class HashMap
  include Enumerable

  CAPACITY = 16
  attr_accessor :load_factor, :capacity, :size

  def initialize(init_capacity=CAPACITY, load_factor=0.75)
    @buckets     = Array.new(init_capacity) { []}
    @load_factor = load_factor
    @capacity    = init_capacity
    @size        = 0
  end

  def current_load
    @size.to_f / @capacity 
  end
  
  # Takes a key and produces a hash code with it.
  def hash(key)
    hash_code    = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
    hash_code % @capacity
  end

  # Takes two arguments, key and value. The value is assigned to the key.
  # If the key already exists, the old value is overwritten and key's value 
  # updated with the new value.
  def set(key, value)
    raise ArgumentError, "Hash keys must not be nil." unless key
    
    address = hash(key) 
    bucket  = @buckets[address]
    
    pair = bucket.find { |k, _| k == key}
    if pair
      pair[1] = value
    else
      bucket << [key, value]
      @size += 1
    end
    resize if needs_resizing?
  end
  alias []= set

  # takes one argument as a key and returns the value that is assigned to it.
  def get(key)
    address = hash(key) 
    bucket  = @buckets[address]
    pair    = bucket.find { |k, _| k == key }
    pair&.last
  end
  alias [] get

  # Takes a key as an argument and returns true or false based on whether or not
  # the key is in the  hash map.
  def has?(key)
    address = hash(key) 
    @buckets[address] && !@buckets[address].empty? ? true : false
  end

  # If key exists, removes the entry with the given key and returns the deleted 
  # entry's value.
  # Returns nil if the key isn't in the hash map.
  def remove(key)
    address = hash(key) 
    return nil if @buckets[address].nil? || @buckets[address].empty?
    
    bucket = @buckets[address]
    pair   = bucket.find_index { |k, _| k == key }
    value  = bucket.delete_at(pair)
    @size -= 1
    return value 
  end

  # Returns the number of stored keys in the hash map
  def length
    @size
  end
  
  # Removes all entries from the hash map 
  def clear
    @buckets = Array.new(CAPACITY) { [] }
    @size    = 0
  end

  def values
    values = []
    @buckets.each do |bucket|
      bucket.each do |pair|
        values.push pair[1]
      end
    end
    values
  end
  
  def keys
    keys = []
    @buckets.each do |bucket|
      bucket.each do |pair|
        keys << pair[0]
      end
    end
    keys
  end

  def entries
    entries = []
    @buckets.each do |bucket|
      next if bucket.nil?
      bucket.each { |element| entries << element }
    end
    entries
  end

  private
  def needs_resizing?
    current_load > @load_factor
  end

  def resize
    new_capacity = @capacity * 2
    new_buckets = Array.new(new_capacity) { [] }
    
    # Rehash all entries
    @buckets.each do |bucket|
      bucket.each do |key, value|
        address = hash(key) 
        new_buckets[address] << [key, value]
      end
    end
    @buckets  = new_buckets
    @capacity = new_capacity
  end
  
  def each
    for item in self
      yield item
    end
  end
end