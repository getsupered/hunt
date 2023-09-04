defmodule Hunt.Repo.Migrations.AddImageUploadToCompletedActivity do
  use Ecto.Migration

  def change do
    alter table(:completed_activities) do
      add :image_upload_id, :binary_id
    end
  end
end
