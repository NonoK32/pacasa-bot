require 'matrix'
require_relative 'my_file'
require_relative 'my_pair'
#
# Coded by Robin Costas del Moral
#
# This class is only meant to use with my bots, therefore its functionality 
# is to manage them, so it is quite limited/useless outside its purpose
#
# This class manages a map stored in a file using my_file.rb.
# The file will be structured in pair of lines, first one is the key, 
# second one is the value
#  

class MyMap
  attr_reader :keys
  # db: file in which we will store everything
  # keys: array of keys of the map
  # values: array of values of the map
  # NOTE: The index on either array is the same for a pair key/value
  def initialize(file)
    @db     = nil
    @keys   = Array.new
    @values = Array.new

    if(!@db.nil?)
      x = 0
      while x < @db.content.size
        @keys   << @db.get_item(x)

        @values[x/2] = Array.new
        @values[x/2] << @db.get_item(x+1)
        
        x+=2
      end
    end
  end

  # adds a pair of key/value
  def add_item(key, value)
    @keys << key
    @values[@keys.size-1] = Array.new
    @values[@keys.size-1] << value
  end

  # return: pair with key/value(s) of that index
  def get_item(index)
    pair = MyPair.new
    pair.first = @keys[index]
    pair.second = @values[index]

    return pair
  end

  # removes item at index position in arrays
  def remove_item(index)
    @keys.delete_at(index)
    @values.delete_at(index)
  end

  # return: values associated with key
  def get_values(key)
    index = find(key)
    return @values[index]
  end

  # adds a given value to the list of values of key
  def add_value(key, value)
    index = find(key)
    @values[index] << value
  end

  # removes a given value from the list of values of key, 
  # if the list becomes empty, deletes key too
  def remove_value(key, value)
    index = find(key)
    @values.remove(value)

    if(@keys[index].empty?)
      @keys.delete_at(index)
      @values.delete_at(index)
    end
  end


  def empty
    return @keys.empty?
  end


  def size
    return @keys.size
  end

  # Finds if a key is in the keys array or not
  # return: -1 if not found, index of key in array if found
  def find(key)
    i=0
    while i < @keys.size
      if(@keys[i]==key)
        return i
      end
      i+=1
    end
    return -1
  end

  # Writes the changes made to db file
  def write_to_db
    text = Array.new

    i=0
    while i<@keys.size
      text << @keys[i]

      tmp = ""
      for val in @values[i]
        tmp += "#{val},"
      end
      tmp += ";"
      text << tmp

      i+=1
    end

    @db.content = text
    @db.write_to_file
  end

end