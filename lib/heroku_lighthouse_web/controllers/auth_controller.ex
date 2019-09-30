defmodule HerokuLighthouseWeb.AuthController do
  use HerokuLighthouseWeb, :controller
  alias HerokuLighthouse.HerokuApi.Oauth
  alias HerokuLighthouseWeb.Auth
  alias HerokuLighthouse.Accounts

  def index(conn, %{"code" => code, "state" => anti_forgery_token}) do
    case Accounts.fetch_token_and_account(code) do
      {:ok, %{user: user, token: _}} ->
        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.dashboard_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:warn, gettext("Something went wrong"))
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def destroy(conn, _) do
    conn
    |> Auth.logout()
    |> redirect(to: "/")
  end
end
