require "rjava"

# 
# Copyright 1999-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module VersionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Io, :PrintStream
    }
  end
  
  class Version 
    include_class_members VersionImports
    
    class_module.module_eval {
      const_set_lazy(:Launcher_name) { "@@launcher_name@@" }
      const_attr_reader  :Launcher_name
      
      const_set_lazy(:Java_version) { "@@java_version@@" }
      const_attr_reader  :Java_version
      
      const_set_lazy(:Java_runtime_name) { "@@java_runtime_name@@" }
      const_attr_reader  :Java_runtime_name
      
      const_set_lazy(:Java_runtime_version) { "@@java_runtime_version@@" }
      const_attr_reader  :Java_runtime_version
      
      when_class_loaded do
        init
      end
      
      typesig { [] }
      def init
        System.set_property("java.version", Java_version)
        System.set_property("java.runtime.version", Java_runtime_version)
        System.set_property("java.runtime.name", Java_runtime_name)
      end
      
      
      def versions_initialized
        defined?(@@versions_initialized) ? @@versions_initialized : @@versions_initialized= false
      end
      alias_method :attr_versions_initialized, :versions_initialized
      
      def versions_initialized=(value)
        @@versions_initialized = value
      end
      alias_method :attr_versions_initialized=, :versions_initialized=
      
      
      def jvm_major_version
        defined?(@@jvm_major_version) ? @@jvm_major_version : @@jvm_major_version= 0
      end
      alias_method :attr_jvm_major_version, :jvm_major_version
      
      def jvm_major_version=(value)
        @@jvm_major_version = value
      end
      alias_method :attr_jvm_major_version=, :jvm_major_version=
      
      
      def jvm_minor_version
        defined?(@@jvm_minor_version) ? @@jvm_minor_version : @@jvm_minor_version= 0
      end
      alias_method :attr_jvm_minor_version, :jvm_minor_version
      
      def jvm_minor_version=(value)
        @@jvm_minor_version = value
      end
      alias_method :attr_jvm_minor_version=, :jvm_minor_version=
      
      
      def jvm_micro_version
        defined?(@@jvm_micro_version) ? @@jvm_micro_version : @@jvm_micro_version= 0
      end
      alias_method :attr_jvm_micro_version, :jvm_micro_version
      
      def jvm_micro_version=(value)
        @@jvm_micro_version = value
      end
      alias_method :attr_jvm_micro_version=, :jvm_micro_version=
      
      
      def jvm_update_version
        defined?(@@jvm_update_version) ? @@jvm_update_version : @@jvm_update_version= 0
      end
      alias_method :attr_jvm_update_version, :jvm_update_version
      
      def jvm_update_version=(value)
        @@jvm_update_version = value
      end
      alias_method :attr_jvm_update_version=, :jvm_update_version=
      
      
      def jvm_build_number
        defined?(@@jvm_build_number) ? @@jvm_build_number : @@jvm_build_number= 0
      end
      alias_method :attr_jvm_build_number, :jvm_build_number
      
      def jvm_build_number=(value)
        @@jvm_build_number = value
      end
      alias_method :attr_jvm_build_number=, :jvm_build_number=
      
      
      def jvm_special_version
        defined?(@@jvm_special_version) ? @@jvm_special_version : @@jvm_special_version= nil
      end
      alias_method :attr_jvm_special_version, :jvm_special_version
      
      def jvm_special_version=(value)
        @@jvm_special_version = value
      end
      alias_method :attr_jvm_special_version=, :jvm_special_version=
      
      
      def jdk_major_version
        defined?(@@jdk_major_version) ? @@jdk_major_version : @@jdk_major_version= 0
      end
      alias_method :attr_jdk_major_version, :jdk_major_version
      
      def jdk_major_version=(value)
        @@jdk_major_version = value
      end
      alias_method :attr_jdk_major_version=, :jdk_major_version=
      
      
      def jdk_minor_version
        defined?(@@jdk_minor_version) ? @@jdk_minor_version : @@jdk_minor_version= 0
      end
      alias_method :attr_jdk_minor_version, :jdk_minor_version
      
      def jdk_minor_version=(value)
        @@jdk_minor_version = value
      end
      alias_method :attr_jdk_minor_version=, :jdk_minor_version=
      
      
      def jdk_micro_version
        defined?(@@jdk_micro_version) ? @@jdk_micro_version : @@jdk_micro_version= 0
      end
      alias_method :attr_jdk_micro_version, :jdk_micro_version
      
      def jdk_micro_version=(value)
        @@jdk_micro_version = value
      end
      alias_method :attr_jdk_micro_version=, :jdk_micro_version=
      
      
      def jdk_update_version
        defined?(@@jdk_update_version) ? @@jdk_update_version : @@jdk_update_version= 0
      end
      alias_method :attr_jdk_update_version, :jdk_update_version
      
      def jdk_update_version=(value)
        @@jdk_update_version = value
      end
      alias_method :attr_jdk_update_version=, :jdk_update_version=
      
      
      def jdk_build_number
        defined?(@@jdk_build_number) ? @@jdk_build_number : @@jdk_build_number= 0
      end
      alias_method :attr_jdk_build_number, :jdk_build_number
      
      def jdk_build_number=(value)
        @@jdk_build_number = value
      end
      alias_method :attr_jdk_build_number=, :jdk_build_number=
      
      
      def jdk_special_version
        defined?(@@jdk_special_version) ? @@jdk_special_version : @@jdk_special_version= nil
      end
      alias_method :attr_jdk_special_version, :jdk_special_version
      
      def jdk_special_version=(value)
        @@jdk_special_version = value
      end
      alias_method :attr_jdk_special_version=, :jdk_special_version=
      
      typesig { [] }
      # 
      # In case you were wondering this method is called by java -version.
      # Sad that it prints to stderr; would be nicer if default printed on
      # stdout.
      def print
        print(System.err)
      end
      
      typesig { [PrintStream] }
      # 
      # Give a stream, it will print version info on it.
      def print(ps)
        # First line: platform version.
        ps.println(Launcher_name + " version \"" + Java_version + "\"")
        # Second line: runtime version (ie, libraries).
        ps.println(Java_runtime_name + " (build " + Java_runtime_version + ")")
        # Third line: JVM information.
        java_vm_name = System.get_property("java.vm.name")
        java_vm_version = System.get_property("java.vm.version")
        java_vm_info = System.get_property("java.vm.info")
        ps.println(java_vm_name + " (build " + java_vm_version + ", " + java_vm_info + ")")
      end
      
      typesig { [] }
      # 
      # Returns the major version of the running JVM if it's 1.6 or newer
      # or any RE VM build. It will return 0 if it's an internal 1.5 or
      # 1.4.x build.
      # 
      # @since 1.6
      def jvm_major_version
        synchronized(self) do
          if (!self.attr_versions_initialized)
            init_versions
          end
          return self.attr_jvm_major_version
        end
      end
      
      typesig { [] }
      # 
      # Returns the minor version of the running JVM if it's 1.6 or newer
      # or any RE VM build. It will return 0 if it's an internal 1.5 or
      # 1.4.x build.
      # @since 1.6
      def jvm_minor_version
        synchronized(self) do
          if (!self.attr_versions_initialized)
            init_versions
          end
          return self.attr_jvm_minor_version
        end
      end
      
      typesig { [] }
      # 
      # Returns the micro version of the running JVM if it's 1.6 or newer
      # or any RE VM build. It will return 0 if it's an internal 1.5 or
      # 1.4.x build.
      # @since 1.6
      def jvm_micro_version
        synchronized(self) do
          if (!self.attr_versions_initialized)
            init_versions
          end
          return self.attr_jvm_micro_version
        end
      end
      
      typesig { [] }
      # 
      # Returns the update release version of the running JVM if it's
      # a RE build. It will return 0 if it's an internal build.
      # @since 1.6
      def jvm_update_version
        synchronized(self) do
          if (!self.attr_versions_initialized)
            init_versions
          end
          return self.attr_jvm_update_version
        end
      end
      
      typesig { [] }
      def jvm_special_version
        synchronized(self) do
          if (!self.attr_versions_initialized)
            init_versions
          end
          if ((self.attr_jvm_special_version).nil?)
            self.attr_jvm_special_version = (get_jvm_special_version).to_s
          end
          return self.attr_jvm_special_version
        end
      end
      
      JNI.native_method :Java_sun_misc_Version_getJvmSpecialVersion, [:pointer, :long], :long
      typesig { [] }
      def get_jvm_special_version
        JNI.__send__(:Java_sun_misc_Version_getJvmSpecialVersion, JNI.env, self.jni_id)
      end
      
      typesig { [] }
      # 
      # Returns the build number of the running JVM if it's a RE build
      # It will return 0 if it's an internal build.
      # @since 1.6
      def jvm_build_number
        synchronized(self) do
          if (!self.attr_versions_initialized)
            init_versions
          end
          return self.attr_jvm_build_number
        end
      end
      
      typesig { [] }
      # 
      # Returns the major version of the running JDK.
      # 
      # @since 1.6
      def jdk_major_version
        synchronized(self) do
          if (!self.attr_versions_initialized)
            init_versions
          end
          return self.attr_jdk_major_version
        end
      end
      
      typesig { [] }
      # 
      # Returns the minor version of the running JDK.
      # @since 1.6
      def jdk_minor_version
        synchronized(self) do
          if (!self.attr_versions_initialized)
            init_versions
          end
          return self.attr_jdk_minor_version
        end
      end
      
      typesig { [] }
      # 
      # Returns the micro version of the running JDK.
      # @since 1.6
      def jdk_micro_version
        synchronized(self) do
          if (!self.attr_versions_initialized)
            init_versions
          end
          return self.attr_jdk_micro_version
        end
      end
      
      typesig { [] }
      # 
      # Returns the update release version of the running JDK if it's
      # a RE build. It will return 0 if it's an internal build.
      # @since 1.6
      def jdk_update_version
        synchronized(self) do
          if (!self.attr_versions_initialized)
            init_versions
          end
          return self.attr_jdk_update_version
        end
      end
      
      typesig { [] }
      def jdk_special_version
        synchronized(self) do
          if (!self.attr_versions_initialized)
            init_versions
          end
          if ((self.attr_jdk_special_version).nil?)
            self.attr_jdk_special_version = (get_jdk_special_version).to_s
          end
          return self.attr_jdk_special_version
        end
      end
      
      JNI.native_method :Java_sun_misc_Version_getJdkSpecialVersion, [:pointer, :long], :long
      typesig { [] }
      def get_jdk_special_version
        JNI.__send__(:Java_sun_misc_Version_getJdkSpecialVersion, JNI.env, self.jni_id)
      end
      
      typesig { [] }
      # 
      # Returns the build number of the running JDK if it's a RE build
      # It will return 0 if it's an internal build.
      # @since 1.6
      def jdk_build_number
        synchronized(self) do
          if (!self.attr_versions_initialized)
            init_versions
          end
          return self.attr_jdk_build_number
        end
      end
      
      # true if JVM exports the version info including the capabilities
      
      def jvm_version_info_available
        defined?(@@jvm_version_info_available) ? @@jvm_version_info_available : @@jvm_version_info_available= false
      end
      alias_method :attr_jvm_version_info_available, :jvm_version_info_available
      
      def jvm_version_info_available=(value)
        @@jvm_version_info_available = value
      end
      alias_method :attr_jvm_version_info_available=, :jvm_version_info_available=
      
      typesig { [] }
      def init_versions
        synchronized(self) do
          if (self.attr_versions_initialized)
            return
          end
          self.attr_jvm_version_info_available = get_jvm_version_info
          if (!self.attr_jvm_version_info_available)
            # parse java.vm.version for older JVM before the
            # new JVM_GetVersionInfo is added.
            # valid format of the version string is:
            # n.n.n[_uu[c]][-<identifer>]-bxx
            cs = System.get_property("java.vm.version")
            if (cs.length >= 5 && Character.is_digit(cs.char_at(0)) && (cs.char_at(1)).equal?(Character.new(?..ord)) && Character.is_digit(cs.char_at(2)) && (cs.char_at(3)).equal?(Character.new(?..ord)) && Character.is_digit(cs.char_at(4)))
              self.attr_jvm_major_version = Character.digit(cs.char_at(0), 10)
              self.attr_jvm_minor_version = Character.digit(cs.char_at(2), 10)
              self.attr_jvm_micro_version = Character.digit(cs.char_at(4), 10)
              cs = cs.sub_sequence(5, cs.length)
              if ((cs.char_at(0)).equal?(Character.new(?_.ord)) && cs.length >= 3 && Character.is_digit(cs.char_at(1)) && Character.is_digit(cs.char_at(2)))
                next_char = 3
                begin
                  uu = cs.sub_sequence(1, 3).to_s
                  self.attr_jvm_update_version = JavaInteger.value_of(uu).int_value
                  if (cs.length >= 4)
                    c = cs.char_at(3)
                    if (c >= Character.new(?a.ord) && c <= Character.new(?z.ord))
                      self.attr_jvm_special_version = (Character.to_s(c)).to_s
                      ((next_char += 1) - 1)
                    end
                  end
                rescue NumberFormatException => e
                  # not conforming to the naming convention
                  return
                end
                cs = cs.sub_sequence(next_char, cs.length)
              end
              if ((cs.char_at(0)).equal?(Character.new(?-.ord)))
                # skip the first character
                # valid format: <identifier>-bxx or bxx
                # non-product VM will have -debug|-release appended
                cs = cs.sub_sequence(1, cs.length)
                res = cs.to_s.split(Regexp.new("-"))
                res.each do |s|
                  if ((s.char_at(0)).equal?(Character.new(?b.ord)) && (s.length).equal?(3) && Character.is_digit(s.char_at(1)) && Character.is_digit(s.char_at(2)))
                    self.attr_jvm_build_number = JavaInteger.value_of(s.substring(1, 3)).int_value
                    break
                  end
                end
              end
            end
          end
          get_jdk_version_info
          self.attr_versions_initialized = true
        end
      end
      
      JNI.native_method :Java_sun_misc_Version_getJvmVersionInfo, [:pointer, :long], :int8
      typesig { [] }
      # Gets the JVM version info if available and sets the jvm_*_version fields
      # and its capabilities.
      # 
      # Return false if not available which implies an old VM (Tiger or before).
      def get_jvm_version_info
        JNI.__send__(:Java_sun_misc_Version_getJvmVersionInfo, JNI.env, self.jni_id) != 0
      end
      
      JNI.native_method :Java_sun_misc_Version_getJdkVersionInfo, [:pointer, :long], :void
      typesig { [] }
      def get_jdk_version_info
        JNI.__send__(:Java_sun_misc_Version_getJdkVersionInfo, JNI.env, self.jni_id)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__version, :initialize
  end
  
end
