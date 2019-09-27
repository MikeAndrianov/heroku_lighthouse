defmodule HerokuLighthouseWeb.AuthController do
  use HerokuLighthouseWeb, :controller
  alias HerokuLighthouse.HerokuApi.Oauth

  def index(conn, %{"code" => code, "state" => anti_forgery_token}) do
    token_response = Oauth.fetch_token(code)

    conn =
      conn
      |> put_session(:access_token, token_response["access_token"])
      # |> assign(:access_token, token_response["access_token"])

    # teams = Client.get_teams(conn.assigns[:access_token])

    conn
    |> put_flash(:info, gettext("Logged in successfully!"))
    |> redirect(to: Routes.dashboard_path(conn, :index))
  end
end
