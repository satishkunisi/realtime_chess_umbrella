defmodule RealtimeChess do
  use Application

  def hello do
    :world
  end

  def start(_type, _args) do
    IO.puts "starting chess application..."
    RealtimeChess.Supervisor.start_link(name: RealtimeChess.Supervisor)
  end
end
