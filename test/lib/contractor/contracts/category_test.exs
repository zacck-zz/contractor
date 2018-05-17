defmodule Contractor.Contracts.CategoryTest do
  use Contractor.DataCase

  alias Contractor.{
    Contracts.Category
  }

  @valid_attrs %{name: "Phone"}
  describe "Category changsets " do
    test "should be valid with valid attributes" do
      changeset = Category.changeset(%Category{}, @valid_attrs)
      assert changeset.valid?
    end

    test "should be invalid without required attrinutes" do
      changeset = Category.changeset(%Category{}, %{})
      refute changeset.valid?
    end
  end
end
