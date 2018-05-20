defmodule ContractorWeb.Resolvers.AccountsTest do
  use ContractorWeb.ConnCase

  alias Contractor.{
    Accounts.Person
  }

  @num 5
  describe "Accounts resolver" do

    test "adds a person to system", %{conn: conn} do
      assert Repo.aggregate(Person, :count, :id) == 0

      variables = %{
        "input" => %{
          "email" => "zacck@contractor.com",
          "hash" => "67q3yu2bduw3gf8wubfduiw",
          "name" => "Zacck Osiemo"
        }
      }

      query = """
        mutation($input: AddUserInput!){
          addUser(input: $input){
            name
            email
          }
        }
      """

      res = post conn, "api/graph", query: query, variables: variables

      %{
        "data" => %{
          "addUser" => person
        }
      } = json_response(res, 200)

      assert Repo.aggregate(Person, :count, :id) == 1
      assert person["name"] == variables["input"]["name"]
      assert person["email"] == variables["input"]["email"]
    end

    test "fetches people on the system", %{conn: conn} do
      insert_list(@num, :person)
      assert Repo.aggregate(Person, :count, :id) == @num
      query = """
      query {
        getPeople{
          email
        }
      }
      """

      res = post conn, "api/graph", query: query

      %{
        "data" => %{
          "getPeople" => people
        }
      } = json_response(res, 200)

      assert Enum.count(people) == @num
    end


    @tag :authenticated
    test "fetches a single person from the system", %{conn: conn, current_user: person} do
      assert Repo.aggregate(Person, :count, :id) == 1
      query = """
      query {
        getPerson(id: "#{person.id}"){
          id
          email
        }
      }
      """

      res = post conn, "api/graph", query: query

      %{
        "data" => %{
          "getPerson" => saved_person
        }
      } = json_response(res, 200)


      assert saved_person["id"] == person.id
      assert saved_person["email"] == person.email
    end
  end
end
