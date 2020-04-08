defmodule RegalocalWeb.SearchController do
  use RegalocalWeb, :controller
  alias Regalocal.Search
  alias Regalocal.Geolocation

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, %{"latitude" => latitude, "longitude" => longitude}) do
    geo =
      Geolocation.to_geopoint(%{lat: String.to_float(latitude), lon: String.to_float(longitude)})

    coordinates = %{latitude: String.to_float(latitude), longitude: String.to_float(longitude)}

    businesses = Search.find_businesses_near!(geo, 25)

    conn
    |> assign(:businesses, businesses)
    |> render("index.html")
  end
end
