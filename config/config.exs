# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :alternative_chef,
  ecto_repos: [AlternativeChef.Repo]

# Configures the endpoint
config :alternative_chef, AlternativeChefWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kl7BaAA2/JRGPmgmldkZbVwS/Jb+oP9y6FgHtVNZZuCHK823J1CojxwOuL3xJQKl",
  render_errors: [view: AlternativeChefWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: AlternativeChef.PubSub,
  live_view: [signing_salt: "jhgQs2Z+"]

config :alternative_chef, AlternativeChefWeb.Mailer,
  from: "support@mailer.alternativechefnc.com",
  adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ex_twilio,
  account_sid: {:system, "TWILIO_ACCOUNT_SID"},
  auth_token: {:system, "TWILIO_AUTH_TOKEN"}

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
