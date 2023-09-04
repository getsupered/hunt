defmodule Hunt.Activity.Schema.CompletedActivity do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime_usec]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "completed_activities" do
    belongs_to :user, Hunt.User.Schema.User
    field :activity_id, Ecto.UUID

    field :approval_state, Ecto.Enum, values: [:pending, :approved, :rejected]
    field :approval_updated_at, :utc_datetime_usec
    belongs_to :approval_by, Hunt.User.Schema.User

    field :metadata, :map
    belongs_to :image_upload, Hunt.Activity.Schema.ImageUpload

    field :activity_module, :any, virtual: true
    field :activity_points, :integer, virtual: true, default: 0

    timestamps()
  end

  def changeset(attrs) do
    fields = [
      :user_id,
      :activity_id,
      :approval_state,
      :approval_updated_at,
      :approval_by_id,
      :metadata
    ]

    %__MODULE__{}
    |> cast(attrs, fields)
    |> validate_required(fields -- [:approval_by_id, :approval_updated_at, :metadata])
    |> unique_constraint([:user_id, :activity_id])
  end
end
