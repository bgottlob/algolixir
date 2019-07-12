defmodule AlgolixirTest do
  use ExUnit.Case
  doctest Algolixir

  test "greets the world" do
    assert Algolixir.hello() == :world
  end
end
