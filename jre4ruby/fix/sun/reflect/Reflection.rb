class Sun::Reflect::Reflection
  class_module.module_eval {
    def get_caller_class(real_frames_to_skip)
      Object
    end

    def get_class_access_flags(c)
      Modifier::PUBLIC
    end
  }
end
