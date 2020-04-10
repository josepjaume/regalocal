defmodule Regalocal.Admin do
  @moduledoc """
  The Admin context.
  """
  import Ecto.Query, warn: false
  alias Regalocal.Repo

  alias Regalocal.Admin.Business
  alias Regalocal.Admin.Coupon
  alias Regalocal.Orders.Gift

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

  def list_coupons(business_id) do
    Coupon |> where(business_id: ^business_id) |> Repo.all()
  end

  def list_orders(business_id) do
    Gift |> where(business_id: ^business_id) |> Repo.all()
  end

  def get_coupon!(business_id, id),
    do: Coupon |> where(business_id: ^business_id, id: ^id) |> Repo.one!()

  def create_coupon(attrs \\ %{}) do
    %Coupon{}
    |> Coupon.changeset(attrs)
    |> Repo.insert()
  end

  def update_coupon(%Coupon{} = coupon, attrs) do
    if updatable?(coupon.id) do
      coupon
      |> Coupon.changeset(attrs)
      |> Repo.update()
    else
      {:error, :has_orders}
    end
  end

  def publish_coupon!(%Coupon{} = coupon) do
    if publishable?(coupon.id) do
      coupon
      |> Coupon.changeset(%{"status" => :published})
      |> Repo.update()
    else
      {:error, :unpublishable}
    end
  end

  def unpublish_coupon!(%Coupon{} = coupon) do
    if unpublishable?(coupon.id) do
      coupon
      |> Coupon.changeset(%{"status" => :draft})
      |> Repo.update()
    else
      {:error, :has_orders}
    end
  end

  def delete_coupon(%Coupon{} = coupon) do
    if updatable?(coupon.id) do
      Repo.delete(coupon)
    else
      {:error, :has_orders}
    end
  end

  def archive_coupon(%Coupon{} = coupon) do
    coupon
    |> Coupon.changeset(%{"archived" => true})
    |> Repo.update()
  end

  @doc """
  Updates a coupon.

  ## Examples

      iex> update_coupon(coupon, %{field: new_value})
      {:ok, %Coupon{}}

      iex> update_coupon(coupon, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def change_coupon(%Coupon{} = coupon) do
    Coupon.changeset(coupon, %{})
  end

  def get_gifts!(coupon_id) do
    Gift |> where(coupon_id: ^coupon_id) |> Repo.all()
  end

  def get_order!(business_id, gift_id) do
    Gift |> where(business_id: ^business_id, id: ^gift_id) |> Repo.one!()
  end

  def accepted_terms?(business_id) do
    Business |> where(id: ^business_id, accepted_terms: true) |> Repo.exists?()
  end

  def publishable?(coupon_id) do
    Coupon |> where(id: ^coupon_id, status: ^:draft, archived: false) |> Repo.exists?()
  end

  def updatable?(coupon_id), do: !has_gifts?(coupon_id) and !archived?(coupon_id)
  def unpublishable?(coupon_id), do: !has_gifts?(coupon_id) and !archived?(coupon_id)

  defp has_gifts?(coupon_id) do
    Gift |> where(coupon_id: ^coupon_id) |> Repo.exists?()
  end

  def pending_payment_confirmation?(gift) do
    gift.status == :pending_payment || gift.status == :paid
  end

  def ready_to_redeem?(%Coupon{status: :published}), do: true
  def ready_to_redeem?(%Coupon{}), do: false

  def archived?(coupon_id) do
    Coupon |> where(id: ^coupon_id, archived: true) |> Repo.exists?()
  end

  def redeemable?(%Gift{status: :redeemed}), do: false

  def redeemable?(%Gift{coupon_id: coupon_id}) do
    Coupon |> where(id: ^coupon_id, status: ^:redeemable) |> Repo.exists?()
  end

  def payment_received!(%Gift{} = gift) do
    if pending_payment_confirmation?(gift) do
      gift
      |> Gift.changeset(%{
        "status" => :payment_confirmed,
        "accepted_gift_terms" => true,
        "accepted_coupon_terms" => true
      })
      |> Repo.update()
    else
      {:error, :cannot_confirm_payment}
    end
  end

  def activate_coupon(%Coupon{} = coupon) do
    if ready_to_redeem?(coupon) do
      coupon
      |> Coupon.changeset(%{"status" => :redeemable})
      |> Repo.update()
    else
      {:error, :is_not_published}
    end
  end

  def redeem!(%Gift{} = gift) do
    if redeemable?(gift) do
      gift
      |> Gift.changeset(%{
        "status" => :redeemed,
        "accepted_gift_terms" => true,
        "accepted_coupon_terms" => true
      })
      |> Repo.update()
    else
      {:error, :cannot_redeem}
    end
  end
end
