defmodule RegalocalWeb.GiftView do
  use RegalocalWeb, :view
  import RegalocalWeb.PublicLayoutHelpers

  def title(:new, %{coupon: %{title: coupon_title}, business: %{name: business_name}}) do
    "#{coupon_title} a #{business_name}"
  end
end
