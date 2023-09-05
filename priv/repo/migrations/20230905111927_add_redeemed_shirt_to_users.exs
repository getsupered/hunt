defmodule Hunt.Repo.Migrations.AddRedeemedShirtToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :redeemed_shirt_at, :utc_datetime_usec
    end
  end
end
