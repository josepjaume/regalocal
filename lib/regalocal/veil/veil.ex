defmodule Regalocal.Veil do
  @moduledoc """
  Veil's main context
  """
  alias Regalocal.Repo
  alias Regalocal.Veil.{Business, Request, Session}
  alias RegalocalWeb.Veil.{Mailer, LoginEmail}
  alias Veil.{Cache, Secure}

  @doc """
  Gets business associated with business_id
  """
  def get_business(business_id) do
    Cache.get_or_update(:business, business_id, &get_business_repo/1)
  end

  defp get_business_repo(business_id) do
    Repo.get(Business, business_id)
  end

  @doc """
  Gets business associated with email
  """
  def get_business_by_email(email) do
    Repo.get_by(Business, email: email |> String.downcase())
  end

  @doc """
  Creates an unverified business with the given email
  """
  def create_business(email) do
    %Business{}
    |> Business.changeset(%{email: email})
    |> Cache.put(:business, &Repo.insert/1)
  end

  @doc """
  Sets verified flag on the business associated with the business_id given, if needed
  """
  def verify_business(%Business{} = business) do
    if not business.verified and not is_nil(business.email) do
      update_business(business, %{verified: true})
    else
      {:ok, business}
    end
  end

  def verify_business(business_id) do
    with {:ok, business} <- get_business(business_id) do
      verify_business(business)
    else
      error -> error
    end
  end

  def update_business(%Business{} = business, attrs) do
    with {:ok, business} <- do_update_business(business, attrs) do
      {:ok, business}
    else
      error -> error
    end
  end

  defp do_update_business(%Business{} = business, attrs) do
    business
    |> Business.changeset(attrs)
    |> Cache.put(:business, &Repo.update/1)
  end

  @doc """
  Sends a new login email to the business
  """
  def send_login_email(conn, %Business{} = business, %Request{} = request) do
    business.email
    |> LoginEmail.generate(new_session_url(conn, request.unique_id))
    |> Mailer.deliver()
  end

  defp new_session_url(conn, unique_id) do
    cur_uri = Phoenix.Controller.endpoint_module(conn).struct_url()

    cur_path = RegalocalWeb.Router.Helpers.session_path(conn, :create, unique_id)

    RegalocalWeb.Router.Helpers.url(cur_uri) <> cur_path
  end

  @doc """
  Creates a new login request for the business provided
  """
  def create_request(conn, %Business{} = business) do
    phoenix_token = Phoenix.Token.sign(conn, request_salt(), business.id)
    unique_id = Secure.generate_unique_id(conn)

    %Request{}
    |> Request.changeset(%{
      business_id: business.id,
      phoenix_token: phoenix_token,
      unique_id: unique_id,
      ip_address: Secure.get_user_ip(conn)
    })
    |> Repo.insert()
  end

  @doc """
  Gets the request associated with the unique id
  """
  def get_request(unique_id) do
    if request = Repo.get_by(Request, unique_id: unique_id) do
      {:ok, request}
    else
      {:error, :no_permission}
    end
  end

  @doc """
  Verifies that the phoenix_token inside the request/session is valid and has not expired
  """
  def verify(%Session{} = session) do
    verify(RegalocalWeb.Endpoint, session)
  end

  def verify(%Request{} = request) do
    verify(RegalocalWeb.Endpoint, request)
  end

  def verify(conn, %Session{phoenix_token: phoenix_token}) do
    max_age = Application.get_env(:veil, :session_expiry)
    verify_session_token(conn, phoenix_token, max_age)
  end

  def verify(conn, %Request{phoenix_token: phoenix_token}) do
    max_age = Application.get_env(:veil, :sign_in_link_expiry)
    Phoenix.Token.verify(conn, request_salt(), phoenix_token, max_age: max_age)
  end

  @doc """
  Creates a new session for the business associated with business_id
  """
  def create_session(conn, business_id) do
    %Session{}
    |> Session.changeset(%{
      business_id: business_id,
      phoenix_token: create_session_token(conn, business_id),
      unique_id: Secure.generate_unique_id(conn),
      ip_address: Secure.get_user_ip(conn)
    })
    |> Cache.put(:veil_sessions, &Repo.insert/1, & &1.unique_id)
  end

  defp create_session_token(conn, business_id) do
    Phoenix.Token.sign(conn, session_salt(), business_id)
  end

  @doc """
  Gets the session associated with the unique id
  """
  def get_session(nil), do: {:error, :no_permission}

  def get_session(unique_id) do
    with {:ok, {:ok, session}} <- Cache.get_and_refresh(:veil_sessions, unique_id) do
      unless is_nil(session) do
        {:ok, session}
      else
        if session = Repo.get_by(Session, unique_id: unique_id) do
          Cachex.put(:veil_sessions, unique_id, session)
          {:ok, session}
        else
          {:error, :no_session_found}
        end
      end
    else
      error -> error
    end
  end

  @doc """
  Extends the session if it is older than the refresh_expiry_interval, by signing a new
  phoenix_token and replacing the one in the database
  """
  def extend_session(
        conn,
        %Session{phoenix_token: phoenix_token, business_id: business_id} = session
      ) do
    max_age = Application.get_env(:veil, :refresh_expiry_interval)

    case verify_session_token(conn, phoenix_token, max_age) do
      {:error, :expired} ->
        session
        |> Session.changeset(%{phoenix_token: create_session_token(conn, business_id)})
        |> Cache.put(:veil_sessions, &Repo.update/1, & &1.unique_id)

      _ ->
        nil
    end
  end

  defp verify_session_token(conn, phoenix_token, max_age) do
    Phoenix.Token.verify(conn, session_salt(), phoenix_token, max_age: max_age)
  end

  @doc """
  Deletes the request/session
  """
  def delete(%Session{} = session) do
    Cachex.del(:veil_sessions, session.unique_id)
    Repo.delete(session)
  end

  def delete(%Request{} = request) do
    Repo.delete(request)
  end

  @doc """
  Deletes the session by unique id
  """
  def delete_session(unique_id) do
    with {:ok, session} <- get_session(unique_id) do
      delete(session)
    else
      error -> error
    end
  end

  def delete_expired(list) when is_list(list) do
    list
    |> Enum.each(fn event ->
      case verify(event) do
        {:error, _} ->
          delete(event)

        {:ok, _} ->
          nil
      end
    end)
  end

  @doc """
  Deletes all expired requests
  """
  def delete_expired_requests do
    Request
    |> Repo.all()
    |> delete_expired()
  end

  @doc """
  Deletes all expired sessions
  """
  def delete_expired_sessions do
    Session
    |> Repo.all()
    |> delete_expired()
  end

  defp request_salt, do: Application.get_env(:regalocal, Regalocal.Veil)[:request_salt]
  defp session_salt, do: Application.get_env(:regalocal, Regalocal.Veil)[:session_salt]
end
