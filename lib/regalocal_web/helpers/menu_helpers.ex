defmodule RegalocalWeb.MenuHelpers do
  def menu_item_active?(conn, %{path: path, exact: true}) do
    conn.request_path === path
  end

  def menu_item_active?(conn, %{path: path}) do
    conn.request_path
    |> String.starts_with?(path)
  end
end
