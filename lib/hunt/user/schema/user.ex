defmodule Hunt.User.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime_usec]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string

    timestamps()
  end

  def changeset(attrs) do
    fields = [:email, :first_name, :last_name]

    %__MODULE__{}
    |> cast(attrs, fields)
    |> validate_required([:email])
    |> unique_constraint([:email])
  end
end
