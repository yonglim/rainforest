defmodule RainforestWeb.PageController do
  use RainforestWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
