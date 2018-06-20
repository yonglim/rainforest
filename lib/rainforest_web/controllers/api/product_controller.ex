defmodule RainforestWeb.Api.ProductController do
  use RainforestWeb, :controller

  alias Rainforest.Warehouse
  alias Rainforest.Warehouse.Product

  action_fallback RainforestWeb.FallbackController

  def index(conn, _params) do
    products = Warehouse.list_products()
    render(conn, "index.json", products: products)
  end

  def create(conn, %{"product" => product_params}) do
    with {:ok, %Product{} = product} <- Warehouse.create_product(product_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_product_path(conn, :show, product))
      |> render("show.json", product: product)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Warehouse.get_product!(id)
    render(conn, "show.json", product: product)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Warehouse.get_product!(id)

    with {:ok, %Product{} = product} <- Warehouse.update_product(product, product_params) do
      render(conn, "show.json", product: product)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Warehouse.get_product!(id)
    with {:ok, %Product{}} <- Warehouse.delete_product(product) do
      send_resp(conn, :no_content, "")
    end
  end
end
