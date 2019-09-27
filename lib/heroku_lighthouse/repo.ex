defmodule HerokuLighthouse.Repo do
  use Ecto.Repo,
    otp_app: :heroku_lighthouse,
    adapter: Ecto.Adapters.Postgres
end
