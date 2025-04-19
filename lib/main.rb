require_relative './linked_lists.rb'

list = LinkedList.new

list.append('dogs')
list.append('cat')
list.append('parrot')
list.append('hamster')
list.append('snake')
list.append('turtle')

puts list #=> ( dogs ) -> ( cat ) -> ( parrot ) -> ( hamster ) -> ( snake ) -> ( turtle ) -> nil

