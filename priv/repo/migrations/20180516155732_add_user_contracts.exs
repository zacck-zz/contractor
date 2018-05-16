defmodule Contractor.Repo.Migrations.AddUserContracts do
  use Ecto.Migration

  def change do
    create table(:contracts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :end_date, :date
      add :cost, :float
      timestamps(inserted_at: :created_at, updated_at: :updated_at)
      add :person_id, references(:people, on_delete: :nothing, type: :binary_id)
      add :vendor_id, references(:vendors, on_delete: :nothing, type: :binary_id)
      add :category_id, references(:categories, on_delete: :nothing, type: :binary_id)
    end
  end
end
