defmodule HerokuLighthouseWeb.PageView do
  use HerokuLighthouseWeb, :view
  alias HerokuLighthouse.HerokuApi.Oauth

  def sign_in_link(conn) do
    if conn.assigns.current_user do
      link("Go to Dashboard",
        to: HerokuLighthouseWeb.Router.Helpers.dashboard_path(conn, :index),
        class: "button button-large"
      )
    else
      link("Sign in with Heroku",
        to:
          "https://id.heroku.com/oauth/authorize?client_id=#{System.get_env("HEROKU_CLIENT_ID")}&response_type=code&scope=read&state=#{
            Plug.CSRFProtection.get_csrf_token()
          }",
        class: "button button-large"
      )
    end
  end
end
