defmodule RegalocalWeb.FaqController do
  use RegalocalWeb, :controller

  @items [
    %{
      question: "No trobo un comerç que m'agradaria que hi fos. Què puc fer?",
      answer:
        "En aquest cas, t'encoratgem a que et posis en contacte amb ells per a fer-los saber de Regalocal, especialment si estan en dificultats pel COVID-19. Entre tots i totes podem aportar el nostre granet de sorra."
    },
    %{
      question: "RegaLocal es queda comissió de cada transacció?",
      answer:
        "No, Regalocal és un servei gratüit sense ànim de lucre. No apliquem cap mena de comissió ni tarifa de serveis. El pagament es fa directament al compte bancari o Bizum proporcionats pel comerç, i per tant, el destinatari rep l'import íntegre."
    },
    %{
      question: "Com a comprador, què és el que estic regalant?",
      answer:
        "Els comerços que estàn donats d'alta posen a disposició teva uns cupons de cert valor que es podràn fer servir un cop el comerç indiqui que pot rebre clients. Quan compres un cupó, el comerç sempre et fa un petit descompte com a agraïment, i la persona a qui li regales el rep immediatament."
    },
    %{
      question: "Quins comerços es poden unir a Regalocal?",
      answer:
        "Petits i mitjans comerços de cara al públic: restaurants, cafeteries, hostals, perruqueries, veterinaris, teatres, estudis de tatuatge, en general qualsevol empresa petita o mitjana que hagi hagut d'aturar o reduïr la seva activitat degut al COVID-19."
    },
    %{
      question: "Quines garanties sobre els cupons que regalo?",
      answer:
        "Comprar un cupó pot comportar cert risc en cas de que el comerç faci fallida. En aquest cas, t'hauràs de posar en contacte directament amb el comerç per a negociar un possible reemborsament."
    },
    %{
      question: "Com puc obtenir un ticket o factura del meu regal?",
      answer:
        "Posa't en contacte amb el comerç directament. Trobaràs les seves dades de contacte en el mail de compra."
    },
    %{
      question: "Com puc posar-me en contacte amb RegaLocal?",
      answer:
        "Pots obrir un chat amb la icona de suport d'abaix a la dreta d'aquest pàgina, o bé enviar-nos un correu electrònic a regalocal@codegram.com."
    }
  ]

  def index(conn, _params) do
    conn
    |> assign(:items, @items)
    |> render("index.html")
  end
end
