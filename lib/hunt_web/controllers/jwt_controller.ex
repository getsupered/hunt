defmodule HuntWeb.JwtController do
  defmodule Token do
    use Joken.Config
  end

  use HuntWeb, :controller
  require Logger

  def login(conn, %{"token" => token}) do
    jwt_secret = Application.fetch_env!(:hunt, :supered_jwt_secret)
    signer = Joken.Signer.create("HS256", jwt_secret)

    with {:ok, %{"user" => %{"email" => email, "first_name" => first_name, "last_name" => last_name}}} <-
           Token.verify_and_validate(token, signer),
         {:ok, user} <- Hunt.User.find_or_create_user(auth: %{info: %{email: email, first_name: first_name, last_name: last_name}}) do
      conn
      |> put_flash(:info, "Successfully authenticated")
      |> put_session(:current_user, user)
      |> configure_session(renew: true)
      |> redirect(to: "/")
    else
      err ->
        Logger.error("#{__MODULE__} #{inspect(err)}")

        conn
        |> put_flash(:error, "Unexpected error logging in")
        |> redirect(to: "/")
    end
  end
end
