defmodule Hunt.Activity.Supered do
  use HuntWeb, :verified_routes
  use HuntWeb, :html

  def title do
    "Supered Admin"
  end

  def image do
    %{
      src: ~p"/images/supered2.png",
      class: "!object-contain p-2"
    }
  end

  def total_points do
    activity_sum = activities() |> Enum.map(& &1.points) |> Enum.sum()
    activity_sum + achievement().points
  end

  def achievement do
    %{
      title: "Achievement: Supered Admin",
      points: 1500
    }
  end

  @activities [
                %{
                  id: "eca91e9f-b6e3-44ac-9e1e-3c14b77236b9",
                  title: "2. Create and Embed a Supered Card in HubSpot",
                  action: "Level up your HubSpot with embedded processes",
                  points: 100,
                  component: &__MODULE__.embed_card/1,
                  completion: Hunt.Activity.Completion.Answer.expected("View in Sidebar")
                },
                %{
                  id: "462e51d1-01e7-40d0-b36c-1a258b696a30",
                  title: "3. Create a Supered Process Rule for HubSpot",
                  action: "Alert your reps to invalid data or processes",
                  points: 100,
                  component: &__MODULE__.process_rule/1,
                  completion: Hunt.Activity.Completion.Answer.expected("Logic")
                },
                %{
                  id: "a232e526-ad95-4956-b0dd-b52b3b110fc1",
                  title: "1. Connect Supered and Hubspot",
                  action: "Supered charge your HubSpot account",
                  points: 300,
                  component: &__MODULE__.connect_hubspot/1,
                  completion: Hunt.Activity.Completion.Answer.expected("Sync Fields")
                },
                %{
                  id: "a28153ab-fca1-4bed-a956-7971012987ea",
                  title: "4. Send us a few sentences on how you'd use Supered",
                  action: "We'd love to hear your thoughts!",
                  points: 200,
                  component: &__MODULE__.use_supered/1,
                  completion: Hunt.Activity.Completion.Answer.expected(:any)
                }
                # %{
                #   id: "d5705849-ec91-4edc-bdd6-99404416afbf",
                #   title: "Create and Post How-To Video",
                #   action: "",
                #   points: 300,
                #   component: &__MODULE__.post_video/1
                # },
              ]
              |> Enum.sort_by(& &1.title)

  def activities, do: @activities

  def embed_card(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href="https://app.supered.io" target="_blank" class="btn btn-muted text-xl">Supered Login</a>
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
              Complete: What phrase is shown at the bottom of an embedded card?
            </label>
            <input required name="answer" type="text" placeholder="Hint: ViS" class="w-full form-input" />
          </div>

          <button class="btn btn-primary btn-big w-full block text-2xl">
            Submit Answer
          </button>
        </.form>
      </HuntWeb.LoggedInForm.wrap>
    </div>
    """
  end

  def process_rule(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href="https://app.supered.io" target="_blank" class="btn btn-muted text-xl">Supered Login</a>
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
              Complete: What is the third tab in "Build Rule"?
            </label>
            <input required name="answer" type="text" placeholder="Hint: L" class="w-full form-input" />
          </div>

          <button class="btn btn-primary btn-big w-full block text-2xl">
            Submit Answer
          </button>
        </.form>
      </HuntWeb.LoggedInForm.wrap>
    </div>
    """
  end

  def connect_hubspot(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href="https://app.supered.io" target="_blank" class="btn btn-muted text-xl">Supered Login</a>
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
              Complete: After connecting to HubSpot, what does the top button of "Data Dictionary" say?
            </label>
            <input required name="answer" type="text" placeholder="Hint: SF" class="w-full form-input" />
          </div>

          <button class="btn btn-primary btn-big w-full block text-2xl">
            Submit Answer
          </button>
        </.form>
      </HuntWeb.LoggedInForm.wrap>
    </div>
    """
  end

  def post_video(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

        <div>
          <a href="https://www.linkedin.com/company/getsupered" target="_blank" class="btn btn-muted text-xl">LinkedIn</a>
        </div>

        <div>
          <span class="font-semibold">Create: </span>
          <span>A how-to video about using Supered. Here are some ideas:</span>
          <ul>
            <li>Creating a card and showing it in HubSpot</li>
            <li>Setting up a process rule on a deal</li>
            <li>Embedding Supered into other applications</li>
          </ul>
        </div>

        <div>
          <span class="font-semibold">Write: </span>
          <span>A LinkedIn post with your video in it</span>
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

      <HuntWeb.ImageButton.button {assigns} />
    </div>
    """
  end

  def use_supered(assigns) do
    ~H"""
    <div class="h-full flex flex-col">
      <div class="flex-grow prose text-xl space-y-4">
        <h2 class="max-w-[calc(100%-3rem)]"><%= @hunt.title %></h2>

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
              Complete: How would you use Supered at your company?
            </label>
            <textarea required name="answer" class="w-full form-input" rows="3" placeholder="Give us a few sentences, we're curious!" />
          </div>

          <button class="btn btn-primary btn-big w-full block text-2xl">
            Submit Answer
          </button>
        </.form>
      </HuntWeb.LoggedInForm.wrap>
    </div>
    """
  end
end
