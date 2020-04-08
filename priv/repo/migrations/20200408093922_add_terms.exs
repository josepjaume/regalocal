defmodule Regalocal.Repo.Migrations.AddTerms do
  use Ecto.Migration

  def change do
    alter table(:businesses) do
      add(:accepted_terms, :boolean)
    end
  end
end
