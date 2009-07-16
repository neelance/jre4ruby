class Java::Util::Hashtable < Hash
  def initialize(data = nil)
    if data
      self.merge! data
    end
  end

  alias_method :put, :[]=
  alias_method :get, :[]
  alias_method :remove, :delete
end
