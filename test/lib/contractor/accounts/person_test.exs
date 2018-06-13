defmodule Contractor.Accounts.PersonTest do
  use Contractor.DataCase
  alias Contractor.Accounts.Person

  @valid_attrs %{
    email: "zacck@contractor.com",
    name: "Zacck",
    token: "72ye82gfjh3vfywvjhwbfyuwegfytefuy%&qjbwfiu",
    hash: "7t24823ty4ubfucy34gruwbur3gre821hduh37ce"
  }
  @email_attrs %{
    email: "zacck-contractor.com",
    token: "72ye82gfjh3vfywvjhwbfyuwegfytefuy%&qjbwfiu",
    hash: "7t24823ty4ubfucy34gruwbur3gre821hduh37ce"
  }
  @invalid_attrs %{name: "Zacck"}

  describe "user changesets" do
    test "valid with correct fields" do
      changeset = Person.changeset(%Person{}, @valid_attrs)
      assert changeset.valid?
    end

    test "invalid when fields are not provided" do
      changeset = Person.changeset(%Person{}, @invalid_attrs)
      refute changeset.valid?
    end

    test "invalid if email is not valid" do
      changeset = Person.changeset(%Person{}, @email_attrs)
      refute changeset.valid?
    end

    test "invalid if email is not unique" do
      saved_person = insert(:person)
      assert Repo.aggregate(Person, :count, :id) == 1

      {:error, invalid_changeset} =
        # credo:disable-for-lines:6
        Person.changeset(%Person{}, %{
          email: saved_person.email,
          token: saved_person.token,
          hash: saved_person.hash
        })
        |> Repo.insert()

      refute invalid_changeset.valid?
    end
  end
end
