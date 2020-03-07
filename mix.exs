defmodule Gearkit.Mixfile do
  use Mix.Project

  def project do
    [
      app: :Gearkit,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Gearkit.Application, []},
      extra_applications: [:logger, :runtime_tools,:mongodb, :poolboy, :calendar, :phoenix_ecto]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, ">= 1.4.14"},
      {:phoenix_pubsub, ">= 1.1.2"},
      {:phoenix_html, ">= 2.14.0"},
      {:gettext, ">= 0.17.4"},
      {:cowboy, "~> 2.7.0"},
      {:plug_cowboy, "~> 2.1.2"},
      {:mongodb, ">= 0.5.1"},
      {:poolboy, ">= 1.5.2"},
      {:json, ">= 1.3.0"},
      {:calendar, ">= 1.0.0"},
      {:cors_plug, "~> 2.0.2"},
      {:json_web_token, "~> 0.2"},
      {:cipher, ">= 1.4.0"},
      {:phoenix_ecto, "~> 4.1.0"},
      {:joken, "~> 2.2.0"}
    ]
  end
end
