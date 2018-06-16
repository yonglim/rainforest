defmodule RainforestWeb.Router do
  use RainforestWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RainforestWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/products", ProductController
    resources "/registrations", UserController, only: [:create, :new]
  end

  # Other scopes may use custom stacks.
  # scope "/api", RainforestWeb do
  #   pipe_through :api
  # end
end
