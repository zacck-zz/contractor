defmodule Contractor.Factory do
  @moduledoc """
  This module containing factories for application data
  use these factories to generate dummy data for tests 
  and the development environment
  """
  use ExMachina.Ecto, repo: Contractor.Repo

  def person_factory do
    %Contractor.Accounts.Person{
      name: sequence(:name, &"user-#{&1}"),
      email: sequence(:email, &"user-#{&1}@contractor.com"),
      token: sequence(:token, &"user-#{&1}-token"),
      hash: sequence(:token, &"user-#{&1}-hash")
    }
  end

  def vendor_factory do
    %Contractor.Contracts.Vendor{
      name: sequence(:name, &"vendor -#{&1}")
    }
  end

  def category_factory do
    %Contractor.Contracts.Category{
      name: sequence(:name, &"category-#{&1}"),
      vendor: build(:vendor)
    }
  end

  def contract_factory do
    %Contractor.Contracts.Contract{
      cost: 78.90,
      end_date: "2019-12-12",
      person: build(:person),
      vendor: build(:vendor),
      category: build(:category)
    }
  end
end
