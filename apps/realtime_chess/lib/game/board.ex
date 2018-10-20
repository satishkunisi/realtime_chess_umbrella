defmodule RealtimeChess.Game.Board do
  alias RealtimeChess.Game.GameState
  alias RealtimeChess.Game.Piece

  @type t :: %{required(integer) => %{required(integer) => board_piece}}

  @typep board_piece :: (nil | piece)
  @typep board :: t
  @typep piece :: tuple
  @typep position :: {integer, integer}

  @spec fetch(board, integer) :: {:ok, %{required(integer) => board_piece}} | :error
  def fetch(board, key), do: Map.fetch(board, key)

  @spec checkmate?(board, Piece.color()) :: boolean
  def checkmate?(board, king_color) do
    if in_check?(board, king_color) do
      board
      |> valid_positions_by_piece()
      |> Map.to_list()
      |> Enum.filter(fn {%{piece: {piece_color, _type}, position: _current_position}, _positions} -> piece_color == king_color end)
      |> Enum.all?(fn {%{piece: _piece, position: current_position}, valid_positions} ->
        valid_positions
        |> MapSet.to_list()
        |> Enum.all?(fn new_position ->
          updated_board_in_check?(board, current_position, new_position, king_color)
        end)
      end)
    else
      false
    end
  end

  @spec updated_board_in_check?(board,  Piece.position(), Piece.position(), Piece.color()) :: boolean()
  defp updated_board_in_check?(board, current_position, new_position, king_color) do
    board
    |> move_piece(%{current_position: current_position, new_position: new_position})
    |> in_check?(king_color)
  end

  @spec valid_positions_by_piece(board) :: map()
  def valid_positions_by_piece(board) do
    board
    |> Map.to_list()
    |> Enum.flat_map(fn {row, pieces} ->
      pieces
      |> Map.to_list()
      |> Enum.reject(fn {_col, piece} -> is_nil(piece) end)
      |> Enum.map(fn {col, piece} -> %{piece: piece, position: {row, col}} end)
    end)
    |> Enum.reduce(%{}, fn board_piece, positions_by_piece ->
      Map.put(
        positions_by_piece,
        board_piece,
        GameState.valid_moves(board, board_piece)
      )
    end)
  end

  @spec in_check?(board, Piece.color()) :: boolean
  def in_check?(board, king_color) do
    king = get_pieces_by_attrs(board, :king, king_color)
      |> MapSet.to_list()
      |> List.first()

    board
    |> valid_positions_by_piece()
    |> Map.to_list()
    |> Enum.filter(fn {%{piece: {piece_color, _type}, position: _position}, _valid_positions} -> piece_color != king_color end)
    |> Enum.any?(fn {_board_piece, valid_positions} ->
      MapSet.member?(valid_positions, king.position)
    end)
  end

  @spec insert_piece(board, {integer, integer}, piece) :: board
  def insert_piece(board, {row, col}, piece) do
    put_in(board[row][col], piece)
  end

  @spec move_piece(board, %{current_position: position, new_position: position}) :: board
  def move_piece(board, %{current_position: current_position, new_position: new_position}) do
    piece = get_piece(board, current_position)

    board
      |> delete_piece(current_position)
      |> insert_piece(new_position, piece)
  end

  @spec blank_board :: board
  def blank_board do
    add_row(%{}, 0)
  end

  @spec populate_board :: board
  def populate_board do
    white_pawn = {:white, :pawn}
    black_pawn = {:black, :pawn}

    blank_board()
      |> fill_row(1, white_pawn)
      |> fill_row(6, black_pawn)
      |> fill_back
  end

  @spec get_pieces_by_attrs(board, Piece.piece_type(), Piece.color()) :: Piece.pieces()
  defp get_pieces_by_attrs(board, type, color) do
    board
    |> Map.to_list()
    |> Enum.flat_map(fn {row, pieces} ->
      pieces
      |> Map.to_list()
      |> Enum.reject(fn {_, piece} -> is_nil(piece) end)
      |> Enum.filter(fn {_, piece} -> piece == {color, type} end)
      |> Enum.map(fn {col, piece} -> %{piece: piece, position: {row, col}} end)
    end)
    |> MapSet.new()
  end

  @spec fill_back(board) :: board
  defp fill_back(board) do
    pieces = [
      {:rook, [0, 7]},
      {:knight, [1, 6]},
      {:bishop, [2, 5]},
      {:queen, [3]},
      {:king, [4]}
    ]

    Enum.reduce(pieces, board, fn ({piece, positions}, new_board) ->
      Enum.reduce(positions, new_board, fn (col, temp_board) ->
        with_white = put_in(temp_board[0][col], {:white, piece})
        put_in(with_white[7][col], {:black, piece})
      end)
    end)
  end

  @spec fill_row(board, integer, piece) :: board
  defp fill_row(board, row, piece) do
    cols = 0..7
    Enum.reduce(cols, board, fn col, new_board ->
      put_in(new_board, [row, col], piece)
    end)
  end

  @spec add_row(board, integer) :: map
  defp add_row(board, row_num) do
    row = initialize_row(%{}, 0)

    if row_num < 8 do
      Map.put(board, row_num, row) |> add_row(row_num + 1)
    else
      board
    end
  end

  @spec initialize_row(map, integer) :: map
  defp initialize_row(row, col_num) do
    if col_num < 8 do
      Map.put(row, col_num, nil) |> initialize_row(col_num + 1)
    else
      row
    end
  end

  @spec get_piece(board, position) :: (piece | nil)
  defp get_piece(board, {row, col}) do
    board[row][col]
  end

  @spec delete_piece(board, {integer, integer}) :: board
  defp delete_piece(board, {row, col}) do
    put_in(board[row][col], nil)
  end
end
