defmodule RainforestWeb.Api.ProductView do
  use RainforestWeb, :view
  alias RainforestWeb.Api.ProductView

  def render("index.json", %{products: products}) do
    %{data: render_many(products, ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      productName: product.productName,
      stock: product.stock,
      sellingPrice: product.sellingPrice}
  end
end
