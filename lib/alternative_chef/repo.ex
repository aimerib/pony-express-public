defmodule AlternativeChef.Repo do
  use Ecto.Repo,
    otp_app: :alternative_chef,
    adapter: Ecto.Adapters.Postgres
end
