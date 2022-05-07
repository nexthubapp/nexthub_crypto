defmodule NextHubCrypto.ReferenceTest do
  use ExUnit.Case

  alias NextHubCrypto.Base

  def read_file_and_run_tests(filename, digest) do
    tests =
      Path.expand("support/#{filename}", __DIR__)
      |> File.read!()
      |> String.split("\n", trim: true)

    for t <- tests do
      [password, salt, iterations, dklen, hash] = String.split(t, ",", trim: true)
      rounds = String.to_integer(iterations)
      length = String.to_integer(dklen)

      assert Base.hash_password(
               password,
               salt,
               rounds: rounds,
               digest: digest,
               length: length,
               format: :hex
             ) == hash
    end
  end

  test "sha256 reference tests" do
    read_file_and_run_tests("nexthub_crypto_sha256_test_vectors", :sha256)
  end

  test "sha512 reference tests" do
    read_file_and_run_tests("nexthub_crypto_sha512_test_vectors", :sha512)
  end
end
