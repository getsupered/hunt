defmodule Hunt.Activity.Schema.ImageUpload do
  @moduledoc """
  https://medium.com/@paulfedory/how-and-why-to-store-images-in-your-database-with-elixir-eb80133eb945

  No value in storing in S3 for this one-off app. Keeping it in postgres
  """

  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime_usec]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "image_uploads" do
    belongs_to :user, Hunt.User.Schema.User
    field :activity_id, Ecto.UUID

    field :image_binary, :binary
    field :image_path, :string
    field :image_binary_type, :string

    timestamps()
  end

  def changeset(attrs) do
    fields = [
      :user_id,
      :activity_id,
      :image_binary,
      :image_binary_type,
      :image_path
    ]

    %__MODULE__{}
    |> cast(attrs, fields)
    |> validate_required(fields)
  end
end
