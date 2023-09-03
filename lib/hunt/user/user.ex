defmodule Hunt.User do
  alias Hunt.Repo
  alias Hunt.User.Schema

  def find_or_create_user(auth: %{info: %{email: email}}) when is_binary(email) do
    case Repo.get_by(Schema.User, email: email) do
      nil -> create_user(email)
      ret -> {:ok, ret}
    end
  end

  def find_or_create_user(auth: _), do: {:error, "Invalid authentication"}

  def get_user(id) do
    Repo.get(Schema.User, id)
  end

  defp create_user(email) do
    %{email: email}
    |> Schema.User.changeset()
    |> Repo.insert()
  end
end
