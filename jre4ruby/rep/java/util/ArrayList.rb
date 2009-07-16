class Java::Util::ArrayList < Array
  def initialize(initial_capacity = 0)
    raise ArgumentError if not initial_capacity.is_a? Fixnum
  end

  alias_method :add, :<<
  alias_method :get, :[]

  def to_a
    self
  end
end
