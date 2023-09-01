defmodule HuntWeb.HomeLive do
  use HuntWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <%= @placeholder %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :placeholder, 1)}
  end
end
