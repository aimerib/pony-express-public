defmodule AlternativeChef.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :first_name, :string
      add :last_name, :string
      add :phone_number, :string
      add :text, :boolean, default: false, null: false
      add :last_texted, :naive_datetime

      timestamps()
    end

  end
end
