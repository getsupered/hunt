defmodule Hunt.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      HuntWeb.Telemetry,
      # Start the Ecto repository
      Hunt.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Hunt.PubSub},
      Hunt.Activity.Leaderboard,
      # Start the Endpoint (http/https)
      HuntWeb.Endpoint
      # Start a worker by calling: Hunt.Worker.start_link(arg)
      # {Hunt.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hunt.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HuntWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
