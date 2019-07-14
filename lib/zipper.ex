defmodule BinTree do
  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """

  @type t :: %BinTree{value: any, left: t() | nil, right: t() | nil}

  defstruct [:value, :left, :right]
end

defimpl Inspect, for: BinTree do
  import Inspect.Algebra

  # A custom inspect instance purely for the tests, this makes error messages
  # much more readable.
  #
  # BinTree[value: 3, left: BinTree[value: 5, right: BinTree[value: 6]]] becomes (3:(5::(6::)):)
  def inspect(%BinTree{value: value, left: left, right: right}, opts) do
    concat([
      "(",
      to_doc(value, opts),
      ":",
      if(left, do: to_doc(left, opts), else: ""),
      ":",
      if(right, do: to_doc(right, opts), else: ""),
      ")"
    ])
  end
end

defmodule Zipper do
  @type t :: %Zipper{focused: BinTree.t(), path: [{:left | :right, BinTree.t()}]}

  defstruct [:focused, :path]

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree) do
    %Zipper{focused: bin_tree, path: []}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(zipper) do
    case up(zipper) do
      nil -> zipper.focused # Already at the root
      up_zipper -> to_tree(up_zipper)
    end
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(zipper) do
    zipper.focused.value
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t()
  def left(zipper) do
    %Zipper{
      focused: zipper.focused.left,
      path: [{:left, zipper.focused} | zipper.path]
    }
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t()
  def right(zipper) do
    %Zipper{
      focused: zipper.focused.right,
      path: [{:right, zipper.focused} | zipper.path]
    }
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(zipper) do
    case zipper.path do
      [] -> nil
      path ->
        {direction, parent} = List.first(path)
        # commit any updates - they are not needed until moving back up the tree
        parent = Map.put(parent, direction, zipper.focused)
        %Zipper{
          focused: parent,
          path: Enum.drop(path, 1)
        }
    end
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(zipper, value) do
    %Zipper{zipper | focused: %BinTree{zipper.focused | value: value}}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(zipper, left) do
    %Zipper{zipper | focused: %BinTree{zipper.focused | left: left}}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(zipper, right) do
    %Zipper{zipper | focused: %BinTree{zipper.focused | right: right}}
  end

  @spec in_order_traversal(Zipper.t()) :: Zipper.t()
  def in_order_traversal(zipper) do
    in_order_traversal(zipper, [])
  end

  #defp in_order_traversal(%Zipper{focused: nil}, path), do: List.flatten(path)
  #defp in_order_traversal(zipper, path) do
  #  path = [in_order_traversal(left(zipper), path) | path]
  #  path = [zipper.focused.value | path]
  #  path = [in_order_traversal(right(zipper), path) | path]
  #end
end
