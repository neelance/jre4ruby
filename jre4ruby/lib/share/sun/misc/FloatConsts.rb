require "rjava"

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
module Sun::Misc
  module FloatConstsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
    }
  end
  
  # This class contains additional constants documenting limits of the
  # <code>float</code> type.
  # 
  # @author Joseph D. Darcy
  class FloatConsts 
    include_class_members FloatConstsImports
    
    typesig { [] }
    # Don't let anyone instantiate this class.
    def initialize
    end
    
    class_module.module_eval {
      const_set_lazy(:POSITIVE_INFINITY) { Java::Lang::Float::POSITIVE_INFINITY }
      const_attr_reader  :POSITIVE_INFINITY
      
      const_set_lazy(:NEGATIVE_INFINITY) { Java::Lang::Float::NEGATIVE_INFINITY }
      const_attr_reader  :NEGATIVE_INFINITY
      
      const_set_lazy(:NaN) { Java::Lang::Float::NaN }
      const_attr_reader  :NaN
      
      const_set_lazy(:MAX_VALUE) { Java::Lang::Float::MAX_VALUE }
      const_attr_reader  :MAX_VALUE
      
      const_set_lazy(:MIN_VALUE) { Java::Lang::Float::MIN_VALUE }
      const_attr_reader  :MIN_VALUE
      
      # A constant holding the smallest positive normal value of type
      # <code>float</code>, 2<sup>-126</sup>.  It is equal to the value
      # returned by <code>Float.intBitsToFloat(0x00800000)</code>.
      const_set_lazy(:MIN_NORMAL) { 1.17549435E-38 }
      const_attr_reader  :MIN_NORMAL
      
      # The number of logical bits in the significand of a
      # <code>float</code> number, including the implicit bit.
      const_set_lazy(:SIGNIFICAND_WIDTH) { 24 }
      const_attr_reader  :SIGNIFICAND_WIDTH
      
      # Maximum exponent a finite <code>float</code> number may have.
      # It is equal to the value returned by
      # <code>Math.ilogb(Float.MAX_VALUE)</code>.
      const_set_lazy(:MAX_EXPONENT) { 127 }
      const_attr_reader  :MAX_EXPONENT
      
      # Minimum exponent a normalized <code>float</code> number may
      # have.  It is equal to the value returned by
      # <code>Math.ilogb(Float.MIN_NORMAL)</code>.
      const_set_lazy(:MIN_EXPONENT) { -126 }
      const_attr_reader  :MIN_EXPONENT
      
      # The exponent the smallest positive <code>float</code> subnormal
      # value would have if it could be normalized.  It is equal to the
      # value returned by <code>FpUtils.ilogb(Float.MIN_VALUE)</code>.
      const_set_lazy(:MIN_SUB_EXPONENT) { MIN_EXPONENT - (SIGNIFICAND_WIDTH - 1) }
      const_attr_reader  :MIN_SUB_EXPONENT
      
      # Bias used in representing a <code>float</code> exponent.
      const_set_lazy(:EXP_BIAS) { 127 }
      const_attr_reader  :EXP_BIAS
      
      # Bit mask to isolate the sign bit of a <code>float</code>.
      const_set_lazy(:SIGN_BIT_MASK) { -0x80000000 }
      const_attr_reader  :SIGN_BIT_MASK
      
      # Bit mask to isolate the exponent field of a
      # <code>float</code>.
      const_set_lazy(:EXP_BIT_MASK) { 0x7f800000 }
      const_attr_reader  :EXP_BIT_MASK
      
      # Bit mask to isolate the significand field of a
      # <code>float</code>.
      const_set_lazy(:SIGNIF_BIT_MASK) { 0x7fffff }
      const_attr_reader  :SIGNIF_BIT_MASK
      
      when_class_loaded do
        # verify bit masks cover all bit positions and that the bit
        # masks are non-overlapping
        raise AssertError if not (((((SIGN_BIT_MASK | EXP_BIT_MASK | SIGNIF_BIT_MASK)).equal?(~0)) && ((((SIGN_BIT_MASK & EXP_BIT_MASK)).equal?(0)) && (((SIGN_BIT_MASK & SIGNIF_BIT_MASK)).equal?(0)) && (((EXP_BIT_MASK & SIGNIF_BIT_MASK)).equal?(0)))))
      end
    }
    
    private
    alias_method :initialize__float_consts, :initialize
  end
  
end
