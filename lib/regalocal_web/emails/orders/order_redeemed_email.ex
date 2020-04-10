defmodule RegalocalWeb.Orders.OrderRedeemedEmail do
  use Phoenix.Swoosh, view: RegalocalWeb.Orders.EmailView

  def generate(gift, business) do
    new()
    |> to({gift.buyer_name, gift.buyer_email})
    |> reply_to({business.owner_name, business.email})
    |> from(from_email())
    |> subject("El cupó que vas regalar ha sigut utilitzat - #{gift.reference}")
    |> render_body("order_redeemed.html", %{gift: gift, business: business})
  end

  defp from_email do
    {Application.get_env(:veil, :email_from_name),
     Application.get_env(:veil, :email_from_address)}
  end
end
