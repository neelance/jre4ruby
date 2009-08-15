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
  module ECParameterSpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # This immutable class specifies the set of domain parameters
  # used with elliptic curve cryptography (ECC).
  # 
  # @see AlgorithmParameterSpec
  # 
  # @author Valerie Peng
  # 
  # @since 1.5
  class ECParameterSpec 
    include_class_members ECParameterSpecImports
    include AlgorithmParameterSpec
    
    attr_accessor :curve
    alias_method :attr_curve, :curve
    undef_method :curve
    alias_method :attr_curve=, :curve=
    undef_method :curve=
    
    attr_accessor :g
    alias_method :attr_g, :g
    undef_method :g
    alias_method :attr_g=, :g=
    undef_method :g=
    
    attr_accessor :n
    alias_method :attr_n, :n
    undef_method :n
    alias_method :attr_n=, :n=
    undef_method :n=
    
    attr_accessor :h
    alias_method :attr_h, :h
    undef_method :h
    alias_method :attr_h=, :h=
    undef_method :h=
    
    typesig { [EllipticCurve, ECPoint, BigInteger, ::Java::Int] }
    # Creates elliptic curve domain parameters based on the
    # specified values.
    # @param curve the elliptic curve which this parameter
    # defines.
    # @param g the generator which is also known as the base point.
    # @param n the order of the generator <code>g</code>.
    # @param h the cofactor.
    # @exception NullPointerException if <code>curve</code>,
    # <code>g</code>, or <code>n</code> is null.
    # @exception IllegalArgumentException if <code>n</code>
    # or <code>h</code> is not positive.
    def initialize(curve, g, n, h)
      @curve = nil
      @g = nil
      @n = nil
      @h = 0
      if ((curve).nil?)
        raise NullPointerException.new("curve is null")
      end
      if ((g).nil?)
        raise NullPointerException.new("g is null")
      end
      if ((n).nil?)
        raise NullPointerException.new("n is null")
      end
      if (!(n.signum).equal?(1))
        raise IllegalArgumentException.new("n is not positive")
      end
      if (h <= 0)
        raise IllegalArgumentException.new("h is not positive")
      end
      @curve = curve
      @g = g
      @n = n
      @h = h
    end
    
    typesig { [] }
    # Returns the elliptic curve that this parameter defines.
    # @return the elliptic curve that this parameter defines.
    def get_curve
      return @curve
    end
    
    typesig { [] }
    # Returns the generator which is also known as the base point.
    # @return the generator which is also known as the base point.
    def get_generator
      return @g
    end
    
    typesig { [] }
    # Returns the order of the generator.
    # @return the order of the generator.
    def get_order
      return @n
    end
    
    typesig { [] }
    # Returns the cofactor.
    # @return the cofactor.
    def get_cofactor
      return @h
    end
    
    private
    alias_method :initialize__ecparameter_spec, :initialize
  end
  
end
