require "rjava"

# 
# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security::Spec
  module EllipticCurveImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Util, :Arrays
    }
  end
  
  # 
  # This immutable class holds the necessary values needed to represent
  # an elliptic curve.
  # 
  # @see ECField
  # @see ECFieldFp
  # @see ECFieldF2m
  # 
  # @author Valerie Peng
  # 
  # @since 1.5
  class EllipticCurve 
    include_class_members EllipticCurveImports
    
    attr_accessor :field
    alias_method :attr_field, :field
    undef_method :field
    alias_method :attr_field=, :field=
    undef_method :field=
    
    attr_accessor :a
    alias_method :attr_a, :a
    undef_method :a
    alias_method :attr_a=, :a=
    undef_method :a=
    
    attr_accessor :b
    alias_method :attr_b, :b
    undef_method :b
    alias_method :attr_b=, :b=
    undef_method :b=
    
    attr_accessor :seed
    alias_method :attr_seed, :seed
    undef_method :seed
    alias_method :attr_seed=, :seed=
    undef_method :seed=
    
    class_module.module_eval {
      typesig { [ECField, BigInteger, String] }
      # Check coefficient c is a valid element in ECField field.
      def check_validity(field, c, c_name)
        # can only perform check if field is ECFieldFp or ECFieldF2m.
        if (field.is_a?(ECFieldFp))
          p = (field).get_p
          if (!((p <=> c)).equal?(1))
            raise IllegalArgumentException.new(c_name + " is too large")
          else
            if (c.signum < 0)
              raise IllegalArgumentException.new(c_name + " is negative")
            end
          end
        else
          if (field.is_a?(ECFieldF2m))
            m = (field).get_m
            if (c.bit_length > m)
              raise IllegalArgumentException.new(c_name + " is too large")
            end
          end
        end
      end
    }
    
    typesig { [ECField, BigInteger, BigInteger] }
    # 
    # Creates an elliptic curve with the specified elliptic field
    # <code>field</code> and the coefficients <code>a</code> and
    # <code>b</code>.
    # @param field the finite field that this elliptic curve is over.
    # @param a the first coefficient of this elliptic curve.
    # @param b the second coefficient of this elliptic curve.
    # @exception NullPointerException if <code>field</code>,
    # <code>a</code>, or <code>b</code> is null.
    # @exception IllegalArgumentException if <code>a</code>
    # or <code>b</code> is not null and not in <code>field</code>.
    def initialize(field, a, b)
      initialize__elliptic_curve(field, a, b, nil)
    end
    
    typesig { [ECField, BigInteger, BigInteger, Array.typed(::Java::Byte)] }
    # 
    # Creates an elliptic curve with the specified elliptic field
    # <code>field</code>, the coefficients <code>a</code> and
    # <code>b</code>, and the <code>seed</code> used for curve generation.
    # @param field the finite field that this elliptic curve is over.
    # @param a the first coefficient of this elliptic curve.
    # @param b the second coefficient of this elliptic curve.
    # @param seed the bytes used during curve generation for later
    # validation. Contents of this array are copied to protect against
    # subsequent modification.
    # @exception NullPointerException if <code>field</code>,
    # <code>a</code>, or <code>b</code> is null.
    # @exception IllegalArgumentException if <code>a</code>
    # or <code>b</code> is not null and not in <code>field</code>.
    def initialize(field, a, b, seed)
      @field = nil
      @a = nil
      @b = nil
      @seed = nil
      if ((field).nil?)
        raise NullPointerException.new("field is null")
      end
      if ((a).nil?)
        raise NullPointerException.new("first coefficient is null")
      end
      if ((b).nil?)
        raise NullPointerException.new("second coefficient is null")
      end
      check_validity(field, a, "first coefficient")
      check_validity(field, b, "second coefficient")
      @field = field
      @a = a
      @b = b
      if (!(seed).nil?)
        @seed = seed.clone
      else
        @seed = nil
      end
    end
    
    typesig { [] }
    # 
    # Returns the finite field <code>field</code> that this
    # elliptic curve is over.
    # @return the field <code>field</code> that this curve
    # is over.
    def get_field
      return @field
    end
    
    typesig { [] }
    # 
    # Returns the first coefficient <code>a</code> of the
    # elliptic curve.
    # @return the first coefficient <code>a</code>.
    def get_a
      return @a
    end
    
    typesig { [] }
    # 
    # Returns the second coefficient <code>b</code> of the
    # elliptic curve.
    # @return the second coefficient <code>b</code>.
    def get_b
      return @b
    end
    
    typesig { [] }
    # 
    # Returns the seeding bytes <code>seed</code> used
    # during curve generation. May be null if not specified.
    # @return the seeding bytes <code>seed</code>. A new
    # array is returned each time this method is called.
    def get_seed
      if ((@seed).nil?)
        return nil
      else
        return @seed.clone
      end
    end
    
    typesig { [Object] }
    # 
    # Compares this elliptic curve for equality with the
    # specified object.
    # @param obj the object to be compared.
    # @return true if <code>obj</code> is an instance of
    # EllipticCurve and the field, A, B, and seeding bytes
    # match, false otherwise.
    def equals(obj)
      if ((self).equal?(obj))
        return true
      end
      if (obj.is_a?(EllipticCurve))
        curve = obj
        if (((@field == curve.attr_field)) && ((@a == curve.attr_a)) && ((@b == curve.attr_b)) && ((Arrays == @seed)))
          return true
        end
      end
      return false
    end
    
    typesig { [] }
    # 
    # Returns a hash code value for this elliptic curve.
    # @return a hash code value.
    def hash_code
      return (@field.hash_code << 6 + (@a.hash_code << 4) + (@b.hash_code << 2) + ((@seed).nil? ? 0 : @seed.attr_length))
    end
    
    private
    alias_method :initialize__elliptic_curve, :initialize
  end
  
end
