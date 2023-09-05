defmodule HuntWeb.Shirt do
  use HuntWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class={"transition-all z-50 fixed max-w-2xl mx-auto bottom-0 top-32 left-0 right-0 #{if @open, do: "translate-y-0", else: "translate-y-full"}"}>
      <div class="relative h-full bg-white mx-4 rounded-t-xl p-4 overflow-auto dropped-border !border-b-0 flex flex-col">
        <div class="flex items-center mb-4">
          <h2 class="text-2xl font-bold flex-grow">Claim Your Supered Shirt</h2>

          <.link patch={HuntWeb.uri_path(@uri, %{"shirt" => nil})}>
            <.icon name="hero-x-mark" class="h-10 w-10" />
          </.link>
        </div>

        <%= if @user.redeemed_shirt_at do %>
          <div>
            Nice! You got your shirt.
          </div>
        <% else %>
          <%= if @points >= Hunt.Activity.points_for_shirt() do %>
            <div class="space-y-4 text-xl">
              <p>
                <span class="underline">Only click this</span> when you're picking up your shirt! Otherwise, you won't get a shirt.
              </p>

              <%= if @confirm do %>
                <button class="btn btn-primary w-full text-2xl" phx-click="redeem_confirm" phx-target={@myself}>Confirm, you're picking up your shirt now</button>
              <% else %>
                <button class="btn btn-primary w-full text-2xl" phx-click="redeem_1" phx-target={@myself}>Redeem Shirt</button>
              <% end %>
            </div>
          <% else %>
            <div>
              Not quite yet, you need <%= Hunt.Activity.points_for_shirt() %> points. You only have <%= @points %>.
            </div>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(socket) do
    socket = assign(socket, open: false, confirm: false)

    {:ok, socket}
  end

  def update(%{open?: open_param}, socket) do
    open? = open_param == "open"
    {:ok, assign(socket, :open, open?)}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def handle_event("redeem_1", _params, socket) do
    {:noreply, assign(socket, :confirm, true)}
  end

  def handle_event("redeem_confirm", _params, socket = %{assigns: %{user: user}}) do
    socket =
      case Hunt.Activity.redeem_shirt(user) do
        :ok -> push_event(socket, "notification", %{type: "success", text: "Confirmed!"})
        {:error, why} -> push_event(socket, "notification", %{type: "error", text: why})
      end

    send(self(), :reload_user)

    {:noreply, socket}
  end
end
