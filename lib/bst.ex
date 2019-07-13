defmodule BST do
  @spec search(BinTree.t(), any()) :: BinTree.t()
  def search(tree = %BinTree{}, value) do
    search(Zipper.from_tree(tree), value)
  end

  def search(nil, _value), do: nil
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
end
