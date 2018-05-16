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
end
