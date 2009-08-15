class Java::Util::Vector < Array
  def initialize(initial_capacity = 0)
    raise ArgumentError if not initial_capacity.is_a? Fixnum
  end

  alias_method :add, :<<
  alias_method :add_element, :<<
  alias_method :get, :[]
  alias_method :element_at, :[]
  alias_method :remove, :delete_at
  alias_method :remove_element_at, :delete_at
  alias_method :contains, :include?

  def to_a
    self
  end

  def copy_into(array)
    array[0, self.size] = self
  end
end
