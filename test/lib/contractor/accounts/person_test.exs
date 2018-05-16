defmodule Contractor.Accounts.PersonTest do
  use Contractor.DataCase
  alias Contractor.Accounts.Person


  @valid_attrs %{token: "72ye82gfjh3vfywvjhwbfyuwegfytefuy%&qjbwfiu", hash: "7t24823ty4ubfucy34gruwbur3gre821hduh37ce"}
  @invalid_attrs %{}

  describe "user changesets" do
    test "valid with correct fields" do
      changeset = Person.changeset(%Person{}, @valid_attrs)
      assert changeset.valid?
    end

    test "invalid with incorrect fields" do
      changeset = Person.changeset(%Person{}, @invalid_attrs)
      refute changeset.valid?
    end
  end
end
