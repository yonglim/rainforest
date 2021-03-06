defmodule RainforestWeb.ProductController do
  use RainforestWeb, :controller

  alias Rainforest.Warehouse
  alias Rainforest.Warehouse.Product

  alias Rainforest.Accounts

  plug(:check_auth when action in [:new, :create, :edit, :update, :delete])

  defp check_auth(conn, _args) do
    if user_id = get_session(conn, :current_user_id) do
      current_user = Accounts.get_user!(user_id)

      conn
      |> assign(:current_user, current_user)
    else
      conn
      |> put_flash(:error, "You need to be signed in to access that page")
      |> redirect(to: product_path(conn, :index))
      |> halt()
    end
  end

  def index(conn, _params) do
    products = Warehouse.list_products()
    render(conn, "index.html", products: products)
  end

  def new(conn, _params) do
    changeset = Warehouse.change_product(%Product{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"product" => product_params}) do
    case Warehouse.create_product(product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: product_path(conn, :show, product))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Warehouse.get_product!(id)
    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = Warehouse.get_product!(id)
    changeset = Warehouse.change_product(product)
    render(conn, "edit.html", product: product, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Warehouse.get_product!(id)

    case Warehouse.update_product(product, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: product_path(conn, :show, product))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", product: product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Warehouse.get_product!(id)
    {:ok, _product} = Warehouse.delete_product(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: product_path(conn, :index))
  end
end
