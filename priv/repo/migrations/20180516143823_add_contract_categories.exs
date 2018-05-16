defmodule Contractor.Repo.Migrations.AddContractCategories do
  use Ecto.Migration

  def change do
    create table(:categories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string

      timestamps(inserted_at: :created_at, updated_at: :updated_at)
      add :vendor_id, references(:vendors, on_delete: :nothing, type: :binary_id)
    end
  end
end
