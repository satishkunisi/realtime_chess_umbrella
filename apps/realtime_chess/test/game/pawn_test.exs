defmodule RealtimeChess.Game.PawnTest do
  use ExUnit.Case, async: true
  alias RealtimeChess.Game.Pawn

  describe "Pawn.move_positions/3" do
    test "returns a set with the one position a pawn can move from any given starting position" do
      surrounding_pieces = MapSet.new([])
      assert MapSet.new([{4, 3}]) == Pawn.move_positions({3, 3}, :white, surrounding_pieces)
      assert MapSet.new([{4, 2}]) == Pawn.move_positions({5, 2}, :black, surrounding_pieces)
    end

    test "returns a set with the two positions a pawn can move from the starting row" do
      surrounding_pieces = MapSet.new([])
      assert MapSet.new([{3, 3}, {2, 3}]) == Pawn.move_positions({1, 3}, :white, surrounding_pieces)
      assert MapSet.new([{4, 7}, {5, 7}]) == Pawn.move_positions({6, 7}, :black, surrounding_pieces)
    end

    test "returns an empty set when moves blocked by surrounding pieces" do
      surrounding_pieces = MapSet.new([
        %{position: {4, 3}, piece: {:black, :pawn}},
        %{position: {4, 2}, piece: {:black, :pawn}},
        %{position: {2, 3}, piece: {:black, :pawn}}
      ])
      assert MapSet.new([]) == Pawn.move_positions({3, 3}, :white, surrounding_pieces)
      assert MapSet.new([]) == Pawn.move_positions({5, 2}, :black, surrounding_pieces)
      assert MapSet.new([]) == Pawn.move_positions({1, 3}, :white, surrounding_pieces)
    end

    test "returns an empty set when moves are out of bounds" do
      surrounding_pieces = MapSet.new([])
      assert MapSet.new([]) == Pawn.move_positions({7, 7}, :white, surrounding_pieces)
    end
  end

  describe "Pawn.attack_positions/3" do
    test "returns a set with the two positions a pawn can attack" do
      surrounding_pieces = MapSet.new([])
      assert MapSet.new([{6, 6}, {6, 4}]) == Pawn.attack_positions({5, 5}, :white, surrounding_pieces)
      assert MapSet.new([{4, 6}, {4, 4}]) == Pawn.attack_positions({5, 5}, :black, surrounding_pieces)
    end

    test "returns an empty set when moves blocked by surrounding pieces of same color" do
      surrounding_pieces = MapSet.new([
        %{position: {6, 4}, piece: {:white, :pawn}},
        %{position: {4, 6}, piece: {:black, :pawn}}
      ])

      assert MapSet.new([{6, 6}]) == Pawn.attack_positions({5, 5}, :white, surrounding_pieces)
      assert MapSet.new([{4, 4}]) == Pawn.attack_positions({5, 5}, :black, surrounding_pieces)
    end

    test "returns an empty set when attacks are out of bounds" do
      surrounding_pieces = MapSet.new([])
      assert MapSet.new([]) == Pawn.move_positions({7, 7}, :white, surrounding_pieces)
    end
  end
end
