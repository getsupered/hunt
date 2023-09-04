defmodule HuntWeb.QrCodeButton do
  use HuntWeb, :html

  def button(assigns) do
    ~H"""
    <div class="pb-8">
      <%= if @user do %>
        <button class="btn btn-primary btn-big w-full block text-2xl" id="scan-button" phx-hook="QRScanButton">
          <.icon name="hero-qr-code" class="h-8 w-8 mr-2" /> Scan QR Code
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
