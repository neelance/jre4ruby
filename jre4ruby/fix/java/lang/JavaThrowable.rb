class Exception
  alias_method :ruby_backtrace, :backtrace
end

class Java::Lang::JavaThrowable
  def fill_in_stack_trace
    @stack_trace = caller
  end

  def backtrace
    ruby_backtrace
  end
end
