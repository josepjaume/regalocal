defmodule Regalocal.Repo.Migrations.AddArchived do
  use Ecto.Migration

  def change do
    alter table(:coupons) do
      add(:archived, :boolean)
    end
  end
end
