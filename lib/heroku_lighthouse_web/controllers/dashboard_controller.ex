defmodule HerokuLighthouseWeb.DashboardController do
  use HerokuLighthouseWeb, :controller
  alias HerokuLighthouse.HerokuEntities.Entities

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  # TODO: add apps to favorites and sort them in first order, show apps without access at the end
  # TODO: add search by heroku app name, github name or domain in my search. Possibly with LiveView
  def index(conn, _params, user) do
    apps_by_team = Entities.cached_grouped_apps(user)
    # |> Enum.filter(fn(app) -> app["name"] == "aon-my-beta" end)

    render(conn, "index.html", account: user, apps_by_team: apps_by_team)
  end
end
