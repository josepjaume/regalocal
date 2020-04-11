defmodule RegalocalWeb.EmailHelpers do
  import Phoenix.HTML.Tag

  use Phoenix.Template, root: "lib/regalocal_web/templates/helpers/email"

  def layout(title, do: content) do
    layout(title, nil) do
      content
    end
  end

  def layout(title, subtitle, do: content) do
    render_template("layout.html", %{title: title, subtitle: subtitle, content: content})
  end

  def layout(do: content) do
    layout(nil, nil) do
      content
    end
  end

  def content_block(do: content) do
    content_tag :tr do
      content_tag(:td, content, class: "content-block")
    end
  end
end
