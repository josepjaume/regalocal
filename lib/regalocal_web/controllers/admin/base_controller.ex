defmodule RegalocalWeb.Admin.BaseController do
  defmacro __using__(_opts) do
    quote do
      plug(:put_layout, {RegalocalWeb.AdminLayoutView, "app.html"})
      import RegalocalWeb.Admin.BaseController
    end
  end

  def current_business(conn) do
    conn.assigns[:current_business]
  end
end
