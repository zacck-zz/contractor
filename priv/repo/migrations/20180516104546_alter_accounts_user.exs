defmodule Contractor.Repo.Migrations.AlterAccountsUser do
  use Ecto.Migration

  def change do
    alter table(:people) do
      add :name, :string
    end 
  end
end
