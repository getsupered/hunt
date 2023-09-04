defmodule HuntWeb.LoggedInForm do
  use HuntWeb, :html

  def wrap(assigns) do
    ~H"""
    <div class="pb-8">
      <%= if @user do %>
        <%= render_slot(@inner_block) %>
      <% else %>
        <.link href={~p"/"} class="btn btn-primary btn-big w-full text-center text-2xl">
          Login to Complete
        </.link>
      <% end %>
    </div>
    """
  end
end
