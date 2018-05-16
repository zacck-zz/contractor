defmodule Contractor.Accounts.Person do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}


  # set up binary key
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "people" do
    field :token, :string
    field :hash, :string

    timestamps(inserted_at: :joined_on, updated_at: :updated_on)
  end
end
