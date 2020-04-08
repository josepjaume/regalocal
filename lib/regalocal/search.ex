defmodule Regalocal.Search do
  import Ecto.Query, warn: false
  alias Regalocal.Repo
  import Geo.PostGIS

  alias Regalocal.Admin.Business
  alias Regalocal.Admin.Coupon

  def find_businesses_near!(%Geo.Point{} = geom, limit) do
    bids = business_ids_with_coupons()

    Business
    |> select([b], %{b | distance_meters: st_distance_in_meters(b.coordinates, ^geom)})
    |> where([b], b.id in ^bids)
    |> order_by([b], st_distance_in_meters(b.coordinates, ^geom))
    |> limit(^limit)
    |> Repo.all()
  end

  defp business_ids_with_coupons() do
    Coupon
    |> select([:business_id])
    |> where([c], c.status == "published" and not is_nil(c.business_id))
    |> Repo.all()
    |> Enum.map(fn c -> c.business_id end)
    |> Enum.uniq()
  end
end
