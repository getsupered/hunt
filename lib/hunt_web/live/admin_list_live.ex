defmodule HuntWeb.AdminListLive do
  use HuntWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="h-full max-w-2xl mx-auto sm:py-4 ">
      <div class="relative h-full sm:shadow sm:rounded-lg sm:overflow-auto">
        <.live_component module={HuntWeb.Header} id="header" />

        <main class="-mt-40">
          <div :for={hunt_mod <- @hunt_mods} class="mx-8 mb-8 p-4 rounded-xl bg-white dropped-border overflow-hidden">
            <h2 class="text-2xl font-bold mb-4"><%= hunt_mod.title() %></h2>

            <ul class="space-y-4">
              <li :for={act <- hunt_mod.activities()}>
                <div class="flex items-center gap-4">
                  <h3 class="text-lg font-semibold flex-grow"><%= act.title %></h3>
                  <.link class="btn btn-muted btn-sm" patch={~p"/admin/detail/#{act.id}"}>Open</.link>
                </div>
              </li>
            </ul>
          </div>
        </main>

        <div class={"z-10 fixed max-w-2xl mx-auto bottom-0 top-40 left-0 right-0 transition-all #{if @hunt, do: "translate-y-0", else: "translate-y-full"}"}>
          <div class="relative h-full bg-white mx-4 rounded-t-xl p-4 overflow-auto dropped-border !border-b-0">
            <%= if @hunt do %>
              <div class="absolute right-4 top-4">
                <.link patch={HuntWeb.uri_path(@uri, %{"path" => "/admin/detail"})} class="touch-manipulation">
                  <.icon name="hero-x-mark" class="h-10 w-10" />
                </.link>
              </div>

              <div class="h-full flex flex-col">
                <div class="flex-grow prose text-xl space-y-4">
                  <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

                  <%= case @hunt[:completion] do %>
                    <% :qr_code -> %>
                      <div>
                        <img src={Hunt.Activity.qr_code(@hunt, :base64)} class="w-[75%] mx-auto" />
                      </div>
                    <% %Hunt.Activity.Completion.Answer{answer: answer} -> %>
                      <div>
                        <span class="font-semibold">Expected Answer: </span>
                        <span><%= answer %></span>
                      </div>
                    <% :image -> %>
                      <div>
                        <span class="font-semibold">Completed via: </span>
                        <span>Image upload</span>
                      </div>
                  <% end %>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, session, socket) do
    socket = HuntWeb.load_user(session, socket)

    socket =
      socket
      |> assign(:hunt_mods, Hunt.Activity.activity_modules())

    case socket.assigns.user do
      %{admin: true} -> {:ok, socket}
      _ -> {:ok, push_redirect(socket, to: "/")}
    end
  end

  def handle_params(params, uri, socket) do
    socket =
      socket
      |> assign(:uri, URI.parse(uri))
      |> assign(:hunt, Hunt.Activity.find_activity(params["hunt_id"]))

    {:noreply, socket}
  end
end
