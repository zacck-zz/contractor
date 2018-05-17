defmodule Contractor.Contracts.ContractTest do
  use Contractor.DataCase

  alias Contractor.{
    Contracts.Contract
  }

  @valid_attrs %{cost: 90.89, end_date: "2038-12-12"}
  @invalid_attrs %{cost: 20, end_date: "1898-07-09"}
  @invalid_cost %{cost: 0, end_date: "2039-12-02"}
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

    test "invalid when date is in the past" do
      person = insert(:person)
      vendor = insert(:vendor)
      category = insert(:category, vendor: vendor)
      changeset = Contract.create_changeset(person, vendor, category, @invalid_attrs) 
      refute changeset.valid?
    end

    test "invalid if cost is not greater than zero" do
      person = insert(:person)
      vendor = insert(:vendor)
      category = insert(:category, vendor: vendor)
      changeset = Contract.create_changeset(person, vendor, category, @invalid_cost)
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
