defmodule HuntWeb.ImageButton do
  use HuntWeb, :html

  attr :text, :string, default: "Upload Screenshot"

  def button(assigns) do
    ~H"""
    <div class="pb-8">
      <%= if @user do %>
        <button class="btn btn-primary btn-big w-full block text-2xl" id="camera-button" phx-hook="CameraButton" data-hunt-id={@hunt.id}>
          <.icon name="hero-camera" class="h-8 w-8 mr-2" /> <%= @text %>
        </button>
      <% else %>
        <.link href={~p"/"} class="btn btn-primary btn-big w-full text-center text-2xl">
          Login to Complete
        </.link>
      <% end %>
    </div>
    """
  end
end
