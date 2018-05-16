defmodule Contractor.Repo.Migrations.AddContractVendors do
  use Ecto.Migration

  def change do
    create table(:vendors, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string

      timestamps(inserted_at: :created_at, updated_at: :updated_at)
    end
  end
end
