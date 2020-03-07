defmodule Gearkit.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(GearkitWeb.Endpoint, []),
      # Start your own worker by calling: Gearkit.Worker.start_link(arg1, arg2, arg3)
      # worker(Gearkit.Worker, [arg1, arg2, arg3]),
      worker(Mongo, [[name: :mongo, database: Application.get_env(:Gearkit, :db)[:name], pool: DBConnection.Poolboy]])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gearkit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GearkitWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defimpl Poison.Encoder, for: BSON.ObjectId do
    def encode(id, options) do
      BSON.ObjectId.encode!(id) |> Poison.Encoder.encode(options)
    end
  end

end
