class Java::Lang::Character
  include Comparable
  include Java::Byte
  include Java::Short
  include Java::Int
  include Java::Long

  Character = self

  class_module.module_eval {
    typesig
    def to_s
      "Java::Lang::Character"
    end
  }

  def initialize(value)
    @value = value
  end

	undef_method :char_value
  def char_value
    @value
  end

  undef_method :to_s
  def to_s
    "" << @value
  end

  def <=>(other)
    self.to_int <=> other.to_int
  end

  @@character_instances = {}
  def self.new(value)
   (@@character_instances[value] ||= super(value))
  end
  
  alias_method :to_i, :char_value
  alias_method :to_int, :char_value
  alias_method :int_value, :char_value
  
  def chr(encoding = nil)
    @value.chr encoding
  end
  
  def is_a?(type)
    type == Numeric || super
  end
  
  def ==(other)
    other.is_a?(Numeric) && @value == other.to_int
  end
  
  alias_method :equal?, :==
  
  def coerce(other)
    return other, @value
  end
  
  def +(other)
    Character.new(@value + other.to_int)
  end
  
  def -(other)
    Character.new(@value - other.to_int)
  end
  
  def *(other)
    Character.new(@value * other.to_int)
  end
  
  def /(other)
    Character.new(@value / other.to_int)
  end
  
  def &(other)
    Character.new(@value & other.to_int)
  end
  
  def |(other)
    Character.new(@value | other.to_int)
  end
  
  def <<(other)
    Character.new(@value << other.to_int)
  end
  
  def >>(other)
    Character.new(@value >> other.to_int)
  end
end
