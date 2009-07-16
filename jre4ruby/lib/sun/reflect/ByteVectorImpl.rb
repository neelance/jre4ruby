require "rjava"

# 
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
  module ByteVectorImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
    }
  end
  
  class ByteVectorImpl 
    include_class_members ByteVectorImplImports
    include ByteVector
    
    attr_accessor :data
    alias_method :attr_data, :data
    undef_method :data
    alias_method :attr_data=, :data=
    undef_method :data=
    
    attr_accessor :pos
    alias_method :attr_pos, :pos
    undef_method :pos
    alias_method :attr_pos=, :pos=
    undef_method :pos=
    
    typesig { [] }
    def initialize
      initialize__byte_vector_impl(100)
    end
    
    typesig { [::Java::Int] }
    def initialize(sz)
      @data = nil
      @pos = 0
      @data = Array.typed(::Java::Byte).new(sz) { 0 }
      @pos = -1
    end
    
    typesig { [] }
    def get_length
      return @pos + 1
    end
    
    typesig { [::Java::Int] }
    def get(index)
      if (index >= @data.attr_length)
        resize(index)
        @pos = index
      end
      return @data[index]
    end
    
    typesig { [::Java::Int, ::Java::Byte] }
    def put(index, value)
      if (index >= @data.attr_length)
        resize(index)
        @pos = index
      end
      @data[index] = value
    end
    
    typesig { [::Java::Byte] }
    def add(value)
      if ((@pos += 1) >= @data.attr_length)
        resize(@pos)
      end
      @data[@pos] = value
    end
    
    typesig { [] }
    def trim
      if (!(@pos).equal?(@data.attr_length - 1))
        new_data = Array.typed(::Java::Byte).new(@pos + 1) { 0 }
        System.arraycopy(@data, 0, new_data, 0, @pos + 1)
        @data = new_data
      end
    end
    
    typesig { [] }
    def get_data
      return @data
    end
    
    typesig { [::Java::Int] }
    def resize(min_size)
      if (min_size <= 2 * @data.attr_length)
        min_size = 2 * @data.attr_length
      end
      new_data = Array.typed(::Java::Byte).new(min_size) { 0 }
      System.arraycopy(@data, 0, new_data, 0, @data.attr_length)
      @data = new_data
    end
    
    private
    alias_method :initialize__byte_vector_impl, :initialize
  end
  
end
