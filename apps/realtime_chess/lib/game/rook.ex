defmodule RealtimeChess.Game.Rook do
  @deltas %{
       up: {-1, 0},
     down: {1, 0}, 
     left: {0, -1},
    right: {0, 1}
  }

  use RealtimeChess.Game.FlyingPiece, deltas: @deltas
end
