defmodule Exutils.Mixfile do
  use Mix.Project

  def project do
    [app: :exutils,
     version: "0.0.1",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :econfig]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:econfig, github: "benoitc/econfig"},
      {:meck, github: "eproxus/meck", only: :test},
    ]
  end
end
