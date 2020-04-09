defmodule Regalocal.Repo.Migrations.CreateGifts do
  use Ecto.Migration

  def change do
    GiftStatusEnum.create_type()

    create table(:gifts) do
      add :reference, :string
      add :buyer_name, :string
      add :buyer_email, :string
      add :buyer_phone, :string
      add :recipient_name, :string
      add :recipient_email, :string
      add :message_for_recipient, :text
      add :value, :integer
      add :amount, :decimal
      add :status, GiftStatusEnum.type()
      add :redeemed_at, :time
      add :coupon_id, references(:coupons, on_delete: :nothing)
      add :business_id, references(:businesses, on_delete: :nothing)

      timestamps()
    end

    create index(:gifts, [:coupon_id])
    create index(:gifts, [:business_id])
  end
end
