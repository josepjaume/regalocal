import EctoEnum
defenum(CouponStatusEnum, :coupon_status, [:draft, :published, :redeemable, :archived])

defenum(GiftStatusEnum, :gift_status, [
  :pending_payment,
  :paid,
  :payment_confirmed,
  :redeemable,
  :redeemed
])
