# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :rainforest,
  ecto_repos: [Rainforest.Repo]

# Configures the endpoint
config :rainforest, RainforestWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3x2z0h4UPm0MP1LLe683VrjGu2K3XD9aE4o/ug9/uCwBmQMWpuNYjPlf5gesy3B4",
  render_errors: [view: RainforestWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Rainforest.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
