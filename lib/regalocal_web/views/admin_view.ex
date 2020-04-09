defmodule RegalocalWeb.AdminLayoutView do
  use RegalocalWeb, :view

  def logo(conn) do
    RegalocalWeb.LayoutView.render("logo.html", %{conn: conn})
  end

  def menu_items(conn) do
    [
      %{title: "Resum", path: Routes.admin_dashboard_path(conn, :show), exact: true},
      %{title: "Editar perfil", path: Routes.admin_business_path(conn, :edit)},
      %{title: "Cupons", path: Routes.admin_coupon_path(conn, :index)}
    ]
  end
end
