defmodule BSTTest do
  alias BinTree, as: BT
  import Zipper
  use ExUnit.Case

  defp bt(value, left, right), do: %BT{value: value, left: left, right: right}
  defp leaf(value), do: %BT{value: value}

  defp t1, do: bt(3, bt(2, nil, leaf(3)), leaf(4))

  test "it searches for a thing" do
    assert t1() |> BST.search(4) == leaf(4)
    assert t1() |> BST.search(5) == nil
  end
end
