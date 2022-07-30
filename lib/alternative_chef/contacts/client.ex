defmodule AlternativeChef.Contacts.Client do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clients" do
    field :first_name, :string
    field :last_name, :string
    field :last_texted, :naive_datetime
    field :phone_number, :string
    field :text, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:first_name, :last_name, :phone_number, :text, :last_texted])
    |> validate_required([:first_name, :last_name, :phone_number, :text])
    |> validate_length(:phone_number, min: 10, max: 10)
    |> validate_format(:phone_number, ~r/^\d+/)
  end

  def last_texted_changeset(user, attrs) do
    user
    |> cast(attrs, [:last_texted])
    |> case do
      %{changes: %{last_texted: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :last_texted, "did not change")
    end
  end
end
