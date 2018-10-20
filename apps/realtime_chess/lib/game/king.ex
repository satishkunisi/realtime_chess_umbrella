defmodule RealtimeChess.Game.King do
  alias RealtimeChess.Game.Piece

  @spec move_positions(Piece.position(), any(), Piece.pieces()) :: Piece.positions()
  def move_positions({row, col}, _, surrounding_pieces) do
    [{row + 1, col},
     {row - 1, col},
     {row, col + 1},
     {row + 1, col + 1},
     {row - 1, col + 1},
     {row, col - 1},
     {row + 1, col - 1},
     {row - 1, col - 1}]
    |> MapSet.new()
    |> circumscribe_moves(surrounding_pieces)
    |> MapSet.new()
  end

  @spec attack_positions(Piece.position(), :white | :black, Piece.pieces()) :: Piece.positions()  
  def attack_positions({row, col}, color, surrounding_pieces) do
    MapSet.new([
      {row + 1, col},
      {row - 1, col},
      {row, col + 1},
      {row + 1, col + 1},
      {row - 1, col + 1},
      {row, col - 1},
      {row + 1, col - 1},
      {row - 1, col - 1}
    ])
    |> circumscribe_attacks(surrounding_pieces, color)
    |> MapSet.new
  end

  @spec circumscribe_moves(Piece.positions(), Piece.pieces()) :: Piece.positions() 
  defp circumscribe_moves(possible_positions, surrounding_pieces) do
    surrounding_positions = get_positions(surrounding_pieces) 

    possible_positions
    |> Enum.filter(&inbounds?/1)
    |> MapSet.new()
    |> MapSet.difference(surrounding_positions)
  end

  @spec circumscribe_attacks(Piece.positions(), Piece.pieces(), Piece.color()) :: Piece.positions() 
  defp circumscribe_attacks(possible_attacks, surrounding_pieces, piece_color) do
    surrounding_positions = surrounding_pieces
      |> Enum.filter(fn %{position: _, piece: {color, _}} -> color == piece_color end)
      |> MapSet.new()
      |> get_positions()

    possible_attacks
    |> Enum.filter(&inbounds?/1)
    |> MapSet.new()
    |> MapSet.difference(surrounding_positions)
  end

  @spec get_positions(Piece.pieces()) :: Piece.positions() 
  defp get_positions(surrounding_pieces) do
    surrounding_pieces
    |> Enum.map(fn %{position: position, piece: _} -> position end)  
    |> MapSet.new()
  end

  @spec inbounds?(Piece.position()) :: boolean 
  defp inbounds?({row, col}) do
    bounds = %{min: 0, max: 7}
    row >= bounds.min && row <= bounds.max && col >= bounds.min && col <= bounds.max
  end
end
