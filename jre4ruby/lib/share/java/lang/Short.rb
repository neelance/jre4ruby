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
module Java::Lang
  module ShortImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # The {@code Short} class wraps a value of primitive type {@code
  # short} in an object.  An object of type {@code Short} contains a
  # single field whose type is {@code short}.
  # 
  # <p>In addition, this class provides several methods for converting
  # a {@code short} to a {@code String} and a {@code String} to a
  # {@code short}, as well as other constants and methods useful when
  # dealing with a {@code short}.
  # 
  # @author  Nakul Saraiya
  # @author  Joseph D. Darcy
  # @see     java.lang.Number
  # @since   JDK1.1
  class Short < ShortImports.const_get :Numeric
    include_class_members ShortImports
    overload_protected {
      include JavaComparable
    }
    
    class_module.module_eval {
      # A constant holding the minimum value a {@code short} can
      # have, -2<sup>15</sup>.
      const_set_lazy(:MIN_VALUE) { -32768 }
      const_attr_reader  :MIN_VALUE
      
      # A constant holding the maximum value a {@code short} can
      # have, 2<sup>15</sup>-1.
      const_set_lazy(:MAX_VALUE) { 32767 }
      const_attr_reader  :MAX_VALUE
      
      # The {@code Class} instance representing the primitive type
      # {@code short}.
      const_set_lazy(:TYPE) { Class.get_primitive_class("short") }
      const_attr_reader  :TYPE
      
      typesig { [::Java::Short] }
      # Returns a new {@code String} object representing the
      # specified {@code short}. The radix is assumed to be 10.
      # 
      # @param s the {@code short} to be converted
      # @return the string representation of the specified {@code short}
      # @see java.lang.Integer#toString(int)
      def to_s(s)
        return JavaInteger.to_s(RJava.cast_to_int(s), 10)
      end
      
      typesig { [String, ::Java::Int] }
      # Parses the string argument as a signed {@code short} in the
      # radix specified by the second argument. The characters in the
      # string must all be digits, of the specified radix (as
      # determined by whether {@link java.lang.Character#digit(char,
      # int)} returns a nonnegative value) except that the first
      # character may be an ASCII minus sign {@code '-'}
      # (<code>'&#92;u002D'</code>) to indicate a negative value.  The
      # resulting {@code short} value is returned.
      # 
      # <p>An exception of type {@code NumberFormatException} is
      # thrown if any of the following situations occurs:
      # <ul>
      # <li> The first argument is {@code null} or is a string of
      # length zero.
      # 
      # <li> The radix is either smaller than {@link
      # java.lang.Character#MIN_RADIX} or larger than {@link
      # java.lang.Character#MAX_RADIX}.
      # 
      # <li> Any character of the string is not a digit of the
      # specified radix, except that the first character may be a minus
      # sign {@code '-'} (<code>'&#92;u002D'</code>) provided that the
      # string is longer than length 1.
      # 
      # <li> The value represented by the string is not a value of type
      # {@code short}.
      # </ul>
      # 
      # @param s         the {@code String} containing the
      # {@code short} representation to be parsed
      # @param radix     the radix to be used while parsing {@code s}
      # @return          the {@code short} represented by the string
      # argument in the specified radix.
      # @throws          NumberFormatException If the {@code String}
      # does not contain a parsable {@code short}.
      def parse_short(s, radix)
        i = JavaInteger.parse_int(s, radix)
        if (i < MIN_VALUE || i > MAX_VALUE)
          raise NumberFormatException.new("Value out of range. Value:\"" + s + "\" Radix:" + RJava.cast_to_string(radix))
        end
        return RJava.cast_to_short(i)
      end
      
      typesig { [String] }
      # Parses the string argument as a signed decimal {@code
      # short}. The characters in the string must all be decimal
      # digits, except that the first character may be an ASCII minus
      # sign {@code '-'} (<code>'&#92;u002D'</code>) to indicate a
      # negative value.  The resulting {@code short} value is returned,
      # exactly as if the argument and the radix 10 were given as
      # arguments to the {@link #parseShort(java.lang.String, int)}
      # method.
      # 
      # @param s a {@code String} containing the {@code short}
      # representation to be parsed
      # @return  the {@code short} value represented by the
      # argument in decimal.
      # @throws  NumberFormatException If the string does not
      # contain a parsable {@code short}.
      def parse_short(s)
        return parse_short(s, 10)
      end
      
      typesig { [String, ::Java::Int] }
      # Returns a {@code Short} object holding the value
      # extracted from the specified {@code String} when parsed
      # with the radix given by the second argument. The first argument
      # is interpreted as representing a signed {@code short} in
      # the radix specified by the second argument, exactly as if the
      # argument were given to the {@link #parseShort(java.lang.String,
      # int)} method. The result is a {@code Short} object that
      # represents the {@code short} value specified by the string.
      # 
      # <p>In other words, this method returns a {@code Short} object
      # equal to the value of:
      # 
      # <blockquote>
      # {@code new Short(Short.parseShort(s, radix))}
      # </blockquote>
      # 
      # @param s         the string to be parsed
      # @param radix     the radix to be used in interpreting {@code s}
      # @return          a {@code Short} object holding the value
      # represented by the string argument in the
      # specified radix.
      # @throws          NumberFormatException If the {@code String} does
      # not contain a parsable {@code short}.
      def value_of(s, radix)
        return Short.new(parse_short(s, radix))
      end
      
      typesig { [String] }
      # Returns a {@code Short} object holding the
      # value given by the specified {@code String}. The argument
      # is interpreted as representing a signed decimal
      # {@code short}, exactly as if the argument were given to
      # the {@link #parseShort(java.lang.String)} method. The result is
      # a {@code Short} object that represents the
      # {@code short} value specified by the string.
      # 
      # <p>In other words, this method returns a {@code Short} object
      # equal to the value of:
      # 
      # <blockquote>
      # {@code new Short(Short.parseShort(s))}
      # </blockquote>
      # 
      # @param s the string to be parsed
      # @return  a {@code Short} object holding the value
      # represented by the string argument
      # @throws  NumberFormatException If the {@code String} does
      # not contain a parsable {@code short}.
      def value_of(s)
        return value_of(s, 10)
      end
      
      const_set_lazy(:ShortCache) { Class.new do
        include_class_members Short
        
        typesig { [] }
        def initialize
        end
        
        class_module.module_eval {
          const_set_lazy(:Cache) { Array.typed(class_self::Short).new(-(-128) + 127 + 1) { nil } }
          const_attr_reader  :Cache
          
          when_class_loaded do
            i = 0
            while i < self.class::Cache.attr_length
              self.class::Cache[i] = class_self::Short.new(RJava.cast_to_short((i - 128)))
              i += 1
            end
          end
        }
        
        private
        alias_method :initialize__short_cache, :initialize
      end }
      
      typesig { [::Java::Short] }
      # Returns a {@code Short} instance representing the specified
      # {@code short} value.
      # If a new {@code Short} instance is not required, this method
      # should generally be used in preference to the constructor
      # {@link #Short(short)}, as this method is likely to yield
      # significantly better space and time performance by caching
      # frequently requested values.
      # 
      # @param  s a short value.
      # @return a {@code Short} instance representing {@code s}.
      # @since  1.5
      def value_of(s)
        offset = 128
        s_as_int = s
        if (s_as_int >= -128 && s_as_int <= 127)
          # must cache
          return ShortCache.attr_cache[s_as_int + offset]
        end
        return Short.new(s)
      end
      
      typesig { [String] }
      # Decodes a {@code String} into a {@code Short}.
      # Accepts decimal, hexadecimal, and octal numbers given by
      # the following grammar:
      # 
      # <blockquote>
      # <dl>
      # <dt><i>DecodableString:</i>
      # <dd><i>Sign<sub>opt</sub> DecimalNumeral</i>
      # <dd><i>Sign<sub>opt</sub></i> {@code 0x} <i>HexDigits</i>
      # <dd><i>Sign<sub>opt</sub></i> {@code 0X} <i>HexDigits</i>
      # <dd><i>Sign<sub>opt</sub></i> {@code #} <i>HexDigits</i>
      # <dd><i>Sign<sub>opt</sub></i> {@code 0} <i>OctalDigits</i>
      # <p>
      # <dt><i>Sign:</i>
      # <dd>{@code -}
      # </dl>
      # </blockquote>
      # 
      # <i>DecimalNumeral</i>, <i>HexDigits</i>, and <i>OctalDigits</i>
      # are defined in <a href="http://java.sun.com/docs/books/jls/second_edition/html/lexical.doc.html#48282">&sect;3.10.1</a>
      # of the <a href="http://java.sun.com/docs/books/jls/html/">Java
      # Language Specification</a>.
      # 
      # <p>The sequence of characters following an (optional) negative
      # sign and/or radix specifier ("{@code 0x}", "{@code 0X}",
      # "{@code #}", or leading zero) is parsed as by the {@code
      # Short.parseShort} method with the indicated radix (10, 16, or
      # 8).  This sequence of characters must represent a positive
      # value or a {@link NumberFormatException} will be thrown.  The
      # result is negated if first character of the specified {@code
      # String} is the minus sign.  No whitespace characters are
      # permitted in the {@code String}.
      # 
      # @param     nm the {@code String} to decode.
      # @return    a {@code Short} object holding the {@code short}
      # value represented by {@code nm}
      # @throws    NumberFormatException  if the {@code String} does not
      # contain a parsable {@code short}.
      # @see java.lang.Short#parseShort(java.lang.String, int)
      def decode(nm)
        i = JavaInteger.decode(nm)
        if (i < MIN_VALUE || i > MAX_VALUE)
          raise NumberFormatException.new("Value " + RJava.cast_to_string(i) + " out of range from input " + nm)
        end
        return RJava.cast_to_short(i)
      end
    }
    
    # The value of the {@code Short}.
    # 
    # @serial
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    typesig { [::Java::Short] }
    # Constructs a newly allocated {@code Short} object that
    # represents the specified {@code short} value.
    # 
    # @param value     the value to be represented by the
    # {@code Short}.
    def initialize(value)
      @value = 0
      super()
      @value = value
    end
    
    typesig { [String] }
    # Constructs a newly allocated {@code Short} object that
    # represents the {@code short} value indicated by the
    # {@code String} parameter. The string is converted to a
    # {@code short} value in exactly the manner used by the
    # {@code parseShort} method for radix 10.
    # 
    # @param s the {@code String} to be converted to a
    # {@code Short}
    # @throws  NumberFormatException If the {@code String}
    # does not contain a parsable {@code short}.
    # @see     java.lang.Short#parseShort(java.lang.String, int)
    def initialize(s)
      @value = 0
      super()
      @value = parse_short(s, 10)
    end
    
    typesig { [] }
    # Returns the value of this {@code Short} as a
    # {@code byte}.
    def byte_value
      return @value
    end
    
    typesig { [] }
    # Returns the value of this {@code Short} as a
    # {@code short}.
    def short_value
      return @value
    end
    
    typesig { [] }
    # Returns the value of this {@code Short} as an
    # {@code int}.
    def int_value
      return RJava.cast_to_int(@value)
    end
    
    typesig { [] }
    # Returns the value of this {@code Short} as a
    # {@code long}.
    def long_value
      return @value
    end
    
    typesig { [] }
    # Returns the value of this {@code Short} as a
    # {@code float}.
    def float_value
      return (@value).to_f
    end
    
    typesig { [] }
    # Returns the value of this {@code Short} as a
    # {@code double}.
    def double_value
      return (@value).to_f
    end
    
    typesig { [] }
    # Returns a {@code String} object representing this
    # {@code Short}'s value.  The value is converted to signed
    # decimal representation and returned as a string, exactly as if
    # the {@code short} value were given as an argument to the
    # {@link java.lang.Short#toString(short)} method.
    # 
    # @return  a string representation of the value of this object in
    # base&nbsp;10.
    def to_s
      return String.value_of(RJava.cast_to_int(@value))
    end
    
    typesig { [] }
    # Returns a hash code for this {@code Short}.
    def hash_code
      return RJava.cast_to_int(@value)
    end
    
    typesig { [Object] }
    # Compares this object to the specified object.  The result is
    # {@code true} if and only if the argument is not
    # {@code null} and is a {@code Short} object that
    # contains the same {@code short} value as this object.
    # 
    # @param obj       the object to compare with
    # @return          {@code true} if the objects are the same;
    # {@code false} otherwise.
    def ==(obj)
      if (obj.is_a?(Short))
        return (@value).equal?((obj).short_value)
      end
      return false
    end
    
    typesig { [Short] }
    # Compares two {@code Short} objects numerically.
    # 
    # @param   anotherShort   the {@code Short} to be compared.
    # @return  the value {@code 0} if this {@code Short} is
    # equal to the argument {@code Short}; a value less than
    # {@code 0} if this {@code Short} is numerically less
    # than the argument {@code Short}; and a value greater than
    # {@code 0} if this {@code Short} is numerically
    # greater than the argument {@code Short} (signed
    # comparison).
    # @since   1.2
    def compare_to(another_short)
      return @value - another_short.attr_value
    end
    
    class_module.module_eval {
      # The number of bits used to represent a {@code short} value in two's
      # complement binary form.
      # @since 1.5
      const_set_lazy(:SIZE) { 16 }
      const_attr_reader  :SIZE
      
      typesig { [::Java::Short] }
      # Returns the value obtained by reversing the order of the bytes in the
      # two's complement representation of the specified {@code short} value.
      # 
      # @return the value obtained by reversing (or, equivalently, swapping)
      # the bytes in the specified {@code short} value.
      # @since 1.5
      def reverse_bytes(i)
        return RJava.cast_to_short((((i & 0xff00) >> 8) | (i << 8)))
      end
      
      # use serialVersionUID from JDK 1.1. for interoperability
      const_set_lazy(:SerialVersionUID) { 7515723908773894738 }
      const_attr_reader  :SerialVersionUID
    }
    
    private
    alias_method :initialize__short, :initialize
  end
  
end
