defmodule ContractorWeb.Resolvers.Accounts do
  @moduledoc """
  A Module to hand web facing interactions for the accounts context
  """
  alias Contractor.{
    Accounts,
    Accounts.Person
  }

  @spec get_people(any(), map, any()) :: {:ok, list(Person.t)} | {:error, String.t()}
  def get_people(_, _, _) do
    Accounts.get_people()
  end

  @spec get_person(any(), map, any()) :: {:ok, Person.t} | {:error, String.t()}
  def get_person(_, args, _) do
    Accounts.get_person(args.id)
  end
end
