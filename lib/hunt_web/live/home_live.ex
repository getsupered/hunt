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
            <div id="image-carousel" phx-hook="ImageCarousel" phx-update="ignore">
              <section class="splide" data-start-index={@active_slide_index}>
                <div class="splide__track">
                  <ul class="splide__list">
                    <li class="splide__slide">
                      <div class="mx-4 mb-8 rounded-lg bg-white dropped-border overflow-hidden">
                        <img src={~p"/images/lounge-2.webp"} class="w-full max-h-[30vh] object-cover object-center" />
                        <div class="px-3 py-2">
                          <div class="flex items-baseline">
                            <h2 class="font-semibold flex-grow">Lounge it up</h2>
                            <div class="text-right">
                              <div class="text-sm font-light">100 / 1200 pts</div>
                              <div class="text-sm font-light">2 / 9 completed</div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </li>

                    <li class="splide__slide">
                      <div class="mx-4 mb-8 rounded-lg bg-white px-5 py-6 shadow sm:px-6">
                        <div class="relative min-h-[150px] rounded ">B</div>
                      </div>
                    </li>
                    <li class="splide__slide">
                      <div class="mx-4 mb-8 rounded-lg bg-white px-5 py-6 shadow sm:px-6">
                        <div class="relative min-h-[150px] rounded ">C</div>
                      </div>
                    </li>
                  </ul>
                </div>
              </section>
            </div>

            <%= case @active_slide_index do %>
              <% "0" -> %>
                <ul class="mt-4 space-y-4">
                  <li class="rounded px-4 py-3 dropped-border-sm flex items-start">
                    <div class="flex-grow flex items-center">
                      <%!-- <div class="rounded-full flex-none bg-pink-50 h-12 w-12 flex items-center justify-center mr-4">
                        <.icon name="hero-trophy" class="h-6 w-6 text-pink-600" />
                      </div> --%>
                      <div class="rounded-full flex-none bg-beanie-gold-600 h-12 w-12 flex items-center justify-center mr-4">
                        <.icon name="hero-lock-closed" class="h-6 w-6 text-orange-900" />
                      </div>

                      <div>
                        <div class="text-xl font-bold">Achievement: Lounge like a Boss</div>
                        <div class="text-sm font-light">2/9 Hunts Complete</div>
                      </div>
                    </div>

                    <div>
                      <div class="text-lg">750pts</div>
                    </div>
                  </li>

                  <li class="rounded px-4 py-3 dropped-border-sm flex items-start">
                    <div class="flex-grow flex items-center">
                      <div class="rounded-full flex-none bg-pink-50 h-12 w-12 flex items-center justify-center mr-4">
                        <.icon name="hero-bolt-solid" class="h-6 w-6 text-pink-600" />
                      </div>

                      <div>
                        <div class="text-xl font-bold">Hunt: Visit Hubsearch</div>
                        <div class="text-sm font-light">Click for location</div>
                      </div>
                    </div>

                    <div>
                      <div class="text-lg">50pts</div>
                    </div>
                  </li>

                  <li class="rounded px-4 py-3 dropped-border-sm flex items-start">
                    <div class="flex-grow flex items-center">
                      <div class="rounded-full flex-none bg-pink-50 h-12 w-12 flex items-center justify-center mr-4">
                        <.icon name="hero-bolt-solid" class="h-6 w-6 text-pink-600" />
                      </div>

                      <div>
                        <div class="text-xl font-bold">Hunt: Visit Chili Piper</div>
                        <div class="text-sm font-light">Click for location</div>
                      </div>
                    </div>

                    <div>
                      <div class="text-lg">50pts</div>
                    </div>
                  </li>

                  <li class="rounded px-4 py-3 dropped-border-sm flex items-start">
                    <div class="flex-grow flex items-center">
                      <div class="rounded-full flex-none bg-pink-50 h-12 w-12 flex items-center justify-center mr-4">
                        <.icon name="hero-bolt-solid" class="h-6 w-6 text-pink-600" />
                      </div>

                      <div>
                        <div class="text-xl font-bold">Hunt: Visit EBSTA</div>
                        <div class="text-sm font-light">Click for location</div>
                      </div>
                    </div>

                    <div>
                      <div class="text-lg">50pts</div>
                    </div>
                  </li>
                </ul>

              <% idx -> %>
                <%= idx %>
            <% end %>
          </div>
        </main>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, uri, socket) do
    socket =
      socket
      |> assign(:uri, URI.parse(uri))
      |> assign(:active_slide_index, params["feature"] || "0")

    {:noreply, socket}
  end

  def handle_event("slide.active", %{"index" => idx}, socket = %{assigns: %{uri: uri}}) do
    socket =
      socket
      |> push_patch(to: HuntWeb.uri_path(uri, %{"feature" => idx}))

    {:noreply, socket}
  end
end
