class Sun::Misc::Unsafe
  class_module.module_eval {
    def register_natives
    end
  }

  def object_field_offset(f)
    "@#{f.name}".to_sym
  end

  def compare_and_swap_int(o, offset, expected, x)
    o.instance_variable_get(offset) == expected and o.instance_variable_set(offset, x) and true
  end

  def ensure_class_initialized(c)
  end
end
