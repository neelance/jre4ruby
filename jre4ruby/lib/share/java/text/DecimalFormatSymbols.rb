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
  module DecimalFormatSymbolsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Io, :Serializable
      include_const ::Java::Text::Spi, :DecimalFormatSymbolsProvider
      include_const ::Java::Util, :Currency
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util::Spi, :LocaleServiceProvider
      include_const ::Sun::Util, :LocaleServiceProviderPool
      include_const ::Sun::Util::Resources, :LocaleData
    }
  end
  
  # This class represents the set of symbols (such as the decimal separator,
  # the grouping separator, and so on) needed by <code>DecimalFormat</code>
  # to format numbers. <code>DecimalFormat</code> creates for itself an instance of
  # <code>DecimalFormatSymbols</code> from its locale data.  If you need to change any
  # of these symbols, you can get the <code>DecimalFormatSymbols</code> object from
  # your <code>DecimalFormat</code> and modify it.
  # 
  # @see          java.util.Locale
  # @see          DecimalFormat
  # @author       Mark Davis
  # @author       Alan Liu
  class DecimalFormatSymbols 
    include_class_members DecimalFormatSymbolsImports
    include Cloneable
    include Serializable
    
    typesig { [] }
    # Create a DecimalFormatSymbols object for the default locale.
    # This constructor can only construct instances for the locales
    # supported by the Java runtime environment, not for those
    # supported by installed
    # {@link java.text.spi.DecimalFormatSymbolsProvider DecimalFormatSymbolsProvider}
    # implementations. For full locale coverage, use the
    # {@link #getInstance(Locale) getInstance} method.
    def initialize
      @zero_digit = 0
      @grouping_separator = 0
      @decimal_separator = 0
      @per_mill = 0
      @percent = 0
      @digit = 0
      @pattern_separator = 0
      @infinity = nil
      @na_n = nil
      @minus_sign = 0
      @currency_symbol = nil
      @intl_currency_symbol = nil
      @monetary_separator = 0
      @exponential = 0
      @exponential_separator = nil
      @locale = nil
      @currency = nil
      @serial_version_on_stream = CurrentSerialVersion
      initialize_(Locale.get_default)
    end
    
    typesig { [Locale] }
    # Create a DecimalFormatSymbols object for the given locale.
    # This constructor can only construct instances for the locales
    # supported by the Java runtime environment, not for those
    # supported by installed
    # {@link java.text.spi.DecimalFormatSymbolsProvider DecimalFormatSymbolsProvider}
    # implementations. For full locale coverage, use the
    # {@link #getInstance(Locale) getInstance} method.
    # 
    # @exception NullPointerException if <code>locale</code> is null
    def initialize(locale)
      @zero_digit = 0
      @grouping_separator = 0
      @decimal_separator = 0
      @per_mill = 0
      @percent = 0
      @digit = 0
      @pattern_separator = 0
      @infinity = nil
      @na_n = nil
      @minus_sign = 0
      @currency_symbol = nil
      @intl_currency_symbol = nil
      @monetary_separator = 0
      @exponential = 0
      @exponential_separator = nil
      @locale = nil
      @currency = nil
      @serial_version_on_stream = CurrentSerialVersion
      initialize_(locale)
    end
    
    class_module.module_eval {
      typesig { [] }
      # Returns an array of all locales for which the
      # <code>getInstance</code> methods of this class can return
      # localized instances.
      # The returned array represents the union of locales supported by the Java
      # runtime and by installed
      # {@link java.text.spi.DecimalFormatSymbolsProvider DecimalFormatSymbolsProvider}
      # implementations.  It must contain at least a <code>Locale</code>
      # instance equal to {@link java.util.Locale#US Locale.US}.
      # 
      # @return An array of locales for which localized
      # <code>DecimalFormatSymbols</code> instances are available.
      # @since 1.6
      def get_available_locales
        pool = LocaleServiceProviderPool.get_pool(DecimalFormatSymbolsProvider)
        return pool.get_available_locales
      end
      
      typesig { [] }
      # Gets the <code>DecimalFormatSymbols</code> instance for the default
      # locale.  This method provides access to <code>DecimalFormatSymbols</code>
      # instances for locales supported by the Java runtime itself as well
      # as for those supported by installed
      # {@link java.text.spi.DecimalFormatSymbolsProvider
      # DecimalFormatSymbolsProvider} implementations.
      # @return a <code>DecimalFormatSymbols</code> instance.
      # @since 1.6
      def get_instance
        return get_instance(Locale.get_default)
      end
      
      typesig { [Locale] }
      # Gets the <code>DecimalFormatSymbols</code> instance for the specified
      # locale.  This method provides access to <code>DecimalFormatSymbols</code>
      # instances for locales supported by the Java runtime itself as well
      # as for those supported by installed
      # {@link java.text.spi.DecimalFormatSymbolsProvider
      # DecimalFormatSymbolsProvider} implementations.
      # @param locale the desired locale.
      # @return a <code>DecimalFormatSymbols</code> instance.
      # @exception NullPointerException if <code>locale</code> is null
      # @since 1.6
      def get_instance(locale)
        # Check whether a provider can provide an implementation that's closer
        # to the requested locale than what the Java runtime itself can provide.
        pool = LocaleServiceProviderPool.get_pool(DecimalFormatSymbolsProvider)
        if (pool.has_providers)
          providers_instance = pool.get_localized_object(DecimalFormatSymbolsGetter::INSTANCE, locale)
          if (!(providers_instance).nil?)
            return providers_instance
          end
        end
        return DecimalFormatSymbols.new(locale)
      end
    }
    
    typesig { [] }
    # Gets the character used for zero. Different for Arabic, etc.
    def get_zero_digit
      return @zero_digit
    end
    
    typesig { [::Java::Char] }
    # Sets the character used for zero. Different for Arabic, etc.
    def set_zero_digit(zero_digit)
      @zero_digit = zero_digit
    end
    
    typesig { [] }
    # Gets the character used for thousands separator. Different for French, etc.
    def get_grouping_separator
      return @grouping_separator
    end
    
    typesig { [::Java::Char] }
    # Sets the character used for thousands separator. Different for French, etc.
    def set_grouping_separator(grouping_separator)
      @grouping_separator = grouping_separator
    end
    
    typesig { [] }
    # Gets the character used for decimal sign. Different for French, etc.
    def get_decimal_separator
      return @decimal_separator
    end
    
    typesig { [::Java::Char] }
    # Sets the character used for decimal sign. Different for French, etc.
    def set_decimal_separator(decimal_separator)
      @decimal_separator = decimal_separator
    end
    
    typesig { [] }
    # Gets the character used for per mille sign. Different for Arabic, etc.
    def get_per_mill
      return @per_mill
    end
    
    typesig { [::Java::Char] }
    # Sets the character used for per mille sign. Different for Arabic, etc.
    def set_per_mill(per_mill)
      @per_mill = per_mill
    end
    
    typesig { [] }
    # Gets the character used for percent sign. Different for Arabic, etc.
    def get_percent
      return @percent
    end
    
    typesig { [::Java::Char] }
    # Sets the character used for percent sign. Different for Arabic, etc.
    def set_percent(percent)
      @percent = percent
    end
    
    typesig { [] }
    # Gets the character used for a digit in a pattern.
    def get_digit
      return @digit
    end
    
    typesig { [::Java::Char] }
    # Sets the character used for a digit in a pattern.
    def set_digit(digit)
      @digit = digit
    end
    
    typesig { [] }
    # Gets the character used to separate positive and negative subpatterns
    # in a pattern.
    def get_pattern_separator
      return @pattern_separator
    end
    
    typesig { [::Java::Char] }
    # Sets the character used to separate positive and negative subpatterns
    # in a pattern.
    def set_pattern_separator(pattern_separator)
      @pattern_separator = pattern_separator
    end
    
    typesig { [] }
    # Gets the string used to represent infinity. Almost always left
    # unchanged.
    def get_infinity
      return @infinity
    end
    
    typesig { [String] }
    # Sets the string used to represent infinity. Almost always left
    # unchanged.
    def set_infinity(infinity)
      @infinity = infinity
    end
    
    typesig { [] }
    # Gets the string used to represent "not a number". Almost always left
    # unchanged.
    def get_na_n
      return @na_n
    end
    
    typesig { [String] }
    # Sets the string used to represent "not a number". Almost always left
    # unchanged.
    def set_na_n(na_n)
      @na_n = na_n
    end
    
    typesig { [] }
    # Gets the character used to represent minus sign. If no explicit
    # negative format is specified, one is formed by prefixing
    # minusSign to the positive format.
    def get_minus_sign
      return @minus_sign
    end
    
    typesig { [::Java::Char] }
    # Sets the character used to represent minus sign. If no explicit
    # negative format is specified, one is formed by prefixing
    # minusSign to the positive format.
    def set_minus_sign(minus_sign)
      @minus_sign = minus_sign
    end
    
    typesig { [] }
    # Returns the currency symbol for the currency of these
    # DecimalFormatSymbols in their locale.
    # @since 1.2
    def get_currency_symbol
      return @currency_symbol
    end
    
    typesig { [String] }
    # Sets the currency symbol for the currency of these
    # DecimalFormatSymbols in their locale.
    # @since 1.2
    def set_currency_symbol(currency)
      @currency_symbol = currency
    end
    
    typesig { [] }
    # Returns the ISO 4217 currency code of the currency of these
    # DecimalFormatSymbols.
    # @since 1.2
    def get_international_currency_symbol
      return @intl_currency_symbol
    end
    
    typesig { [String] }
    # Sets the ISO 4217 currency code of the currency of these
    # DecimalFormatSymbols.
    # If the currency code is valid (as defined by
    # {@link java.util.Currency#getInstance(java.lang.String) Currency.getInstance}),
    # this also sets the currency attribute to the corresponding Currency
    # instance and the currency symbol attribute to the currency's symbol
    # in the DecimalFormatSymbols' locale. If the currency code is not valid,
    # then the currency attribute is set to null and the currency symbol
    # attribute is not modified.
    # 
    # @see #setCurrency
    # @see #setCurrencySymbol
    # @since 1.2
    def set_international_currency_symbol(currency_code)
      @intl_currency_symbol = currency_code
      @currency = nil
      if (!(currency_code).nil?)
        begin
          @currency = Currency.get_instance(currency_code)
          @currency_symbol = RJava.cast_to_string(@currency.get_symbol)
        rescue IllegalArgumentException => e
        end
      end
    end
    
    typesig { [] }
    # Gets the currency of these DecimalFormatSymbols. May be null if the
    # currency symbol attribute was previously set to a value that's not
    # a valid ISO 4217 currency code.
    # 
    # @return the currency used, or null
    # @since 1.4
    def get_currency
      return @currency
    end
    
    typesig { [Currency] }
    # Sets the currency of these DecimalFormatSymbols.
    # This also sets the currency symbol attribute to the currency's symbol
    # in the DecimalFormatSymbols' locale, and the international currency
    # symbol attribute to the currency's ISO 4217 currency code.
    # 
    # @param currency the new currency to be used
    # @exception NullPointerException if <code>currency</code> is null
    # @since 1.4
    # @see #setCurrencySymbol
    # @see #setInternationalCurrencySymbol
    def set_currency(currency)
      if ((currency).nil?)
        raise NullPointerException.new
      end
      @currency = currency
      @intl_currency_symbol = RJava.cast_to_string(currency.get_currency_code)
      @currency_symbol = RJava.cast_to_string(currency.get_symbol(@locale))
    end
    
    typesig { [] }
    # Returns the monetary decimal separator.
    # @since 1.2
    def get_monetary_decimal_separator
      return @monetary_separator
    end
    
    typesig { [::Java::Char] }
    # Sets the monetary decimal separator.
    # @since 1.2
    def set_monetary_decimal_separator(sep)
      @monetary_separator = sep
    end
    
    typesig { [] }
    # ------------------------------------------------------------
    # BEGIN   Package Private methods ... to be made public later
    # ------------------------------------------------------------
    # 
    # Returns the character used to separate the mantissa from the exponent.
    def get_exponential_symbol
      return @exponential
    end
    
    typesig { [] }
    # Returns the string used to separate the mantissa from the exponent.
    # Examples: "x10^" for 1.23x10^4, "E" for 1.23E4.
    # 
    # @return the exponent separator string
    # @see #setExponentSeparator(java.lang.String)
    # @since 1.6
    def get_exponent_separator
      return @exponential_separator
    end
    
    typesig { [::Java::Char] }
    # Sets the character used to separate the mantissa from the exponent.
    def set_exponential_symbol(exp)
      @exponential = exp
    end
    
    typesig { [String] }
    # Sets the string used to separate the mantissa from the exponent.
    # Examples: "x10^" for 1.23x10^4, "E" for 1.23E4.
    # 
    # @param exp the exponent separator string
    # @exception NullPointerException if <code>exp</code> is null
    # @see #getExponentSeparator()
    # @since 1.6
    def set_exponent_separator(exp)
      if ((exp).nil?)
        raise NullPointerException.new
      end
      @exponential_separator = exp
    end
    
    typesig { [] }
    # ------------------------------------------------------------
    # END     Package Private methods ... to be made public later
    # ------------------------------------------------------------
    # 
    # Standard override.
    def clone
      begin
        return super
        # other fields are bit-copied
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
    end
    
    typesig { [Object] }
    # Override equals.
    def ==(obj)
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
      return ((@zero_digit).equal?(other.attr_zero_digit) && (@grouping_separator).equal?(other.attr_grouping_separator) && (@decimal_separator).equal?(other.attr_decimal_separator) && (@percent).equal?(other.attr_percent) && (@per_mill).equal?(other.attr_per_mill) && (@digit).equal?(other.attr_digit) && (@minus_sign).equal?(other.attr_minus_sign) && (@pattern_separator).equal?(other.attr_pattern_separator) && (@infinity == other.attr_infinity) && (@na_n == other.attr_na_n) && (@currency_symbol == other.attr_currency_symbol) && (@intl_currency_symbol == other.attr_intl_currency_symbol) && (@currency).equal?(other.attr_currency) && (@monetary_separator).equal?(other.attr_monetary_separator) && (@exponential_separator == other.attr_exponential_separator) && (@locale == other.attr_locale))
    end
    
    typesig { [] }
    # Override hashCode.
    def hash_code
      result = @zero_digit
      result = result * 37 + @grouping_separator
      result = result * 37 + @decimal_separator
      return result
    end
    
    typesig { [Locale] }
    # Initializes the symbols from the FormatData resource bundle.
    def initialize_(locale)
      @locale = locale
      # get resource bundle data - try the cache first
      need_cache_update = false
      data = CachedLocaleData.get(locale)
      if ((data).nil?)
        # cache miss
        data = Array.typed(Object).new(3) { nil }
        rb = LocaleData.get_number_format_data(locale)
        data[0] = rb.get_string_array("NumberElements")
        need_cache_update = true
      end
      number_elements = data[0]
      @decimal_separator = number_elements[0].char_at(0)
      @grouping_separator = number_elements[1].char_at(0)
      @pattern_separator = number_elements[2].char_at(0)
      @percent = number_elements[3].char_at(0)
      @zero_digit = number_elements[4].char_at(0) # different for Arabic,etc.
      @digit = number_elements[5].char_at(0)
      @minus_sign = number_elements[6].char_at(0)
      @exponential = number_elements[7].char_at(0)
      @exponential_separator = RJava.cast_to_string(number_elements[7]) # string representation new since 1.6
      @per_mill = number_elements[8].char_at(0)
      @infinity = RJava.cast_to_string(number_elements[9])
      @na_n = RJava.cast_to_string(number_elements[10])
      # Try to obtain the currency used in the locale's country.
      # Check for empty country string separately because it's a valid
      # country ID for Locale (and used for the C locale), but not a valid
      # ISO 3166 country code, and exceptions are expensive.
      if (!("" == locale.get_country))
        begin
          @currency = Currency.get_instance(locale)
        rescue IllegalArgumentException => e
          # use default values below for compatibility
        end
      end
      if (!(@currency).nil?)
        @intl_currency_symbol = RJava.cast_to_string(@currency.get_currency_code)
        if (!(data[1]).nil? && (data[1]).equal?(@intl_currency_symbol))
          @currency_symbol = RJava.cast_to_string(data[2])
        else
          @currency_symbol = RJava.cast_to_string(@currency.get_symbol(locale))
          data[1] = @intl_currency_symbol
          data[2] = @currency_symbol
          need_cache_update = true
        end
      else
        # default values
        @intl_currency_symbol = "XXX"
        begin
          @currency = Currency.get_instance(@intl_currency_symbol)
        rescue IllegalArgumentException => e
        end
        @currency_symbol = ("".to_u << 0x00A4 << "")
      end
      # Currently the monetary decimal separator is the same as the
      # standard decimal separator for all locales that we support.
      # If that changes, add a new entry to NumberElements.
      @monetary_separator = @decimal_separator
      if (need_cache_update)
        CachedLocaleData.put(locale, data)
      end
    end
    
    typesig { [ObjectInputStream] }
    # Reads the default serializable fields, provides default values for objects
    # in older serial versions, and initializes non-serializable fields.
    # If <code>serialVersionOnStream</code>
    # is less than 1, initializes <code>monetarySeparator</code> to be
    # the same as <code>decimalSeparator</code> and <code>exponential</code>
    # to be 'E'.
    # If <code>serialVersionOnStream</code> is less than 2,
    # initializes <code>locale</code>to the root locale, and initializes
    # If <code>serialVersionOnStream</code> is less than 3, it initializes
    # <code>exponentialSeparator</code> using <code>exponential</code>.
    # Sets <code>serialVersionOnStream</code> back to the maximum allowed value so that
    # default serialization will work properly if this object is streamed out again.
    # Initializes the currency from the intlCurrencySymbol field.
    # 
    # @since JDK 1.1.6
    def read_object(stream)
      stream.default_read_object
      if (@serial_version_on_stream < 1)
        # Didn't have monetarySeparator or exponential field;
        # use defaults.
        @monetary_separator = @decimal_separator
        @exponential = Character.new(?E.ord)
      end
      if (@serial_version_on_stream < 2)
        # didn't have locale; use root locale
        @locale = Locale::ROOT
      end
      if (@serial_version_on_stream < 3)
        # didn't have exponentialSeparator. Create one using exponential
        @exponential_separator = RJava.cast_to_string(Character.to_s(@exponential))
      end
      @serial_version_on_stream = CurrentSerialVersion
      if (!(@intl_currency_symbol).nil?)
        begin
          @currency = Currency.get_instance(@intl_currency_symbol)
        rescue IllegalArgumentException => e
        end
      end
    end
    
    # Character used for zero.
    # 
    # @serial
    # @see #getZeroDigit
    attr_accessor :zero_digit
    alias_method :attr_zero_digit, :zero_digit
    undef_method :zero_digit
    alias_method :attr_zero_digit=, :zero_digit=
    undef_method :zero_digit=
    
    # Character used for thousands separator.
    # 
    # @serial
    # @see #getGroupingSeparator
    attr_accessor :grouping_separator
    alias_method :attr_grouping_separator, :grouping_separator
    undef_method :grouping_separator
    alias_method :attr_grouping_separator=, :grouping_separator=
    undef_method :grouping_separator=
    
    # Character used for decimal sign.
    # 
    # @serial
    # @see #getDecimalSeparator
    attr_accessor :decimal_separator
    alias_method :attr_decimal_separator, :decimal_separator
    undef_method :decimal_separator
    alias_method :attr_decimal_separator=, :decimal_separator=
    undef_method :decimal_separator=
    
    # Character used for per mille sign.
    # 
    # @serial
    # @see #getPerMill
    attr_accessor :per_mill
    alias_method :attr_per_mill, :per_mill
    undef_method :per_mill
    alias_method :attr_per_mill=, :per_mill=
    undef_method :per_mill=
    
    # Character used for percent sign.
    # @serial
    # @see #getPercent
    attr_accessor :percent
    alias_method :attr_percent, :percent
    undef_method :percent
    alias_method :attr_percent=, :percent=
    undef_method :percent=
    
    # Character used for a digit in a pattern.
    # 
    # @serial
    # @see #getDigit
    attr_accessor :digit
    alias_method :attr_digit, :digit
    undef_method :digit
    alias_method :attr_digit=, :digit=
    undef_method :digit=
    
    # Character used to separate positive and negative subpatterns
    # in a pattern.
    # 
    # @serial
    # @see #getPatternSeparator
    attr_accessor :pattern_separator
    alias_method :attr_pattern_separator, :pattern_separator
    undef_method :pattern_separator
    alias_method :attr_pattern_separator=, :pattern_separator=
    undef_method :pattern_separator=
    
    # String used to represent infinity.
    # @serial
    # @see #getInfinity
    attr_accessor :infinity
    alias_method :attr_infinity, :infinity
    undef_method :infinity
    alias_method :attr_infinity=, :infinity=
    undef_method :infinity=
    
    # String used to represent "not a number".
    # @serial
    # @see #getNaN
    attr_accessor :na_n
    alias_method :attr_na_n, :na_n
    undef_method :na_n
    alias_method :attr_na_n=, :na_n=
    undef_method :na_n=
    
    # Character used to represent minus sign.
    # @serial
    # @see #getMinusSign
    attr_accessor :minus_sign
    alias_method :attr_minus_sign, :minus_sign
    undef_method :minus_sign
    alias_method :attr_minus_sign=, :minus_sign=
    undef_method :minus_sign=
    
    # String denoting the local currency, e.g. "$".
    # @serial
    # @see #getCurrencySymbol
    attr_accessor :currency_symbol
    alias_method :attr_currency_symbol, :currency_symbol
    undef_method :currency_symbol
    alias_method :attr_currency_symbol=, :currency_symbol=
    undef_method :currency_symbol=
    
    # ISO 4217 currency code denoting the local currency, e.g. "USD".
    # @serial
    # @see #getInternationalCurrencySymbol
    attr_accessor :intl_currency_symbol
    alias_method :attr_intl_currency_symbol, :intl_currency_symbol
    undef_method :intl_currency_symbol
    alias_method :attr_intl_currency_symbol=, :intl_currency_symbol=
    undef_method :intl_currency_symbol=
    
    # The decimal separator used when formatting currency values.
    # @serial
    # @since JDK 1.1.6
    # @see #getMonetaryDecimalSeparator
    attr_accessor :monetary_separator
    alias_method :attr_monetary_separator, :monetary_separator
    undef_method :monetary_separator
    alias_method :attr_monetary_separator=, :monetary_separator=
    undef_method :monetary_separator=
    
    # Field new in JDK 1.1.6
    # 
    # The character used to distinguish the exponent in a number formatted
    # in exponential notation, e.g. 'E' for a number such as "1.23E45".
    # <p>
    # Note that the public API provides no way to set this field,
    # even though it is supported by the implementation and the stream format.
    # The intent is that this will be added to the API in the future.
    # 
    # @serial
    # @since JDK 1.1.6
    attr_accessor :exponential
    alias_method :attr_exponential, :exponential
    undef_method :exponential
    alias_method :attr_exponential=, :exponential=
    undef_method :exponential=
    
    # Field new in JDK 1.1.6
    # 
    # The string used to separate the mantissa from the exponent.
    # Examples: "x10^" for 1.23x10^4, "E" for 1.23E4.
    # <p>
    # If both <code>exponential</code> and <code>exponentialSeparator</code>
    # exist, this <code>exponentialSeparator</code> has the precedence.
    # 
    # @serial
    # @since 1.6
    attr_accessor :exponential_separator
    alias_method :attr_exponential_separator, :exponential_separator
    undef_method :exponential_separator
    alias_method :attr_exponential_separator=, :exponential_separator=
    undef_method :exponential_separator=
    
    # Field new in JDK 1.6
    # 
    # The locale of these currency format symbols.
    # 
    # @serial
    # @since 1.4
    attr_accessor :locale
    alias_method :attr_locale, :locale
    undef_method :locale
    alias_method :attr_locale=, :locale=
    undef_method :locale=
    
    # currency; only the ISO code is serialized.
    attr_accessor :currency
    alias_method :attr_currency, :currency
    undef_method :currency
    alias_method :attr_currency=, :currency=
    undef_method :currency=
    
    class_module.module_eval {
      # Proclaim JDK 1.1 FCS compatibility
      const_set_lazy(:SerialVersionUID) { 5772796243397350300 }
      const_attr_reader  :SerialVersionUID
      
      # The internal serial version which says which version was written
      # - 0 (default) for version up to JDK 1.1.5
      # - 1 for version from JDK 1.1.6, which includes two new fields:
      # monetarySeparator and exponential.
      # - 2 for version from J2SE 1.4, which includes locale field.
      # - 3 for version from J2SE 1.6, which includes exponentialSeparator field.
      const_set_lazy(:CurrentSerialVersion) { 3 }
      const_attr_reader  :CurrentSerialVersion
    }
    
    # Describes the version of <code>DecimalFormatSymbols</code> present on the stream.
    # Possible values are:
    # <ul>
    # <li><b>0</b> (or uninitialized): versions prior to JDK 1.1.6.
    # 
    # <li><b>1</b>: Versions written by JDK 1.1.6 or later, which include
    # two new fields: <code>monetarySeparator</code> and <code>exponential</code>.
    # <li><b>2</b>: Versions written by J2SE 1.4 or later, which include a
    # new <code>locale</code> field.
    # <li><b>3</b>: Versions written by J2SE 1.6 or later, which include a
    # new <code>exponentialSeparator</code> field.
    # </ul>
    # When streaming out a <code>DecimalFormatSymbols</code>, the most recent format
    # (corresponding to the highest allowable <code>serialVersionOnStream</code>)
    # is always written.
    # 
    # @serial
    # @since JDK 1.1.6
    attr_accessor :serial_version_on_stream
    alias_method :attr_serial_version_on_stream, :serial_version_on_stream
    undef_method :serial_version_on_stream
    alias_method :attr_serial_version_on_stream=, :serial_version_on_stream=
    undef_method :serial_version_on_stream=
    
    class_module.module_eval {
      # cache to hold the NumberElements and the Currency
      # of a Locale.
      const_set_lazy(:CachedLocaleData) { Hashtable.new(3) }
      const_attr_reader  :CachedLocaleData
      
      # Obtains a DecimalFormatSymbols instance from a DecimalFormatSymbolsProvider
      # implementation.
      const_set_lazy(:DecimalFormatSymbolsGetter) { Class.new do
        include_class_members DecimalFormatSymbols
        include LocaleServiceProviderPool::LocalizedObjectGetter
        
        class_module.module_eval {
          const_set_lazy(:INSTANCE) { class_self::DecimalFormatSymbolsGetter.new }
          const_attr_reader  :INSTANCE
        }
        
        typesig { [class_self::DecimalFormatSymbolsProvider, class_self::Locale, String, Object] }
        def get_object(decimal_format_symbols_provider, locale, key, *params)
          raise AssertError if not ((params.attr_length).equal?(0))
          return decimal_format_symbols_provider.get_instance(locale)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__decimal_format_symbols_getter, :initialize
      end }
    }
    
    private
    alias_method :initialize__decimal_format_symbols, :initialize
  end
  
end
