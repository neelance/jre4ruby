class Java::Util::ArrayList < Array
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

  def to_a
    self
  end

  def iterator
    Iterator.new self
  end
end
