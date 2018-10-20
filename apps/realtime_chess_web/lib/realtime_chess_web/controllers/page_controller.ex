defmodule RealtimeChessWeb.PageController do
  use RealtimeChessWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
