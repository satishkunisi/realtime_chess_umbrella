defmodule RealtimeChess.Game.Registry do
  use GenServer

  @spec register_game(pid(), String.t()) :: {:ok, String.t()} | {:error, any()}
  def register_game(game_pid, name) do
     GenServer.call(__MODULE__, {:create, game_pid, name})
     {:ok, name}
  end

  @spec start_link(list(atom)) :: any
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @spec lookup(String.t) :: pid() | :error
  def lookup(name) do
    case GenServer.call(__MODULE__, {:lookup, name}) do
      {:ok, game_pid} -> game_pid
      :error -> :error
    end
  end

  @spec create(game :: pid, name :: String.t) :: tuple | atom
  def create(game, name) do
    GenServer.call(__MODULE__, {:create, game, name})
  end

  ## Server callbacks

  @spec init(:ok) :: {:ok, %{}}
  def init(:ok) do
    {:ok, %{}}
  end

  @type call_response :: {:reply, struct, map}

  @spec handle_call({:lookup, String.t()}, GenServer.from, map) :: call_response
  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  @spec handle_call({:create, pid(), String.t()}, GenServer.from, map) :: call_response
  def handle_call({:create, game, name}, _from, names) do
    if Map.has_key?(names, name) do
      {:reply, Map.fetch(names, name), names}
    else
      new_names = Map.put(names, name, game)
      {:reply, game, new_names}
    end
  end
end
