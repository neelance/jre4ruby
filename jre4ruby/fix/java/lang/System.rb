class Java::Lang::System
  class_module.module_eval {
    when_class_loaded do
      initialize_system_class
    end

    def arraycopy(src, src_pos, dest, dest_pos, length)
			if src.is_a? CharArray and dest.is_a? CharArray
				dest.data[dest_pos, length] = src.data[src_pos, length]
			else
	      dest[dest_pos, length] = src[src_pos, length]
      end
    end

    def register_natives
    end

    def current_time_millis
      (Time.new.to_f * 1000).to_i
    end

    def init_properties(props)
      # TODO set guaranteed properties:
      # * <dt>java.version         <dd>Java version number
      # * <dt>java.vendor          <dd>Java vendor specific string
      # * <dt>java.vendor.url      <dd>Java vendor URL
      # * <dt>java.home            <dd>Java installation directory
      # * <dt>java.class.version   <dd>Java class version number
      # * <dt>java.class.path      <dd>Java classpath
      # * <dt>os.name              <dd>Operating System Name
      # * <dt>os.arch              <dd>Operating System Architecture
      # * <dt>os.version           <dd>Operating System Version
      # * <dt>file.separator       <dd>File separator ("/" on Unix)
      # * <dt>path.separator       <dd>Path separator (":" on Unix)
      # * <dt>line.separator       <dd>Line separator ("\n" on Unix)
      # * <dt>user.name            <dd>User account name
      # * <dt>user.home            <dd>User home directory
      # * <dt>user.dir             <dd>User's current working directory
      set_property "os.name", RUBY_PLATFORM.split("-").last
      set_property "file.separator", File::SEPARATOR
      set_property "path.separator", File::PATH_SEPARATOR
      set_property "line.separator", "\n"
      set_property "file.encoding", "UTF-8"
    end

    def set_in0(in_)
      @@in = in_
    end

    def set_out0(out)
      @@out = out
    end

    def set_err0(err)
      @@err = err
    end

    def map_library_name(libname)
      case RUBY_PLATFORM
	  when "i386-mingw32"
        "#{libname}.dll"
      when "i686-darwin9"
	    "lib#{libname}.jnilib"
      else
        "lib#{libname}.so"
      end
    end
  }
end
