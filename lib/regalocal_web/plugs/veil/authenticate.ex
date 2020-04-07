defmodule RegalocalWeb.Plugs.Veil.Authenticate do
  @moduledoc """
  A plug to restrict access to logged in business
  We simply check to see if the business has the :business_id assign set
  """

  def init(default), do: default

  def call(conn, _opts) do
    unless is_nil(conn.assigns[:business_id]) do
      conn
    else
      Phoenix.Controller.redirect(conn,
        to: RegalocalWeb.Router.Helpers.veil_business_path(conn, :new)
      )
    end
  end
end
