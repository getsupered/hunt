defmodule HuntWeb.Prizes do
  use HuntWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class={"transition-all z-50 fixed max-w-2xl mx-auto bottom-0 top-32 left-0 right-0 #{if @open, do: "translate-y-0", else: "translate-y-full"}"}>
      <div class="relative h-full bg-white mx-4 rounded-t-xl p-4 overflow-auto dropped-border !border-b-0 flex flex-col">
        <div class="flex items-center mb-4">
          <h2 class="text-2xl font-bold flex-grow">Prizes</h2>

          <.link patch={HuntWeb.uri_path(@uri, %{"prizes" => nil})}>
            <.icon name="hero-x-mark" class="h-10 w-10" />
          </.link>
        </div>

        <ul class="space-y-4 text-lg">
          <li class="border rounded px-4 py-3 border-l-8 border-pink-600">
            <div class="font-bold">1st</div>
            <div class="text-sm">Free Year of Supered (30 Pro Users)<br />Supered Backpack</div>
          </li>

          <li class="border rounded px-4 py-3 border-l-4 border-pink-600">
            <div class="font-bold">2nd</div>
            <div class="text-sm">Free Year of Supered (20 Pro Users)</div>
          </li>

          <li class="border rounded px-4 py-3 border-l-2 border-pink-600">
            <div class="font-bold">3rd</div>
            <div class="text-sm">Free Year of Supered (10 Pro Users)</div>
          </li>

          <li class="border rounded px-4 py-3 border-pink-600">
            <div class="font-bold">4th, 5th, 6th</div>
            <div class="text-sm">Free Year of Supered (5 Pro Users)</div>
          </li>

          <li class="border rounded px-4 py-3 border-pink-600">
            <div class="font-bold">Top 10</div>
            <div class="text-sm">Supered Special Swag (After Conference)</div>
          </li>

          <li class="border rounded px-4 py-3 border-pink-600">
            <div class="font-bold">Top 20</div>
            <div class="text-sm">Extra round of drinks at Sprocketeer Afterparty</div>
          </li>

          <li class="border rounded px-4 py-3 border-pink-600">
            <div class="font-bold">1500 Points</div>
            <div class="text-sm">Enter drawing for Supered backpack (must pick up at INBOUND23)</div>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def mount(socket) do
    socket = assign(socket, open: false)

    {:ok, socket}
  end

  def update(%{open?: open_param}, socket) do
    open? = open_param == "open"
    {:ok, assign(socket, :open, open?)}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
