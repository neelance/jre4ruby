class Java::Util::Stack < Array
  def initialize
  end

  alias_method :add, :<<
  alias_method :add_element, :<<
  alias_method :get, :[]
  alias_method :element_at, :[]
  alias_method :remove, :delete_at
  alias_method :remove_element_at, :delete_at
  alias_method :peek, :last

  def to_a
    self
  end
end
