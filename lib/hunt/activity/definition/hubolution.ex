defmodule Hunt.Activity.Hubolution do
  use HuntWeb, :verified_routes
  use HuntWeb, :html

  def title do
    "Hubolution: The Orange Wave"
  end

  def image do
    %{
      src: ~p"/images/hubolution.webp",
      class: "!object-contain p-2"
    }
  end

  def total_points do
    activity_sum = activities() |> Enum.map(& &1.points) |> Enum.sum()
    activity_sum + achievement().points
  end

  def achievement do
    %{
      title: "Achievement: Hubolutionary",
      points: 750
    }
  end

  @activities [
                %{
                  id: "ec97f1af-c366-4ef3-9895-cd942213693e",
                  title: "Join Sprocketeer Discord",
                  action: "Over 1500 HubSpot enthusiasts in one place!",
                  points: 100,
                  component: &__MODULE__.discord/1,
                  completion: Hunt.Activity.Completion.Answer.expected("Captain Sprocket")
                },
                %{
                  id: "a9882a9b-c2be-419b-9a2f-01841900d39b",
                  title: "Use a photo booth at Hubolution Party",
                  action: "Big cheesin' at the afterparty",
                  points: 150,
                  component: &__MODULE__.photo_booth/1,
                  completion: :qr_code
                },
                %{
                  id: "20aeef09-f040-4eda-bc7c-de1894f6e3e9",
                  title: "Get \"The Mayor of INBOUND\"'s signature",
                  action: "Better bring a pen!",
                  points: 300,
                  component: &__MODULE__.mayor_signature/1,
                  completion: :image
                },
                %{
                  id: "96205e49-81ff-420d-bd99-c2002db9b094",
                  title: "Post Hubolution Party pic with #hubolution",
                  action: "You'll have a bunch of fun, so share it with the world",
                  points: 300,
                  component: &__MODULE__.afterparty_pic/1,
                  completion: :image
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

  def discord(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href="https://discord.com/invite/AWsZgNSWjs" target="_blank" class="btn btn-muted text-xl">Discord Invite</a>
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
              Complete: In the announcements channel, what is the name signing off the message?
            </label>
            <input required name="answer" type="text" placeholder="Hint: C.S." class="w-full form-input" />
          </div>

          <button class="btn btn-primary btn-big w-full block text-2xl" phx-disable-with="Thinking...">
            Submit Answer
          </button>
        </.form>
      </HuntWeb.LoggedInForm.wrap>
    </div>
    """
  end

  def photo_booth(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <span class="font-semibold">Complete: </span>
          <span>Scan QR code at the booth</span>
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

  def mayor_signature(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <span class="font-semibold">Location: </span>
          <span>This one's on you...we recommend the afterparty.</span>
        </div>

        <div>
          <span class="font-semibold">Complete: </span>
          <span>Take picture of The Mayor's signature. Try it on a shirt, your hand, or a framed portrait of The Mayor.</span>
        </div>

        <div>
          <span class="font-semibold">Points: </span>
          <span><%= @hunt.points %>pts</span>
        </div>
      </div>

      <HuntWeb.ImageButton.button {assigns} text="Upload Signature" />
    </div>
    """
  end

  def afterparty_pic(assigns) do
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
          <span>Screenshot your social post</span>
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
