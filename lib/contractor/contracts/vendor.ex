defmodule Contractor.Contracts.Vendor do
  use Ecto.Schema
  import Ecto.Changeset
  alias Contractor.{
    Contracts.Vendor
  }

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "vendors" do
    field :name , :string
    timestamps(inserted_at: :created_at, updated_at: :updated_at)
  end

  @spec changeset(Vendor.t, map) :: {:ok, Ecto.Changeset.t()} | {:error, Ecto.Changeset.t()}
  def changeset(%Vendor{} = vendor, attrs) do
    vendor
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
