defmodule RegalocalWeb.Admin.DashboardController do
  use RegalocalWeb, :controller
  use RegalocalWeb.Admin.BaseController

  alias Regalocal.Orders.Gift
  alias Regalocal.Admin.Coupon
  import Ecto.Query, warn: false
  alias Regalocal.Repo

  @spec show(Plug.Conn.t(), any) :: Plug.Conn.t()
  def show(conn, _params) do
    business = current_business(conn)

    conn
    |> assign(:orders, orders(business.id))
    |> assign(:has_active_coupons, has_active_coupons?(business.id))
    |> assign(:sales, sales(business.id))
    |> assign(:revenue, revenue(business.id))
    |> render("show.html")
  end

  def has_active_coupons?(business_id) do
    Coupon
    |> where(business_id: ^business_id)
    |> where([c], c.status in ["published", "redeemable"] and c.archived == false)
    |> Repo.exists?()
  end

  defp orders(business_id) do
    from(g in Gift, where: g.business_id == ^business_id, select: count()) |> Repo.one!()
  end

  defp sales(business_id) do
    from(g in Gift, where: g.business_id == ^business_id, select: sum(g.value)) |> Repo.one!()
  end

  defp revenue(business_id) do
    from(g in Gift, where: g.business_id == ^business_id, select: sum(g.amount)) |> Repo.one!()
  end
end
