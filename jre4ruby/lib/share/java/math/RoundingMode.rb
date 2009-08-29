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
# Portions Copyright IBM Corporation, 2001. All Rights Reserved.
module Java::Math
  module RoundingModeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Math
    }
  end
  
  # Specifies a <i>rounding behavior</i> for numerical operations
  # capable of discarding precision. Each rounding mode indicates how
  # the least significant returned digit of a rounded result is to be
  # calculated.  If fewer digits are returned than the digits needed to
  # represent the exact numerical result, the discarded digits will be
  # referred to as the <i>discarded fraction</i> regardless the digits'
  # contribution to the value of the number.  In other words,
  # considered as a numerical value, the discarded fraction could have
  # an absolute value greater than one.
  # 
  # <p>Each rounding mode description includes a table listing how
  # different two-digit decimal values would round to a one digit
  # decimal value under the rounding mode in question.  The result
  # column in the tables could be gotten by creating a
  # {@code BigDecimal} number with the specified value, forming a
  # {@link MathContext} object with the proper settings
  # ({@code precision} set to {@code 1}, and the
  # {@code roundingMode} set to the rounding mode in question), and
  # calling {@link BigDecimal#round round} on this number with the
  # proper {@code MathContext}.  A summary table showing the results
  # of these rounding operations for all rounding modes appears below.
  # 
  # <p>
  # <table border>
  # <caption top><h3>Summary of Rounding Operations Under Different Rounding Modes</h3></caption>
  # <tr><th></th><th colspan=8>Result of rounding input to one digit with the given
  # rounding mode</th>
  # <tr valign=top>
  # <th>Input Number</th>         <th>{@code UP}</th>
  # <th>{@code DOWN}</th>
  # <th>{@code CEILING}</th>
  # <th>{@code FLOOR}</th>
  # <th>{@code HALF_UP}</th>
  # <th>{@code HALF_DOWN}</th>
  # <th>{@code HALF_EVEN}</th>
  # <th>{@code UNNECESSARY}</th>
  # 
  # <tr align=right><td>5.5</td>  <td>6</td>  <td>5</td>    <td>6</td>    <td>5</td>  <td>6</td>      <td>5</td>       <td>6</td>       <td>throw {@code ArithmeticException}</td>
  # <tr align=right><td>2.5</td>  <td>3</td>  <td>2</td>    <td>3</td>    <td>2</td>  <td>3</td>      <td>2</td>       <td>2</td>       <td>throw {@code ArithmeticException}</td>
  # <tr align=right><td>1.6</td>  <td>2</td>  <td>1</td>    <td>2</td>    <td>1</td>  <td>2</td>      <td>2</td>       <td>2</td>       <td>throw {@code ArithmeticException}</td>
  # <tr align=right><td>1.1</td>  <td>2</td>  <td>1</td>    <td>2</td>    <td>1</td>  <td>1</td>      <td>1</td>       <td>1</td>       <td>throw {@code ArithmeticException}</td>
  # <tr align=right><td>1.0</td>  <td>1</td>  <td>1</td>    <td>1</td>    <td>1</td>  <td>1</td>      <td>1</td>       <td>1</td>       <td>1</td>
  # <tr align=right><td>-1.0</td> <td>-1</td> <td>-1</td>   <td>-1</td>   <td>-1</td> <td>-1</td>     <td>-1</td>      <td>-1</td>      <td>-1</td>
  # <tr align=right><td>-1.1</td> <td>-2</td> <td>-1</td>   <td>-1</td>   <td>-2</td> <td>-1</td>     <td>-1</td>      <td>-1</td>      <td>throw {@code ArithmeticException}</td>
  # <tr align=right><td>-1.6</td> <td>-2</td> <td>-1</td>   <td>-1</td>   <td>-2</td> <td>-2</td>     <td>-2</td>      <td>-2</td>      <td>throw {@code ArithmeticException}</td>
  # <tr align=right><td>-2.5</td> <td>-3</td> <td>-2</td>   <td>-2</td>   <td>-3</td> <td>-3</td>     <td>-2</td>      <td>-2</td>      <td>throw {@code ArithmeticException}</td>
  # <tr align=right><td>-5.5</td> <td>-6</td> <td>-5</td>   <td>-5</td>   <td>-6</td> <td>-6</td>     <td>-5</td>      <td>-6</td>      <td>throw {@code ArithmeticException}</td>
  # </table>
  # 
  # 
  # <p>This {@code enum} is intended to replace the integer-based
  # enumeration of rounding mode constants in {@link BigDecimal}
  # ({@link BigDecimal#ROUND_UP}, {@link BigDecimal#ROUND_DOWN},
  # etc. ).
  # 
  # @see     BigDecimal
  # @see     MathContext
  # @author  Josh Bloch
  # @author  Mike Cowlishaw
  # @author  Joseph D. Darcy
  # @since 1.5
  class RoundingMode 
    include_class_members RoundingModeImports
    
    class_module.module_eval {
      # Rounding mode to round away from zero.  Always increments the
      # digit prior to a non-zero discarded fraction.  Note that this
      # rounding mode never decreases the magnitude of the calculated
      # value.
      # 
      # <p>Example:
      # <table border>
      # <tr valign=top><th>Input Number</th>
      # <th>Input rounded to one digit<br> with {@code UP} rounding
      # <tr align=right><td>5.5</td>  <td>6</td>
      # <tr align=right><td>2.5</td>  <td>3</td>
      # <tr align=right><td>1.6</td>  <td>2</td>
      # <tr align=right><td>1.1</td>  <td>2</td>
      # <tr align=right><td>1.0</td>  <td>1</td>
      # <tr align=right><td>-1.0</td> <td>-1</td>
      # <tr align=right><td>-1.1</td> <td>-2</td>
      # <tr align=right><td>-1.6</td> <td>-2</td>
      # <tr align=right><td>-2.5</td> <td>-3</td>
      # <tr align=right><td>-5.5</td> <td>-6</td>
      # </table>
      const_set_lazy(:UP) { RoundingMode.new(BigDecimal::ROUND_UP).set_value_name("UP") }
      const_attr_reader  :UP
      
      # Rounding mode to round towards zero.  Never increments the digit
      # prior to a discarded fraction (i.e., truncates).  Note that this
      # rounding mode never increases the magnitude of the calculated value.
      # 
      # <p>Example:
      # <table border>
      # <tr valign=top><th>Input Number</th>
      # <th>Input rounded to one digit<br> with {@code DOWN} rounding
      # <tr align=right><td>5.5</td>  <td>5</td>
      # <tr align=right><td>2.5</td>  <td>2</td>
      # <tr align=right><td>1.6</td>  <td>1</td>
      # <tr align=right><td>1.1</td>  <td>1</td>
      # <tr align=right><td>1.0</td>  <td>1</td>
      # <tr align=right><td>-1.0</td> <td>-1</td>
      # <tr align=right><td>-1.1</td> <td>-1</td>
      # <tr align=right><td>-1.6</td> <td>-1</td>
      # <tr align=right><td>-2.5</td> <td>-2</td>
      # <tr align=right><td>-5.5</td> <td>-5</td>
      # </table>
      const_set_lazy(:DOWN) { RoundingMode.new(BigDecimal::ROUND_DOWN).set_value_name("DOWN") }
      const_attr_reader  :DOWN
      
      # Rounding mode to round towards positive infinity.  If the
      # result is positive, behaves as for {@code RoundingMode.UP};
      # if negative, behaves as for {@code RoundingMode.DOWN}.  Note
      # that this rounding mode never decreases the calculated value.
      # 
      # <p>Example:
      # <table border>
      # <tr valign=top><th>Input Number</th>
      # <th>Input rounded to one digit<br> with {@code CEILING} rounding
      # <tr align=right><td>5.5</td>  <td>6</td>
      # <tr align=right><td>2.5</td>  <td>3</td>
      # <tr align=right><td>1.6</td>  <td>2</td>
      # <tr align=right><td>1.1</td>  <td>2</td>
      # <tr align=right><td>1.0</td>  <td>1</td>
      # <tr align=right><td>-1.0</td> <td>-1</td>
      # <tr align=right><td>-1.1</td> <td>-1</td>
      # <tr align=right><td>-1.6</td> <td>-1</td>
      # <tr align=right><td>-2.5</td> <td>-2</td>
      # <tr align=right><td>-5.5</td> <td>-5</td>
      # </table>
      const_set_lazy(:CEILING) { RoundingMode.new(BigDecimal::ROUND_CEILING).set_value_name("CEILING") }
      const_attr_reader  :CEILING
      
      # Rounding mode to round towards negative infinity.  If the
      # result is positive, behave as for {@code RoundingMode.DOWN};
      # if negative, behave as for {@code RoundingMode.UP}.  Note that
      # this rounding mode never increases the calculated value.
      # 
      # <p>Example:
      # <table border>
      # <tr valign=top><th>Input Number</th>
      # <th>Input rounded to one digit<br> with {@code FLOOR} rounding
      # <tr align=right><td>5.5</td>  <td>5</td>
      # <tr align=right><td>2.5</td>  <td>2</td>
      # <tr align=right><td>1.6</td>  <td>1</td>
      # <tr align=right><td>1.1</td>  <td>1</td>
      # <tr align=right><td>1.0</td>  <td>1</td>
      # <tr align=right><td>-1.0</td> <td>-1</td>
      # <tr align=right><td>-1.1</td> <td>-2</td>
      # <tr align=right><td>-1.6</td> <td>-2</td>
      # <tr align=right><td>-2.5</td> <td>-3</td>
      # <tr align=right><td>-5.5</td> <td>-6</td>
      # </table>
      const_set_lazy(:FLOOR) { RoundingMode.new(BigDecimal::ROUND_FLOOR).set_value_name("FLOOR") }
      const_attr_reader  :FLOOR
      
      # Rounding mode to round towards {@literal "nearest neighbor"}
      # unless both neighbors are equidistant, in which case round up.
      # Behaves as for {@code RoundingMode.UP} if the discarded
      # fraction is &ge; 0.5; otherwise, behaves as for
      # {@code RoundingMode.DOWN}.  Note that this is the rounding
      # mode commonly taught at school.
      # 
      # <p>Example:
      # <table border>
      # <tr valign=top><th>Input Number</th>
      # <th>Input rounded to one digit<br> with {@code HALF_UP} rounding
      # <tr align=right><td>5.5</td>  <td>6</td>
      # <tr align=right><td>2.5</td>  <td>3</td>
      # <tr align=right><td>1.6</td>  <td>2</td>
      # <tr align=right><td>1.1</td>  <td>1</td>
      # <tr align=right><td>1.0</td>  <td>1</td>
      # <tr align=right><td>-1.0</td> <td>-1</td>
      # <tr align=right><td>-1.1</td> <td>-1</td>
      # <tr align=right><td>-1.6</td> <td>-2</td>
      # <tr align=right><td>-2.5</td> <td>-3</td>
      # <tr align=right><td>-5.5</td> <td>-6</td>
      # </table>
      const_set_lazy(:HALF_UP) { RoundingMode.new(BigDecimal::ROUND_HALF_UP).set_value_name("HALF_UP") }
      const_attr_reader  :HALF_UP
      
      # Rounding mode to round towards {@literal "nearest neighbor"}
      # unless both neighbors are equidistant, in which case round
      # down.  Behaves as for {@code RoundingMode.UP} if the discarded
      # fraction is &gt; 0.5; otherwise, behaves as for
      # {@code RoundingMode.DOWN}.
      # 
      # <p>Example:
      # <table border>
      # <tr valign=top><th>Input Number</th>
      # <th>Input rounded to one digit<br> with {@code HALF_DOWN} rounding
      # <tr align=right><td>5.5</td>  <td>5</td>
      # <tr align=right><td>2.5</td>  <td>2</td>
      # <tr align=right><td>1.6</td>  <td>2</td>
      # <tr align=right><td>1.1</td>  <td>1</td>
      # <tr align=right><td>1.0</td>  <td>1</td>
      # <tr align=right><td>-1.0</td> <td>-1</td>
      # <tr align=right><td>-1.1</td> <td>-1</td>
      # <tr align=right><td>-1.6</td> <td>-2</td>
      # <tr align=right><td>-2.5</td> <td>-2</td>
      # <tr align=right><td>-5.5</td> <td>-5</td>
      # </table>
      const_set_lazy(:HALF_DOWN) { RoundingMode.new(BigDecimal::ROUND_HALF_DOWN).set_value_name("HALF_DOWN") }
      const_attr_reader  :HALF_DOWN
      
      # Rounding mode to round towards the {@literal "nearest neighbor"}
      # unless both neighbors are equidistant, in which case, round
      # towards the even neighbor.  Behaves as for
      # {@code RoundingMode.HALF_UP} if the digit to the left of the
      # discarded fraction is odd; behaves as for
      # {@code RoundingMode.HALF_DOWN} if it's even.  Note that this
      # is the rounding mode that statistically minimizes cumulative
      # error when applied repeatedly over a sequence of calculations.
      # It is sometimes known as {@literal "Banker's rounding,"} and is
      # chiefly used in the USA.  This rounding mode is analogous to
      # the rounding policy used for {@code float} and {@code double}
      # arithmetic in Java.
      # 
      # <p>Example:
      # <table border>
      # <tr valign=top><th>Input Number</th>
      # <th>Input rounded to one digit<br> with {@code HALF_EVEN} rounding
      # <tr align=right><td>5.5</td>  <td>6</td>
      # <tr align=right><td>2.5</td>  <td>2</td>
      # <tr align=right><td>1.6</td>  <td>2</td>
      # <tr align=right><td>1.1</td>  <td>1</td>
      # <tr align=right><td>1.0</td>  <td>1</td>
      # <tr align=right><td>-1.0</td> <td>-1</td>
      # <tr align=right><td>-1.1</td> <td>-1</td>
      # <tr align=right><td>-1.6</td> <td>-2</td>
      # <tr align=right><td>-2.5</td> <td>-2</td>
      # <tr align=right><td>-5.5</td> <td>-6</td>
      # </table>
      const_set_lazy(:HALF_EVEN) { RoundingMode.new(BigDecimal::ROUND_HALF_EVEN).set_value_name("HALF_EVEN") }
      const_attr_reader  :HALF_EVEN
      
      # Rounding mode to assert that the requested operation has an exact
      # result, hence no rounding is necessary.  If this rounding mode is
      # specified on an operation that yields an inexact result, an
      # {@code ArithmeticException} is thrown.
      # <p>Example:
      # <table border>
      # <tr valign=top><th>Input Number</th>
      # <th>Input rounded to one digit<br> with {@code UNNECESSARY} rounding
      # <tr align=right><td>5.5</td>  <td>throw {@code ArithmeticException}</td>
      # <tr align=right><td>2.5</td>  <td>throw {@code ArithmeticException}</td>
      # <tr align=right><td>1.6</td>  <td>throw {@code ArithmeticException}</td>
      # <tr align=right><td>1.1</td>  <td>throw {@code ArithmeticException}</td>
      # <tr align=right><td>1.0</td>  <td>1</td>
      # <tr align=right><td>-1.0</td> <td>-1</td>
      # <tr align=right><td>-1.1</td> <td>throw {@code ArithmeticException}</td>
      # <tr align=right><td>-1.6</td> <td>throw {@code ArithmeticException}</td>
      # <tr align=right><td>-2.5</td> <td>throw {@code ArithmeticException}</td>
      # <tr align=right><td>-5.5</td> <td>throw {@code ArithmeticException}</td>
      # </table>
      const_set_lazy(:UNNECESSARY) { RoundingMode.new(BigDecimal::ROUND_UNNECESSARY).set_value_name("UNNECESSARY") }
      const_attr_reader  :UNNECESSARY
    }
    
    # Corresponding BigDecimal rounding constant
    attr_accessor :old_mode
    alias_method :attr_old_mode, :old_mode
    undef_method :old_mode
    alias_method :attr_old_mode=, :old_mode=
    undef_method :old_mode=
    
    typesig { [::Java::Int] }
    # Constructor
    # 
    # @param oldMode The {@code BigDecimal} constant corresponding to
    # this mode
    def initialize(old_mode)
      @old_mode = 0
      @old_mode = old_mode
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Returns the {@code RoundingMode} object corresponding to a
      # legacy integer rounding mode constant in {@link BigDecimal}.
      # 
      # @param  rm legacy integer rounding mode to convert
      # @return {@code RoundingMode} corresponding to the given integer.
      # @throws IllegalArgumentException integer is out of range
      def value_of(rm)
        case (rm)
        when BigDecimal::ROUND_UP
          return UP
        when BigDecimal::ROUND_DOWN
          return DOWN
        when BigDecimal::ROUND_CEILING
          return CEILING
        when BigDecimal::ROUND_FLOOR
          return FLOOR
        when BigDecimal::ROUND_HALF_UP
          return HALF_UP
        when BigDecimal::ROUND_HALF_DOWN
          return HALF_DOWN
        when BigDecimal::ROUND_HALF_EVEN
          return HALF_EVEN
        when BigDecimal::ROUND_UNNECESSARY
          return UNNECESSARY
        else
          raise IllegalArgumentException.new("argument out of range")
        end
      end
    }
    
    typesig { [String] }
    def set_value_name(name)
      @value_name = name
      self
    end
    
    typesig { [] }
    def to_s
      @value_name
    end
    
    class_module.module_eval {
      typesig { [] }
      def values
        [UP, DOWN, CEILING, FLOOR, HALF_UP, HALF_DOWN, HALF_EVEN, UNNECESSARY]
      end
    }
    
    private
    alias_method :initialize__rounding_mode, :initialize
  end
  
end
