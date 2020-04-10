defmodule RegalocalWeb.Admin.CouponController do
  use RegalocalWeb, :controller
  use RegalocalWeb.Admin.BaseController

  alias Regalocal.Admin
  alias Regalocal.Admin.Coupon

  def index(conn, _params) do
    coupons = Admin.list_coupons(conn.assigns[:business_id])

    conn
    |> assign(:title, "Cupons")
    |> render("index.html", coupons: coupons)
  end

  def new(conn, _params) do
    changeset = Admin.change_coupon(%Coupon{})

    conn
    |> assign(:title, "Nou cupó")
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"coupon" => coupon_params}) do
    params =
      Map.merge(coupon_params, %{"business_id" => conn.assigns[:business_id], "status" => :draft})

    case Admin.create_coupon(params) do
      {:ok, coupon} ->
        conn
        |> put_flash(:info, "Coupon created successfully.")
        |> redirect(to: Routes.admin_coupon_path(conn, :show, coupon))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)

        conn
        |> assign(:title, "Nou cupó")
        |> render("new.html", changeset: changeset)
    end
  end

  def publish(conn, %{"id" => id}) do
    coupon = Admin.get_coupon!(conn.assigns[:business_id], id)

    case Admin.publish_coupon!(coupon) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Coupon published successfully.")
        |> redirect(to: Routes.admin_coupon_path(conn, :index))

      {:error, :unpublishable} ->
        conn
        |> put_flash(
          :error,
          "El cupó no està en estat d'esborrany"
        )
        |> redirect(to: Routes.admin_coupon_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Coupon could not be published.")
        |> redirect(to: Routes.admin_coupon_path(conn, :index))
    end
  end

  def unpublish(conn, %{"id" => id}) do
    coupon = Admin.get_coupon!(conn.assigns[:business_id], id)

    case Admin.unpublish_coupon!(coupon) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Coupon unpublished successfully.")
        |> redirect(to: Routes.admin_coupon_path(conn, :index))

      {:error, :has_orders} ->
        conn
        |> put_flash(
          :error,
          "El cupó ja ha sigut comprat almenys un cop, per tant no es pot despublicar. Si vols que ningú més el pugui comprar, arxiva'l."
        )
        |> redirect(to: Routes.admin_coupon_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)

        conn
        |> put_flash(:error, "Coupon could not be unpublished.")
        |> redirect(to: Routes.admin_coupon_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    coupon = Admin.get_coupon!(conn.assigns[:business_id], id)

    conn
    |> assign(:title, "Cupó")
    |> render("show.html", coupon: coupon)
  end

  def edit(conn, %{"id" => id}) do
    coupon = Admin.get_coupon!(conn.assigns[:business_id], id)
    changeset = Admin.change_coupon(coupon)

    conn
    |> assign(:title, "Editar cupó")
    |> render("edit.html", coupon: coupon, changeset: changeset)
  end

  def update(conn, %{"id" => id, "coupon" => coupon_params}) do
    coupon = Admin.get_coupon!(conn.assigns[:business_id], id)

    case Admin.update_coupon(coupon, coupon_params) do
      {:ok, coupon} ->
        conn
        |> put_flash(:info, "Coupon updated successfully.")
        |> redirect(to: Routes.admin_coupon_path(conn, :show, coupon))

      {:error, :has_orders} ->
        conn
        |> put_flash(
          :error,
          "El cupó ja ha sigut comprat almenys un cop, per tant no es pot modificar. Si vols canviar les condicions, arxiva'l i crea'n un de nou."
        )
        |> redirect(to: Routes.admin_coupon_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:title, "Editar cupó")
        |> render("edit.html", coupon: coupon, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    coupon = Admin.get_coupon!(conn.assigns[:business_id], id)
    {:ok, _coupon} = Admin.delete_coupon(coupon)

    conn
    |> put_flash(:info, "Coupon deleted successfully.")
    |> redirect(to: Routes.admin_coupon_path(conn, :index))
  end
end
