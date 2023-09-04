defmodule Hunt.Activity.Social do
  use HuntWeb, :verified_routes
  use HuntWeb, :html

  def title do
    "Supered Squad"
  end

  def image do
    %{
      src: ~p"/images/supered.png",
      class: "!object-contain p-2"
    }
  end

  def total_points do
    activity_sum = activities() |> Enum.map(& &1.points) |> Enum.sum()
    activity_sum + achievement().points
  end

  def achievement do
    %{
      title: "Achievement: Supefluencer",
      points: 1000
    }
  end

  @activities [
                %{
                  id: "a4f56a03-9a95-4f55-a518-e1c338f6bc79",
                  title: "Post a picture with your fanny pack and tag Supered",
                  action: "They're back in fashion?!",
                  points: 150,
                  component: &__MODULE__.fanny_pack/1,
                  completion: :image
                },
                %{
                  id: "1865303b-1c6a-432e-b3d1-268d5fadadc9",
                  title: "Follow Supered on LinkedIn",
                  action: "These points are a click away",
                  points: 150,
                  component: &__MODULE__.linkedin/1,
                  completion: :image
                },
                %{
                  id: "b92661eb-ee13-4490-bbc3-1903503e9ee4",
                  title: "LinkedIn Post: \"Favorite thing about Supered\"",
                  action: "Share your Supered awesomeness",
                  points: 300,
                  component: &__MODULE__.linkedin_post/1,
                  completion: :image
                }
              ]
              |> Enum.sort_by(& &1.title)

  def activities, do: @activities

  def fanny_pack(assigns) do
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
          <span>Upload screenshot of your LinkedIn post</span>
        </div>

        <div>
          <span class="font-semibold">Points: </span>
          <span><%= @hunt.points %>pts</span>
        </div>
      </div>

      <div class="pb-8">
        <button class="btn btn-primary btn-big w-full block text-2xl" id="camera-button" phx-hook="CameraButton">
          <.icon name="hero-camera" class="h-8 w-8 mr-2" /> Upload Screenshot
        </button>
      </div>
    </div>
    """
  end

  def linkedin(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href="https://www.linkedin.com/company/getsupered" target="_blank" class="btn btn-muted text-xl">LinkedIn</a>
        </div>

        <div>
          <span class="font-semibold">Complete: </span>
          <span>Upload screenshot of your LinkedIn follow</span>
        </div>

        <div>
          <span class="font-semibold">Points: </span>
          <span><%= @hunt.points %>pts</span>
        </div>
      </div>

      <div class="pb-8">
        <button class="btn btn-primary btn-big w-full block text-2xl" id="camera-button" phx-hook="CameraButton">
          <.icon name="hero-camera" class="h-8 w-8 mr-2" /> Upload Screenshot
        </button>
      </div>
    </div>
    """
  end

  def linkedin_post(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href="https://www.linkedin.com/company/getsupered" target="_blank" class="btn btn-muted text-xl">LinkedIn</a>
        </div>

        <div>
          <span class="font-semibold">Write: </span>
          <span>A LinkedIn post with Supered tagged in it. Let us know what how you would use Supered, or what your favorite thing is!</span>
        </div>

        <div>
          <span class="font-semibold">Complete: </span>
          <span>Upload screenshot of your LinkedIn post</span>
        </div>

        <div>
          <span class="font-semibold">Points: </span>
          <span><%= @hunt.points %>pts</span>
        </div>
      </div>

      <div class="pb-8 mt-4">
        <button class="btn btn-primary btn-big w-full block text-2xl" id="camera-button" phx-hook="CameraButton">
          <.icon name="hero-camera" class="h-8 w-8 mr-2" /> Upload Screenshot
        </button>
      </div>
    </div>
    """
  end
end
