defmodule RegalocalWeb.Admin.BusinessController do
  use RegalocalWeb, :controller

  alias Regalocal.Admin

  # alias Regalocal.Admin.Business

  def show(conn, _params) do
    business = load_business(conn)
    render(conn, "show.html", business: business)
  end

  def edit(conn, _params) do
    business = load_business(conn)
    changeset = Admin.change_business(business)
    render(conn, "edit.html", business: business, changeset: changeset)
  end

  def update(conn, %{"business" => params}) do
    business = load_business(conn)

    new_params =
      if upload = params["photo"] do
        {:ok, %Cloudex.UploadedImage{public_id: photo_id}} = Cloudex.upload(upload.path)
        Map.put(params, "photo_id", photo_id)
      else
        params
      end

    case Admin.update_business(business, new_params) do
      {:ok, _business} ->
        conn
        |> put_flash(:info, "Business updated successfully.")
        |> redirect(to: Routes.admin_business_path(conn, :show))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        render(conn, "edit.html", business: business, changeset: changeset)
    end
  end

  def load_business(conn) do
    Admin.get_business!(conn.assigns[:business_id])
  end

  def delete(conn) do
    business = Admin.get_business!(conn.assigns[:business_id])
    {:ok, _business} = Admin.delete_business(business)

    conn
    |> put_flash(:info, "Business deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
