defmodule Regalocal.Repo.Migrations.CreateCoupons do
  use Ecto.Migration

  def change do
    CouponStatusEnum.create_type()

    create table(:coupons) do
      add :title, :string
      add :amount, :decimal
      add :value, :integer
      add :discount, :integer
      add :status, CouponStatusEnum.type()
      add :terms, :text
      add :business_id, references(:businesses, on_delete: :nothing)

      timestamps()
    end

    create index(:coupons, [:business_id])
  end
end
