defmodule RealtimeChess.Game.Supervisor do
  alias RealtimeChess.Game.GameState
  alias RealtimeChess.Game

  use DynamicSupervisor

  @spec create_game(Game.t) :: {:ok, pid()}
  def create_game(game_state) do
    DynamicSupervisor.start_child(__MODULE__, {GameState, game_state})
  end

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
