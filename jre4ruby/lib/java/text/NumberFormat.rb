require "rjava"

# Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - 1998 - All Rights Reserved
# 
# The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module NumberFormatImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Io, :InvalidObjectException
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Io, :ObjectOutputStream
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Math, :RoundingMode
      include_const ::Java::Text::Spi, :NumberFormatProvider
      include_const ::Java::Util, :Currency
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util::Concurrent::Atomic, :AtomicInteger
      include_const ::Java::Util::Concurrent::Atomic, :AtomicLong
      include_const ::Java::Util::Spi, :LocaleServiceProvider
      include_const ::Sun::Util, :LocaleServiceProviderPool
      include_const ::Sun::Util::Resources, :LocaleData
    }
  end
  
  # <code>NumberFormat</code> is the abstract base class for all number
  # formats. This class provides the interface for formatting and parsing
  # numbers. <code>NumberFormat</code> also provides methods for determining
  # which locales have number formats, and what their names are.
  # 
  # <p>
  # <code>NumberFormat</code> helps you to format and parse numbers for any locale.
  # Your code can be completely independent of the locale conventions for
  # decimal points, thousands-separators, or even the particular decimal
  # digits used, or whether the number format is even decimal.
  # 
  # <p>
  # To format a number for the current Locale, use one of the factory
  # class methods:
  # <blockquote>
  # <pre>
  # myString = NumberFormat.getInstance().format(myNumber);
  # </pre>
  # </blockquote>
  # If you are formatting multiple numbers, it is
  # more efficient to get the format and use it multiple times so that
  # the system doesn't have to fetch the information about the local
  # language and country conventions multiple times.
  # <blockquote>
  # <pre>
  # NumberFormat nf = NumberFormat.getInstance();
  # for (int i = 0; i < myNumber.length; ++i) {
  # output.println(nf.format(myNumber[i]) + "; ");
  # }
  # </pre>
  # </blockquote>
  # To format a number for a different Locale, specify it in the
  # call to <code>getInstance</code>.
  # <blockquote>
  # <pre>
  # NumberFormat nf = NumberFormat.getInstance(Locale.FRENCH);
  # </pre>
  # </blockquote>
  # You can also use a <code>NumberFormat</code> to parse numbers:
  # <blockquote>
  # <pre>
  # myNumber = nf.parse(myString);
  # </pre>
  # </blockquote>
  # Use <code>getInstance</code> or <code>getNumberInstance</code> to get the
  # normal number format. Use <code>getIntegerInstance</code> to get an
  # integer number format. Use <code>getCurrencyInstance</code> to get the
  # currency number format. And use <code>getPercentInstance</code> to get a
  # format for displaying percentages. With this format, a fraction like
  # 0.53 is displayed as 53%.
  # 
  # <p>
  # You can also control the display of numbers with such methods as
  # <code>setMinimumFractionDigits</code>.
  # If you want even more control over the format or parsing,
  # or want to give your users more control,
  # you can try casting the <code>NumberFormat</code> you get from the factory methods
  # to a <code>DecimalFormat</code>. This will work for the vast majority
  # of locales; just remember to put it in a <code>try</code> block in case you
  # encounter an unusual one.
  # 
  # <p>
  # NumberFormat and DecimalFormat are designed such that some controls
  # work for formatting and others work for parsing.  The following is
  # the detailed description for each these control methods,
  # <p>
  # setParseIntegerOnly : only affects parsing, e.g.
  # if true,  "3456.78" -> 3456 (and leaves the parse position just after index 6)
  # if false, "3456.78" -> 3456.78 (and leaves the parse position just after index 8)
  # This is independent of formatting.  If you want to not show a decimal point
  # where there might be no digits after the decimal point, use
  # setDecimalSeparatorAlwaysShown.
  # <p>
  # setDecimalSeparatorAlwaysShown : only affects formatting, and only where
  # there might be no digits after the decimal point, such as with a pattern
  # like "#,##0.##", e.g.,
  # if true,  3456.00 -> "3,456."
  # if false, 3456.00 -> "3456"
  # This is independent of parsing.  If you want parsing to stop at the decimal
  # point, use setParseIntegerOnly.
  # 
  # <p>
  # You can also use forms of the <code>parse</code> and <code>format</code>
  # methods with <code>ParsePosition</code> and <code>FieldPosition</code> to
  # allow you to:
  # <ul>
  # <li> progressively parse through pieces of a string
  # <li> align the decimal point and other areas
  # </ul>
  # For example, you can align numbers in two ways:
  # <ol>
  # <li> If you are using a monospaced font with spacing for alignment,
  # you can pass the <code>FieldPosition</code> in your format call, with
  # <code>field</code> = <code>INTEGER_FIELD</code>. On output,
  # <code>getEndIndex</code> will be set to the offset between the
  # last character of the integer and the decimal. Add
  # (desiredSpaceCount - getEndIndex) spaces at the front of the string.
  # 
  # <li> If you are using proportional fonts,
  # instead of padding with spaces, measure the width
  # of the string in pixels from the start to <code>getEndIndex</code>.
  # Then move the pen by
  # (desiredPixelWidth - widthToAlignmentPoint) before drawing the text.
  # It also works where there is no decimal, but possibly additional
  # characters at the end, e.g., with parentheses in negative
  # numbers: "(12)" for -12.
  # </ol>
  # 
  # <h4><a name="synchronization">Synchronization</a></h4>
  # 
  # <p>
  # Number formats are generally not synchronized.
  # It is recommended to create separate format instances for each thread.
  # If multiple threads access a format concurrently, it must be synchronized
  # externally.
  # 
  # @see          DecimalFormat
  # @see          ChoiceFormat
  # @author       Mark Davis
  # @author       Helena Shih
  class NumberFormat < NumberFormatImports.const_get :Format
    include_class_members NumberFormatImports
    
    class_module.module_eval {
      # Field constant used to construct a FieldPosition object. Signifies that
      # the position of the integer part of a formatted number should be returned.
      # @see java.text.FieldPosition
      const_set_lazy(:INTEGER_FIELD) { 0 }
      const_attr_reader  :INTEGER_FIELD
      
      # Field constant used to construct a FieldPosition object. Signifies that
      # the position of the fraction part of a formatted number should be returned.
      # @see java.text.FieldPosition
      const_set_lazy(:FRACTION_FIELD) { 1 }
      const_attr_reader  :FRACTION_FIELD
    }
    
    typesig { [] }
    # Sole constructor.  (For invocation by subclass constructors, typically
    # implicit.)
    def initialize
      @grouping_used = false
      @max_integer_digits = 0
      @min_integer_digits = 0
      @max_fraction_digits = 0
      @min_fraction_digits = 0
      @parse_integer_only = false
      @maximum_integer_digits = 0
      @minimum_integer_digits = 0
      @maximum_fraction_digits = 0
      @minimum_fraction_digits = 0
      @serial_version_on_stream = 0
      super()
      @grouping_used = true
      @max_integer_digits = 40
      @min_integer_digits = 1
      @max_fraction_digits = 3
      @min_fraction_digits = 0
      @parse_integer_only = false
      @maximum_integer_digits = 40
      @minimum_integer_digits = 1
      @maximum_fraction_digits = 3
      @minimum_fraction_digits = 0
      @serial_version_on_stream = CurrentSerialVersion
    end
    
    typesig { [Object, StringBuffer, FieldPosition] }
    # Formats a number and appends the resulting text to the given string
    # buffer.
    # The number can be of any subclass of {@link java.lang.Number}.
    # <p>
    # This implementation extracts the number's value using
    # {@link java.lang.Number#longValue()} for all integral type values that
    # can be converted to <code>long</code> without loss of information,
    # including <code>BigInteger</code> values with a
    # {@link java.math.BigInteger#bitLength() bit length} of less than 64,
    # and {@link java.lang.Number#doubleValue()} for all other types. It
    # then calls
    # {@link #format(long,java.lang.StringBuffer,java.text.FieldPosition)}
    # or {@link #format(double,java.lang.StringBuffer,java.text.FieldPosition)}.
    # This may result in loss of magnitude information and precision for
    # <code>BigInteger</code> and <code>BigDecimal</code> values.
    # @param number     the number to format
    # @param toAppendTo the <code>StringBuffer</code> to which the formatted
    # text is to be appended
    # @param pos        On input: an alignment field, if desired.
    # On output: the offsets of the alignment field.
    # @return           the value passed in as <code>toAppendTo</code>
    # @exception        IllegalArgumentException if <code>number</code> is
    # null or not an instance of <code>Number</code>.
    # @exception        NullPointerException if <code>toAppendTo</code> or
    # <code>pos</code> is null
    # @exception        ArithmeticException if rounding is needed with rounding
    # mode being set to RoundingMode.UNNECESSARY
    # @see              java.text.FieldPosition
    def format(number, to_append_to, pos)
      if (number.is_a?(Long) || number.is_a?(JavaInteger) || number.is_a?(Short) || number.is_a?(Byte) || number.is_a?(AtomicInteger) || number.is_a?(AtomicLong) || (number.is_a?(BigInteger) && (number).bit_length < 64))
        return format((number).long_value, to_append_to, pos)
      else
        if (number.is_a?(Numeric))
          return format((number).double_value, to_append_to, pos)
        else
          raise IllegalArgumentException.new("Cannot format given Object as a Number")
        end
      end
    end
    
    typesig { [String, ParsePosition] }
    # Parses text from a string to produce a <code>Number</code>.
    # <p>
    # The method attempts to parse text starting at the index given by
    # <code>pos</code>.
    # If parsing succeeds, then the index of <code>pos</code> is updated
    # to the index after the last character used (parsing does not necessarily
    # use all characters up to the end of the string), and the parsed
    # number is returned. The updated <code>pos</code> can be used to
    # indicate the starting point for the next call to this method.
    # If an error occurs, then the index of <code>pos</code> is not
    # changed, the error index of <code>pos</code> is set to the index of
    # the character where the error occurred, and null is returned.
    # <p>
    # See the {@link #parse(String, ParsePosition)} method for more information
    # on number parsing.
    # 
    # @param source A <code>String</code>, part of which should be parsed.
    # @param pos A <code>ParsePosition</code> object with index and error
    # index information as described above.
    # @return A <code>Number</code> parsed from the string. In case of
    # error, returns null.
    # @exception NullPointerException if <code>pos</code> is null.
    def parse_object(source, pos)
      return parse(source, pos)
    end
    
    typesig { [::Java::Double] }
    # Specialization of format.
    # @exception        ArithmeticException if rounding is needed with rounding
    # mode being set to RoundingMode.UNNECESSARY
    # @see java.text.Format#format
    def format(number)
      return format(number, StringBuffer.new, DontCareFieldPosition::INSTANCE).to_s
    end
    
    typesig { [::Java::Long] }
    # Specialization of format.
    # @exception        ArithmeticException if rounding is needed with rounding
    # mode being set to RoundingMode.UNNECESSARY
    # @see java.text.Format#format
    def format(number)
      return format(number, StringBuffer.new, DontCareFieldPosition::INSTANCE).to_s
    end
    
    typesig { [::Java::Double, StringBuffer, FieldPosition] }
    # Specialization of format.
    # @exception        ArithmeticException if rounding is needed with rounding
    # mode being set to RoundingMode.UNNECESSARY
    # @see java.text.Format#format
    def format(number, to_append_to, pos)
      raise NotImplementedError
    end
    
    typesig { [::Java::Long, StringBuffer, FieldPosition] }
    # Specialization of format.
    # @exception        ArithmeticException if rounding is needed with rounding
    # mode being set to RoundingMode.UNNECESSARY
    # @see java.text.Format#format
    def format(number, to_append_to, pos)
      raise NotImplementedError
    end
    
    typesig { [String, ParsePosition] }
    # Returns a Long if possible (e.g., within the range [Long.MIN_VALUE,
    # Long.MAX_VALUE] and with no decimals), otherwise a Double.
    # If IntegerOnly is set, will stop at a decimal
    # point (or equivalent; e.g., for rational numbers "1 2/3", will stop
    # after the 1).
    # Does not throw an exception; if no object can be parsed, index is
    # unchanged!
    # @see java.text.NumberFormat#isParseIntegerOnly
    # @see java.text.Format#parseObject
    def parse(source, parse_position)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Parses text from the beginning of the given string to produce a number.
    # The method may not use the entire text of the given string.
    # <p>
    # See the {@link #parse(String, ParsePosition)} method for more information
    # on number parsing.
    # 
    # @param source A <code>String</code> whose beginning should be parsed.
    # @return A <code>Number</code> parsed from the string.
    # @exception ParseException if the beginning of the specified string
    # cannot be parsed.
    def parse(source)
      parse_position = ParsePosition.new(0)
      result = parse(source, parse_position)
      if ((parse_position.attr_index).equal?(0))
        raise ParseException.new("Unparseable number: \"" + source + "\"", parse_position.attr_error_index)
      end
      return result
    end
    
    typesig { [] }
    # Returns true if this format will parse numbers as integers only.
    # For example in the English locale, with ParseIntegerOnly true, the
    # string "1234." would be parsed as the integer value 1234 and parsing
    # would stop at the "." character.  Of course, the exact format accepted
    # by the parse operation is locale dependant and determined by sub-classes
    # of NumberFormat.
    def is_parse_integer_only
      return @parse_integer_only
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether or not numbers should be parsed as integers only.
    # @see #isParseIntegerOnly
    def set_parse_integer_only(value)
      @parse_integer_only = value
    end
    
    class_module.module_eval {
      typesig { [] }
      # ============== Locale Stuff =====================
      # 
      # Returns a general-purpose number format for the current default locale.
      # This is the same as calling
      # {@link #getNumberInstance() getNumberInstance()}.
      def get_instance
        return get_instance(Locale.get_default, NUMBERSTYLE)
      end
      
      typesig { [Locale] }
      # Returns a general-purpose number format for the specified locale.
      # This is the same as calling
      # {@link #getNumberInstance(java.util.Locale) getNumberInstance(inLocale)}.
      def get_instance(in_locale)
        return get_instance(in_locale, NUMBERSTYLE)
      end
      
      typesig { [] }
      # Returns a general-purpose number format for the current default locale.
      def get_number_instance
        return get_instance(Locale.get_default, NUMBERSTYLE)
      end
      
      typesig { [Locale] }
      # Returns a general-purpose number format for the specified locale.
      def get_number_instance(in_locale)
        return get_instance(in_locale, NUMBERSTYLE)
      end
      
      typesig { [] }
      # Returns an integer number format for the current default locale. The
      # returned number format is configured to round floating point numbers
      # to the nearest integer using half-even rounding (see {@link
      # java.math.RoundingMode#HALF_EVEN RoundingMode.HALF_EVEN}) for formatting,
      # and to parse only the integer part of an input string (see {@link
      # #isParseIntegerOnly isParseIntegerOnly}).
      # 
      # @see #getRoundingMode()
      # @return a number format for integer values
      # @since 1.4
      def get_integer_instance
        return get_instance(Locale.get_default, INTEGERSTYLE)
      end
      
      typesig { [Locale] }
      # Returns an integer number format for the specified locale. The
      # returned number format is configured to round floating point numbers
      # to the nearest integer using half-even rounding (see {@link
      # java.math.RoundingMode#HALF_EVEN RoundingMode.HALF_EVEN}) for formatting,
      # and to parse only the integer part of an input string (see {@link
      # #isParseIntegerOnly isParseIntegerOnly}).
      # 
      # @see #getRoundingMode()
      # @return a number format for integer values
      # @since 1.4
      def get_integer_instance(in_locale)
        return get_instance(in_locale, INTEGERSTYLE)
      end
      
      typesig { [] }
      # Returns a currency format for the current default locale.
      def get_currency_instance
        return get_instance(Locale.get_default, CURRENCYSTYLE)
      end
      
      typesig { [Locale] }
      # Returns a currency format for the specified locale.
      def get_currency_instance(in_locale)
        return get_instance(in_locale, CURRENCYSTYLE)
      end
      
      typesig { [] }
      # Returns a percentage format for the current default locale.
      def get_percent_instance
        return get_instance(Locale.get_default, PERCENTSTYLE)
      end
      
      typesig { [Locale] }
      # Returns a percentage format for the specified locale.
      def get_percent_instance(in_locale)
        return get_instance(in_locale, PERCENTSTYLE)
      end
      
      typesig { [] }
      # Returns a scientific format for the current default locale.
      # 
      # public
      def get_scientific_instance
        return get_instance(Locale.get_default, SCIENTIFICSTYLE)
      end
      
      typesig { [Locale] }
      # Returns a scientific format for the specified locale.
      # 
      # public
      def get_scientific_instance(in_locale)
        return get_instance(in_locale, SCIENTIFICSTYLE)
      end
      
      typesig { [] }
      # Returns an array of all locales for which the
      # <code>get*Instance</code> methods of this class can return
      # localized instances.
      # The returned array represents the union of locales supported by the Java
      # runtime and by installed
      # {@link java.text.spi.NumberFormatProvider NumberFormatProvider} implementations.
      # It must contain at least a <code>Locale</code> instance equal to
      # {@link java.util.Locale#US Locale.US}.
      # 
      # @return An array of locales for which localized
      # <code>NumberFormat</code> instances are available.
      def get_available_locales
        pool = LocaleServiceProviderPool.get_pool(NumberFormatProvider.class)
        return pool.get_available_locales
      end
    }
    
    typesig { [] }
    # Overrides hashCode
    def hash_code
      return @maximum_integer_digits * 37 + @max_fraction_digits
      # just enough fields for a reasonable distribution
    end
    
    typesig { [Object] }
    # Overrides equals
    def equals(obj)
      if ((obj).nil?)
        return false
      end
      if ((self).equal?(obj))
        return true
      end
      if (!(get_class).equal?(obj.get_class))
        return false
      end
      other = obj
      return ((@maximum_integer_digits).equal?(other.attr_maximum_integer_digits) && (@minimum_integer_digits).equal?(other.attr_minimum_integer_digits) && (@maximum_fraction_digits).equal?(other.attr_maximum_fraction_digits) && (@minimum_fraction_digits).equal?(other.attr_minimum_fraction_digits) && (@grouping_used).equal?(other.attr_grouping_used) && (@parse_integer_only).equal?(other.attr_parse_integer_only))
    end
    
    typesig { [] }
    # Overrides Cloneable
    def clone
      other = super
      return other
    end
    
    typesig { [] }
    # Returns true if grouping is used in this format. For example, in the
    # English locale, with grouping on, the number 1234567 might be formatted
    # as "1,234,567". The grouping separator as well as the size of each group
    # is locale dependant and is determined by sub-classes of NumberFormat.
    # @see #setGroupingUsed
    def is_grouping_used
      return @grouping_used
    end
    
    typesig { [::Java::Boolean] }
    # Set whether or not grouping will be used in this format.
    # @see #isGroupingUsed
    def set_grouping_used(new_value)
      @grouping_used = new_value
    end
    
    typesig { [] }
    # Returns the maximum number of digits allowed in the integer portion of a
    # number.
    # @see #setMaximumIntegerDigits
    def get_maximum_integer_digits
      return @maximum_integer_digits
    end
    
    typesig { [::Java::Int] }
    # Sets the maximum number of digits allowed in the integer portion of a
    # number. maximumIntegerDigits must be >= minimumIntegerDigits.  If the
    # new value for maximumIntegerDigits is less than the current value
    # of minimumIntegerDigits, then minimumIntegerDigits will also be set to
    # the new value.
    # @param newValue the maximum number of integer digits to be shown; if
    # less than zero, then zero is used. The concrete subclass may enforce an
    # upper limit to this value appropriate to the numeric type being formatted.
    # @see #getMaximumIntegerDigits
    def set_maximum_integer_digits(new_value)
      @maximum_integer_digits = Math.max(0, new_value)
      if (@minimum_integer_digits > @maximum_integer_digits)
        @minimum_integer_digits = @maximum_integer_digits
      end
    end
    
    typesig { [] }
    # Returns the minimum number of digits allowed in the integer portion of a
    # number.
    # @see #setMinimumIntegerDigits
    def get_minimum_integer_digits
      return @minimum_integer_digits
    end
    
    typesig { [::Java::Int] }
    # Sets the minimum number of digits allowed in the integer portion of a
    # number. minimumIntegerDigits must be <= maximumIntegerDigits.  If the
    # new value for minimumIntegerDigits exceeds the current value
    # of maximumIntegerDigits, then maximumIntegerDigits will also be set to
    # the new value
    # @param newValue the minimum number of integer digits to be shown; if
    # less than zero, then zero is used. The concrete subclass may enforce an
    # upper limit to this value appropriate to the numeric type being formatted.
    # @see #getMinimumIntegerDigits
    def set_minimum_integer_digits(new_value)
      @minimum_integer_digits = Math.max(0, new_value)
      if (@minimum_integer_digits > @maximum_integer_digits)
        @maximum_integer_digits = @minimum_integer_digits
      end
    end
    
    typesig { [] }
    # Returns the maximum number of digits allowed in the fraction portion of a
    # number.
    # @see #setMaximumFractionDigits
    def get_maximum_fraction_digits
      return @maximum_fraction_digits
    end
    
    typesig { [::Java::Int] }
    # Sets the maximum number of digits allowed in the fraction portion of a
    # number. maximumFractionDigits must be >= minimumFractionDigits.  If the
    # new value for maximumFractionDigits is less than the current value
    # of minimumFractionDigits, then minimumFractionDigits will also be set to
    # the new value.
    # @param newValue the maximum number of fraction digits to be shown; if
    # less than zero, then zero is used. The concrete subclass may enforce an
    # upper limit to this value appropriate to the numeric type being formatted.
    # @see #getMaximumFractionDigits
    def set_maximum_fraction_digits(new_value)
      @maximum_fraction_digits = Math.max(0, new_value)
      if (@maximum_fraction_digits < @minimum_fraction_digits)
        @minimum_fraction_digits = @maximum_fraction_digits
      end
    end
    
    typesig { [] }
    # Returns the minimum number of digits allowed in the fraction portion of a
    # number.
    # @see #setMinimumFractionDigits
    def get_minimum_fraction_digits
      return @minimum_fraction_digits
    end
    
    typesig { [::Java::Int] }
    # Sets the minimum number of digits allowed in the fraction portion of a
    # number. minimumFractionDigits must be <= maximumFractionDigits.  If the
    # new value for minimumFractionDigits exceeds the current value
    # of maximumFractionDigits, then maximumIntegerDigits will also be set to
    # the new value
    # @param newValue the minimum number of fraction digits to be shown; if
    # less than zero, then zero is used. The concrete subclass may enforce an
    # upper limit to this value appropriate to the numeric type being formatted.
    # @see #getMinimumFractionDigits
    def set_minimum_fraction_digits(new_value)
      @minimum_fraction_digits = Math.max(0, new_value)
      if (@maximum_fraction_digits < @minimum_fraction_digits)
        @maximum_fraction_digits = @minimum_fraction_digits
      end
    end
    
    typesig { [] }
    # Gets the currency used by this number format when formatting
    # currency values. The initial value is derived in a locale dependent
    # way. The returned value may be null if no valid
    # currency could be determined and no currency has been set using
    # {@link #setCurrency(java.util.Currency) setCurrency}.
    # <p>
    # The default implementation throws
    # <code>UnsupportedOperationException</code>.
    # 
    # @return the currency used by this number format, or <code>null</code>
    # @exception UnsupportedOperationException if the number format class
    # doesn't implement currency formatting
    # @since 1.4
    def get_currency
      raise UnsupportedOperationException.new
    end
    
    typesig { [Currency] }
    # Sets the currency used by this number format when formatting
    # currency values. This does not update the minimum or maximum
    # number of fraction digits used by the number format.
    # <p>
    # The default implementation throws
    # <code>UnsupportedOperationException</code>.
    # 
    # @param currency the new currency to be used by this number format
    # @exception UnsupportedOperationException if the number format class
    # doesn't implement currency formatting
    # @exception NullPointerException if <code>currency</code> is null
    # @since 1.4
    def set_currency(currency)
      raise UnsupportedOperationException.new
    end
    
    typesig { [] }
    # Gets the {@link java.math.RoundingMode} used in this NumberFormat.
    # The default implementation of this method in NumberFormat
    # always throws {@link java.lang.UnsupportedOperationException}.
    # Subclasses which handle different rounding modes should override
    # this method.
    # 
    # @exception UnsupportedOperationException The default implementation
    # always throws this exception
    # @return The <code>RoundingMode</code> used for this NumberFormat.
    # @see #setRoundingMode(RoundingMode)
    # @since 1.6
    def get_rounding_mode
      raise UnsupportedOperationException.new
    end
    
    typesig { [RoundingMode] }
    # Sets the {@link java.math.RoundingMode} used in this NumberFormat.
    # The default implementation of this method in NumberFormat always
    # throws {@link java.lang.UnsupportedOperationException}.
    # Subclasses which handle different rounding modes should override
    # this method.
    # 
    # @exception UnsupportedOperationException The default implementation
    # always throws this exception
    # @exception NullPointerException if <code>roundingMode</code> is null
    # @param roundingMode The <code>RoundingMode</code> to be used
    # @see #getRoundingMode()
    # @since 1.6
    def set_rounding_mode(rounding_mode)
      raise UnsupportedOperationException.new
    end
    
    class_module.module_eval {
      typesig { [Locale, ::Java::Int] }
      # =======================privates===============================
      def get_instance(desired_locale, choice)
        # Check whether a provider can provide an implementation that's closer
        # to the requested locale than what the Java runtime itself can provide.
        pool = LocaleServiceProviderPool.get_pool(NumberFormatProvider.class)
        if (pool.has_providers)
          providers_instance = pool.get_localized_object(NumberFormatGetter::INSTANCE, desired_locale, choice)
          if (!(providers_instance).nil?)
            return providers_instance
          end
        end
        # try the cache first
        number_patterns = CachedLocaleData.get(desired_locale)
        if ((number_patterns).nil?)
          # cache miss
          resource = LocaleData.get_number_format_data(desired_locale)
          number_patterns = resource.get_string_array("NumberPatterns")
          # update cache
          CachedLocaleData.put(desired_locale, number_patterns)
        end
        symbols = DecimalFormatSymbols.get_instance(desired_locale)
        entry = ((choice).equal?(INTEGERSTYLE)) ? NUMBERSTYLE : choice
        format_ = DecimalFormat.new(number_patterns[entry], symbols)
        if ((choice).equal?(INTEGERSTYLE))
          format_.set_maximum_fraction_digits(0)
          format_.set_decimal_separator_always_shown(false)
          format_.set_parse_integer_only(true)
        else
          if ((choice).equal?(CURRENCYSTYLE))
            format_.adjust_for_currency_default_fraction_digits
          end
        end
        return format_
      end
    }
    
    typesig { [ObjectInputStream] }
    # First, read in the default serializable data.
    # 
    # Then, if <code>serialVersionOnStream</code> is less than 1, indicating that
    # the stream was written by JDK 1.1,
    # set the <code>int</code> fields such as <code>maximumIntegerDigits</code>
    # to be equal to the <code>byte</code> fields such as <code>maxIntegerDigits</code>,
    # since the <code>int</code> fields were not present in JDK 1.1.
    # Finally, set serialVersionOnStream back to the maximum allowed value so that
    # default serialization will work properly if this object is streamed out again.
    # 
    # <p>If <code>minimumIntegerDigits</code> is greater than
    # <code>maximumIntegerDigits</code> or <code>minimumFractionDigits</code>
    # is greater than <code>maximumFractionDigits</code>, then the stream data
    # is invalid and this method throws an <code>InvalidObjectException</code>.
    # In addition, if any of these values is negative, then this method throws
    # an <code>InvalidObjectException</code>.
    # 
    # @since 1.2
    def read_object(stream)
      stream.default_read_object
      if (@serial_version_on_stream < 1)
        # Didn't have additional int fields, reassign to use them.
        @maximum_integer_digits = @max_integer_digits
        @minimum_integer_digits = @min_integer_digits
        @maximum_fraction_digits = @max_fraction_digits
        @minimum_fraction_digits = @min_fraction_digits
      end
      if (@minimum_integer_digits > @maximum_integer_digits || @minimum_fraction_digits > @maximum_fraction_digits || @minimum_integer_digits < 0 || @minimum_fraction_digits < 0)
        raise InvalidObjectException.new("Digit count range invalid")
      end
      @serial_version_on_stream = CurrentSerialVersion
    end
    
    typesig { [ObjectOutputStream] }
    # Write out the default serializable data, after first setting
    # the <code>byte</code> fields such as <code>maxIntegerDigits</code> to be
    # equal to the <code>int</code> fields such as <code>maximumIntegerDigits</code>
    # (or to <code>Byte.MAX_VALUE</code>, whichever is smaller), for compatibility
    # with the JDK 1.1 version of the stream format.
    # 
    # @since 1.2
    def write_object(stream)
      @max_integer_digits = (@maximum_integer_digits > Byte::MAX_VALUE) ? Byte::MAX_VALUE : @maximum_integer_digits
      @min_integer_digits = (@minimum_integer_digits > Byte::MAX_VALUE) ? Byte::MAX_VALUE : @minimum_integer_digits
      @max_fraction_digits = (@maximum_fraction_digits > Byte::MAX_VALUE) ? Byte::MAX_VALUE : @maximum_fraction_digits
      @min_fraction_digits = (@minimum_fraction_digits > Byte::MAX_VALUE) ? Byte::MAX_VALUE : @minimum_fraction_digits
      stream.default_write_object
    end
    
    class_module.module_eval {
      # Cache to hold the NumberPatterns of a Locale.
      const_set_lazy(:CachedLocaleData) { Hashtable.new(3) }
      const_attr_reader  :CachedLocaleData
      
      # Constants used by factory methods to specify a style of format.
      const_set_lazy(:NUMBERSTYLE) { 0 }
      const_attr_reader  :NUMBERSTYLE
      
      const_set_lazy(:CURRENCYSTYLE) { 1 }
      const_attr_reader  :CURRENCYSTYLE
      
      const_set_lazy(:PERCENTSTYLE) { 2 }
      const_attr_reader  :PERCENTSTYLE
      
      const_set_lazy(:SCIENTIFICSTYLE) { 3 }
      const_attr_reader  :SCIENTIFICSTYLE
      
      const_set_lazy(:INTEGERSTYLE) { 4 }
      const_attr_reader  :INTEGERSTYLE
    }
    
    # True if the grouping (i.e. thousands) separator is used when
    # formatting and parsing numbers.
    # 
    # @serial
    # @see #isGroupingUsed
    attr_accessor :grouping_used
    alias_method :attr_grouping_used, :grouping_used
    undef_method :grouping_used
    alias_method :attr_grouping_used=, :grouping_used=
    undef_method :grouping_used=
    
    # The maximum number of digits allowed in the integer portion of a
    # number.  <code>maxIntegerDigits</code> must be greater than or equal to
    # <code>minIntegerDigits</code>.
    # <p>
    # <strong>Note:</strong> This field exists only for serialization
    # compatibility with JDK 1.1.  In Java platform 2 v1.2 and higher, the new
    # <code>int</code> field <code>maximumIntegerDigits</code> is used instead.
    # When writing to a stream, <code>maxIntegerDigits</code> is set to
    # <code>maximumIntegerDigits</code> or <code>Byte.MAX_VALUE</code>,
    # whichever is smaller.  When reading from a stream, this field is used
    # only if <code>serialVersionOnStream</code> is less than 1.
    # 
    # @serial
    # @see #getMaximumIntegerDigits
    attr_accessor :max_integer_digits
    alias_method :attr_max_integer_digits, :max_integer_digits
    undef_method :max_integer_digits
    alias_method :attr_max_integer_digits=, :max_integer_digits=
    undef_method :max_integer_digits=
    
    # The minimum number of digits allowed in the integer portion of a
    # number.  <code>minimumIntegerDigits</code> must be less than or equal to
    # <code>maximumIntegerDigits</code>.
    # <p>
    # <strong>Note:</strong> This field exists only for serialization
    # compatibility with JDK 1.1.  In Java platform 2 v1.2 and higher, the new
    # <code>int</code> field <code>minimumIntegerDigits</code> is used instead.
    # When writing to a stream, <code>minIntegerDigits</code> is set to
    # <code>minimumIntegerDigits</code> or <code>Byte.MAX_VALUE</code>,
    # whichever is smaller.  When reading from a stream, this field is used
    # only if <code>serialVersionOnStream</code> is less than 1.
    # 
    # @serial
    # @see #getMinimumIntegerDigits
    attr_accessor :min_integer_digits
    alias_method :attr_min_integer_digits, :min_integer_digits
    undef_method :min_integer_digits
    alias_method :attr_min_integer_digits=, :min_integer_digits=
    undef_method :min_integer_digits=
    
    # The maximum number of digits allowed in the fractional portion of a
    # number.  <code>maximumFractionDigits</code> must be greater than or equal to
    # <code>minimumFractionDigits</code>.
    # <p>
    # <strong>Note:</strong> This field exists only for serialization
    # compatibility with JDK 1.1.  In Java platform 2 v1.2 and higher, the new
    # <code>int</code> field <code>maximumFractionDigits</code> is used instead.
    # When writing to a stream, <code>maxFractionDigits</code> is set to
    # <code>maximumFractionDigits</code> or <code>Byte.MAX_VALUE</code>,
    # whichever is smaller.  When reading from a stream, this field is used
    # only if <code>serialVersionOnStream</code> is less than 1.
    # 
    # @serial
    # @see #getMaximumFractionDigits
    attr_accessor :max_fraction_digits
    alias_method :attr_max_fraction_digits, :max_fraction_digits
    undef_method :max_fraction_digits
    alias_method :attr_max_fraction_digits=, :max_fraction_digits=
    undef_method :max_fraction_digits=
    
    # invariant, >= minFractionDigits
    # 
    # The minimum number of digits allowed in the fractional portion of a
    # number.  <code>minimumFractionDigits</code> must be less than or equal to
    # <code>maximumFractionDigits</code>.
    # <p>
    # <strong>Note:</strong> This field exists only for serialization
    # compatibility with JDK 1.1.  In Java platform 2 v1.2 and higher, the new
    # <code>int</code> field <code>minimumFractionDigits</code> is used instead.
    # When writing to a stream, <code>minFractionDigits</code> is set to
    # <code>minimumFractionDigits</code> or <code>Byte.MAX_VALUE</code>,
    # whichever is smaller.  When reading from a stream, this field is used
    # only if <code>serialVersionOnStream</code> is less than 1.
    # 
    # @serial
    # @see #getMinimumFractionDigits
    attr_accessor :min_fraction_digits
    alias_method :attr_min_fraction_digits, :min_fraction_digits
    undef_method :min_fraction_digits
    alias_method :attr_min_fraction_digits=, :min_fraction_digits=
    undef_method :min_fraction_digits=
    
    # True if this format will parse numbers as integers only.
    # 
    # @serial
    # @see #isParseIntegerOnly
    attr_accessor :parse_integer_only
    alias_method :attr_parse_integer_only, :parse_integer_only
    undef_method :parse_integer_only
    alias_method :attr_parse_integer_only=, :parse_integer_only=
    undef_method :parse_integer_only=
    
    # new fields for 1.2.  byte is too small for integer digits.
    # 
    # The maximum number of digits allowed in the integer portion of a
    # number.  <code>maximumIntegerDigits</code> must be greater than or equal to
    # <code>minimumIntegerDigits</code>.
    # 
    # @serial
    # @since 1.2
    # @see #getMaximumIntegerDigits
    attr_accessor :maximum_integer_digits
    alias_method :attr_maximum_integer_digits, :maximum_integer_digits
    undef_method :maximum_integer_digits
    alias_method :attr_maximum_integer_digits=, :maximum_integer_digits=
    undef_method :maximum_integer_digits=
    
    # The minimum number of digits allowed in the integer portion of a
    # number.  <code>minimumIntegerDigits</code> must be less than or equal to
    # <code>maximumIntegerDigits</code>.
    # 
    # @serial
    # @since 1.2
    # @see #getMinimumIntegerDigits
    attr_accessor :minimum_integer_digits
    alias_method :attr_minimum_integer_digits, :minimum_integer_digits
    undef_method :minimum_integer_digits
    alias_method :attr_minimum_integer_digits=, :minimum_integer_digits=
    undef_method :minimum_integer_digits=
    
    # The maximum number of digits allowed in the fractional portion of a
    # number.  <code>maximumFractionDigits</code> must be greater than or equal to
    # <code>minimumFractionDigits</code>.
    # 
    # @serial
    # @since 1.2
    # @see #getMaximumFractionDigits
    attr_accessor :maximum_fraction_digits
    alias_method :attr_maximum_fraction_digits, :maximum_fraction_digits
    undef_method :maximum_fraction_digits
    alias_method :attr_maximum_fraction_digits=, :maximum_fraction_digits=
    undef_method :maximum_fraction_digits=
    
    # invariant, >= minFractionDigits
    # 
    # The minimum number of digits allowed in the fractional portion of a
    # number.  <code>minimumFractionDigits</code> must be less than or equal to
    # <code>maximumFractionDigits</code>.
    # 
    # @serial
    # @since 1.2
    # @see #getMinimumFractionDigits
    attr_accessor :minimum_fraction_digits
    alias_method :attr_minimum_fraction_digits, :minimum_fraction_digits
    undef_method :minimum_fraction_digits
    alias_method :attr_minimum_fraction_digits=, :minimum_fraction_digits=
    undef_method :minimum_fraction_digits=
    
    class_module.module_eval {
      const_set_lazy(:CurrentSerialVersion) { 1 }
      const_attr_reader  :CurrentSerialVersion
    }
    
    # Describes the version of <code>NumberFormat</code> present on the stream.
    # Possible values are:
    # <ul>
    # <li><b>0</b> (or uninitialized): the JDK 1.1 version of the stream format.
    # In this version, the <code>int</code> fields such as
    # <code>maximumIntegerDigits</code> were not present, and the <code>byte</code>
    # fields such as <code>maxIntegerDigits</code> are used instead.
    # 
    # <li><b>1</b>: the 1.2 version of the stream format.  The values of the
    # <code>byte</code> fields such as <code>maxIntegerDigits</code> are ignored,
    # and the <code>int</code> fields such as <code>maximumIntegerDigits</code>
    # are used instead.
    # </ul>
    # When streaming out a <code>NumberFormat</code>, the most recent format
    # (corresponding to the highest allowable <code>serialVersionOnStream</code>)
    # is always written.
    # 
    # @serial
    # @since 1.2
    attr_accessor :serial_version_on_stream
    alias_method :attr_serial_version_on_stream, :serial_version_on_stream
    undef_method :serial_version_on_stream
    alias_method :attr_serial_version_on_stream=, :serial_version_on_stream=
    undef_method :serial_version_on_stream=
    
    class_module.module_eval {
      # Removed "implements Cloneable" clause.  Needs to update serialization
      # ID for backward compatibility.
      const_set_lazy(:SerialVersionUID) { -2308460125733713944 }
      const_attr_reader  :SerialVersionUID
      
      # class for AttributedCharacterIterator attributes
      # 
      # 
      # Defines constants that are used as attribute keys in the
      # <code>AttributedCharacterIterator</code> returned
      # from <code>NumberFormat.formatToCharacterIterator</code> and as
      # field identifiers in <code>FieldPosition</code>.
      # 
      # @since 1.4
      const_set_lazy(:Field) { Class.new(Format::Field) do
        include_class_members NumberFormat
        
        class_module.module_eval {
          # Proclaim serial compatibility with 1.4 FCS
          const_set_lazy(:SerialVersionUID) { 7494728892700160890 }
          const_attr_reader  :SerialVersionUID
          
          # table of all instances in this class, used by readResolve
          const_set_lazy(:InstanceMap) { HashMap.new(11) }
          const_attr_reader  :InstanceMap
        }
        
        typesig { [String] }
        # Creates a Field instance with the specified
        # name.
        # 
        # @param name Name of the attribute
        def initialize(name)
          super(name)
          if ((self.get_class).equal?(NumberFormat::Field.class))
            self.class::InstanceMap.put(name, self)
          end
        end
        
        typesig { [] }
        # Resolves instances being deserialized to the predefined constants.
        # 
        # @throws InvalidObjectException if the constant could not be resolved.
        # @return resolved NumberFormat.Field constant
        def read_resolve
          if (!(self.get_class).equal?(NumberFormat::Field.class))
            raise InvalidObjectException.new("subclass didn't correctly implement readResolve")
          end
          instance = self.class::InstanceMap.get(get_name)
          if (!(instance).nil?)
            return instance
          else
            raise InvalidObjectException.new("unknown attribute name")
          end
        end
        
        class_module.module_eval {
          # Constant identifying the integer field.
          const_set_lazy(:INTEGER) { Field.new("integer") }
          const_attr_reader  :INTEGER
          
          # Constant identifying the fraction field.
          const_set_lazy(:FRACTION) { Field.new("fraction") }
          const_attr_reader  :FRACTION
          
          # Constant identifying the exponent field.
          const_set_lazy(:EXPONENT) { Field.new("exponent") }
          const_attr_reader  :EXPONENT
          
          # Constant identifying the decimal separator field.
          const_set_lazy(:DECIMAL_SEPARATOR) { Field.new("decimal separator") }
          const_attr_reader  :DECIMAL_SEPARATOR
          
          # Constant identifying the sign field.
          const_set_lazy(:SIGN) { Field.new("sign") }
          const_attr_reader  :SIGN
          
          # Constant identifying the grouping separator field.
          const_set_lazy(:GROUPING_SEPARATOR) { Field.new("grouping separator") }
          const_attr_reader  :GROUPING_SEPARATOR
          
          # Constant identifying the exponent symbol field.
          const_set_lazy(:EXPONENT_SYMBOL) { Field.new("exponent symbol") }
          const_attr_reader  :EXPONENT_SYMBOL
          
          # Constant identifying the percent field.
          const_set_lazy(:PERCENT) { Field.new("percent") }
          const_attr_reader  :PERCENT
          
          # Constant identifying the permille field.
          const_set_lazy(:PERMILLE) { Field.new("per mille") }
          const_attr_reader  :PERMILLE
          
          # Constant identifying the currency field.
          const_set_lazy(:CURRENCY) { Field.new("currency") }
          const_attr_reader  :CURRENCY
          
          # Constant identifying the exponent sign field.
          const_set_lazy(:EXPONENT_SIGN) { Field.new("exponent sign") }
          const_attr_reader  :EXPONENT_SIGN
        }
        
        private
        alias_method :initialize__field, :initialize
      end }
      
      # Obtains a NumberFormat instance from a NumberFormatProvider implementation.
      const_set_lazy(:NumberFormatGetter) { Class.new do
        include_class_members NumberFormat
        include LocaleServiceProviderPool::LocalizedObjectGetter
        
        class_module.module_eval {
          const_set_lazy(:INSTANCE) { NumberFormatGetter.new }
          const_attr_reader  :INSTANCE
        }
        
        typesig { [NumberFormatProvider, Locale, String, Object] }
        def get_object(number_format_provider, locale, key, *params)
          raise AssertError if not ((params.attr_length).equal?(1))
          choice = params[0]
          case (choice)
          when NUMBERSTYLE
            return number_format_provider.get_number_instance(locale)
          when PERCENTSTYLE
            return number_format_provider.get_percent_instance(locale)
          when CURRENCYSTYLE
            return number_format_provider.get_currency_instance(locale)
          when INTEGERSTYLE
            return number_format_provider.get_integer_instance(locale)
          else
            raise AssertError, (choice).to_s if not (false)
          end
          return nil
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__number_format_getter, :initialize
      end }
    }
    
    private
    alias_method :initialize__number_format, :initialize
  end
  
end
