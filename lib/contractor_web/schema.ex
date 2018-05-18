defmodule ContractorWeb.Schema do
  use Absinthe.Schema
  alias ContractorWeb.Resolvers

  import_types Absinthe.Type.Custom
  import_types __MODULE__.ContractTypes
  import_types __MODULE__.AccountTypes

  mutation do
    @desc "Add a user contract"
    field :add_user_contract, :contract do
      arg :input, non_null (:contract_input)
      resolve &Resolvers.Contracts.add_contract/3
    end

    @desc "Delete a User Contract"
    field :delete_contract, :contract do
      arg :input, non_null(:contract_delete_input)
      resolve &Resolvers.Contracts.delete_contract/3
    end
  end

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
end
