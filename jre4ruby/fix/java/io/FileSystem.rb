class Java::Io::FileSystem
  class_module.module_eval {
    def get_file_system
      new
    end
  }

  def get_separator
    Character.new File::SEPARATOR.ord
  end

  def get_path_separator
    Character.new File::PATH_SEPARATOR.ord
  end

  def get_default_parent
    "" # TODO FileSystem.get_default_parent
  end
    
  def normalize(path)
    path # TODO FileSystem.normalize
  end

  def resolve(file, child = nil) # TODO FileSystem.resolve
    if child == nil
      file.attr_path
    else
      File.join file, child
    end
  end
    
  def canonicalize(path)
    File.expand_path path
  end

  def prefix_length(path)
    0 # TODO FileSystem.prefix_length
  end

  def get_boolean_attributes(f)
    (File.exist?(f.attr_path) ? BA_EXISTS : 0) | (File.file?(f.attr_path) ? BA_REGULAR : 0) | (File.directory?(f.attr_path) ? BA_DIRECTORY : 0)
  end

  def check_access(f, access)
    case access
    when ACCESS_READ
			File.readable?(f.attr_path)
    when ACCESS_WRITE
			File.writable?(f.attr_path)
    when ACCESS_EXECUTE
			File.executable?(f.attr_path)
    else
      raise ArgumentError
    end
  end

  def get_length(f)
    File.size f.attr_path
  end

  def is_absolute(f)
    f.attr_path =~ /^(\w:)?[\/\\]/
  end
end
