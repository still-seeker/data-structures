module BinarySearchTree
  # A node class to help keep track of data
  class Node
    include Comparable

    attr_accessor :data, :left, :right

    def initialize(data)
      @data  = data
      @left  = nil
      @right = nil
    end

    # We compare the nodes using their data attribute.
    def <=>(other)
      data <=> other.data
    end
  end

  # A Tree class to implement the Binary search tree operations.
  class Tree
    attr_accessor :root

    # Takes an array when initialized
    def initialize(array)
      @root = build_tree(array)
    end

    # Constructs a binary search tree from an ordered tree
    def build_tree(array)
      array = array.dup.sort.uniq
      recursive_build(array, 0, array.size - 1)
    end

    # A visualizer of a binary search tree.
    def pretty_print(node = @root, prefix = "", is_left = true)
      pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
      puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
      pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end

    # Accepts a value to insert
    def insert(value, node = @root)
      return Node.new(value) if node.nil?

      if value < node.data
        node.left = insert(value, node.left)
      elsif value > node.data
        node.right = insert(value, node.right)
      end
      node
    end

    # Accepts a value to delete
    def delete(value, current_root = @root) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      if current_root.nil?
        current_root
      elsif value < current_root.data
        current_root.left = delete(value, current_root.left)
        current_root
      elsif value > current_root.data
        current_root.right = delete(value, current_root.right)
        current_root
      elsif value == current_root.data
        if current_root.left.nil?
          current_root.right
        elsif current_root.right.nil?
          current_root.left
        else
          current_root.right = check_successor(current_root, current_root.right)
          current_root
        end
      end
    end

    # Changes the current node's value to the value of its successor
    def check_successor(node_to_delete, node = @root)
      if node.left
        node.left = check_successor(node_to_delete, node.left)
        node
      else
        node_to_delete.data = node.data
        node.right
      end
    end

    # Accepts a value and returns the node with the given value
    def find(value, node = @root)
      return nil if node.nil?

      if value == node.data
        node.data
      elsif value < node.data
        find(value, node.left)
      elsif value > node.data
        find(value, node.right)
      end
    end

    def level_order
      queue = []
      result = []
      queue << @root

      until queue.empty?
        current_node = queue.shift
        result << current_node.data

        queue << current_node.left unless current_node.left.nil?
        queue << current_node.right unless current_node.right.nil?
      end
      result
    end

    def preorder(node = @root, result = [])
      return result if node.nil?

      result << node.data
      preorder(node.left, result)
      preorder(node.right, result)
    end

    def inorder(node = @root, result = [])
      return result if node.nil?

      inorder(node.left, result)
      result << node.data
      inorder(node.right, result)
      result
    end

    def postorder(node = @root, result = [])
      return result unless node

      postorder(node.left, result)
      postorder(node.right, result)
      result << node.data
      result
    end

    def depth(value, node = @root, current_depth = 0)
      return nil if node.nil?

      if value == node.data
        current_depth
      elsif value < node.data
        depth(value, node.left, current_depth + 1)
      else
        depth(value, node.right, current_depth + 1)
      end
    end

    def height(node = @root) # rubocop:disable Metrics/MethodLength
      if node.nil?
        -1
      else
        right_height = height(node.right)
        left_height  = height(node.left)

        if left_height > right_height
          left_height + 1
        else
          right_height + 1
        end
      end
    end

    # Checks whether the tree is balanced
    def balanced?(current_root = @root)
      left_sub_tree = current_root.left
      right_sub_tree = current_root.right

      if height(left_sub_tree) >= height(right_sub_tree) + 2
        false
      elsif height(left_sub_tree) <= height(right_sub_tree) + 1 || height(left_sub_tree) + 1 >= height(right_sub_tree)
        true
      end
    end

    # Rebalances the tree in case it is not balanced
    def rebalance(*)
      @root = build_tree(inorder)
      pretty_print
    end

    private

    # Recursive function to construct the BST
    def recursive_build(arr, start, _end)
      return nil if start > _end

      mid        = start + ((_end - start) / 2)
      root       = Node.new(arr[mid]) # creates a root node
      root.left  = recursive_build(arr, start, mid - 1) # left child
      root.right = recursive_build(arr, mid + 1, _end)  # right child
      root
    end
  end
end

arr = [1, 7, 4, 23, 8, 9, 67, 6345, 324, 5, 34, 93, 200]
bst = BinarySearchTree::Tree.new(arr)
p bst.pretty_print
p bst.delete(6345)
p bst.pretty_print
