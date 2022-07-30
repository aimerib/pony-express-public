defmodule AlternativeChefWeb.ClientControllerTest do
  use AlternativeChefWeb.ConnCase, async: true

  alias AlternativeChef.Contacts
  import AlternativeChef.AccountsFixtures

  @create_attrs %{
    first_name: "some first_name",
    last_name: "some last_name",
    last_texted: ~N[2010-04-17 14:00:00],
    phone_number: "1234567890",
    text: true
  }
  @update_attrs %{
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    last_texted: ~N[2011-05-18 15:01:01],
    phone_number: "1234567891",
    text: false
  }
  @invalid_attrs %{
    first_name: nil,
    last_name: nil,
    last_texted: nil,
    phone_number: nil,
    text: nil
  }

  def fixture(:client) do
    {:ok, client} = Contacts.create_client(@create_attrs)
    client
  end

  describe "index" do
    test "lists all clients", %{conn: conn} do
      conn =
        conn |> log_in_user(user_with_password_fixture()) |> get(Routes.client_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Clients"
    end
  end

  describe "new client" do
    test "renders form", %{conn: conn} do
      conn =
        conn |> log_in_user(user_with_password_fixture()) |> get(Routes.client_path(conn, :new))

      assert html_response(conn, 200) =~ "New Client"
    end
  end

  describe "create client" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn =
        conn
        |> log_in_user(user_with_password_fixture())
        |> post(Routes.client_path(conn, :create), client: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.client_path(conn, :show, id)

      conn = get(conn, Routes.client_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Client"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        conn
        |> log_in_user(user_with_password_fixture())
        |> post(Routes.client_path(conn, :create), client: @invalid_attrs)

      assert redirected_to(conn) == Routes.client_path(conn, :create)
    end
  end

  describe "edit client" do
    setup [:create_client]

    test "renders form for editing chosen client", %{conn: conn, client: client} do
      conn =
        conn
        |> log_in_user(user_with_password_fixture())
        |> get(Routes.client_path(conn, :edit, client))

      assert html_response(conn, 200) =~ "Edit Client"
    end
  end

  describe "update client" do
    setup [:create_client]

    test "redirects when data is valid", %{conn: conn, client: client} do
      conn =
        conn
        |> log_in_user(user_with_password_fixture())
        |> put(Routes.client_path(conn, :update, client), client: @update_attrs)

      assert redirected_to(conn) == Routes.client_path(conn, :show, client)

      conn =
        conn
        |> get(Routes.client_path(conn, :show, client))

      assert html_response(conn, 200) =~ "some updated first_name"
    end

    test "renders errors when data is invalid", %{conn: conn, client: client} do
      conn =
        conn
        |> log_in_user(user_with_password_fixture())
        |> put(Routes.client_path(conn, :update, client), client: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Client"
    end
  end

  describe "delete client" do
    setup [:create_client]

    test "deletes chosen client", %{conn: conn, client: client} do
      conn =
        conn
        |> log_in_user(user_with_password_fixture())
        |> delete(Routes.client_path(conn, :delete, client))

      assert redirected_to(conn) == Routes.client_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.client_path(conn, :show, client))
      end
    end
  end

  defp create_client(_) do
    client = fixture(:client)
    %{client: client}
  end
end
