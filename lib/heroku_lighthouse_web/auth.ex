defmodule HerokuLighthouseWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias HerokuLighthouse.Accounts

  def init(opts) do
    opts
  end

  def call(conn, _) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] ->
        put_current_user(conn, user)
      user = user_id && Accounts.get_user!(user_id) ->
        put_current_user(conn, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn) do
    conn
    |> assign(:authenticated, true)
    |> put_session(:authenticated, true)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    conn
    |> configure_session(drop: true)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: HerokuLighthouseWeb.Router.Helpers.page_path(conn, :index))
      |> halt()
    end
  end

  defp put_current_user(conn, user) do
    assign(conn, :current_user, user)
  end
end
