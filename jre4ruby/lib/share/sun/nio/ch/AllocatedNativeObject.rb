require "rjava"

# Copyright 2000-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Ch
  module AllocatedNativeObjectImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
    }
  end
  
  # Formerly in sun.misc
  # ## In the fullness of time, this class will be eliminated
  class AllocatedNativeObject < AllocatedNativeObjectImports.const_get :NativeObject
    include_class_members AllocatedNativeObjectImports
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # package-private
    # Allocates a memory area of at least <tt>size</tt> bytes outside of the
    # Java heap and creates a native object for that area.
    # 
    # @param  size
    #         Number of bytes to allocate
    # 
    # @param  pageAligned
    #         If <tt>true</tt> then the area will be aligned on a hardware
    #         page boundary
    # 
    # @throws OutOfMemoryError
    #         If the request cannot be satisfied
    def initialize(size, page_aligned)
      super(size, page_aligned)
    end
    
    typesig { [] }
    # Frees the native memory area associated with this object.
    def free
      synchronized(self) do
        if (!(self.attr_allocation_address).equal?(0))
          self.attr_unsafe.free_memory(self.attr_allocation_address)
          self.attr_allocation_address = 0
        end
      end
    end
    
    private
    alias_method :initialize__allocated_native_object, :initialize
  end
  
end
