defmodule RealtimeChess.Game.Bishop do
  @deltas %{
   down_right: {1, 1},
    down_left: {1, -1},
      up_left: {-1, -1},
     up_right: {-1, 1}
  }

  use RealtimeChess.Game.FlyingPiece, deltas: @deltas
end
