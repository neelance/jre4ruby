class Java::Util::ArrayList < Array
  overload_protected {
    include Java::Util::JavaList
  }

  class Iterator
    def initialize(array)
      @array = array
      @index = 0
    end

    def has_next
      @index < @array.size
    end

    def next_
      entry = @array[@index]
      @index += 1
      entry
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

  def remove(o)
    if o.is_a? Integer
      delete_at o
    else
      delete o
    end
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
end
