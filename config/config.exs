# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :heroku_lighthouse,
  ecto_repos: [HerokuLighthouse.Repo]

# Configures the endpoint
config :heroku_lighthouse, HerokuLighthouseWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cip95rSP7QmfqOZRUXlbxC2leQ9GKgvLgityYEhy8aYMgmYspVY61q3MjKF6mvSy",
  render_errors: [view: HerokuLighthouseWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HerokuLighthouse.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :app, HerokuLighthouse.Repo,
  migration_timestamps: [type: :utc_datetime]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
