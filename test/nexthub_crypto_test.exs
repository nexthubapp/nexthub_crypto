defmodule NextHubCryptoTest do
  use ExUnit.Case
  doctest NextHubCrypto

  import Comeonin.BehaviourTestHelper

  test "implementation of Comeonin.PasswordHash behaviour" do
    password = Enum.random(ascii_passwords())
    assert correct_password_true(NextHubCrypto, password)
    assert wrong_password_false(NextHubCrypto, password)
  end

  test "Comeonin.PasswordHash behaviour with non-ascii characters" do
    password = Enum.random(non_ascii_passwords())
    assert correct_password_true(NextHubCrypto, password)
    assert wrong_password_false(NextHubCrypto, password)
  end

  test "hash_pwd_salt only contains alphanumeric characters" do
    assert String.match?(NextHubCrypto.hash_pwd_salt("password"), ~r/^[A-Za-z0-9.$\/\-]*$/)

    assert String.match?(
             NextHubCrypto.hash_pwd_salt("password", format: :django),
             ~r/^[A-Za-z0-9+$_=\/]*$/
           )

    assert String.match?(NextHubCrypto.hash_pwd_salt("password", format: :hex), ~r/^[A-Za-z0-9]*$/)
  end

  test "hashes with different lengths are correctly created and verified" do
    hash = NextHubCrypto.hash_pwd_salt("password", length: 128)
    assert NextHubCrypto.verify_pass("password", hash) == true
    django_hash = NextHubCrypto.hash_pwd_salt("password", length: 128, format: :django)
    assert NextHubCrypto.verify_pass("password", django_hash) == true
  end

  test "hashes with different number of rounds are correctly created and verified" do
    hash = NextHubCrypto.hash_pwd_salt("password", rounds: 100_000)
    assert NextHubCrypto.verify_pass("password", hash) == true
    django_hash = NextHubCrypto.hash_pwd_salt("password", rounds: 10000, format: :django)
    assert NextHubCrypto.verify_pass("password", django_hash) == true
  end

  # tests for deprecated functions
  test "add_hash function" do
    password = Enum.random(ascii_passwords())
    assert add_hash_creates_map(NextHubCrypto, password)
  end

  test "check_pass function" do
    password = Enum.random(ascii_passwords())
    assert check_pass_returns_user(NextHubCrypto, password)
    assert check_pass_returns_error(NextHubCrypto, password)
    assert check_pass_nil_user(NextHubCrypto)
  end

  test "add_hash and check_pass" do
    assert {:ok, user} = NextHubCrypto.add_hash("password") |> NextHubCrypto.check_pass("password")
    assert {:error, "invalid password"} = NextHubCrypto.add_hash("pass") |> NextHubCrypto.check_pass("password")
    assert Map.has_key?(user, :password_hash)
  end

  test "add_hash with a custom hash_key and check_pass" do
    assert {:ok, user} =
             NextHubCrypto.add_hash("password", hash_key: :encrypted_password)
             |> NextHubCrypto.check_pass("password")

    assert {:error, "invalid password"} =
             NextHubCrypto.add_hash("pass", hash_key: :encrypted_password)
             |> NextHubCrypto.check_pass("password")

    assert Map.has_key?(user, :encrypted_password)
  end

  test "check_pass with custom hash_key" do
    assert {:ok, user} =
             NextHubCrypto.add_hash("password", hash_key: :custom_hash)
             |> NextHubCrypto.check_pass("password", hash_key: :custom_hash)

    assert Map.has_key?(user, :custom_hash)
  end

  test "check_pass with invalid hash_key" do
    {:error, message} =
      NextHubCrypto.add_hash("password", hash_key: :unconventional_name)
      |> NextHubCrypto.check_pass("password")

    assert message =~ "no password hash found"
  end

  test "check_pass with password that is not a string" do
    assert {:error, message} = NextHubCrypto.add_hash("pass") |> NextHubCrypto.check_pass(nil)
    assert message =~ "password is not a string"
  end
end
