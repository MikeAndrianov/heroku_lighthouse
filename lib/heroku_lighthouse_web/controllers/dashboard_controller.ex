defmodule HerokuLighthouseWeb.DashboardController do
  use HerokuLighthouseWeb, :controller
  alias HerokuLighthouse.Dashboard
  alias Phoenix.LiveView
  alias HerokuLighthouseWeb.DashboardLive.Index

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  # TODO: add apps to favorites and sort them in first order, show apps without access at the end
  # TODO: add search by heroku app name, github name or domain in my search. Possibly with LiveView
  def index(conn, _params, user) do
    LiveView.Controller.live_render(conn, Index, session: %{user: user})
  end
end
