defmodule RealtimeChess.Game do
  alias __MODULE__
  alias RealtimeChess.Game.GameState

  defstruct name: "", board: %{}, status: :unstarted #, player_white: %Player{}, player_black: %Player{}, board: %Board{}
  @type t :: %__MODULE__{name: String.t, board: map, status: atom}

  # @spec start(%{player_white: Player.t, player_black: Player.t}) :: Game.t
  #
  # def start(player_white: %Player{}, player_black: %Player{}) do
  #   # generate a name
  #   # generate an empty board
  #   # create a process for holding game state
  #   # register the game
  #   # assign players to the game
  # end
end

