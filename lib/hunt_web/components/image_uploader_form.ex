defmodule HuntWeb.ImageUploaderForm do
  use HuntWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex-grow">
      <form id="upload-form" phx-submit="save" phx-change="validate" phx-target={@myself}>
        <.live_file_input upload={@uploads.image} class="form-input w-full" />

        <div class="mt-4">
          <button type="submit" phx-disable-with="Uploading..." class="btn btn-primary btn-big w-full block text-2xl">Upload</button>
        </div>
      </form>
    </div>
    """
  end

  def mount(socket) do
    socket =
      socket
      |> assign(:uploaded_files, [])
      |> allow_upload(:image, accept: ~w(.jpg .jpeg .png), max_entries: 1)

    {:ok, socket}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", _params, socket = %{assigns: %{activity_id: activity_id, user: user}}) do
    [result] =
      consume_uploaded_entries(socket, :image, fn %{path: path}, entry ->
        file_data = File.read!(path)
        file_name = entry.client_name

        params = %{
          activity_id: activity_id,
          user_id: user.id,
          image_binary: file_data,
          image_binary_type: Path.extname(file_name),
          image_path: file_name
        }

        {:ok, Hunt.Activity.submit_image(activity_id, params, user: user)}
      end)

    send(self(), {:activity_result, result, "You'll see the points for now, but we'll verify it later"})

    if match?({:ok, _}, result) do
      send_update(HuntWeb.ImageUploader, id: "image_uploader", open: false)
    end

    {:noreply, assign(socket, :uploaded_files, [])}
  end
end
