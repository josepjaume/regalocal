defmodule RegalocalWeb.LayoutView do
  use RegalocalWeb, :view

  def logo(conn) do
    render("logo.html", %{conn: conn})
  end

  def menu_items(conn) do
    [
      %{title: "Preguntes Freqüents", path: Routes.faq_path(conn, :index)}
    ]
  end
end
