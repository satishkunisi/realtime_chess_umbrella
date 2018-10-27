defmodule RealtimeChessWeb.GameChannel do
  def join("game:lobby", _auth_message, socket) do
    {:ok, socket}
  end

  def join("game:" <> game_id, auth_message, socket) do

  end
end
