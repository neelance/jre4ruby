class Java::Lang::JavaThread
  class_module.module_eval {
    when_class_loaded do
      main_thread = JavaThread.allocate
      main_thread.attr_group = JavaThreadGroup.new
      @@thread_mappings = { Thread.current => main_thread }
    end

    def register_natives
    end

    def current_thread
      @@thread_mappings[Thread.current]
    end
  }
end
