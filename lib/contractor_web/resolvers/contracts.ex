defmodule ContractorWeb.Resolvers.Contracts do
  @moduledoc """
  Module to handle web facing operations for the Contracts Context
  """

  alias Contractor.{
    Accounts,
    Accounts.Person,
    Contracts,
    Contracts.Category,
    Contracts.Contract,
    Contracts.Vendor
  }

  @spec get_vendors(any(), any(), any()) :: {:ok, list(Vendor.t())} | {:error, String.t()}
  def get_vendors(_, _, _) do
    Contracts.get_vendors()
  end

  @spec get_vendor_categories(any(), map, any()) ::
          {:ok, list(Category.t())} | {:error, String.t()}
  def get_vendor_categories(_, args, _) do
    with {:ok, vendor} <- Contracts.get_vendor(args.id),
         {:ok, categories} <- Contracts.get_vendor_categories(vendor) do
      {:ok, categories}
    end
  end

  @spec get_user_contracts(any(), any(), map) :: {:ok, list(Contract.t())} | {:error, String.t()}
  def get_user_contracts(_, _, %{context: context}) do
    with {:ok, %Person{} = person} <- Accounts.get_person(context.current_user.id),
         {:ok, contracts} <- Contracts.get_user_contracts(person) do
      {:ok, contracts}
    end
  end

  @spec get_contract(any(), map, any()) :: {:ok, Contract.t()} | {:error, String.t()}
  def get_contract(_, args, _) do
    Contracts.get_contract(args.id)
  end

  @spec add_contract(any(), map, any()) :: {:ok, Contract.t()} | {:error, String.t()}
  def add_contract(_, %{input: params}, _) do
    with {:ok, %Person{} = person} <- Accounts.get_person(params.person_id),
         {:ok, %Vendor{} = vendor} <- Contracts.get_vendor(params.vendor_id),
         {:ok, %Category{} = category} <- Contracts.get_category(params.category_id) do
      Contracts.add_contract(person, vendor, category, %{
        cost: params.cost,
        end_date: params.end_date
      })
    end
  end

  @spec delete_contract(any(), any(), any()) :: {:ok, Contract.t()} | {:error, String.t()}
  def delete_contract(_, %{input: params}, _) do
    with {:ok, %Contract{} = contract} <- Contracts.get_contract(params.id) do
      Contracts.delete_contract(contract)
    end
  end

  @spec update_contract(any(), any(), any()) :: {:ok, Contract.t()} | {:error, String.t()}
  def update_contract(_, %{input: params}, _) do
    with {:ok, %Contract{} = contract} <- Contracts.get_contract(params.id),
         {:ok, %Vendor{} = vendor} <- Contracts.get_vendor(params.vendor_id),
         {:ok, %Category{} = category} <- Contracts.get_category(params.category_id) do
      Contracts.update_contract(contract, vendor, category, %{
        cost: params.cost,
        end_date: params.end_date
      })
    end
  end
end
