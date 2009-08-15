require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang::Management
  module MemoryTypeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Management
    }
  end
  
  # Types of {@link MemoryPoolMXBean memory pools}.
  # 
  # @author  Mandy Chung
  # @since   1.5
  class MemoryType 
    include_class_members MemoryTypeImports
    
    class_module.module_eval {
      # Heap memory type.
      # <p>
      # The Java virtual machine has a <i>heap</i>
      # that is the runtime data area from which
      # memory for all class instances and arrays are allocated.
      const_set_lazy(:HEAP) { MemoryType.new("Heap memory").set_value_name("HEAP") }
      const_attr_reader  :HEAP
      
      # Non-heap memory type.
      # <p>
      # The Java virtual machine manages memory other than the heap
      # (referred as <i>non-heap memory</i>).  The non-heap memory includes
      # the <i>method area</i> and memory required for the internal
      # processing or optimization for the Java virtual machine.
      # It stores per-class structures such as a runtime
      # constant pool, field and method data, and the code for
      # methods and constructors.
      const_set_lazy(:NON_HEAP) { MemoryType.new("Non-heap memory").set_value_name("NON_HEAP") }
      const_attr_reader  :NON_HEAP
    }
    
    attr_accessor :description
    alias_method :attr_description, :description
    undef_method :description
    alias_method :attr_description=, :description=
    undef_method :description=
    
    typesig { [String] }
    def initialize(s)
      @description = nil
      @description = s
    end
    
    typesig { [] }
    # Returns the string representation of this <tt>MemoryType</tt>.
    # @return the string representation of this <tt>MemoryType</tt>.
    def to_s
      return @description
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 6992337162326171013 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [String] }
    def set_value_name(name)
      @value_name = name
      self
    end
    
    typesig { [] }
    def to_s
      @value_name
    end
    
    class_module.module_eval {
      typesig { [] }
      def values
        [HEAP, NON_HEAP]
      end
    }
    
    private
    alias_method :initialize__memory_type, :initialize
  end
  
end
