class Sun::Misc::Unsafe
  class_module.module_eval {
    def register_natives
    end
  }

  def object_field_offset(f)
    "@#{f.attr_name}".to_sym
  end

  def compare_and_swap_object(o, offset, expected, x)
    o.instance_variable_get(offset) == expected and o.instance_variable_set(offset, x) and true
  end

  alias_method :compare_and_swap_int, :compare_and_swap_object

  def ensure_class_initialized(c)
  end
end
