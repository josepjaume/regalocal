defmodule Regalocal.Admin do
  @moduledoc """
  The Admin context.
  """
  import Ecto.Query, warn: false
  alias Regalocal.Repo
  import Geo.PostGIS

  alias Regalocal.Admin.Business

  @doc """
  Gets a single business.

  Raises `Ecto.NoResultsError` if the Business does not exist.

  ## Examples

      iex> get_business!(123)
      %Business{}

      iex> get_business!(456)
      ** (Ecto.NoResultsError)

  """
  def get_business!(id), do: Repo.get!(Business, id)

  def find_businesses_near!(%Geo.Point{} = geom, limit_meters) do
    Business
    |> select([b], %{b | distance_meters: st_distance_in_meters(b.coordinates, ^geom)})
    |> where([b], st_distance_in_meters(b.coordinates, ^geom) < ^limit_meters)
    |> order_by([b], st_distance_in_meters(b.coordinates, ^geom))
    |> Repo.all()
  end

  @doc """
  Updates a business.

  ## Examples

      iex> update_business(business, %{field: new_value})
      {:ok, %Business{}}

      iex> update_business(business, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_business(%Business{} = business, attrs) do
    business
    |> Business.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a business.

  ## Examples

      iex> delete_business(business)
      {:ok, %Business{}}

      iex> delete_business(business)
      {:error, %Ecto.Changeset{}}

  """
  def delete_business(%Business{} = business) do
    Repo.delete(business)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking business changes.

  ## Examples

      iex> change_business(business)
      %Ecto.Changeset{source: %Business{}}

  """
  def change_business(%Business{} = business) do
    Business.changeset(business, %{})
  end
end
