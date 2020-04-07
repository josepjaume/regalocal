defmodule RegalocalWeb.Plugs.Veil.Business do
  @moduledoc """
  A plug to assign the Veil.Business struct to the connection.
  """
  require Logger
  import Plug.Conn
  alias Regalocal.Veil

  def init(default), do: default

  def call(conn, _opts) do
    if business_id = conn.assigns[:veil_user_id] do
      {:ok, business} = Veil.get_business(business_id)
      assign(conn, :business, business)
    else
      conn
    end
  end
end
