require "rjava"

# Copyright 1994-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang
  module NumberImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # The abstract class <code>Number</code> is the superclass of classes
  # <code>BigDecimal</code>, <code>BigInteger</code>,
  # <code>Byte</code>, <code>Double</code>, <code>Float</code>,
  # <code>Integer</code>, <code>Long</code>, and <code>Short</code>.
  # <p>
  # Subclasses of <code>Number</code> must provide methods to convert
  # the represented numeric value to <code>byte</code>, <code>double</code>,
  # <code>float</code>, <code>int</code>, <code>long</code>, and
  # <code>short</code>.
  # 
  # @author      Lee Boynton
  # @author      Arthur van Hoff
  # @see     java.lang.Byte
  # @see     java.lang.Double
  # @see     java.lang.Float
  # @see     java.lang.Integer
  # @see     java.lang.Long
  # @see     java.lang.Short
  # @since   JDK1.0
  class Numeric 
    include_class_members NumberImports
    include Java::Io::Serializable
    
    typesig { [] }
    # Returns the value of the specified number as an <code>int</code>.
    # This may involve rounding or truncation.
    # 
    # @return  the numeric value represented by this object after conversion
    # to type <code>int</code>.
    def int_value
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the value of the specified number as a <code>long</code>.
    # This may involve rounding or truncation.
    # 
    # @return  the numeric value represented by this object after conversion
    # to type <code>long</code>.
    def long_value
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the value of the specified number as a <code>float</code>.
    # This may involve rounding.
    # 
    # @return  the numeric value represented by this object after conversion
    # to type <code>float</code>.
    def float_value
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the value of the specified number as a <code>double</code>.
    # This may involve rounding.
    # 
    # @return  the numeric value represented by this object after conversion
    # to type <code>double</code>.
    def double_value
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the value of the specified number as a <code>byte</code>.
    # This may involve rounding or truncation.
    # 
    # @return  the numeric value represented by this object after conversion
    # to type <code>byte</code>.
    # @since   JDK1.1
    def byte_value
      return int_value
    end
    
    typesig { [] }
    # Returns the value of the specified number as a <code>short</code>.
    # This may involve rounding or truncation.
    # 
    # @return  the numeric value represented by this object after conversion
    # to type <code>short</code>.
    # @since   JDK1.1
    def short_value
      return RJava.cast_to_short(int_value)
    end
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.0.2 for interoperability
      const_set_lazy(:SerialVersionUID) { -8742448824652078965 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__number, :initialize
  end
  
end
