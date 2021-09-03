defmodule DirtyDriver.MixProject do
  use Mix.Project

  @version "0.0.2"
  @repo_url "https://github.com/joesho112358/DirtyDriver"

  def project do
    [
      app: :dirty_driver,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      elixirc_paths: elixirc_paths(Mix.env),
      deps: deps,

      # Xref
      xref: [
        exclude: [
          :persistent_term
        ]
      ],

      # Hex
      package: package,
      description: "Small webdriver interactions.",

      # Docs
      name: "DirtyDriver",
      docs: [
        source_ref: "v#{@version}",
        source_url: @repo_url,
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :ssl],
      mod: {DirtyDriver.Application, []}
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @repo_url}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:mint, "~> 1.0"},
      {:json, "~> 1.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

end
