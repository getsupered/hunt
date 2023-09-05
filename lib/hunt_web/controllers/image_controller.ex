defmodule HuntWeb.ImageController do
  use HuntWeb, :controller

  def serve(conn, %{"id" => image_id}) do
    case load_user(conn) do
      %{admin: true} ->
        image = Hunt.Repo.get!(Hunt.Activity.Schema.ImageUpload, image_id)

        conn
        # hard-coded type, needs changed for different image types
        |> put_resp_content_type("image/jpeg", "utf-8")
        |> send_resp(200, image.image_binary)

      nil ->
        redirect(conn, to: "/")
    end
  end

  defp load_user(conn) do
    case get_session(conn) do
      %{"current_user" => %{id: user_id}} -> Hunt.User.get_user(user_id)
      _ -> nil
    end
  end
end
