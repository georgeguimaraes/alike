defmodule Alike.MixProject do
  use Mix.Project

  def project do
    [
      app: :alike,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Alike",
      description: "Semantic similarity testing for Elixir with the wave operator <~>",
      package: package(),
      docs: docs(),
      source_url: "https://github.com/georgeguimaraes/alike"
    ]
  end

  defp package do
    [
      maintainers: ["George Guimarães"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/georgeguimaraes/alike"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md",
        "LICENSE",
        "guides/getting-started.md",
        "guides/configuration.md",
        "guides/advanced-usage.md",
        "guides/testing-patterns.md"
      ],
      groups_for_extras: [
        Guides: ~r/guides\/.*/
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Alike.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nx, "~> 0.10.0"},
      {:bumblebee, "~> 0.6.3"},
      # GPU acceleration
      {:exla, "~> 0.10.0"},
      {:ex_doc, "~> 0.37", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end
