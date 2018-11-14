defmodule RealtimeChessWeb.GameController do
  use RealtimeChessWeb, :controller

  def show(conn, %{"id" => id}) do
    conn
    |> assign(:game_id, id)
    |> render("show.html")
  end
end
