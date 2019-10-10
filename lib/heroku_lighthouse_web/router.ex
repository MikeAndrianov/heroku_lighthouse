defmodule HerokuLighthouseWeb.Router do
  use HerokuLighthouseWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HerokuLighthouseWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HerokuLighthouseWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/auth/callback", AuthController, :index
  end

  scope "/", HerokuLighthouseWeb do
    pipe_through [:browser, :authenticate_user]

    delete "/logout", AuthController, :destroy
    get "/dashboard", DashboardController, :index
    get "/account", AccountController, :show
    delete "/account", AccountController, :destroy
  end

  # Other scopes may use custom stacks.
  # scope "/api", HerokuLighthouseWeb do
  #   pipe_through :api
  # end
end
