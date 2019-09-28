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

  # def list_apps(user) do
  #   user
  #   |> list_teams
  #   |> Enum.flat_map(&Client.team_app_list_by_team(Accounts.access_token(user), &1["id"]))
  # end

  # %{ team_name: [apps], ...}
  def grouped_apps(user) do
    #TODO: add personal
    user
    |> list_teams
    |> Map.new(fn team ->
      {team["name"], Client.team_app_list_by_team(Accounts.access_token(user), team["id"])}
    end)
    |> Map.put(%{"name" => "Personal"}, personal_apps(user))
    # |> Enum.reject(fn({_, apps}) -> length(apps) == 0 end)
  end

  defp personal_apps(user) do
    user
    |> Accounts.access_token()
    |> Client.app_list()
  end
end
