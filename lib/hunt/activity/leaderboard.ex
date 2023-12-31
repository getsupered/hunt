defmodule Hunt.Activity.Leaderboard do
  use GenServer
  require Logger

  import Ecto.Query
  alias Hunt.Repo

  @initial_score_by_user %{
    achievements: [],
    completed_ids: MapSet.new(),
    points: 0,
    user: nil
  }

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  def ordered_leaderboard(user: user) do
    Hunt.Activity.Leaderboard.OrderedLeaders.from_ets()
    |> Enum.filter(fn entry ->
      (entry.place <= 20 && entry.points > 0) || (user && entry.user_id == user.id)
    end)
  end

  def update_user(summary, user, server \\ __MODULE__) do
    GenServer.call(server, {:update_user, summary, user})
  end

  def init(opts) do
    ets_opts =
      if Keyword.get(opts, :named_table?, true) do
        [:named_table, :protected, :set]
      else
        [:protected, :set]
      end

    ets = :ets.new(:leaderboard, ets_opts)

    :ok = :pg.join(__MODULE__, self())

    {:ok, %{scores_by_user: %{}, ets: ets}, {:continue, :load_initial}}
  end

  def handle_continue(:load_initial, state) do
    state = load_pointed_completions(state)
    Hunt.Activity.Leaderboard.OrderedLeaders.update_from_leaderboard_state(state)

    {:noreply, state}
  end

  def handle_info({:update_user, summary, user}, state) do
    Logger.info("#{__MODULE__} update user_id=#{user.id}")

    completed_ids = Map.values(summary) |> Enum.flat_map(& &1.ids)

    achievements =
      summary
      |> Enum.map(fn {mod, %{achievement: achieved?}} ->
        if achieved?, do: mod.achievement()
      end)
      |> Enum.reject(&is_nil/1)

    new_score = %{
      achievements: achievements,
      completed_ids: MapSet.new(completed_ids),
      points: Hunt.Activity.total_points(summary),
      user: user
    }

    new_scores_by_user = Map.put(state.scores_by_user, user.id, new_score)
    state = %{state | scores_by_user: new_scores_by_user}
    Hunt.Activity.Leaderboard.OrderedLeaders.update_from_leaderboard_state(state)

    {:noreply, state}
  end

  def handle_call({:update_user, summary, user}, _from, state) do
    {:noreply, state} = handle_info({:update_user, summary, user}, state)

    on_remotes(fn pid ->
      send(pid, {:update_user, summary, user})
    end)

    {:reply, :ok, state}
  end

  defp load_pointed_completions(state) do
    activities_by_id = Hunt.Activity.activities() |> Map.new(&{&1.id, &1})

    stream =
      from(
        c in Hunt.Activity.Schema.CompletedActivity,
        where: c.approval_state in [:pending, :approved]
      )
      |> Repo.stream(max_rows: 200)

    {:ok, state} =
      Repo.transaction(fn ->
        stream
        |> Stream.chunk_every(200)
        |> Enum.reduce(state, fn completions, state ->
          completions = Repo.preload(completions, [:user])

          Enum.reduce(completions, state, fn completion, state ->
            case activities_by_id[completion.activity_id] do
              nil ->
                state

              act ->
                existing = state.scores_by_user[completion.user_id] || @initial_score_by_user

                new_score =
                  Map.merge(existing, %{
                    completed_ids: MapSet.put(existing.completed_ids, act.id),
                    points: existing.points + act.points,
                    user: completion.user
                  })

                new_scores_by_user = Map.put(state.scores_by_user, completion.user_id, new_score)

                %{state | scores_by_user: new_scores_by_user}
            end
          end)
        end)
      end)

    compute_achievements(state)
  end

  defp compute_achievements(state) do
    achievements =
      Enum.map(Hunt.Activity.activity_modules(), fn mod ->
        ids = Enum.map(mod.activities(), & &1.id)
        {MapSet.new(ids), mod.achievement()}
      end)

    new_scores_by_user =
      Map.new(state.scores_by_user, fn {user_id, user_score} ->
        achievements =
          achievements
          |> Enum.filter(fn {required_ids, _achievement} ->
            MapSet.intersection(required_ids, user_score.completed_ids) == required_ids
          end)
          |> Enum.map(&elem(&1, 1))

        ach_points = achievements |> Enum.map(& &1.points) |> Enum.sum()

        user_score = %{
          user_score
          | achievements: achievements,
            points: user_score.points + ach_points
        }

        {user_id, user_score}
      end)

    %{state | scores_by_user: new_scores_by_user}
  end

  defp on_remotes(func) do
    __MODULE__
    |> :pg.get_members()
    |> Kernel.--(:pg.get_local_members(__MODULE__))
    |> Enum.each(func)
  end
end
