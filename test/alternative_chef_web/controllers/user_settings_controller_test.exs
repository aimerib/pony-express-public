defmodule AlternativeChefWeb.UserSettingsControllerTest do
  use AlternativeChefWeb.ConnCase, async: true

  alias AlternativeChef.Accounts
  import AlternativeChef.AccountsFixtures

  setup :register_and_log_in_user

  describe "GET /users/settings/:id" do
    test "renders settings page", %{conn: conn} do
      user = user_fixture()
      conn = get(conn, Routes.user_settings_path(conn, :edit, user))
      response = html_response(conn, 200)
      assert response =~ "Settings</h1>"
    end

    test "redirects if user is not logged in" do
      user = user_fixture()
      conn = build_conn()
      conn = get(conn, Routes.user_settings_path(conn, :edit, user))
      assert redirected_to(conn) == Routes.user_session_path(conn, :new)
    end
  end

  describe "PUT /users/settings/update_password" do
    test "updates the user password and resets tokens", %{conn: conn} do
      user = user_with_password_fixture()

      new_password_conn =
        conn
        |> log_in_user(user)
        |> put(Routes.user_settings_path(conn, :update_password), %{
          "current_password" => valid_user_password(),
          "user" => %{
            "password" => "new valid password",
            "password_confirmation" => "new valid password"
          }
        })

      assert redirected_to(new_password_conn) ==
               Routes.user_settings_path(conn, :edit, user)

      assert get_session(new_password_conn, :user_token) != get_session(conn, :user_token)
      assert get_flash(new_password_conn, :info) =~ "Password updated successfully"
      assert Accounts.get_user_by_email_and_password(user.email, "new valid password")
    end

    test "does not update password on invalid data", %{conn: conn} do
      old_password_conn =
        put(conn, Routes.user_settings_path(conn, :update_password), %{
          "current_password" => "invalid",
          "user" => %{
            "password" => "short",
            "password_confirmation" => "does not match"
          }
        })

      response = html_response(old_password_conn, 200)
      assert response =~ "Settings</h1>"
      assert response =~ "Send an email with instructions to reset password.</span>"

      assert get_session(old_password_conn, :user_token) == get_session(conn, :user_token)
    end
  end
end
