defmodule RegalocalWeb.BusinessHelpers do
  use Phoenix.HTML

  def name(%{name: name}), do: name

  def owner_name(%{owner_name: name}), do: name

  def email(%{email: email}), do: email

  def picture(business) do
    picture(business, 8)
  end

  def picture(business = %{photo_id: nil}, size) do
    content_tag(:div,
      class: "shadow-sm inline-block flex items-center justify-center #{picture_classes(size)}"
    ) do
      content_tag(
        :span,
        (owner_name(business) || email(business)) |> String.capitalize() |> String.first(),
        class: "text-primary-500 font-bold pointer-events-none select-none",
        style: "margin-top: -0.05em; font-size: #{size / 8.0}rem"
      )
    end
  end

  def picture(%{photo_id: photo_id}, size) do
    img_tag(
      Cloudex.Url.for(photo_id, %{width: size * 15, height: size * 15}),
      class: "object-cover #{picture_classes(size)}"
    )
  end

  defp picture_classes(size) do
    "border border-gray-100 shadow-sm bg-white h-#{size} w-#{size} rounded-full"
  end
end
