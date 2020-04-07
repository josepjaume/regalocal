defmodule RegalocalWeb.Plugs.Veil.BusinessId do
  @moduledoc """
  A plug to verify if the client is logged in.
  If the client has a session id set as a cookie or api request header, we
  verify if it is valid and unexpired and assign their business_id to the conn. It
  can now be accessed using conn.assigns[:business_id].
  """
  import Plug.Conn
  alias Regalocal.Veil

  def init(default), do: default

  def call(conn, _opts) do
    with session_unique_id <- conn.cookies["session_unique_id"],
         {:ok, session} <- Veil.get_session(session_unique_id),
         {:ok, business_id} <- Veil.verify(conn, session),
         true <- Kernel.==(business_id, session.business_id) do
      Task.start(fn -> Veil.extend_session(conn, session) end)

      conn
      |> assign(:business_id, business_id)
      |> assign(:session_unique_id, session_unique_id)
    else
      _error ->
        conn
    end
  end
end
