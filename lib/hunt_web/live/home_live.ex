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
            hunt_mods={@hunt_mods}
            completion={@completion}
            points={@total_points}
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

    socket =
      case {connected?(socket), params} do
        {true, %{"code" => _qrcode}} ->
          # The code should always be removed, but we need to do it async as the user may be redirected during qrscan event
          # This code cannot run unless connected?, or the notification event isn't pushed
          send(self(), :remove_code)
          {:noreply, socket} = handle_event("qrscan", %{"text" => uri}, socket)
          socket

        _ ->
          socket
      end

    {:noreply, socket}
  end

  def handle_event("slide.active", %{"index" => idx}, socket = %{assigns: %{uri: uri}}) do
    socket =
      socket
      |> push_patch(to: HuntWeb.uri_path(uri, %{"feature" => idx}), replace: true)

    {:noreply, socket}
  end

  def handle_event("submit_answer", params, socket) do
    socket =
      Hunt.Activity.submit_answer(params, user: socket.assigns.user)
      |> handle_activity_result(socket, "Your answer was accepted. The points are yours!", true)

    {:noreply, socket}
  end

  def handle_event("qrscan", %{"text" => text}, socket) do
    uri = URI.parse(text)

    hunt_id =
      case uri.path do
        "/hunt/" <> id -> id
        _ -> nil
      end

    close_slideout? =
      case socket.assigns do
        %{hunt: %{id: current_hunt_id}} -> current_hunt_id == hunt_id
        _ -> false
      end

    activity = Hunt.Activity.find_activity(hunt_id) || %{}
    query = Plug.Conn.Query.decode(uri.query || "")

    socket =
      Hunt.Activity.submit_qr_code(hunt_id, query["code"], user: socket.assigns.user)
      |> handle_activity_result(socket, "#{activity[:title]} complete. The points are yours!", close_slideout?)

    {:noreply, socket}
  end

  def handle_info(:remove_code, socket) do
    {:noreply, push_patch(socket, to: HuntWeb.uri_path(socket.assigns.uri, %{"code" => nil}), replace: true)}
  end

  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  def handle_info({:activity_result, result, msg}, socket) do
    {:noreply, handle_activity_result(result, socket, msg, true)}
  end

  defp load_completion(socket = %{assigns: %{user: user}}) do
    summary = Hunt.Activity.completion_summary(user: user)
    # This will be self-correcting if there's any issues
    Hunt.Activity.Leaderboard.update_user(summary, user.id)

    socket
    |> assign(:completion, summary)
    |> assign(:total_points, Hunt.Activity.total_points(summary))
  end

  defp handle_activity_result(result, socket, msg, close_slideout?) do
    maybe_close_slideout = fn socket ->
      if close_slideout? do
        push_patch(socket, to: HuntWeb.uri_path(socket.assigns.uri, %{"path" => "/", "code" => nil}))
      else
        socket
      end
    end

    case result do
      {:ok, %{approval_state: :approved}} ->
        socket
        |> load_completion()
        |> completed_notification(msg)
        |> maybe_close_slideout.()

      {:ok, %{approval_state: :pending}} ->
        socket
        |> load_completion()
        |> completed_notification(msg)
        |> maybe_close_slideout.()

      {:error, why} when is_binary(why) ->
        push_event(socket, "notification", %{type: "error", text: why})

      {:error, cs = %Ecto.Changeset{}} ->
        why = HuntWeb.CoreComponents.translate_errors(cs)
        push_event(socket, "notification", %{type: "error", text: why})
    end
  end

  defp completed_notification(socket = %{assigns: %{total_points: points}}, msg) do
    push_event(socket, "notification", %{
      type: "success",
      text: "Boom! #{msg} You have #{points} points."
    })
  end
end
