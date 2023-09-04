defmodule Hunt.Activity.LeaderboardTest do
  use Hunt.DataCase, async: false

  alias Hunt.Activity.Leaderboard

  test "a bunch of completed activities will fill in the leaderboard properly" do
    setup_random_completions(max_users: 1000)

    {:ok, pid} = Leaderboard.start_link(name: nil, named_table?: false)
    verify_state(pid)
  end

  test "the user completion can be updated" do
    setup_random_completions(max_users: 5)
    {:ok, pid} = Leaderboard.start_link(name: nil, named_table?: false)

    users = setup_random_completions(max_users: 5)

    for user <- users do
      summary = Hunt.Activity.completion_summary(user: user)
      assert Leaderboard.update_user(summary, user, pid) == :ok
    end

    verify_state(pid)
  end

  defp setup_random_completions(max_users: max_users) do
    num_users = Enum.random(1..max_users)
    num_completions = num_users * 15

    activity_ids = Hunt.Activity.activities() |> Enum.map(& &1.id)

    users =
      for _ <- 1..num_users do
        {:ok, user} = Hunt.User.create_user(Ecto.UUID.generate(), Faker.Person.first_name(), Faker.Person.last_name())
        user
      end

    for _ <- 1..num_completions, reduce: [] do
      acc ->
        user = Enum.random(users)
        activity = Enum.random(activity_ids)

        if {user, activity} in acc do
          acc
        else
          create_fake_completion(user.id, activity)
          [{user.id, activity} | acc]
        end
    end

    users
  end

  defp verify_state(pid) do
    %{scores_by_user: scores_by_user, ets: ets} = :sys.get_state(pid)

    users_with_completions =
      Repo.all(
        from c in Hunt.Activity.Schema.CompletedActivity,
          where: c.approval_state in [:pending, :approved],
          distinct: c.user_id,
          select: c.user_id
      )

    assert map_size(scores_by_user) == length(users_with_completions)

    for {user_id, score} <- scores_by_user do
      completion_summary = Hunt.Activity.completion_summary(user: %{id: user_id})
      computed_points = Hunt.Activity.total_points(completion_summary)
      completed_ids = Enum.flat_map(completion_summary, fn {_mod, %{ids: ids}} -> ids end)

      assert %Hunt.User.Schema.User{} = score.user
      assert score.points == computed_points
      assert Enum.sort(score.completed_ids) == Enum.sort(completed_ids)
    end

    leaderboard = Hunt.Activity.Leaderboard.OrderedLeaders.from_ets(ets)

    for entry <- leaderboard, reduce: %{points: 100_000} do
      prev ->
        assert entry.points <= prev.points
        assert entry.user_id
        assert entry.user_name
        entry
    end
  end

  defp create_fake_completion(user_id, activity_id) do
    %{
      activity_id: activity_id,
      user_id: user_id,
      approval_state: Enum.random([:pending, :approved, :rejected])
    }
    |> Hunt.Activity.Schema.CompletedActivity.changeset()
    |> Repo.insert()
  end
end
