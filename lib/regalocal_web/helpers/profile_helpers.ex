defmodule RegalocalWeb.ProfileHelpers do
  use Phoenix.HTML

  def name(conn) do
    business(conn)
    |> Map.get(:name)
  end

  def email(conn) do
    business(conn)
    |> Map.get(:email)
  end

  def business(conn) do
    conn.assigns[:current_business]
  end

  def picture(conn, width, height, options \\ []) do
    img_tag(
      Cloudex.Url.for(business(conn).photo_id, %{width: width, height: height}),
      options
    )
  end
end
