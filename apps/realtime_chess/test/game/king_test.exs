defmodule RealtimeChess.Game.KingTest do
  use ExUnit.Case, async: true
  alias RealtimeChess.Game.King

  describe "King.move_positions/3" do
    test "returns a set with the eight positions a king can move from any given starting position" do
      surrounding_pieces = MapSet.new([])
      expected_pieces = [{4, 3}, {2, 3}, {3, 4}, {3, 2}, {4, 4}, {2, 2}, {4, 2}, {2, 2}, {2, 4}]
      assert MapSet.new(expected_pieces) == King.move_positions({3 ,3}, :white, surrounding_pieces)
      assert MapSet.new(expected_pieces) == King.move_positions({3 ,3}, :black, surrounding_pieces)
    end

    test "retuns a set with the seven circumscribed positions a king can move with a surrounding piece" do
      surrounding_pieces = MapSet.new([%{position: {4, 3}, piece: {:black, :pawn}}])
      expected_pieces = [{2, 3}, {3, 4}, {3, 2}, {4, 4}, {2, 2}, {4, 2}, {2, 2}, {2, 4}]
      assert MapSet.new(expected_pieces) == King.move_positions({3 ,3}, :white, surrounding_pieces)
    end

    test "retuns a set excluding out of bounds positions" do
      surrounding_pieces = MapSet.new([])
      assert MapSet.new([{0, 1}, {1, 1}, {1, 0}]) == King.move_positions({0 ,0}, :white, surrounding_pieces)
    end
  end

  describe "King.attack_positions/3" do
    test "returns a set with the eight positions a king can attack from any given starting position" do
      surrounding_pieces = MapSet.new([])
      expected_pieces = [{4, 3}, {2, 3}, {3, 4}, {3, 2}, {4, 4}, {2, 2}, {4, 2}, {2, 2}, {2, 4}]
      assert MapSet.new(expected_pieces) == King.attack_positions({3 ,3}, :white, surrounding_pieces)
      assert MapSet.new(expected_pieces) == King.attack_positions({3 ,3}, :black, surrounding_pieces)
    end

    test "retuns a set with the eight circumscribed positions a king can move with a surrounding piece of opposing color" do
      surrounding_pieces = MapSet.new([%{position: {4, 3}, piece: {:black, :pawn}}])
      expected_pieces = [{4, 3}, {2, 3}, {3, 4}, {3, 2}, {4, 4}, {2, 2}, {4, 2}, {2, 2}, {2, 4}]
      assert MapSet.new(expected_pieces) == King.attack_positions({3 ,3}, :white, surrounding_pieces)
    end

    test "retuns a set excluding out of bounds positions" do
      surrounding_pieces = MapSet.new([])
      assert MapSet.new([{0, 1}, {1, 1}, {1, 0}]) == King.attack_positions({0 ,0}, :white, surrounding_pieces)
    end
  end
end
