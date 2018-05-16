defmodule Contractor.AccountsTest do
  use Contractor.DataCase

  alias Contractor.{
    Accounts,
    Accounts.Person
  }

  @valid_attrs %{email: "zacck@contractor.com", name: "Zacck",  token: "72ye82gfjh3vfywvjhwbfyuwegfytefuy%&qjbwfiu", hash: "7t24823ty4ubfucy34gruwbur3gre821hduh37ce"}


  describe "Accounts context" do
    test "can create a person's account" do
      assert Repo.aggregate(Person, :count, :id) == 0
      assert {:ok, %Person{} = person} = Accounts.create_person(@valid_attrs)
      assert person.email == @valid_attrs.email
      assert person.name == @valid_attrs.name
    end


    test "can list users on the platform" do
      insert_list(3, :person)
      assert {:ok, people} = Accounts.get_people()
      assert Enum.count(people) == 3
    end

    test "errors out if no users on the platform" do
      assert Repo.aggregate(Person, :count, :id) == 0
      assert {:error, "No users on the app"} = Accounts.get_people()
    end

    test "gets a single user given the id" do
      person = insert(:person)
      assert Repo.aggregate(Person, :count, :id) == 1
      assert {:ok, saved_person} = Accounts.get_person(person.id)
      assert saved_person.name == person.name
      assert saved_person.email == person.email
    end

    test "errors out if user with id doesnt exist" do
      id = "d965afab-d71e-4616-bd8f-f7604cb3df27"
      assert Repo.aggregate(Person, :count, :id) == 0
      assert {:error, "No user with id #{id} exists"} == Accounts.get_person(id)
    end

    test "deletes a given user" do
      person = insert(:person)
      assert Repo.aggregate(Person, :count, :id) == 1
      assert {:ok, deleted_person} = Accounts.delete_person(person)
      assert Repo.aggregate(Person, :count, :id) == 0
      assert deleted_person.id == person.id
      assert deleted_person.email == person.email
    end

    test "updates a user" do
      insert(:person)
      assert Repo.aggregate(Person, :count, :id) == 1
      person = Repo.one(Person)
      refute person.name == @valid_attrs.name
      refute person.email == @valid_attrs.email
      {:ok, saved_person} = Accounts.update_person(person, @valid_attrs)
      assert Repo.aggregate(Person, :count, :id) == 1
      assert saved_person.name == @valid_attrs.name
      assert saved_person.email == @valid_attrs.email
      assert person.id == saved_person.id
    end
  end
end
