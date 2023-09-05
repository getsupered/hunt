defmodule HuntWeb.AdminPendingLive do
  use HuntWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="h-full max-w-2xl mx-auto sm:py-4 ">
      <div class="relative h-full sm:shadow sm:rounded-lg sm:overflow-auto">
        <.live_component module={HuntWeb.Header} id="header" />

        <main class="-mt-40">
          <div class="mx-8 mb-8 p-4 rounded-xl bg-white dropped-border overflow-hidden">
            <h2 class="text-2xl font-bold mb-4">Pending Hunts</h2>

            <div class="space-y-2">
              <p>
                Go through the hunts to validate images. 1 is shown at a time.
              </p>

              <p>
                <span class="font-bold">Pending:</span> <%= @pending_count %>
              </p>
            </div>
          </div>

          <div :for={hunt <- @pending} class="mx-8 mb-8 p-4 rounded-xl bg-white dropped-border overflow-hidden space-y-2">
            <div>
              <span class="font-semibold">User: </span>
              <%= hunt.user.first_name %> <%= hunt.user.last_name %>
            </div>

            <div>
              <span class="font-semibold">Email: </span>
              <%= hunt.user.email %>
            </div>

            <div>
              <span class="font-semibold">Activity: </span>
              <%= hunt.activity.title %>
            </div>

            <div class="flex flex-col gap-2">
              <button class="btn btn-primary w-full text-xl" phx-value-id={hunt.id} phx-click="approve">Approve</button>
              <button class="btn btn-muted w-full text-xl" phx-value-id={hunt.id} phx-click="reject">Reject</button>
            </div>

            <%= if hunt.image_upload_id do %>
              <div>
                <img src={~p"/images/#{hunt.image_upload_id}"} class="w-full h-auto p-8" />
              </div>
            <% end %>
          </div>
        </main>
      </div>
    </div>
    """
  end

  def mount(_params, session, socket) do
    socket = HuntWeb.load_user(session, socket)

    case socket.assigns.user do
      %{admin: true} -> {:ok, load_data(socket)}
      _ -> {:ok, push_redirect(socket, to: "/")}
    end
  end

  defp load_data(socket) do
    assign(socket, pending_count: Hunt.Activity.pending_activity_count(), pending: Hunt.Activity.pending_activities())
  end

  def handle_event("approve", %{"id" => hunt_id}, socket) do
    activity = Hunt.Repo.get!(Hunt.Activity.Schema.CompletedActivity, hunt_id)
    Hunt.Activity.approve_answer(activity, by_user: socket.assigns.user)

    {:noreply, load_data(socket)}
  end

  def handle_event("reject", %{"id" => hunt_id}, socket) do
    activity = Hunt.Repo.get!(Hunt.Activity.Schema.CompletedActivity, hunt_id)
    Hunt.Activity.reject_answer(activity, by_user: socket.assigns.user)

    {:noreply, load_data(socket)}
  end
end
