defmodule ContractorWeb.Resolvers.ContractsTest do
  use ContractorWeb.ConnCase

  alias Contractor.{
    Contracts.Category,
    Contracts.Contract,
    Contracts.Vendor
  }

  @num 5

  describe "Contracts Resolver" do
    @tag :authenticated
    test "saves a  user contract", %{conn: conn, current_user: person} do
      vendor = insert(:vendor)
      category =  insert(:category, vendor: vendor)

      variables = %{
        "input" => %{
          "vendor_id" => vendor.id,
          "category_id" => category.id,
          "person_id" => person.id,
          "cost" => 78.9,
          "end_date" => Date.to_string(Date.add(Date.utc_today, 1))
        }
      }

      query = """
      mutation($input: ContractInput!){
        addUserContract(input: $input) {
          personId
          vendorId
          categoryId
          id
          cost
          endDate
        }
      }
      """

      assert Repo.aggregate(Contract, :count, :id) == 0

      res = post conn, "api/graph", query: query, variables: variables

      %{
        "data" => %{
          "addUserContract" => saved_contract
        }
      } = json_response(res, 200)

      assert Repo.aggregate(Contract, :count, :id) == 1
      assert saved_contract["personId"] == person.id
      assert saved_contract["vendorId"] ==  vendor.id
      assert saved_contract["cost"] == variables["input"]["cost"]
      assert saved_contract["endDate"] == variables["input"]["end_date"]
    end

    @tag :authenticated
    test "updates a contract", %{conn: conn} do
      [vendor, vendor1] = insert_pair(:vendor)
      category = insert(:category, vendor: vendor)
      category1 = insert(:category, vendor: vendor1)
      contract = insert(:contract, vendor: vendor1, category: category1)
      assert Repo.aggregate(Contract, :count, :id) == 1

      variables = %{
        "input" => %{
          "id" => contract.id,
          "vendor_id" => vendor.id,
          "category_id" => category.id,
          "cost" => 900.9,
          "end_date" => Date.to_string(Date.add(Date.utc_today, 1))
        }
      }


      query = """
      mutation($input: ContractUpdateInput!) {
        updateContract(input: $input){
          id
          vendorId
          categoryId
          personId
          cost
          endDate
        }
      }
      """

      res = post conn, "api/graph", query: query, variables: variables

      %{
        "data" => %{
          "updateContract" => updated_contract
        }
      } = json_response(res, 200)



      assert Repo.aggregate(Contract, :count, :id) == 1
      assert updated_contract["id"] == contract.id
      assert updated_contract["personId"] == contract.person_id
      assert updated_contract["categoryId"] == category.id
      assert updated_contract["vendorId"] == vendor.id
      assert updated_contract["endDate"] == variables["input"]["end_date"]
    end


    @tag :authenticated
    test "deletes a single contract", %{conn: conn} do
      contract = insert(:contract)

      variables = %{
        "input" => %{
          "id" => contract.id
        }
      }

      query = """
      mutation($input: ContractDeleteInput!) {
        deleteContract(input: $input) {
          id
          cost
        }
      }
      """

      assert Repo.aggregate(Contract, :count, :id) == 1

      res = post conn, "api/graph", query: query, variables: variables

      %{
        "data" => %{
          "deleteContract" => _contract
        }
      } = json_response(res, 200)

      assert Repo.aggregate(Contract, :count, :id) == 0
    end

    @tag :authenticated
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

    @tag :authenticated
    test "fetches a person's Contracts", %{conn: conn, current_user: person} do
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

    @tag :authenticated
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

    @tag :authenticated
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
