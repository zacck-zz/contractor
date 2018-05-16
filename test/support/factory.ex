defmodule Contractor.Factory do
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
end
