defmodule ContractorWeb.Schema.ContractTypes do
  use Absinthe.Schema.Notation

  @desc "A Users Contract"
  object :contract do
    field :id, :id
    field :cost, :float
    field :end_date, :date
    field :person_id, :id
    field :vendor_id, :id
    field :category_id, :id
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
