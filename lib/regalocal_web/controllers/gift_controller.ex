defmodule RegalocalWeb.GiftController do
  use RegalocalWeb, :controller

  alias Regalocal.Orders
  alias Regalocal.Orders.Gift

  def new(conn, %{"id" => coupon_id}) do
    IO.inspect(coupon_id)
    coupon = Orders.get_coupon!(coupon_id)
    business = Orders.get_business!(coupon.business_id)
    changeset = Orders.change_gift(%Gift{})
    render(conn, "new.html", changeset: changeset, coupon: coupon, business: business)
  end

  def create(conn, %{"id" => coupon_id, "gift" => gift_params}) do
    coupon = Orders.get_coupon!(coupon_id)

    params =
      if is_nil(coupon.terms) do
        gift_params |> Map.put("accepted_coupon_terms", true)
      else
        gift_params
      end
      |> Map.merge(%{
        "coupon_id" => coupon_id,
        "business_id" => coupon.business_id,
        "amount" => coupon.amount,
        "value" => coupon.value,
        "status" => :pending_payment
      })

    case Orders.create_gift(params) do
      {:ok, gift} ->
        conn
        |> put_flash(:info, "Gift created successfully.")
        |> render("thanks.html", gift: gift)

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        business = Orders.get_business!(coupon.business_id)
        render(conn, "new.html", changeset: changeset, coupon: coupon, business: business)
    end
  end
end
