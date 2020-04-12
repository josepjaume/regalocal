defmodule RegalocalWeb.PageView do
  use RegalocalWeb, :view
  import RegalocalWeb.PublicLayoutHelpers

  def title(:index, _assigns) do
    "Regala solidaritat al comerç local"
  end

  def title(:about, _assigns) do
    "Sobre nosaltres"
  end

  def title(:cookies, _assigns) do
    "Política de Cookies"
  end

  def title(:privacy, _assigns) do
    "Política de Privacitat"
  end

  def title(:terms, _assigns) do
    "Avís Legal"
  end
end
