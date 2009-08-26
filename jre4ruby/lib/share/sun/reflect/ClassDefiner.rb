require "rjava"

# Copyright 2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect
  module ClassDefinerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Sun::Misc, :Unsafe
    }
  end
  
  # Utility class which assists in calling Unsafe.defineClass() by
  # creating a new class loader which delegates to the one needed in
  # order for proper resolution of the given bytecodes to occur.
  class ClassDefiner 
    include_class_members ClassDefinerImports
    
    class_module.module_eval {
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
      
      typesig { [String, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ClassLoader] }
      # <P> We define generated code into a new class loader which
      # delegates to the defining loader of the target class. It is
      # necessary for the VM to be able to resolve references to the
      # target class from the generated bytecodes, which could not occur
      # if the generated code was loaded into the bootstrap class
      # loader. </P>
      # 
      # <P> There are two primary reasons for creating a new loader
      # instead of defining these bytecodes directly into the defining
      # loader of the target class: first, it avoids any possible
      # security risk of having these bytecodes in the same loader.
      # Second, it allows the generated bytecodes to be unloaded earlier
      # than would otherwise be possible, decreasing run-time
      # footprint. </P>
      def define_class(name, bytes, off, len, parent_class_loader)
        new_loader = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members ClassDefiner
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return self.class::DelegatingClassLoader.new(parent_class_loader)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        return UnsafeInstance.define_class(name, bytes, off, len, new_loader, nil)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__class_definer, :initialize
  end
  
  # NOTE: this class's name and presence are known to the virtual
  # machine as of the fix for 4474172.
  class DelegatingClassLoader < ClassDefinerImports.const_get :ClassLoader
    include_class_members ClassDefinerImports
    
    typesig { [ClassLoader] }
    def initialize(parent)
      super(parent)
    end
    
    private
    alias_method :initialize__delegating_class_loader, :initialize
  end
  
end
