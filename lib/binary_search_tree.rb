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
      @root = build_tree(array)
    end

    # Constructs a binary search tree from an ordered tree
    def build_tree(array)
      arr = array.dup.sort.uniq
      recursive_build(arr, 0, arr.size-1)
    end

    # A visualizer of a binary search tree.
    def pretty_print(node=@root, prefix = '', is_left=true)
      pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
      puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
      pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end

    # Accepts a value to insert
    def insert(value)
      @root = insert_recursive(@root, value)
    end

    # Accepts a value to delete
    def delete(value)
      @root = delete_recursive(@root, value)
    end

    def preorder(root)
      return if root.nil?
      print root.data + " "
      preorder root.left
      preorder root.rights
    end

    def inorder(root)
      if root
        inorder(root.left)
        print root.data + " "
        inorder(root.right)
      end
    end

    def postorder(root)
      if root
        postorder(root.left)
        postorder(root.right)
        print root.data + " "
      end
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

    # A recursive insertion helper method
    def insert_recursive(node, value)
      return Node.new(value) if node.nil?

      if value < node.data
        node.left = insert_recursive(node.left, value)
      elsif value > node.data
        node.right = insert_recursive(node.right, value)
      end
      node
    end

    # A recursive delete helper method
    def delete_recursive(value_to_delete, node)
      if node.nil?
        return nil
      elsif value_to_delete < node.data  # Recursively calling delete method on left subtree
        node.left = delete_recursive(value_to_delete, node.left)
        node
      elsif value_to_delete > node.data # Recursively calling delete method on right subtree
        node.right = delete_recursive(value_to_delete, node.right)
        node
      elsif value_to_delete == node.data # if the current node is the one we want to delete
        if node.left.nil?  # node has one right child, return it
          return node.right
        elsif node.right.nil? # node has one left child, return it
          return node.left
        else # current node has two children, use lift helper method to handle reconstruction logic
          node.right = lift(node.right, node)
          node
        end
      end
    end

    # Changes the current node's value to the value of its successor
    # This method handles logic where the current node has two children that have to be 
    # reconstructed after their parent has been deleted.
    def lift(node, node_to_delete)
      if node.left  # Recursively call this method to continue down to left sub tree to fid successor
        node.left = lift(node.left, node_to_delete)
        node
      else # current node has no left node, current node of this method is successor node
        node_to_delete = node.data
        node.right
      end
    end
  end
end

bst = BinarySearchTree::Tree.new([1, 7, 4, 23, 8, 9, 67, 6345, 324])
p bst.pretty_print