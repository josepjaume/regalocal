defmodule RegalocalWeb.Plugs.Acceptance do
  @moduledoc """
  A plug to assign whether a businses accepted the terms or not.
  """
  require Logger
  import Plug.Conn
  alias Regalocal.Admin
  alias RegalocalWeb.Router.Helpers, as: Routes
  use Phoenix.Controller

  def init(default), do: default

  def call(%{assigns: %{business_id: nil}} = conn, _opts), do: conn

  def call(%{path_info: ["admin", "business", "edit"]} = conn, _opts) do
    assign(conn, :acceptance, accepted_terms?(conn))
  end

  def call(conn, _opts) do
    if !accepted_terms?(conn) do
      conn
      |> assign(:acceptance, false)
      |> redirect(to: Routes.admin_business_path(conn, :edit))
      |> halt
    else
      conn
      |> assign(:acceptance, true)
    end
  end

  defp accepted_terms?(conn) do
    Admin.accepted_terms?(conn.assigns[:business_id])
  end
end
