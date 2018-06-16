defmodule Rainforest.WarehouseTest do
  use Rainforest.DataCase

  alias Rainforest.Warehouse

  describe "products" do
    alias Rainforest.Warehouse.Product

    @valid_attrs %{productName: "some productName", sellingPrice: 120.5, stock: 42}
    @update_attrs %{productName: "some updated productName", sellingPrice: 456.7, stock: 43}
    @invalid_attrs %{productName: nil, sellingPrice: nil, stock: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Warehouse.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Warehouse.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Warehouse.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Warehouse.create_product(@valid_attrs)
      assert product.productName == "some productName"
      assert product.sellingPrice == 120.5
      assert product.stock == 42
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Warehouse.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, product} = Warehouse.update_product(product, @update_attrs)
      assert %Product{} = product
      assert product.productName == "some updated productName"
      assert product.sellingPrice == 456.7
      assert product.stock == 43
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Warehouse.update_product(product, @invalid_attrs)
      assert product == Warehouse.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Warehouse.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Warehouse.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Warehouse.change_product(product)
    end
  end
end
