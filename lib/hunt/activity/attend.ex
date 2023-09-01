defmodule Hunt.Activity.Attend do
  use HuntWeb, :verified_routes

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
      points: 1000,
    }
  end

  @activities [
    %{
      id: "4ed0fe52-abc4-4386-8dcc-838a4820bfe4",
      title: "10k Pitch Attendee",
      action: "Click for location",
      points: 150
    },
    %{
      id: "bf31f5d1-8247-4414-be8b-9084400e2a08",
      title: "HUG Admin Attendee",
      action: "Click for location",
      points: 150
    },
    %{
      id: "59180db0-0161-4b4c-ad53-170fbe309ae8",
      title: "Session: Supered Adoption Framework",
      action: "Click for location",
      points: 150
    },
    %{
      # https://www.eventbrite.com/e/hubolution-after-party-tickets-691845738227
      id: "f9f1f4de-cc67-46e6-997d-0570296cddbf",
      title: "Attend Sprocketeer Party",
      action: "Click for location",
      points: 250
    },
  ]
  |> Enum.sort_by(& &1.title)

  def activities, do: @activities
end
