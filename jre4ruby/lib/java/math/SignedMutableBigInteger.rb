require "rjava"

# Copyright 1999-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Math
  module SignedMutableBigIntegerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Math
    }
  end
  
  # A class used to represent multiprecision integers that makes efficient
  # use of allocated space by allowing a number to occupy only part of
  # an array so that the arrays do not have to be reallocated as often.
  # When performing an operation with many iterations the array used to
  # hold a number is only increased when necessary and does not have to
  # be the same size as the number it represents. A mutable number allows
  # calculations to occur on the same number without having to create
  # a new number for every step of the calculation as occurs with
  # BigIntegers.
  # 
  # Note that SignedMutableBigIntegers only support signed addition and
  # subtraction. All other operations occur as with MutableBigIntegers.
  # 
  # @see     BigInteger
  # @author  Michael McCloskey
  # @since   1.3
  class SignedMutableBigInteger < SignedMutableBigIntegerImports.const_get :MutableBigInteger
    include_class_members SignedMutableBigIntegerImports
    
    # The sign of this MutableBigInteger.
    attr_accessor :sign
    alias_method :attr_sign, :sign
    undef_method :sign
    alias_method :attr_sign=, :sign=
    undef_method :sign=
    
    typesig { [] }
    # Constructors
    # 
    # The default constructor. An empty MutableBigInteger is created with
    # a one word capacity.
    def initialize
      @sign = 0
      super()
      @sign = 1
    end
    
    typesig { [::Java::Int] }
    # Construct a new MutableBigInteger with a magnitude specified by
    # the int val.
    def initialize(val)
      @sign = 0
      super(val)
      @sign = 1
    end
    
    typesig { [MutableBigInteger] }
    # Construct a new MutableBigInteger with a magnitude equal to the
    # specified MutableBigInteger.
    def initialize(val)
      @sign = 0
      super(val)
      @sign = 1
    end
    
    typesig { [SignedMutableBigInteger] }
    # Arithmetic Operations
    # 
    # Signed addition built upon unsigned add and subtract.
    def signed_add(addend)
      if ((@sign).equal?(addend.attr_sign))
        add(addend)
      else
        @sign = @sign * subtract(addend)
      end
    end
    
    typesig { [MutableBigInteger] }
    # Signed addition built upon unsigned add and subtract.
    def signed_add(addend)
      if ((@sign).equal?(1))
        add(addend)
      else
        @sign = @sign * subtract(addend)
      end
    end
    
    typesig { [SignedMutableBigInteger] }
    # Signed subtraction built upon unsigned add and subtract.
    def signed_subtract(addend)
      if ((@sign).equal?(addend.attr_sign))
        @sign = @sign * subtract(addend)
      else
        add(addend)
      end
    end
    
    typesig { [MutableBigInteger] }
    # Signed subtraction built upon unsigned add and subtract.
    def signed_subtract(addend)
      if ((@sign).equal?(1))
        @sign = @sign * subtract(addend)
      else
        add(addend)
      end
      if ((self.attr_int_len).equal?(0))
        @sign = 1
      end
    end
    
    typesig { [] }
    # Print out the first intLen ints of this MutableBigInteger's value
    # array starting at offset.
    def to_s
      b = BigInteger.new(self, @sign)
      return b.to_s
    end
    
    private
    alias_method :initialize__signed_mutable_big_integer, :initialize
  end
  
end
