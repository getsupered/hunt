# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
defmodule Seed do
  def setup_random_completions(users: users) do
    num_completions = length(users) * 15
    activity_ids = Hunt.Activity.activities() |> Enum.map(& &1.id)
    user_ids = Enum.map(users, & &1.id)

    for _ <- 1..num_completions, reduce: [] do
      acc ->
        user = Enum.random(user_ids)
        activity = Enum.random(activity_ids)

        if {user, activity} in acc do
          acc
        else
          create_fake_completion(user, activity)
          [{user, activity} | acc]
        end
    end

    user_ids
  end

  defp create_fake_completion(user_id, activity_id) do
    %{
      activity_id: activity_id,
      user_id: user_id,
      approval_state: Enum.random([:pending, :approved, :rejected])
    }
    |> Hunt.Activity.Schema.CompletedActivity.changeset()
    |> Hunt.Repo.insert()
  end
end

random_users =
  for _ <- 1..100 do
    {:ok, user} =
      Hunt.User.find_or_create_user(
        auth: %{
          info: %{
            email: Ecto.UUID.generate() <> "@supered.io",
            first_name: Faker.Name.first_name(),
            last_name: Faker.Name.last_name()
          }
        }
      )

    user
  end

Seed.setup_random_completions(users: random_users)
