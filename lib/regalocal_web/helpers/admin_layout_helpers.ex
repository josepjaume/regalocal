defmodule RegalocalWeb.AdminLayoutHelpers do
  import Phoenix.HTML.Tag
  use Phoenix.Template, root: "lib/regalocal_web/templates/helpers/admin"

  def layout(title, do: content) do
    render_template("layout.html", %{title: title, content: content})
  end

  def layout(do: content) do
    render_template("layout.html", %{title: nil, content: content})
  end
end
