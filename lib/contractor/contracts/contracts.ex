defmodule Contractor.Contracts do
  alias Contractor.{
    Repo,
    Contracts.Category,
    Contracts.Vendor
  }

  @spec get_vendors() :: {:ok, list(Vendor.t)} | {:error, String.t()}
  def get_vendors() do
    with [_|_] = vendors <- Vendor |> Repo.all() do
      {:ok, vendors}
    else
      [] ->
        {:error, "No Vendors available, Please Add Vendors"}
    end
  end

  @spec add_vendor(map) :: {:ok, Vendor.t} | {:error, Ecto.Changeset.t()}
  def add_vendor(attrs) do
    %Vendor{}
    |> Vendor.changeset(attrs)
    |> Repo.insert()
  end

  @spec get_vendor_categories(Vendor.t) :: {:ok, list(Category.t)} | {:error, String.t()}
  def get_vendor_categories(%Vendor{id: id, name: name}) do
    with [_|_] = categories <- Category |> Repo.all([vendor_id: id]) do
      {:ok, categories}
    else
      [] ->
        {:error, "#{name} has no categories available"}
      end
  end
end
