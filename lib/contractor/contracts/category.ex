defmodule Contractor.Contracts.Category do
  @moduledoc """
  Module to handle the Category Records in the system
  Use this to create and validate changesets
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Contractor.{
    Contracts.Category,
    Contracts.Vendor
  }

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "categories" do
    field :name, :string
    belongs_to :vendor, Vendor, foreign_key: :vendor_id, type: :binary_id
    timestamps(inserted_at: :created_at, updated_at: :updated_at)
  end

  @spec changeset(%Category{}, map) :: {:ok, Category.t} | {:error, Ecto.Changeset.t()}
  def changeset(%Category{} = cat, attrs ) do
    cat
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  @spec create_changeset(Vendor.t, map) :: Ecto.Changeset.t()
  def create_changeset(%Vendor{} = vendor, attrs) do
    %Category{}
    |> changeset(attrs)
    |> put_assoc(:vendor, vendor)
  end
end
