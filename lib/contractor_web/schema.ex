defmodule ContractorWeb.Schema do
  use Absinthe.Schema
  alias ContractorWeb.Resolvers
  alias ContractorWeb.Schema.Middleware

  import_types Absinthe.Type.Custom
  import_types __MODULE__.ContractTypes
  import_types __MODULE__.AccountTypes

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [Middleware.ChangesetErrors]
  end

  def middleware(middleware, _, _) do
    middleware
  end

  mutation do
    @desc "Add User"
    field :add_user, :person do
      arg :input, non_null(:add_user_input)
      resolve & Resolvers.Accounts.add_user/3
    end

    @desc "Add a user contract"
    field :add_user_contract, :contract do
      arg :input, non_null (:contract_input)
      middleware Middleware.Authorize, :any
      resolve &Resolvers.Contracts.add_contract/3
    end

    @desc "Delete a User Contract"
    field :delete_contract, :contract do
      arg :input, non_null(:contract_delete_input)
      middleware Middleware.Authorize, :any
      resolve &Resolvers.Contracts.delete_contract/3
    end

    @desc "Update a User Contract"
    field :update_contract, :contract do
      arg :input, non_null(:contract_update_input)
      middleware Middleware.Authorize, :any
      resolve &Resolvers.Contracts.update_contract/3
    end

    @desc "Start a session"
    field :login, :session do
      arg :input, non_null(:login_input)
      resolve &Resolvers.Accounts.login/3
    end
  end

  query do
    @desc "fetches all app users"
    field :people, list_of(:person) do
      resolve &Resolvers.Accounts.get_people/3
    end

    @desc "fetches a user"
    field :person, :person do
      arg :id, :id
      middleware Middleware.Authorize, :any
      resolve &Resolvers.Accounts.get_person/3
    end

    @desc "fetches vendors"
    field :vendors, list_of(:vendor) do
      middleware Middleware.Authorize, :any
      resolve &Resolvers.Contracts.get_vendors/3
    end

    @desc "fetches vendor categories"
    field :categories, list_of(:category) do
      arg :id, :id
      middleware Middleware.Authorize, :any
      resolve &Resolvers.Contracts.get_vendor_categories/3
    end

    @desc "fetches user contracts"
    field :contracts, list_of(:contract) do
      arg :id, :id
      middleware Middleware.Authorize, :any
      resolve &Resolvers.Contracts.get_user_contracts/3
    end

    @desc "fetches a single contract"
    field :contract, :contract do
      arg :id, :id
      middleware Middleware.Authorize, :any
      resolve &Resolvers.Contracts.get_contract/3
    end
  end
end
