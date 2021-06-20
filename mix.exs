defmodule Expletive.Mixfile do
  use Mix.Project

  def project do
    [
      app: :expletive,
      version: "0.1.5",
      elixir: "~> 1.0",
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/xavier/expletive",
      homepage_url: "https://github.com/xavier/expletive"
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
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
    [{:earmark, "~> 0.1", only: :dev}, {:ex_doc, "0.6.0", only: :dev}]
  end

  defp description do
    "Profanity detection and sanitization library"
  end

  defp package do
    [
      files: ["lib", "data", "priv", "mix.exs", "README*", "LICENSE*"],
      contributors: ["Xavier Defrang"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/xavier/expletive"}
    ]
  end
end
