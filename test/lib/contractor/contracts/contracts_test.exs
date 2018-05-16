defmodule Contractor.ContractsTest do
  use Contractor.DataCase

  alias Contractor.{
    Contracts,
    Contracts.Vendor
  }

  @num 25
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
  end
end
