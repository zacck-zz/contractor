defmodule Contractor.Accounts.Person do
  use Ecto.Schema
  import Ecto.Changeset
  alias Contractor.{
    Accounts.Person,
  }

  @type t :: %__MODULE__{}


  # set up binary key
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "people" do
    field :token, :string
    field :hash, :string
    field :email, :string
    field :name, :string

    timestamps(inserted_at: :joined_on, updated_at: :updated_on)
  end

  @spec changeset(Person.t, map) :: Ecto.Changeset.t()
  def changeset(%Person{} = person, attrs) do
    person
    |> cast(attrs, [:hash, :token, :email, :name])
    |> validate_required([:email, :hash, :token, :name])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
