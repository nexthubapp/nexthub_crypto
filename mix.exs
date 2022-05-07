defmodule NextHubCrypto.MixProject do
  use Mix.Project

  @source_url "https://github.com/nexthubapp/nexthub_crypto"
  @version "0.1.0"

  def project do
    [
      app: :nexthub_crypto,
      version: @version,
      elixir: "~> 1.13",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "NextHubCrypto",
      source_url: @source_url
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:comeonin, "~> 5.3"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Cryptographic operations library for NextHub"
  end

  defp package do
    [
      name: "nexthub_crypto",
      description: "Cryptographic operation library for NextHub",
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["NextHub, Inc."],
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end
end
