defmodule Contractor.Contracts.VendorTest do
  use Contractor.DataCase

  alias Contractor.{
    Contracts.Vendor
  }

  @valid_attrs %{name: "Vodafone"}
  describe "vendor changeset" do

    test "should be valid with valid data " do
      changeset = Vendor.changeset(%Vendor{}, @valid_attrs)
      assert changeset.valid?
    end

    test "should be invalid if name is missing" do
      changeset = Vendor.changeset(%Vendor{}, %{})
      refute changeset.valid?
    end
  end
end
