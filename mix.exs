defmodule Alike.MixProject do
  use Mix.Project

  def project do
    [
      app: :alike,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:nx, "~> 0.9.0"},
      {:bumblebee, "~> 0.6.0"},
      # GPU acceleration
      {:exla, "~> 0.9.0"},
      {:ex_doc, "~> 0.37", only: :dev, runtime: false}
    ]
  end
end
