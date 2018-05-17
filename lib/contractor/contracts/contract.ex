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
    belongs_to :vendor, Vendor, foreign_key: :vendor_id, type: :binary_id, on_replace: :update
    belongs_to :category, Category, foreign_key: :category_id, type: :binary_id, on_replace: :update
  end

  @spec create_changeset(Person.t, Vendor.t, Category.t, map) :: Ecto.Changeset.t()
  def create_changeset(%Person{} = person, %Vendor{} = vendor, %Category{} = category, attrs) do
    %Contract{}
    |> cast(attrs,[:cost, :end_date])
    |> validate_required([:cost, :end_date])
    |> put_assoc(:person, person)
    |> put_assoc(:vendor, vendor)
    |> put_assoc(:category, category)
  end

  @spec update_changeset(Contract.t, Vendor.t, Category.t, map) :: Ecto.Changeset.t()
  def update_changeset(%Contract{} = contract, %Vendor{} = vendor, %Category{} = category, attrs) do
    contract
    |> cast(attrs, [:cost, :end_date])
    |> validate_required([:cost, :end_date])
    |> put_assoc(:person, contract.person)
    |> put_assoc(:vendor, [vendor_id: vendor.id])
    |> put_assoc(:category, [category_id: category.id])
  end
end
