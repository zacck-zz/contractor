defmodule Contractor.Contracts.ContractTest do
  use Contractor.DataCase

  alias Contractor.{
    Contracts.Contract
  }

  @valid_attrs %{cost: 90.89, end_date: "2018-12-12"}
  describe "contract changesets" do
    test "valid with correct data" do
      person = insert(:person)
      vendor = insert(:vendor)
      category = insert(:category, vendor: vendor)

      assert changeset = Contract.create_changeset(person, vendor, category, @valid_attrs)
      assert changeset.changes.person
      assert changeset.changes.vendor
      assert changeset.changes.category
      assert changeset.valid?
    end

    test "invalid when required fields are missing" do
      person = insert(:person)
      vendor = insert(:vendor)
      category = insert(:category, vendor: vendor)
      assert changeset = Contract.create_changeset(person, vendor, category, %{})
      refute changeset.valid?
    end

    test "valid update changeset when required fields are set " do
      insert(:contract)
      vendor = insert(:vendor)
      category = insert(:category, vendor: vendor)
      contract = Repo.one(Contract) |> Repo.preload([:vendor, :category, :person])
      changeset = Contract.update_changeset(contract, vendor, category, @valid_attrs)
      assert changeset.valid?
    end
  end

end
