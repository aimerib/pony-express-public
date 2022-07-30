defmodule AlternativeChefWeb.MessageController do
  use AlternativeChefWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def send(conn, %{"message_data" => %{"message" => message}}) do
    case AlternativeChef.PonyExpress.post_letter(message) do
      :ok ->
        conn
        |> put_flash(
          :info,
          "Messages delivered"
        )
        |> redirect(to: "/")

      {:error, error_message} ->
        conn
        |> put_flash(:error, "Something went wrong: #{error_message}")
        |> redirect(to: "/")
    end
  end
end
