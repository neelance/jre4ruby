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
module Java::Security::Spec
  module ECPointImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # This immutable class represents a point on an elliptic curve (EC)
  # in affine coordinates. Other coordinate systems can
  # extend this class to represent this point in other
  # coordinates.
  # 
  # @author Valerie Peng
  # 
  # @since 1.5
  class ECPoint 
    include_class_members ECPointImports
    
    attr_accessor :x
    alias_method :attr_x, :x
    undef_method :x
    alias_method :attr_x=, :x=
    undef_method :x=
    
    attr_accessor :y
    alias_method :attr_y, :y
    undef_method :y
    alias_method :attr_y=, :y=
    undef_method :y=
    
    class_module.module_eval {
      # This defines the point at infinity.
      const_set_lazy(:POINT_INFINITY) { ECPoint.new }
      const_attr_reader  :POINT_INFINITY
    }
    
    typesig { [] }
    # private constructor for constructing point at infinity
    def initialize
      @x = nil
      @y = nil
      @x = nil
      @y = nil
    end
    
    typesig { [BigInteger, BigInteger] }
    # Creates an ECPoint from the specified affine x-coordinate
    # <code>x</code> and affine y-coordinate <code>y</code>.
    # @param x the affine x-coordinate.
    # @param y the affine y-coordinate.
    # @exception NullPointerException if <code>x</code> or
    # <code>y</code> is null.
    def initialize(x, y)
      @x = nil
      @y = nil
      if (((x).nil?) || ((y).nil?))
        raise NullPointerException.new("affine coordinate x or y is null")
      end
      @x = x
      @y = y
    end
    
    typesig { [] }
    # Returns the affine x-coordinate <code>x</code>.
    # Note: POINT_INFINITY has a null affine x-coordinate.
    # @return the affine x-coordinate.
    def get_affine_x
      return @x
    end
    
    typesig { [] }
    # Returns the affine y-coordinate <code>y</code>.
    # Note: POINT_INFINITY has a null affine y-coordinate.
    # @return the affine y-coordinate.
    def get_affine_y
      return @y
    end
    
    typesig { [Object] }
    # Compares this elliptic curve point for equality with
    # the specified object.
    # @param obj the object to be compared.
    # @return true if <code>obj</code> is an instance of
    # ECPoint and the affine coordinates match, false otherwise.
    def equals(obj)
      if ((self).equal?(obj))
        return true
      end
      if ((self).equal?(POINT_INFINITY))
        return false
      end
      if (obj.is_a?(ECPoint))
        return (((@x == (obj).attr_x)) && ((@y == (obj).attr_y)))
      end
      return false
    end
    
    typesig { [] }
    # Returns a hash code value for this elliptic curve point.
    # @return a hash code value.
    def hash_code
      if ((self).equal?(POINT_INFINITY))
        return 0
      end
      return @x.hash_code << 5 + @y.hash_code
    end
    
    private
    alias_method :initialize__ecpoint, :initialize
  end
  
end
