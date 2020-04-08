defmodule Regalocal.Geolocation do
  defstruct lat: nil, lon: nil, address: nil

  def locate(raw_address) do
    case Geocoder.call(raw_address) do
      {:ok,
       %Geocoder.Coords{
         lat: lat,
         lon: lon,
         location:
           %Geocoder.Location{
             formatted_address: address
           } = loc
       }} ->
        if loc.country_code == "ES" do
          {:ok, %Regalocal.Geolocation{lat: lat, lon: lon, address: address}}
        else
          {:error, "Address is not in Spain"}
        end

      {:error, _} ->
        {:error, "Could not geolocate " <> raw_address}
    end
  end

  def to_geopoint(%{lat: lat, lon: lon}) do
    %Geo.Point{coordinates: {lat, lon}, srid: 4326}
  end
end
