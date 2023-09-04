defmodule HuntWeb.ImageUploaderForm do
  use HuntWeb, :live_component

  def render(assigns) do
    ~H"""
    <form id="upload-form" phx-submit="save" phx-change="validate" phx-target={@myself}>
      <.live_file_input upload={@uploads.image} />
      <button type="submit">Upload</button>
    </form>
    """
  end

  def mount(socket) do
    socket =
      socket
      |> assign(:uploaded_files, [])
      |> allow_upload(:image, accept: ~w(.jpg .jpeg), max_entries: 1)

    {:ok, socket}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", _params, socket = %{assigns: %{user: user}}) do
    uploaded_files =
      consume_uploaded_entries(socket, :image, fn %{path: path}, entry ->
        file_data = File.read!(path)
        file_name = entry.client_name

        %{
          activity_id: Ecto.UUID.generate(),
          user_id: user.id,
          image_binary: file_data,
          image_binary_type: Path.extname(file_name),
          image_path: file_name
        }
        |> Hunt.Activity.Schema.ImageUpload.changeset()
        |> Hunt.Repo.insert()
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  end
end
