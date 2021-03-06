class Java::Io::FileDescriptor
  def initialize
    @use_count = 0
  end

  def increment_and_get_use_count
    @use_count += 1
    @use_count
  end

  def decrement_and_get_use_count
    @use_count -= 1
    @use_count
  end

  In = self.new
  In.instance_eval do
    def io
      $stdin
    end
  end

  Out = self.new
  Out.instance_eval do
    def io
      $stdout
    end
  end

  Err = self.new
  Err.instance_eval do
    def io
      $stderr
    end
  end

  def self.attr_in
    In
  end

  def self.attr_out
    Out
  end

  def self.attr_err
    Err
  end
end
