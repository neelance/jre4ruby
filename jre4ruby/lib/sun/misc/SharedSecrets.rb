require "rjava"

# 
# Copyright 2002-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SharedSecretsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Util::Jar, :JarFile
      include_const ::Java::Io, :Console
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :FileDescriptor
    }
  end
  
  # A repository of "shared secrets", which are a mechanism for
  # calling implementation-private methods in another package without
  # using reflection. A package-private class implements a public
  # interface and provides the ability to call package-private methods
  # within that package; the object implementing that interface is
  # provided through a third package to which access is restricted.
  # This framework avoids the primary disadvantage of using reflection
  # for this purpose, namely the loss of compile-time checking.
  class SharedSecrets 
    include_class_members SharedSecretsImports
    
    class_module.module_eval {
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
      
      
      def java_util_jar_access
        defined?(@@java_util_jar_access) ? @@java_util_jar_access : @@java_util_jar_access= nil
      end
      alias_method :attr_java_util_jar_access, :java_util_jar_access
      
      def java_util_jar_access=(value)
        @@java_util_jar_access = value
      end
      alias_method :attr_java_util_jar_access=, :java_util_jar_access=
      
      
      def java_lang_access
        defined?(@@java_lang_access) ? @@java_lang_access : @@java_lang_access= nil
      end
      alias_method :attr_java_lang_access, :java_lang_access
      
      def java_lang_access=(value)
        @@java_lang_access = value
      end
      alias_method :attr_java_lang_access=, :java_lang_access=
      
      
      def java_ioaccess
        defined?(@@java_ioaccess) ? @@java_ioaccess : @@java_ioaccess= nil
      end
      alias_method :attr_java_ioaccess, :java_ioaccess
      
      def java_ioaccess=(value)
        @@java_ioaccess = value
      end
      alias_method :attr_java_ioaccess=, :java_ioaccess=
      
      
      def java_iodelete_on_exit_access
        defined?(@@java_iodelete_on_exit_access) ? @@java_iodelete_on_exit_access : @@java_iodelete_on_exit_access= nil
      end
      alias_method :attr_java_iodelete_on_exit_access, :java_iodelete_on_exit_access
      
      def java_iodelete_on_exit_access=(value)
        @@java_iodelete_on_exit_access = value
      end
      alias_method :attr_java_iodelete_on_exit_access=, :java_iodelete_on_exit_access=
      
      
      def java_net_access
        defined?(@@java_net_access) ? @@java_net_access : @@java_net_access= nil
      end
      alias_method :attr_java_net_access, :java_net_access
      
      def java_net_access=(value)
        @@java_net_access = value
      end
      alias_method :attr_java_net_access=, :java_net_access=
      
      
      def java_iofile_descriptor_access
        defined?(@@java_iofile_descriptor_access) ? @@java_iofile_descriptor_access : @@java_iofile_descriptor_access= nil
      end
      alias_method :attr_java_iofile_descriptor_access, :java_iofile_descriptor_access
      
      def java_iofile_descriptor_access=(value)
        @@java_iofile_descriptor_access = value
      end
      alias_method :attr_java_iofile_descriptor_access=, :java_iofile_descriptor_access=
      
      typesig { [] }
      def java_util_jar_access
        if ((self.attr_java_util_jar_access).nil?)
          # Ensure JarFile is initialized; we know that that class
          # provides the shared secret
          UnsafeInstance.ensure_class_initialized(JarFile.class)
        end
        return self.attr_java_util_jar_access
      end
      
      typesig { [JavaUtilJarAccess] }
      def set_java_util_jar_access(access)
        self.attr_java_util_jar_access = access
      end
      
      typesig { [JavaLangAccess] }
      def set_java_lang_access(jla)
        self.attr_java_lang_access = jla
      end
      
      typesig { [] }
      def get_java_lang_access
        return self.attr_java_lang_access
      end
      
      typesig { [JavaNetAccess] }
      def set_java_net_access(jna)
        self.attr_java_net_access = jna
      end
      
      typesig { [] }
      def get_java_net_access
        return self.attr_java_net_access
      end
      
      typesig { [JavaIOAccess] }
      def set_java_ioaccess(jia)
        self.attr_java_ioaccess = jia
      end
      
      typesig { [] }
      def get_java_ioaccess
        if ((self.attr_java_ioaccess).nil?)
          UnsafeInstance.ensure_class_initialized(Console.class)
        end
        return self.attr_java_ioaccess
      end
      
      typesig { [JavaIODeleteOnExitAccess] }
      def set_java_iodelete_on_exit_access(jida)
        self.attr_java_iodelete_on_exit_access = jida
      end
      
      typesig { [] }
      def get_java_iodelete_on_exit_access
        if ((self.attr_java_iodelete_on_exit_access).nil?)
          UnsafeInstance.ensure_class_initialized(JavaFile.class)
        end
        return self.attr_java_iodelete_on_exit_access
      end
      
      typesig { [JavaIOFileDescriptorAccess] }
      def set_java_iofile_descriptor_access(jiofda)
        self.attr_java_iofile_descriptor_access = jiofda
      end
      
      typesig { [] }
      def get_java_iofile_descriptor_access
        if ((self.attr_java_iofile_descriptor_access).nil?)
          UnsafeInstance.ensure_class_initialized(FileDescriptor.class)
        end
        return self.attr_java_iofile_descriptor_access
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__shared_secrets, :initialize
  end
  
end
