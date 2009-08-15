class Java::Lang::ClassLoader
  class_module.module_eval {
    def register_natives
    end

    NativeLibrary.class_eval do
      def load(name)
        JNI.load_library name
        @handle = 1
      end
    end
  }

  def find_loaded_class0(name)
    Class.for_name name
  end
end
