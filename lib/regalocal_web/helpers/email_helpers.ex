defmodule RegalocalWeb.EmailHelpers do
  import Phoenix.HTML.Tag

  use Phoenix.Template, root: "lib/regalocal_web/templates/helpers/email"

  def layout(alert, do: content) do
    render_template("layout.html", %{alert: alert, content: content})
  end

  def layout(do: content) do
    render_template("layout.html", %{content: content})
  end

  def content_block(do: content) do
    content_tag :tr do
      content_tag(:td, content, class: "content-block")
    end
  end
end
