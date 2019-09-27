defmodule HerokuLighthouseWeb.PageController do
  use HerokuLighthouseWeb, :controller
  alias HerokuLighthouse.HerokuApi.{Client, Oauth}

  def index(conn, _params) do
    # TODO: fix this. move to plug
    token = get_session(conn, :access_token) || conn.assigns[:access_token]
    render(conn, "index.html", access_token: token)
  end

  def callback(conn, %{"code" => code, "state" => anti_forgery_token}) do
    token_response = Oauth.fetch_token(code)

    conn =
      conn
      |> put_session(:access_token, token_response["access_token"])
      |> assign(:access_token, token_response["access_token"])

    # if response.status_code == 200 ...

    # teams = Client.get_teams(conn.assigns[:access_token])

    conn
    |> put_flash(:info, gettext("Logged in successfully!"))
    |> redirect(to: Routes.dashboard_path(conn, :index))
  end

  # TODO: https://devcenter.heroku.com/articles/oauth#token-refresh
end
