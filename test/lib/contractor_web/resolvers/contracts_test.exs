defmodule ContractorWeb.Resolvers.ContractsTest do
  use ContractorWeb.ConnCase

  alias Contractor.{
    Contracts.Category,
    Contracts.Contract,
    Contracts.Vendor
  }

  @num 5

  describe "Contracts Resolver" do

    test "fetches a single contract", %{conn: conn} do
      contract = insert(:contract)
      assert Repo.aggregate(Contract, :count, :id) == 1

      query = """
      query {
        getContract(id: "#{contract.id}"){
          cost
          id
          vendorId
        }
      }
      """

      res = post conn, "api/graph", query: query

      %{
        "data" => %{
          "getContract" => saved_contract
        }
      } = json_response(res, 200)

      assert saved_contract["id"] == contract.id
      assert saved_contract["vendorId"] == contract.vendor_id
      assert saved_contract["cost"] == contract.cost

    end

    test "fetches a person's Contracts", %{conn: conn} do
      person = insert(:person)
      insert_list(@num, :contract)
      insert_list(@num, :contract, person: person)
      assert Repo.aggregate(Contract, :count, :id) == @num * 2
      query = """
      query {
        getUserContracts(id: "#{person.id}"){
          cost
          personId
          endDate
        }
      }
      """
      res = post conn, "api/graph", query: query

      %{
        "data" => %{
          "getUserContracts" => user_contracts
        }
      } = json_response(res, 200)

      assert Enum.count(user_contracts)
      [contract]= Enum.take(user_contracts, 1)
      assert contract["personId"] == person.id
    end

    test "fetches all vendors", %{conn: conn} do
      insert_list(@num, :vendor)
      assert Repo.aggregate(Vendor, :count, :id) == @num
      query = """
      query {
        getVendors{
          name
        }
      }
      """

      res = post conn, "api/graph", query: query

      %{
        "data" =>  %{
          "getVendors" => vendors
        }
      } = json_response(res, 200)

      assert Enum.count(vendors) == @num
    end

    test "fetches vendor categories", %{conn: conn} do
      vendor = insert(:vendor)
      insert_list(@num, :category)
      insert_list(@num, :category, vendor: vendor)
      assert Repo.aggregate(Category, :count, :id) == @num * 2


      query = """
      query {
        getVendorCategories(id: "#{vendor.id}"){
          vendor_id
          name
          id
        }
      }
      """

      res = post conn, "api/graph", query: query


      %{
        "data" => %{
          "getVendorCategories" => categories
        }
      } = json_response(res, 200)

      assert Enum.count(categories) == @num
    end
  end
end
