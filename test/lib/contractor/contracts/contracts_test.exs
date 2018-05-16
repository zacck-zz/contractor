defmodule Contractor.ContractsTest do
  use Contractor.DataCase

  alias Contractor.{
    Contracts,
    Contracts.Vendor
  }

  @num 25
  @valid_vendor %{name: "Orange"}
  describe "Contracts boundary " do
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
  end
end
