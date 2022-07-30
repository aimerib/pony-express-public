defmodule AlternativeChefWeb.UserRegistrationControllerTest do
  use AlternativeChefWeb.ConnCase, async: true

  import AlternativeChef.AccountsFixtures

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn =
        conn |> log_in_user(admin_fixture()) |> get(Routes.user_registration_path(conn, :new))

      assert html_response(conn, 200) =~ "Register</h1>"
    end

    test "redirects if user not admin", %{conn: conn} do
      conn =
        conn
        |> log_in_user(user_with_password_fixture())
        |> get(Routes.user_registration_path(conn, :new))

      assert redirected_to(conn) == Routes.user_session_path(conn, :new)
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and redirects to users list", %{conn: conn} do
      email = unique_user_email()

      conn =
        conn
        |> log_in_user(admin_fixture())
        |> post(Routes.user_registration_path(conn, :create), %{
          "user" => %{"email" => email}
        })

      assert redirected_to(conn) == Routes.user_registration_path(conn, :index)

      # Now check that new user is present
      conn = get(conn, "/users")
      response = html_response(conn, 200)
      assert response =~ email
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        conn
        |> log_in_user(admin_fixture())
        |> post(Routes.user_registration_path(conn, :create), %{
          "user" => %{"email" => "with spaces"}
        })

      response = html_response(conn, 200)
      assert response =~ "Register</h1>"
      assert response =~ "must have the @ sign and no spaces"
    end
  end
end
