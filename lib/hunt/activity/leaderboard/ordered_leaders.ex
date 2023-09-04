defmodule Hunt.Activity.Leaderboard.OrderedLeaders do
  def from_ets(ets \\ :leaderboard) do
    [ordered_leaderboard: board] = :ets.lookup(ets, :ordered_leaderboard)
    board
  end

  def update_from_leaderboard_state(%{scores_by_user: user_map, ets: ets}) do
    leaderboard =
      user_map
      |> Enum.map(fn {_user_id, summary} ->
        %{
          points: summary.points,
          user_id: summary.user.id,
          user_name: user_name(summary.user)
        }
      end)
      |> Enum.sort_by(& {&1.points, &1.user_name})
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.map(fn {m, idx} -> Map.put(m, :place, idx + 1) end)

    :ets.insert(ets, {:ordered_leaderboard, leaderboard})
  end

  defp user_name(user) do
    domain = String.split(user.email, "@") |> List.last()

    name =
      [
        user.first_name,
        user.last_name
      ]
      |> Enum.reject(& &1 == nil || &1 == "")
      |> Enum.join(" ")

    case name do
      "" -> "INBOUNDer @ #{domain}"
      name -> name
    end
  end
end
