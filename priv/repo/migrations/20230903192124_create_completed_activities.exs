defmodule Hunt.Repo.Migrations.CreateCompletedActivities do
  use Ecto.Migration

  def change do
    create table(:completed_activities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :binary_id, null: false
      add :activity_id, :binary_id, null: false

      add :approval_state, :text, null: false
      add :approval_updated_at, :utc_datetime_usec
      add :approval_by_id, :binary_id

      timestamps()
    end

    create unique_index(:completed_activities, [:user_id, :activity_id], where: "approval_state != 'cancelled'")
  end
end
