# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :Gearkit, :db, name: "pizzastore"

config :Gearkit, :spKey, value: "hKYFwc76E3p0m0bUsQjQxPolmNnoESlR"

# Configures the endpoint
config :Gearkit, GearkitWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/H0Z7XnE7ag+yDEq1pbm3RVpL/j8I2Ljk4ySJCJ4epRCXg1561VUuGHP2gunH7Xg",
  render_errors: [view: GearkitWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Gearkit.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :cipher, keyphrase: "hKYFwc76E3p0m0bUsQjQxPolmNnoESlR",
                ivphrase: "czJoN1x2m3Z8u36rkc4uFvpEwdB4mjcz",
                magic_token: "kindle1610"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
