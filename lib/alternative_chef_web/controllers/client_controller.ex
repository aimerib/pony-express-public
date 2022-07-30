defmodule AlternativeChefWeb.ClientController do
  use AlternativeChefWeb, :controller

  alias AlternativeChef.Contacts
  alias AlternativeChef.Contacts.Client

  def index(conn, _params) do
    case Contacts.list_clients() do
      {:ok, clients} -> render(conn, "index.html", clients: clients)
      {:empty_list, _} -> render(conn, "index.html", clients: [])
    end
  end

  def new(conn, _params) do
    changeset = Contacts.change_client(%Client{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{
        "client" => %{
          "first_name" => first_name,
          "last_name" => last_name,
          "phone_number" => phone_number,
          "text" => ok_to_text
        }
      }) do
    case phone_number do
      nil ->
        conn
        |> put_flash(:info, "Must add a phone number.")
        |> redirect(to: Routes.client_path(conn, :create))

      _ ->
        phone_number = phone_number |> String.replace(~r/[\+\(\)\-\ \.]/, "")

        new_client = %{
          "first_name" => first_name,
          "last_name" => last_name,
          "phone_number" => phone_number,
          "text" => ok_to_text
        }

        case Contacts.create_client(new_client) do
          {:ok, client} ->
            conn
            |> put_flash(:info, "Client created successfully.")
            |> redirect(to: Routes.client_path(conn, :show, client))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
    end
  end

  def show(conn, %{"id" => id}) do
    client = Contacts.get_client!(id)
    %Client{phone_number: phone_number} = client
    [_, first, second, third] = Regex.run(~r/(\d{3})(\d{3})(\d{4})/, phone_number)
    render(conn, "show.html", client: client, phone_number: "(#{first}) #{second}-#{third}")
  end

  def edit(conn, %{"id" => id}) do
    client = Contacts.get_client!(id)
    changeset = Contacts.change_client(client)
    render(conn, "edit.html", client: client, changeset: changeset)
  end

  def update(conn, %{
        "id" => id,
        "client" => %{
          "first_name" => first_name,
          "last_name" => last_name,
          "phone_number" => phone_number,
          "text" => ok_to_text
        }
      }) do
    case phone_number do
      nil ->
        client = Contacts.get_client!(id)

        case Contacts.update_client(client, %{
               "first_name" => first_name,
               "last_name" => last_name,
               "phone_number" => "0000000000",
               "text" => ok_to_text
             }) do
          {:ok, client} ->
            conn
            |> put_flash(:info, "Client updated successfully.")
            |> redirect(to: Routes.client_path(conn, :show, client))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", client: client, changeset: changeset)
        end

      _ ->
        phone_number = phone_number |> String.replace(~r/[\+\(\)\-\ \.]/, "")

        client = Contacts.get_client!(id)

        case Contacts.update_client(client, %{
               "first_name" => first_name,
               "last_name" => last_name,
               "phone_number" => phone_number,
               "text" => ok_to_text
             }) do
          {:ok, client} ->
            conn
            |> put_flash(:info, "Client updated successfully.")
            |> redirect(to: Routes.client_path(conn, :show, client))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", client: client, changeset: changeset)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    client = Contacts.get_client!(id)
    {:ok, _client} = Contacts.delete_client(client)

    conn
    |> put_flash(:info, "Client deleted successfully.")
    |> redirect(to: Routes.client_path(conn, :index))
  end
end
