defmodule RegalocalWeb.FaqController do
  use RegalocalWeb, :controller

  @items [
    %{
      question: "RegaLocal es queda comissió de cada transacció?",
      answer:
        "El pagament es fa directament al comptes bancari o altres medis de pagament proporcionats pel comerç, i per tant, el destinatari rep l'import íntegre. No apliquem cap mena de comissió ni tarifa de serveis."
    }
  ]

  def index(conn, _params) do
    conn
    |> assign(:items, @items)
    |> render("index.html")
  end
end
