defmodule Regalocal.Repo do
  use Ecto.Repo,
    otp_app: :regalocal,
    adapter: Ecto.Adapters.Postgres
end
