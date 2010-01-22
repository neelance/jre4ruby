class Java::Util::ArrayList < Array
  overload_protected {
    include Java::Util::JavaList
  }

  class Iterator
    def initialize(array, from_index = 0, to_index = nil)
      @array = array
      @index = from_index
      @to_index = to_index || @array.size
    end

    def has_next
      @index < @to_index
    end

    def next_
      entry = @array[@index]
      @index += 1
      entry
    end

    def remove
      @index -= 1
      @to_index -= 1
      @array.delete_at @index
    end
  end

  class SubList
    def initialize(parent_list, from_index, to_index)
      @parent_list = parent_list
      @from_index = from_index
      @to_index = to_index
    end

    def size
      @to_index - @from_index
    end

    def iterator
      Iterator.new @parent_list, @from_index, @to_index
    end
  end

  def initialize(data = nil)
    case data
    when nil
      # do nothing
    when Array
      self.concat data
    when Integer
      # initial capacity, ignored
    else
      raise ArgumentError
    end
  end

  alias_method :add, :<<
  alias_method :get, :[]
  alias_method :contains, :include?
  alias_method :is_empty, :empty?

  def add(a1, a2 = nil)
    if a2
      self.insert a1, a2
    else
      self << a1
    end
  end

  def remove(o)
    if o.is_a? Integer
      delete_at o
    else
      delete o
    end
  end

  def index_of(e)
    index(e) || -1
  end

  def to_a
    self
  end

  def to_array(target_array = nil)
    target_array ||= Array.typed(Object).new
    if target_array.size <= self.size
      target_array.replace self
    else
      target_array[0, self.size] = self
      target_array[self.size] = nil
    end
    target_array
  end

  def iterator
    Iterator.new self
  end

  def sub_list(from_index, to_index)
    SubList.new self, from_index, to_index
  end

  def remove_all(list)
    delete_if { |item| list.include? item }
  end
end
