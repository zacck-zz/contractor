defmodule Contractor.Contracts do
  alias Contractor.{
    Repo,
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
end
