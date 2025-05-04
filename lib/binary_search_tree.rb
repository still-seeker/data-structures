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
      return current_root if current_root.nil?

      if value < current_root.data
        current_root.left = delete(value, current_root.left)
      elsif value > current_root.data
        current_root.right = delete(value, current_root.right)
      else
        return current_root.right if current_root.left.nil?
        return current_root.left if current_root.right.nil?

        successor = check_successor(current_root)
        current_root.data = successor.data
        current_root.right = delete(successor.data, current_root.right)
      end
    end

    # Changes the current node's value to the value of its successor
    def check_successor(node_to_delete = @root)
      node_to_delete = node_to_delete.right

      node_to_delete = node_to_delete.left while !node_to_delete.nil? && !node_to_delete.left.nil?
      node_to_delete
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
      queue << @root

      until queue.empty?
        current_node = queue.shift
        print "#{current_node.data}, "

        queue << current_node.left unless current_node.left.nil?
        queue << current_node.right unless current_node.right.nil?
      end
    end

    def preorder(node = @root)
      return if node.nil?

      print "#{node.data}, "
      preorder node.left
      preorder node.right
    end

    def inorder(node = @root)
      return unless node

      inorder(node.left)
      print "#{node.data}, "
      inorder(node.right)
    end

    def postorder(node = @root)
      return unless node

      postorder(node.left)
      postorder(node.right)
      print "#{node.data}, "
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

    def height(node = @root)
      if node.nil?
        0
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

    # helper method for calculating height
    def calculate_height(node = @root)
      return -1 if node.nil?

      left_height = calculate_height(node.left)
      right_height = calculate_height(node.right)

      [left_height, right_height].max + 1
    end
  end
end

arr = [1, 7, 4, 23, 8, 9, 67, 6345, 324]
bst = BinarySearchTree::Tree.new(arr)
# bst.insert(100)

p bst.level_order
p bst.delete(9)
p bst.level_order
