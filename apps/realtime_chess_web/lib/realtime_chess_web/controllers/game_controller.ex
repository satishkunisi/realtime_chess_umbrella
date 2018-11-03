defmodule RealtimeChessWeb.GameController do
  use RealtimeChessWeb, :controller

  def show(conn, %{id: id}) do
    render(conn, id)
  end
end
