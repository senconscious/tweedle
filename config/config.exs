# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :tweedle,
  ecto_repos: [Tweedle.Repo]

# Configures the endpoint
config :tweedle, TweedleWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: TweedleWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Tweedle.PubSub,
  live_view: [signing_salt: "gqLly6ue"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tweedle, Tweedle.Auth.Guardian,
  issuer: "tweedle",
  secret_key: "oiL4QOWG9RWr1qJKJNvYZpHAK8lu/93Hj3CIZXRfbwbMFKGWjjiyi3L/tUbicEeh"

config :guardian, Guardian.DB, repo: Tweedle.Repo

config :tweedle, TweedleWeb.Pipelines.AuthorizedAccess,
  module: Tweedle.Auth.Guardian,
  error_handler: TweedleWeb.Helpers.AuthErrorHandler

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
