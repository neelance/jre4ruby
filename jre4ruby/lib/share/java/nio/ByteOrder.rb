require "rjava"

# Copyright 2000-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ByteOrderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio
    }
  end
  
  # A typesafe enumeration for byte orders.
  # 
  # @author Mark Reinhold
  # @author JSR-51 Expert Group
  # @since 1.4
  class ByteOrder 
    include_class_members ByteOrderImports
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    typesig { [String] }
    def initialize(name)
      @name = nil
      @name = name
    end
    
    class_module.module_eval {
      # Constant denoting big-endian byte order.  In this order, the bytes of a
      # multibyte value are ordered from most significant to least significant.
      # </p>
      const_set_lazy(:BIG_ENDIAN) { ByteOrder.new("BIG_ENDIAN") }
      const_attr_reader  :BIG_ENDIAN
      
      # Constant denoting little-endian byte order.  In this order, the bytes of
      # a multibyte value are ordered from least significant to most
      # significant.  </p>
      const_set_lazy(:LITTLE_ENDIAN) { ByteOrder.new("LITTLE_ENDIAN") }
      const_attr_reader  :LITTLE_ENDIAN
      
      typesig { [] }
      # Retrieves the native byte order of the underlying platform.
      # 
      # <p> This method is defined so that performance-sensitive Java code can
      # allocate direct buffers with the same byte order as the hardware.
      # Native code libraries are often more efficient when such buffers are
      # used.  </p>
      # 
      # @return  The native byte order of the hardware upon which this Java
      #          virtual machine is running
      def native_order
        return Bits.byte_order
      end
    }
    
    typesig { [] }
    # Constructs a string describing this object.
    # 
    # <p> This method returns the string <tt>"BIG_ENDIAN"</tt> for {@link
    # #BIG_ENDIAN} and <tt>"LITTLE_ENDIAN"</tt> for {@link #LITTLE_ENDIAN}.
    # </p>
    # 
    # @return  The specified string
    def to_s
      return @name
    end
    
    private
    alias_method :initialize__byte_order, :initialize
  end
  
end
