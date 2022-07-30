defmodule AlternativeChef.ContactsTest do
  use AlternativeChef.DataCase

  alias AlternativeChef.Contacts

  describe "clients" do
    alias AlternativeChef.Contacts.Client

    @valid_attrs %{
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
      phone_number: "1234567890",
      text: false
    }
    @invalid_attrs %{
      first_name: nil,
      last_name: nil,
      last_texted: nil,
      phone_number: nil,
      text: nil
    }

    def client_fixture(attrs \\ %{}) do
      {:ok, client} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contacts.create_client()

      client
    end

    test "list_clients/0 returns all clients" do
      client = client_fixture()
      {:ok, clients} = Contacts.list_clients()
      assert clients == [client]
    end

    test "get_client!/1 returns the client with given id" do
      client = client_fixture()
      assert Contacts.get_client!(client.id) == client
    end

    test "create_client/1 with valid data creates a client" do
      assert {:ok, %Client{} = client} = Contacts.create_client(@valid_attrs)
      assert client.first_name == "some first_name"
      assert client.last_name == "some last_name"
      assert client.last_texted == ~N[2010-04-17 14:00:00]
      assert client.phone_number == "1234567890"
      assert client.text == true
    end

    test "create_client/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contacts.create_client(@invalid_attrs)
    end

    test "update_client/2 with valid data updates the client" do
      client = client_fixture()
      assert {:ok, %Client{} = client} = Contacts.update_client(client, @update_attrs)
      assert client.first_name == "some updated first_name"
      assert client.last_name == "some updated last_name"
      assert client.last_texted == ~N[2011-05-18 15:01:01]
      assert client.phone_number == "1234567890"
      assert client.text == false
    end

    test "update_client/2 with invalid data returns error changeset" do
      client = client_fixture()
      assert {:error, %Ecto.Changeset{}} = Contacts.update_client(client, @invalid_attrs)
      assert client == Contacts.get_client!(client.id)
    end

    test "delete_client/1 deletes the client" do
      client = client_fixture()
      assert {:ok, %Client{}} = Contacts.delete_client(client)
      assert_raise Ecto.NoResultsError, fn -> Contacts.get_client!(client.id) end
    end

    test "change_client/1 returns a client changeset" do
      client = client_fixture()
      assert %Ecto.Changeset{} = Contacts.change_client(client)
    end
  end
end
