require "rjava"

# Copyright 1994-1995 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CRC16Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
    }
  end
  
  # The CRC-16 class calculates a 16 bit cyclic redundancy check of a set
  # of bytes. This error detecting code is used to determine if bit rot
  # has occured in a byte stream.
  class CRC16 
    include_class_members CRC16Imports
    
    # value contains the currently computed CRC, set it to 0 initally
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    typesig { [] }
    def initialize
      @value = 0
      @value = 0
    end
    
    typesig { [::Java::Byte] }
    # update CRC with byte b
    def update(a_byte)
      a = 0
      b = 0
      a = (a_byte).to_int
      count = 7
      while count >= 0
        a = a << 1
        b = (a >> 8) & 1
        if (!((@value & 0x8000)).equal?(0))
          @value = ((@value << 1) + b) ^ 0x1021
        else
          @value = (@value << 1) + b
        end
        count -= 1
      end
      @value = @value & 0xffff
      return
    end
    
    typesig { [] }
    # reset CRC value to 0
    def reset
      @value = 0
    end
    
    private
    alias_method :initialize__crc16, :initialize
  end
  
end
