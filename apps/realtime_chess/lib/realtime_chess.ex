defmodule RealtimeChess do
  use Application

  def hello do
    :world
  end

  def start(_type, _args) do
    children = [
      {RealtimeChess.Game.Registry, name: RealtimeChess.Game.Registry},
      {DynamicSupervisor, name: RealtimeChess.GameSupervisor, strategy: :one_for_one}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: RealtimeChess.Supervisor)
  end
end
