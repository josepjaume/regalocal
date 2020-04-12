defmodule RegalocalWeb.BusinessView do
  use RegalocalWeb, :view
  import RegalocalWeb.PublicLayoutHelpers
  alias RegalocalWeb.BusinessHelpers, as: Business

  def title(:show, %{business: %{name: name}}), do: name
  def meta_description(:show, %{business: %{story: story}}), do: story |> String.slice(0..200)
end
