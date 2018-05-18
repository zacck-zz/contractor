defmodule ContractorWeb.Schema do
  use Absinthe.Schema
  alias ContractorWeb.Resolvers

  import_types Absinthe.Type.Custom



  query do
    @desc "fetches all app users"
    field :get_people, list_of(:person) do
      resolve &Resolvers.Accounts.get_people/3
    end

    @desc "fetches a user"
    field :get_person, :person do
      arg :id, :id
      resolve &Resolvers.Accounts.get_person/3
    end

    @desc "fetches vendors"
    field :get_vendors, list_of(:vendor) do
      resolve &Resolvers.Contracts.get_vendors/3
    end

    @desc "fetches vendor categories"
    field :get_vendor_categories, list_of(:category) do
      arg :id, :id
      resolve &Resolvers.Contracts.get_vendor_categories/3
    end

    @desc "fetches user contracts"
    field :get_user_contracts, list_of(:contract) do
      arg :id, :id
      resolve &Resolvers.Contracts.get_user_contracts/3
    end

    @desc "fetches a single contract"
    field :get_contract, :contract do
      arg :id, :id
      resolve &Resolvers.Contracts.get_contract/3
    end
  end

  @desc "A Users Contract"
  object :contract do
    field :id, :id
    field :cost, :float
    field :end_date, :date
    field :person_id, :id
    field :vendor_id, :id
    field :category_id, :id
  end

  @desc  "A system user"
  object :person do
    field :id, :id
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

  @desc "A Contract Category"
  object :category do
    field :id, :id
    field :vendor_id, :id
    field :name, :string
  end
end
