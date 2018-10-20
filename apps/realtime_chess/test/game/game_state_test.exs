defmodule RealtimeChess.Game.GameStateTest do
  use ExUnit.Case, async: true
  alias RealtimeChess.Game.GameState
  alias RealtimeChess.Game
  alias RealtimeChess.Game.Board

  setup do
    with {:ok, game_pid} <- GameState.create(name: "testgame"),
         {:ok, game_state} <- GameState.fetch(game_pid)
    do
          %{game_state: game_state}
    end
  end

  test "game has a name", %{game_state: game_state} do
    assert Map.get(game_state, :name) == "testgame"
  end

  test "initializes board", %{game_state: game_state} do
    board = game_state.board

    assert board |> Map.keys |> length == 8

    assert board
      |> Map.values
      |> Enum.all?(fn row ->
        row |> Map.keys |> length == 8
      end)

    assert {:white, :king} == board[0][4]
    assert {:black, :knight} == board[7][1]
    assert {:black, :pawn} == board[6][1]
  end

  test "moves a piece", %{game_state: game_state} do
    new_state = game_state
      |> GameState.move_piece(%{current_position: {1,0}, new_position: {2,2}})

    assert {:white, :pawn} == new_state.board[2][2]
  end

  describe "surrounding_pieces/2" do
    test "get surrounding pieces and stop when out of bound" do
      piece_position = {0, 0}

      #   0 1 2 3 4 5 6 7
      # 0 x x x x x x x x
      # 1 x x x x x x x x
      # 2 x x x x x x x x
      # 3 x x x x x x x x
      # 4 x x x Q x x x x
      # 5 x x x x x x x x
      # 6 x x x x x x x x
      # 7 x x x x x x x x

      surrounding_pieces = []

      new_board = Board.blank_board()

      setup_board = Enum.reduce(surrounding_pieces, new_board, fn (%{piece: piece, position: {row, col}}, new_board) ->
        put_in(new_board, [row, col], piece)
      end)

      assert GameState.surrounding_pieces(setup_board, piece_position) == MapSet.new(surrounding_pieces)
    end

    test "get surrounding pieces two rows and columns away" do
      piece_position = {4, 3}

      #   0 1 2 3 4 5 6 7
      # 0 x x x x x x x x
      # 1 x x x x x x x x
      # 2 x 1 1 1 1 1 x x
      # 3 x 1 x x x 1 x x
      # 4 x 1 x Q x 1 x x
      # 5 x 1 x x x 1 x x
      # 6 x 1 1 1 1 1 x x
      # 7 x x x x x x x x

      surrounding_pieces = [
        %{piece: {:white, :pawn}, position: {2, 1}},
        %{piece: {:black, :pawn}, position: {2, 2}},
        %{piece: {:white, :pawn}, position: {2, 3}},
        %{piece: {:black, :pawn}, position: {2, 4}},
        %{piece: {:white, :pawn}, position: {2, 5}},
        %{piece: {:black, :pawn}, position: {3, 1}},
        %{piece: {:white, :pawn}, position: {4, 1}},
        %{piece: {:black, :pawn}, position: {5, 1}},
        %{piece: {:white, :pawn}, position: {6, 1}},
        %{piece: {:black, :pawn}, position: {6, 2}},
        %{piece: {:white, :pawn}, position: {6, 3}},
        %{piece: {:black, :pawn}, position: {6, 4}},
        %{piece: {:white, :pawn}, position: {6, 5}},
        %{piece: {:black, :pawn}, position: {3, 5}},
        %{piece: {:white, :pawn}, position: {4, 5}},
        %{piece: {:black, :pawn}, position: {5, 5}}
      ]

      new_board = Board.blank_board()

      setup_board = Enum.reduce(surrounding_pieces, new_board, fn (%{piece: piece, position: {row, col}}, new_board) ->
        put_in(new_board, [row, col], piece)
      end)

      assert GameState.surrounding_pieces(setup_board, piece_position) == MapSet.new(surrounding_pieces)
    end

    test "get surrounding pieces three rows and columns away" do
      piece_position = {4, 3}

      #   0 1 2 3 4 5 6 7
      # 0 x x x x x x x x
      # 1 o - - o - - o x
      # 2 - x x x x x - x
      # 3 - x x x x x - x
      # 4 o x x Q x x o x
      # 5 - x x x x x - x
      # 6 - x x x x x - x
      # 7 o - - o - - o x

      expected_pieces = [
        %{piece: {:white, :pawn}, position: {1, 0}},
        %{piece: {:black, :pawn}, position: {1, 3}},
        %{piece: {:white, :pawn}, position: {1, 6}},
        %{piece: {:black, :pawn}, position: {4, 0}},
        %{piece: {:white, :pawn}, position: {4, 6}},
        %{piece: {:black, :pawn}, position: {7, 0}},
        %{piece: {:white, :pawn}, position: {7, 3}},
        %{piece: {:black, :pawn}, position: {7, 6}}
      ]

      ignored_pieces = [
        %{piece: {:white, :pawn}, position: {1, 1}},
        %{piece: {:white, :pawn}, position: {1, 2}},
        %{piece: {:white, :pawn}, position: {1, 4}},
        %{piece: {:white, :pawn}, position: {1, 5}},
        %{piece: {:white, :pawn}, position: {2, 0}},
        %{piece: {:white, :pawn}, position: {3, 0}}
      ]

      new_board = Board.blank_board()

      surrounding_pieces = expected_pieces ++ ignored_pieces

      setup_board = Enum.reduce(surrounding_pieces, new_board, fn (%{piece: piece, position: {row, col}}, new_board) ->
        put_in(new_board, [row, col], piece)
      end)

      assert GameState.surrounding_pieces(setup_board, piece_position) == MapSet.new(expected_pieces)
    end
  end

  describe "GameState.valid_moves/2" do
    test "it returns valid moves based on piece type" do
      piece = %{piece: {:white, :queen}, position: {4, 3}}

      #   0 1 2 3 4 5 6 7
      # 0 x x x x x x x x
      # 1 x x x x x x x x
      # 2 x b b b b b x x
      # 3 x b x x x w x x
      # 4 x b x Q x w x x
      # 5 x b x x x w x x
      # 6 x b w w w x x x
      # 7 x x x x x x x x

      surrounding_pieces = [
        %{piece: {:black, :pawn}, position: {2, 1}},
        %{piece: {:black, :pawn}, position: {2, 2}},
        %{piece: {:black, :pawn}, position: {2, 3}},
        %{piece: {:black, :pawn}, position: {2, 4}},
        %{piece: {:black, :pawn}, position: {2, 5}},
        %{piece: {:black, :pawn}, position: {3, 1}},
        %{piece: {:black, :pawn}, position: {4, 1}},
        %{piece: {:black, :pawn}, position: {5, 1}},
        %{piece: {:black, :pawn}, position: {6, 1}},
        %{piece: {:white, :pawn}, position: {6, 2}},
        %{piece: {:white, :pawn}, position: {6, 3}},
        %{piece: {:white, :pawn}, position: {6, 4}},
        %{piece: {:white, :pawn}, position: {3, 5}},
        %{piece: {:white, :pawn}, position: {4, 5}},
        %{piece: {:white, :pawn}, position: {5, 5}}
      ]

      expected_moves = MapSet.new([
        {2, 1},
        {2, 3},
        {2, 5},
        {3, 2},
        {3, 3},
        {3, 4},
        {4, 1},
        {4, 2},
        {4, 4},
        {5, 2},
        {5, 3},
        {5, 4},
        {6, 1},
        {6, 5},
        {7, 6}
      ])

      new_board = Board.blank_board()

      setup_board = Enum.reduce(surrounding_pieces, new_board, fn (%{piece: piece, position: {row, col}}, new_board) ->
        put_in(new_board, [row, col], piece)
      end)

      assert GameState.valid_moves(setup_board, piece) == expected_moves
    end
  end
end
