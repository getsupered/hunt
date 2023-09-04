defmodule Hunt.Activity.Selfie1 do
  use HuntWeb, :verified_routes
  use HuntWeb, :html

  def title do
    "Selfies with HubSpot Execs"
  end

  def image do
    %{
      src: ~p"/images/selfie-1.jpeg",
      class: "object-center"
    }
  end

  def total_points do
    activity_sum = activities() |> Enum.map(& &1.points) |> Enum.sum()
    activity_sum + achievement().points
  end

  def achievement do
    %{
      title: "Achievement: Three Hubeteers",
      points: 500
    }
  end

  @activities [
                %{
                  id: "8c7e361f-a8c1-486f-9017-647a1bb785c3",
                  title: "Selfie with Brian Halligan",
                  action: "Co-Founder at HubSpot",
                  points: 100,
                  component: &__MODULE__.selfie/1,
                  linkedin: "https://www.linkedin.com/in/brianhalligan/",
                  completion: :image
                },
                %{
                  id: "2c62226d-2513-4fee-b8fd-625107300ccb",
                  title: "Selfie with Dharmesh Shah",
                  action: "Founder and CTO at HubSpot",
                  points: 100,
                  component: &__MODULE__.selfie/1,
                  linkedin: "https://www.linkedin.com/in/dharmesh/",
                  completion: :image
                },
                %{
                  id: "43663b50-612f-4f01-b93e-199304db5993",
                  title: "Selfie with Yamini Rangan",
                  action: "CEO of HubSpot",
                  points: 100,
                  component: &__MODULE__.selfie/1,
                  linkedin: "https://www.linkedin.com/in/yaminirangan/",
                  completion: :image
                }
              ]
              |> Enum.sort_by(& &1.title)

  def activities, do: @activities

  def selfie(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href={@hunt.linkedin} target="_blank" class="btn btn-muted text-xl">LinkedIn</a>
        </div>

        <div>
          <span class="font-semibold">Location: </span>
          <span>This one's on you</span>
        </div>

        <div>
          <span class="font-semibold">Complete: </span>
          <span>Upload selfie</span>
        </div>

        <div>
          <span class="font-semibold">Points: </span>
          <span><%= @hunt.points %>pts</span>
        </div>
      </div>

      <HuntWeb.ImageButton.button {assigns} text="Upload Selfie" />
    </div>
    """
  end
end
