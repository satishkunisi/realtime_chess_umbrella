defmodule RealtimeChess.Game.BoardTest do
use ExUnit.Case, async: true
  alias RealtimeChess.Game.Board

  describe ".in_check?/2" do
    test "takes a Board and a color and returns true if King of given color is in check" do
      blank_board = Board.blank_board()

      pieces = [
        %{piece: {:white, :king}, position: {3, 5}},
        %{piece: {:black, :queen}, position: {3, 3}},
        %{piece: {:black, :king}, position: {1, 1}}
      ]

      board = Enum.reduce(pieces, blank_board, fn data, board ->
         Board.insert_piece(board, data.position, data.piece)
      end)

      assert Board.in_check?(board, :white) == true
      assert Board.in_check?(board, :black) == false

      board = Board.insert_piece(board, {3, 4}, {:white, :pawn})
      assert Board.in_check?(board, :white) == false

      board = Board.insert_piece(board, {5, 4}, {:black, :knight})
      assert Board.in_check?(board, :white) == true

      board = Board.insert_piece(board, {7, 1}, {:white, :rook})
      assert Board.in_check?(board, :black) == true
    end
  end

  describe ".checkmate?" do
    test "pieces of same type checkmate opposing king" do
      blank_board = Board.blank_board()

      pieces = [
        %{piece: {:white, :king}, position: {0, 1}},
        %{piece: {:black, :pawn}, position: {1, 0}},
        %{piece: {:black, :pawn}, position: {1, 1}},
        %{piece: {:black, :pawn}, position: {1, 2}},
        %{piece: {:black, :queen}, position: {2, 1}}
      ]

      board = Enum.reduce(pieces, blank_board, fn data, board ->
        Board.insert_piece(board, data.position, data.piece)
      end)

      assert Board.checkmate?(board, :white) == true
    end

    test "takes a board and a color and returns true if player of given color is checkmated" do
      blank_board = Board.blank_board()

      pieces = [
        %{piece: {:white, :king}, position: {0, 0}},
        %{piece: {:black, :queen}, position: {0, 1}},
        %{piece: {:black, :rook}, position: {5, 1}},
        %{piece: {:black, :king}, position: {7, 7}},
        %{piece: {:white, :knight}, position: {5, 6}}
      ]

      board = Enum.reduce(pieces, blank_board, fn data, board ->
        Board.insert_piece(board, data.position, data.piece)
      end)

      assert Board.checkmate?(board, :white) == true
      assert Board.checkmate?(board, :black) == false
    end

    test "returns false if king of specified color is not in check but there are no valid moves" do
      blank_board = Board.blank_board()

      # _ _ Q
      # K - - -

      pieces = [
        %{piece: {:white, :king}, position: {0, 0}},
        %{piece: {:black, :queen}, position: {1, 2}},
        %{piece: {:black, :king}, position: {7, 7}}
      ]

      board = Enum.reduce(pieces, blank_board, fn data, board ->
        Board.insert_piece(board, data.position, data.piece)
      end)

      assert Board.checkmate?(board, :white) == false
    end
  end
end
