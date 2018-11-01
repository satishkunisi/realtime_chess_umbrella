defmodule RealtimeChessWeb.GameChannel do
  use Phoenix.Channel
  alias RealtimeChess.Game

  def join("game:lobby", _auth_message, socket) do
    {:ok, socket}
  end

  def join("game:" <> game_name, %{username: username}, socket) do
    Game.add_player(game_name, username)
  end

  def handle_in("create_game", %{"username" => username}, socket) do
    game =  Game.start(username)

    new_socket = socket
      |> assign(:username, username)
      |> assign(:game_name, game.name)

    broadcast!(new_socket, "game_created", %{game_name: game.name})
    {:noreply, new_socket}
  end
end
