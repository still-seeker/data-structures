#  This library represents a data structure where elements(nodes) are added and
#  removed dynamically.
class LinkedList
  include Enumerable

  # Creates a new linked-list. Takes an optional array argument to initialize the
  # list.
  # 
  #     l = LinkedList.new([1, 2, 3])
  #     l.head #=> 1
  #     l.back #=> 3
  def initialize(ary=[])
    @head = nil
    @tail = nil
    @size = 0

    ary.each { |element| push(element) } unless ary.empty?
  end

  # Adds a new node containing value to the end of the list
  #     l = LinkedList.new([1, 2, 3])
  #     l.append(5)
  #     l.size #=> 4
  def append(value)
    node = Node.new(value)
    if @tail
      @tail.next_node = node
      @tail = node
    else
      @head = @tail = node
    end
    @size += 1
  end

  # Adds a new node to the start of the list
  # 
  #       l = LinkedList.new([1, 2, 3])
  #       l.prepend(0)
  #       l.size #=> 4
  def prepend(value)
    node = Node.new(value)
    if @head
      node.next_node = @head
      @head = node
    else
      @head = @tail = node
    end
    @size += 1
  end

  # Returns the total number of nodes in the list
  #
  #     l = LinkedList.new([4, 5])
  #     l.size #=> 2
  def size
    @size
  end
  
  # Returns the first node in the list
  def head
    @head
  end

  # Returns the last node in the list
  def tail
    nil
  end

  # Returns the node at a given index
  # 
  #     l = LinkedList.new([1, 2, 3, 4])
  #     l.at(2) #=> 3
  def at(index)
    return nil if index < 0
    current_element = @head
    current_index = 0

    while current_element && current_index < index
      current = current.next_node
      current_index += 1
    end
    current_element
  end

  # Removes the last element from the list and returns it
  # 
  #      l = LinkedList.new([1, 2, 3, 5])
  #      l.pop #=> 5
  def pop
    return nil unless @head
    node = @head
    if @size == 1  # clear the list and return the value
      @head = nil
      @tail = nil
      @size = 0
      return node.value
    else 
      @tail.value = nil
      @tail = @tail.next_node
    end
    @size -= 1
    node.value
  end

  # Return the index of the node containing value or nil if not found
  def find(value)
    current = @head
    count   = 0
    while current != nil
      return count if current.value == value
      current = current.next_node
      count += 1
    end
    nil
  end

  # Return true if value is in the list, otherwise return false

  # Represents LinkedList objects as strings, so we can print them them out and
  # preview them in the console.
  def to_s
    nodes = []
    current_element = @head
    while current_element != nil
      nodes << current_element.value
      current_element = current_element.next_node
    end
    nodes.join(" -> ")
    nodes << "nil"  # nil represents the end of the list
  end

  # Iterate over the list.
  # This implementation is needed for methods in the Enumerable module to use
  def each_list
    return unless @head
    node = @head
    while @head
      yield node.next_node
    end
  end
  alias each each_list

  # Node class implementation used internally within the library
  class Node
    attr_accessor :value, :next_node

    def initialize(value=nil)
      @value = value
      @next_node = nil
    end
  end
end
