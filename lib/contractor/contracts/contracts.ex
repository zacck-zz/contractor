defmodule Contractor.Contracts do
  @moduledoc """
  Boundary Module for the Contracts context
  This module contains all actions that are associated with
  Managing User Contracts, Contract Vendors and Contract Categories
  """
  alias Contractor.{
    Repo,
    Accounts.Person,
    Contracts.Category,
    Contracts.Contract,
    Contracts.Vendor
  }

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
