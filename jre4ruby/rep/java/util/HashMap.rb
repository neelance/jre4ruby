class Java::Util::HashMap < Hash
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
  alias_method :contains_key, :has_key?
end
