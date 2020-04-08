defmodule RegalocalWeb.LayoutView do
  use RegalocalWeb, :view

  def logo(conn) do
    render("logo.html", %{conn: conn})
  end
end
