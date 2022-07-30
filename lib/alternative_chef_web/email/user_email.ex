defmodule AlternativeChefWeb.UserEmail do
  use Phoenix.Swoosh,
    view: AlternativeChefWeb.EmailView,
    layout: {AlternativeChefWeb.EmailLayoutView, :email}

  def new_user_email(user, url) do
    prepare(user)
    |> subject("New account for Alternative Chef NC Pony Express")
    |> render_body("new_user.html", %{user: user, url: url})
  end

  def password_reset(user, url) do
    prepare(user)
    |> subject("Password reset request")
    |> render_body("password_reset.html", %{user: user, url: url})
  end

  def change_email(user, url) do
    prepare(user)
    |> subject("Email change request")
    |> render_body("change_email.html", %{user: user, url: url})
  end

  defp prepare(user) do
    new()
    |> to(user.email)
    |> from({
      "Alternative Chef NC",
      Application.get_env(:alternative_chef, AlternativeChefWeb.Mailer)[:from]
    })
    |> assign(:app_uri, AlternativeChefWeb.Endpoint.url())
  end
end
