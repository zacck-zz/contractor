defmodule Contractor.Accounts.Person do
  @moduledoc """
  Module to Handle Chagesets for the Person 
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Contractor.{
    Accounts.Person,
    Contracts.Contract
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
    has_many :contracts, Contract, on_delete: :delete_all
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
