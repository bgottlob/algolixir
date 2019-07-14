defmodule BinSearchTree do
  alias BinTree, as: BT

  # Returns the first occurrence of the value in a node
  @spec search(BT.t(), any()) :: BT.t()
  def search(tree = %BT{}, value) do
    search(Zipper.from_tree(tree), value)
  end

  def search(%Zipper{focused: f}, _value) when f == nil, do: nil
  def search(zipper = %Zipper{}, value) do
    cond do
      value < zipper.focused.value ->
        search(Zipper.left(zipper), value)
      value > zipper.focused.value ->
        search(Zipper.right(zipper), value)
      value == zipper.focused.value ->
        zipper.focused
    end
  end

  # Return the root of the whole tree after the insert
  @spec insert(BT.t() | nil, any) :: BT.t()
  def insert(nil, value), do: %BT{value: value}
  def insert(tree = %BT{}, value) do
    insert(Zipper.from_tree(tree), value) |> Zipper.to_tree()
  end

  def insert(zipper = %Zipper{focused: nil}, value) do
    %Zipper{zipper | focused: %BT{value: value}}
  end
  def insert(zipper = %Zipper{}, value) do
    cond do
      value < zipper.focused.value ->
        insert(Zipper.left(zipper), value)
      value >= zipper.focused.value ->
        insert(Zipper.right(zipper), value)
    end
  end

  @spec from_list_unbalanced([any]) :: BT.t()
  def from_list_unbalanced(list) do
    List.foldl(list, nil, fn(x, tree) -> insert(tree, x) end)
  end
end
