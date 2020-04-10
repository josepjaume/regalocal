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
    n =
      index
      |> Integer.to_string()
      |> String.pad_leading(4, "0")

    add = @addresses |> Enum.random()
    photo_id = @photos |> Enum.random()
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

    times = Faker.random_between(1, 5)
    1..times |> Enum.each(fn _ -> insert_coupon(b.id) end)
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

    times = Faker.random_between(0, 9)
    0..times |> Enum.each(fn _ -> insert_gift(c) end)
    c
  end

  def clear do
    Coupon |> Repo.delete_all()
    Business |> Repo.delete_all()
  end

  def seed! do
    clear()

    insert_business(999, "txus@codegram.com")
    insert_business(998, "oriol@codegram.com")
    insert_business(997, "josepjaume@codegram.com")

    1..100
    |> Enum.map(fn i ->
      insert_business(i).email
    end)
    |> Enum.take(5)
    |> IO.inspect()
  end
end
