defmodule AlternativeChefWeb.UserRegistrationController do
  use AlternativeChefWeb, :controller

  alias AlternativeChef.Accounts
  alias AlternativeChef.Accounts.User

  def index(conn, _params) do
    render(conn, "index.html", users: Accounts.list_users())
  end

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_new_user_instructions(
            user,
            &Routes.user_reset_password_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_registration_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_registration_path(conn, :index))
  end
end
