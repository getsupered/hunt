defmodule Hunt.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:image_uploads, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :binary_id, null: false
      add :activity_id, :binary_id, null: false

      add :image_binary, :binary, null: false
      add :image_path, :text, null: false
      add :image_binary_type, :text, null: false

      timestamps()
    end
  end
end
