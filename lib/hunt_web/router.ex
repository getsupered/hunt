defmodule HuntWeb.Router do
  use HuntWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HuntWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HuntWeb do
    pipe_through :browser

    live "/", HomeLive
    live "/hunt/:hunt_id", HomeLive
    live "/admin", AdminListLive
    live "/admin/pending", AdminPendingLive
    live "/admin/:hunt_id", AdminListLive

    get "/images/:id", ImageController, :serve
    get "/jwt/login", JwtController, :login
  end

  scope "/auth", HuntWeb do
    pipe_through :browser

    get "/logout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", HuntWeb do
  #   pipe_through :api
  # end
end
