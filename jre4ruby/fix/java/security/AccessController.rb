class Java::Security::AccessController
  class_module.module_eval {
    def do_privileged(action, arg1 = nil)
      action.run
    end

    def get_stack_access_control_context
      nil
    end

    def get_inherited_access_control_context
      nil
    end
  }
end
