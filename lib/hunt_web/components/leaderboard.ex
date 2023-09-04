defmodule HuntWeb.Leaderboard do
  use HuntWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class={"transition-all z-50 fixed max-w-2xl mx-auto bottom-0 top-32 left-0 right-0 #{if @open, do: "translate-y-0", else: "translate-y-full"}"}>
      <div class="relative h-full bg-white mx-4 rounded-t-xl p-4 overflow-auto dropped-border !border-b-0 flex flex-col">
        <div class="flex items-center mb-4">
          <h2 class="text-2xl font-bold flex-grow">Leaderboard</h2>

          <.link patch={HuntWeb.uri_path(@uri, %{"leaderboard" => nil})}>
            <.icon name="hero-x-mark" class="h-10 w-10" />
          </.link>
        </div>

        <ul :if={@leaderboard} class="flex-grow space-y-4">
          <li
            :for={entry <- @leaderboard}
            class={"border rounded px-4 py-3 flex items-center gap-4 text-xl #{if @user && entry.user_id == @user.id, do: "border-2 border-l-8 border-pink-600"}"}
          >
            <div class="flex-grow break-all line-clamp-1">
              <span class="font-bold"><%= entry.place %>.</span>
              <span class="ml-2"><%= entry.user_name %></span>
            </div>

            <div class="flex-none">
              <span class="text-sm"><%= entry.points %> pts</span>
            </div>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def mount(socket) do
    socket = assign(socket, open: false, leaderboard: nil)

    {:ok, socket}
  end

  def update(%{open?: open_param}, socket = %{assigns: %{user: user}}) do
    open? = open_param == "open"

    socket =
      if open? do
        assign(socket, :leaderboard, Hunt.Activity.Leaderboard.ordered_leaderboard(user: user))
      else
        assign(socket, :leaderboard, nil)
      end

    {:ok, assign(socket, :open, open?)}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
