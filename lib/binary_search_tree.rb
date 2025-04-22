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
      self.data <=> other.data
    end   
  end

  # A Tree class to implement the Binanary search tree operations.
  class Tree 
    attr_accessor :root

    # Takes an array when initialized
    def initialize(array)
      @array = array
      @root = build_tree(array)
    end

    # Constructs a binary search tree from an ordered tree
    def build_tree(array)
      recursive_build(array, 0, array.size-1)
    end

    # A visualizer of a binary search tree.
    def pretty_print(node=@root, prefix = '', is_left=true)
      pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
      puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
      pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end

    def preorder(root)
      return if root.nil?
      print root.data + " "
      preorder root.left
      preorder root.rights
    end

    private
    
    # Recursive function to construct the BST
    def recursive_build(arr, start, _end)
      return nil if start > _end

      mid        = start + (_end - start) / 2
      root       = Node.new(arr[mid]) # creates a root node
      root.left  = recursive_build(arr, start, mid-1) # left child
      root.right = recursive_build(arr, mid+1, _end)  # right child
      root
    end
  end
end

bst = BinarySearchTree::Tree.new([1, 7, 4, 23, 8, 9, 67, 6345, 324])
p bst.pretty_print