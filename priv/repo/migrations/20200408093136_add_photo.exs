defmodule Regalocal.Repo.Migrations.AddPhoto do
  use Ecto.Migration

  def change do
    alter table(:businesses) do
      add(:photo_id, :string)
    end
  end
end
