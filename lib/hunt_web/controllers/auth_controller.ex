defmodule HuntWeb.AuthController do
  use HuntWeb, :controller

  plug HuntWeb.Ueberauth

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Hunt.User.find_or_create_user(auth: auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated")
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def mock_login(conn, _params) do
    {:ok, user} = Hunt.User.find_or_create_user(auth: %{info: %{email: "test@tester.com", first_name: "Test", last_name: "Testerson"}})

    conn
    |> put_flash(:info, "Successfully authenticated")
    |> put_session(:current_user, user)
    |> configure_session(renew: true)
    |> redirect(to: "/")
  end
end
