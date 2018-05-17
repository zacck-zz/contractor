# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :contractor,
  ecto_repos: [Contractor.Repo]

# Configures the endpoint
config :contractor, ContractorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "01uumd810yQUcp8XnBtrnFSRI0hL+/KDvBtPEXnpAJlHqgwH8T6lecAUGoBjqnVF",
  render_errors: [view: ContractorWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Contractor.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


# Configures Guardian
config :contractor, Contractor.Auth.Guardian,
  issuer: "VoldersContractor",
  secret_key: "beruUwLdnIf2R+0UWcswHsrUJzU7ipfDyfH1sxdpuHpO6tAzLzWsvY6sfxYmx0ia"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
