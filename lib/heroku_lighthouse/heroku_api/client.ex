defmodule HerokuLighthouse.HerokuApi.Client do
  use HTTPoison.Base

  alias HerokuLighthouse.HerokuEntities.{Application, Domain, Team}

  # https://devcenter.heroku.com/articles/platform-api-reference

  @base_url "https://api.heroku.com"

  def process_request_url(url), do: @base_url <> url

  def get_account(auth_token) do
    get!("/account", headers(auth_token)).body
    |> Poison.decode!()
  end

  def get_teams(auth_token) do
    get!("/teams", headers(auth_token)).body
    |> Poison.decode!(as: [%Team{}])
  end

  def team_app_list_by_team(auth_token, team_name_or_id) do
    get!("/teams/#{team_name_or_id}/apps", headers(auth_token)).body
    |> Poison.decode!(as: [%Application{}])
  end

  def app_list(auth_token) do
    get!("/apps", headers(auth_token)).body
    |> Poison.decode!(as: [%Application{}])
  end

  def get_domains_for_app(auth_token, app_id_or_name) do
    case get!("/apps/#{app_id_or_name}/domains", headers(auth_token)) do
      %{status_code: 403} ->
        [%Domain{hostname: "No access"}]

      %{status_code: 404} ->
        [%Domain{hostname: "No access"}]

      response ->
        Poison.decode!(response.body, as: [%Domain{}])
    end
  end

  defp headers(auth_token) do
    [
      Authorization: "Bearer #{auth_token}",
      Accept: "application/vnd.heroku+json; version=3"
    ]
  end
end
