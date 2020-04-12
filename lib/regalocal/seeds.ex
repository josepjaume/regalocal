defmodule Regalocal.Seeds do
  alias Regalocal.Repo
  alias Regalocal.Admin.Business
  alias Regalocal.Admin.Coupon
  alias Regalocal.Orders.Gift
  alias Regalocal.Orders
  alias Regalocal.Geolocation

  @addresses [
    "Pare Llaurador 113, baixos, 08224 terrassa",
    "Rambla Egara 235, 08224 terrassa",
    "Carrer de Vinyals, 61, 08221 Terrassa, Barcelona",
    "Carrer Navarra, 10, 08227 Terrassa, Barcelona",
    "Carrer de Colom, 112, 08222 Terrassa, Barcelona",
    "Carrer d'Amèrica, 15, 19, 08205 Sabadell, Barcelona",
    "Carretera de Prats de Lluçanès, 401, 08201 Sabadell, Barcelona",
    "Polígono Industrial Can Trias, Carrer Miquel Servet, s/n, 08232, Barcelona",
    "Carrer Bailèn, 29 - 31, 08224 Terrassa, Barcelona"
  ]

  @photos [
    "Regalocal/5e535c632b568a7abf1af4de_peep-92_oj1sxm.png",
    "Regalocal/5e53521c4600805ff88b3bb5_peep-16_adwxs7.png",
    "Regalocal/5e5356897371bb93979e09cd_peep-42_kukxek.png",
    "Regalocal/5e535741f5fa1a13a1f8f233_peep-48_ptglnj.png",
    "Regalocal/5e5350fb460080ed648acdc3_peep-7_vzelw1.png",
    "Regalocal/5e535d35550b761a3af880d9_peep-99_bqglyq.png",
    "Regalocal/5e535d195197053fe1a71f4b_peep-98_iujrhb.png",
    "Regalocal/5e5356a864109d65bb0139b9_peep-43_c9ycva.png",
    "Regalocal/5e535778c99250c02ec82750_peep-50_g0dbhr.png",
    "Regalocal/5e51c6d88c34f86ae14980f1_peep-4_plmduc.png",
    "Regalocal/5e53517fc6b2492d63287d6d_peep-11_lpnina.png",
    "Regalocal/5e535727550b765a60f50817_peep-47_gyrhsx.png",
    "Regalocal/5e535b9cd8713177a910e39b_peep-85_gnafbp.png",
    "Regalocal/5e535bd3460080e5d68ef5ac_peep-87_skqd35.png"
  ]

  def insert_gift(coupon) do
    Repo.insert!(%Gift{
      reference: Orders.generate_unique_reference(),
      amount: coupon.amount,
      value: coupon.value,
      business_id: coupon.business_id,
      coupon_id: coupon.id,
      buyer_email: Faker.Internet.email(),
      buyer_name: Faker.Name.Es.name(),
      buyer_phone: Faker.Phone.EnGb.mobile_number(),
      recipient_name: Faker.Name.Es.name(),
      recipient_email: Faker.Internet.email(),
      message_for_recipient: Faker.Util.to_sentence(Faker.Lorem.paragraphs(2)),
      status: [:pending_payment, :paid, :payment_confirmed] |> Enum.random()
    })
  end

  def insert_business(index) do
    [account, domain] = String.split(Faker.Internet.email(), "@")
    insert_business(index, "#{account}#{index}@#{domain}")
  end

  def insert_business(index, email) do
    insert_business(index, email, true)
  end

  def insert_business(index, email, public) do
    n =
      index
      |> Integer.to_string()
      |> String.pad_leading(4, "0")

    add = @addresses |> Enum.random()
    photo_id = Enum.random([nil, Enum.random(@photos)])
    {:ok, %Geolocation{address: address} = geo} = Geolocation.locate(add)

    name = Faker.Company.En.name()

    b =
      Repo.insert!(%Business{
        address: address,
        coordinates: Geolocation.to_geopoint(geo),
        billing_address: add,
        bizum_number: "600100200",
        email: email,
        facebook: Faker.Internet.user_name(),
        google_maps_url: "https://maps.google.es",
        iban: "ES210021002100210021" <> n,
        instagram: Faker.Internet.user_name(),
        legal_name: name,
        name: name,
        owner_name: Faker.Name.Es.name(),
        phone: "937100200",
        story: Faker.Util.to_sentence(Faker.Lorem.paragraphs(4)),
        tripadvisor_url: "https://www.tripadvisor.com",
        vat_number: "B9900" <> n,
        website: Faker.Internet.url(),
        whatsapp: "600100200",
        photo_id: photo_id,
        accepted_terms: true,
        verified: true
      })

    if public do
      times = Faker.random_between(1, 5)
      1..times |> Enum.each(fn _ -> insert_coupon(b.id) end)
    end

    b
  end

  def insert_coupon(business_id) do
    discount = Faker.random_between(5, 25)
    value = Faker.random_between(5, 120)

    c =
      Repo.insert!(%Coupon{
        business_id: business_id,
        title: to_string(discount) <> "% off!",
        value: value,
        discount: discount,
        terms: Faker.Util.to_sentence(Faker.Lorem.paragraphs(2)),
        status: [:published, :draft] |> Enum.random(),
        amount: Float.round(value * (100 - discount) / 100, 2)
      })

    if c.status == :published do
      times = Faker.random_between(0, 9)
      0..times |> Enum.each(fn _ -> insert_gift(c) end)
    end

    c
  end

  def clear do
    Gift |> Repo.delete_all()
    Coupon |> Repo.delete_all()
    Business |> Repo.delete_all()
  end

  def seed! do
    clear()

    insert_business(999, "txus@codegram.com", false)
    insert_business(998, "oriol@codegram.com", false)
    insert_business(997, "josepjaume@codegram.com", false)

    santa_cereza()
    clinica_veterinaria_grau()
    frita_kahlo()
    delightcious_cakes()

    # 1..100
    # |> Enum.map(fn i ->
    #   insert_business(i).email
    # end)
    # |> Enum.take(5)
    # |> IO.inspect()
  end

  def santa_cereza() do
    add = "Raval de Montserrat, 31, Terrassa, ES 08221"
    photo_id = "Regalocal/nicolas_santacereza.jpg"
    {:ok, %Geolocation{address: address} = geo} = Geolocation.locate(add)

    b =
      Repo.insert!(%Business{
        address: address,
        coordinates: Geolocation.to_geopoint(geo),
        billing_address: add,
        email: "nicolas@santacereza.com",
        google_maps_url: "https://maps.google.es",
        iban: "ES2100210021002100218746",
        legal_name: "Santa Cereza S.L.",
        name: "Santa Cereza",
        owner_name: "Nicolás",
        phone: "938015057",
        tripadvisor_url:
          "https://www.tripadvisor.com/Restaurant_Review-g665811-d15664318-Reviews-Santa_Cereza-Terrassa_Catalonia.html#REVIEWS",
        story:
          "Som una cafeteria d'especialitat, un espai amb personalitat creat des de la il·lusió, on podràs gaudir menjant creps d'una manera alternativa i prendre una tassa de cafè d'especialitat. Situats al centre de Terrassa, pretenem alimentar els teus moments del dia a dia cuidant amb cura tots els detalls. La vida té el gust que tu vulguis i la nostra sap a creps i a cafè. I a tu, a què et sap la vida?",
        facebook: "stantacerezarest",
        vat_number: "B64148722",
        website: "https://www.facebook.com/santacerezarest",
        photo_id: photo_id,
        accepted_terms: true,
        verified: true
      })

    Repo.insert!(%Coupon{
      business_id: b.id,
      title: "Cafès i pastís",
      value: 15,
      discount: 20,
      terms: "Vàlid per a tota la gamma d'espresso, filtre i tès, i tots els pastissos",
      status: :published,
      amount: Float.round(15 * (100 - 20) / 100, 2)
    })

    Repo.insert!(%Coupon{
      business_id: b.id,
      title: "Sopar de tapes",
      value: 35,
      discount: 15,
      terms: "Vàlid per totes les tapes del menú i begudes",
      status: :published,
      amount: Float.round(35 * (100 - 15) / 100, 2)
    })
  end

  def frita_kahlo() do
    add = "Plaça de Salvador Espriu, 4L, 08221 Terrassa, Barcelona"

    photo_id =
      "Regalocal/propietaries-del-frita-kahlo-la-irene-i-la-alba-5b3f4748a7664_pysxns.jpg"

    {:ok, %Geolocation{address: address} = geo} = Geolocation.locate(add)

    b =
      Repo.insert!(%Business{
        address: address,
        coordinates: Geolocation.to_geopoint(geo),
        billing_address: add,
        email: "viulafrita@fritakahlo.com",
        google_maps_url: "https://goo.gl/maps/sWi8x4gKAPoeXoSM8",
        iban: "ES2100210021002100218291",
        legal_name: "La Frita Kahlo S.L.",
        name: "La Frita Kahlo",
        owner_name: "Irene i Alba",
        phone: "938015057",
        whatsapp: "671376085",
        story:
          "Som una patateria inspirada en Brusseles però amb estil mediterrani i ingredients de proximitat. Vam obrir portes per la Festa Major de Terrassa del 2018. Tot i tenir com a especialitat les patates fregides, la nostra idea és poder l'esmorzar al matí a base de fruita i verdura, a més de poder gaudir d'una tassa de cafè. A la tarda, venem les patates fregides amb diferents toppings (acompanyaments, com ara bacon o cheddar) i salses. Respecte els toppings, en tenim uns de preestablerts però a més a més en algunes èpoques de l'any n'afegim de nous, com en la temporada de bolets o de carabasses. Les 15 salses són creades per nosaltres, jugant amb bases veganes i lliures de gluten, evitant treballar amb llet de vaca i l'ou.",
        facebook: "viulafrita",
        vat_number: "B91148781",
        website: "https://la-frita-kahlo.negocio.site",
        photo_id: photo_id,
        accepted_terms: true,
        verified: true
      })

    Repo.insert!(%Coupon{
      business_id: b.id,
      title: "Patates grans i vermut per dos",
      value: 12,
      discount: 20,
      terms:
        "Vàlid per a una ració de patates grans amb un sol topping i dos vermuts de la casa, o dues canyes.",
      status: :published,
      amount: Float.round(12 * (100 - 20) / 100, 2)
    })

    Repo.insert!(%Coupon{
      business_id: b.id,
      title: "Especial grups!",
      value: 45,
      discount: 15,
      terms: "Tres racions de patates grans amb un topping i una salsa i 6 begudes!",
      status: :published,
      amount: Float.round(45 * (100 - 15) / 100, 2)
    })
  end

  def clinica_veterinaria_grau() do
    add = "Carrer del Pare Llaurador, 153, 08224 Terrassa, Barcelona"

    photo_id = "Regalocal/ramon_grau.jpg"

    {:ok, %Geolocation{address: address} = geo} = Geolocation.locate(add)

    b =
      Repo.insert!(%Business{
        address: address,
        coordinates: Geolocation.to_geopoint(geo),
        billing_address: add,
        email: "ramongrau@clinicagrau.com",
        google_maps_url: "https://goo.gl/maps/YKFECrUMv69nRN8F7",
        iban: "ES2100210021002100217183",
        legal_name: "Clínica Veterinària Grau S.L.",
        name: "Clínica Veterinària Grau",
        owner_name: "Ramón Grau",
        phone: "937880557",
        story:
          "La nostra clínica amb més de 20 anys d'història està formada per un grup de vuit a deu veterinaris especialitzats, auxiliars i secretàries, dedicats a l’atenció dels seus animals domèstics com ara gossos, gats i tot tipus d’animals exòtics.",
        facebook: "Clinicaveterinariaramongrau",
        vat_number: "B91148789",
        website: "https://clinicaveterinariaramongrau.com",
        photo_id: photo_id,
        accepted_terms: true,
        verified: true
      })

    Repo.insert!(%Coupon{
      business_id: b.id,
      title: "Perruqueria per animals",
      value: 50,
      discount: 15,
      terms: "Val per tots els serveis de perruqueria",
      status: :published,
      amount: Float.round(50 * (100 - 15) / 100, 2)
    })
  end

  def delightcious_cakes() do
    add = "Vinyals, 27, 08221 Terrassa, España"
    photo_id = "Regalocal/delightciouscakes.jpg"

    {:ok, %Geolocation{address: address} = geo} = Geolocation.locate(add)

    b =
      Repo.insert!(%Business{
        address: address,
        coordinates: Geolocation.to_geopoint(geo),
        billing_address: add,
        email: "hola@delightciouscakes.com",
        google_maps_url: "https://g.page/Delightciouscakes?share",
        iban: "ES2100210083002100218291",
        legal_name: "Delightcious Cake Shop Cafe SL",
        name: "Delightcious Cakes",
        owner_name: "Jordi i Mar",
        phone: "937354634",
        whatsapp: "633664884",
        story:
          "Després de molt temps fent pastissos personalitzats per encàrrec ens vam animar a obrir en nostre propi local... durant l'agost de 2019! Des de llavors no hem parat de servir pastissos i cafès cada setmana. La nostra oferta de pastissos és molt variada: carrot cake, red velvet, pastís de formatge, brownies i també tenim opcions veganes!",
        facebook: "viulafrita",
        vat_number: "B91249735",
        website: "https://delightcious-cake-shop.negocio.site",
        photo_id: photo_id,
        accepted_terms: true,
        verified: true
      })

    Repo.insert!(%Coupon{
      business_id: b.id,
      title: "Berena amb un tall de pastís!",
      value: 12,
      discount: 20,
      terms: "Dos talls de pastissos del dia acompanyats d'un cafè o cafè amb llet.",
      status: :published,
      amount: Float.round(12 * (100 - 20) / 100, 2)
    })
  end
end
