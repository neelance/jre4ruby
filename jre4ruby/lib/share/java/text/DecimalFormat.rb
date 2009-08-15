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
  module DecimalFormatImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Io, :InvalidObjectException
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Math, :BigDecimal
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Math, :RoundingMode
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Currency
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util::Concurrent::Atomic, :AtomicInteger
      include_const ::Java::Util::Concurrent::Atomic, :AtomicLong
      include_const ::Sun::Util::Resources, :LocaleData
    }
  end
  
  # <code>DecimalFormat</code> is a concrete subclass of
  # <code>NumberFormat</code> that formats decimal numbers. It has a variety of
  # features designed to make it possible to parse and format numbers in any
  # locale, including support for Western, Arabic, and Indic digits.  It also
  # supports different kinds of numbers, including integers (123), fixed-point
  # numbers (123.4), scientific notation (1.23E4), percentages (12%), and
  # currency amounts ($123).  All of these can be localized.
  # 
  # <p>To obtain a <code>NumberFormat</code> for a specific locale, including the
  # default locale, call one of <code>NumberFormat</code>'s factory methods, such
  # as <code>getInstance()</code>.  In general, do not call the
  # <code>DecimalFormat</code> constructors directly, since the
  # <code>NumberFormat</code> factory methods may return subclasses other than
  # <code>DecimalFormat</code>. If you need to customize the format object, do
  # something like this:
  # 
  # <blockquote><pre>
  # NumberFormat f = NumberFormat.getInstance(loc);
  # if (f instanceof DecimalFormat) {
  # ((DecimalFormat) f).setDecimalSeparatorAlwaysShown(true);
  # }
  # </pre></blockquote>
  # 
  # <p>A <code>DecimalFormat</code> comprises a <em>pattern</em> and a set of
  # <em>symbols</em>.  The pattern may be set directly using
  # <code>applyPattern()</code>, or indirectly using the API methods.  The
  # symbols are stored in a <code>DecimalFormatSymbols</code> object.  When using
  # the <code>NumberFormat</code> factory methods, the pattern and symbols are
  # read from localized <code>ResourceBundle</code>s.
  # 
  # <h4>Patterns</h4>
  # 
  # <code>DecimalFormat</code> patterns have the following syntax:
  # <blockquote><pre>
  # <i>Pattern:</i>
  # <i>PositivePattern</i>
  # <i>PositivePattern</i> ; <i>NegativePattern</i>
  # <i>PositivePattern:</i>
  # <i>Prefix<sub>opt</sub></i> <i>Number</i> <i>Suffix<sub>opt</sub></i>
  # <i>NegativePattern:</i>
  # <i>Prefix<sub>opt</sub></i> <i>Number</i> <i>Suffix<sub>opt</sub></i>
  # <i>Prefix:</i>
  # any Unicode characters except &#92;uFFFE, &#92;uFFFF, and special characters
  # <i>Suffix:</i>
  # any Unicode characters except &#92;uFFFE, &#92;uFFFF, and special characters
  # <i>Number:</i>
  # <i>Integer</i> <i>Exponent<sub>opt</sub></i>
  # <i>Integer</i> . <i>Fraction</i> <i>Exponent<sub>opt</sub></i>
  # <i>Integer:</i>
  # <i>MinimumInteger</i>
  # #
  # # <i>Integer</i>
  # # , <i>Integer</i>
  # <i>MinimumInteger:</i>
  # 0
  # 0 <i>MinimumInteger</i>
  # 0 , <i>MinimumInteger</i>
  # <i>Fraction:</i>
  # <i>MinimumFraction<sub>opt</sub></i> <i>OptionalFraction<sub>opt</sub></i>
  # <i>MinimumFraction:</i>
  # 0 <i>MinimumFraction<sub>opt</sub></i>
  # <i>OptionalFraction:</i>
  # # <i>OptionalFraction<sub>opt</sub></i>
  # <i>Exponent:</i>
  # E <i>MinimumExponent</i>
  # <i>MinimumExponent:</i>
  # 0 <i>MinimumExponent<sub>opt</sub></i>
  # </pre></blockquote>
  # 
  # <p>A <code>DecimalFormat</code> pattern contains a positive and negative
  # subpattern, for example, <code>"#,##0.00;(#,##0.00)"</code>.  Each
  # subpattern has a prefix, numeric part, and suffix. The negative subpattern
  # is optional; if absent, then the positive subpattern prefixed with the
  # localized minus sign (<code>'-'</code> in most locales) is used as the
  # negative subpattern. That is, <code>"0.00"</code> alone is equivalent to
  # <code>"0.00;-0.00"</code>.  If there is an explicit negative subpattern, it
  # serves only to specify the negative prefix and suffix; the number of digits,
  # minimal digits, and other characteristics are all the same as the positive
  # pattern. That means that <code>"#,##0.0#;(#)"</code> produces precisely
  # the same behavior as <code>"#,##0.0#;(#,##0.0#)"</code>.
  # 
  # <p>The prefixes, suffixes, and various symbols used for infinity, digits,
  # thousands separators, decimal separators, etc. may be set to arbitrary
  # values, and they will appear properly during formatting.  However, care must
  # be taken that the symbols and strings do not conflict, or parsing will be
  # unreliable.  For example, either the positive and negative prefixes or the
  # suffixes must be distinct for <code>DecimalFormat.parse()</code> to be able
  # to distinguish positive from negative values.  (If they are identical, then
  # <code>DecimalFormat</code> will behave as if no negative subpattern was
  # specified.)  Another example is that the decimal separator and thousands
  # separator should be distinct characters, or parsing will be impossible.
  # 
  # <p>The grouping separator is commonly used for thousands, but in some
  # countries it separates ten-thousands. The grouping size is a constant number
  # of digits between the grouping characters, such as 3 for 100,000,000 or 4 for
  # 1,0000,0000.  If you supply a pattern with multiple grouping characters, the
  # interval between the last one and the end of the integer is the one that is
  # used. So <code>"#,##,###,####"</code> == <code>"######,####"</code> ==
  # <code>"##,####,####"</code>.
  # 
  # <h4>Special Pattern Characters</h4>
  # 
  # <p>Many characters in a pattern are taken literally; they are matched during
  # parsing and output unchanged during formatting.  Special characters, on the
  # other hand, stand for other characters, strings, or classes of characters.
  # They must be quoted, unless noted otherwise, if they are to appear in the
  # prefix or suffix as literals.
  # 
  # <p>The characters listed here are used in non-localized patterns.  Localized
  # patterns use the corresponding characters taken from this formatter's
  # <code>DecimalFormatSymbols</code> object instead, and these characters lose
  # their special status.  Two exceptions are the currency sign and quote, which
  # are not localized.
  # 
  # <blockquote>
  # <table border=0 cellspacing=3 cellpadding=0 summary="Chart showing symbol,
  # location, localized, and meaning.">
  # <tr bgcolor="#ccccff">
  # <th align=left>Symbol
  # <th align=left>Location
  # <th align=left>Localized?
  # <th align=left>Meaning
  # <tr valign=top>
  # <td><code>0</code>
  # <td>Number
  # <td>Yes
  # <td>Digit
  # <tr valign=top bgcolor="#eeeeff">
  # <td><code>#</code>
  # <td>Number
  # <td>Yes
  # <td>Digit, zero shows as absent
  # <tr valign=top>
  # <td><code>.</code>
  # <td>Number
  # <td>Yes
  # <td>Decimal separator or monetary decimal separator
  # <tr valign=top bgcolor="#eeeeff">
  # <td><code>-</code>
  # <td>Number
  # <td>Yes
  # <td>Minus sign
  # <tr valign=top>
  # <td><code>,</code>
  # <td>Number
  # <td>Yes
  # <td>Grouping separator
  # <tr valign=top bgcolor="#eeeeff">
  # <td><code>E</code>
  # <td>Number
  # <td>Yes
  # <td>Separates mantissa and exponent in scientific notation.
  # <em>Need not be quoted in prefix or suffix.</em>
  # <tr valign=top>
  # <td><code>;</code>
  # <td>Subpattern boundary
  # <td>Yes
  # <td>Separates positive and negative subpatterns
  # <tr valign=top bgcolor="#eeeeff">
  # <td><code>%</code>
  # <td>Prefix or suffix
  # <td>Yes
  # <td>Multiply by 100 and show as percentage
  # <tr valign=top>
  # <td><code>&#92;u2030</code>
  # <td>Prefix or suffix
  # <td>Yes
  # <td>Multiply by 1000 and show as per mille value
  # <tr valign=top bgcolor="#eeeeff">
  # <td><code>&#164;</code> (<code>&#92;u00A4</code>)
  # <td>Prefix or suffix
  # <td>No
  # <td>Currency sign, replaced by currency symbol.  If
  # doubled, replaced by international currency symbol.
  # If present in a pattern, the monetary decimal separator
  # is used instead of the decimal separator.
  # <tr valign=top>
  # <td><code>'</code>
  # <td>Prefix or suffix
  # <td>No
  # <td>Used to quote special characters in a prefix or suffix,
  # for example, <code>"'#'#"</code> formats 123 to
  # <code>"#123"</code>.  To create a single quote
  # itself, use two in a row: <code>"# o''clock"</code>.
  # </table>
  # </blockquote>
  # 
  # <h4>Scientific Notation</h4>
  # 
  # <p>Numbers in scientific notation are expressed as the product of a mantissa
  # and a power of ten, for example, 1234 can be expressed as 1.234 x 10^3.  The
  # mantissa is often in the range 1.0 <= x < 10.0, but it need not be.
  # <code>DecimalFormat</code> can be instructed to format and parse scientific
  # notation <em>only via a pattern</em>; there is currently no factory method
  # that creates a scientific notation format.  In a pattern, the exponent
  # character immediately followed by one or more digit characters indicates
  # scientific notation.  Example: <code>"0.###E0"</code> formats the number
  # 1234 as <code>"1.234E3"</code>.
  # 
  # <ul>
  # <li>The number of digit characters after the exponent character gives the
  # minimum exponent digit count.  There is no maximum.  Negative exponents are
  # formatted using the localized minus sign, <em>not</em> the prefix and suffix
  # from the pattern.  This allows patterns such as <code>"0.###E0 m/s"</code>.
  # 
  # <li>The minimum and maximum number of integer digits are interpreted
  # together:
  # 
  # <ul>
  # <li>If the maximum number of integer digits is greater than their minimum number
  # and greater than 1, it forces the exponent to be a multiple of the maximum
  # number of integer digits, and the minimum number of integer digits to be
  # interpreted as 1.  The most common use of this is to generate
  # <em>engineering notation</em>, in which the exponent is a multiple of three,
  # e.g., <code>"##0.#####E0"</code>. Using this pattern, the number 12345
  # formats to <code>"12.345E3"</code>, and 123456 formats to
  # <code>"123.456E3"</code>.
  # 
  # <li>Otherwise, the minimum number of integer digits is achieved by adjusting the
  # exponent.  Example: 0.00123 formatted with <code>"00.###E0"</code> yields
  # <code>"12.3E-4"</code>.
  # </ul>
  # 
  # <li>The number of significant digits in the mantissa is the sum of the
  # <em>minimum integer</em> and <em>maximum fraction</em> digits, and is
  # unaffected by the maximum integer digits.  For example, 12345 formatted with
  # <code>"##0.##E0"</code> is <code>"12.3E3"</code>. To show all digits, set
  # the significant digits count to zero.  The number of significant digits
  # does not affect parsing.
  # 
  # <li>Exponential patterns may not contain grouping separators.
  # </ul>
  # 
  # <h4>Rounding</h4>
  # 
  # <code>DecimalFormat</code> provides rounding modes defined in
  # {@link java.math.RoundingMode} for formatting.  By default, it uses
  # {@link java.math.RoundingMode#HALF_EVEN RoundingMode.HALF_EVEN}.
  # 
  # <h4>Digits</h4>
  # 
  # For formatting, <code>DecimalFormat</code> uses the ten consecutive
  # characters starting with the localized zero digit defined in the
  # <code>DecimalFormatSymbols</code> object as digits. For parsing, these
  # digits as well as all Unicode decimal digits, as defined by
  # {@link Character#digit Character.digit}, are recognized.
  # 
  # <h4>Special Values</h4>
  # 
  # <p><code>NaN</code> is formatted as a string, which typically has a single character
  # <code>&#92;uFFFD</code>.  This string is determined by the
  # <code>DecimalFormatSymbols</code> object.  This is the only value for which
  # the prefixes and suffixes are not used.
  # 
  # <p>Infinity is formatted as a string, which typically has a single character
  # <code>&#92;u221E</code>, with the positive or negative prefixes and suffixes
  # applied.  The infinity string is determined by the
  # <code>DecimalFormatSymbols</code> object.
  # 
  # <p>Negative zero (<code>"-0"</code>) parses to
  # <ul>
  # <li><code>BigDecimal(0)</code> if <code>isParseBigDecimal()</code> is
  # true,
  # <li><code>Long(0)</code> if <code>isParseBigDecimal()</code> is false
  # and <code>isParseIntegerOnly()</code> is true,
  # <li><code>Double(-0.0)</code> if both <code>isParseBigDecimal()</code>
  # and <code>isParseIntegerOnly()</code> are false.
  # </ul>
  # 
  # <h4><a name="synchronization">Synchronization</a></h4>
  # 
  # <p>
  # Decimal formats are generally not synchronized.
  # It is recommended to create separate format instances for each thread.
  # If multiple threads access a format concurrently, it must be synchronized
  # externally.
  # 
  # <h4>Example</h4>
  # 
  # <blockquote><pre>
  # <strong>// Print out a number using the localized number, integer, currency,
  # // and percent format for each locale</strong>
  # Locale[] locales = NumberFormat.getAvailableLocales();
  # double myNumber = -1234.56;
  # NumberFormat form;
  # for (int j=0; j<4; ++j) {
  # System.out.println("FORMAT");
  # for (int i = 0; i < locales.length; ++i) {
  # if (locales[i].getCountry().length() == 0) {
  # continue; // Skip language-only locales
  # }
  # System.out.print(locales[i].getDisplayName());
  # switch (j) {
  # case 0:
  # form = NumberFormat.getInstance(locales[i]); break;
  # case 1:
  # form = NumberFormat.getIntegerInstance(locales[i]); break;
  # case 2:
  # form = NumberFormat.getCurrencyInstance(locales[i]); break;
  # default:
  # form = NumberFormat.getPercentInstance(locales[i]); break;
  # }
  # if (form instanceof DecimalFormat) {
  # System.out.print(": " + ((DecimalFormat) form).toPattern());
  # }
  # System.out.print(" -> " + form.format(myNumber));
  # try {
  # System.out.println(" -> " + form.parse(form.format(myNumber)));
  # } catch (ParseException e) {}
  # }
  # }
  # </pre></blockquote>
  # 
  # @see          <a href="http://java.sun.com/docs/books/tutorial/i18n/format/decimalFormat.html">Java Tutorial</a>
  # @see          NumberFormat
  # @see          DecimalFormatSymbols
  # @see          ParsePosition
  # @author       Mark Davis
  # @author       Alan Liu
  class DecimalFormat < DecimalFormatImports.const_get :NumberFormat
    include_class_members DecimalFormatImports
    
    typesig { [] }
    # Creates a DecimalFormat using the default pattern and symbols
    # for the default locale. This is a convenient way to obtain a
    # DecimalFormat when internationalization is not the main concern.
    # <p>
    # To obtain standard formats for a given locale, use the factory methods
    # on NumberFormat such as getNumberInstance. These factories will
    # return the most appropriate sub-class of NumberFormat for a given
    # locale.
    # 
    # @see java.text.NumberFormat#getInstance
    # @see java.text.NumberFormat#getNumberInstance
    # @see java.text.NumberFormat#getCurrencyInstance
    # @see java.text.NumberFormat#getPercentInstance
    def initialize
      @big_integer_multiplier = nil
      @big_decimal_multiplier = nil
      @digit_list = nil
      @positive_prefix = nil
      @positive_suffix = nil
      @negative_prefix = nil
      @negative_suffix = nil
      @pos_prefix_pattern = nil
      @pos_suffix_pattern = nil
      @neg_prefix_pattern = nil
      @neg_suffix_pattern = nil
      @multiplier = 0
      @grouping_size = 0
      @decimal_separator_always_shown = false
      @parse_big_decimal = false
      @is_currency_format = false
      @symbols = nil
      @use_exponential_notation = false
      @positive_prefix_field_positions = nil
      @positive_suffix_field_positions = nil
      @negative_prefix_field_positions = nil
      @negative_suffix_field_positions = nil
      @min_exponent_digits = 0
      @maximum_integer_digits = 0
      @minimum_integer_digits = 0
      @maximum_fraction_digits = 0
      @minimum_fraction_digits = 0
      @rounding_mode = nil
      @serial_version_on_stream = 0
      super()
      @digit_list = DigitList.new
      @positive_prefix = ""
      @positive_suffix = ""
      @negative_prefix = "-"
      @negative_suffix = ""
      @multiplier = 1
      @grouping_size = 3
      @decimal_separator_always_shown = false
      @parse_big_decimal = false
      @is_currency_format = false
      @symbols = nil
      @maximum_integer_digits = NumberFormat.instance_method(:get_maximum_integer_digits).bind(self).call
      @minimum_integer_digits = NumberFormat.instance_method(:get_minimum_integer_digits).bind(self).call
      @maximum_fraction_digits = NumberFormat.instance_method(:get_maximum_fraction_digits).bind(self).call
      @minimum_fraction_digits = NumberFormat.instance_method(:get_minimum_fraction_digits).bind(self).call
      @rounding_mode = RoundingMode::HALF_EVEN
      @serial_version_on_stream = CurrentSerialVersion
      def_ = Locale.get_default
      # try to get the pattern from the cache
      pattern = self.attr_cached_locale_data.get(def_)
      if ((pattern).nil?)
        # cache miss
        # Get the pattern for the default locale.
        rb = LocaleData.get_number_format_data(def_)
        all = rb.get_string_array("NumberPatterns")
        pattern = RJava.cast_to_string(all[0])
        # update cache
        self.attr_cached_locale_data.put(def_, pattern)
      end
      # Always applyPattern after the symbols are set
      @symbols = DecimalFormatSymbols.new(def_)
      apply_pattern(pattern, false)
    end
    
    typesig { [String] }
    # Creates a DecimalFormat using the given pattern and the symbols
    # for the default locale. This is a convenient way to obtain a
    # DecimalFormat when internationalization is not the main concern.
    # <p>
    # To obtain standard formats for a given locale, use the factory methods
    # on NumberFormat such as getNumberInstance. These factories will
    # return the most appropriate sub-class of NumberFormat for a given
    # locale.
    # 
    # @param pattern A non-localized pattern string.
    # @exception NullPointerException if <code>pattern</code> is null
    # @exception IllegalArgumentException if the given pattern is invalid.
    # @see java.text.NumberFormat#getInstance
    # @see java.text.NumberFormat#getNumberInstance
    # @see java.text.NumberFormat#getCurrencyInstance
    # @see java.text.NumberFormat#getPercentInstance
    def initialize(pattern)
      @big_integer_multiplier = nil
      @big_decimal_multiplier = nil
      @digit_list = nil
      @positive_prefix = nil
      @positive_suffix = nil
      @negative_prefix = nil
      @negative_suffix = nil
      @pos_prefix_pattern = nil
      @pos_suffix_pattern = nil
      @neg_prefix_pattern = nil
      @neg_suffix_pattern = nil
      @multiplier = 0
      @grouping_size = 0
      @decimal_separator_always_shown = false
      @parse_big_decimal = false
      @is_currency_format = false
      @symbols = nil
      @use_exponential_notation = false
      @positive_prefix_field_positions = nil
      @positive_suffix_field_positions = nil
      @negative_prefix_field_positions = nil
      @negative_suffix_field_positions = nil
      @min_exponent_digits = 0
      @maximum_integer_digits = 0
      @minimum_integer_digits = 0
      @maximum_fraction_digits = 0
      @minimum_fraction_digits = 0
      @rounding_mode = nil
      @serial_version_on_stream = 0
      super()
      @digit_list = DigitList.new
      @positive_prefix = ""
      @positive_suffix = ""
      @negative_prefix = "-"
      @negative_suffix = ""
      @multiplier = 1
      @grouping_size = 3
      @decimal_separator_always_shown = false
      @parse_big_decimal = false
      @is_currency_format = false
      @symbols = nil
      @maximum_integer_digits = NumberFormat.instance_method(:get_maximum_integer_digits).bind(self).call
      @minimum_integer_digits = NumberFormat.instance_method(:get_minimum_integer_digits).bind(self).call
      @maximum_fraction_digits = NumberFormat.instance_method(:get_maximum_fraction_digits).bind(self).call
      @minimum_fraction_digits = NumberFormat.instance_method(:get_minimum_fraction_digits).bind(self).call
      @rounding_mode = RoundingMode::HALF_EVEN
      @serial_version_on_stream = CurrentSerialVersion
      # Always applyPattern after the symbols are set
      @symbols = DecimalFormatSymbols.new(Locale.get_default)
      apply_pattern(pattern, false)
    end
    
    typesig { [String, DecimalFormatSymbols] }
    # Creates a DecimalFormat using the given pattern and symbols.
    # Use this constructor when you need to completely customize the
    # behavior of the format.
    # <p>
    # To obtain standard formats for a given
    # locale, use the factory methods on NumberFormat such as
    # getInstance or getCurrencyInstance. If you need only minor adjustments
    # to a standard format, you can modify the format returned by
    # a NumberFormat factory method.
    # 
    # @param pattern a non-localized pattern string
    # @param symbols the set of symbols to be used
    # @exception NullPointerException if any of the given arguments is null
    # @exception IllegalArgumentException if the given pattern is invalid
    # @see java.text.NumberFormat#getInstance
    # @see java.text.NumberFormat#getNumberInstance
    # @see java.text.NumberFormat#getCurrencyInstance
    # @see java.text.NumberFormat#getPercentInstance
    # @see java.text.DecimalFormatSymbols
    def initialize(pattern, symbols)
      @big_integer_multiplier = nil
      @big_decimal_multiplier = nil
      @digit_list = nil
      @positive_prefix = nil
      @positive_suffix = nil
      @negative_prefix = nil
      @negative_suffix = nil
      @pos_prefix_pattern = nil
      @pos_suffix_pattern = nil
      @neg_prefix_pattern = nil
      @neg_suffix_pattern = nil
      @multiplier = 0
      @grouping_size = 0
      @decimal_separator_always_shown = false
      @parse_big_decimal = false
      @is_currency_format = false
      @symbols = nil
      @use_exponential_notation = false
      @positive_prefix_field_positions = nil
      @positive_suffix_field_positions = nil
      @negative_prefix_field_positions = nil
      @negative_suffix_field_positions = nil
      @min_exponent_digits = 0
      @maximum_integer_digits = 0
      @minimum_integer_digits = 0
      @maximum_fraction_digits = 0
      @minimum_fraction_digits = 0
      @rounding_mode = nil
      @serial_version_on_stream = 0
      super()
      @digit_list = DigitList.new
      @positive_prefix = ""
      @positive_suffix = ""
      @negative_prefix = "-"
      @negative_suffix = ""
      @multiplier = 1
      @grouping_size = 3
      @decimal_separator_always_shown = false
      @parse_big_decimal = false
      @is_currency_format = false
      @symbols = nil
      @maximum_integer_digits = NumberFormat.instance_method(:get_maximum_integer_digits).bind(self).call
      @minimum_integer_digits = NumberFormat.instance_method(:get_minimum_integer_digits).bind(self).call
      @maximum_fraction_digits = NumberFormat.instance_method(:get_maximum_fraction_digits).bind(self).call
      @minimum_fraction_digits = NumberFormat.instance_method(:get_minimum_fraction_digits).bind(self).call
      @rounding_mode = RoundingMode::HALF_EVEN
      @serial_version_on_stream = CurrentSerialVersion
      # Always applyPattern after the symbols are set
      @symbols = symbols.clone
      apply_pattern(pattern, false)
    end
    
    typesig { [Object, StringBuffer, FieldPosition] }
    # Overrides
    # 
    # Formats a number and appends the resulting text to the given string
    # buffer.
    # The number can be of any subclass of {@link java.lang.Number}.
    # <p>
    # This implementation uses the maximum precision permitted.
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
        if (number.is_a?(BigDecimal))
          return format(number, to_append_to, pos)
        else
          if (number.is_a?(BigInteger))
            return format(number, to_append_to, pos)
          else
            if (number.is_a?(Numeric))
              return format((number).double_value, to_append_to, pos)
            else
              raise IllegalArgumentException.new("Cannot format given Object as a Number")
            end
          end
        end
      end
    end
    
    typesig { [::Java::Double, StringBuffer, FieldPosition] }
    # Formats a double to produce a string.
    # @param number    The double to format
    # @param result    where the text is to be appended
    # @param fieldPosition    On input: an alignment field, if desired.
    # On output: the offsets of the alignment field.
    # @exception ArithmeticException if rounding is needed with rounding
    # mode being set to RoundingMode.UNNECESSARY
    # @return The formatted number string
    # @see java.text.FieldPosition
    def format(number, result, field_position)
      field_position.set_begin_index(0)
      field_position.set_end_index(0)
      return format(number, result, field_position.get_field_delegate)
    end
    
    typesig { [::Java::Double, StringBuffer, FieldDelegate] }
    # Formats a double to produce a string.
    # @param number    The double to format
    # @param result    where the text is to be appended
    # @param delegate notified of locations of sub fields
    # @exception       ArithmeticException if rounding is needed with rounding
    # mode being set to RoundingMode.UNNECESSARY
    # @return The formatted number string
    def format(number, result, delegate)
      if (Double.is_na_n(number) || (Double.is_infinite(number) && (@multiplier).equal?(0)))
        i_field_start = result.length
        result.append(@symbols.get_na_n)
        delegate.formatted(INTEGER_FIELD, Field::INTEGER, Field::INTEGER, i_field_start, result.length, result)
        return result
      end
      # Detecting whether a double is negative is easy with the exception of
      # the value -0.0.  This is a double which has a zero mantissa (and
      # exponent), but a negative sign bit.  It is semantically distinct from
      # a zero with a positive sign bit, and this distinction is important
      # to certain kinds of computations.  However, it's a little tricky to
      # detect, since (-0.0 == 0.0) and !(-0.0 < 0.0).  How then, you may
      # ask, does it behave distinctly from +0.0?  Well, 1/(-0.0) ==
      # -Infinity.  Proper detection of -0.0 is needed to deal with the
      # issues raised by bugs 4106658, 4106667, and 4147706.  Liu 7/6/98.
      is_negative = ((number < 0.0) || ((number).equal?(0.0) && 1 / number < 0.0)) ^ (@multiplier < 0)
      if (!(@multiplier).equal?(1))
        number *= @multiplier
      end
      if (Double.is_infinite(number))
        if (is_negative)
          append(result, @negative_prefix, delegate, get_negative_prefix_field_positions, Field::SIGN)
        else
          append(result, @positive_prefix, delegate, get_positive_prefix_field_positions, Field::SIGN)
        end
        i_field_start = result.length
        result.append(@symbols.get_infinity)
        delegate.formatted(INTEGER_FIELD, Field::INTEGER, Field::INTEGER, i_field_start, result.length, result)
        if (is_negative)
          append(result, @negative_suffix, delegate, get_negative_suffix_field_positions, Field::SIGN)
        else
          append(result, @positive_suffix, delegate, get_positive_suffix_field_positions, Field::SIGN)
        end
        return result
      end
      if (is_negative)
        number = -number
      end
      # at this point we are guaranteed a nonnegative finite number.
      raise AssertError if not ((number >= 0 && !Double.is_infinite(number)))
      synchronized((@digit_list)) do
        max_int_digits = NumberFormat.instance_method(:get_maximum_integer_digits).bind(self).call
        min_int_digits = NumberFormat.instance_method(:get_minimum_integer_digits).bind(self).call
        max_fra_digits = NumberFormat.instance_method(:get_maximum_fraction_digits).bind(self).call
        min_fra_digits = NumberFormat.instance_method(:get_minimum_fraction_digits).bind(self).call
        @digit_list.set(is_negative, number, @use_exponential_notation ? max_int_digits + max_fra_digits : max_fra_digits, !@use_exponential_notation)
        return subformat(result, delegate, is_negative, false, max_int_digits, min_int_digits, max_fra_digits, min_fra_digits)
      end
    end
    
    typesig { [::Java::Long, StringBuffer, FieldPosition] }
    # Format a long to produce a string.
    # @param number    The long to format
    # @param result    where the text is to be appended
    # @param fieldPosition    On input: an alignment field, if desired.
    # On output: the offsets of the alignment field.
    # @exception       ArithmeticException if rounding is needed with rounding
    # mode being set to RoundingMode.UNNECESSARY
    # @return The formatted number string
    # @see java.text.FieldPosition
    def format(number, result, field_position)
      field_position.set_begin_index(0)
      field_position.set_end_index(0)
      return format(number, result, field_position.get_field_delegate)
    end
    
    typesig { [::Java::Long, StringBuffer, FieldDelegate] }
    # Format a long to produce a string.
    # @param number    The long to format
    # @param result    where the text is to be appended
    # @param delegate notified of locations of sub fields
    # @return The formatted number string
    # @exception        ArithmeticException if rounding is needed with rounding
    # mode being set to RoundingMode.UNNECESSARY
    # @see java.text.FieldPosition
    def format(number, result, delegate)
      is_negative = (number < 0)
      if (is_negative)
        number = -number
      end
      # In general, long values always represent real finite numbers, so
      # we don't have to check for +/- Infinity or NaN.  However, there
      # is one case we have to be careful of:  The multiplier can push
      # a number near MIN_VALUE or MAX_VALUE outside the legal range.  We
      # check for this before multiplying, and if it happens we use
      # BigInteger instead.
      use_big_integer = false
      if (number < 0)
        # This can only happen if number == Long.MIN_VALUE.
        if (!(@multiplier).equal?(0))
          use_big_integer = true
        end
      else
        if (!(@multiplier).equal?(1) && !(@multiplier).equal?(0))
          cutoff = Long::MAX_VALUE / @multiplier
          if (cutoff < 0)
            cutoff = -cutoff
          end
          use_big_integer = (number > cutoff)
        end
      end
      if (use_big_integer)
        if (is_negative)
          number = -number
        end
        big_integer_value = BigInteger.value_of(number)
        return format(big_integer_value, result, delegate, true)
      end
      number *= @multiplier
      if ((number).equal?(0))
        is_negative = false
      else
        if (@multiplier < 0)
          number = -number
          is_negative = !is_negative
        end
      end
      synchronized((@digit_list)) do
        max_int_digits = NumberFormat.instance_method(:get_maximum_integer_digits).bind(self).call
        min_int_digits = NumberFormat.instance_method(:get_minimum_integer_digits).bind(self).call
        max_fra_digits = NumberFormat.instance_method(:get_maximum_fraction_digits).bind(self).call
        min_fra_digits = NumberFormat.instance_method(:get_minimum_fraction_digits).bind(self).call
        @digit_list.set(is_negative, number, @use_exponential_notation ? max_int_digits + max_fra_digits : 0)
        return subformat(result, delegate, is_negative, true, max_int_digits, min_int_digits, max_fra_digits, min_fra_digits)
      end
    end
    
    typesig { [BigDecimal, StringBuffer, FieldPosition] }
    # Formats a BigDecimal to produce a string.
    # @param number    The BigDecimal to format
    # @param result    where the text is to be appended
    # @param fieldPosition    On input: an alignment field, if desired.
    # On output: the offsets of the alignment field.
    # @return The formatted number string
    # @exception        ArithmeticException if rounding is needed with rounding
    # mode being set to RoundingMode.UNNECESSARY
    # @see java.text.FieldPosition
    def format(number, result, field_position)
      field_position.set_begin_index(0)
      field_position.set_end_index(0)
      return format(number, result, field_position.get_field_delegate)
    end
    
    typesig { [BigDecimal, StringBuffer, FieldDelegate] }
    # Formats a BigDecimal to produce a string.
    # @param number    The BigDecimal to format
    # @param result    where the text is to be appended
    # @param delegate notified of locations of sub fields
    # @exception        ArithmeticException if rounding is needed with rounding
    # mode being set to RoundingMode.UNNECESSARY
    # @return The formatted number string
    def format(number, result, delegate)
      if (!(@multiplier).equal?(1))
        number = number.multiply(get_big_decimal_multiplier)
      end
      is_negative = (number.signum).equal?(-1)
      if (is_negative)
        number = number.negate
      end
      synchronized((@digit_list)) do
        max_int_digits = get_maximum_integer_digits
        min_int_digits = get_minimum_integer_digits
        max_fra_digits = get_maximum_fraction_digits
        min_fra_digits = get_minimum_fraction_digits
        maximum_digits = max_int_digits + max_fra_digits
        @digit_list.set(is_negative, number, @use_exponential_notation ? ((maximum_digits < 0) ? JavaInteger::MAX_VALUE : maximum_digits) : max_fra_digits, !@use_exponential_notation)
        return subformat(result, delegate, is_negative, false, max_int_digits, min_int_digits, max_fra_digits, min_fra_digits)
      end
    end
    
    typesig { [BigInteger, StringBuffer, FieldPosition] }
    # Format a BigInteger to produce a string.
    # @param number    The BigInteger to format
    # @param result    where the text is to be appended
    # @param fieldPosition    On input: an alignment field, if desired.
    # On output: the offsets of the alignment field.
    # @return The formatted number string
    # @exception        ArithmeticException if rounding is needed with rounding
    # mode being set to RoundingMode.UNNECESSARY
    # @see java.text.FieldPosition
    def format(number, result, field_position)
      field_position.set_begin_index(0)
      field_position.set_end_index(0)
      return format(number, result, field_position.get_field_delegate, false)
    end
    
    typesig { [BigInteger, StringBuffer, FieldDelegate, ::Java::Boolean] }
    # Format a BigInteger to produce a string.
    # @param number    The BigInteger to format
    # @param result    where the text is to be appended
    # @param delegate notified of locations of sub fields
    # @return The formatted number string
    # @exception        ArithmeticException if rounding is needed with rounding
    # mode being set to RoundingMode.UNNECESSARY
    # @see java.text.FieldPosition
    def format(number, result, delegate, format_long)
      if (!(@multiplier).equal?(1))
        number = number.multiply(get_big_integer_multiplier)
      end
      is_negative = (number.signum).equal?(-1)
      if (is_negative)
        number = number.negate
      end
      synchronized((@digit_list)) do
        max_int_digits = 0
        min_int_digits = 0
        max_fra_digits = 0
        min_fra_digits = 0
        maximum_digits = 0
        if (format_long)
          max_int_digits = NumberFormat.instance_method(:get_maximum_integer_digits).bind(self).call
          min_int_digits = NumberFormat.instance_method(:get_minimum_integer_digits).bind(self).call
          max_fra_digits = NumberFormat.instance_method(:get_maximum_fraction_digits).bind(self).call
          min_fra_digits = NumberFormat.instance_method(:get_minimum_fraction_digits).bind(self).call
          maximum_digits = max_int_digits + max_fra_digits
        else
          max_int_digits = get_maximum_integer_digits
          min_int_digits = get_minimum_integer_digits
          max_fra_digits = get_maximum_fraction_digits
          min_fra_digits = get_minimum_fraction_digits
          maximum_digits = max_int_digits + max_fra_digits
          if (maximum_digits < 0)
            maximum_digits = JavaInteger::MAX_VALUE
          end
        end
        @digit_list.set(is_negative, number, @use_exponential_notation ? maximum_digits : 0)
        return subformat(result, delegate, is_negative, true, max_int_digits, min_int_digits, max_fra_digits, min_fra_digits)
      end
    end
    
    typesig { [Object] }
    # Formats an Object producing an <code>AttributedCharacterIterator</code>.
    # You can use the returned <code>AttributedCharacterIterator</code>
    # to build the resulting String, as well as to determine information
    # about the resulting String.
    # <p>
    # Each attribute key of the AttributedCharacterIterator will be of type
    # <code>NumberFormat.Field</code>, with the attribute value being the
    # same as the attribute key.
    # 
    # @exception NullPointerException if obj is null.
    # @exception IllegalArgumentException when the Format cannot format the
    # given object.
    # @exception        ArithmeticException if rounding is needed with rounding
    # mode being set to RoundingMode.UNNECESSARY
    # @param obj The object to format
    # @return AttributedCharacterIterator describing the formatted value.
    # @since 1.4
    def format_to_character_iterator(obj)
      delegate = CharacterIteratorFieldDelegate.new
      sb = StringBuffer.new
      if (obj.is_a?(Double) || obj.is_a?(Float))
        format((obj).double_value, sb, delegate)
      else
        if (obj.is_a?(Long) || obj.is_a?(JavaInteger) || obj.is_a?(Short) || obj.is_a?(Byte) || obj.is_a?(AtomicInteger) || obj.is_a?(AtomicLong))
          format((obj).long_value, sb, delegate)
        else
          if (obj.is_a?(BigDecimal))
            format(obj, sb, delegate)
          else
            if (obj.is_a?(BigInteger))
              format(obj, sb, delegate, false)
            else
              if ((obj).nil?)
                raise NullPointerException.new("formatToCharacterIterator must be passed non-null object")
              else
                raise IllegalArgumentException.new("Cannot format given Object as a Number")
              end
            end
          end
        end
      end
      return delegate.get_iterator(sb.to_s)
    end
    
    typesig { [StringBuffer, FieldDelegate, ::Java::Boolean, ::Java::Boolean, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Complete the formatting of a finite number.  On entry, the digitList must
    # be filled in with the correct digits.
    def subformat(result, delegate, is_negative, is_integer, max_int_digits, min_int_digits, max_fra_digits, min_fra_digits)
      # NOTE: This isn't required anymore because DigitList takes care of this.
      # 
      # // The negative of the exponent represents the number of leading
      # // zeros between the decimal and the first non-zero digit, for
      # // a value < 0.1 (e.g., for 0.00123, -fExponent == 2).  If this
      # // is more than the maximum fraction digits, then we have an underflow
      # // for the printed representation.  We recognize this here and set
      # // the DigitList representation to zero in this situation.
      # 
      # if (-digitList.decimalAt >= getMaximumFractionDigits())
      # {
      # digitList.count = 0;
      # }
      zero = @symbols.get_zero_digit
      zero_delta = zero - Character.new(?0.ord) # '0' is the DigitList representation of zero
      grouping = @symbols.get_grouping_separator
      decimal = @is_currency_format ? @symbols.get_monetary_decimal_separator : @symbols.get_decimal_separator
      # Per bug 4147706, DecimalFormat must respect the sign of numbers which
      # format as zero.  This allows sensible computations and preserves
      # relations such as signum(1/x) = signum(x), where x is +Infinity or
      # -Infinity.  Prior to this fix, we always formatted zero values as if
      # they were positive.  Liu 7/6/98.
      if (@digit_list.is_zero)
        @digit_list.attr_decimal_at = 0 # Normalize
      end
      if (is_negative)
        append(result, @negative_prefix, delegate, get_negative_prefix_field_positions, Field::SIGN)
      else
        append(result, @positive_prefix, delegate, get_positive_prefix_field_positions, Field::SIGN)
      end
      if (@use_exponential_notation)
        i_field_start = result.length
        i_field_end = -1
        f_field_start = -1
        # Minimum integer digits are handled in exponential format by
        # adjusting the exponent.  For example, 0.01234 with 3 minimum
        # integer digits is "123.4E-4".
        # Maximum integer digits are interpreted as indicating the
        # repeating range.  This is useful for engineering notation, in
        # which the exponent is restricted to a multiple of 3.  For
        # example, 0.01234 with 3 maximum integer digits is "12.34e-3".
        # If maximum integer digits are > 1 and are larger than
        # minimum integer digits, then minimum integer digits are
        # ignored.
        exponent = @digit_list.attr_decimal_at
        repeat = max_int_digits
        minimum_integer_digits = min_int_digits
        if (repeat > 1 && repeat > min_int_digits)
          # A repeating range is defined; adjust to it as follows.
          # If repeat == 3, we have 6,5,4=>3; 3,2,1=>0; 0,-1,-2=>-3;
          # -3,-4,-5=>-6, etc. This takes into account that the
          # exponent we have here is off by one from what we expect;
          # it is for the format 0.MMMMMx10^n.
          if (exponent >= 1)
            exponent = ((exponent - 1) / repeat) * repeat
          else
            # integer division rounds towards 0
            exponent = ((exponent - repeat) / repeat) * repeat
          end
          minimum_integer_digits = 1
        else
          # No repeating range is defined; use minimum integer digits.
          exponent -= minimum_integer_digits
        end
        # We now output a minimum number of digits, and more if there
        # are more digits, up to the maximum number of digits.  We
        # place the decimal point after the "integer" digits, which
        # are the first (decimalAt - exponent) digits.
        minimum_digits = min_int_digits + min_fra_digits
        if (minimum_digits < 0)
          # overflow?
          minimum_digits = JavaInteger::MAX_VALUE
        end
        # The number of integer digits is handled specially if the number
        # is zero, since then there may be no digits.
        integer_digits = @digit_list.is_zero ? minimum_integer_digits : @digit_list.attr_decimal_at - exponent
        if (minimum_digits < integer_digits)
          minimum_digits = integer_digits
        end
        total_digits = @digit_list.attr_count
        if (minimum_digits > total_digits)
          total_digits = minimum_digits
        end
        added_decimal_separator = false
        i = 0
        while i < total_digits
          if ((i).equal?(integer_digits))
            # Record field information for caller.
            i_field_end = result.length
            result.append(decimal)
            added_decimal_separator = true
            # Record field information for caller.
            f_field_start = result.length
          end
          result.append((i < @digit_list.attr_count) ? RJava.cast_to_char((@digit_list.attr_digits[i] + zero_delta)) : zero)
          (i += 1)
        end
        if (@decimal_separator_always_shown && (total_digits).equal?(integer_digits))
          # Record field information for caller.
          i_field_end = result.length
          result.append(decimal)
          added_decimal_separator = true
          # Record field information for caller.
          f_field_start = result.length
        end
        # Record field information
        if ((i_field_end).equal?(-1))
          i_field_end = result.length
        end
        delegate.formatted(INTEGER_FIELD, Field::INTEGER, Field::INTEGER, i_field_start, i_field_end, result)
        if (added_decimal_separator)
          delegate.formatted(Field::DECIMAL_SEPARATOR, Field::DECIMAL_SEPARATOR, i_field_end, f_field_start, result)
        end
        if ((f_field_start).equal?(-1))
          f_field_start = result.length
        end
        delegate.formatted(FRACTION_FIELD, Field::FRACTION, Field::FRACTION, f_field_start, result.length, result)
        # The exponent is output using the pattern-specified minimum
        # exponent digits.  There is no maximum limit to the exponent
        # digits, since truncating the exponent would result in an
        # unacceptable inaccuracy.
        field_start = result.length
        result.append(@symbols.get_exponent_separator)
        delegate.formatted(Field::EXPONENT_SYMBOL, Field::EXPONENT_SYMBOL, field_start, result.length, result)
        # For zero values, we force the exponent to zero.  We
        # must do this here, and not earlier, because the value
        # is used to determine integer digit count above.
        if (@digit_list.is_zero)
          exponent = 0
        end
        negative_exponent = exponent < 0
        if (negative_exponent)
          exponent = -exponent
          field_start = result.length
          result.append(@symbols.get_minus_sign)
          delegate.formatted(Field::EXPONENT_SIGN, Field::EXPONENT_SIGN, field_start, result.length, result)
        end
        @digit_list.set(negative_exponent, exponent)
        e_field_start = result.length
        i_ = @digit_list.attr_decimal_at
        while i_ < @min_exponent_digits
          result.append(zero)
          (i_ += 1)
        end
        i__ = 0
        while i__ < @digit_list.attr_decimal_at
          result.append((i__ < @digit_list.attr_count) ? RJava.cast_to_char((@digit_list.attr_digits[i__] + zero_delta)) : zero)
          (i__ += 1)
        end
        delegate.formatted(Field::EXPONENT, Field::EXPONENT, e_field_start, result.length, result)
      else
        i_field_start = result.length
        # Output the integer portion.  Here 'count' is the total
        # number of integer digits we will display, including both
        # leading zeros required to satisfy getMinimumIntegerDigits,
        # and actual digits present in the number.
        count = min_int_digits
        digit_index = 0 # Index into digitList.fDigits[]
        if (@digit_list.attr_decimal_at > 0 && count < @digit_list.attr_decimal_at)
          count = @digit_list.attr_decimal_at
        end
        # Handle the case where getMaximumIntegerDigits() is smaller
        # than the real number of integer digits.  If this is so, we
        # output the least significant max integer digits.  For example,
        # the value 1997 printed with 2 max integer digits is just "97".
        if (count > max_int_digits)
          count = max_int_digits
          digit_index = @digit_list.attr_decimal_at - count
        end
        size_before_integer_part = result.length
        i = count - 1
        while i >= 0
          if (i < @digit_list.attr_decimal_at && digit_index < @digit_list.attr_count)
            # Output a real digit
            result.append(RJava.cast_to_char((@digit_list.attr_digits[((digit_index += 1) - 1)] + zero_delta)))
          else
            # Output a leading zero
            result.append(zero)
          end
          # Output grouping separator if necessary.  Don't output a
          # grouping separator if i==0 though; that's at the end of
          # the integer part.
          if (is_grouping_used && i > 0 && (!(@grouping_size).equal?(0)) && ((i % @grouping_size).equal?(0)))
            g_start = result.length
            result.append(grouping)
            delegate.formatted(Field::GROUPING_SEPARATOR, Field::GROUPING_SEPARATOR, g_start, result.length, result)
          end
          (i -= 1)
        end
        # Determine whether or not there are any printable fractional
        # digits.  If we've used up the digits we know there aren't.
        fraction_present = (min_fra_digits > 0) || (!is_integer && digit_index < @digit_list.attr_count)
        # If there is no fraction present, and we haven't printed any
        # integer digits, then print a zero.  Otherwise we won't print
        # _any_ digits, and we won't be able to parse this string.
        if (!fraction_present && (result.length).equal?(size_before_integer_part))
          result.append(zero)
        end
        delegate.formatted(INTEGER_FIELD, Field::INTEGER, Field::INTEGER, i_field_start, result.length, result)
        # Output the decimal separator if we always do so.
        s_start = result.length
        if (@decimal_separator_always_shown || fraction_present)
          result.append(decimal)
        end
        if (!(s_start).equal?(result.length))
          delegate.formatted(Field::DECIMAL_SEPARATOR, Field::DECIMAL_SEPARATOR, s_start, result.length, result)
        end
        f_field_start = result.length
        i_ = 0
        while i_ < max_fra_digits
          # Here is where we escape from the loop.  We escape if we've
          # output the maximum fraction digits (specified in the for
          # expression above).
          # We also stop when we've output the minimum digits and either:
          # we have an integer, so there is no fractional stuff to
          # display, or we're out of significant digits.
          if (i_ >= min_fra_digits && (is_integer || digit_index >= @digit_list.attr_count))
            break
          end
          # Output leading fractional zeros. These are zeros that come
          # after the decimal but before any significant digits. These
          # are only output if abs(number being formatted) < 1.0.
          if (-1 - i_ > (@digit_list.attr_decimal_at - 1))
            result.append(zero)
            (i_ += 1)
            next
          end
          # Output a digit, if we have any precision left, or a
          # zero if we don't.  We don't want to output noise digits.
          if (!is_integer && digit_index < @digit_list.attr_count)
            result.append(RJava.cast_to_char((@digit_list.attr_digits[((digit_index += 1) - 1)] + zero_delta)))
          else
            result.append(zero)
          end
          (i_ += 1)
        end
        # Record field information for caller.
        delegate.formatted(FRACTION_FIELD, Field::FRACTION, Field::FRACTION, f_field_start, result.length, result)
      end
      if (is_negative)
        append(result, @negative_suffix, delegate, get_negative_suffix_field_positions, Field::SIGN)
      else
        append(result, @positive_suffix, delegate, get_positive_suffix_field_positions, Field::SIGN)
      end
      return result
    end
    
    typesig { [StringBuffer, String, FieldDelegate, Array.typed(FieldPosition), Format::Field] }
    # Appends the String <code>string</code> to <code>result</code>.
    # <code>delegate</code> is notified of all  the
    # <code>FieldPosition</code>s in <code>positions</code>.
    # <p>
    # If one of the <code>FieldPosition</code>s in <code>positions</code>
    # identifies a <code>SIGN</code> attribute, it is mapped to
    # <code>signAttribute</code>. This is used
    # to map the <code>SIGN</code> attribute to the <code>EXPONENT</code>
    # attribute as necessary.
    # <p>
    # This is used by <code>subformat</code> to add the prefix/suffix.
    def append(result, string, delegate, positions, sign_attribute)
      start = result.length
      if (string.length > 0)
        result.append(string)
        counter = 0
        max = positions.attr_length
        while counter < max
          fp = positions[counter]
          attribute = fp.get_field_attribute
          if ((attribute).equal?(Field::SIGN))
            attribute = sign_attribute
          end
          delegate.formatted(attribute, attribute, start + fp.get_begin_index, start + fp.get_end_index, result)
          counter += 1
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
    # The subclass returned depends on the value of {@link #isParseBigDecimal}
    # as well as on the string being parsed.
    # <ul>
    # <li>If <code>isParseBigDecimal()</code> is false (the default),
    # most integer values are returned as <code>Long</code>
    # objects, no matter how they are written: <code>"17"</code> and
    # <code>"17.000"</code> both parse to <code>Long(17)</code>.
    # Values that cannot fit into a <code>Long</code> are returned as
    # <code>Double</code>s. This includes values with a fractional part,
    # infinite values, <code>NaN</code>, and the value -0.0.
    # <code>DecimalFormat</code> does <em>not</em> decide whether to
    # return a <code>Double</code> or a <code>Long</code> based on the
    # presence of a decimal separator in the source string. Doing so
    # would prevent integers that overflow the mantissa of a double,
    # such as <code>"-9,223,372,036,854,775,808.00"</code>, from being
    # parsed accurately.
    # <p>
    # Callers may use the <code>Number</code> methods
    # <code>doubleValue</code>, <code>longValue</code>, etc., to obtain
    # the type they want.
    # <li>If <code>isParseBigDecimal()</code> is true, values are returned
    # as <code>BigDecimal</code> objects. The values are the ones
    # constructed by {@link java.math.BigDecimal#BigDecimal(String)}
    # for corresponding strings in locale-independent format. The
    # special cases negative and positive infinity and NaN are returned
    # as <code>Double</code> instances holding the values of the
    # corresponding <code>Double</code> constants.
    # </ul>
    # <p>
    # <code>DecimalFormat</code> parses all Unicode characters that represent
    # decimal digits, as defined by <code>Character.digit()</code>. In
    # addition, <code>DecimalFormat</code> also recognizes as digits the ten
    # consecutive characters starting with the localized zero digit defined in
    # the <code>DecimalFormatSymbols</code> object.
    # 
    # @param text the string to be parsed
    # @param pos  A <code>ParsePosition</code> object with index and error
    # index information as described above.
    # @return     the parsed value, or <code>null</code> if the parse fails
    # @exception  NullPointerException if <code>text</code> or
    # <code>pos</code> is null.
    def parse(text, pos)
      # special case NaN
      if (text.region_matches(pos.attr_index, @symbols.get_na_n, 0, @symbols.get_na_n.length))
        pos.attr_index = pos.attr_index + @symbols.get_na_n.length
        return Double.new(Double::NaN)
      end
      status = Array.typed(::Java::Boolean).new(STATUS_LENGTH) { false }
      if (!subparse(text, pos, @positive_prefix, @negative_prefix, @digit_list, false, status))
        return nil
      end
      # special case INFINITY
      if (status[STATUS_INFINITE])
        if ((status[STATUS_POSITIVE]).equal?((@multiplier >= 0)))
          return Double.new(Double::POSITIVE_INFINITY)
        else
          return Double.new(Double::NEGATIVE_INFINITY)
        end
      end
      if ((@multiplier).equal?(0))
        if (@digit_list.is_zero)
          return Double.new(Double::NaN)
        else
          if (status[STATUS_POSITIVE])
            return Double.new(Double::POSITIVE_INFINITY)
          else
            return Double.new(Double::NEGATIVE_INFINITY)
          end
        end
      end
      if (is_parse_big_decimal)
        big_decimal_result = @digit_list.get_big_decimal
        if (!(@multiplier).equal?(1))
          begin
            big_decimal_result = big_decimal_result.divide(get_big_decimal_multiplier)
          rescue ArithmeticException => e
            # non-terminating decimal expansion
            big_decimal_result = big_decimal_result.divide(get_big_decimal_multiplier, @rounding_mode)
          end
        end
        if (!status[STATUS_POSITIVE])
          big_decimal_result = big_decimal_result.negate
        end
        return big_decimal_result
      else
        got_double = true
        got_long_minimum = false
        double_result = 0.0
        long_result = 0
        # Finally, have DigitList parse the digits into a value.
        if (@digit_list.fits_into_long(status[STATUS_POSITIVE], is_parse_integer_only))
          got_double = false
          long_result = @digit_list.get_long
          if (long_result < 0)
            # got Long.MIN_VALUE
            got_long_minimum = true
          end
        else
          double_result = @digit_list.get_double
        end
        # Divide by multiplier. We have to be careful here not to do
        # unneeded conversions between double and long.
        if (!(@multiplier).equal?(1))
          if (got_double)
            double_result /= @multiplier
          else
            # Avoid converting to double if we can
            if ((long_result % @multiplier).equal?(0))
              long_result /= @multiplier
            else
              double_result = ((long_result).to_f) / @multiplier
              got_double = true
            end
          end
        end
        if (!status[STATUS_POSITIVE] && !got_long_minimum)
          double_result = -double_result
          long_result = -long_result
        end
        # At this point, if we divided the result by the multiplier, the
        # result may fit into a long.  We check for this case and return
        # a long if possible.
        # We must do this AFTER applying the negative (if appropriate)
        # in order to handle the case of LONG_MIN; otherwise, if we do
        # this with a positive value -LONG_MIN, the double is > 0, but
        # the long is < 0. We also must retain a double in the case of
        # -0.0, which will compare as == to a long 0 cast to a double
        # (bug 4162852).
        if (!(@multiplier).equal?(1) && got_double)
          long_result = double_result
          got_double = ((!(double_result).equal?((long_result).to_f)) || ((double_result).equal?(0.0) && 1 / double_result < 0.0)) && !is_parse_integer_only
        end
        return got_double ? Double.new(double_result) : Long.new(long_result)
      end
    end
    
    typesig { [] }
    # Return a BigInteger multiplier.
    def get_big_integer_multiplier
      if ((@big_integer_multiplier).nil?)
        @big_integer_multiplier = BigInteger.value_of(@multiplier)
      end
      return @big_integer_multiplier
    end
    
    attr_accessor :big_integer_multiplier
    alias_method :attr_big_integer_multiplier, :big_integer_multiplier
    undef_method :big_integer_multiplier
    alias_method :attr_big_integer_multiplier=, :big_integer_multiplier=
    undef_method :big_integer_multiplier=
    
    typesig { [] }
    # Return a BigDecimal multiplier.
    def get_big_decimal_multiplier
      if ((@big_decimal_multiplier).nil?)
        @big_decimal_multiplier = BigDecimal.new(@multiplier)
      end
      return @big_decimal_multiplier
    end
    
    attr_accessor :big_decimal_multiplier
    alias_method :attr_big_decimal_multiplier, :big_decimal_multiplier
    undef_method :big_decimal_multiplier
    alias_method :attr_big_decimal_multiplier=, :big_decimal_multiplier=
    undef_method :big_decimal_multiplier=
    
    class_module.module_eval {
      const_set_lazy(:STATUS_INFINITE) { 0 }
      const_attr_reader  :STATUS_INFINITE
      
      const_set_lazy(:STATUS_POSITIVE) { 1 }
      const_attr_reader  :STATUS_POSITIVE
      
      const_set_lazy(:STATUS_LENGTH) { 2 }
      const_attr_reader  :STATUS_LENGTH
    }
    
    typesig { [String, ParsePosition, String, String, DigitList, ::Java::Boolean, Array.typed(::Java::Boolean)] }
    # Parse the given text into a number.  The text is parsed beginning at
    # parsePosition, until an unparseable character is seen.
    # @param text The string to parse.
    # @param parsePosition The position at which to being parsing.  Upon
    # return, the first unparseable character.
    # @param digits The DigitList to set to the parsed value.
    # @param isExponent If true, parse an exponent.  This means no
    # infinite values and integer only.
    # @param status Upon return contains boolean status flags indicating
    # whether the value was infinite and whether it was positive.
    def subparse(text, parse_position, positive_prefix, negative_prefix, digits, is_exponent, status)
      position = parse_position.attr_index
      old_start = parse_position.attr_index
      backup = 0
      got_positive = false
      got_negative = false
      # check for positivePrefix; take longest
      got_positive = text.region_matches(position, positive_prefix, 0, positive_prefix.length)
      got_negative = text.region_matches(position, negative_prefix, 0, negative_prefix.length)
      if (got_positive && got_negative)
        if (positive_prefix.length > negative_prefix.length)
          got_negative = false
        else
          if (positive_prefix.length < negative_prefix.length)
            got_positive = false
          end
        end
      end
      if (got_positive)
        position += positive_prefix.length
      else
        if (got_negative)
          position += negative_prefix.length
        else
          parse_position.attr_error_index = position
          return false
        end
      end
      # process digits or Inf, find decimal position
      status[STATUS_INFINITE] = false
      if (!is_exponent && text.region_matches(position, @symbols.get_infinity, 0, @symbols.get_infinity.length))
        position += @symbols.get_infinity.length
        status[STATUS_INFINITE] = true
      else
        # We now have a string of digits, possibly with grouping symbols,
        # and decimal points.  We want to process these into a DigitList.
        # We don't want to put a bunch of leading zeros into the DigitList
        # though, so we keep track of the location of the decimal point,
        # put only significant digits into the DigitList, and adjust the
        # exponent as needed.
        digits.attr_decimal_at = digits.attr_count = 0
        zero = @symbols.get_zero_digit
        decimal = @is_currency_format ? @symbols.get_monetary_decimal_separator : @symbols.get_decimal_separator
        grouping = @symbols.get_grouping_separator
        exponent_string = @symbols.get_exponent_separator
        saw_decimal = false
        saw_exponent = false
        saw_digit = false
        exponent = 0 # Set to the exponent value, if any
        # We have to track digitCount ourselves, because digits.count will
        # pin when the maximum allowable digits is reached.
        digit_count = 0
        backup = -1
        while position < text.length
          ch = text.char_at(position)
          # We recognize all digit ranges, not only the Latin digit range
          # '0'..'9'.  We do so by using the Character.digit() method,
          # which converts a valid Unicode digit to the range 0..9.
          # 
          # The character 'ch' may be a digit.  If so, place its value
          # from 0 to 9 in 'digit'.  First try using the locale digit,
          # which may or MAY NOT be a standard Unicode digit range.  If
          # this fails, try using the standard Unicode digit ranges by
          # calling Character.digit().  If this also fails, digit will
          # have a value outside the range 0..9.
          digit = ch - zero
          if (digit < 0 || digit > 9)
            digit = Character.digit(ch, 10)
          end
          if ((digit).equal?(0))
            # Cancel out backup setting (see grouping handler below)
            backup = -1 # Do this BEFORE continue statement below!!!
            saw_digit = true
            # Handle leading zeros
            if ((digits.attr_count).equal?(0))
              # Ignore leading zeros in integer part of number.
              if (!saw_decimal)
                (position += 1)
                next
              end
              # If we have seen the decimal, but no significant
              # digits yet, then we account for leading zeros by
              # decrementing the digits.decimalAt into negative
              # values.
              (digits.attr_decimal_at -= 1)
            else
              (digit_count += 1)
              digits.append(RJava.cast_to_char((digit + Character.new(?0.ord))))
            end
          else
            if (digit > 0 && digit <= 9)
              # [sic] digit==0 handled above
              saw_digit = true
              (digit_count += 1)
              digits.append(RJava.cast_to_char((digit + Character.new(?0.ord))))
              # Cancel out backup setting (see grouping handler below)
              backup = -1
            else
              if (!is_exponent && (ch).equal?(decimal))
                # If we're only parsing integers, or if we ALREADY saw the
                # decimal, then don't parse this one.
                if (is_parse_integer_only || saw_decimal)
                  break
                end
                digits.attr_decimal_at = digit_count # Not digits.count!
                saw_decimal = true
              else
                if (!is_exponent && (ch).equal?(grouping) && is_grouping_used)
                  if (saw_decimal)
                    break
                  end
                  # Ignore grouping characters, if we are using them, but
                  # require that they be followed by a digit.  Otherwise
                  # we backup and reprocess them.
                  backup = position
                else
                  if (!is_exponent && text.region_matches(position, exponent_string, 0, exponent_string.length) && !saw_exponent)
                    # Process the exponent by recursively calling this method.
                    pos = ParsePosition.new(position + exponent_string.length)
                    stat = Array.typed(::Java::Boolean).new(STATUS_LENGTH) { false }
                    exponent_digits = DigitList.new
                    if (subparse(text, pos, "", Character.to_s(@symbols.get_minus_sign), exponent_digits, true, stat) && exponent_digits.fits_into_long(stat[STATUS_POSITIVE], true))
                      position = pos.attr_index # Advance past the exponent
                      exponent = RJava.cast_to_int(exponent_digits.get_long)
                      if (!stat[STATUS_POSITIVE])
                        exponent = -exponent
                      end
                      saw_exponent = true
                    end
                    break # Whether we fail or succeed, we exit this loop
                  else
                    break
                  end
                end
              end
            end
          end
          (position += 1)
        end
        if (!(backup).equal?(-1))
          position = backup
        end
        # If there was no decimal point we have an integer
        if (!saw_decimal)
          digits.attr_decimal_at = digit_count # Not digits.count!
        end
        # Adjust for exponent, if any
        digits.attr_decimal_at += exponent
        # If none of the text string was recognized.  For example, parse
        # "x" with pattern "#0.00" (return index and error index both 0)
        # parse "$" with pattern "$#0.00". (return index 0 and error
        # index 1).
        if (!saw_digit && (digit_count).equal?(0))
          parse_position.attr_index = old_start
          parse_position.attr_error_index = old_start
          return false
        end
      end
      # check for suffix
      if (!is_exponent)
        if (got_positive)
          got_positive = text.region_matches(position, @positive_suffix, 0, @positive_suffix.length)
        end
        if (got_negative)
          got_negative = text.region_matches(position, @negative_suffix, 0, @negative_suffix.length)
        end
        # if both match, take longest
        if (got_positive && got_negative)
          if (@positive_suffix.length > @negative_suffix.length)
            got_negative = false
          else
            if (@positive_suffix.length < @negative_suffix.length)
              got_positive = false
            end
          end
        end
        # fail if neither or both
        if ((got_positive).equal?(got_negative))
          parse_position.attr_error_index = position
          return false
        end
        parse_position.attr_index = position + (got_positive ? @positive_suffix.length : @negative_suffix.length) # mark success!
      else
        parse_position.attr_index = position
      end
      status[STATUS_POSITIVE] = got_positive
      if ((parse_position.attr_index).equal?(old_start))
        parse_position.attr_error_index = position
        return false
      end
      return true
    end
    
    typesig { [] }
    # Returns a copy of the decimal format symbols, which is generally not
    # changed by the programmer or user.
    # @return a copy of the desired DecimalFormatSymbols
    # @see java.text.DecimalFormatSymbols
    def get_decimal_format_symbols
      begin
        # don't allow multiple references
        return @symbols.clone
      rescue JavaException => foo
        return nil # should never happen
      end
    end
    
    typesig { [DecimalFormatSymbols] }
    # Sets the decimal format symbols, which is generally not changed
    # by the programmer or user.
    # @param newSymbols desired DecimalFormatSymbols
    # @see java.text.DecimalFormatSymbols
    def set_decimal_format_symbols(new_symbols)
      begin
        # don't allow multiple references
        @symbols = new_symbols.clone
        expand_affixes
      rescue JavaException => foo
        # should never happen
      end
    end
    
    typesig { [] }
    # Get the positive prefix.
    # <P>Examples: +123, $123, sFr123
    def get_positive_prefix
      return @positive_prefix
    end
    
    typesig { [String] }
    # Set the positive prefix.
    # <P>Examples: +123, $123, sFr123
    def set_positive_prefix(new_value)
      @positive_prefix = new_value
      @pos_prefix_pattern = RJava.cast_to_string(nil)
      @positive_prefix_field_positions = nil
    end
    
    typesig { [] }
    # Returns the FieldPositions of the fields in the prefix used for
    # positive numbers. This is not used if the user has explicitly set
    # a positive prefix via <code>setPositivePrefix</code>. This is
    # lazily created.
    # 
    # @return FieldPositions in positive prefix
    def get_positive_prefix_field_positions
      if ((@positive_prefix_field_positions).nil?)
        if (!(@pos_prefix_pattern).nil?)
          @positive_prefix_field_positions = expand_affix(@pos_prefix_pattern)
        else
          @positive_prefix_field_positions = self.attr_empty_field_position_array
        end
      end
      return @positive_prefix_field_positions
    end
    
    typesig { [] }
    # Get the negative prefix.
    # <P>Examples: -123, ($123) (with negative suffix), sFr-123
    def get_negative_prefix
      return @negative_prefix
    end
    
    typesig { [String] }
    # Set the negative prefix.
    # <P>Examples: -123, ($123) (with negative suffix), sFr-123
    def set_negative_prefix(new_value)
      @negative_prefix = new_value
      @neg_prefix_pattern = RJava.cast_to_string(nil)
    end
    
    typesig { [] }
    # Returns the FieldPositions of the fields in the prefix used for
    # negative numbers. This is not used if the user has explicitly set
    # a negative prefix via <code>setNegativePrefix</code>. This is
    # lazily created.
    # 
    # @return FieldPositions in positive prefix
    def get_negative_prefix_field_positions
      if ((@negative_prefix_field_positions).nil?)
        if (!(@neg_prefix_pattern).nil?)
          @negative_prefix_field_positions = expand_affix(@neg_prefix_pattern)
        else
          @negative_prefix_field_positions = self.attr_empty_field_position_array
        end
      end
      return @negative_prefix_field_positions
    end
    
    typesig { [] }
    # Get the positive suffix.
    # <P>Example: 123%
    def get_positive_suffix
      return @positive_suffix
    end
    
    typesig { [String] }
    # Set the positive suffix.
    # <P>Example: 123%
    def set_positive_suffix(new_value)
      @positive_suffix = new_value
      @pos_suffix_pattern = RJava.cast_to_string(nil)
    end
    
    typesig { [] }
    # Returns the FieldPositions of the fields in the suffix used for
    # positive numbers. This is not used if the user has explicitly set
    # a positive suffix via <code>setPositiveSuffix</code>. This is
    # lazily created.
    # 
    # @return FieldPositions in positive prefix
    def get_positive_suffix_field_positions
      if ((@positive_suffix_field_positions).nil?)
        if (!(@pos_suffix_pattern).nil?)
          @positive_suffix_field_positions = expand_affix(@pos_suffix_pattern)
        else
          @positive_suffix_field_positions = self.attr_empty_field_position_array
        end
      end
      return @positive_suffix_field_positions
    end
    
    typesig { [] }
    # Get the negative suffix.
    # <P>Examples: -123%, ($123) (with positive suffixes)
    def get_negative_suffix
      return @negative_suffix
    end
    
    typesig { [String] }
    # Set the negative suffix.
    # <P>Examples: 123%
    def set_negative_suffix(new_value)
      @negative_suffix = new_value
      @neg_suffix_pattern = RJava.cast_to_string(nil)
    end
    
    typesig { [] }
    # Returns the FieldPositions of the fields in the suffix used for
    # negative numbers. This is not used if the user has explicitly set
    # a negative suffix via <code>setNegativeSuffix</code>. This is
    # lazily created.
    # 
    # @return FieldPositions in positive prefix
    def get_negative_suffix_field_positions
      if ((@negative_suffix_field_positions).nil?)
        if (!(@neg_suffix_pattern).nil?)
          @negative_suffix_field_positions = expand_affix(@neg_suffix_pattern)
        else
          @negative_suffix_field_positions = self.attr_empty_field_position_array
        end
      end
      return @negative_suffix_field_positions
    end
    
    typesig { [] }
    # Gets the multiplier for use in percent, per mille, and similar
    # formats.
    # 
    # @see #setMultiplier(int)
    def get_multiplier
      return @multiplier
    end
    
    typesig { [::Java::Int] }
    # Sets the multiplier for use in percent, per mille, and similar
    # formats.
    # For a percent format, set the multiplier to 100 and the suffixes to
    # have '%' (for Arabic, use the Arabic percent sign).
    # For a per mille format, set the multiplier to 1000 and the suffixes to
    # have '&#92;u2030'.
    # 
    # <P>Example: with multiplier 100, 1.23 is formatted as "123", and
    # "123" is parsed into 1.23.
    # 
    # @see #getMultiplier
    def set_multiplier(new_value)
      @multiplier = new_value
      @big_decimal_multiplier = nil
      @big_integer_multiplier = nil
    end
    
    typesig { [] }
    # Return the grouping size. Grouping size is the number of digits between
    # grouping separators in the integer portion of a number.  For example,
    # in the number "123,456.78", the grouping size is 3.
    # @see #setGroupingSize
    # @see java.text.NumberFormat#isGroupingUsed
    # @see java.text.DecimalFormatSymbols#getGroupingSeparator
    def get_grouping_size
      return @grouping_size
    end
    
    typesig { [::Java::Int] }
    # Set the grouping size. Grouping size is the number of digits between
    # grouping separators in the integer portion of a number.  For example,
    # in the number "123,456.78", the grouping size is 3.
    # <br>
    # The value passed in is converted to a byte, which may lose information.
    # @see #getGroupingSize
    # @see java.text.NumberFormat#setGroupingUsed
    # @see java.text.DecimalFormatSymbols#setGroupingSeparator
    def set_grouping_size(new_value)
      @grouping_size = new_value
    end
    
    typesig { [] }
    # Allows you to get the behavior of the decimal separator with integers.
    # (The decimal separator will always appear with decimals.)
    # <P>Example: Decimal ON: 12345 -> 12345.; OFF: 12345 -> 12345
    def is_decimal_separator_always_shown
      return @decimal_separator_always_shown
    end
    
    typesig { [::Java::Boolean] }
    # Allows you to set the behavior of the decimal separator with integers.
    # (The decimal separator will always appear with decimals.)
    # <P>Example: Decimal ON: 12345 -> 12345.; OFF: 12345 -> 12345
    def set_decimal_separator_always_shown(new_value)
      @decimal_separator_always_shown = new_value
    end
    
    typesig { [] }
    # Returns whether the {@link #parse(java.lang.String, java.text.ParsePosition)}
    # method returns <code>BigDecimal</code>. The default value is false.
    # @see #setParseBigDecimal
    # @since 1.5
    def is_parse_big_decimal
      return @parse_big_decimal
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether the {@link #parse(java.lang.String, java.text.ParsePosition)}
    # method returns <code>BigDecimal</code>.
    # @see #isParseBigDecimal
    # @since 1.5
    def set_parse_big_decimal(new_value)
      @parse_big_decimal = new_value
    end
    
    typesig { [] }
    # Standard override; no change in semantics.
    def clone
      begin
        other = super
        other.attr_symbols = @symbols.clone
        other.attr_digit_list = @digit_list.clone
        return other
      rescue JavaException => e
        raise InternalError.new
      end
    end
    
    typesig { [Object] }
    # Overrides equals
    def ==(obj)
      if ((obj).nil?)
        return false
      end
      if (!super(obj))
        return false
      end # super does class check
      other = obj
      return (((@pos_prefix_pattern).equal?(other.attr_pos_prefix_pattern) && (@positive_prefix == other.attr_positive_prefix)) || (!(@pos_prefix_pattern).nil? && (@pos_prefix_pattern == other.attr_pos_prefix_pattern))) && (((@pos_suffix_pattern).equal?(other.attr_pos_suffix_pattern) && (@positive_suffix == other.attr_positive_suffix)) || (!(@pos_suffix_pattern).nil? && (@pos_suffix_pattern == other.attr_pos_suffix_pattern))) && (((@neg_prefix_pattern).equal?(other.attr_neg_prefix_pattern) && (@negative_prefix == other.attr_negative_prefix)) || (!(@neg_prefix_pattern).nil? && (@neg_prefix_pattern == other.attr_neg_prefix_pattern))) && (((@neg_suffix_pattern).equal?(other.attr_neg_suffix_pattern) && (@negative_suffix == other.attr_negative_suffix)) || (!(@neg_suffix_pattern).nil? && (@neg_suffix_pattern == other.attr_neg_suffix_pattern))) && (@multiplier).equal?(other.attr_multiplier) && (@grouping_size).equal?(other.attr_grouping_size) && (@decimal_separator_always_shown).equal?(other.attr_decimal_separator_always_shown) && (@parse_big_decimal).equal?(other.attr_parse_big_decimal) && (@use_exponential_notation).equal?(other.attr_use_exponential_notation) && (!@use_exponential_notation || (@min_exponent_digits).equal?(other.attr_min_exponent_digits)) && (@maximum_integer_digits).equal?(other.attr_maximum_integer_digits) && (@minimum_integer_digits).equal?(other.attr_minimum_integer_digits) && (@maximum_fraction_digits).equal?(other.attr_maximum_fraction_digits) && (@minimum_fraction_digits).equal?(other.attr_minimum_fraction_digits) && (@rounding_mode).equal?(other.attr_rounding_mode) && (@symbols == other.attr_symbols)
    end
    
    typesig { [] }
    # Overrides hashCode
    def hash_code
      return super * 37 + @positive_prefix.hash_code
      # just enough fields for a reasonable distribution
    end
    
    typesig { [] }
    # Synthesizes a pattern string that represents the current state
    # of this Format object.
    # @see #applyPattern
    def to_pattern
      return to_pattern(false)
    end
    
    typesig { [] }
    # Synthesizes a localized pattern string that represents the current
    # state of this Format object.
    # @see #applyPattern
    def to_localized_pattern
      return to_pattern(true)
    end
    
    typesig { [] }
    # Expand the affix pattern strings into the expanded affix strings.  If any
    # affix pattern string is null, do not expand it.  This method should be
    # called any time the symbols or the affix patterns change in order to keep
    # the expanded affix strings up to date.
    def expand_affixes
      # Reuse one StringBuffer for better performance
      buffer = StringBuffer.new
      if (!(@pos_prefix_pattern).nil?)
        @positive_prefix = RJava.cast_to_string(expand_affix(@pos_prefix_pattern, buffer))
        @positive_prefix_field_positions = nil
      end
      if (!(@pos_suffix_pattern).nil?)
        @positive_suffix = RJava.cast_to_string(expand_affix(@pos_suffix_pattern, buffer))
        @positive_suffix_field_positions = nil
      end
      if (!(@neg_prefix_pattern).nil?)
        @negative_prefix = RJava.cast_to_string(expand_affix(@neg_prefix_pattern, buffer))
        @negative_prefix_field_positions = nil
      end
      if (!(@neg_suffix_pattern).nil?)
        @negative_suffix = RJava.cast_to_string(expand_affix(@neg_suffix_pattern, buffer))
        @negative_suffix_field_positions = nil
      end
    end
    
    typesig { [String, StringBuffer] }
    # Expand an affix pattern into an affix string.  All characters in the
    # pattern are literal unless prefixed by QUOTE.  The following characters
    # after QUOTE are recognized: PATTERN_PERCENT, PATTERN_PER_MILLE,
    # PATTERN_MINUS, and CURRENCY_SIGN.  If CURRENCY_SIGN is doubled (QUOTE +
    # CURRENCY_SIGN + CURRENCY_SIGN), it is interpreted as an ISO 4217
    # currency code.  Any other character after a QUOTE represents itself.
    # QUOTE must be followed by another character; QUOTE may not occur by
    # itself at the end of the pattern.
    # 
    # @param pattern the non-null, possibly empty pattern
    # @param buffer a scratch StringBuffer; its contents will be lost
    # @return the expanded equivalent of pattern
    def expand_affix(pattern, buffer)
      buffer.set_length(0)
      i = 0
      while i < pattern.length
        c = pattern.char_at(((i += 1) - 1))
        if ((c).equal?(QUOTE))
          c = pattern.char_at(((i += 1) - 1))
          case (c)
          when CURRENCY_SIGN
            if (i < pattern.length && (pattern.char_at(i)).equal?(CURRENCY_SIGN))
              (i += 1)
              buffer.append(@symbols.get_international_currency_symbol)
            else
              buffer.append(@symbols.get_currency_symbol)
            end
            next
            c = @symbols.get_percent
          when PATTERN_PERCENT
            c = @symbols.get_percent
          when PATTERN_PER_MILLE
            c = @symbols.get_per_mill
          when PATTERN_MINUS
            c = @symbols.get_minus_sign
          end
        end
        buffer.append(c)
      end
      return buffer.to_s
    end
    
    typesig { [String] }
    # Expand an affix pattern into an array of FieldPositions describing
    # how the pattern would be expanded.
    # All characters in the
    # pattern are literal unless prefixed by QUOTE.  The following characters
    # after QUOTE are recognized: PATTERN_PERCENT, PATTERN_PER_MILLE,
    # PATTERN_MINUS, and CURRENCY_SIGN.  If CURRENCY_SIGN is doubled (QUOTE +
    # CURRENCY_SIGN + CURRENCY_SIGN), it is interpreted as an ISO 4217
    # currency code.  Any other character after a QUOTE represents itself.
    # QUOTE must be followed by another character; QUOTE may not occur by
    # itself at the end of the pattern.
    # 
    # @param pattern the non-null, possibly empty pattern
    # @return FieldPosition array of the resulting fields.
    def expand_affix(pattern)
      positions = nil
      string_index = 0
      i = 0
      while i < pattern.length
        c = pattern.char_at(((i += 1) - 1))
        if ((c).equal?(QUOTE))
          field = -1
          field_id = nil
          c = pattern.char_at(((i += 1) - 1))
          case (c)
          when CURRENCY_SIGN
            string = nil
            if (i < pattern.length && (pattern.char_at(i)).equal?(CURRENCY_SIGN))
              (i += 1)
              string = RJava.cast_to_string(@symbols.get_international_currency_symbol)
            else
              string = RJava.cast_to_string(@symbols.get_currency_symbol)
            end
            if (string.length > 0)
              if ((positions).nil?)
                positions = ArrayList.new(2)
              end
              fp = FieldPosition.new(Field::CURRENCY)
              fp.set_begin_index(string_index)
              fp.set_end_index(string_index + string.length)
              positions.add(fp)
              string_index += string.length
            end
            next
            c = @symbols.get_percent
            field = -1
            field_id = Field::PERCENT
          when PATTERN_PERCENT
            c = @symbols.get_percent
            field = -1
            field_id = Field::PERCENT
          when PATTERN_PER_MILLE
            c = @symbols.get_per_mill
            field = -1
            field_id = Field::PERMILLE
          when PATTERN_MINUS
            c = @symbols.get_minus_sign
            field = -1
            field_id = Field::SIGN
          end
          if (!(field_id).nil?)
            if ((positions).nil?)
              positions = ArrayList.new(2)
            end
            fp = FieldPosition.new(field_id, field)
            fp.set_begin_index(string_index)
            fp.set_end_index(string_index + 1)
            positions.add(fp)
          end
        end
        string_index += 1
      end
      if (!(positions).nil?)
        return positions.to_array(self.attr_empty_field_position_array)
      end
      return self.attr_empty_field_position_array
    end
    
    typesig { [StringBuffer, String, String, ::Java::Boolean] }
    # Appends an affix pattern to the given StringBuffer, quoting special
    # characters as needed.  Uses the internal affix pattern, if that exists,
    # or the literal affix, if the internal affix pattern is null.  The
    # appended string will generate the same affix pattern (or literal affix)
    # when passed to toPattern().
    # 
    # @param buffer the affix string is appended to this
    # @param affixPattern a pattern such as posPrefixPattern; may be null
    # @param expAffix a corresponding expanded affix, such as positivePrefix.
    # Ignored unless affixPattern is null.  If affixPattern is null, then
    # expAffix is appended as a literal affix.
    # @param localized true if the appended pattern should contain localized
    # pattern characters; otherwise, non-localized pattern chars are appended
    def append_affix(buffer, affix_pattern, exp_affix, localized)
      if ((affix_pattern).nil?)
        append_affix(buffer, exp_affix, localized)
      else
        i = 0
        pos = 0
        while pos < affix_pattern.length
          i = affix_pattern.index_of(QUOTE, pos)
          if (i < 0)
            append_affix(buffer, affix_pattern.substring(pos), localized)
            break
          end
          if (i > pos)
            append_affix(buffer, affix_pattern.substring(pos, i), localized)
          end
          c = affix_pattern.char_at((i += 1))
          (i += 1)
          if ((c).equal?(QUOTE))
            buffer.append(c)
            # Fall through and append another QUOTE below
          else
            if ((c).equal?(CURRENCY_SIGN) && i < affix_pattern.length && (affix_pattern.char_at(i)).equal?(CURRENCY_SIGN))
              (i += 1)
              buffer.append(c)
              # Fall through and append another CURRENCY_SIGN below
            else
              if (localized)
                case (c)
                when PATTERN_PERCENT
                  c = @symbols.get_percent
                when PATTERN_PER_MILLE
                  c = @symbols.get_per_mill
                when PATTERN_MINUS
                  c = @symbols.get_minus_sign
                end
              end
            end
          end
          buffer.append(c)
          pos = i
        end
      end
    end
    
    typesig { [StringBuffer, String, ::Java::Boolean] }
    # Append an affix to the given StringBuffer, using quotes if
    # there are special characters.  Single quotes themselves must be
    # escaped in either case.
    def append_affix(buffer, affix, localized)
      need_quote = false
      if (localized)
        need_quote = affix.index_of(@symbols.get_zero_digit) >= 0 || affix.index_of(@symbols.get_grouping_separator) >= 0 || affix.index_of(@symbols.get_decimal_separator) >= 0 || affix.index_of(@symbols.get_percent) >= 0 || affix.index_of(@symbols.get_per_mill) >= 0 || affix.index_of(@symbols.get_digit) >= 0 || affix.index_of(@symbols.get_pattern_separator) >= 0 || affix.index_of(@symbols.get_minus_sign) >= 0 || affix.index_of(CURRENCY_SIGN) >= 0
      else
        need_quote = affix.index_of(PATTERN_ZERO_DIGIT) >= 0 || affix.index_of(PATTERN_GROUPING_SEPARATOR) >= 0 || affix.index_of(PATTERN_DECIMAL_SEPARATOR) >= 0 || affix.index_of(PATTERN_PERCENT) >= 0 || affix.index_of(PATTERN_PER_MILLE) >= 0 || affix.index_of(PATTERN_DIGIT) >= 0 || affix.index_of(PATTERN_SEPARATOR) >= 0 || affix.index_of(PATTERN_MINUS) >= 0 || affix.index_of(CURRENCY_SIGN) >= 0
      end
      if (need_quote)
        buffer.append(Character.new(?\'.ord))
      end
      if (affix.index_of(Character.new(?\'.ord)) < 0)
        buffer.append(affix)
      else
        j = 0
        while j < affix.length
          c = affix.char_at(j)
          buffer.append(c)
          if ((c).equal?(Character.new(?\'.ord)))
            buffer.append(c)
          end
          (j += 1)
        end
      end
      if (need_quote)
        buffer.append(Character.new(?\'.ord))
      end
    end
    
    typesig { [::Java::Boolean] }
    # Does the real work of generating a pattern.
    def to_pattern(localized)
      result = StringBuffer.new
      j = 1
      while j >= 0
        if ((j).equal?(1))
          append_affix(result, @pos_prefix_pattern, @positive_prefix, localized)
        else
          append_affix(result, @neg_prefix_pattern, @negative_prefix, localized)
        end
        i = 0
        digit_count = @use_exponential_notation ? get_maximum_integer_digits : Math.max(@grouping_size, get_minimum_integer_digits) + 1
        i = digit_count
        while i > 0
          if (!(i).equal?(digit_count) && is_grouping_used && !(@grouping_size).equal?(0) && (i % @grouping_size).equal?(0))
            result.append(localized ? @symbols.get_grouping_separator : PATTERN_GROUPING_SEPARATOR)
          end
          result.append(i <= get_minimum_integer_digits ? (localized ? @symbols.get_zero_digit : PATTERN_ZERO_DIGIT) : (localized ? @symbols.get_digit : PATTERN_DIGIT))
          (i -= 1)
        end
        if (get_maximum_fraction_digits > 0 || @decimal_separator_always_shown)
          result.append(localized ? @symbols.get_decimal_separator : PATTERN_DECIMAL_SEPARATOR)
        end
        i = 0
        while i < get_maximum_fraction_digits
          if (i < get_minimum_fraction_digits)
            result.append(localized ? @symbols.get_zero_digit : PATTERN_ZERO_DIGIT)
          else
            result.append(localized ? @symbols.get_digit : PATTERN_DIGIT)
          end
          (i += 1)
        end
        if (@use_exponential_notation)
          result.append(localized ? @symbols.get_exponent_separator : PATTERN_EXPONENT)
          i = 0
          while i < @min_exponent_digits
            result.append(localized ? @symbols.get_zero_digit : PATTERN_ZERO_DIGIT)
            (i += 1)
          end
        end
        if ((j).equal?(1))
          append_affix(result, @pos_suffix_pattern, @positive_suffix, localized)
          # n == p == null
          if (((@neg_suffix_pattern).equal?(@pos_suffix_pattern) && (@negative_suffix == @positive_suffix)) || (!(@neg_suffix_pattern).nil? && (@neg_suffix_pattern == @pos_suffix_pattern)))
            # n == p == null
            if ((!(@neg_prefix_pattern).nil? && !(@pos_prefix_pattern).nil? && (@neg_prefix_pattern == "'-" + @pos_prefix_pattern)) || ((@neg_prefix_pattern).equal?(@pos_prefix_pattern) && (@negative_prefix == RJava.cast_to_string(@symbols.get_minus_sign) + @positive_prefix)))
              break
            end
          end
          result.append(localized ? @symbols.get_pattern_separator : PATTERN_SEPARATOR)
        else
          append_affix(result, @neg_suffix_pattern, @negative_suffix, localized)
        end
        (j -= 1)
      end
      return result.to_s
    end
    
    typesig { [String] }
    # Apply the given pattern to this Format object.  A pattern is a
    # short-hand specification for the various formatting properties.
    # These properties can also be changed individually through the
    # various setter methods.
    # <p>
    # There is no limit to integer digits set
    # by this routine, since that is the typical end-user desire;
    # use setMaximumInteger if you want to set a real value.
    # For negative numbers, use a second pattern, separated by a semicolon
    # <P>Example <code>"#,#00.0#"</code> -> 1,234.56
    # <P>This means a minimum of 2 integer digits, 1 fraction digit, and
    # a maximum of 2 fraction digits.
    # <p>Example: <code>"#,#00.0#;(#,#00.0#)"</code> for negatives in
    # parentheses.
    # <p>In negative patterns, the minimum and maximum counts are ignored;
    # these are presumed to be set in the positive pattern.
    # 
    # @exception NullPointerException if <code>pattern</code> is null
    # @exception IllegalArgumentException if the given pattern is invalid.
    def apply_pattern(pattern)
      apply_pattern(pattern, false)
    end
    
    typesig { [String] }
    # Apply the given pattern to this Format object.  The pattern
    # is assumed to be in a localized notation. A pattern is a
    # short-hand specification for the various formatting properties.
    # These properties can also be changed individually through the
    # various setter methods.
    # <p>
    # There is no limit to integer digits set
    # by this routine, since that is the typical end-user desire;
    # use setMaximumInteger if you want to set a real value.
    # For negative numbers, use a second pattern, separated by a semicolon
    # <P>Example <code>"#,#00.0#"</code> -> 1,234.56
    # <P>This means a minimum of 2 integer digits, 1 fraction digit, and
    # a maximum of 2 fraction digits.
    # <p>Example: <code>"#,#00.0#;(#,#00.0#)"</code> for negatives in
    # parentheses.
    # <p>In negative patterns, the minimum and maximum counts are ignored;
    # these are presumed to be set in the positive pattern.
    # 
    # @exception NullPointerException if <code>pattern</code> is null
    # @exception IllegalArgumentException if the given pattern is invalid.
    def apply_localized_pattern(pattern)
      apply_pattern(pattern, true)
    end
    
    typesig { [String, ::Java::Boolean] }
    # Does the real work of applying a pattern.
    def apply_pattern(pattern, localized)
      zero_digit = PATTERN_ZERO_DIGIT
      grouping_separator = PATTERN_GROUPING_SEPARATOR
      decimal_separator = PATTERN_DECIMAL_SEPARATOR
      percent = PATTERN_PERCENT
      per_mill = PATTERN_PER_MILLE
      digit_ = PATTERN_DIGIT
      separator = PATTERN_SEPARATOR
      exponent = PATTERN_EXPONENT
      minus = PATTERN_MINUS
      if (localized)
        zero_digit = @symbols.get_zero_digit
        grouping_separator = @symbols.get_grouping_separator
        decimal_separator = @symbols.get_decimal_separator
        percent = @symbols.get_percent
        per_mill = @symbols.get_per_mill
        digit_ = @symbols.get_digit
        separator = @symbols.get_pattern_separator
        exponent = RJava.cast_to_string(@symbols.get_exponent_separator)
        minus = @symbols.get_minus_sign
      end
      got_negative = false
      @decimal_separator_always_shown = false
      @is_currency_format = false
      @use_exponential_notation = false
      # Two variables are used to record the subrange of the pattern
      # occupied by phase 1.  This is used during the processing of the
      # second pattern (the one representing negative numbers) to ensure
      # that no deviation exists in phase 1 between the two patterns.
      phase_one_start = 0
      phase_one_length = 0
      start = 0
      j = 1
      while j >= 0 && start < pattern.length
        in_quote = false
        prefix = StringBuffer.new
        suffix = StringBuffer.new
        decimal_pos = -1
        multiplier = 1
        digit_left_count = 0
        zero_digit_count = 0
        digit_right_count = 0
        grouping_count = -1
        # The phase ranges from 0 to 2.  Phase 0 is the prefix.  Phase 1 is
        # the section of the pattern with digits, decimal separator,
        # grouping characters.  Phase 2 is the suffix.  In phases 0 and 2,
        # percent, per mille, and currency symbols are recognized and
        # translated.  The separation of the characters into phases is
        # strictly enforced; if phase 1 characters are to appear in the
        # suffix, for example, they must be quoted.
        phase = 0
        # The affix is either the prefix or the suffix.
        affix = prefix
        pos = start
        while pos < pattern.length
          ch = pattern.char_at(pos)
          case (phase)
          when 0, 2
            # Process the prefix / suffix characters
            if (in_quote)
              # A quote within quotes indicates either the closing
              # quote or two quotes, which is a quote literal. That
              # is, we have the second quote in 'do' or 'don''t'.
              if ((ch).equal?(QUOTE))
                if ((pos + 1) < pattern.length && (pattern.char_at(pos + 1)).equal?(QUOTE))
                  (pos += 1)
                  affix.append("''") # 'don''t'
                else
                  in_quote = false # 'do'
                end
                (pos += 1)
                next
              end
            else
              # Process unquoted characters seen in prefix or suffix
              # phase.
              if ((ch).equal?(digit_) || (ch).equal?(zero_digit) || (ch).equal?(grouping_separator) || (ch).equal?(decimal_separator))
                phase = 1
                if ((j).equal?(1))
                  phase_one_start = pos
                end
                (pos -= 1) # Reprocess this character
                (pos += 1)
                next
              else
                if ((ch).equal?(CURRENCY_SIGN))
                  # Use lookahead to determine if the currency sign
                  # is doubled or not.
                  doubled = (pos + 1) < pattern.length && (pattern.char_at(pos + 1)).equal?(CURRENCY_SIGN)
                  if (doubled)
                    # Skip over the doubled character
                    (pos += 1)
                  end
                  @is_currency_format = true
                  affix.append(doubled ? ("'".to_u << 0x00A4 << "".to_u << 0x00A4 << "") : ("'".to_u << 0x00A4 << ""))
                  (pos += 1)
                  next
                else
                  if ((ch).equal?(QUOTE))
                    # A quote outside quotes indicates either the
                    # opening quote or two quotes, which is a quote
                    # literal. That is, we have the first quote in 'do'
                    # or o''clock.
                    if ((ch).equal?(QUOTE))
                      if ((pos + 1) < pattern.length && (pattern.char_at(pos + 1)).equal?(QUOTE))
                        (pos += 1)
                        affix.append("''") # o''clock
                      else
                        in_quote = true # 'do'
                      end
                      (pos += 1)
                      next
                    end
                  else
                    if ((ch).equal?(separator))
                      # Don't allow separators before we see digit
                      # characters of phase 1, and don't allow separators
                      # in the second pattern (j == 0).
                      if ((phase).equal?(0) || (j).equal?(0))
                        raise IllegalArgumentException.new("Unquoted special character '" + RJava.cast_to_string(ch) + "' in pattern \"" + pattern + RJava.cast_to_string(Character.new(?".ord)))
                      end
                      start = pos + 1
                      pos = pattern.length
                      (pos += 1)
                      next
                    # Next handle characters which are appended directly.
                    else
                      if ((ch).equal?(percent))
                        if (!(multiplier).equal?(1))
                          raise IllegalArgumentException.new("Too many percent/per mille characters in pattern \"" + pattern + RJava.cast_to_string(Character.new(?".ord)))
                        end
                        multiplier = 100
                        affix.append("'%")
                        (pos += 1)
                        next
                      else
                        if ((ch).equal?(per_mill))
                          if (!(multiplier).equal?(1))
                            raise IllegalArgumentException.new("Too many percent/per mille characters in pattern \"" + pattern + RJava.cast_to_string(Character.new(?".ord)))
                          end
                          multiplier = 1000
                          affix.append(("'".to_u << 0x2030 << ""))
                          (pos += 1)
                          next
                        else
                          if ((ch).equal?(minus))
                            affix.append("'-")
                            (pos += 1)
                            next
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
            # Note that if we are within quotes, or if this is an
            # unquoted, non-special character, then we usually fall
            # through to here.
            affix.append(ch)
          when 1
            # Phase one must be identical in the two sub-patterns. We
            # enforce this by doing a direct comparison. While
            # processing the first sub-pattern, we just record its
            # length. While processing the second, we compare
            # characters.
            if ((j).equal?(1))
              (phase_one_length += 1)
            else
              if (((phase_one_length -= 1)).equal?(0))
                phase = 2
                affix = suffix
              end
              (pos += 1)
              next
            end
            # Process the digits, decimal, and grouping characters. We
            # record five pieces of information. We expect the digits
            # to occur in the pattern ####0000.####, and we record the
            # number of left digits, zero (central) digits, and right
            # digits. The position of the last grouping character is
            # recorded (should be somewhere within the first two blocks
            # of characters), as is the position of the decimal point,
            # if any (should be in the zero digits). If there is no
            # decimal point, then there should be no right digits.
            if ((ch).equal?(digit_))
              if (zero_digit_count > 0)
                (digit_right_count += 1)
              else
                (digit_left_count += 1)
              end
              if (grouping_count >= 0 && decimal_pos < 0)
                (grouping_count += 1)
              end
            else
              if ((ch).equal?(zero_digit))
                if (digit_right_count > 0)
                  raise IllegalArgumentException.new("Unexpected '0' in pattern \"" + pattern + RJava.cast_to_string(Character.new(?".ord)))
                end
                (zero_digit_count += 1)
                if (grouping_count >= 0 && decimal_pos < 0)
                  (grouping_count += 1)
                end
              else
                if ((ch).equal?(grouping_separator))
                  grouping_count = 0
                else
                  if ((ch).equal?(decimal_separator))
                    if (decimal_pos >= 0)
                      raise IllegalArgumentException.new("Multiple decimal separators in pattern \"" + pattern + RJava.cast_to_string(Character.new(?".ord)))
                    end
                    decimal_pos = digit_left_count + zero_digit_count + digit_right_count
                  else
                    if (pattern.region_matches(pos, exponent, 0, exponent.length))
                      if (@use_exponential_notation)
                        raise IllegalArgumentException.new("Multiple exponential " + "symbols in pattern \"" + pattern + RJava.cast_to_string(Character.new(?".ord)))
                      end
                      @use_exponential_notation = true
                      @min_exponent_digits = 0
                      # Use lookahead to parse out the exponential part
                      # of the pattern, then jump into phase 2.
                      pos = pos + exponent.length
                      while (pos < pattern.length && (pattern.char_at(pos)).equal?(zero_digit))
                        (@min_exponent_digits += 1)
                        (phase_one_length += 1)
                        (pos += 1)
                      end
                      if ((digit_left_count + zero_digit_count) < 1 || @min_exponent_digits < 1)
                        raise IllegalArgumentException.new("Malformed exponential " + "pattern \"" + pattern + RJava.cast_to_string(Character.new(?".ord)))
                      end
                      # Transition to phase 2
                      phase = 2
                      affix = suffix
                      (pos -= 1)
                      (pos += 1)
                      next
                    else
                      phase = 2
                      affix = suffix
                      (pos -= 1)
                      (phase_one_length -= 1)
                      (pos += 1)
                      next
                    end
                  end
                end
              end
            end
          end
          (pos += 1)
        end
        # Handle patterns with no '0' pattern character. These patterns
        # are legal, but must be interpreted.  "##.###" -> "#0.###".
        # ".###" -> ".0##".
        # We allow patterns of the form "####" to produce a zeroDigitCount
        # of zero (got that?); although this seems like it might make it
        # possible for format() to produce empty strings, format() checks
        # for this condition and outputs a zero digit in this situation.
        # Having a zeroDigitCount of zero yields a minimum integer digits
        # of zero, which allows proper round-trip patterns.  That is, we
        # don't want "#" to become "#0" when toPattern() is called (even
        # though that's what it really is, semantically).
        if ((zero_digit_count).equal?(0) && digit_left_count > 0 && decimal_pos >= 0)
          # Handle "###.###" and "###." and ".###"
          n = decimal_pos
          if ((n).equal?(0))
            # Handle ".###"
            (n += 1)
          end
          digit_right_count = digit_left_count - n
          digit_left_count = n - 1
          zero_digit_count = 1
        end
        # Do syntax checking on the digits.
        if ((decimal_pos < 0 && digit_right_count > 0) || (decimal_pos >= 0 && (decimal_pos < digit_left_count || decimal_pos > (digit_left_count + zero_digit_count))) || (grouping_count).equal?(0) || in_quote)
          raise IllegalArgumentException.new("Malformed pattern \"" + pattern + RJava.cast_to_string(Character.new(?".ord)))
        end
        if ((j).equal?(1))
          @pos_prefix_pattern = RJava.cast_to_string(prefix.to_s)
          @pos_suffix_pattern = RJava.cast_to_string(suffix.to_s)
          @neg_prefix_pattern = @pos_prefix_pattern # assume these for now
          @neg_suffix_pattern = @pos_suffix_pattern
          digit_total_count = digit_left_count + zero_digit_count + digit_right_count
          # The effectiveDecimalPos is the position the decimal is at or
          # would be at if there is no decimal. Note that if decimalPos<0,
          # then digitTotalCount == digitLeftCount + zeroDigitCount.
          effective_decimal_pos = decimal_pos >= 0 ? decimal_pos : digit_total_count
          set_minimum_integer_digits(effective_decimal_pos - digit_left_count)
          set_maximum_integer_digits(@use_exponential_notation ? digit_left_count + get_minimum_integer_digits : MAXIMUM_INTEGER_DIGITS)
          set_maximum_fraction_digits(decimal_pos >= 0 ? (digit_total_count - decimal_pos) : 0)
          set_minimum_fraction_digits(decimal_pos >= 0 ? (digit_left_count + zero_digit_count - decimal_pos) : 0)
          set_grouping_used(grouping_count > 0)
          @grouping_size = (grouping_count > 0) ? grouping_count : 0
          @multiplier = multiplier
          set_decimal_separator_always_shown((decimal_pos).equal?(0) || (decimal_pos).equal?(digit_total_count))
        else
          @neg_prefix_pattern = RJava.cast_to_string(prefix.to_s)
          @neg_suffix_pattern = RJava.cast_to_string(suffix.to_s)
          got_negative = true
        end
        (j -= 1)
      end
      if ((pattern.length).equal?(0))
        @pos_prefix_pattern = RJava.cast_to_string(@pos_suffix_pattern = "")
        set_minimum_integer_digits(0)
        set_maximum_integer_digits(MAXIMUM_INTEGER_DIGITS)
        set_minimum_fraction_digits(0)
        set_maximum_fraction_digits(MAXIMUM_FRACTION_DIGITS)
      end
      # If there was no negative pattern, or if the negative pattern is
      # identical to the positive pattern, then prepend the minus sign to
      # the positive pattern to form the negative pattern.
      if (!got_negative || ((@neg_prefix_pattern == @pos_prefix_pattern) && (@neg_suffix_pattern == @pos_suffix_pattern)))
        @neg_suffix_pattern = @pos_suffix_pattern
        @neg_prefix_pattern = "'-" + @pos_prefix_pattern
      end
      expand_affixes
    end
    
    typesig { [::Java::Int] }
    # Sets the maximum number of digits allowed in the integer portion of a
    # number.
    # For formatting numbers other than <code>BigInteger</code> and
    # <code>BigDecimal</code> objects, the lower of <code>newValue</code> and
    # 309 is used. Negative input values are replaced with 0.
    # @see NumberFormat#setMaximumIntegerDigits
    def set_maximum_integer_digits(new_value)
      @maximum_integer_digits = Math.min(Math.max(0, new_value), MAXIMUM_INTEGER_DIGITS)
      super((@maximum_integer_digits > DOUBLE_INTEGER_DIGITS) ? DOUBLE_INTEGER_DIGITS : @maximum_integer_digits)
      if (@minimum_integer_digits > @maximum_integer_digits)
        @minimum_integer_digits = @maximum_integer_digits
        NumberFormat.instance_method(:set_minimum_integer_digits).bind(self).call((@minimum_integer_digits > DOUBLE_INTEGER_DIGITS) ? DOUBLE_INTEGER_DIGITS : @minimum_integer_digits)
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the minimum number of digits allowed in the integer portion of a
    # number.
    # For formatting numbers other than <code>BigInteger</code> and
    # <code>BigDecimal</code> objects, the lower of <code>newValue</code> and
    # 309 is used. Negative input values are replaced with 0.
    # @see NumberFormat#setMinimumIntegerDigits
    def set_minimum_integer_digits(new_value)
      @minimum_integer_digits = Math.min(Math.max(0, new_value), MAXIMUM_INTEGER_DIGITS)
      super((@minimum_integer_digits > DOUBLE_INTEGER_DIGITS) ? DOUBLE_INTEGER_DIGITS : @minimum_integer_digits)
      if (@minimum_integer_digits > @maximum_integer_digits)
        @maximum_integer_digits = @minimum_integer_digits
        NumberFormat.instance_method(:set_maximum_integer_digits).bind(self).call((@maximum_integer_digits > DOUBLE_INTEGER_DIGITS) ? DOUBLE_INTEGER_DIGITS : @maximum_integer_digits)
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the maximum number of digits allowed in the fraction portion of a
    # number.
    # For formatting numbers other than <code>BigInteger</code> and
    # <code>BigDecimal</code> objects, the lower of <code>newValue</code> and
    # 340 is used. Negative input values are replaced with 0.
    # @see NumberFormat#setMaximumFractionDigits
    def set_maximum_fraction_digits(new_value)
      @maximum_fraction_digits = Math.min(Math.max(0, new_value), MAXIMUM_FRACTION_DIGITS)
      super((@maximum_fraction_digits > DOUBLE_FRACTION_DIGITS) ? DOUBLE_FRACTION_DIGITS : @maximum_fraction_digits)
      if (@minimum_fraction_digits > @maximum_fraction_digits)
        @minimum_fraction_digits = @maximum_fraction_digits
        NumberFormat.instance_method(:set_minimum_fraction_digits).bind(self).call((@minimum_fraction_digits > DOUBLE_FRACTION_DIGITS) ? DOUBLE_FRACTION_DIGITS : @minimum_fraction_digits)
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the minimum number of digits allowed in the fraction portion of a
    # number.
    # For formatting numbers other than <code>BigInteger</code> and
    # <code>BigDecimal</code> objects, the lower of <code>newValue</code> and
    # 340 is used. Negative input values are replaced with 0.
    # @see NumberFormat#setMinimumFractionDigits
    def set_minimum_fraction_digits(new_value)
      @minimum_fraction_digits = Math.min(Math.max(0, new_value), MAXIMUM_FRACTION_DIGITS)
      super((@minimum_fraction_digits > DOUBLE_FRACTION_DIGITS) ? DOUBLE_FRACTION_DIGITS : @minimum_fraction_digits)
      if (@minimum_fraction_digits > @maximum_fraction_digits)
        @maximum_fraction_digits = @minimum_fraction_digits
        NumberFormat.instance_method(:set_maximum_fraction_digits).bind(self).call((@maximum_fraction_digits > DOUBLE_FRACTION_DIGITS) ? DOUBLE_FRACTION_DIGITS : @maximum_fraction_digits)
      end
    end
    
    typesig { [] }
    # Gets the maximum number of digits allowed in the integer portion of a
    # number.
    # For formatting numbers other than <code>BigInteger</code> and
    # <code>BigDecimal</code> objects, the lower of the return value and
    # 309 is used.
    # @see #setMaximumIntegerDigits
    def get_maximum_integer_digits
      return @maximum_integer_digits
    end
    
    typesig { [] }
    # Gets the minimum number of digits allowed in the integer portion of a
    # number.
    # For formatting numbers other than <code>BigInteger</code> and
    # <code>BigDecimal</code> objects, the lower of the return value and
    # 309 is used.
    # @see #setMinimumIntegerDigits
    def get_minimum_integer_digits
      return @minimum_integer_digits
    end
    
    typesig { [] }
    # Gets the maximum number of digits allowed in the fraction portion of a
    # number.
    # For formatting numbers other than <code>BigInteger</code> and
    # <code>BigDecimal</code> objects, the lower of the return value and
    # 340 is used.
    # @see #setMaximumFractionDigits
    def get_maximum_fraction_digits
      return @maximum_fraction_digits
    end
    
    typesig { [] }
    # Gets the minimum number of digits allowed in the fraction portion of a
    # number.
    # For formatting numbers other than <code>BigInteger</code> and
    # <code>BigDecimal</code> objects, the lower of the return value and
    # 340 is used.
    # @see #setMinimumFractionDigits
    def get_minimum_fraction_digits
      return @minimum_fraction_digits
    end
    
    typesig { [] }
    # Gets the currency used by this decimal format when formatting
    # currency values.
    # The currency is obtained by calling
    # {@link DecimalFormatSymbols#getCurrency DecimalFormatSymbols.getCurrency}
    # on this number format's symbols.
    # 
    # @return the currency used by this decimal format, or <code>null</code>
    # @since 1.4
    def get_currency
      return @symbols.get_currency
    end
    
    typesig { [Currency] }
    # Sets the currency used by this number format when formatting
    # currency values. This does not update the minimum or maximum
    # number of fraction digits used by the number format.
    # The currency is set by calling
    # {@link DecimalFormatSymbols#setCurrency DecimalFormatSymbols.setCurrency}
    # on this number format's symbols.
    # 
    # @param currency the new currency to be used by this decimal format
    # @exception NullPointerException if <code>currency</code> is null
    # @since 1.4
    def set_currency(currency)
      if (!(currency).equal?(@symbols.get_currency))
        @symbols.set_currency(currency)
        if (@is_currency_format)
          expand_affixes
        end
      end
    end
    
    typesig { [] }
    # Gets the {@link java.math.RoundingMode} used in this DecimalFormat.
    # 
    # @return The <code>RoundingMode</code> used for this DecimalFormat.
    # @see #setRoundingMode(RoundingMode)
    # @since 1.6
    def get_rounding_mode
      return @rounding_mode
    end
    
    typesig { [RoundingMode] }
    # Sets the {@link java.math.RoundingMode} used in this DecimalFormat.
    # 
    # @param roundingMode The <code>RoundingMode</code> to be used
    # @see #getRoundingMode()
    # @exception NullPointerException if <code>roundingMode</code> is null.
    # @since 1.6
    def set_rounding_mode(rounding_mode)
      if ((rounding_mode).nil?)
        raise NullPointerException.new
      end
      @rounding_mode = rounding_mode
      @digit_list.set_rounding_mode(rounding_mode)
    end
    
    typesig { [] }
    # Adjusts the minimum and maximum fraction digits to values that
    # are reasonable for the currency's default fraction digits.
    def adjust_for_currency_default_fraction_digits
      currency = @symbols.get_currency
      if ((currency).nil?)
        begin
          currency = Currency.get_instance(@symbols.get_international_currency_symbol)
        rescue IllegalArgumentException => e
        end
      end
      if (!(currency).nil?)
        digits = currency.get_default_fraction_digits
        if (!(digits).equal?(-1))
          old_min_digits = get_minimum_fraction_digits
          # Common patterns are "#.##", "#.00", "#".
          # Try to adjust all of them in a reasonable way.
          if ((old_min_digits).equal?(get_maximum_fraction_digits))
            set_minimum_fraction_digits(digits)
            set_maximum_fraction_digits(digits)
          else
            set_minimum_fraction_digits(Math.min(digits, old_min_digits))
            set_maximum_fraction_digits(digits)
          end
        end
      end
    end
    
    typesig { [ObjectInputStream] }
    # Reads the default serializable fields from the stream and performs
    # validations and adjustments for older serialized versions. The
    # validations and adjustments are:
    # <ol>
    # <li>
    # Verify that the superclass's digit count fields correctly reflect
    # the limits imposed on formatting numbers other than
    # <code>BigInteger</code> and <code>BigDecimal</code> objects. These
    # limits are stored in the superclass for serialization compatibility
    # with older versions, while the limits for <code>BigInteger</code> and
    # <code>BigDecimal</code> objects are kept in this class.
    # If, in the superclass, the minimum or maximum integer digit count is
    # larger than <code>DOUBLE_INTEGER_DIGITS</code> or if the minimum or
    # maximum fraction digit count is larger than
    # <code>DOUBLE_FRACTION_DIGITS</code>, then the stream data is invalid
    # and this method throws an <code>InvalidObjectException</code>.
    # <li>
    # If <code>serialVersionOnStream</code> is less than 4, initialize
    # <code>roundingMode</code> to {@link java.math.RoundingMode#HALF_EVEN
    # RoundingMode.HALF_EVEN}.  This field is new with version 4.
    # <li>
    # If <code>serialVersionOnStream</code> is less than 3, then call
    # the setters for the minimum and maximum integer and fraction digits with
    # the values of the corresponding superclass getters to initialize the
    # fields in this class. The fields in this class are new with version 3.
    # <li>
    # If <code>serialVersionOnStream</code> is less than 1, indicating that
    # the stream was written by JDK 1.1, initialize
    # <code>useExponentialNotation</code>
    # to false, since it was not present in JDK 1.1.
    # <li>
    # Set <code>serialVersionOnStream</code> to the maximum allowed value so
    # that default serialization will work properly if this object is streamed
    # out again.
    # </ol>
    # 
    # <p>Stream versions older than 2 will not have the affix pattern variables
    # <code>posPrefixPattern</code> etc.  As a result, they will be initialized
    # to <code>null</code>, which means the affix strings will be taken as
    # literal values.  This is exactly what we want, since that corresponds to
    # the pre-version-2 behavior.
    def read_object(stream)
      stream.default_read_object
      @digit_list = DigitList.new
      if (@serial_version_on_stream < 4)
        set_rounding_mode(RoundingMode::HALF_EVEN)
      end
      # We only need to check the maximum counts because NumberFormat
      # .readObject has already ensured that the maximum is greater than the
      # minimum count.
      if (NumberFormat.instance_method(:get_maximum_integer_digits).bind(self).call > DOUBLE_INTEGER_DIGITS || NumberFormat.instance_method(:get_maximum_fraction_digits).bind(self).call > DOUBLE_FRACTION_DIGITS)
        raise InvalidObjectException.new("Digit count out of range")
      end
      if (@serial_version_on_stream < 3)
        set_maximum_integer_digits(NumberFormat.instance_method(:get_maximum_integer_digits).bind(self).call)
        set_minimum_integer_digits(NumberFormat.instance_method(:get_minimum_integer_digits).bind(self).call)
        set_maximum_fraction_digits(NumberFormat.instance_method(:get_maximum_fraction_digits).bind(self).call)
        set_minimum_fraction_digits(NumberFormat.instance_method(:get_minimum_fraction_digits).bind(self).call)
      end
      if (@serial_version_on_stream < 1)
        # Didn't have exponential fields
        @use_exponential_notation = false
      end
      @serial_version_on_stream = CurrentSerialVersion
    end
    
    # ----------------------------------------------------------------------
    # INSTANCE VARIABLES
    # ----------------------------------------------------------------------
    attr_accessor :digit_list
    alias_method :attr_digit_list, :digit_list
    undef_method :digit_list
    alias_method :attr_digit_list=, :digit_list=
    undef_method :digit_list=
    
    # The symbol used as a prefix when formatting positive numbers, e.g. "+".
    # 
    # @serial
    # @see #getPositivePrefix
    attr_accessor :positive_prefix
    alias_method :attr_positive_prefix, :positive_prefix
    undef_method :positive_prefix
    alias_method :attr_positive_prefix=, :positive_prefix=
    undef_method :positive_prefix=
    
    # The symbol used as a suffix when formatting positive numbers.
    # This is often an empty string.
    # 
    # @serial
    # @see #getPositiveSuffix
    attr_accessor :positive_suffix
    alias_method :attr_positive_suffix, :positive_suffix
    undef_method :positive_suffix
    alias_method :attr_positive_suffix=, :positive_suffix=
    undef_method :positive_suffix=
    
    # The symbol used as a prefix when formatting negative numbers, e.g. "-".
    # 
    # @serial
    # @see #getNegativePrefix
    attr_accessor :negative_prefix
    alias_method :attr_negative_prefix, :negative_prefix
    undef_method :negative_prefix
    alias_method :attr_negative_prefix=, :negative_prefix=
    undef_method :negative_prefix=
    
    # The symbol used as a suffix when formatting negative numbers.
    # This is often an empty string.
    # 
    # @serial
    # @see #getNegativeSuffix
    attr_accessor :negative_suffix
    alias_method :attr_negative_suffix, :negative_suffix
    undef_method :negative_suffix
    alias_method :attr_negative_suffix=, :negative_suffix=
    undef_method :negative_suffix=
    
    # The prefix pattern for non-negative numbers.  This variable corresponds
    # to <code>positivePrefix</code>.
    # 
    # <p>This pattern is expanded by the method <code>expandAffix()</code> to
    # <code>positivePrefix</code> to update the latter to reflect changes in
    # <code>symbols</code>.  If this variable is <code>null</code> then
    # <code>positivePrefix</code> is taken as a literal value that does not
    # change when <code>symbols</code> changes.  This variable is always
    # <code>null</code> for <code>DecimalFormat</code> objects older than
    # stream version 2 restored from stream.
    # 
    # @serial
    # @since 1.3
    attr_accessor :pos_prefix_pattern
    alias_method :attr_pos_prefix_pattern, :pos_prefix_pattern
    undef_method :pos_prefix_pattern
    alias_method :attr_pos_prefix_pattern=, :pos_prefix_pattern=
    undef_method :pos_prefix_pattern=
    
    # The suffix pattern for non-negative numbers.  This variable corresponds
    # to <code>positiveSuffix</code>.  This variable is analogous to
    # <code>posPrefixPattern</code>; see that variable for further
    # documentation.
    # 
    # @serial
    # @since 1.3
    attr_accessor :pos_suffix_pattern
    alias_method :attr_pos_suffix_pattern, :pos_suffix_pattern
    undef_method :pos_suffix_pattern
    alias_method :attr_pos_suffix_pattern=, :pos_suffix_pattern=
    undef_method :pos_suffix_pattern=
    
    # The prefix pattern for negative numbers.  This variable corresponds
    # to <code>negativePrefix</code>.  This variable is analogous to
    # <code>posPrefixPattern</code>; see that variable for further
    # documentation.
    # 
    # @serial
    # @since 1.3
    attr_accessor :neg_prefix_pattern
    alias_method :attr_neg_prefix_pattern, :neg_prefix_pattern
    undef_method :neg_prefix_pattern
    alias_method :attr_neg_prefix_pattern=, :neg_prefix_pattern=
    undef_method :neg_prefix_pattern=
    
    # The suffix pattern for negative numbers.  This variable corresponds
    # to <code>negativeSuffix</code>.  This variable is analogous to
    # <code>posPrefixPattern</code>; see that variable for further
    # documentation.
    # 
    # @serial
    # @since 1.3
    attr_accessor :neg_suffix_pattern
    alias_method :attr_neg_suffix_pattern, :neg_suffix_pattern
    undef_method :neg_suffix_pattern
    alias_method :attr_neg_suffix_pattern=, :neg_suffix_pattern=
    undef_method :neg_suffix_pattern=
    
    # The multiplier for use in percent, per mille, etc.
    # 
    # @serial
    # @see #getMultiplier
    attr_accessor :multiplier
    alias_method :attr_multiplier, :multiplier
    undef_method :multiplier
    alias_method :attr_multiplier=, :multiplier=
    undef_method :multiplier=
    
    # The number of digits between grouping separators in the integer
    # portion of a number.  Must be greater than 0 if
    # <code>NumberFormat.groupingUsed</code> is true.
    # 
    # @serial
    # @see #getGroupingSize
    # @see java.text.NumberFormat#isGroupingUsed
    attr_accessor :grouping_size
    alias_method :attr_grouping_size, :grouping_size
    undef_method :grouping_size
    alias_method :attr_grouping_size=, :grouping_size=
    undef_method :grouping_size=
    
    # invariant, > 0 if useThousands
    # 
    # If true, forces the decimal separator to always appear in a formatted
    # number, even if the fractional part of the number is zero.
    # 
    # @serial
    # @see #isDecimalSeparatorAlwaysShown
    attr_accessor :decimal_separator_always_shown
    alias_method :attr_decimal_separator_always_shown, :decimal_separator_always_shown
    undef_method :decimal_separator_always_shown
    alias_method :attr_decimal_separator_always_shown=, :decimal_separator_always_shown=
    undef_method :decimal_separator_always_shown=
    
    # If true, parse returns BigDecimal wherever possible.
    # 
    # @serial
    # @see #isParseBigDecimal
    # @since 1.5
    attr_accessor :parse_big_decimal
    alias_method :attr_parse_big_decimal, :parse_big_decimal
    undef_method :parse_big_decimal
    alias_method :attr_parse_big_decimal=, :parse_big_decimal=
    undef_method :parse_big_decimal=
    
    # True if this object represents a currency format.  This determines
    # whether the monetary decimal separator is used instead of the normal one.
    attr_accessor :is_currency_format
    alias_method :attr_is_currency_format, :is_currency_format
    undef_method :is_currency_format
    alias_method :attr_is_currency_format=, :is_currency_format=
    undef_method :is_currency_format=
    
    # The <code>DecimalFormatSymbols</code> object used by this format.
    # It contains the symbols used to format numbers, e.g. the grouping separator,
    # decimal separator, and so on.
    # 
    # @serial
    # @see #setDecimalFormatSymbols
    # @see java.text.DecimalFormatSymbols
    attr_accessor :symbols
    alias_method :attr_symbols, :symbols
    undef_method :symbols
    alias_method :attr_symbols=, :symbols=
    undef_method :symbols=
    
    # LIU new DecimalFormatSymbols();
    # 
    # True to force the use of exponential (i.e. scientific) notation when formatting
    # numbers.
    # 
    # @serial
    # @since 1.2
    attr_accessor :use_exponential_notation
    alias_method :attr_use_exponential_notation, :use_exponential_notation
    undef_method :use_exponential_notation
    alias_method :attr_use_exponential_notation=, :use_exponential_notation=
    undef_method :use_exponential_notation=
    
    # Newly persistent in the Java 2 platform v.1.2
    # 
    # FieldPositions describing the positive prefix String. This is
    # lazily created. Use <code>getPositivePrefixFieldPositions</code>
    # when needed.
    attr_accessor :positive_prefix_field_positions
    alias_method :attr_positive_prefix_field_positions, :positive_prefix_field_positions
    undef_method :positive_prefix_field_positions
    alias_method :attr_positive_prefix_field_positions=, :positive_prefix_field_positions=
    undef_method :positive_prefix_field_positions=
    
    # FieldPositions describing the positive suffix String. This is
    # lazily created. Use <code>getPositiveSuffixFieldPositions</code>
    # when needed.
    attr_accessor :positive_suffix_field_positions
    alias_method :attr_positive_suffix_field_positions, :positive_suffix_field_positions
    undef_method :positive_suffix_field_positions
    alias_method :attr_positive_suffix_field_positions=, :positive_suffix_field_positions=
    undef_method :positive_suffix_field_positions=
    
    # FieldPositions describing the negative prefix String. This is
    # lazily created. Use <code>getNegativePrefixFieldPositions</code>
    # when needed.
    attr_accessor :negative_prefix_field_positions
    alias_method :attr_negative_prefix_field_positions, :negative_prefix_field_positions
    undef_method :negative_prefix_field_positions
    alias_method :attr_negative_prefix_field_positions=, :negative_prefix_field_positions=
    undef_method :negative_prefix_field_positions=
    
    # FieldPositions describing the negative suffix String. This is
    # lazily created. Use <code>getNegativeSuffixFieldPositions</code>
    # when needed.
    attr_accessor :negative_suffix_field_positions
    alias_method :attr_negative_suffix_field_positions, :negative_suffix_field_positions
    undef_method :negative_suffix_field_positions
    alias_method :attr_negative_suffix_field_positions=, :negative_suffix_field_positions=
    undef_method :negative_suffix_field_positions=
    
    # The minimum number of digits used to display the exponent when a number is
    # formatted in exponential notation.  This field is ignored if
    # <code>useExponentialNotation</code> is not true.
    # 
    # @serial
    # @since 1.2
    attr_accessor :min_exponent_digits
    alias_method :attr_min_exponent_digits, :min_exponent_digits
    undef_method :min_exponent_digits
    alias_method :attr_min_exponent_digits=, :min_exponent_digits=
    undef_method :min_exponent_digits=
    
    # Newly persistent in the Java 2 platform v.1.2
    # 
    # The maximum number of digits allowed in the integer portion of a
    # <code>BigInteger</code> or <code>BigDecimal</code> number.
    # <code>maximumIntegerDigits</code> must be greater than or equal to
    # <code>minimumIntegerDigits</code>.
    # 
    # @serial
    # @see #getMaximumIntegerDigits
    # @since 1.5
    attr_accessor :maximum_integer_digits
    alias_method :attr_maximum_integer_digits, :maximum_integer_digits
    undef_method :maximum_integer_digits
    alias_method :attr_maximum_integer_digits=, :maximum_integer_digits=
    undef_method :maximum_integer_digits=
    
    # The minimum number of digits allowed in the integer portion of a
    # <code>BigInteger</code> or <code>BigDecimal</code> number.
    # <code>minimumIntegerDigits</code> must be less than or equal to
    # <code>maximumIntegerDigits</code>.
    # 
    # @serial
    # @see #getMinimumIntegerDigits
    # @since 1.5
    attr_accessor :minimum_integer_digits
    alias_method :attr_minimum_integer_digits, :minimum_integer_digits
    undef_method :minimum_integer_digits
    alias_method :attr_minimum_integer_digits=, :minimum_integer_digits=
    undef_method :minimum_integer_digits=
    
    # The maximum number of digits allowed in the fractional portion of a
    # <code>BigInteger</code> or <code>BigDecimal</code> number.
    # <code>maximumFractionDigits</code> must be greater than or equal to
    # <code>minimumFractionDigits</code>.
    # 
    # @serial
    # @see #getMaximumFractionDigits
    # @since 1.5
    attr_accessor :maximum_fraction_digits
    alias_method :attr_maximum_fraction_digits, :maximum_fraction_digits
    undef_method :maximum_fraction_digits
    alias_method :attr_maximum_fraction_digits=, :maximum_fraction_digits=
    undef_method :maximum_fraction_digits=
    
    # The minimum number of digits allowed in the fractional portion of a
    # <code>BigInteger</code> or <code>BigDecimal</code> number.
    # <code>minimumFractionDigits</code> must be less than or equal to
    # <code>maximumFractionDigits</code>.
    # 
    # @serial
    # @see #getMinimumFractionDigits
    # @since 1.5
    attr_accessor :minimum_fraction_digits
    alias_method :attr_minimum_fraction_digits, :minimum_fraction_digits
    undef_method :minimum_fraction_digits
    alias_method :attr_minimum_fraction_digits=, :minimum_fraction_digits=
    undef_method :minimum_fraction_digits=
    
    # The {@link java.math.RoundingMode} used in this DecimalFormat.
    # 
    # @serial
    # @since 1.6
    attr_accessor :rounding_mode
    alias_method :attr_rounding_mode, :rounding_mode
    undef_method :rounding_mode
    alias_method :attr_rounding_mode=, :rounding_mode=
    undef_method :rounding_mode=
    
    class_module.module_eval {
      # ----------------------------------------------------------------------
      const_set_lazy(:CurrentSerialVersion) { 4 }
      const_attr_reader  :CurrentSerialVersion
    }
    
    # The internal serial version which says which version was written.
    # Possible values are:
    # <ul>
    # <li><b>0</b> (default): versions before the Java 2 platform v1.2
    # <li><b>1</b>: version for 1.2, which includes the two new fields
    # <code>useExponentialNotation</code> and
    # <code>minExponentDigits</code>.
    # <li><b>2</b>: version for 1.3 and later, which adds four new fields:
    # <code>posPrefixPattern</code>, <code>posSuffixPattern</code>,
    # <code>negPrefixPattern</code>, and <code>negSuffixPattern</code>.
    # <li><b>3</b>: version for 1.5 and later, which adds five new fields:
    # <code>maximumIntegerDigits</code>,
    # <code>minimumIntegerDigits</code>,
    # <code>maximumFractionDigits</code>,
    # <code>minimumFractionDigits</code>, and
    # <code>parseBigDecimal</code>.
    # <li><b>4</b>: version for 1.6 and later, which adds one new field:
    # <code>roundingMode</code>.
    # </ul>
    # @since 1.2
    # @serial
    attr_accessor :serial_version_on_stream
    alias_method :attr_serial_version_on_stream, :serial_version_on_stream
    undef_method :serial_version_on_stream
    alias_method :attr_serial_version_on_stream=, :serial_version_on_stream=
    undef_method :serial_version_on_stream=
    
    class_module.module_eval {
      # ----------------------------------------------------------------------
      # CONSTANTS
      # ----------------------------------------------------------------------
      # Constants for characters used in programmatic (unlocalized) patterns.
      const_set_lazy(:PATTERN_ZERO_DIGIT) { Character.new(?0.ord) }
      const_attr_reader  :PATTERN_ZERO_DIGIT
      
      const_set_lazy(:PATTERN_GROUPING_SEPARATOR) { Character.new(?,.ord) }
      const_attr_reader  :PATTERN_GROUPING_SEPARATOR
      
      const_set_lazy(:PATTERN_DECIMAL_SEPARATOR) { Character.new(?..ord) }
      const_attr_reader  :PATTERN_DECIMAL_SEPARATOR
      
      const_set_lazy(:PATTERN_PER_MILLE) { Character.new(0x2030) }
      const_attr_reader  :PATTERN_PER_MILLE
      
      const_set_lazy(:PATTERN_PERCENT) { Character.new(?%.ord) }
      const_attr_reader  :PATTERN_PERCENT
      
      const_set_lazy(:PATTERN_DIGIT) { Character.new(?#.ord) }
      const_attr_reader  :PATTERN_DIGIT
      
      const_set_lazy(:PATTERN_SEPARATOR) { Character.new(?;.ord) }
      const_attr_reader  :PATTERN_SEPARATOR
      
      const_set_lazy(:PATTERN_EXPONENT) { "E" }
      const_attr_reader  :PATTERN_EXPONENT
      
      const_set_lazy(:PATTERN_MINUS) { Character.new(?-.ord) }
      const_attr_reader  :PATTERN_MINUS
      
      # The CURRENCY_SIGN is the standard Unicode symbol for currency.  It
      # is used in patterns and substituted with either the currency symbol,
      # or if it is doubled, with the international currency symbol.  If the
      # CURRENCY_SIGN is seen in a pattern, then the decimal separator is
      # replaced with the monetary decimal separator.
      # 
      # The CURRENCY_SIGN is not localized.
      const_set_lazy(:CURRENCY_SIGN) { Character.new(0x00A4) }
      const_attr_reader  :CURRENCY_SIGN
      
      const_set_lazy(:QUOTE) { Character.new(?\'.ord) }
      const_attr_reader  :QUOTE
      
      
      def empty_field_position_array
        defined?(@@empty_field_position_array) ? @@empty_field_position_array : @@empty_field_position_array= Array.typed(FieldPosition).new(0) { nil }
      end
      alias_method :attr_empty_field_position_array, :empty_field_position_array
      
      def empty_field_position_array=(value)
        @@empty_field_position_array = value
      end
      alias_method :attr_empty_field_position_array=, :empty_field_position_array=
      
      # Upper limit on integer and fraction digits for a Java double
      const_set_lazy(:DOUBLE_INTEGER_DIGITS) { 309 }
      const_attr_reader  :DOUBLE_INTEGER_DIGITS
      
      const_set_lazy(:DOUBLE_FRACTION_DIGITS) { 340 }
      const_attr_reader  :DOUBLE_FRACTION_DIGITS
      
      # Upper limit on integer and fraction digits for BigDecimal and BigInteger
      const_set_lazy(:MAXIMUM_INTEGER_DIGITS) { JavaInteger::MAX_VALUE }
      const_attr_reader  :MAXIMUM_INTEGER_DIGITS
      
      const_set_lazy(:MAXIMUM_FRACTION_DIGITS) { JavaInteger::MAX_VALUE }
      const_attr_reader  :MAXIMUM_FRACTION_DIGITS
      
      # Proclaim JDK 1.1 serial compatibility.
      const_set_lazy(:SerialVersionUID) { 864413376551465018 }
      const_attr_reader  :SerialVersionUID
      
      # Cache to hold the NumberPattern of a Locale.
      
      def cached_locale_data
        defined?(@@cached_locale_data) ? @@cached_locale_data : @@cached_locale_data= Hashtable.new(3)
      end
      alias_method :attr_cached_locale_data, :cached_locale_data
      
      def cached_locale_data=(value)
        @@cached_locale_data = value
      end
      alias_method :attr_cached_locale_data=, :cached_locale_data=
    }
    
    private
    alias_method :initialize__decimal_format, :initialize
  end
  
end
