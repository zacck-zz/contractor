defmodule ContractorWeb.PageController do
  use ContractorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
