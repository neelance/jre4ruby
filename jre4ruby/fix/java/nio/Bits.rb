class Java::Nio::Bits
  class_module.module_eval {
    Module.class_loaded_hooks.delete_at 0

    def byte_order
      ByteOrder::BIG_ENDIAN
    end
  }
end
