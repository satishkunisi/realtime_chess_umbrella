defmodule RealtimeChess.Game.Piece do
  @type piece_type :: (:pawn | :rook | :knight | :bishop | :queen | :king)
  @type color :: (:white | :black)
  @type t :: {color, piece_type}
  @type pieces :: (MapSet.t(board_piece) | MapSet.t())
  @type position :: {integer, integer}
  @type positions :: MapSet.t(position) | MapSet.t()
  @type board_piece :: %{piece: t, position: position}
end
