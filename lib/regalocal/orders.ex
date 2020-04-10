defmodule Regalocal.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias Regalocal.Repo
  alias Regalocal.Orders.Gift
  alias Regalocal.Admin.Coupon
  alias Regalocal.Admin.Business

  def get_coupon!(id) do
    Repo.get!(Coupon, id)
  end

  def get_business!(id), do: Business |> where(accepted_terms: true) |> Repo.one!()

  @doc """
  Returns the list of gifts.

  ## Examples

      iex> list_gifts()
      [%Gift{}, ...]

  """
  def list_gifts do
    Repo.all(Gift)
  end

  @doc """
  Gets a single gift.

  Raises `Ecto.NoResultsError` if the Gift does not exist.

  ## Examples

      iex> get_gift!(123)
      %Gift{}

      iex> get_gift!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gift!(id), do: Repo.get!(Gift, id)

  def get_gift_by_reference!(reference) do
    Gift |> where(reference: ^reference) |> Repo.one()
  end

  @doc """
  Creates a gift.

  ## Examples

      iex> create_gift(%{field: value})
      {:ok, %Gift{}}

      iex> create_gift(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gift(attrs \\ %{}) do
    %Gift{}
    |> Gift.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gift.

  ## Examples

      iex> update_gift(gift, %{field: new_value})
      {:ok, %Gift{}}

      iex> update_gift(gift, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gift(%Gift{} = gift, attrs) do
    gift
    |> Gift.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gift changes.

  ## Examples

      iex> change_gift(gift)
      %Ecto.Changeset{source: %Gift{}}

  """
  def change_gift(%Gift{} = gift) do
    Gift.changeset(gift, %{})
  end

  defp generate_reference() do
    1..9
    |> Enum.map(fn _ -> String.downcase(Faker.Util.letter()) end)
    |> Enum.chunk_every(3)
    |> Enum.map(fn letters -> Enum.join(letters) end)
    |> Enum.join("-")
  end

  defp reference_exists?(reference) do
    Gift |> where(reference: ^reference) |> Repo.exists?()
  end

  def generate_unique_reference() do
    ref = generate_reference()

    if !reference_exists?(ref) do
      ref
    else
      generate_unique_reference()
    end
  end
end
