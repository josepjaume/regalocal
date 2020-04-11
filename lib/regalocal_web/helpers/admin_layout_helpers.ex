defmodule RegalocalWeb.AdminLayoutHelpers do
  use Phoenix.HTML
  use Phoenix.Template, root: "lib/regalocal_web/templates/helpers/admin"

  def layout(title, actions, do: content) do
    render_template("layout.html", %{title: title, content: content, actions: apply(actions, [])})
  end

  def layout(title, do: content) do
    render_template("layout.html", %{title: title, content: content, actions: nil})
  end

  def layout(do: content) do
    render_template("layout.html", %{title: nil, content: content, actions: nil})
  end

  def primary_layout_button(options, do: content) do
    primary_layout_button(content, options)
  end

  def primary_layout_button(content, options \\ []) do
    link(
      content,
      options ++
        [
          class:
            "mr-2 sm:mr-0 sm:ml-2 inline-flex items-center px-4 py-2 border border-transparent text-sm leading-5 font-medium rounded-md text-white bg-primary-600 hover:bg-primary-500 focus:outline-none focus:shadow-outline-primary focus:border-primary-700 active:bg-primary-700 transition duration-150 ease-in-out"
        ]
    )
  end

  def secondary_layout_button(options, do: content) do
    secondary_layout_button(content, options)
  end

  def secondary_layout_button(content, options \\ []) do
    link(
      content,
      options ++
        [
          class:
            "mr-2 sm:mr-0 sm:ml-2 inline-flex items-center px-4 py-2 border border-gray-300 text-sm leading-5 font-medium rounded-md text-gray-700 bg-white hover:text-gray-500 focus:outline-none focus:shadow-outline-blue focus:border-blue-300 active:text-gray-800 active:bg-gray-50 transition duration-150 ease-in-out"
        ]
    )
  end
end
