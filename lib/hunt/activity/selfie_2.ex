defmodule Hunt.Activity.Selfie2 do
  use HuntWeb, :verified_routes
  use HuntWeb, :html

  def title do
    "Selfies with HubSpot Influencers"
  end

  def image do
    %{
      src: ~p"/images/selfie-2.jpeg",
      class: "object-top"
    }
  end

  def total_points do
    activity_sum = activities() |> Enum.map(& &1.points) |> Enum.sum()
    activity_sum + achievement().points
  end

  def achievement do
    %{
      title: "Achievement: The Hub Busters",
      points: 500,
    }
  end

  @activities [
    %{
      id: "a4850287-ba7c-4a14-8f18-cb39e5953bf7",
      title: "Selfie with Kyle Jepson",
      action: "The HubSpot Professor",
      points: 100,
      component: &Hunt.Activity.Selfie1.selfie/1,
      linkedin: "https://www.linkedin.com/in/kyleanthonyjepson/"
    },
    %{
      id: "6626e442-cd27-4b50-8a87-1fae36825f82",
      title: "Selfie with Matt Bolian",
      action: "Supered Selfie with Supered Matt",
      points: 100,
      component: &Hunt.Activity.Selfie1.selfie/1,
      linkedin: "https://www.linkedin.com/in/matthewbolian/"
    },
    %{
      id: "3a46b231-7b3c-4aad-b1d7-7e3363c10669",
      title: "Selfie with Max Cohen",
      action: "Chief Evangelist @ Hapily",
      points: 100,
      component: &Hunt.Activity.Selfie1.selfie/1,
      linkedin: "https://www.linkedin.com/in/maxjacobcohen/"
    },
    %{
      id: "346a6caa-6bab-4215-88b6-1b51aae979bb",
      title: "Selfie with Robert Jones",
      action: "The Mayor of INBOUND, RevPartners",
      points: 100,
      component: &Hunt.Activity.Selfie1.selfie/1,
      linkedin: "https://www.linkedin.com/in/robert-jones-%F0%9F%A4%A0-a9878bb1/"
    }
  ]
  |> Enum.sort_by(& &1.title)

  def activities, do: @activities
end
