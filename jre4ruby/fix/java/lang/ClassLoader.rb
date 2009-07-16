class Java::Lang::ClassLoader
  class_module.module_eval {
    def register_natives
    end

    NativeLibrary.class_eval do
      def load(name)
        unless name == "/libzip.so" or name == "/zip.dll" or name == "/libzip.jnilib"
          JNI.load_library name
        end
        @handle = 1
      end
    end
  }
end
