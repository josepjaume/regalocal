defmodule RegalocalWeb.Veil.SessionController do
  use RegalocalWeb, :controller
  alias Regalocal.Veil

  action_fallback(RegalocalWeb.Veil.FallbackController)

  @doc """
  Creates a new session using a unique id sent by email.
  If creating the new session is successful, the business is verified and the request is deleted.
  """
  def create(conn, %{"request_id" => request_unique_id}) do
    with {:ok, request} <- Veil.get_request(request_unique_id),
         {:ok, business_id} <- Veil.verify(conn, request),
         {:ok, session} <- Veil.create_session(conn, business_id) do
      Task.start(fn -> Veil.verify_business(business_id) end)
      Task.start(fn -> Veil.delete(request) end)

      conn
      |> put_resp_cookie("session_unique_id", session.unique_id, max_age: 60 * 60 * 24 * 365)
      |> redirect(to: Routes.admin_business_path(conn, :edit))
    else
      error ->
        error
    end
  end

  @doc """
  Deletes an existing session and logs the business out.
  """
  def delete(conn, %{"session_id" => session_unique_id}) do
    with {:ok, _del} <- Cachex.del(:veil_sessions, session_unique_id),
         {:ok, _session} <- Veil.delete_session(session_unique_id) do
      conn
      |> delete_resp_cookie("session_unique_id", max_age: 60 * 60 * 24 * 365)
      |> redirect(to: Routes.veil_business_path(conn, :new))
    else
      error ->
        error
    end
  end
end
