defmodule AlternativeChef.Accounts.UserNotifier do
  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_new_user_instructions(user, url) do
    email = AlternativeChefWeb.UserEmail.new_user_email(user, url)
    %Swoosh.Email{assigns: %{url: url}} = email

    email
    |> AlternativeChefWeb.Mailer.deliver()
    |> case do
      {:ok, _} -> {:ok, url}
      {_, _} -> {:error, :email_failed_to_deliver}
    end
  end

  @doc """
  Deliver instructions to reset a user password.
  """

  def deliver_reset_password_instructions(user, url) do
    email = AlternativeChefWeb.UserEmail.password_reset(user, url)
    %Swoosh.Email{assigns: %{url: url}} = email

    email
    |> AlternativeChefWeb.Mailer.deliver()
    |> case do
      {:ok, _} -> {:ok, url}
      {_, _} -> {:error, :email_failed_to_deliver}
    end
  end
end
