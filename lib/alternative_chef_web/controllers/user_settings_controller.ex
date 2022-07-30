defmodule AlternativeChefWeb.UserSettingsController do
  use AlternativeChefWeb, :controller

  alias AlternativeChef.Accounts
  alias AlternativeChefWeb.UserAuth

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.user_admin_changeset(user, %{admin: ""})
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def make_admin(conn, %{"user" => %{"admin" => admin?, "email" => email}}) do
    user = conn.assigns.current_user
    user_to_promote = Accounts.get_user_by_email(email)

    changed? = to_string(user_to_promote.admin) != admin?

    message =
      case admin? do
        "true" -> "User promoted to admin."
        "false" -> "User changed to basic user."
      end

    if user.admin && changed? do
      case Accounts.make_user_admin(user_to_promote, %{admin: admin?}) do
        {:ok, promoted_user} ->
          conn
          |> put_flash(:info, message)
          |> redirect(to: Routes.user_settings_path(conn, :edit, promoted_user.id))

        {:error, _} ->
          render(conn, "edit.html")
      end
    else
      conn
      |> put_flash(:info, "Nothing changed. Nothing ever changes.")
      |> redirect(to: Routes.user_settings_path(conn, :edit, user_to_promote.id))
    end
  end

  def update_password(conn, %{"current_password" => password, "user" => user_params}) do
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit, user.id))
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def redirect_to_users(conn, _params) do
    conn |> redirect(to: Routes.user_registration_path(conn, :index))
  end
end
