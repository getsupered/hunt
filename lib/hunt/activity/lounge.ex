defmodule Hunt.Activity.Lounge do
  use HuntWeb, :verified_routes

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
      points: 750,
    }
  end

  @activities [
    %{
      id: "58568b31-8b67-4134-bf59-82c628e9bead",
      title: "Visit Hubsearch",
      action: "Click for location",
      points: 50
    },
    %{
      id: "1956e950-d964-49e6-9e50-e2cb0a7ac3e3",
      title: "Visit Chili Piper",
      action: "Click for location",
      points: 50
    },
    %{
      id: "4aa86593-c13d-4249-bde4-4c1a9baa711b",
      title: "Visit EBSTA",
      action: "Click for location",
      points: 50
    },
    %{
      id: "5b09dd99-68e2-49b0-be49-a100b95c662b",
      title: "Visit Aircall",
      action: "Click for location",
      points: 50
    },
    %{
      id: "8d73b165-64e4-4971-ab9b-68c0c8891547",
      title: "Visit ClickUp",
      action: "Click for location",
      points: 50
    },
    %{
      id: "c44c98a2-2256-493c-9453-3db795693f0c",
      title: "Visit QuotaPath",
      action: "Click for location",
      points: 50
    },
    %{
      id: "8921c81a-a0d3-4d4a-a1ad-86bcf3631429",
      title: "Visit Avoma",
      action: "Click for location",
      points: 50
    },
    %{
      id: "a614ea30-135f-43ef-a1e4-cef3925c8709",
      title: "Visit Salesloft",
      action: "Click for location",
      points: 50
    },
    %{
      id: "32179c8f-2f00-4bea-8364-7e44e948c4b2",
      title: "Visit Vertify",
      action: "Click for location",
      points: 50
    },
  ]
  |> Enum.sort_by(& &1.title)

  def activities, do: @activities
end
