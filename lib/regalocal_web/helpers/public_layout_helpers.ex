defmodule RegalocalWeb.PublicLayoutHelpers do
  import Phoenix.HTML.Tag

  def container(do: content) do
    container(:wide) do
      content_tag(:div, content, class: "mx-auto max-w-screen-xl relative p-4 sm:p-6 lg:p-8")
    end
  end

  def container(:wide, do: content) do
    content_tag(:div, content, class: "bg-white border-t border-primary-100")
  end
end
