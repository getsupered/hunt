defmodule Hunt.Activity do
  import Ecto.Query

  alias Hunt.Repo
  alias Hunt.Activity.Schema.CompletedActivity

  @system_uuid "00000000-0000-0000-0000-000000000000"

  @activity_modules [
    Hunt.Activity.Supered,
    Hunt.Activity.Social,
    Hunt.Activity.Lounge,
    Hunt.Activity.Attend,
    Hunt.Activity.Hubolution,
    Hunt.Activity.Selfie1,
    Hunt.Activity.Selfie2,
    Hunt.Activity.Selfie3,
    Hunt.Activity.Fun
  ]

  @activities Enum.flat_map(@activity_modules, fn mod ->
                Enum.map(mod.activities(), fn activity ->
                  case activity.completion do
                    %Hunt.Activity.Completion.Answer{} -> nil
                    :qr_code -> nil
                    :image -> nil
                  end

                  Map.put(activity, :module, mod)
                end)
              end)

  @qrcodes Enum.flat_map(Enum.with_index(@activity_modules), fn {mod, idx} ->
             Enum.map(mod.activities(), fn activity ->
               if activity.completion == :qr_code do
                 feature = idx + 1
                 svg_settings = %QRCode.Render.SvgSettings{image: {"priv/static/images/supered_svg_logo.svg", 200}}

                 {:ok, qr_svg} =
                   "https://hunt.supered.io/hunt/#{activity.id}?feature=#{feature}&code=#{:erlang.phash2(activity.id)}"
                   |> QRCode.create(:high)
                   |> QRCode.render(:svg, svg_settings)

                 {activity.id, qr_svg}
               end
             end)
           end)
           |> Enum.reject(&is_nil/1)
           |> Map.new()

  def activity_modules, do: @activity_modules
  def activities, do: @activities

  def points_for_shirt do
    1000
  end

  def redeem_shirt(user) do
    user = Hunt.User.get_user(user.id)
    summary = completion_summary(user: user)
    points = total_points(summary)

    cond do
      user.redeemed_shirt_at ->
        {:error, "Already redeemed"}

      points < points_for_shirt() ->
        {:error, "Not enough points"}

      true ->
        Ecto.Changeset.change(user, redeemed_shirt_at: DateTime.utc_now()) |> Repo.update!()
        :ok
    end
  end

  def qr_code(activity, :svg) do
    Map.fetch!(@qrcodes, activity.id)
  end

  def qr_code(activity, :base64) do
    {:ok, base64} = QRCode.to_base64({:ok, Map.fetch!(@qrcodes, activity.id)})
    "data:image/svg+xml; base64, " <> base64
  end

  def completion_summary(user: user) do
    activities = completed_activities(user: user) |> Enum.group_by(& &1.activity_module)

    Enum.map(activity_modules(), fn mod ->
      mod_activities = Map.get(activities, mod, [])
      mod_activity_count = length(mod.activities())

      pointed_activities = Enum.filter(mod_activities, &(&1.approval_state in [:pending, :approved]))
      pointed_activities_count = length(pointed_activities)

      achievement? = mod_activity_count == pointed_activities_count
      points = Enum.map(pointed_activities, & &1.activity_points) |> Enum.sum()
      points = if achievement?, do: mod.achievement().points + points, else: points

      completion = %{
        ids: Enum.map(pointed_activities, & &1.activity_id),
        achievement: achievement?,
        count: if(achievement?, do: pointed_activities_count + 1, else: pointed_activities_count),
        activity_count: pointed_activities_count,
        points: points
      }

      {mod, completion}
    end)
    |> Map.new()
  end

  def total_points(summary) do
    summary
    |> Map.values()
    |> Enum.map(& &1.points)
    |> Enum.sum()
  end

  def completed_activities(user: nil), do: []

  def completed_activities(user: user) do
    from(
      c in CompletedActivity,
      where: c.user_id == ^user.id
    )
    |> Repo.all()
    |> Enum.map(fn completion ->
      case find_activity(completion.activity_id) do
        nil -> nil
        act -> %{completion | activity_module: act.module, activity_points: act.points}
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  def submit_answer(_params, user: nil) do
    {:error, "Must log in first"}
  end

  def submit_answer(params, user: user) do
    id = params["activity_id"]

    case find_activity(id) do
      nil ->
        {:error, "Error submitting hunt: missing #{id}"}

      act = %{completion: completion = %{__struct__: mod}} ->
        case mod.verify(completion, params) do
          true ->
            create_activity_completion(act, user, :approved, params)

          false ->
            {:error, "Wrong answer, give it another try"}
        end
    end
  end

  def submit_qr_code(_id, _code, user: nil) do
    {:error, "Must log in first"}
  end

  def submit_qr_code(id, code, user: user) do
    case find_activity(id) do
      nil ->
        {:error, "Error completing hunt: missing #{id}"}

      act = %{completion: :qr_code} ->
        if to_string(:erlang.phash2(act.id)) == to_string(code) do
          create_activity_completion(act, user, :approved, %{})
        else
          {:error, "Error completing hunt: invalid code"}
        end
    end
  end

  def submit_image(_id, _upload_params, user: nil) do
    {:error, "Must log in first"}
  end

  def submit_image(id, upload_params, user: user) do
    case find_activity(id) do
      nil ->
        {:error, "Error completing hunt: missing #{id}"}

      act = %{completion: :image} ->
        Repo.transaction(fn ->
          with {:ok, hunt} <- create_activity_completion(act, user, :pending, %{}),
               {:ok, upload} <- create_image_upload(upload_params),
               {:ok, hunt} <- Ecto.Changeset.change(hunt, image_upload_id: upload.id) |> Repo.update() do
            hunt
          else
            {:error, cs} -> Repo.rollback(cs)
          end
        end)
    end
  end

  def find_activity(id) do
    Enum.find(activities(), &(&1.id == id))
  end

  defp create_activity_completion(activity, user, state, metadata) when state in [:pending, :approved] do
    params =
      maybe_merge_state_params(
        %{
          activity_id: activity.id,
          user_id: user.id,
          approval_state: state,
          metadata: metadata
        },
        state
      )

    params
    |> CompletedActivity.changeset()
    |> Repo.insert(
      returning: true,
      stale_error_field: :activity_id,
      stale_error_message: "has already been approved",
      conflict_target: [:user_id, :activity_id],
      on_conflict:
        from(c in CompletedActivity,
          where: c.approval_state in [:pending, :rejected],
          update: [
            set: ^Enum.into(params, [])
          ]
        )
    )
  end

  defp create_image_upload(params) do
    params
    |> Hunt.Activity.Schema.ImageUpload.changeset()
    |> Hunt.Repo.insert()
  end

  def approve_answer(completed_activity, by_user: user) do
    completed_activity
    |> Ecto.Changeset.change(approval_state: :approved, approval_updated_at: DateTime.utc_now(), approval_by_id: user.id)
    |> Repo.update()
  end

  def reject_answer(completed_activity, by_user: user) do
    completed_activity
    |> Ecto.Changeset.change(approval_state: :rejected, approval_updated_at: DateTime.utc_now(), approval_by_id: user.id)
    |> Repo.update()
  end

  defp maybe_merge_state_params(params, state) do
    case state do
      :approved -> Map.merge(params, %{approval_updated_at: DateTime.utc_now(), approval_by_id: @system_uuid})
      _ -> params
    end
  end

  def pending_activity_count do
    from(
      c in CompletedActivity,
      where: c.approval_state == :pending
    )
    |> Repo.aggregate(:count)
  end

  def pending_activities do
    from(
      c in CompletedActivity,
      where: c.approval_state == :pending,
      preload: [:user],
      limit: 1,
      order_by: [
        asc: c.inserted_at
      ]
    )
    |> Repo.all()
    |> Enum.map(fn pending ->
      activity = Enum.find(activities(), &(&1.id == pending.activity_id))
      %{pending | activity: activity}
    end)
  end

  @svg_settings %QRCode.Render.SvgSettings{image: {"priv/static/images/supered_svg_logo.svg", 100}}
  @base64_qr "https://hunt.supered.io"
    |> QRCode.create(:high)
    |> QRCode.render(:svg, @svg_settings)
    |> QRCode.to_base64()

  def hunt_qr do
    {:ok, base64} = @base64_qr
    "data:image/svg+xml; base64, " <> base64
  end
end
