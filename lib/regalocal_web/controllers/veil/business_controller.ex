defmodule RegalocalWeb.Veil.BusinessController do
  use RegalocalWeb, :controller
  alias Regalocal.Veil
  alias Regalocal.Veil.Business

  action_fallback(RegalocalWeb.Veil.FallbackController)

  plug(:scrub_params, "business" when action in [:create])

  @doc """
  Shows the sign in form
  """
  def new(conn, _params) do
    render(conn, "new.html", changeset: Business.changeset(%Business{}))
  end

  @doc """
  If needed, creates a new business, otherwise finds the existing one.
  Creates a new request and emails the unique id to the business.
  """

  def create(conn, %{"business" => %{"email" => email}}) when not is_nil(email) do
    if business = Veil.get_business_by_email(email) do
      sign_and_email(conn, business)
    else
      with {:ok, business} <- Veil.create_business(email) do
        sign_and_email(conn, business)
      else
        error ->
          error
      end
    end
  end

  defp sign_and_email(conn, %Business{} = business) do
    with {:ok, request} <- Veil.create_request(conn, business),
         {:ok, email} <- Veil.send_login_email(conn, business, request) do
      render(conn, "show.html", business: business, email: email)
    else
      error ->
        error
    end
  end
end
