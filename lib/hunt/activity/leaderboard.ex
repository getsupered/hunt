defmodule Hunt.Activity.Leaderboard do
  use GenServer

  import Ecto.Query
  alias Hunt.Repo

  @initial_score_by_user %{
    achievements: [],
    completed_ids: MapSet.new(),
    points: 0
  }

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, [], name: name)
  end

  def update_user(summary, user_id, server \\ __MODULE__) do
    GenServer.call(server, {:update_user, summary, user_id})
  end

  def init(_opts) do
    {:ok, %{scores_by_user: %{}}, {:continue, :load_initial}}
  end

  def handle_continue(:load_initial, state) do
    {:noreply, load_pointed_completions(state)}
  end

  def handle_call({:update_user, summary, user_id}, _from, state) do
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
      points: Hunt.Activity.total_points(summary)
    }

    new_scores_by_user = Map.put(state.scores_by_user, user_id, new_score)
    state = %{state | scores_by_user: new_scores_by_user}

    {:reply, :ok, state}
  end

  defp load_pointed_completions(state) do
    activities_by_id = Hunt.Activity.activities() |> Map.new(&{&1.id, &1})

    stream =
      from(
        c in Hunt.Activity.Schema.CompletedActivity,
        where: c.approval_state in [:pending, :approved]
      )
      |> Repo.stream(max_rows: 100)

    {:ok, state} =
      Repo.transaction(fn ->
        Enum.reduce(stream, state, fn completion, state ->
          case activities_by_id[completion.activity_id] do
            nil ->
              state

            act ->
              existing = state.scores_by_user[completion.user_id] || @initial_score_by_user

              new_score =
                Map.merge(existing, %{
                  completed_ids: MapSet.put(existing.completed_ids, act.id),
                  points: existing.points + act.points
                })

              new_scores_by_user = Map.put(state.scores_by_user, completion.user_id, new_score)

              %{state | scores_by_user: new_scores_by_user}
          end
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
end
