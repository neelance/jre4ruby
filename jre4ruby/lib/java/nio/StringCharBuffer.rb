require "rjava"

# 
# Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Nio
  # package-private
  module StringCharBufferImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio
    }
  end
  
  # ## If the sequence is a string, use reflection to share its array
  class StringCharBuffer < StringCharBufferImports.const_get :CharBuffer
    include_class_members StringCharBufferImports
    
    attr_accessor :str
    alias_method :attr_str, :str
    undef_method :str
    alias_method :attr_str=, :str=
    undef_method :str=
    
    typesig { [CharSequence, ::Java::Int, ::Java::Int] }
    def initialize(s, start, end_)
      # package-private
      @str = nil
      super(-1, start, end_, s.length)
      n = s.length
      if ((start < 0) || (start > n) || (end_ < start) || (end_ > n))
        raise IndexOutOfBoundsException.new
      end
      @str = s
    end
    
    typesig { [] }
    def slice
      return StringCharBuffer.new(@str, -1, 0, self.remaining, self.remaining, self.position)
    end
    
    typesig { [CharSequence, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    def initialize(s, mark, pos, limit, cap, offset)
      @str = nil
      super(mark, pos, limit, cap, nil, offset)
      @str = s
    end
    
    typesig { [CharSequence, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    def initialize(s, mark, pos, limit, cap)
      @str = nil
      super(mark, pos, limit, cap)
      @str = s
    end
    
    typesig { [] }
    def duplicate
      return StringCharBuffer.new(@str, mark_value, position, limit, capacity)
    end
    
    typesig { [] }
    def as_read_only_buffer
      return duplicate
    end
    
    typesig { [] }
    def get
      return @str.char_at(next_get_index)
    end
    
    typesig { [::Java::Int] }
    def get(index)
      return @str.char_at(check_index(index))
    end
    
    typesig { [::Java::Char] }
    # ## Override bulk get methods for better performance
    def put(c)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [::Java::Int, ::Java::Char] }
    def put(index, c)
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def compact
      raise ReadOnlyBufferException.new
    end
    
    typesig { [] }
    def is_read_only
      return true
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def to_s(start, end_)
      return @str.to_s.substring(start, end_)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def sub_sequence(start, end_)
      begin
        pos = position
        return StringCharBuffer.new(@str, pos + check_index(start, pos), pos + check_index(end_, pos))
      rescue IllegalArgumentException => x
        raise IndexOutOfBoundsException.new
      end
    end
    
    typesig { [] }
    def is_direct
      return false
    end
    
    typesig { [] }
    def order
      return ByteOrder.native_order
    end
    
    private
    alias_method :initialize__string_char_buffer, :initialize
  end
  
end
