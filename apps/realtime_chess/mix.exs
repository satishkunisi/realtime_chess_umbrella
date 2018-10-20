defmodule RealtimeChess.MixProject do
  use Mix.Project

  def project do
    [
      app: :realtime_chess,
      version: "0.1.0",
      elixir: "~> 1.7.3-otp-21",
      start_permanent: Mix.env == :prod,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      deps: deps()
   ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {RealtimeChess, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false},
      {:apex, "~>1.2.1"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
