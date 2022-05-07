defmodule NextHubCrypto do
  use Comeonin
  alias NextHubCrypto.Base

  @impl true
  def hash_pwd_salt(password, opts \\ []) do
    Base.hash_password(password, Base.gen_salt(opts), opts)
  end

  @impl true
  def verify_pass(password, stored_hash) do
    [alg, rounds, salt, hash] = String.split(stored_hash, "$", trim: true)
    digest = if alg =~ "sha512", do: :sha512, else: :sha256
    Base.verify_pass(password, hash, salt, digest, rounds, output(stored_hash))
  end

  defp output("$nexthub_crypto" <> _), do: :modular
  defp output("nexthub_crypto" <> _), do: :django
end
