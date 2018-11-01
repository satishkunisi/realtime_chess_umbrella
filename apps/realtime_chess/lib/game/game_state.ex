defmodule RealtimeChess.Game.GameState do
  alias RealtimeChess.Game
  alias RealtimeChess.Game.Board
  alias RealtimeChess.Game.Piece
  alias RealtimeChess.Game.Registry

  @type game_option() :: {:name, String.t()} | {:board, Board.t()} | {:status, game_status()} | {:player_white, player} | {:player_black, player}
  @type game_options() :: [game_option()]
  @type player() :: String.t() | nil

  @typep board :: Board.t
  @typep position :: Piece.position()
  @typep pieces :: Piece.pieces()
  @typep board_piece :: Piece.board_piece()
  @typep game_status() :: :started | :white | :black | :white_checkmated | :black_checkmated | :draw
  @type game_id() :: String.t() | pid()

  use GenServer

  @spec initialize_board(Game.t) :: Game.t
  def initialize_board(game_state) do
    %Game{game_state | board: Board.populate_board()}
  end

  @spec assign_player(game_id(), String.t(), Board.color()) :: {:ok, Game.t} | {:error, String.t()}
  def assign_player(game_id, player, target_color \\ nil) do
    with {:ok, game_state} <- fetch(game_id),
      {:ok, :started} <- Map.fetch(game_state, :status),
      {:ok, player_color} <- open_color(target_color, game_state.player_white, game_state.player_black)
    do
      game_state.name
      |> Registry.lookup()
      |> GenServer.call({:assign_player, player_color, player})
    else
      {:error, _state_fetch_failure} -> {:error, "no Game with that id"}
      {:ok, _game_began} -> {:error, "can't assign player to game that has begun"}
      {:error, "no open color"} -> {:error, "no player position available"}
    end
  end

  @spec start(pid()) :: {:ok, Game.t} | {:error, String.t()}
  def start(game_id) when is_pid(game_id) do
    GenServer.call(game_id, :start)
  end

  @spec start(String.t()) :: {:ok, Game.t} | {:error, String.t()}
  def start(game_id)  when is_binary(game_id) do
    game_id
    |> Registry.lookup()
    |> GenServer.call(:start)
  end

  @spec update_name(Game.t, String.t) :: Game.t
  def update_name(%Game{} = game_state, new_name) do
    Map.put(game_state, :name, new_name)
  end

  @spec create(game_options()) :: GenServer.on_start()
  def create(options \\ []) do
    name = Keyword.get(options, :name, random_string(10))
    board = Keyword.get(options, :board, Board.populate_board())
    status = Keyword.get(options, :status, :started)
    player_white = Keyword.get(options, :player_white, nil)
    player_black = Keyword.get(options, :player_black, nil)

    game = %Game{
      name: name,
      board: board,
      status: status,
      player_white: player_white,
      player_black: player_black
    }

    {:ok, game_pid} = GenServer.start_link(__MODULE__, game)
    {:ok, _registered_name} = RealtimeChess.Game.Registry.register_game(game_pid, name)

    {:ok, game_pid}
  end

  @spec fetch(pid()) :: {:ok, Game.t} | {:error, GenServer.reason()}
  def fetch(pid) when is_pid(pid) do
    GenServer.call(pid, :get_state)
  end

  @spec fetch(String.t()) :: {:ok, Game.t} | {:error, GenServer.reason()}
  def fetch(name) when is_binary(name) do
    pid = RealtimeChess.Game.Registry.lookup(name)
    GenServer.call(pid, :get_state)
  end

  # GenServer Callbacks

  @impl true
  def init(%Game{} = initial_state) do
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:start_game, _from, game) do
    if game.status == :unstarted do
      new_game = Map.put(game, :status, :white)
      {:reply, new_game, new_game}
    else
      {:stop, {:error, "game already started"}, "game already started", game}
    end
  end

  @impl true
  def handle_call(:end_turn, _from, game) do
    case game.status do
      :white ->
        new_game = Map.put(game, :status, :black)
        {:reply, {:ok, new_game}, new_game}
      :black ->
        new_game = Map.put(game, :status, :white)
        {:reply, {:ok, new_game}, new_game}
      _ ->
        {:stop, {:error, "game not in progress"}, "game not in progress", game}
    end
  end

  @impl true
  def handle_call(:start, _from, game) do
    new_game = Map.put(game, :status, :white)
    {:reply, {:ok, new_game}, new_game}
  end

  @impl true
  def handle_call({:assign_player, player_color, player}, _from, game) do
    new_game = Map.put(game, player_color, player)
    {:reply, {:ok, new_game}, new_game}
  end

  @impl true
  def handle_call(:get_state, _from, game) do
    {:reply, {:ok, game}, game}
  end

  @spec random_string(number) :: String.t
  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  ## TODO: Move the functions below to the Board module

  @spec move_piece(Game.t, %{current_position: position, new_position: position}) :: Game.t
  def move_piece(%Game{} = game, %{current_position: _, new_position: _} = positions) do
    %Game{game | board: Board.move_piece(game.board, positions)}
  end

  @default_deltas %{
               up: {-1, 0},
             down: {1, 0},
             left: {0, -1},
            right: {0, 1},
         down_right: {1, 1},
          down_left: {1, -1},
        up_left: {-1, -1},
       up_right: {-1, 1},
      el_down_right: {2, 1},
       el_down_left: {2, -1},
     el_up_left: {-2, -1},
    el_up_right: {-2, 1},
      el_right_down: {1, 2},
    el_right_up: {1, -2},
     el_left_up: {-1, -2},
       el_left_down: {-1, 2}
  }

  @el_delta_keys [
   :el_down_right,
   :el_down_left,
   :el_up_left,
   :el_up_right,
   :el_right_down,
   :el_right_up,
   :el_left_up,
   :el_left_down
 ]

  @spec surrounding_pieces(board, position) :: pieces()
  def surrounding_pieces(board, piece_position) do
    surrounding_pieces(board, piece_position, 1, @default_deltas)
  end


  defp open_color(target_color, player_white, player_black) do
    cond do
      is_nil(player_white) && (target_color == :white || is_nil(target_color)) -> {:ok, :player_white}
      is_nil(player_black) && (target_color == :black || is_nil(target_color)) -> {:ok, :player_black}
      true -> {:error, "color not open"}
    end
  end

  @spec surrounding_pieces(board, position, integer, map) :: pieces()
  defp surrounding_pieces(_, _, _, deltas) when deltas == %{}, do: MapSet.new([])
  defp surrounding_pieces(board, {row, col}, multiplier, deltas) do
    result = deltas
      |> Enum.map(fn {dir, {dy, dx}} -> {dir, {row + (dy * multiplier), col + (dx * multiplier)}} end)
      |> Enum.filter(fn {_, piece} -> inbounds?(piece) end)
      |> Enum.map(fn {dir, {new_row, new_col}} -> {dir, %{piece: board[new_row][new_col], position: {new_row, new_col}}} end)
      |> Enum.split_with(fn {_, %{piece: piece, position: _}} -> is_nil(piece) end)

    {deltas_list, pieces_list} = result

    without_el_deltas = Map.drop(@default_deltas, @el_delta_keys)
    remaining_deltas = Map.take(without_el_deltas, Keyword.keys(deltas_list))
    next_pieces = surrounding_pieces(board, {row, col}, multiplier + 1, remaining_deltas)

    current_pieces = Keyword.values(pieces_list) |> MapSet.new

    MapSet.union(
      current_pieces,
      next_pieces
    )
  end

  @spec valid_moves(board, board_piece) :: pieces()
  def valid_moves(board, %{piece: {color, piece_type}, position: position}) do
    with module_name <- :"Elixir.RealtimeChess.Game.#{piece_type |> Atom.to_string |> String.capitalize}",
         pieces <- surrounding_pieces(board, position)
    do
      MapSet.union(
        module_name.move_positions(position, color, pieces),
        module_name.attack_positions(position, color, pieces)
      )
    end
  end

  @spec inbounds?(position) :: boolean
  defp inbounds?({row, col}) do
    bounds = %{min: 0, max: 7}
    row >= bounds.min && row <= bounds.max && col >= bounds.min && col <= bounds.max
  end
end
