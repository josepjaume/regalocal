defmodule Regalocal.Veil.Request do
  @moduledoc """
  Veil's Request Schema - a request is a login attempt
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Regalocal.Veil.Business

  schema "veil_requests" do
    field(:unique_id, :string)
    field(:phoenix_token, :string)
    field(:ip_address, :string)
    belongs_to(:business, Business)

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:unique_id, :phoenix_token, :business_id, :ip_address])
    |> validate_required([:unique_id, :phoenix_token, :business_id, :ip_address])
  end
end
