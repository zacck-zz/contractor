defmodule Contractor.Auth do
  @moduledoc """
  Boundary module for authentication actions
  """
  alias Contractor.{
    Accounts.Person
  }

  @spec auth_user(String.t(), String.t()) :: {:ok, Person.t} | {:error, String.t}
  def auth_user(email, password) do
    query = from p in Person, where: p.email == ^email

    Repo.one(query)
    |> validate_hash(password)
  end

  @spec validate_hash(nil | Person.t, String.t) :: {:ok, Person.t} | {:error, String.t()}
  defp validate_hash(nil, _), do: {:error, "Incorrect username or password"}

  defp validate_hash(%Person{} = person, password) do
    case Bcrypt.checkpw(password, person.hash) do
      true -> {:ok, person}
      false -> {:error,  "Incorrect email or password"}
    end
  end
end
