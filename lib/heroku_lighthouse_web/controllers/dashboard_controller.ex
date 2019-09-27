defmodule HerokuLighthouseWeb.DashboardController do
  use HerokuLighthouseWeb, :controller
  alias HerokuLighthouse.HerokuApi.Client

  # TODO: make it only for logged in users
  # TODO: add apps to favorites and sort them in first order, show apps without access at the end
  # TODO: add search by heroku app name, github name or domain in my search. Possibly with LiveView
  def index(conn, _params) do
    # TODO: fix this. move to plug
    token = get_session(conn, :access_token) || conn.assigns[:access_token]
    account = Client.get_account(token)

    apps = Client.team_app_list_by_team(token, "coverwallet")
    # |> Enum.filter(fn(app) -> app["name"] == "aon-my-beta" end)

    render(conn, "index.html", account: account, apps: apps)
  end
end
