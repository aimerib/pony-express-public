defmodule AlternativeChefWeb.Plug.Admin do
  @behaviour Plug
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.assigns.current_user do
      %AlternativeChef.Accounts.User{} ->
        if conn.assigns.current_user.admin do
          conn
        else
          conn
          |> put_flash(:error, "You must be an admin to access that page.")
          |> redirect(to: AlternativeChefWeb.Router.Helpers.user_session_path(conn, :new))
          |> halt()
        end

      _ ->
        conn
        |> put_flash(:error, "You must be logged in to access that page.")
        |> redirect(to: AlternativeChefWeb.Router.Helpers.user_session_path(conn, :new))
        |> halt()
    end
  end
end
