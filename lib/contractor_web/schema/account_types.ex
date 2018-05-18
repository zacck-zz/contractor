defmodule ContractorWeb.Schema.AccountTypes do
  use Absinthe.Schema.Notation

  @desc  "A system user"
  object :person do
    field :id, :id
    field :token, :string
    field :hash, :string
    field :email, :string
    field :name, :string
  end
end
