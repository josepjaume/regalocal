defmodule RegalocalWeb.AppHelpers do
  def current_business(conn) do
    conn.assigns[:current_business]
  end
end
