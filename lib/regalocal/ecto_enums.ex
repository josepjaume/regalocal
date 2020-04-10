import EctoEnum
defenum(CouponStatusEnum, :coupon_status, [:draft, :published, :redeemable])

defenum(GiftStatusEnum, :gift_status, [
  :pending_payment,
  :paid,
  :payment_confirmed,
  :redeemed
])
