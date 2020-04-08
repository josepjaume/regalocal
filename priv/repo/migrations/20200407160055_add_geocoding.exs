defmodule Regalocal.Repo.Migrations.AddGeocoding do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"

    alter table(:businesses) do
      add(:coordinates, :geometry)
    end
  end
end
