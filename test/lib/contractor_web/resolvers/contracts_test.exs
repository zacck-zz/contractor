defmodule ContractorWeb.Resolvers.ContractsTest do
  use ContractorWeb.ConnCase

  alias Contractor.{
    Contracts.Category,
    Contracts.Vendor
  }

  @num 5

  describe "Contracts Resolver" do
    test "fetches all vendots", %{conn: conn} do
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
