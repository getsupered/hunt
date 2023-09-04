defmodule HuntWeb.Header do
  use HuntWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="bg-pink-600 pb-40 sm:rounded-t-lg">
      <header class="px-6 py-8">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div class="flex items-center gap-6">
            <.link patch={~p"/"} class="no-flex">
              <img src={~p"/images/supered_white.svg"} class="w-28" />
            </.link>

            <h1 class="text-white text-3xl font-black flex-grow text-right tracking-tight leading-8">
              INBOUND23<br />Scavenger Hunt
            </h1>
          </div>
        </div>
      </header>
    </div>
    """
  end
end
