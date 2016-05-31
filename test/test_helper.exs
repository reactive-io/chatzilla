ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Chatzilla.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Chatzilla.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Chatzilla.Repo)

