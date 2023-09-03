defmodule HuntWeb.HuntRender do
  use HuntWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <%= @hunt.component.(%{hunt: @hunt, completed: @completion}) %>
    </div>
    """
  end
end
