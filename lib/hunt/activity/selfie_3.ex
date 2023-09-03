defmodule Hunt.Activity.Selfie3 do
  use HuntWeb, :verified_routes
  use HuntWeb, :html

  def title do
    "Selfies with HubSpot Advocates"
  end

  def image do
    %{
      src: ~p"/images/selfie-3.webp",
      class: "object-center"
    }
  end

  def total_points do
    activity_sum = activities() |> Enum.map(& &1.points) |> Enum.sum()
    activity_sum + achievement().points
  end

  def achievement do
    %{
      title: "Achievement: HubSpot in the City",
      points: 500
    }
  end

  @activities [
                %{
                  id: "af67f490-81f7-42e8-94a3-2cb9c1662def",
                  title: "Selfie with Lindsay John",
                  action: "Heads of Customer Success at Supered",
                  points: 100,
                  component: &Hunt.Activity.Selfie1.selfie/1,
                  linkedin: "https://www.linkedin.com/in/lindsayjohn92/"
                },
                %{
                  id: "af79a828-11c7-4828-af2a-0b881ccbd801",
                  title: "Selfie with D'Ana Guiloff",
                  action: "HubSpot Admin HUG Co-leader",
                  points: 100,
                  component: &Hunt.Activity.Selfie1.selfie/1,
                  linkedin: "https://www.linkedin.com/in/dguiloff/"
                },
                %{
                  id: "f27b8420-d966-4e2c-a7cc-39479b61af5f",
                  title: "Selfie with Christina Garnett",
                  action: "Principle Marketing Manager (Community) at HubSpot",
                  points: 100,
                  component: &Hunt.Activity.Selfie1.selfie/1,
                  linkedin: "https://www.linkedin.com/in/christinamgarnett/"
                },
                %{
                  id: "3b18291f-c999-46be-b871-edc1dfaf3e13",
                  title: "Selfie with Alina Vandenberghe",
                  action: "Co-founder & Co-Ceo at Chili Piper",
                  points: 100,
                  component: &Hunt.Activity.Selfie1.selfie/1,
                  linkedin: "https://www.linkedin.com/in/alinav/"
                }
              ]
              |> Enum.sort_by(& &1.title)

  def activities, do: @activities
end
