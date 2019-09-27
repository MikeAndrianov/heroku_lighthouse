defmodule HerokuLighthouse.Dashboards do
  alias HerokuLighthouse.HerokuApi.Client

  def list_teams(user) do
  end

  def list_apps(user, %Team{name: name}) do
    Client.team_app_list_by_team(token, name)
  end
end
