defmodule RegalocalWeb.BusinessController do
  use RegalocalWeb, :controller
  alias Regalocal.Search

  def show(conn, %{"id" => id}) do
    business = Search.get_business!(id)
    coupons = Search.active_coupons_for(business)

    conn
    |> assign(:business, business)
    |> assign(:coupons, coupons)
    |> render("show.html")
  end
end
