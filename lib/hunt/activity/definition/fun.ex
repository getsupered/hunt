defmodule Hunt.Activity.Fun do
  use HuntWeb, :verified_routes
  use HuntWeb, :html

  def title do
    "We like to have fun"
  end

  def image do
    %{
      src: ~p"/images/meme.jpeg",
      class: "!object-contain"
    }
  end

  def total_points do
    activity_sum = activities() |> Enum.map(& &1.points) |> Enum.sum()
    activity_sum + achievement().points
  end

  def achievement do
    %{
      title: "Achievement: I am Supered Fun",
      points: 750
    }
  end

  @activities [
                %{
                  id: "b56e728a-1e26-48ad-9978-ba2f7e2222ba",
                  title: "Make Lindsay laugh with a dad joke",
                  action: "@ Sprocketeer Lounge",
                  points: 75,
                  component: &__MODULE__.dad_joke/1,
                  completion: Hunt.Activity.Completion.Answer.expected("Knock Knock")
                },
                %{
                  id: "d5a63e41-7326-4446-a977-60cfab602e04",
                  title: "Supered sticker on your device",
                  action: "@ Sprocketeer Lounge",
                  points: 75,
                  component: &__MODULE__.qr_at_sprocketeer/1,
                  completion: :qr_code
                },
                %{
                  id: "7b7c7d75-cf55-4e96-b911-2202f62cfa3c",
                  title: "Collect 5 Conference Shirts",
                  action: "Can be from anywhere",
                  points: 150,
                  component: &__MODULE__.shirts/1,
                  completion: :image
                },
                %{
                  id: "6ecfb3b1-2e94-404c-87b5-b7b22a8dea72",
                  title: "Wear a Supered Shirt",
                  action: "Looking good, Supered Star",
                  points: 150,
                  component: &__MODULE__.qr_at_sprocketeer/1,
                  completion: :qr_code
                },
                %{
                  id: "c1b20a9c-71b6-4d44-9b19-c184075c66b3",
                  title: "Grab a Supered Coffee (Day 1)",
                  action: "Everyday @ Sprocketeer Lounge!",
                  points: 75,
                  component: &__MODULE__.qr_at_sprocketeer/1,
                  completion: :qr_code
                },
                %{
                  id: "e7a9fbe0-5cbc-4f1f-9566-3b6659a62413",
                  title: "Grab a Supered Coffee (Day 2)",
                  action: "Everyday @ Sprocketeer Lounge!",
                  points: 75,
                  component: &__MODULE__.qr_at_sprocketeer/1,
                  completion: :qr_code
                },
                %{
                  id: "44c0079e-52db-49a1-9c80-0e9dbba3a8c3",
                  title: "Grab a Supered Coffee (Day 3)",
                  action: "Everyday @ Sprocketeer Lounge!",
                  points: 75,
                  component: &__MODULE__.qr_at_sprocketeer/1,
                  completion: :qr_code
                }
              ]
              |> Enum.sort_by(& &1.title)

  def activities, do: @activities

  def qr_at_sprocketeer(assigns) do
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
          <span>Scan QR code</span>
        </div>

        <div>
          <span class="font-semibold">Points: </span>
          <span><%= @hunt.points %>pts</span>
        </div>
      </div>

      <HuntWeb.QrCodeButton.button {assigns} />
    </div>
    """
  end

  def dad_joke(assigns) do
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
          <span class="font-semibold">Points: </span>
          <span><%= @hunt.points %>pts</span>
        </div>
      </div>

      <HuntWeb.LoggedInForm.wrap {assigns}>
        <.form for={nil} class="pb-8" phx-submit="submit_answer">
          <input type="hidden" name="activity_id" value={@hunt.id} />
          <div class="mb-4">
            <label class="font-semibold mb-2 block">
              Complete: What pass phrase did Lindsay give you?
            </label>
            <input required name="answer" type="text" placeholder="Ask Lindsay" class="w-full form-input" />
          </div>

          <button class="btn btn-primary btn-big w-full block text-2xl" phx-disable-with="Thinking...">
            Submit Answer
          </button>
        </.form>
      </HuntWeb.LoggedInForm.wrap>
    </div>
    """
  end

  def shirts(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <span class="font-semibold">Complete: </span>
          <span>Upload an image of your shirts</span>
        </div>

        <div>
          <span class="font-semibold">Points: </span>
          <span><%= @hunt.points %>pts</span>
        </div>
      </div>

      <HuntWeb.ImageButton.button {assigns} text="Upload Photo" />
    </div>
    """
  end
end
