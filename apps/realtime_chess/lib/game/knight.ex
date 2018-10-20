defmodule RealtimeChess.Game.Knight do 
  alias RealtimeChess.Game.Piece

  @bounds %{row_min: 0, col_min: 0, row_max: 7, col_max: 7} 
  @deltas [{1, 2}, {1, -2}, {-1, -2}, {-1, 2}, {2, 1}, {2, -1}, {-2, -1}, {-2, 1}]

  @spec move_positions(tuple, any(), Piece.pieces()) :: Piece.positions()
  def move_positions({row, col}, _, surrounding_pieces) do
    surrounding_positions = get_positions(surrounding_pieces) 

    possible_positions({row, col})
    |> Enum.filter(&inbounds?/1)
    |> MapSet.new
    |> MapSet.difference(surrounding_positions)
  end

  @spec attack_positions(tuple, :white | :black, Piece.pieces()) :: Piece.positions()  
  def attack_positions({row, col}, piece_color, surrounding_pieces) do
    surrounding_positions = surrounding_pieces
    |> Enum.filter(fn %{position: _, piece: {color, _}} -> color == piece_color end)
    |> MapSet.new()
    |> get_positions()

    possible_positions({row, col})
    |> Enum.filter(&inbounds?/1)
    |> MapSet.new()
    |> MapSet.difference(surrounding_positions)
  end

  @spec possible_positions(tuple) :: list 
  defp possible_positions({row, col}) do 
    Enum.map(@deltas, fn {dy, dx} -> {row + dy, col + dx} end)   
  end

  @spec get_positions(Piece.pieces()) :: Piece.positions() 
  defp get_positions(surrounding_pieces) do
    surrounding_pieces
    |> Enum.map(fn %{position: position, piece: _} -> position end)  
    |> MapSet.new()
  end

  @spec inbounds?(tuple) :: boolean 
  defp inbounds?({row, col}) do
    bounds = %{min: 0, max: 7}
    row >= bounds.min && row <= bounds.max && col >= bounds.min && col <= bounds.max
  end
end
