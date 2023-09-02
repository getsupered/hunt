defmodule HuntWeb.HomeLive do
  use HuntWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="h-full max-w-2xl mx-auto sm:py-4 ">
      <div class="relative h-full sm:shadow sm:rounded-lg sm:overflow-auto">
        <div class="bg-pink-600 pb-40 sm:rounded-t-lg">
          <header class="px-6 py-8">
            <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
              <div class="flex items-center gap-8">
                <.link patch={~p"/"}>
                  <img src={~p"/images/supered_white.svg"} class="w-24" />
                </.link>

                <h1 class="text-white text-2xl font-black flex-grow text-right">
                  Supered Dupered<br />Challenge
                </h1>
              </div>
            </div>
          </header>
        </div>

        <main class="-mt-40">
          <.live_component
            module={HuntWeb.HuntCarousel}
            id="carousel"
            active_slide_index={@active_slide_index}
            hunt_mods={@hunt_mods}
            completion={@completion}
          />
        </main>

        <div class={"z-10 fixed max-w-2xl mx-auto bottom-0 top-40 left-0 right-0 transition-all #{if @hunt, do: "translate-y-0", else: "translate-y-full"}"}>
          <div class="relative h-full bg-white mx-4 rounded-t-xl p-4 overflow-auto dropped-border !border-b-0">
            <%= if @hunt do %>
              <div class="absolute right-4 top-4">
                <.link patch={~p"/"} class="touch-manipulation">
                  <.icon name="hero-x-mark" class="h-10 w-10" />
                </.link>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(params, _session, socket) do
    socket =
      socket
      # Do not reassign on change, or it forces an unnecessary update
      |> assign(:active_slide_index, params["feature"] || "0")
      |> assign(:hunt_mods, [Hunt.Activity.Lounge, Hunt.Activity.Attend])
      |> assign(:completion, %{
        Hunt.Activity.Lounge => %{
          ids: ["c44c98a2-2256-493c-9453-3db795693f0c"],
          achievement: false,
          count: 1,
          activity_count: 1,
          points: 50
        },
        Hunt.Activity.Attend => %{
          ids: [],
          achievement: false,
          count: 0,
          activity_count: 0,
          points: 0
        }
      })

    {:ok, socket}
  end

  def handle_params(params, uri, socket = %{assigns: %{hunt_mods: hunt_mods}}) do
    socket =
      socket
      |> assign(:uri, URI.parse(uri))
      |> assign(:hunt, get_hunt(params["hunt_id"], hunt_mods))

    {:noreply, socket}
  end

  def handle_event("slide.active", %{"index" => idx}, socket = %{assigns: %{uri: uri}}) do
    socket =
      socket
      |> push_patch(to: HuntWeb.uri_path(uri, %{"feature" => idx}))

    {:noreply, socket}
  end

  defp get_hunt(id, hunt_mods) do
    Enum.find_value(hunt_mods, fn hunt_mod ->
      Enum.find(hunt_mod.activities(), &(&1.id == id))
    end)
  end
end
