class Java::Util::HashMap < Hash
  def initialize(data = nil)
    if data
      self.merge! data
    end
  end

  alias_method :put, :[]=
  alias_method :get, :[]
end
