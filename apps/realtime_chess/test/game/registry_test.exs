defmodule RealtimeChess.Game.RegistryTest do
  use ExUnit.Case, async: true
  alias RealtimeChess.Game.Registry

  test "spawns game states" do
    {:ok, _registry} = start_supervised(Registry)

    assert Registry.lookup("testname") == :error

    {:ok, game} = Agent.start_link(fn -> [] end)
    Registry.create(game, "testname")

    assert {:ok, game} = Registry.lookup("testname")
  end
end
