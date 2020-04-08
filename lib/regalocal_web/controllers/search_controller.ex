defmodule RegalocalWeb.SearchController do
  use RegalocalWeb, :controller

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, %{"latitude" => latitude, "longitude" => longitude}) do
    coordinates = %{latitude: String.to_float(latitude), longitude: String.to_float(longitude)}

    conn
    |> assign(:coordinates, coordinates)
    |> render("index.html")
  end
end
