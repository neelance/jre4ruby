class Java::Lang::Throwable
  def fill_in_stack_trace
    @stack_trace = caller
  end

  def backtrace
    super
  end
end
