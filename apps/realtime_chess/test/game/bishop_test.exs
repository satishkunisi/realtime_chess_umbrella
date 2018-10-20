defmodule RealtimeChess.Game.BishopTest do
  use ExUnit.Case, async: true
  alias RealtimeChess.Game.Bishop

  describe "Bishop.move_positions/2" do
    test "returns a set with the positions a bishop can move" do
      expected_positions = [
        {0, 0}, {1, 1}, {2, 2}, {4, 4}, {5, 5}, {6, 6}, {7, 7},
        {4, 2}, {5, 1}, {6, 0}, {2, 4}, {1, 5}, {0, 6}
      ]
      surrounding_pieces = MapSet.new([])
      assert MapSet.new(expected_positions) == Bishop.move_positions({3, 3}, :white, surrounding_pieces)
    end

    test "returns a set excluding positions blocked by other pieces" do
      expected_positions = [
        {4, 4}, {5, 5}, {6, 6}, {7, 7},
        {4, 2}, {5, 1}, {6, 0}, {2, 4}, {1, 5}, {0, 6}
      ]
      surrounding_pieces = MapSet.new([%{position: {2, 2}, piece: {:black, :pawn}}])
      assert MapSet.new(expected_positions) == Bishop.move_positions({3, 3}, :white, surrounding_pieces)
    end
  end

  describe "Bishopa.attack_positions/3" do
    test "returns a set with the positions a bishop can attack" do
      expected_positions = [
        {0, 0}, {1, 1}, {2, 2}, {4, 4}, {5, 5}, {6, 6}, {7, 7},
        {4, 2}, {5, 1}, {6, 0}, {2, 4}, {1, 5}, {0, 6}
      ]

      surrounding_pieces = MapSet.new([])
      assert MapSet.new(expected_positions) == Bishop.attack_positions({3, 3}, :white, surrounding_pieces)
    end

    test "returns a set excluding positions blocked by opposing pieces" do
      expected_positions = [
        {2, 2}, {4, 4}, {5, 5}, {6, 6}, {7, 7},
        {4, 2}, {5, 1}, {6, 0}, {2, 4}, {1, 5}, {0, 6}
      ]
      surrounding_pieces = MapSet.new([%{position: {2, 2}, piece: {:black, :pawn}}])
      assert MapSet.new(expected_positions) == Bishop.attack_positions({3, 3}, :white, surrounding_pieces)
    end

    test "returns a set excluding positions blocked by same color pieces" do
      expected_positions = [
        {4, 4}, {5, 5}, {6, 6}, {7, 7},
        {4, 2}, {5, 1}, {6, 0}, {2, 4}, {1, 5}, {0, 6}
      ]
      surrounding_pieces = MapSet.new([%{position: {2, 2}, piece: {:white, :pawn}}])
      assert MapSet.new(expected_positions) == Bishop.attack_positions({3, 3}, :white, surrounding_pieces)
    end
  end
end
