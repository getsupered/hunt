defmodule Hunt.Activity do
  import Ecto.Query

  alias Hunt.Repo
  alias Hunt.Activity.Schema.CompletedActivity

  @system_uuid "00000000-0000-0000-0000-000000000000"

  @activity_modules [
    Hunt.Activity.Lounge,
    Hunt.Activity.Attend,
    Hunt.Activity.Social,
    Hunt.Activity.Selfie1,
    Hunt.Activity.Selfie2,
    Hunt.Activity.Selfie3,
    Hunt.Activity.Fun,
    Hunt.Activity.Hubolution,
    Hunt.Activity.Supered
  ]

  def activity_modules, do: @activity_modules
  def activities, do: Enum.flat_map(@activity_modules, & &1.activities())

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

  defp find_activity(id) do
    Enum.find(activities(), &(&1.id == id))
  end

  defp create_activity_completion(activity, user, state, metadata) when state in [:pending, :approved] do
    params = maybe_merge_state_params(%{
      activity_id: activity.id,
      user_id: user.id,
      approval_state: state,
      metadata: metadata
    }, state)

    params
    |> CompletedActivity.changeset()
    |> Repo.insert(
      returning: true,
      stale_error_field: :activity_id,
      stale_error_message: "has already been approved",
      conflict_target: [:user_id, :activity_id],
      on_conflict: (
        from c in CompletedActivity,
        where: c.approval_state in [:pending, :rejected],
        update: [
          set: ^Enum.into(params, [])
        ]
      )
    )
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
end
