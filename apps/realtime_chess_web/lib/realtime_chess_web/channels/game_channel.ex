defmodule RealtimeChessWeb.GameChannel do
  use Phoenix.Channel
  alias RealtimeChess.Game
  def join("game:lobby", %{"username" => username}, socket) do
    send(self(), {:after_join_lobby, username})
    {:ok, socket}
  end

  def join("game:" <> game_name, %{"body" => %{"username" => username}}, socket) do
    Game.add_player(game_name, username)
    {:ok, socket}
  end

  def handle_in("send_piece_drag", %{"body" => body}, socket) do
    push(
      socket,
      "receive_drag_piece",
      body
    )
  end

  def handle_info({:after_join_lobby, username}, socket) do
    {:ok, game} =  Game.start(username)

    new_socket = socket
      |> assign(:username, username)
      |> assign(:game_name, game.name)

    game = Game.for_json(game) |> Map.from_struct() |> Map.put(:username, username)

    push(
      new_socket,
      "go_to_game",
      game
    )

    {:noreply, new_socket}
  end
end
