class Java::Util::Hashtable < Hash
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
end
