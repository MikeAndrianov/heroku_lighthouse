defmodule HerokuLighthouse.HerokuApi.Oauth do
  use HTTPoison.Base

  @base_url "https://id.heroku.com"
  # TODO: move to .env
  @client_secret "c7fd8800-2842-4ca4-b11d-ba8556fa7af4"

  def process_request_url(url) do
    @base_url <> url
  end

  def process_response_body(""), do: ""
  def process_response_body(body), do: Poison.decode!(body)

  # https://devcenter.heroku.com/articles/oauth
  # %{
  #   "access_token" => "27fc651d-6bd1-42bd-b835-d90ba7d478d8",
  #   "expires_in" => 28799,
  #   "refresh_token" => "505affd1-2378-46fe-8baa-74775261f721",
  #   "session_nonce" => nil,
  #   "token_type" => "Bearer",
  #   "user_id" => "9f8d9141-9afe-45c0-ae08-993b6db5d301"
  # }
  def fetch_token(code) do
    post_params = [
      grant_type: "authorization_code",
      code: code,
      client_secret: @client_secret
    ]

    __MODULE__.post!(
      "/oauth/token",
      URI.encode_query(post_params),
      %{"Content-Type" => "application/x-www-form-urlencoded"}
    ).body
  end

  def token_refresh(refresh_token) do
    post_params = [
      grant_type: "refresh_token",
      refresh_token: refresh_token,
      client_secret: @client_secret
    ]

    __MODULE__.post!(
      "/oauth/token",
      URI.encode_query(post_params),
      %{"Content-Type" => "application/x-www-form-urlencoded"}
    ).body
  end
end
