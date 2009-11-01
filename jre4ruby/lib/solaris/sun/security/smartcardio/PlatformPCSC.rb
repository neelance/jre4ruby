require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Smartcardio
  module PlatformPCSCImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Smartcardio
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Sun::Security::Util, :Debug
    }
  end
  
  # Platform specific code and functions for Unix / MUSCLE based PC/SC
  # implementations.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class PlatformPCSC 
    include_class_members PlatformPCSCImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("pcsc") }
      const_attr_reader  :Debug
      
      const_set_lazy(:PROP_NAME) { "sun.security.smartcardio.library" }
      const_attr_reader  :PROP_NAME
      
      const_set_lazy(:LIB1) { "/usr/$LIBISA/libpcsclite.so" }
      const_attr_reader  :LIB1
      
      const_set_lazy(:LIB2) { "/usr/local/$LIBISA/libpcsclite.so" }
      const_attr_reader  :LIB2
    }
    
    typesig { [] }
    def initialize
      # empty
    end
    
    class_module.module_eval {
      when_class_loaded do
        const_set :InitException, AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members PlatformPCSC
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            begin
              System.load_library("j2pcsc")
              library = get_library_name
              if (!(Debug).nil?)
                Debug.println("Using PC/SC library: " + library)
              end
              initialize_(library)
              return nil
            rescue self.class::JavaThrowable => e
              return e
            end
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [String] }
      # expand $LIBISA to the system specific directory name for libraries
      def expand(lib)
        k = lib.index_of("$LIBISA")
        if ((k).equal?(-1))
          return lib
        end
        s1 = lib.substring(0, k)
        s2 = lib.substring(k + 7)
        lib_dir = nil
        if (("64" == System.get_property("sun.arch.data.model")))
          if (("SunOS" == System.get_property("os.name")))
            lib_dir = "lib/64"
          else
            # assume Linux convention
            lib_dir = "lib64"
          end
        else
          # must be 32-bit
          lib_dir = "lib"
        end
        s = s1 + lib_dir + s2
        return s
      end
      
      typesig { [] }
      def get_library_name
        # if system property is set, use that library
        lib = expand(System.get_property(PROP_NAME, "").trim)
        if (!(lib.length).equal?(0))
          return lib
        end
        lib = RJava.cast_to_string(expand(LIB1))
        if (JavaFile.new(lib).is_file)
          # if LIB1 exists, use that
          return lib
        end
        lib = RJava.cast_to_string(expand(LIB2))
        if (JavaFile.new(lib).is_file)
          # if LIB2 exists, use that
          return lib
        end
        raise IOException.new("No PC/SC library found on this system")
      end
      
      JNI.load_native_method :Java_sun_security_smartcardio_PlatformPCSC_initialize, [:pointer, :long, :long], :void
      typesig { [String] }
      def initialize_(library_name)
        JNI.call_native_method(:Java_sun_security_smartcardio_PlatformPCSC_initialize, JNI.env, self.jni_id, library_name.jni_id)
      end
      
      # PCSC constants defined differently under Windows and MUSCLE
      # MUSCLE version
      const_set_lazy(:SCARD_PROTOCOL_T0) { 0x1 }
      const_attr_reader  :SCARD_PROTOCOL_T0
      
      const_set_lazy(:SCARD_PROTOCOL_T1) { 0x2 }
      const_attr_reader  :SCARD_PROTOCOL_T1
      
      const_set_lazy(:SCARD_PROTOCOL_RAW) { 0x4 }
      const_attr_reader  :SCARD_PROTOCOL_RAW
      
      const_set_lazy(:SCARD_UNKNOWN) { 0x1 }
      const_attr_reader  :SCARD_UNKNOWN
      
      const_set_lazy(:SCARD_ABSENT) { 0x2 }
      const_attr_reader  :SCARD_ABSENT
      
      const_set_lazy(:SCARD_PRESENT) { 0x4 }
      const_attr_reader  :SCARD_PRESENT
      
      const_set_lazy(:SCARD_SWALLOWED) { 0x8 }
      const_attr_reader  :SCARD_SWALLOWED
      
      const_set_lazy(:SCARD_POWERED) { 0x10 }
      const_attr_reader  :SCARD_POWERED
      
      const_set_lazy(:SCARD_NEGOTIABLE) { 0x20 }
      const_attr_reader  :SCARD_NEGOTIABLE
      
      const_set_lazy(:SCARD_SPECIFIC) { 0x40 }
      const_attr_reader  :SCARD_SPECIFIC
    }
    
    private
    alias_method :initialize__platform_pcsc, :initialize
  end
  
end
