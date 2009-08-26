require "rjava"

# Copyright 1995-2006 Sun Microsystems, Inc.  All Rights Reserved.
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
# 
# This code is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 only, as
# published by the Free Software Foundation.  Sun designates this
# particular file as subject to the "Classpath" exception as provided
# by Sun in the LICENSE file that accompanied this code.
# 
# This code is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# version 2 for more details (a copy is included in the LICENSE file that
# accompanied this code).
# 
# You should have received a copy of the GNU General Public License version
# 2 along with this work; if not, write to the Free Software Foundation,
# Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
# 
# Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
# CA 95054 USA or visit www.sun.com if you need additional information or
# have any questions.
module Java::Lang
  module CompilerImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # The {@code Compiler} class is provided to support Java-to-native-code
  # compilers and related services. By design, the {@code Compiler} class does
  # nothing; it serves as a placeholder for a JIT compiler implementation.
  # 
  # <p> When the Java Virtual Machine first starts, it determines if the system
  # property {@code java.compiler} exists. (System properties are accessible
  # through {@link System#getProperty(String)} and {@link
  # System#getProperty(String, String)}.  If so, it is assumed to be the name of
  # a library (with a platform-dependent exact location and type); {@link
  # System#loadLibrary} is called to load that library. If this loading
  # succeeds, the function named {@code java_lang_Compiler_start()} in that
  # library is called.
  # 
  # <p> If no compiler is available, these methods do nothing.
  # 
  # @author  Frank Yellin
  # @since   JDK1.0
  class Compiler 
    include_class_members CompilerImports
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_lang_Compiler_initialize, [:pointer, :long], :void
      typesig { [] }
      # don't make instances
      def initialize_
        JNI.__send__(:Java_java_lang_Compiler_initialize, JNI.env, self.jni_id)
      end
      
      JNI.native_method :Java_java_lang_Compiler_registerNatives, [:pointer, :long], :void
      typesig { [] }
      def register_natives
        JNI.__send__(:Java_java_lang_Compiler_registerNatives, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        register_natives
        Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
          extend LocalClass
          include_class_members Compiler
          include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            loaded = false
            jit = System.get_property("java.compiler")
            if ((!(jit).nil?) && (!(jit == "NONE")) && (!(jit == "")))
              begin
                System.load_library(jit)
                initialize_
                loaded = true
              rescue self.class::UnsatisfiedLinkError => e
                System.err.println("Warning: JIT compiler \"" + jit + "\" not found. Will use interpreter.")
              end
            end
            info = System.get_property("java.vm.info")
            if (loaded)
              System.set_property("java.vm.info", info + ", " + jit)
            else
              System.set_property("java.vm.info", info + ", nojit")
            end
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      JNI.native_method :Java_java_lang_Compiler_compileClass, [:pointer, :long, :long], :int8
      typesig { [Class] }
      # Compiles the specified class.
      # 
      # @param  clazz
      # A class
      # 
      # @return  {@code true} if the compilation succeeded; {@code false} if the
      # compilation failed or no compiler is available
      # 
      # @throws  NullPointerException
      # If {@code clazz} is {@code null}
      def compile_class(clazz)
        JNI.__send__(:Java_java_lang_Compiler_compileClass, JNI.env, self.jni_id, clazz.jni_id) != 0
      end
      
      JNI.native_method :Java_java_lang_Compiler_compileClasses, [:pointer, :long, :long], :int8
      typesig { [String] }
      # Compiles all classes whose name matches the specified string.
      # 
      # @param  string
      # The name of the classes to compile
      # 
      # @return  {@code true} if the compilation succeeded; {@code false} if the
      # compilation failed or no compiler is available
      # 
      # @throws  NullPointerException
      # If {@code string} is {@code null}
      def compile_classes(string)
        JNI.__send__(:Java_java_lang_Compiler_compileClasses, JNI.env, self.jni_id, string.jni_id) != 0
      end
      
      JNI.native_method :Java_java_lang_Compiler_command, [:pointer, :long, :long], :long
      typesig { [Object] }
      # Examines the argument type and its fields and perform some documented
      # operation.  No specific operations are required.
      # 
      # @param  any
      # An argument
      # 
      # @return  A compiler-specific value, or {@code null} if no compiler is
      # available
      # 
      # @throws  NullPointerException
      # If {@code any} is {@code null}
      def command(any)
        JNI.__send__(:Java_java_lang_Compiler_command, JNI.env, self.jni_id, any.jni_id)
      end
      
      JNI.native_method :Java_java_lang_Compiler_enable, [:pointer, :long], :void
      typesig { [] }
      # Cause the Compiler to resume operation.
      def enable
        JNI.__send__(:Java_java_lang_Compiler_enable, JNI.env, self.jni_id)
      end
      
      JNI.native_method :Java_java_lang_Compiler_disable, [:pointer, :long], :void
      typesig { [] }
      # Cause the Compiler to cease operation.
      def disable
        JNI.__send__(:Java_java_lang_Compiler_disable, JNI.env, self.jni_id)
      end
    }
    
    private
    alias_method :initialize__compiler, :initialize
  end
  
end
