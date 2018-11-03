defmodule RealtimeChess.Game do
  defstruct name: "", board: %{}, status: :unstarted, player_white: nil, player_black: nil
  alias RealtimeChess.Game.GameState

  @type t :: %__MODULE__{name: String.t, board: map, status: atom, player_white: GameState.player(), player_black: GameState.player()}

  @spec start(GameState.player()) :: {:ok, Game.t}
  def start(player_white) do
    {:ok, game_pid} = GameState.create(player_white: player_white)
    GameState.fetch(game_pid)
  end

  @spec add_player(binary() | pid(), String.t(), RealtimeChess.Game.Board.color() | nil) ::
          {:error, String.t()} | {:ok, t()}
  def add_player(game_name, new_player, color \\ nil) do
    GameState.assign_player(game_name, new_player, color)
  end

  @spec for_json(t) :: map()
  def for_json(game) do
    board = Enum.map(game.board, fn {num, row} ->
      new_row = row
        |> Enum.map(fn {col, pos} ->
          {col, tuple_to_list(pos)}
        end)
        |> Enum.into(%{})
      {num, new_row}
    end)
    |> Enum.into(%{})

    Map.put(game, :board, board)
  end

  @spec tuple_to_list(any()) :: any()
  def tuple_to_list(item) do
    if is_tuple(item) do
      [elem(item, 0), elem(item, 1)]
    else
      item
    end
  end
end

