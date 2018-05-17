defmodule ContractorWeb.Resolvers.AccountsTest do
  use ContractorWeb.ConnCase

  alias Contractor.{
    Accounts.Person
  }

  @num 5
  describe "Accounts resolver" do
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


    test "fetches a single person from the system", %{conn: conn} do
      person = insert(:person)
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
