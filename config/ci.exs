use Mix.Config

import_config "test.exs"

config :regalocal, Regalocal.Repo,
  url: System.get_env("DATABASE_URL"),
  pool: Ecto.Adapters.SQL.Sandbox
