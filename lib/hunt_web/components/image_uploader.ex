defmodule HuntWeb.ImageUploader do
  use HuntWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="camera-upload" phx-hook="CameraUploader">
      <div class={"transition-all z-50 fixed max-w-2xl mx-auto bottom-0 top-32 left-0 right-0 #{if @open, do: "translate-y-0", else: "translate-y-full"}"}>
        <div class="relative h-full bg-white mx-4 rounded-t-xl p-4 overflow-auto dropped-border !border-b-0">
          <div class="flex items-center mb-4">
            <h2 class="text-2xl font-bold flex-grow">Photo Upload</h2>

            <button id="camera-upload--cancel" phx-click="closeUploader" phx-target={@myself}>
              <.icon name="hero-x-mark" class="h-10 w-10" />
            </button>
          </div>

          <div class="p-4">
            <HuntWeb.LoggedInForm.wrap {assigns}>
              <.live_component :if={@open} id="image_uploader_form" module={HuntWeb.ImageUploaderForm} user={@user} />
            </HuntWeb.LoggedInForm.wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, :open, false)}
  end

  def handle_event("openUploader", _, socket) do
    {:noreply, assign(socket, :open, true)}
  end

  def handle_event("closeUploader", _, socket) do
    {:noreply, assign(socket, :open, false)}
  end
end
