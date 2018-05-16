defmodule Contractor.Contracts.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Contractor.{
    Contracts.Category,
    Contracts.Vendor
  }

  @type t :: %__MODULE__{}

  schema "categories" do
    field :name, :string
    belongs_to :vendor, Vendor
  end

  @spec changeset(%Category{}, map) :: {:ok, Category.t} | {:error, Ecto.Changeset.t()}
  def changeset(%Category{} = cat, attrs ) do
    cat
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

end
