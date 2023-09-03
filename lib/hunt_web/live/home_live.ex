defmodule HuntWeb.HomeLive do
  use HuntWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="h-full max-w-2xl mx-auto sm:py-4 ">
      <div class="relative h-full sm:shadow sm:rounded-lg sm:overflow-auto">
        <.live_component module={HuntWeb.Header} id="header" />

        <main class="-mt-40">
          <.live_component
            module={HuntWeb.HuntCarousel}
            id="carousel"
            user={@user}
            active_slide_index={@active_slide_index}
            hunt_mods={@hunt_mods}
            completion={@completion}
          />
        </main>

        <div class={"z-10 fixed max-w-2xl mx-auto bottom-0 top-40 left-0 right-0 transition-all #{if @hunt, do: "translate-y-0", else: "translate-y-full"}"}>
          <div class="relative h-full bg-white mx-4 rounded-t-xl p-4 overflow-auto dropped-border !border-b-0">
            <%= if @hunt do %>
              <div class="absolute right-4 top-4">
                <.link patch={HuntWeb.uri_path(@uri, %{"path" => "/"})} class="touch-manipulation">
                  <.icon name="hero-x-mark" class="h-10 w-10" />
                </.link>
              </div>

              <.live_component module={HuntWeb.HuntRender} id="hunt-display" user={@user} hunt={@hunt} completion={@completion} />
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(params, session, socket) do
    socket = HuntWeb.load_user(session, socket)

    completion =
      Enum.map(Hunt.Activity.activity_modules(), fn mod ->
        completion = %{
          ids: [],
          achievement: false,
          count: 0,
          activity_count: 0,
          points: 0
        }

        {mod, completion}
      end)

    socket =
      socket
      # Do not reassign on change, or it forces an unnecessary update
      |> assign(:active_slide_index, params["feature"] || "0")
      |> assign(:hunt_mods, Hunt.Activity.activity_modules())
      |> assign(:completion, completion)

    if connected?(socket) && socket.assigns.flash != %{} do
      Process.send_after(self(), :clear_flash, 5000)
    end

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
      |> push_patch(to: HuntWeb.uri_path(uri, %{"feature" => idx}), replace: true)

    {:noreply, socket}
  end

  def handle_event("submit_answer", params, socket) do
    now = DateTime.utc_now() |> DateTime.to_unix(:millisecond) |> to_string()

    socket =
      case Hunt.Activity.submit_answer(params, user: socket.assigns.user) do
        {:ok, %{approval_state: :approved}} ->
          put_flash(socket, "info-#{now}", "Boom! Your answer was accepted. The points are yours.")

        {:ok, %{approval_state: :pending}} ->
          put_flash(socket, "info-#{now}", "Boom! We'll review your answer, but you'll see the points now.")

        {:error, why} when is_binary(why) ->
          put_flash(socket, "error-#{now}", why)

        {:error, cs = %Ecto.Changeset{}} ->
          put_flash(socket, "error-#{now}", HuntWeb.CoreComponents.translate_errors(cs))
      end

    Process.send_after(self(), {:clear_flash, now}, 5000)

    {:noreply, socket}
  end

  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  def handle_info({:clear_flash, time}, socket) do
    socket =
      Enum.reduce(socket.assigns.flash, socket, fn {k, _v}, socket ->
        if is_binary(k) and String.contains?(k, time) do
          clear_flash(socket, k)
        else
          socket
        end
      end)

    {:noreply, socket}
  end

  defp get_hunt(id, hunt_mods) do
    Enum.find_value(hunt_mods, fn hunt_mod ->
      Enum.find(hunt_mod.activities(), &(&1.id == id))
    end)
  end
end
