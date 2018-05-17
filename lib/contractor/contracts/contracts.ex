defmodule Contractor.Contracts do
  @moduledoc """
  Boundary Module for the Contracts context
  This module contains all actions that are associated with
  Managing User Contracts, Contract Vendors and Contract Categories
  """
  import Ecto.Query, warn: false

  alias Contractor.{
    Repo,
    Accounts.Person,
    Contracts.Category,
    Contracts.Contract,
    Contracts.Vendor
  }

  @spec get_contract(String.t()) :: {:ok, Contract.t} | {:error, String.t()}
  def get_contract(id)do
    with %Contract{} = contract <- Contract |> Repo.get(id) do
      {:ok, contract}
    else
      nil ->
        {:error, "Contract with id: #{id} doesn't exist" }
      end
  end

  @spec get_user_contracts(Person.t) :: {:ok, list(Contract.t)} | {:error, String.t()}
  def get_user_contracts(%Person{id: id, name: name} = _person) do
    q = from c in Contract, where: c.person_id == ^id and c.end_date > from_now(0, "day")

    query = from c in q, order_by: [asc: c.end_date]

    with [_|_] = contracts <- Repo.all(query) do
      {:ok, contracts}
    else
      [] ->
        {:error, "#{name} has no active contracts"}
      end
  end


  @spec add_contract(Person.t, Vendor.t, Category.t, map) :: {:ok, Contract.t} | {:error, Ecto.Changeset.t()}
  def add_contract(%Person{} = person, %Vendor{} = vendor, %Category{} = category, attrs) do
    Contract.create_changeset(person, vendor, category, attrs)
    |> Repo.insert()
  end

  @spec update_contract(Contract.t, Vendor.t, Category.t, map) :: {:ok, Contract.t} | {:error, Ecto.Changeset.t()}
  def update_contract(%Contract{} = contract, %Vendor{} = vendor, %Category{} = category, attrs) do
    contract = contract |> Repo.preload([:person, :vendor, :category])

    contract
    |> Contract.update_changeset(vendor, category, attrs)
    |> Repo.update()
  end

  @spec delete_contract(Contract.t) :: {:ok, Contract.t} | {:error, Ecto.Changeset.t()}
  def delete_contract(%Contract{} = contract) do
    contract
    |> Repo.delete()
  end

  @spec add_category(Vendor.t, map) :: {:ok, Category.t} | {:error, Ecto.Changeset.t()}
  def add_category(%Vendor{} = vendor, attrs) do
    vendor
    |> Category.create_changeset(attrs)
    |> Repo.insert()
  end

  @spec get_vendors() :: {:ok, list(Vendor.t)} | {:error, String.t()}
  def get_vendors() do
    with [_|_] = vendors <- Vendor |> Repo.all() do
      {:ok, vendors}
    else
      [] ->
        {:error, "No Vendors available, Please Add Vendors"}
    end
  end

  @spec add_vendor(map) :: {:ok, Vendor.t} | {:error, Ecto.Changeset.t()}
  def add_vendor(attrs) do
    %Vendor{}
    |> Vendor.changeset(attrs)
    |> Repo.insert()
  end

  @spec get_vendor_categories(Vendor.t) :: {:ok, list(Category.t)} | {:error, String.t()}
  def get_vendor_categories(%Vendor{id: id, name: name}) do
    with [_|_] = categories <- Category |> Repo.all([vendor_id: id]) do
      {:ok, categories}
    else
      [] ->
        {:error, "#{name} has no categories available"}
      end
  end
end
