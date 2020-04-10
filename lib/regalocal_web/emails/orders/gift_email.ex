defmodule RegalocalWeb.Orders.GiftEmail do
  use Phoenix.Swoosh, view: RegalocalWeb.Orders.EmailView

  def generate(gift, business) do
    new()
    |> to({gift.recipient_name, gift.recipient_email})
    |> reply_to({gift.buyer_name, gift.buyer_email})
    |> from(from_email())
    |> subject("#{gift.buyer_name} t'ha fet un regal per anar a #{business.name}!")
    |> render_body("gift_email.html", %{gift: gift, business: business})
  end

  defp from_email do
    {Application.get_env(:veil, :email_from_name),
     Application.get_env(:veil, :email_from_address)}
  end
end
