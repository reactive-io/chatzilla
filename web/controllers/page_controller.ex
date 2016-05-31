defmodule Chatzilla.PageController do
  use Chatzilla.Web, :controller

  def index(conn, params) do
    render conn, "index.html", [name: params["name"]]
  end
end
