defmodule RealtimeChess.Game.RookTest do
  use ExUnit.Case, async: true
  alias RealtimeChess.Game.Rook

  describe "Rook.move_positions/2" do
    test "returns a set with the positions a rook can move" do
      expected_positions = [
        {0, 3}, {1, 3}, {2, 3}, {4, 3}, {5, 3}, {6, 3}, {7, 3},  
        {3, 0}, {3, 1}, {3, 2}, {3, 4}, {3, 5}, {3, 6}, {3, 7}
      ]
      surrounding_pieces = MapSet.new([])
      assert MapSet.new(expected_positions) == Rook.move_positions({3, 3}, :white, surrounding_pieces)
    end

    test "returns a set excluding positions blocked by other pieces" do
      expected_positions = [
        {4, 3}, {5, 3}, {6, 3}, {7, 3},  
        {3, 0}, {3, 1}, {3, 2}, {3, 4}, {3, 5}, {3, 6}, {3, 7}
      ]
      surrounding_pieces = MapSet.new([%{position: {2, 3}, piece: {:black, :pawn}}])
      assert MapSet.new(expected_positions) == Rook.move_positions({3, 3}, :white, surrounding_pieces)
    end
  end

  describe "Rooka.attack_positions/3" do
    test "returns a set with the positions a rook can attack" do
      expected_positions = [
        {0, 3}, {1, 3}, {2, 3}, {4, 3}, {5, 3}, {6, 3}, {7, 3},  
        {3, 0}, {3, 1}, {3, 2}, {3, 4}, {3, 5}, {3, 6}, {3, 7}
      ]

      surrounding_pieces = MapSet.new([])
      assert MapSet.new(expected_positions) == Rook.attack_positions({3, 3}, :white, surrounding_pieces)
    end

    test "returns a set excluding positions blocked by opposing pieces" do
      expected_positions = [
        {2, 3}, {4, 3}, {5, 3}, {6, 3}, {7, 3},  
        {3, 0}, {3, 1}, {3, 2}, {3, 4}, {3, 5}, {3, 6}, {3, 7}
      ]
      surrounding_pieces = MapSet.new([%{position: {2, 3}, piece: {:black, :pawn}}])
      assert MapSet.new(expected_positions) == Rook.attack_positions({3, 3}, :white, surrounding_pieces)
    end

    test "returns a set excluding positions blocked by same color pieces" do
      expected_positions = [
        {4, 3}, {5, 3}, {6, 3}, {7, 3},  
        {3, 0}, {3, 1}, {3, 2}, {3, 4}, {3, 5}, {3, 6}, {3, 7}
      ]
      surrounding_pieces = MapSet.new([%{position: {2, 3}, piece: {:white, :pawn}}])
      assert MapSet.new(expected_positions) == Rook.attack_positions({3, 3}, :white, surrounding_pieces)
    end
  end
end
