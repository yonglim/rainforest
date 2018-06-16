defmodule Rainforest.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :productName, :string
      add :stock, :integer
      add :sellingPrice, :float

      timestamps()
    end

  end
end
