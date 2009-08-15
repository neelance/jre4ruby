class Java::Util::Stack < Array
  def initialize
  end

  alias_method :add, :<<
  alias_method :add_element, :<<
  alias_method :element_at, :[]
  alias_method :empty, :empty?
  alias_method :get, :[]
  alias_method :peek, :last
  alias_method :remove, :delete_at
  alias_method :remove_element_at, :delete_at

  def to_a
    self
  end
end
