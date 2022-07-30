# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AlternativeChef.Repo.insert!(%AlternativeChef.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
AlternativeChef.Accounts.register_user(%{
  email: System.get_env("ROOT_USER"),
  password: System.get_env("ROOT_PASSWORD"),
  admin: true
})
