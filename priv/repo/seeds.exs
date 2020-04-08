defmodule Regalocal.Seeder do
  alias Regalocal.Repo
  alias Regalocal.Profiles.Business
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
    "5e535c632b568a7abf1af4de_peep-92_oj1sxm",
    "5e53521c4600805ff88b3bb5_peep-16_adwxs7",
    "5e5356897371bb93979e09cd_peep-42_kukxek",
    "5e535741f5fa1a13a1f8f233_peep-48_ptglnj",
    "5e5350fb460080ed648acdc3_peep-7_vzelw1",
    "5e535d35550b761a3af880d9_peep-99_bqglyq",
    "5e535d195197053fe1a71f4b_peep-98_iujrhb",
    "5e5356a864109d65bb0139b9_peep-43_c9ycva",
    "5e535778c99250c02ec82750_peep-50_g0dbhr",
    "5e51c6d88c34f86ae14980f1_peep-4_plmduc",
    "5e53517fc6b2492d63287d6d_peep-11_lpnina",
    "5e535727550b765a60f50817_peep-47_gyrhsx",
    "5e535b9cd8713177a910e39b_peep-85_gnafbp",
    "5e535bd3460080e5d68ef5ac_peep-87_skqd35"
  ]

  def insert_business(index) do
    n =
      index
      |> Integer.to_string()
      |> String.pad_leading(4, "0")

    add = @addresses |> Enum.random()
    photo_id = @photos |> Enum.random()
    {:ok, %Geolocation{address: address} = geo} = Geolocation.locate(add)

    Repo.insert!(%Business{
      address: address,
      coordinates: Geolocation.to_geopoint(geo),
      billing_address: add,
      bizum_number: "600100200",
      email: Faker.Internet.email(),
      facebook: Faker.Internet.user_name(),
      google_maps_url: "https://maps.google.es",
      iban: "ES210021002100210021" <> n,
      instagram: Faker.Internet.user_name(),
      legal_name: Faker.Company.name(),
      name: Faker.Company.En.name(),
      owner_name: Faker.Name.Es.name(),
      phone: "937100200",
      story: Faker.Company.En.catch_phrase(),
      tripadvisor_url: "https://www.tripadvisor.com",
      vat_number: "B9900" <> n,
      website: Faker.Internet.url(),
      whatsapp: "600100200",
      photo_id: photo_id,
      accepted_terms: true
    })
  end

  def clear do
    Repo.delete_all()
  end
end

1..100 |> Enum.each(fn i -> Regalocal.Seeder.insert_business(i) end)
