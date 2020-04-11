defmodule RegalocalWeb.Admin.OrderController do
  use RegalocalWeb, :controller
  use RegalocalWeb.Admin.BaseController

  alias Regalocal.Admin
  alias RegalocalWeb.Orders.{Mailer, PaymentReceivedEmail, OrderRedeemedEmail}

  def index(conn, _params) do
    orders = Admin.list_orders(conn.assigns[:business_id])

    conn
    |> render("index.html", orders: orders)
  end

  def show(conn, %{"id" => id}) do
    order = Admin.get_order!(conn.assigns[:business_id], id)

    conn
    |> render("show.html", order: order)
  end

  def payment_received(conn, %{"id" => order_id}) do
    order = Admin.get_order!(conn.assigns[:business_id], order_id)
    business = Admin.get_business!(order.business_id)

    case Admin.payment_received!(order) do
      {:ok, _order} ->
        PaymentReceivedEmail.generate(conn, order, business)
        |> Mailer.deliver()

        conn
        |> put_flash(:info, "El pagament confirmat correctament.")
        |> redirect(to: Routes.admin_order_path(conn, :index))

      {:error, _error} ->
        conn
        |> put_flash(:error, "El pagament no ha pogut ser confirmat.")
        |> redirect(to: Routes.admin_order_path(conn, :index))
    end
  end

  def redeem(conn, %{"id" => order_id}) do
    order = Admin.get_order!(conn.assigns[:business_id], order_id)
    business = Admin.get_business!(order.business_id)

    case Admin.redeem!(order) do
      {:ok, _order} ->
        OrderRedeemedEmail.generate(order, business)
        |> Mailer.deliver()

        conn
        |> put_flash(:info, "El cupó ha sigut marcat com a utilitzat correctament.")
        |> redirect(to: Routes.admin_order_path(conn, :index))

      {:error, _error} ->
        conn
        |> put_flash(:error, "El cupó no s'ha pogut marcar com a utilitzat.")
        |> redirect(to: Routes.admin_order_path(conn, :index))
    end
  end
end
