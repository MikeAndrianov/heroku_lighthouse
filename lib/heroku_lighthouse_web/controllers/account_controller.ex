defmodule HerokuLighthouseWeb.AccountController do
  use HerokuLighthouseWeb, :controller
  alias HerokuLighthouse.Accounts

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def show(conn, _params, user) do
    render(conn, "show.html")
  end

  def destroy(conn, _params, user) do
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> HerokuLighthouseWeb.Auth.logout
    |> redirect(to: HerokuLighthouseWeb.Router.Helpers.page_path(conn, :index))
  end
end
