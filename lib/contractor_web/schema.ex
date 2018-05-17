defmodule ContractorWeb.Schema do
  use Absinthe.Schema
  alias ContractorWeb.Resolvers


  query do
    @desc "fetches all app users"
    field :get_people, list_of(:person) do
      resolve &Resolvers.Accounts.get_people/3
    end

    @desc "fetches a user"
    field :get_person, :person do
      arg :id, :string
      resolve &Resolvers.Accounts.get_person/3
    end

    @desc "fetches vendors"
    field :get_vendors, list_of(:vendor) do
      resolve &Resolvers.Contracts.get_vendors/3
    end
  end

  @desc  "A system user"
  object :person do
    field :id, :string
    field :token, :string
    field :hash, :string
    field :email, :string
    field :name, :string
  end

  @desc "A Contract Vendor"
  object :vendor do
    field :id, :string
    field :name, :string
  end
end
