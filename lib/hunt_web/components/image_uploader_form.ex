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

  def handle_event("save", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :image, fn %{path: path}, entry ->
        dest = Path.join([:code.priv_dir(:hunt), "static", "uploads", Path.basename(path) <> Path.extname(entry.client_name)])
        # The `static/uploads` directory must exist for `File.cp!/2`
        # and MyAppWeb.static_paths/0 should contain uploads to work,.
        File.cp!(path, dest)
        {:ok, "/uploads/#{Path.basename(dest)}"}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  end
end
