defmodule ContractorWeb.Resolvers.Accounts do
  @moduledoc """
  A Module to hand web facing interactions for the accounts context
  """
  alias Contractor.{
    Auth,
    Auth.Guardian,
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

  @spec login(any(), map, any()) :: {:ok, any()} | {:error, String.t()}
  def login(_, %{input: params}, _) do
    with {:ok, %Person{} = person } <- Auth.auth_user(params.email, params.password),
      {:ok, token, _}  <- Guardian.encode_and_sign(person) do
        {:ok, %{token: token, person: person}}
      end
  end

  @spec add_user(any(), map, any()) :: {:ok, Person.t} | {:error, String.t()}
  def add_user(_, %{input: params}, _) do
    Accounts.create_person(params)
  end
end
