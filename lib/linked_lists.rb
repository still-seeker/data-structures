#  This library represents a data structure where elements(nodes) are added and
#  removed dynamically.
class LinkedList
  include Enumerable
  attr_accessor :head, :size

  # Creates a new linked-list. Takes an optional array argument to initialize the
  # list.
  #
  #     l = LinkedList.new([1, 2, 3])
  #     l.head #=> 1
  #     l.back #=> 3
  def initialize(ary = [])
    @head = nil
    @size = 0

    ary.each { |element| push(element) } unless ary.empty?
  end

  # Adds a new node containing value to the end of the list
  # If the list is empty, the new node is current head
  #     l = LinkedList.new([1, 2, 3])
  #     l.append(5)
  #     l.size #=> 4
  def append(value)
    node = Node.new(value)
    if @head.nil?
      @head = node
    else
      current_element = @head
      current_element = current_element.next_node until current_element.next_node.nil?
      current_element.next_node = node
    end
    @size += 1
  end

  # Adds a new node to the start of the list
  #
  #       l = LinkedList.new([1, 2, 3])
  #       l.prepend(0)
  #       l.size #=> 4
  def prepend(value)
    @head = Node.new(value, @head)
    @size += 1
  end

  # Returns the last node in the list
  def tail
    return unless @head

    node = @head
    node = node.next_node until node.next_node.nil?
    node.value
  end

  # Returns the node at a given index
  #
  #     l = LinkedList.new([1, 2, 3, 4])
  #     l.at(2) #=> 3
  def at(index)
    return nil if index.negative?

    current_element = @head
    current_index = 0

    while current_element && current_index < index
      current_element = current_element.next_node
      current_index += 1
    end
    current_element.value
  end

  # inserts an element at a given index
  def insert_at(value, index)
    new_node = Node.new(value)
    if index.zero?
      new_node.next_node = @head
      @head = new_node
      return
    end
    current_node = @head
    current_index = 0
    while current_index < (index - 1)
      current_node = current_node.next_node
      current_index += 1
    end
    new_node.next_node = current_node.next_node
    current_node.next_node = new_node
    @size += 1
  end

  # Removes a node from a given index
  def remove_at(index)
    # deleting the first node
    if index.zero?
      @head = @head.next_node
      return
    end

    current_index = 0
    current_node = @head
    while current_index < (index - 1)
      current_node = current_node.next_node
      current_index += 1
    end

    node_after_deleted_node = current_node.next_node.next_node
    current_node.next_node = node_after_deleted_node
    @size -= 1
  end

  # Removes the last element from the list and returns it
  def pop
    return nil unless @head

    if @head.next_node.nil?
      value = @head.value
      @head = nil
      return value
    end

    current = @head
    current = current.next_node while current.next_node.next_node
    current.next_node.value
    current.next_node = nil
    @size -= 1
  end

  # Return the index of the node containing value or nil if not found
  def find(value)
    current = @head
    count   = 0
    until current.nil?
      return count if current.value == value

      current = current.next_node
      count += 1
    end
    puts "Value not found" # in case value does not exist
  end

  # Return true if value is in the list, otherwise return false
  def contains(value)
    current = @head
    count   = 0
    until current.nil?
      return true if current.value == value

      current = current.next_node
      count += 1
    end
    false
  end

  # Represents LinkedList objects as strings, so we can print them them out and
  # preview them in the console.
  def to_s
    current = @head
    until current.nil?
      print "( #{current.value} ) -> "
      current = current.next_node
    end
    print "nil\n"
  end

  # Iterate over the list.
  # This implementation is needed for methods in the Enumerable module to use
  def each_list
    return unless @head

    node = @head
    yield node.next_node while @head
  end
  alias each each_list

  # Node class implementation used internally within the library
  class Node
    attr_accessor :value, :next_node

    def initialize(value, next_node = nil)
      @value = value
      @next_node = next_node
    end
  end
end
