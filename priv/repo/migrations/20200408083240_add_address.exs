defmodule Regalocal.Repo.Migrations.AddAddress do
  use Ecto.Migration

  def change do
    alter table(:businesses) do
      add(:address, :string)
    end
  end
end
