defmodule HerokuLighthouse.HerokuEntities.Entities do
  import Ecto.Query, warn: false
  alias HerokuLighthouse.Repo
  alias HerokuLighthouse.HerokuApi.Client
  alias HerokuLighthouse.Accounts.{User}
  alias HerokuLighthouse.Accounts

  def list_teams(user) do
    user
    |> Accounts.access_token()
    |> Client.get_teams()
  end

  # %{ team_name: [apps], ...}
  def grouped_apps(user) do
    user
    |> list_teams
    |> fetch_apps_for_teams(user)
    |> Map.put(%{"name" => "Personal"}, personal_apps(user))
    |> Enum.reject(fn {_, apps} -> length(apps) == 0 end)
    |> Enum.map(fn {team, apps} -> {team, put_domains_to_apps(apps, user)} end)
  end

  defp fetch_apps_for_teams(teams, user) do
    Map.new(teams, fn team -> {team, team_apps(team, user)} end)
  end

  defp team_apps_with_domains(team, user) do
    team
    |> team_apps(user)
    |> Enum.map(fn app -> Map.put(app, "domains", app_domains(app, user)) end)
  end

  defp team_apps(team, user) do
    user
    |> Accounts.access_token()
    |> Client.team_app_list_by_team(team["id"])
  end

  defp put_domains_to_apps(apps, user) do
    apps
    |> Enum.map(&(Map.put(&1, "domains", app_domains(&1, user))))
  end

  defp app_domains(app, user) do
    response = user
              |> Accounts.access_token()
              |> Client.get_domains_for_app(app["id"])

    if is_map(response) do
      ["No access"]
    else
      Enum.map(response, fn domain -> domain["hostname"] end)
    end
  end

  # TODO: personal also include shared by team apps. remove them from personal
  defp personal_apps(user) do
    user
    |> Accounts.access_token()
    |> Client.app_list()
    |> Enum.reject(&(&1["team"]))
  end
end
