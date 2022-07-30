defmodule AlternativeChef.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AlternativeChef.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email()
      })
      |> AlternativeChef.Accounts.register_user()

    user
  end

  def user_with_password_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password: valid_user_password()
      })
      |> AlternativeChef.Accounts.register_user()

    user
  end

  def admin_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        admin: "true",
        password: valid_user_password()
      })
      |> AlternativeChef.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured, "[TOKEN]")
    token
  end
end
