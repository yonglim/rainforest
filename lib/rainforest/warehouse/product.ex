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
    |> validate_number(:stock, greater_than_or_equal_to: 0)
    |> validate_number(:sellingPrice, greater_than_or_equal_to: 0.0)
  end
end
