defmodule HuntWeb.HuntCarousel do
  use HuntWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="image-carousel" phx-hook="ImageCarousel" class="p-4 z-0">
      <section class="splide">
        <ul class="splide__pagination"></ul>

        <div class="splide__track">
          <ul class="splide__list">
            <li class="splide__slide">
              <div class="mx-4 mb-8 p-4 rounded-lg bg-white dropped-border overflow-hidden">
                <div class="prose text-xl">
                  <h2>Welcome!</h2>

                  <p>The Supered Dupered Challenge is a multi-day scavenger hunt to expand your INBOUND experience.</p>
                  <p>We'll be giving away prizes to the top performers, so try to complete as many as you can!</p>
                </div>
              </div>

              <ul class="mx-4 my-4 space-y-4">
                <li class="rounded px-4 py-3 dropped-border-sm flex items-start gap-4">
                  <%= if @user do %>
                    <div class="flex-grow">
                      You're logged in as <%= @user.email %>
                    </div>

                    <div class="flex-none">
                      <a href="/auth/logout" class="btn btn-muted">Logout</a>
                    </div>
                  <% else %>
                    <a class="btn btn-primary block w-full text-center" href="/auth/google">Login with Google</a>
                    <button class="btn btn-primary block w-full text-center">Login with Supered</button>
                  <% end %>
                </li>
              </ul>
            </li>

            <li :for={{slide, slide_idx} <- Enum.with_index(@hunt_mods)} class="splide__slide">
              <div class="mx-4 mb-8 rounded-lg bg-white dropped-border overflow-hidden">
                <img src={slide.image().src} class={"w-full max-h-[30vh] object-cover #{slide.image().class}"} />
                <div class="px-3 py-2">
                  <div>
                    <h2 class="font-semibold text-2xl"><%= slide.title() %></h2>
                  </div>

                  <div class="mt-2 flex items-center font-light">
                    <div>
                      <%= @completion[slide].count %> / <%= length(slide.activities()) + 1 %> completed
                    </div>

                    <div class="flex-grow text-right">
                      <%= @completion[slide].points %> / <%= slide.total_points() %> pts
                    </div>
                  </div>
                </div>
              </div>

              <ul class="mx-4 my-4 space-y-4">
                <li class="rounded px-4 py-3 dropped-border-sm flex items-start gap-4">
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
                  <.link
                    patch={~p"/hunt/#{act.id}?feature=#{slide_idx + 1}"}
                    class="w-full flex items-start gap-4 rounded px-4 py-3 dropped-border-sm touch-manipulation"
                  >
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
