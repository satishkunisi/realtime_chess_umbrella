defmodule RealtimeChess.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {RealtimeChess.Game.Registry, name: RealtimeChess.Game.Registry},
      {RealtimeChess.Game.Supervisor, name: RealtimeChess.Game.Supervisor},
    ]

    Supervisor.init(children, strategy: :one_for_one, name: __MODULE__)
  end
end
