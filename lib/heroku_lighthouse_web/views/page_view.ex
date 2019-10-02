defmodule HerokuLighthouseWeb.PageView do
  use HerokuLighthouseWeb, :view

  def sign_in_link(conn) do
    if conn.assigns.current_user do
      link("Go to Dashboard",
        to: HerokuLighthouseWeb.Router.Helpers.dashboard_path(conn, :index),
        class: "button button-large"
      )
    else
      link("Sign in with Heroku",
        to:
          "https://id.heroku.com/oauth/authorize?client_id=94405156-0a36-487e-ba56-92349207a72e&response_type=code&scope=read&state=#{
            Plug.CSRFProtection.get_csrf_token()
          }",
        class: "button button-large"
      )
    end
  end
end
