defmodule HuntWeb.HuntCarousel do
  use HuntWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="image-carousel" phx-hook="ImageCarousel" class="p-4 z-0">
      <section class="splide" data-start-index={@active_slide_index}>
        <ul class="splide__pagination"></ul>

        <div class="splide__track">
          <ul class="splide__list">
            <li :for={slide <- @hunt_mods} class="splide__slide">
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

                <li :for={act <- slide.activities()}>
                  <.link patch={~p"/hunt/#{act.id}"} class="w-full flex items-start rounded px-4 py-3 dropped-border-sm touch-manipulation">
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
                  </.link>
                </li>
              </ul>
            </li>
          </ul>
        </div>
      </section>
    </div>
    """
  end
end
