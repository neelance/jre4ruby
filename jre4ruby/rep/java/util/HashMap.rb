class Java::Util::HashMap < Hash
  overload_protected {
    include Java::Util::Map
  }

  def initialize(data = nil)
    case data
    when nil
      # do nothing
    when Hash
      self.merge! data
    when Integer
      # initial capacity, ignored
    else
      raise ArgumentError
    end
  end

  alias_method :put, :[]=
  alias_method :get, :[]
  alias_method :remove, :delete
  alias_method :contains, :has_value?
  alias_method :contains_key, :has_key?
  alias_method :contains_value, :has_value?
  alias_method :is_empty, :empty?

  alias_method :array_values, :values
  def values
    ArrayList.new array_values
  end

  def key_set
    ArrayList.new keys
  end
  
  def entry_set
    ArrayList.new values
  end
end
