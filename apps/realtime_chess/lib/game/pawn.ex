defmodule RealtimeChess.Game.Pawn do
  alias RealtimeChess.Game.Piece

  @starting_row %{white: 1, black: 6}

  @spec move_positions(tuple, :white | :black, Piece.pieces()) :: Piece.positions()
  def move_positions({row, col}, color, surrounding_pieces) do
    surrounding_positions = get_positions(surrounding_pieces)

    direction = if (color == :white), do: 1, else: -1 

    first_square = {row + direction, col}
    second_square = {row + (direction * 2), col}

    cond do
      # first square is out of bounds
      out_of_bounds?(first_square) -> MapSet.new([]) 
      # first square is occupied
      MapSet.member?(surrounding_positions, first_square) -> MapSet.new([]) 
      # not on starting row and first square is free
      @starting_row[color] != row -> MapSet.new([first_square]) 
      # on starting row and second square is blocked 
      MapSet.member?(surrounding_positions, second_square) -> MapSet.new([first_square]) 
      # on starting row and second square is free
      @starting_row[color] == row -> MapSet.new([first_square, second_square])
    end
  end

  @spec attack_positions(tuple, :white | :black, Piece.pieces()) :: Piece.positions()  
  def attack_positions({row, col}, color, surrounding_pieces) do
    possible_attacks = if (color == :black) do 
      [{row - 1, col + 1}, {row - 1, col - 1}]
      |> Enum.filter(&inbounds?/1)
      |> MapSet.new()
    else
      [{row + 1, col + 1}, {row + 1, col - 1}]
      |> Enum.filter(&inbounds?/1)
      |> MapSet.new()
    end

    surrounding_positions = 
      surrounding_pieces
      |> Enum.filter(fn %{position: _, piece: {curr_color, _}} -> curr_color == color end)  
      |> MapSet.new()
      |> get_positions() 

    MapSet.difference(possible_attacks, surrounding_positions) 
  end


  @spec get_positions(Piece.pieces()) :: Piece.positions() 
  defp get_positions(surrounding_pieces) do
    surrounding_pieces
    |> Enum.map(fn %{position: position, piece: _} -> position end)  
    |> MapSet.new()
  end

  @spec out_of_bounds?(Piece.position()) ::boolean
  defp out_of_bounds?(position) do
    !inbounds?(position)
  end

  @spec inbounds?(Piece.position()) :: boolean 
  defp inbounds?({row, col}) do
    bounds = %{min: 0, max: 7}
    row >= bounds.min && row <= bounds.max && col >= bounds.min && col <= bounds.max
  end
end
