class Java::Io::FileInputStream
  class_module.module_eval {
    def init_ids
    end
  }

  def open(filename)
    @file_handle = File.open filename
  end

  def close0
    @file_handle.close
  end

  def read_bytes(b, off, len)
    return -1 if @file_handle.eof?
    data = @file_handle.read(len).bytes.to_a
    b[off, len] = data
    data.size
  end

  def available
    @file_handle.count - @file_handle.pos
  end
end
