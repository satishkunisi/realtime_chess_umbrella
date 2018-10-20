defmodule RealtimeChess.Game.QueenTest do
  use ExUnit.Case, async: true
  alias RealtimeChess.Game.Queen

  describe "Queen.move_positions/3" do
    test "returns a set with the positions a queen can move" do
      expected_positions = [
        {0, 3}, {1, 3}, {2, 3}, {4, 3}, {5, 3}, {6, 3}, {7, 3},
        {3, 0}, {3, 1}, {3, 2}, {3, 4}, {3, 5}, {3, 6}, {3, 7},
        {0, 0}, {1, 1}, {2, 2}, {4, 4}, {5, 5}, {6, 6}, {7, 7},
        {4, 2}, {5, 1}, {6, 0}, {2, 4}, {1, 5}, {0, 6}
      ]
      surrounding_pieces = MapSet.new([])
      assert MapSet.new(expected_positions) == Queen.move_positions({3, 3}, :white, surrounding_pieces)
    end

    test "returns a set excluding positions blocked by other pieces" do
      expected_positions = [
        {4, 3}, {5, 3}, {6, 3}, {7, 3},
        {3, 0}, {3, 1}, {3, 2}, {3, 4}, {3, 5}, {3, 6}, {3, 7},
        {0, 0}, {1, 1}, {2, 2}, {4, 4}, {5, 5}, {6, 6}, {7, 7},
        {4, 2}, {5, 1}, {6, 0}, {2, 4}, {1, 5}, {0, 6}
      ]
      surrounding_pieces = MapSet.new([%{position: {2, 3}, piece: {:black, :pawn}}])
      assert MapSet.new(expected_positions) == Queen.move_positions({3, 3}, :white, surrounding_pieces)
    end
  end

  describe "Queen.attack_positions/3" do
    test "returns a set with the positions a queen can attack" do
      expected_positions = [
        {0, 3}, {1, 3}, {2, 3}, {4, 3}, {5, 3}, {6, 3}, {7, 3},
        {3, 0}, {3, 1}, {3, 2}, {3, 4}, {3, 5}, {3, 6}, {3, 7},
        {0, 0}, {1, 1}, {2, 2}, {4, 4}, {5, 5}, {6, 6}, {7, 7},
        {4, 2}, {5, 1}, {6, 0}, {2, 4}, {1, 5}, {0, 6}
      ]

      surrounding_pieces = MapSet.new([])
      assert MapSet.new(expected_positions) == Queen.attack_positions({3, 3}, :white, surrounding_pieces)
    end

    test "returns a set including positions blocked by opposing pieces" do
      expected_positions = [
        {2, 3}, {4, 3}, {5, 3}, {6, 3}, {7, 3},
        {3, 0}, {3, 1}, {3, 2}, {3, 4}, {3, 5}, {3, 6}, {3, 7},
        {0, 0}, {1, 1}, {2, 2}, {4, 4}, {5, 5}, {6, 6}, {7, 7},
        {4, 2}, {5, 1}, {6, 0}, {2, 4}, {1, 5}, {0, 6}
      ]
      surrounding_pieces = MapSet.new([%{position: {2, 3}, piece: {:black, :pawn}}])
      assert MapSet.new(expected_positions) == Queen.attack_positions({3, 3}, :white, surrounding_pieces)
    end

    test "returns a set excluding positions blocked by same color pieces" do
      expected_positions = [
        {4, 3}, {5, 3}, {6, 3}, {7, 3},
        {3, 0}, {3, 1}, {3, 2}, {3, 4}, {3, 5}, {3, 6}, {3, 7},
        {0, 0}, {1, 1}, {2, 2}, {4, 4}, {5, 5}, {6, 6}, {7, 7},
        {4, 2}, {5, 1}, {6, 0}, {2, 4}, {1, 5}, {0, 6}
      ]
      surrounding_pieces = MapSet.new([%{position: {2, 3}, piece: {:white, :pawn}}])
      assert MapSet.new(expected_positions) == Queen.attack_positions({3, 3}, :white, surrounding_pieces)
    end
  end
end
