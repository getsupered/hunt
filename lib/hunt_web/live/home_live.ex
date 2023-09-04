defmodule HuntWeb.HomeLive do
  use HuntWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="h-full max-w-2xl mx-auto sm:py-4 ">
      <div class="relative h-full sm:shadow sm:rounded-lg sm:overflow-auto">
        <.live_component module={HuntWeb.Header} id="header" />

        <main class="-mt-40">
          <.live_component module={HuntWeb.HuntCarousel} id="carousel" user={@user} hunt_mods={@hunt_mods} completion={@completion} />
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

  def mount(_params, session, socket) do
    socket = HuntWeb.load_user(session, socket)

    socket =
      socket
      |> assign(:hunt_mods, Hunt.Activity.activity_modules())
      |> load_completion()

    if connected?(socket) && socket.assigns.flash != %{} do
      Process.send_after(self(), :clear_flash, 5000)
    end

    {:ok, socket}
  end

  def handle_params(params, uri, socket) do
    socket =
      socket
      |> assign(:uri, URI.parse(uri))
      |> assign(:hunt, Hunt.Activity.find_activity(params["hunt_id"]))

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
          socket
          |> load_completion()
          |> completed_notification()
          |> push_patch(to: HuntWeb.uri_path(socket.assigns.uri, %{"path" => "/"}))

        {:ok, %{approval_state: :pending}} ->
          socket
          |> load_completion()
          |> completed_notification()
          |> push_patch(to: HuntWeb.uri_path(socket.assigns.uri, %{"path" => "/"}))

        {:error, why} when is_binary(why) ->
          push_event(socket, "notification", %{type: "error", text: why})

        {:error, cs = %Ecto.Changeset{}} ->
          why = HuntWeb.CoreComponents.translate_errors(cs)
          push_event(socket, "notification", %{type: "error", text: why})
      end

    {:noreply, socket}
  end

  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  defp load_completion(socket = %{assigns: %{user: user}}) do
    assign(socket, :completion, Hunt.Activity.completion_summary(user: user))
  end

  defp completed_notification(socket = %{assigns: %{completion: completion}}) do
    total_points = completion |> Map.values() |> Enum.map(& &1.points) |> Enum.sum()

    push_event(socket, "notification", %{
      type: "success",
      text: "Boom! Your answer was accepted. The points are yours. You have #{total_points} points."
    })
  end
end
