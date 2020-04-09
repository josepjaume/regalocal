defmodule RegalocalWeb.Admin.DashboardController do
  use RegalocalWeb, :controller
  use RegalocalWeb.Admin.BaseController

  @spec show(Plug.Conn.t(), any) :: Plug.Conn.t()
  def show(conn, _params) do
    business = load_business(conn)

    conn
    |> assign(:title, "Panell")
    |> render("show.html", business: business)
  end
end
