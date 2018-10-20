defmodule RealtimeChess.Game.Queen do 
  @deltas %{
           up: {-1, 0},
         down: {1, 0}, 
         left: {0, -1},
        right: {0, 1},
   down_right: {1, 1},
    down_left: {1, -1},
      up_left: {-1, -1},
     up_right: {-1, 1}
  }

  use RealtimeChess.Game.FlyingPiece, deltas: @deltas
end
