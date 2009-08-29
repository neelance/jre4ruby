require "rjava"

# Portions Copyright 2003-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# 
# Portions Copyright IBM Corporation, 1997, 2001. All Rights Reserved.
module Java::Math
  module MathContextImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Math
      include ::Java::Io
    }
  end
  
  # Immutable objects which encapsulate the context settings which
  # describe certain rules for numerical operators, such as those
  # implemented by the {@link BigDecimal} class.
  # 
  # <p>The base-independent settings are:
  # <ol>
  # <li>{@code precision}:
  # the number of digits to be used for an operation; results are
  # rounded to this precision
  # 
  # <li>{@code roundingMode}:
  # a {@link RoundingMode} object which specifies the algorithm to be
  # used for rounding.
  # </ol>
  # 
  # @see     BigDecimal
  # @see     RoundingMode
  # @author  Mike Cowlishaw
  # @author  Joseph D. Darcy
  # @since 1.5
  class MathContext 
    include_class_members MathContextImports
    include Serializable
    
    class_module.module_eval {
      # ----- Constants -----
      # defaults for constructors
      const_set_lazy(:DEFAULT_DIGITS) { 9 }
      const_attr_reader  :DEFAULT_DIGITS
      
      const_set_lazy(:DEFAULT_ROUNDINGMODE) { RoundingMode::HALF_UP }
      const_attr_reader  :DEFAULT_ROUNDINGMODE
      
      # Smallest values for digits (Maximum is Integer.MAX_VALUE)
      const_set_lazy(:MIN_DIGITS) { 0 }
      const_attr_reader  :MIN_DIGITS
      
      # Serialization version
      const_set_lazy(:SerialVersionUID) { 5579720004786848255 }
      const_attr_reader  :SerialVersionUID
      
      # ----- Public Properties -----
      # 
      # A {@code MathContext} object whose settings have the values
      # required for unlimited precision arithmetic.
      # The values of the settings are:
      # <code>
      # precision=0 roundingMode=HALF_UP
      # </code>
      const_set_lazy(:UNLIMITED) { MathContext.new(0, RoundingMode::HALF_UP) }
      const_attr_reader  :UNLIMITED
      
      # A {@code MathContext} object with a precision setting
      # matching the IEEE 754R Decimal32 format, 7 digits, and a
      # rounding mode of {@link RoundingMode#HALF_EVEN HALF_EVEN}, the
      # IEEE 754R default.
      const_set_lazy(:DECIMAL32) { MathContext.new(7, RoundingMode::HALF_EVEN) }
      const_attr_reader  :DECIMAL32
      
      # A {@code MathContext} object with a precision setting
      # matching the IEEE 754R Decimal64 format, 16 digits, and a
      # rounding mode of {@link RoundingMode#HALF_EVEN HALF_EVEN}, the
      # IEEE 754R default.
      const_set_lazy(:DECIMAL64) { MathContext.new(16, RoundingMode::HALF_EVEN) }
      const_attr_reader  :DECIMAL64
      
      # A {@code MathContext} object with a precision setting
      # matching the IEEE 754R Decimal128 format, 34 digits, and a
      # rounding mode of {@link RoundingMode#HALF_EVEN HALF_EVEN}, the
      # IEEE 754R default.
      const_set_lazy(:DECIMAL128) { MathContext.new(34, RoundingMode::HALF_EVEN) }
      const_attr_reader  :DECIMAL128
    }
    
    # ----- Shared Properties -----
    # 
    # The number of digits to be used for an operation.  A value of 0
    # indicates that unlimited precision (as many digits as are
    # required) will be used.  Note that leading zeros (in the
    # coefficient of a number) are never significant.
    # 
    # <p>{@code precision} will always be non-negative.
    # 
    # @serial
    attr_accessor :precision
    alias_method :attr_precision, :precision
    undef_method :precision
    alias_method :attr_precision=, :precision=
    undef_method :precision=
    
    # The rounding algorithm to be used for an operation.
    # 
    # @see RoundingMode
    # @serial
    attr_accessor :rounding_mode
    alias_method :attr_rounding_mode, :rounding_mode
    undef_method :rounding_mode
    alias_method :attr_rounding_mode=, :rounding_mode=
    undef_method :rounding_mode=
    
    # Lookaside for the rounding points (the numbers which determine
    # whether the coefficient of a number will require rounding).
    # These will be present if {@code precision > 0} and
    # {@code precision <= MAX_LOOKASIDE}.  In this case they will share the
    # {@code BigInteger int[]} array.  Note that the transients
    # cannot be {@code final} because they are reconstructed on
    # deserialization.
    attr_accessor :rounding_max
    alias_method :attr_rounding_max, :rounding_max
    undef_method :rounding_max
    alias_method :attr_rounding_max=, :rounding_max=
    undef_method :rounding_max=
    
    attr_accessor :rounding_min
    alias_method :attr_rounding_min, :rounding_min
    undef_method :rounding_min
    alias_method :attr_rounding_min=, :rounding_min=
    undef_method :rounding_min=
    
    class_module.module_eval {
      const_set_lazy(:MAX_LOOKASIDE) { 1000 }
      const_attr_reader  :MAX_LOOKASIDE
    }
    
    typesig { [::Java::Int] }
    # ----- Constructors -----
    # 
    # Constructs a new {@code MathContext} with the specified
    # precision and the {@link RoundingMode#HALF_UP HALF_UP} rounding
    # mode.
    # 
    # @param setPrecision The non-negative {@code int} precision setting.
    # @throws IllegalArgumentException if the {@code setPrecision} parameter is less
    # than zero.
    def initialize(set_precision)
      initialize__math_context(set_precision, DEFAULT_ROUNDINGMODE)
      return
    end
    
    typesig { [::Java::Int, RoundingMode] }
    # Constructs a new {@code MathContext} with a specified
    # precision and rounding mode.
    # 
    # @param setPrecision The non-negative {@code int} precision setting.
    # @param setRoundingMode The rounding mode to use.
    # @throws IllegalArgumentException if the {@code setPrecision} parameter is less
    # than zero.
    # @throws NullPointerException if the rounding mode argument is {@code null}
    def initialize(set_precision, set_rounding_mode)
      @precision = 0
      @rounding_mode = nil
      @rounding_max = nil
      @rounding_min = nil
      if (set_precision < MIN_DIGITS)
        raise IllegalArgumentException.new("Digits < 0")
      end
      if ((set_rounding_mode).nil?)
        raise NullPointerException.new("null RoundingMode")
      end
      @precision = set_precision
      if (@precision > 0 && @precision <= MAX_LOOKASIDE)
        @rounding_max = BigInteger::TEN.pow(@precision)
        @rounding_min = @rounding_max.negate
      end
      @rounding_mode = set_rounding_mode
      return
    end
    
    typesig { [String] }
    # Constructs a new {@code MathContext} from a string.
    # 
    # The string must be in the same format as that produced by the
    # {@link #toString} method.
    # 
    # <p>An {@code IllegalArgumentException} is thrown if the precision
    # section of the string is out of range ({@code < 0}) or the string is
    # not in the format created by the {@link #toString} method.
    # 
    # @param val The string to be parsed
    # @throws IllegalArgumentException if the precision section is out of range
    # or of incorrect format
    # @throws NullPointerException if the argument is {@code null}
    def initialize(val)
      @precision = 0
      @rounding_mode = nil
      @rounding_max = nil
      @rounding_min = nil
      bad = false
      set_precision = 0
      if ((val).nil?)
        raise NullPointerException.new("null String")
      end
      begin
        # any error here is a string format problem
        if (!val.starts_with("precision="))
          raise RuntimeException.new
        end
        fence = val.index_of(Character.new(?\s.ord)) # could be -1
        off = 10 # where value starts
        set_precision = JavaInteger.parse_int(val.substring(10, fence))
        if (!val.starts_with("roundingMode=", fence + 1))
          raise RuntimeException.new
        end
        off = fence + 1 + 13
        str = val.substring(off, val.length)
        @rounding_mode = RoundingMode.value_of(str)
      rescue RuntimeException => re
        raise IllegalArgumentException.new("bad string format")
      end
      if (set_precision < MIN_DIGITS)
        raise IllegalArgumentException.new("Digits < 0")
      end
      # the other parameters cannot be invalid if we got here
      @precision = set_precision
      if (@precision > 0 && @precision <= MAX_LOOKASIDE)
        @rounding_max = BigInteger::TEN.pow(@precision)
        @rounding_min = @rounding_max.negate
      end
    end
    
    typesig { [] }
    # Returns the {@code precision} setting.
    # This value is always non-negative.
    # 
    # @return an {@code int} which is the value of the {@code precision}
    # setting
    def get_precision
      return @precision
    end
    
    typesig { [] }
    # Returns the roundingMode setting.
    # This will be one of
    # {@link  RoundingMode#CEILING},
    # {@link  RoundingMode#DOWN},
    # {@link  RoundingMode#FLOOR},
    # {@link  RoundingMode#HALF_DOWN},
    # {@link  RoundingMode#HALF_EVEN},
    # {@link  RoundingMode#HALF_UP},
    # {@link  RoundingMode#UNNECESSARY}, or
    # {@link  RoundingMode#UP}.
    # 
    # @return a {@code RoundingMode} object which is the value of the
    # {@code roundingMode} setting
    def get_rounding_mode
      return @rounding_mode
    end
    
    typesig { [Object] }
    # Compares this {@code MathContext} with the specified
    # {@code Object} for equality.
    # 
    # @param  x {@code Object} to which this {@code MathContext} is to
    # be compared.
    # @return {@code true} if and only if the specified {@code Object} is
    # a {@code MathContext} object which has exactly the same
    # settings as this object
    def ==(x)
      mc = nil
      if (!(x.is_a?(MathContext)))
        return false
      end
      mc = x
      return (mc.attr_precision).equal?(@precision) && (mc.attr_rounding_mode).equal?(@rounding_mode) # no need for .equals()
    end
    
    typesig { [] }
    # Returns the hash code for this {@code MathContext}.
    # 
    # @return hash code for this {@code MathContext}
    def hash_code
      return @precision + @rounding_mode.hash_code * 59
    end
    
    typesig { [] }
    # Returns the string representation of this {@code MathContext}.
    # The {@code String} returned represents the settings of the
    # {@code MathContext} object as two space-delimited words
    # (separated by a single space character, <tt>'&#92;u0020'</tt>,
    # and with no leading or trailing white space), as follows:
    # <ol>
    # <li>
    # The string {@code "precision="}, immediately followed
    # by the value of the precision setting as a numeric string as if
    # generated by the {@link Integer#toString(int) Integer.toString}
    # method.
    # 
    # <li>
    # The string {@code "roundingMode="}, immediately
    # followed by the value of the {@code roundingMode} setting as a
    # word.  This word will be the same as the name of the
    # corresponding public constant in the {@link RoundingMode}
    # enum.
    # </ol>
    # <p>
    # For example:
    # <pre>
    # precision=9 roundingMode=HALF_UP
    # </pre>
    # 
    # Additional words may be appended to the result of
    # {@code toString} in the future if more properties are added to
    # this class.
    # 
    # @return a {@code String} representing the context settings
    def to_s
      return "precision=" + RJava.cast_to_string(@precision) + " " + "roundingMode=" + RJava.cast_to_string(@rounding_mode.to_s)
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Private methods
    # 
    # Reconstitute the {@code MathContext} instance from a stream (that is,
    # deserialize it).
    # 
    # @param s the stream being read.
    def read_object(s)
      s.default_read_object # read in all fields
      # validate possibly bad fields
      if (@precision < MIN_DIGITS)
        message = "MathContext: invalid digits in stream"
        raise Java::Io::StreamCorruptedException.new(message)
      end
      if ((@rounding_mode).nil?)
        message = "MathContext: null roundingMode in stream"
        raise Java::Io::StreamCorruptedException.new(message)
      end
      # Set the lookaside, if applicable
      if (@precision <= MAX_LOOKASIDE)
        @rounding_max = BigInteger::TEN.pow(@precision)
        @rounding_min = @rounding_max.negate
      end
    end
    
    private
    alias_method :initialize__math_context, :initialize
  end
  
end
