defmodule RegalocalWeb.Admin.BaseController do
  defmacro __using__(_opts) do
    quote do
      plug(:put_layout, {RegalocalWeb.AdminLayoutView, "app.html"})
      import RegalocalWeb.Admin.BaseController
    end
  end

  alias Regalocal.Admin

  def load_business(conn) do
    Admin.get_business!(conn.assigns[:business_id])
  end
end
