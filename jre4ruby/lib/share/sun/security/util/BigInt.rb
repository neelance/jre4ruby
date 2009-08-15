require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Util
  module BigIntImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # A low-overhead arbitrary-precision <em>unsigned</em> integer.
  # This is intended for use with ASN.1 parsing, and printing of
  # such parsed values.  Convert to "BigInteger" if you need to do
  # arbitrary precision arithmetic, rather than just represent
  # the number as a wrapped array of bytes.
  # 
  # <P><em><b>NOTE:</b>  This class may eventually disappear, to
  # be supplanted by big-endian byte arrays which hold both signed
  # and unsigned arbitrary-precision integers.</em>
  # 
  # @author David Brownell
  class BigInt 
    include_class_members BigIntImports
    
    # Big endian -- MSB first.
    attr_accessor :places
    alias_method :attr_places, :places
    undef_method :places
    alias_method :attr_places=, :places=
    undef_method :places=
    
    typesig { [Array.typed(::Java::Byte)] }
    # Constructs a "Big" integer from a set of (big-endian) bytes.
    # Leading zeroes should be stripped off.
    # 
    # @param data a sequence of bytes, most significant bytes/digits
    # first.  CONSUMED.
    def initialize(data)
      @places = nil
      @places = data.clone
    end
    
    typesig { [BigInteger] }
    # Constructs a "Big" integer from a "BigInteger", which must be
    # positive (or zero) in value.
    def initialize(i)
      @places = nil
      temp = i.to_byte_array
      if (!((temp[0] & 0x80)).equal?(0))
        raise IllegalArgumentException.new("negative BigInteger")
      end
      # XXX we assume exactly _one_ sign byte is used...
      if (!(temp[0]).equal?(0))
        @places = temp
      else
        @places = Array.typed(::Java::Byte).new(temp.attr_length - 1) { 0 }
        j = 1
        while j < temp.attr_length
          @places[j - 1] = temp[j]
          j += 1
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Constructs a "Big" integer from a normal Java integer.
    # 
    # @param i the java primitive integer
    def initialize(i)
      @places = nil
      if (i < (1 << 8))
        @places = Array.typed(::Java::Byte).new(1) { 0 }
        @places[0] = i
      else
        if (i < (1 << 16))
          @places = Array.typed(::Java::Byte).new(2) { 0 }
          @places[0] = (i >> 8)
          @places[1] = i
        else
          if (i < (1 << 24))
            @places = Array.typed(::Java::Byte).new(3) { 0 }
            @places[0] = (i >> 16)
            @places[1] = (i >> 8)
            @places[2] = i
          else
            @places = Array.typed(::Java::Byte).new(4) { 0 }
            @places[0] = (i >> 24)
            @places[1] = (i >> 16)
            @places[2] = (i >> 8)
            @places[3] = i
          end
        end
      end
    end
    
    typesig { [] }
    # Converts the "big" integer to a java primitive integer.
    # 
    # @excpet NumberFormatException if 32 bits is insufficient.
    def to_int
      if (@places.attr_length > 4)
        raise NumberFormatException.new("BigInt.toLong, too big")
      end
      retval = 0
      i = 0
      while i < @places.attr_length
        retval = (retval << 8) + (RJava.cast_to_int(@places[i]) & 0xff)
        i += 1
      end
      return retval
    end
    
    typesig { [] }
    # Returns a hexadecimal printed representation.  The value is
    # formatted to fit on lines of at least 75 characters, with
    # embedded newlines.  Words are separated for readability,
    # with eight words (32 bytes) per line.
    def to_s
      return hexify
    end
    
    typesig { [] }
    # Returns a BigInteger value which supports many arithmetic
    # operations. Assumes negative values will never occur.
    def to_big_integer
      return BigInteger.new(1, @places)
    end
    
    typesig { [] }
    # Returns the data as a byte array.  The most significant bit
    # of the array is bit zero (as in <code>java.math.BigInteger</code>).
    def to_byte_array
      return @places.clone
    end
    
    class_module.module_eval {
      const_set_lazy(:Digits) { "0123456789abcdef" }
      const_attr_reader  :Digits
    }
    
    typesig { [] }
    def hexify
      if ((@places.attr_length).equal?(0))
        return "  0  "
      end
      buf = StringBuffer.new(@places.attr_length * 2)
      buf.append("    ") # four spaces
      i = 0
      while i < @places.attr_length
        buf.append(Digits.char_at((@places[i] >> 4) & 0xf))
        buf.append(Digits.char_at(@places[i] & 0xf))
        if ((((i + 1) % 32)).equal?(0))
          if (!((i + 1)).equal?(@places.attr_length))
            buf.append("\n    ")
          end # line after four words
        else
          if ((((i + 1) % 4)).equal?(0))
            buf.append(Character.new(?\s.ord))
          end
        end # space between words
        i += 1
      end
      return buf.to_s
    end
    
    typesig { [Object] }
    # Returns true iff the parameter is a numerically equivalent
    # BigInt.
    # 
    # @param other the object being compared with this one.
    def ==(other)
      if (other.is_a?(BigInt))
        return self.==(other)
      end
      return false
    end
    
    typesig { [BigInt] }
    # Returns true iff the parameter is numerically equivalent.
    # 
    # @param other the BigInt being compared with this one.
    def ==(other)
      if ((self).equal?(other))
        return true
      end
      other_places = other.to_byte_array
      if (!(@places.attr_length).equal?(other_places.attr_length))
        return false
      end
      i = 0
      while i < @places.attr_length
        if (!(@places[i]).equal?(other_places[i]))
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [] }
    # Returns a hashcode for this BigInt.
    # 
    # @return a hashcode for this BigInt.
    def hash_code
      return hexify.hash_code
    end
    
    private
    alias_method :initialize__big_int, :initialize
  end
  
end
