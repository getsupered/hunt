defmodule Hunt.Activity.Attend do
  use HuntWeb, :verified_routes
  use HuntWeb, :html

  def title do
    "Attend Awesome Events"
  end

  def image do
    %{
      src: ~p"/images/afterparty.jpeg",
      class: "object-right-top"
    }
  end

  def total_points do
    activity_sum = activities() |> Enum.map(& &1.points) |> Enum.sum()
    activity_sum + achievement().points
  end

  def achievement do
    %{
      title: "Achievement: Attendee Supered Star",
      points: 1000
    }
  end

  @activities [
                %{
                  id: "4ed0fe52-abc4-4386-8dcc-838a4820bfe4",
                  title: "10k Pitch Attendee",
                  action: "Click for location",
                  points: 150,
                  component: &__MODULE__.ten_k_pitch/1,
                  completion: :qr_code
                },
                %{
                  id: "bf31f5d1-8247-4414-be8b-9084400e2a08",
                  title: "HUG Attendee: HubSpot Admins",
                  action: "Click for location",
                  points: 150,
                  component: &__MODULE__.hug_admin/1,
                  completion: :qr_code
                },
                %{
                  id: "59180db0-0161-4b4c-ad53-170fbe309ae8",
                  title: "Session: Supered Adoption Framework",
                  action: "Click for location",
                  points: 150,
                  component: &__MODULE__.adoption/1,
                  completion: :qr_code
                },
                %{
                  id: "f9f1f4de-cc67-46e6-997d-0570296cddbf",
                  title: "Attend Hubolution Party",
                  action: "Click for location",
                  points: 250,
                  component: &__MODULE__.attend_party/1,
                  completion: :qr_code
                }
              ]
              |> Enum.sort_by(& &1.title)

  def activities, do: @activities

  def ten_k_pitch(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href="https://inbound.expofp.com/?sprocketeer" target="_blank" class="btn btn-muted text-xl">Interactive Map</a>
        </div>

        <div>
          <span class="font-semibold">Location: </span>
          <span>Sprocketeer Lounge</span>
        </div>

        <div>
          <span class="font-semibold">Time: </span>
          <span>Thursday 2PM – 3PM</span>
        </div>

        <div>
          <span class="font-semibold">Complete: </span>
          <span>Scan QR code after</span>
        </div>

        <div>
          <span class="font-semibold">Points: </span>
          <span><%= @hunt.points %>pts</span>
        </div>
      </div>

      <div class="pb-8">
        <button class="btn btn-primary btn-big w-full block text-2xl" id="scan-button" phx-hook="QRScanButton">
          <.icon name="hero-qr-code" class="h-8 w-8 mr-2" /> Scan QR Code
        </button>
      </div>
    </div>
    """
  end

  def adoption(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href="https://inbound.expofp.com/?sprocketeer" target="_blank" class="btn btn-muted text-xl">Interactive Map</a>
        </div>

        <div>
          <span class="font-semibold">Location: </span>
          <span>Sprocketeer Lounge</span>
        </div>

        <div>
          <span class="font-semibold">Time: </span>
          <span>Wednesday 2:30PM – 3:30PM</span>
        </div>

        <div>
          <span class="font-semibold">Complete: </span>
          <span>Scan QR code after</span>
        </div>

        <div>
          <span class="font-semibold">Points: </span>
          <span><%= @hunt.points %>pts</span>
        </div>
      </div>

      <div class="pb-8">
        <button class="btn btn-primary btn-big w-full block text-2xl" id="scan-button" phx-hook="QRScanButton">
          <.icon name="hero-qr-code" class="h-8 w-8 mr-2" /> Scan QR Code
        </button>
      </div>
    </div>
    """
  end

  def hug_admin(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a
            href="https://events.hubspot.com/events/details/hubspot-hubspot-admins-presents-inbound23-hug-meet-up/"
            target="_blank"
            class="btn btn-muted text-xl"
          >
            Event Page
          </a>
        </div>

        <div>
          <span class="font-semibold">Location: </span>
          <span>Sprocketeer Lounge</span>
        </div>

        <div>
          <span class="font-semibold">Time: </span>
          <span>Thursday 4:00PM – 4:45PM</span>
        </div>

        <div>
          <span class="font-semibold">Complete: </span>
          <span>Scan QR code at event</span>
        </div>

        <div>
          <span class="font-semibold">Points: </span>
          <span><%= @hunt.points %>pts</span>
        </div>
      </div>

      <div class="pb-8">
        <button class="btn btn-primary btn-big w-full block text-2xl" id="scan-button" phx-hook="QRScanButton">
          <.icon name="hero-qr-code" class="h-8 w-8 mr-2" /> Scan QR Code
        </button>
      </div>
    </div>
    """
  end

  def attend_party(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href="https://www.eventbrite.com/e/hubolution-after-party-tickets-691845738227" target="_blank" class="btn btn-muted text-xl">
            Register
          </a>
        </div>

        <div>
          <span class="font-semibold">Location: </span>
          <span>Westin Pavilion, by Lawn on D</span>
        </div>

        <div>
          <span class="font-semibold">Time: </span>
          <span>Thursday 5:30PM – 8:30PM</span>
        </div>

        <div>
          <span class="font-semibold">Complete: </span>
          <span>Scan QR code at party</span>
        </div>

        <div>
          <span class="font-semibold">Points: </span>
          <span><%= @hunt.points %>pts</span>
        </div>
      </div>

      <div class="pb-8">
        <button class="btn btn-primary btn-big w-full block text-2xl" id="scan-button" phx-hook="QRScanButton">
          <.icon name="hero-qr-code" class="h-8 w-8 mr-2" /> Scan QR Code
        </button>
      </div>
    </div>
    """
  end
end
