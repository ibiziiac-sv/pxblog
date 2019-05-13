defmodule Pxblog.Mixfile do
  use Mix.Project

  def project do
    [app: :pxblog,
     version: "1.1.0",
     elixir: "~> 1.8.1",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Pxblog.Application, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :ecto_sql, :postgrex, :comeonin, :phoenix_swoosh, :ex_machina]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.4.4"},
     {:phoenix_pubsub, "~> 1.0"},
     {:ecto_sql, "~> 3.0"},
     {:phoenix_ecto, "~> 4.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.10"},
     {:jason, "~> 1.0"},
     {:gettext, "~> 0.16.1"},
     {:plug_cowboy, "~> 2.0"},
     {:plug, "~> 1.7"},
     {:comeonin, "~> 5.1.2"},
     {:bcrypt_elixir, "~> 2.0.3"},
     {:canary, "~> 1.1.1"},
     {:phoenix_swoosh, "~> 0.2"},
     {:ex_machina, "~> 2.3.0"},
     {:earmark, "~> 1.3.2"},
     {:timex, "~> 3.5.0"},
     {:phoenix_slime, "~> 0.12"},
     {:breadcrumble, "~> 1.0.4"},
     {:phoenix_live_reload, "~> 1.2", only: :dev},
     {:mix_test_watch, "~> 0.9", only: :dev, runtime: false},
     {:credo, "~> 1.0.5", only: [:dev, :test], runtime: false}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     test: ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
