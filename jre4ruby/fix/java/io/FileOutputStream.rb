class Java::Io::FileOutputStream
  class_module.module_eval {
    def init_ids
    end
  }

  def write_bytes(b, off, len)
    @fd.io.write String.new(b, off, len)
  end
end
