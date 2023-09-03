defmodule Hunt.User.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime_usec]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "users" do
    field :email, :string

    timestamps()
  end

  def changeset(attrs) do
    fields = [:email]

    %__MODULE__{}
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> unique_constraint([:email])
  end
end
