defmodule HuntWeb.HomeLive do
  use HuntWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="min-h-full h-full max-w-2xl mx-auto sm:py-4">
      <div class="h-full sm:shadow sm:rounded-lg sm:overflow-auto">
        <div class="bg-pink-600 pb-32 sm:rounded-lg">
          <header class="px-6 py-8">
            <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
              <div class="flex items-center gap-8">
                <img src={~p"/images/supered_white.svg"} class="w-24" />
                <h1 class="text-white text-2xl font-black flex-grow text-right">
                  Supered Dupered<br />Challenge
                </h1>
              </div>
            </div>
          </header>
        </div>

        <main class="-mt-32">
          <div class="mx-auto max-w-7xl px-4 pb-12 sm:px-6 lg:px-8">
            <div id="image-carousel" phx-hook="ImageCarousel">
              <section class="splide" data-start-index={@active_slide_index}>
                <ul class="splide__pagination"></ul>

                <div class="splide__track">
                  <ul class="splide__list">
                    <li :for={slide <- @slides} class="splide__slide">
                      <div class="mx-4 mb-8 rounded-lg bg-white dropped-border overflow-hidden">
                        <img src={slide.image().src} class={"w-full max-h-[30vh] object-cover #{slide.image().class}"} />
                        <div class="px-3 py-2">
                          <div class="flex items-baseline">
                            <h2 class="font-semibold flex-grow"><%= slide.title() %></h2>
                            <div class="text-right">
                              <div class="text-sm font-light">
                                <%= @completion[slide].points %> / <%= slide.total_points() %> pts
                              </div>

                              <div class="text-sm font-light">
                                <%= @completion[slide].count %> / <%= length(slide.activities()) + 1 %> completed
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>

                      <ul class="mx-4 my-4 space-y-4">
                        <li class="rounded px-4 py-3 dropped-border-sm flex items-start">
                          <div class="flex-grow flex items-center">
                            <%= if @completion[slide].achievement do %>
                              <div class="rounded-full flex-none bg-pink-50 h-12 w-12 flex items-center justify-center mr-4">
                                <.icon name="hero-trophy" class="h-6 w-6 text-pink-600" />
                              </div>
                            <% else %>
                              <div class="rounded-full flex-none bg-beanie-gold-100 h-12 w-12 flex items-center justify-center mr-4">
                                <.icon name="hero-lock-closed" class="h-6 w-6 text-beanie-gold-900" />
                              </div>
                            <% end %>

                            <div>
                              <div class="text-xl font-bold">
                                <%= slide.achievement().title %>
                              </div>

                              <div class="text-sm font-light">
                                <%= @completion[slide].activity_count %> / <%= length(slide.activities()) %> Hunts Complete
                              </div>
                            </div>
                          </div>

                          <div>
                            <div class="text-lg"><%= slide.achievement().points %>pts</div>
                          </div>
                        </li>

                        <li :for={act <- slide.activities()} class="rounded px-4 py-3 dropped-border-sm flex items-start">
                          <div class="flex-grow flex items-center">
                            <%= if act.id in @completion[slide].ids do %>
                              <div class="rounded-full flex-none bg-pink-50 h-12 w-12 flex items-center justify-center mr-4">
                                <.icon name="hero-bolt-solid" class="h-6 w-6 text-pink-600" />
                              </div>
                            <% else %>
                              <div class="rounded-full flex-none bg-beanie-gold-100 h-12 w-12 flex items-center justify-center mr-4">
                                <.icon name="hero-lock-closed" class="h-6 w-6 text-beanie-gold-900" />
                              </div>
                            <% end %>

                            <div>
                              <div class="text-xl font-bold"><%= act.title %></div>
                              <div class="text-sm font-light"><%= act.action %></div>
                            </div>
                          </div>

                          <div>
                            <div class="text-lg"><%= act.points %>pts</div>
                          </div>
                        </li>
                      </ul>
                    </li>
                  </ul>
                </div>
              </section>
            </div>
          </div>
        </main>
      </div>
    </div>
    """
  end

  def mount(params, _session, socket) do
    socket =
      socket
      # Do not reassign on change, or it forces an unnecessary update
      |> assign(:active_slide_index, params["feature"] || "0")
      |> assign(:slides, [Hunt.Activity.Lounge, Hunt.Activity.Attend])
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

  def handle_params(_params, uri, socket) do
    socket =
      socket
      |> assign(:uri, URI.parse(uri))

    {:noreply, socket}
  end

  def handle_event("slide.active", %{"index" => idx}, socket = %{assigns: %{uri: uri}}) do
    socket =
      socket
      |> push_patch(to: HuntWeb.uri_path(uri, %{"feature" => idx}))

    {:noreply, socket}
  end
end
