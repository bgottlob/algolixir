defmodule BinSearchTreeTest do
  alias BinTree, as: BT
  alias BinSearchTree, as: BST
  use ExUnit.Case

  defp bt(value, left, right), do: %BT{value: value, left: left, right: right}
  defp leaf(value), do: %BT{value: value}

  defp t1, do: bt(3, bt(2, leaf(1), nil), leaf(4))
  defp t1_inserted, do: bt(3, bt(2, leaf(1), nil), bt(4, nil, leaf(5)))

  test "it searches for a thing" do
    assert t1() |> BST.search(4) == leaf(4)
    assert t1() |> BST.search(5) == nil
  end

  test "it inserts a thing" do
    assert t1() |> BST.insert(5) == t1_inserted()
  end

  test "it builds a BST" do
    assert BST.from_list_unbalanced([3,2,1,4,5]) == t1_inserted()
  end
end
