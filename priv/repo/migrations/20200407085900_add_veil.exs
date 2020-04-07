defmodule Regalocal.Repo.Migrations.AddVeil do
  use Ecto.Migration

  def change do
    create table(:businesses) do
      add(:email, :string)
      add :name, :string
      add :owner_name, :string
      add :story, :text
      add :phone, :string
      add :website, :string
      add :whatsapp, :string
      add :google_maps_url, :string
      add :tripadvisor_url, :string
      add :instagram, :string
      add :facebook, :string
      add :iban, :string
      add :legal_name, :string
      add :vat_number, :string
      add :billing_address, :string
      add :bizum_number, :string
      add(:verified, :boolean, default: false)

      timestamps()
    end

    create(unique_index(:businesses, [:email]))

    create table(:veil_requests) do
      add(:business_id, references(:businesses, on_delete: :delete_all))
      add(:unique_id, :string)
      add(:phoenix_token, :string)
      add(:ip_address, :string)

      timestamps()
    end

    create(index(:veil_requests, [:unique_id]))

    create table(:veil_sessions) do
      add(:business_id, references(:businesses, on_delete: :delete_all))
      add(:unique_id, :string)
      add(:phoenix_token, :string)
      add(:ip_address, :string)

      timestamps()
    end

    create(index(:veil_sessions, [:unique_id]))
  end
end
