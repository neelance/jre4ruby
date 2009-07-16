require "rjava"

# 
# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# 
# package private helper class which provides decoder (native->ucs)
# mapping capability for the benefit of compound encoders/decoders
# whose individual component submappings do not need an association with
# an enclosing charset
module Sun::Nio::Cs::Ext
  module DBCSDecoderMappingImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
    }
  end
  
  class DBCSDecoderMapping 
    include_class_members DBCSDecoderMappingImports
    
    # 1rst level index
    attr_accessor :index1
    alias_method :attr_index1, :index1
    undef_method :index1
    alias_method :attr_index1=, :index1=
    undef_method :index1=
    
    # 
    # 2nd level index, provided by subclass
    # every string has 0x10*(end-start+1) characters.
    attr_accessor :index2
    alias_method :attr_index2, :index2
    undef_method :index2
    alias_method :attr_index2=, :index2=
    undef_method :index2=
    
    attr_accessor :start
    alias_method :attr_start, :start
    undef_method :start
    alias_method :attr_start=, :start=
    undef_method :start=
    
    attr_accessor :end
    alias_method :attr_end, :end
    undef_method :end
    alias_method :attr_end=, :end=
    undef_method :end=
    
    class_module.module_eval {
      const_set_lazy(:REPLACE_CHAR) { Character.new(0xFFFD) }
      const_attr_reader  :REPLACE_CHAR
    }
    
    typesig { [Array.typed(::Java::Short), Array.typed(String), ::Java::Int, ::Java::Int] }
    def initialize(index1, index2, start, end_)
      @index1 = nil
      @index2 = nil
      @start = 0
      @end = 0
      @index1 = index1
      @index2 = index2
      @start = start
      @end = end_
    end
    
    typesig { [::Java::Int] }
    # 
    # Can be changed by subclass
    def decode_single(b)
      if (b >= 0)
        return RJava.cast_to_char(b)
      end
      return REPLACE_CHAR
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def decode_double(byte1, byte2)
      if (((byte1 < 0) || (byte1 > @index1.attr_length)) || ((byte2 < @start) || (byte2 > @end)))
        return REPLACE_CHAR
      end
      n = (@index1[byte1] & 0xf) * (@end - @start + 1) + (byte2 - @start)
      return @index2[@index1[byte1] >> 4].char_at(n)
    end
    
    private
    alias_method :initialize__dbcsdecoder_mapping, :initialize
  end
  
end
