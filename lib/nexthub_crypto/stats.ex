defmodule NextHubCrypto.Stats do
  alias NextHubCrypto.Base64

  def report(opts \\ []) do
    password = Keyword.get(opts, :password, "password")
    salt = Keyword.get(opts, :salt, "somesaltSOMESALT")
    {exec_time, encoded} = :timer.tc(NextHubCrypto.Base, :hash_password, [password, salt, opts])

    NextHubCrypto.verify_pass(password, encoded)
    |> format_result(encoded, exec_time)
  end

  defp format_result(check, encoded, exec_time) do
    [alg, rounds, _, hash] = String.split(encoded, "$", trim: true)

    IO.puts("""
    Digest:\t\t#{alg}
    Digest length:\t#{digest_length(encoded, hash)}
    Hash:\t\t#{encoded}
    Rounds:\t\t#{rounds}
    Time taken:\t#{format_time(exec_time)} seconds
    Verification #{if check, do: "OK", else: "FAILED"}
    """)
  end

  defp digest_length("$nexthub_crypto" <> _, hash), do: Base64.decode(hash) |> byte_size
  defp digest_length("nexthub_crypto" <> _, hash), do: Base.decode64!(hash) |> byte_size

  defp format_time(time) do
    Float.round(time / 1_000_000, 2)
  end
end
