defmodule RealtimeChess.Game.KnightTest do
  use ExUnit.Case, async: true
  alias RealtimeChess.Game.Knight

  setup do
    surrounding_pieces = MapSet.new([
      %{position: {4, 5}, piece: {:black, :pawn}},
      %{position: {2, 5}, piece: {:white, :pawn}},
    ])
    %{surrounding_pieces: surrounding_pieces}
  end

  describe "Knight.move_positions/3" do
    test "returns a set with the four positions a knight can move from any given starting position", %{surrounding_pieces: surrounding_pieces} do
      expected_positions = [{2, 1}, {4, 1}, {5, 4}, {1, 4}, {1, 2}, {5, 2}]
      assert MapSet.new(expected_positions) == Knight.move_positions({3, 3}, :white, surrounding_pieces)
      assert MapSet.new(expected_positions) == Knight.move_positions({3, 3}, :black, surrounding_pieces)
    end
  end

  describe "Knight.attack_positions/3" do
    test "returns a set with the positions a knight can attack from any given starting position", %{surrounding_pieces: surrounding_pieces} do
      expected_white_positions = [{4, 5}, {2, 1}, {4, 1}, {5, 4}, {1, 4}, {1, 2}, {5, 2}]
      assert MapSet.new(expected_white_positions) == Knight.attack_positions({3, 3}, :white, surrounding_pieces)
      expected_black_positions = [{2, 5}, {2, 1}, {4, 1}, {5, 4}, {1, 4}, {1, 2}, {5, 2}]
      assert MapSet.new(expected_black_positions) == Knight.attack_positions({3, 3}, :black, surrounding_pieces)
    end
  end
end
