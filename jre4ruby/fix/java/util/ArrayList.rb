class Java::Util::ArrayList
  def to_a
    array = []
    0.upto(self.size - 1) do |i|
      array << self.get(i)
    end
    array
  end
end
