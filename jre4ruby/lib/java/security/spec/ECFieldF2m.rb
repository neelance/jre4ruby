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
module Java::Security::Spec
  module ECFieldF2mImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Util, :Arrays
    }
  end
  
  # 
  # This immutable class defines an elliptic curve (EC)
  # characteristic 2 finite field.
  # 
  # @see ECField
  # 
  # @author Valerie Peng
  # 
  # @since 1.5
  class ECFieldF2m 
    include_class_members ECFieldF2mImports
    include ECField
    
    attr_accessor :m
    alias_method :attr_m, :m
    undef_method :m
    alias_method :attr_m=, :m=
    undef_method :m=
    
    attr_accessor :ks
    alias_method :attr_ks, :ks
    undef_method :ks
    alias_method :attr_ks=, :ks=
    undef_method :ks=
    
    attr_accessor :rp
    alias_method :attr_rp, :rp
    undef_method :rp
    alias_method :attr_rp=, :rp=
    undef_method :rp=
    
    typesig { [::Java::Int] }
    # 
    # Creates an elliptic curve characteristic 2 finite
    # field which has 2^<code>m</code> elements with normal basis.
    # @param m with 2^<code>m</code> being the number of elements.
    # @exception IllegalArgumentException if <code>m</code>
    # is not positive.
    def initialize(m)
      @m = 0
      @ks = nil
      @rp = nil
      if (m <= 0)
        raise IllegalArgumentException.new("m is not positive")
      end
      @m = m
      @ks = nil
      @rp = nil
    end
    
    typesig { [::Java::Int, BigInteger] }
    # 
    # Creates an elliptic curve characteristic 2 finite
    # field which has 2^<code>m</code> elements with
    # polynomial basis.
    # The reduction polynomial for this field is based
    # on <code>rp</code> whose i-th bit correspondes to
    # the i-th coefficient of the reduction polynomial.<p>
    # Note: A valid reduction polynomial is either a
    # trinomial (X^<code>m</code> + X^<code>k</code> + 1
    # with <code>m</code> > <code>k</code> >= 1) or a
    # pentanomial (X^<code>m</code> + X^<code>k3</code>
    # + X^<code>k2</code> + X^<code>k1</code> + 1 with
    # <code>m</code> > <code>k3</code> > <code>k2</code>
    # > <code>k1</code> >= 1).
    # @param m with 2^<code>m</code> being the number of elements.
    # @param rp the BigInteger whose i-th bit corresponds to
    # the i-th coefficient of the reduction polynomial.
    # @exception NullPointerException if <code>rp</code> is null.
    # @exception IllegalArgumentException if <code>m</code>
    # is not positive, or <code>rp</code> does not represent
    # a valid reduction polynomial.
    def initialize(m, rp)
      @m = 0
      @ks = nil
      @rp = nil
      # check m and rp
      @m = m
      @rp = rp
      if (m <= 0)
        raise IllegalArgumentException.new("m is not positive")
      end
      bit_count_ = @rp.bit_count
      if (!@rp.test_bit(0) || !@rp.test_bit(m) || ((!(bit_count_).equal?(3)) && (!(bit_count_).equal?(5))))
        raise IllegalArgumentException.new("rp does not represent a valid reduction polynomial")
      end
      # convert rp into ks
      temp = @rp.clear_bit(0).clear_bit(m)
      @ks = Array.typed(::Java::Int).new(bit_count_ - 2) { 0 }
      i = @ks.attr_length - 1
      while i >= 0
        index = temp.get_lowest_set_bit
        @ks[i] = index
        temp = temp.clear_bit(index)
        ((i -= 1) + 1)
      end
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Int)] }
    # 
    # Creates an elliptic curve characteristic 2 finite
    # field which has 2^<code>m</code> elements with
    # polynomial basis. The reduction polynomial for this
    # field is based on <code>ks</code> whose content
    # contains the order of the middle term(s) of the
    # reduction polynomial.
    # Note: A valid reduction polynomial is either a
    # trinomial (X^<code>m</code> + X^<code>k</code> + 1
    # with <code>m</code> > <code>k</code> >= 1) or a
    # pentanomial (X^<code>m</code> + X^<code>k3</code>
    # + X^<code>k2</code> + X^<code>k1</code> + 1 with
    # <code>m</code> > <code>k3</code> > <code>k2</code>
    # > <code>k1</code> >= 1), so <code>ks</code> should
    # have length 1 or 3.
    # @param m with 2^<code>m</code> being the number of elements.
    # @param ks the order of the middle term(s) of the
    # reduction polynomial. Contents of this array are copied
    # to protect against subsequent modification.
    # @exception NullPointerException if <code>ks</code> is null.
    # @exception IllegalArgumentException if<code>m</code>
    # is not positive, or the length of <code>ks</code>
    # is neither 1 nor 3, or values in <code>ks</code>
    # are not between <code>m</code>-1 and 1 (inclusive)
    # and in descending order.
    def initialize(m, ks)
      @m = 0
      @ks = nil
      @rp = nil
      # check m and ks
      @m = m
      @ks = ks.clone
      if (m <= 0)
        raise IllegalArgumentException.new("m is not positive")
      end
      if ((!(@ks.attr_length).equal?(1)) && (!(@ks.attr_length).equal?(3)))
        raise IllegalArgumentException.new("length of ks is neither 1 nor 3")
      end
      i = 0
      while i < @ks.attr_length
        if ((@ks[i] < 1) || (@ks[i] > m - 1))
          raise IllegalArgumentException.new("ks[" + (i).to_s + "] is out of range")
        end
        if ((!(i).equal?(0)) && (@ks[i] >= @ks[i - 1]))
          raise IllegalArgumentException.new("values in ks are not in descending order")
        end
        ((i += 1) - 1)
      end
      # convert ks into rp
      @rp = BigInteger::ONE
      @rp = @rp.set_bit(m)
      j = 0
      while j < @ks.attr_length
        @rp = @rp.set_bit(@ks[j])
        ((j += 1) - 1)
      end
    end
    
    typesig { [] }
    # 
    # Returns the field size in bits which is <code>m</code>
    # for this characteristic 2 finite field.
    # @return the field size in bits.
    def get_field_size
      return @m
    end
    
    typesig { [] }
    # 
    # Returns the value <code>m</code> of this characteristic
    # 2 finite field.
    # @return <code>m</code> with 2^<code>m</code> being the
    # number of elements.
    def get_m
      return @m
    end
    
    typesig { [] }
    # 
    # Returns a BigInteger whose i-th bit corresponds to the
    # i-th coefficient of the reduction polynomial for polynomial
    # basis or null for normal basis.
    # @return a BigInteger whose i-th bit corresponds to the
    # i-th coefficient of the reduction polynomial for polynomial
    # basis or null for normal basis.
    def get_reduction_polynomial
      return @rp
    end
    
    typesig { [] }
    # 
    # Returns an integer array which contains the order of the
    # middle term(s) of the reduction polynomial for polynomial
    # basis or null for normal basis.
    # @return an integer array which contains the order of the
    # middle term(s) of the reduction polynomial for polynomial
    # basis or null for normal basis. A new array is returned
    # each time this method is called.
    def get_mid_terms_of_reduction_polynomial
      if ((@ks).nil?)
        return nil
      else
        return @ks.clone
      end
    end
    
    typesig { [Object] }
    # 
    # Compares this finite field for equality with the
    # specified object.
    # @param obj the object to be compared.
    # @return true if <code>obj</code> is an instance
    # of ECFieldF2m and both <code>m</code> and the reduction
    # polynomial match, false otherwise.
    def equals(obj)
      if ((self).equal?(obj))
        return true
      end
      if (obj.is_a?(ECFieldF2m))
        # no need to compare rp here since ks and rp
        # should be equivalent
        return (((@m).equal?((obj).attr_m)) && ((Arrays == @ks)))
      end
      return false
    end
    
    typesig { [] }
    # 
    # Returns a hash code value for this characteristic 2
    # finite field.
    # @return a hash code value.
    def hash_code
      value = @m << 5
      value += ((@rp).nil? ? 0 : @rp.hash_code)
      # no need to involve ks here since ks and rp
      # should be equivalent.
      return value
    end
    
    private
    alias_method :initialize__ecfield_f2m, :initialize
  end
  
end
