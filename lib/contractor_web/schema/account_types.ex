defmodule ContractorWeb.Schema.AccountTypes do
  use Absinthe.Schema.Notation

  @desc "A system user"
  object :person do
    field(:id, :id)
    field(:email, :string)
    field(:name, :string)
  end

  @desc "A User's Session"
  object :session do
    field(:token, :string)
    field(:person, :person)
  end

  @desc "Login input"
  input_object :login_input do
    field(:email, :string)
    field(:password, :string)
  end

  @desc "Add User input"
  input_object :add_user_input do
    field(:email, :string)
    field(:hash, :string)
    field(:name, :string)
  end
end
