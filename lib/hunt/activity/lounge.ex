defmodule Hunt.Activity.Lounge do
  use HuntWeb, :verified_routes
  use HuntWeb, :html

  def title do
    "Lounge it up"
  end

  def image do
    %{
      src: ~p"/images/lounge-2.webp",
      class: "object-center"
    }
  end

  def total_points do
    activity_sum = activities() |> Enum.map(& &1.points) |> Enum.sum()
    activity_sum + achievement().points
  end

  def achievement do
    %{
      title: "Achievement: Lounge like a Boss",
      points: 750
    }
  end

  @activities [
                %{
                  id: "58568b31-8b67-4134-bf59-82c628e9bead",
                  title: "Visit Hubsearch",
                  action: "@ Sprocketeer Lounge",
                  points: 50,
                  component: &__MODULE__.visit_hubsearch/1,
                  completion: :qr_code
                },
                %{
                  id: "1956e950-d964-49e6-9e50-e2cb0a7ac3e3",
                  title: "Visit Chili Piper",
                  action: "@ Booth 15",
                  points: 50,
                  component: &__MODULE__.visit_chilipiper/1,
                  completion: :qr_code
                },
                %{
                  id: "4aa86593-c13d-4249-bde4-4c1a9baa711b",
                  title: "Visit EBSTA",
                  action: "@ Sprocketeer Lounge",
                  points: 50,
                  component: &__MODULE__.visit_ebsta/1,
                  completion: :qr_code
                },
                %{
                  id: "5b09dd99-68e2-49b0-be49-a100b95c662b",
                  title: "Visit Aircall",
                  action: "@ Booth 12",
                  points: 50,
                  component: &__MODULE__.visit_aircall/1,
                  completion: :qr_code
                },
                %{
                  id: "8d73b165-64e4-4971-ab9b-68c0c8891547",
                  title: "Visit ClickUp",
                  action: "@ Booth 16",
                  points: 50,
                  component: &__MODULE__.visit_clickup/1,
                  completion: :qr_code
                },
                %{
                  id: "c44c98a2-2256-493c-9453-3db795693f0c",
                  title: "Visit QuotaPath",
                  action: "@ Sprocketeer Lounge",
                  points: 50,
                  component: &__MODULE__.visit_quotapath/1,
                  completion: :qr_code
                },
                %{
                  id: "8921c81a-a0d3-4d4a-a1ad-86bcf3631429",
                  title: "Visit Avoma",
                  action: "@ Booth 2",
                  points: 50,
                  component: &__MODULE__.visit_avoma/1,
                  completion: :qr_code
                },
                %{
                  id: "a614ea30-135f-43ef-a1e4-cef3925c8709",
                  title: "Visit Salesloft",
                  action: "@ Booth 64",
                  points: 50,
                  component: &__MODULE__.visit_salesloft/1,
                  completion: :qr_code
                },
                %{
                  id: "32179c8f-2f00-4bea-8364-7e44e948c4b2",
                  title: "Visit Vertify",
                  action: "@ Sprocketeer Lounge",
                  points: 50,
                  component: &__MODULE__.visit_vertify/1,
                  completion: :qr_code
                }
              ]
              |> Enum.sort_by(& &1.title)

  def activities, do: @activities

  def visit_aircall(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href="https://inbound.expofp.com/?aircall" target="_blank" class="btn btn-muted text-xl">Interactive Map</a>
        </div>

        <div>
          <span class="font-semibold">Location: </span>
          <span>Booth 12</span>
        </div>

        <div>
          <span class="font-semibold">Complete: </span>
          <span>Scan QR code at booth</span>
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

  def visit_avoma(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href="https://inbound.expofp.com/?avoma" target="_blank" class="btn btn-muted text-xl">Interactive Map</a>
        </div>

        <div>
          <span class="font-semibold">Location: </span>
          <span>Booth 2</span>
        </div>

        <div>
          <span class="font-semibold">Complete: </span>
          <span>Scan QR code at booth</span>
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

  def visit_chilipiper(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href="https://inbound.expofp.com/?chili-piper" target="_blank" class="btn btn-muted text-xl">Interactive Map</a>
        </div>

        <div>
          <span class="font-semibold">Location: </span>
          <span>Booth 15</span>
        </div>

        <div>
          <span class="font-semibold">Complete: </span>
          <span>Scan QR code at booth</span>
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

  def visit_clickup(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href="https://inbound.expofp.com/?clickup" target="_blank" class="btn btn-muted text-xl">Interactive Map</a>
        </div>

        <div>
          <span class="font-semibold">Location: </span>
          <span>Booth 16</span>
        </div>

        <div>
          <span class="font-semibold">Complete: </span>
          <span>Scan QR code at booth</span>
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

  def visit_ebsta(assigns) do
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
          <span class="font-semibold">Complete: </span>
          <span>Scan QR code at booth</span>
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

  def visit_hubsearch(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href="https://inbound.expofp.com/?sprocketeer" target="_blank" class="btn btn-muted text-xl">Interactive Map</a>
        </div>

        <div>
          <span class="font-semibold">Location: </span>
          <span>Sprocketeer</span>
        </div>

        <div>
          <span class="font-semibold">Complete: </span>
          <span>Scan QR code at booth</span>
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

  def visit_quotapath(assigns) do
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
          <span class="font-semibold">Complete: </span>
          <span>Scan QR code at booth</span>
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

  def visit_salesloft(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href="https://inbound.expofp.com/?salesloft" target="_blank" class="btn btn-muted text-xl">Interactive Map</a>
        </div>

        <div>
          <span class="font-semibold">Location: </span>
          <span>Booth 64</span>
        </div>

        <div>
          <span class="font-semibold">Complete: </span>
          <span>Scan QR code at booth</span>
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

  def visit_vertify(assigns) do
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
          <span class="font-semibold">Complete: </span>
          <span>Scan QR code at booth</span>
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
