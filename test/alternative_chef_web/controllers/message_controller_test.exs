defmodule AlternativeChefWeb.MessageControllerTest do
  use AlternativeChefWeb.ConnCase
  import AlternativeChef.AccountsFixtures

  test "GET /", %{conn: conn} do
    conn = conn |> log_in_user(user_fixture()) |> get(Routes.message_path(conn, :index))
    assert html_response(conn, 200) =~ "Text customers"
  end

  test "Redirects when user isn't logged in", %{conn: conn} do
    conn = conn |> get(Routes.message_path(conn, :index))
    assert redirected_to(conn) == Routes.user_session_path(conn, :new)
  end
end
