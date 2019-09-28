defmodule HerokuLighthouse.HerokuApi.Client do
  use HTTPoison.Base

  # @base_url "https://api.heroku.com"

  def process_request_url(url) do
    "https://api.heroku.com" <> url
  end

  def process_response_body(body), do: Poison.decode!(body)

  # https://devcenter.heroku.com/articles/platform-api-reference#account
  def get_account(auth_token) do
    __MODULE__.get!("/account", headers(auth_token)).body
  end

  def get_teams(auth_token), do: __MODULE__.get!("/teams", headers(auth_token)).body

  # TODO: fetch also self apps
  # returns:
  # [%{
  #   "acm" => true,
  #   "archived_at" => nil,
  #   "build_stack" => %{
  #     "id" => "69bee368-352b-4bd0-9b7c-819d860a2588",
  #     "name" => "heroku-18"
  #   },
  #   "buildpack_provided_description" => "Node.js,Ruby",
  #   "created_at" => "2019-07-02T20:23:21Z",
  #   "git_url" => "https://git.heroku.com/aon-backend-binder.git",
  #   "id" => "3ab80c80-3928-47d3-b5fd-5b820942fe59",
  #   "internal_routing" => nil,
  #   "joined" => false,
  #   "legacy_id" => "app138559411@heroku.com",
  #   "locked" => false,
  #   "maintenance" => false,
  #   "name" => "aon-backend-binder",
  #   "organization" => %{
  #     "id" => "30b3ba81-7df0-4ee2-aa8d-ff82aa852231",
  #     "name" => "coverwallet"
  #   },
  #   "owner" => %{
  #     "email" => "coverwallet@herokumanager.com",
  #     "id" => "30b3ba81-7df0-4ee2-aa8d-ff82aa852231"
  #   },
  #   "region" => %{"id" => "59accabd-516d-4f0e-83e6-6e3757701145", "name" => "us"},
  #   "released_at" => "2019-09-26T08:51:13Z",
  #   "repo_size" => nil,
  #   "slug_size" => 80575047,
  #   "space" => nil,
  #   "stack" => %{
  #     "id" => "ee582d3c-717d-4a57-ba5f-8b3a39f3a817",
  #     "name" => "heroku-16"
  #   },
  #   "team" => %{
  #     "id" => "30b3ba81-7df0-4ee2-aa8d-ff82aa852231",
  #     "name" => "coverwallet"
  #   },
  #   "updated_at" => "2019-09-26T08:51:30Z",
  #   "web_url" => "https://aon-backend-binder.herokuapp.com/"
  # }]
  def team_app_list_by_team(auth_token, team_name_or_id) do
    __MODULE__.get!("/teams/#{team_name_or_id}/apps", headers(auth_token)).body
  end

  def app_list(auth_token) do
    __MODULE__.get!("/apps", headers(auth_token)).body
  end

  # TODO: check response status. Can be forbidden on not found.
  def get_domains_for_app(auth_token, app_id_or_name) do
    __MODULE__.get!("/apps/#{app_id_or_name}/domains", headers(auth_token)).body
  end

  def headers(auth_token) do
    [
      Authorization: "Bearer #{auth_token}",
      Accept: "application/vnd.heroku+json; version=3"
    ]
  end
end
