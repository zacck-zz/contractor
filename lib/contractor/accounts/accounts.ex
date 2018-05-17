defmodule Contractor.Accounts  do
  @moduledoc """
  Boundary Module for the Accounts context,
  This module handles all accounts related Actions
  """
  alias Contractor.{
    Repo,
    Accounts.Person
  }

  @spec create_person(map) :: {:ok, Person.t} | {:error, Ecto.Changeset.t()}
  def create_person(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  @spec get_people() :: {:ok, list(Person.t)} | {:error, String.t()}
  def get_people() do
    with [_|_] = people <- Repo.all(Person) do
      {:ok, people}
    else
      [] ->
        {:error, "No users on the app"}
      end
  end

  @spec get_person(String.t()) :: {:ok, Person.t} | {:error, String.t()}
  def get_person(id) do
    with %Person{} = person <- Person |> Repo.get(id) do
      {:ok, person}
    else
      nil ->
        {:error, "No user with id: #{id} exists"}
      end
  end

  @spec delete_person(Person.t) :: {:ok, Person.t} | {:error, Ecto.Changeset.t()}
  def delete_person(%Person{} = person) do
    with {:ok, %Person{} = person} <- Repo.delete(person) do
      {:ok, person}
    end
  end

  @spec update_person(Person.t, map) :: {:ok, Person.t} | {:error, Ecto.Changeset.t()}
  def update_person(%Person{} = person, attrs) do
    person
    |> Person.changeset(attrs)
    |> Repo.update()
  end
end
