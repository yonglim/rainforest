defmodule Rainforest.Warehouse.Product do
  use Ecto.Schema
  import Ecto.Changeset


  schema "products" do
    field :productName, :string
    field :sellingPrice, :float
    field :stock, :integer

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:productName, :stock, :sellingPrice])
    |> validate_required([:productName, :stock, :sellingPrice])
  end
end
