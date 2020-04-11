defmodule Regalocal.Orders.Gift do
  use Ecto.Schema
  import Ecto.Changeset

  @email_regex ~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  schema "gifts" do
    field :reference, :string
    field :amount, :decimal
    field :buyer_email, :string
    field :buyer_name, :string
    field :buyer_phone, :string
    field :message_for_recipient, :string
    field :recipient_email, :string
    field :recipient_name, :string
    field :redeemed_at, :time
    field :status, GiftStatusEnum
    field :value, :integer
    field :business_id, :id

    field :accepted_coupon_terms, :boolean, virtual: true
    field :accepted_gift_terms, :boolean, virtual: true

    belongs_to :coupon, Regalocal.Admin.Coupon

    timestamps()
  end

  @doc false
  def changeset(gift, attrs) do
    gift
    |> cast(attrs, [
      :reference,
      :buyer_name,
      :buyer_email,
      :buyer_phone,
      :recipient_name,
      :recipient_email,
      :message_for_recipient,
      :value,
      :amount,
      :status,
      :accepted_coupon_terms,
      :accepted_gift_terms,
      :coupon_id,
      :business_id
    ])
    |> validate_required([
      :reference,
      :buyer_name,
      :buyer_email,
      :buyer_phone,
      :recipient_name,
      :recipient_email,
      :message_for_recipient,
      :value,
      :amount,
      :status,
      :coupon_id,
      :business_id
    ])
    |> validate_terms
    |> validate_acceptance(:accepted_gift_terms)
    |> validate_format(:buyer_email, @email_regex)
    |> validate_format(:recipient_email, @email_regex)
    |> unique_constraint(:reference)
  end

  def validate_terms(changeset) do
    if !get_change(changeset, :accepted_coupon_terms) do
      add_error(changeset, :accepted_coupon_terms, "must accept terms")
    else
      changeset
    end
  end
end
