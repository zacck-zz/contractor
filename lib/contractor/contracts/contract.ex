defmodule Contractor.Contracts.Contract do
  use Ecto.Schema
  import Ecto.Changeset

  alias Contractor.{
    Accounts.Person,
    Contracts.Category,
    Contracts.Contract,
    Contracts.Vendor
  }

  @type t :: %__MODULE__{}


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "contracts" do
    field :cost, :float
    field :end_date, :date
    timestamps(inserted_at: :created_at, updated_at: :updated_at)
    belongs_to :person, Person, foreign_key: :person_id, type: :binary_id
    belongs_to :vendor, Vendor, foreign_key: :vendor_id, type: :binary_id
    belongs_to :category, Category, foreign_key: :category_id, type: :binary_id
  end
end
