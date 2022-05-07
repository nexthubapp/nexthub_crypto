# nexthub_crypto

NextHubCrypto is an internal service we use to manage cryptographic operations like hashing and comparing passwords and sensible data, with a modified algorithm based in Pbkdf2.

## Installation
Add the dependency in your `mix.exs`:

```elixir
def deps do
  [
    {:nexthub_crypto, "~> 0.1.0"}
  ]
end
```

## Why is this open source?
We open source parts of the NextHub source code to be transparent with our users and give an example for people interested in learning new technologies like Elixir to go off.