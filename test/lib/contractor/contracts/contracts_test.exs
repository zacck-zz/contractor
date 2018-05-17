defmodule Contractor.ContractsTest do
  use Contractor.DataCase

  alias Contractor.{
    Contracts,
    Contracts.Category,
    Contracts.Contract,
    Contracts.Vendor
  }

  @num 25
  @valid_vendor %{name: "Orange"}
  @valid_category %{name: "Phone"}
  @valid_contract %{cost: 90.89, end_date: "2018-12-12"}
  describe "Contracts boundary " do

    test "can fetch a specific contract" do
      contract = insert(:contract)
      assert Repo.aggregate(Contract, :count, :id) == 1
      {:ok, saved_contract} = Contracts.get_contract(contract.id)
      assert Repo.aggregate(Contract, :count, :id) == 1
      assert contract.cost == saved_contract.cost
    end

    test "errors out if contract does not exist" do
      id = "d965afab-d71e-4616-bd8f-f7604cb3df27"
      assert Repo.aggregate(Contract, :count, :id) == 0
      assert {:error, "Contract with id: #{id} doesn't exist" } == Contracts.get_contract(id)
    end

    test "can fetch user's contracts" do
      person = insert(:person)
      insert_list(@num, :contract)
      insert_list(@num, :contract, person: person)
      assert Repo.aggregate(Contract, :count, :id) == @num * 2
      {:ok, contracts} = Contracts.get_user_contracts(person)
      assert Enum.count(contracts) == @num
    end

    test "errors out when user has no contracts" do
      person = insert(:person)
      insert_list(@num, :contract)
      assert Repo.aggregate(Contract, :count, :id) == @num
      assert {:error, "#{person.name} has no active contracts"} == Contracts.get_user_contracts(person)
    end

    test "errors out when user's contracts are expired" do
      person = insert(:person)
      insert_list(@num, :contract, person: person, end_date: "2016-12-12")
      assert Repo.aggregate(Contract, :count, :id) == @num
      assert {:error, "#{person.name} has no active contracts"} == Contracts.get_user_contracts(person)
    end

    test "can add a user contract" do
      person = insert(:person)
      vendor = insert(:vendor)
      category = insert(:category, vendor: vendor)
      assert Repo.aggregate(Contract, :count, :id) == 0
      assert {:ok, _} = Contracts.add_contract(person, vendor, category, @valid_contract)
      assert Repo.aggregate(Contract, :count, :id) == 1
    end

    test "can update a user contract" do
      contract = insert(:contract)
      assert Repo.aggregate(Contract, :count, :id) == 1
      vendor = insert(:vendor)
      category = insert(:category, vendor: vendor)
      assert {:ok, updated_contract} = Contracts.update_contract(contract, vendor, category, @valid_contract)
      assert updated_contract.id == contract.id
      refute updated_contract.cost == contract.cost
      refute updated_contract.end_date == contract.end_date
      assert Repo.aggregate(Contract, :count, :id) == 1
      assert updated_contract.cost == @valid_contract.cost
      assert Date.to_string(updated_contract.end_date) == @valid_contract.end_date
    end

    test "can delete a user contract" do
      contract = insert(:contract)
      assert Repo.aggregate(Contract, :count, :id) == 1
      {:ok, deleted_contract} = Contracts.delete_contract(contract)
      assert Repo.aggregate(Contract, :count, :id) == 0
      assert deleted_contract.id == contract.id
    end

    test "can add a category" do
      vendor = insert(:vendor)
      assert Repo.aggregate(Vendor, :count, :id) == 1
      assert Repo.aggregate(Category, :count, :id) == 0
      assert {:ok, _} = Contracts.add_category(vendor, @valid_category)
      assert Repo.aggregate(Category, :count, :id) == 1
    end

    test "errors out if category details are invalid" do
      vendor = insert(:vendor)
      assert Repo.aggregate(Vendor, :count, :id) == 1
      assert Repo.aggregate(Category, :count, :id) == 0
      assert {:error, _} = Contracts.add_category(vendor, %{})
      assert Repo.aggregate(Category, :count, :id) == 0
    end

    test "list all available vendors" do
      insert_list(@num, :vendor)
      assert {:ok, vendors} = Contracts.get_vendors()
      assert Enum.count(vendors) == @num
    end

    test "errors out if there are no vendors" do
      assert Repo.aggregate(Vendor, :count, :id) == 0
      assert {:error, "No Vendors available, Please Add Vendors"} = Contracts.get_vendors()
    end

    test "can add a vendor" do
      assert Repo.aggregate(Vendor, :count, :id) == 0
      assert {:ok, saved_vendor} = Contracts.add_vendor(@valid_vendor)
      assert Repo.aggregate(Vendor, :count, :id) == 1
      assert saved_vendor.name == @valid_vendor.name
    end

    test "errors out with invalid vendor when trying to add a vendor" do
      assert Repo.aggregate(Vendor, :count, :id) == 0
      assert {:error, _} = Contracts.add_vendor(%{})
      assert Repo.aggregate(Vendor, :count, :id) == 0
    end

    test "fetches a contracts categories" do
      vendor = insert(:vendor)
      insert_list(@num, :category, vendor: vendor)
      assert Repo.aggregate(Vendor, :count, :id) == 1
      assert Repo.aggregate(Category, :count, :id) == @num
      assert {:ok, vendor_categories} = Contracts.get_vendor_categories(vendor)
      assert Enum.count(vendor_categories) == @num
    end

    test "errors out when vendor has no categories" do
      vendor = insert(:vendor)
      assert Repo.aggregate(Vendor, :count, :id) == 1
      assert Repo.aggregate(Category, :count, :id) == 0
      assert {:error, "#{vendor.name} has no categories available"} == Contracts.get_vendor_categories(vendor)
    end
  end
end
