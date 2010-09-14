class Java::Lang::JavaThread
  attr_accessor :ruby_thread

  class_module.module_eval {
    def self.init_thread_mappings
      main_thread = JavaThread.allocate
      main_thread.attr_group = JavaThreadGroup.new
      main_thread.attr_priority = 5
      main_thread.attr_daemon = false
      main_thread.ruby_thread = Thread.current
      @@thread_mappings = { Thread.current => main_thread }
    end
    
    when_class_loaded do
      init_thread_mappings
    end

    def register_natives
    end

    def current_thread
      @@thread_mappings[Thread.current]
    end

    def sleep(millis)
      Kernel.sleep millis / 1000
    end
  }

  def set_priority(priority)
    @priority = priority
  end

  def is_alive
    defined?(@ruby_thread) && @ruby_thread.alive?
  end

  def start
    Thread.new {
      Thread.current.abort_on_exception = true
      @@thread_mappings[Thread.current] = self
      run
    }
  end
end
