require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util
  module ScannerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include ::Java::Util::Regex
      include ::Java::Io
      include ::Java::Math
      include ::Java::Nio
      include ::Java::Nio::Channels
      include ::Java::Nio::Charset
      include ::Java::Text
      include_const ::Java::Util, :Locale
      include_const ::Sun::Misc, :LRUCache
    }
  end
  
  # A simple text scanner which can parse primitive types and strings using
  # regular expressions.
  # 
  # <p>A <code>Scanner</code> breaks its input into tokens using a
  # delimiter pattern, which by default matches whitespace. The resulting
  # tokens may then be converted into values of different types using the
  # various <tt>next</tt> methods.
  # 
  # <p>For example, this code allows a user to read a number from
  # <tt>System.in</tt>:
  # <blockquote><pre>
  # Scanner sc = new Scanner(System.in);
  # int i = sc.nextInt();
  # </pre></blockquote>
  # 
  # <p>As another example, this code allows <code>long</code> types to be
  # assigned from entries in a file <code>myNumbers</code>:
  # <blockquote><pre>
  # Scanner sc = new Scanner(new File("myNumbers"));
  # while (sc.hasNextLong()) {
  # long aLong = sc.nextLong();
  # }</pre></blockquote>
  # 
  # <p>The scanner can also use delimiters other than whitespace. This
  # example reads several items in from a string:
  # <blockquote><pre>
  # String input = "1 fish 2 fish red fish blue fish";
  # Scanner s = new Scanner(input).useDelimiter("\\s*fish\\s*");
  # System.out.println(s.nextInt());
  # System.out.println(s.nextInt());
  # System.out.println(s.next());
  # System.out.println(s.next());
  # s.close(); </pre></blockquote>
  # <p>
  # prints the following output:
  # <blockquote><pre>
  # 1
  # 2
  # red
  # blue </pre></blockquote>
  # 
  # <p>The same output can be generated with this code, which uses a regular
  # expression to parse all four tokens at once:
  # <blockquote><pre>
  # String input = "1 fish 2 fish red fish blue fish";
  # Scanner s = new Scanner(input);
  # s.findInLine("(\\d+) fish (\\d+) fish (\\w+) fish (\\w+)");
  # MatchResult result = s.match();
  # for (int i=1; i<=result.groupCount(); i++)
  # System.out.println(result.group(i));
  # s.close(); </pre></blockquote>
  # 
  # <p>The <a name="default-delimiter">default whitespace delimiter</a> used
  # by a scanner is as recognized by {@link java.lang.Character}.{@link
  # java.lang.Character#isWhitespace(char) isWhitespace}. The {@link #reset}
  # method will reset the value of the scanner's delimiter to the default
  # whitespace delimiter regardless of whether it was previously changed.
  # 
  # <p>A scanning operation may block waiting for input.
  # 
  # <p>The {@link #next} and {@link #hasNext} methods and their
  # primitive-type companion methods (such as {@link #nextInt} and
  # {@link #hasNextInt}) first skip any input that matches the delimiter
  # pattern, and then attempt to return the next token. Both <tt>hasNext</tt>
  # and <tt>next</tt> methods may block waiting for further input.  Whether a
  # <tt>hasNext</tt> method blocks has no connection to whether or not its
  # associated <tt>next</tt> method will block.
  # 
  # <p> The {@link #findInLine}, {@link #findWithinHorizon}, and {@link #skip}
  # methods operate independently of the delimiter pattern. These methods will
  # attempt to match the specified pattern with no regard to delimiters in the
  # input and thus can be used in special circumstances where delimiters are
  # not relevant. These methods may block waiting for more input.
  # 
  # <p>When a scanner throws an {@link InputMismatchException}, the scanner
  # will not pass the token that caused the exception, so that it may be
  # retrieved or skipped via some other method.
  # 
  # <p>Depending upon the type of delimiting pattern, empty tokens may be
  # returned. For example, the pattern <tt>"\\s+"</tt> will return no empty
  # tokens since it matches multiple instances of the delimiter. The delimiting
  # pattern <tt>"\\s"</tt> could return empty tokens since it only passes one
  # space at a time.
  # 
  # <p> A scanner can read text from any object which implements the {@link
  # java.lang.Readable} interface.  If an invocation of the underlying
  # readable's {@link java.lang.Readable#read} method throws an {@link
  # java.io.IOException} then the scanner assumes that the end of the input
  # has been reached.  The most recent <tt>IOException</tt> thrown by the
  # underlying readable can be retrieved via the {@link #ioException} method.
  # 
  # <p>When a <code>Scanner</code> is closed, it will close its input source
  # if the source implements the {@link java.io.Closeable} interface.
  # 
  # <p>A <code>Scanner</code> is not safe for multithreaded use without
  # external synchronization.
  # 
  # <p>Unless otherwise mentioned, passing a <code>null</code> parameter into
  # any method of a <code>Scanner</code> will cause a
  # <code>NullPointerException</code> to be thrown.
  # 
  # <p>A scanner will default to interpreting numbers as decimal unless a
  # different radix has been set by using the {@link #useRadix} method. The
  # {@link #reset} method will reset the value of the scanner's radix to
  # <code>10</code> regardless of whether it was previously changed.
  # 
  # <a name="localized-numbers">
  # <h4> Localized numbers </h4>
  # 
  # <p> An instance of this class is capable of scanning numbers in the standard
  # formats as well as in the formats of the scanner's locale. A scanner's
  # <a name="initial-locale">initial locale </a>is the value returned by the {@link
  # java.util.Locale#getDefault} method; it may be changed via the {@link
  # #useLocale} method. The {@link #reset} method will reset the value of the
  # scanner's locale to the initial locale regardless of whether it was
  # previously changed.
  # 
  # <p>The localized formats are defined in terms of the following parameters,
  # which for a particular locale are taken from that locale's {@link
  # java.text.DecimalFormat DecimalFormat} object, <tt>df</tt>, and its and
  # {@link java.text.DecimalFormatSymbols DecimalFormatSymbols} object,
  # <tt>dfs</tt>.
  # 
  # <blockquote><table>
  # <tr><td valign="top"><i>LocalGroupSeparator&nbsp;&nbsp;</i></td>
  # <td valign="top">The character used to separate thousands groups,
  # <i>i.e.,</i>&nbsp;<tt>dfs.</tt>{@link
  # java.text.DecimalFormatSymbols#getGroupingSeparator
  # getGroupingSeparator()}</td></tr>
  # <tr><td valign="top"><i>LocalDecimalSeparator&nbsp;&nbsp;</i></td>
  # <td valign="top">The character used for the decimal point,
  # <i>i.e.,</i>&nbsp;<tt>dfs.</tt>{@link
  # java.text.DecimalFormatSymbols#getDecimalSeparator
  # getDecimalSeparator()}</td></tr>
  # <tr><td valign="top"><i>LocalPositivePrefix&nbsp;&nbsp;</i></td>
  # <td valign="top">The string that appears before a positive number (may
  # be empty), <i>i.e.,</i>&nbsp;<tt>df.</tt>{@link
  # java.text.DecimalFormat#getPositivePrefix
  # getPositivePrefix()}</td></tr>
  # <tr><td valign="top"><i>LocalPositiveSuffix&nbsp;&nbsp;</i></td>
  # <td valign="top">The string that appears after a positive number (may be
  # empty), <i>i.e.,</i>&nbsp;<tt>df.</tt>{@link
  # java.text.DecimalFormat#getPositiveSuffix
  # getPositiveSuffix()}</td></tr>
  # <tr><td valign="top"><i>LocalNegativePrefix&nbsp;&nbsp;</i></td>
  # <td valign="top">The string that appears before a negative number (may
  # be empty), <i>i.e.,</i>&nbsp;<tt>df.</tt>{@link
  # java.text.DecimalFormat#getNegativePrefix
  # getNegativePrefix()}</td></tr>
  # <tr><td valign="top"><i>LocalNegativeSuffix&nbsp;&nbsp;</i></td>
  # <td valign="top">The string that appears after a negative number (may be
  # empty), <i>i.e.,</i>&nbsp;<tt>df.</tt>{@link
  # java.text.DecimalFormat#getNegativeSuffix
  # getNegativeSuffix()}</td></tr>
  # <tr><td valign="top"><i>LocalNaN&nbsp;&nbsp;</i></td>
  # <td valign="top">The string that represents not-a-number for
  # floating-point values,
  # <i>i.e.,</i>&nbsp;<tt>dfs.</tt>{@link
  # java.text.DecimalFormatSymbols#getNaN
  # getNaN()}</td></tr>
  # <tr><td valign="top"><i>LocalInfinity&nbsp;&nbsp;</i></td>
  # <td valign="top">The string that represents infinity for floating-point
  # values, <i>i.e.,</i>&nbsp;<tt>dfs.</tt>{@link
  # java.text.DecimalFormatSymbols#getInfinity
  # getInfinity()}</td></tr>
  # </table></blockquote>
  # 
  # <a name="number-syntax">
  # <h4> Number syntax </h4>
  # 
  # <p> The strings that can be parsed as numbers by an instance of this class
  # are specified in terms of the following regular-expression grammar, where
  # Rmax is the highest digit in the radix being used (for example, Rmax is 9
  # in base 10).
  # 
  # <p>
  # <table cellspacing=0 cellpadding=0 align=center>
  # 
  # <tr><td valign=top align=right><i>NonASCIIDigit</i>&nbsp;&nbsp;::</td>
  # <td valign=top>= A non-ASCII character c for which
  # {@link java.lang.Character#isDigit Character.isDigit}<tt>(c)</tt>
  # returns&nbsp;true</td></tr>
  # 
  # <tr><td>&nbsp;</td></tr>
  # 
  # <tr><td align=right><i>Non0Digit</i>&nbsp;&nbsp;::</td>
  # <td><tt>= [1-</tt><i>Rmax</i><tt>] | </tt><i>NonASCIIDigit</i></td></tr>
  # 
  # <tr><td>&nbsp;</td></tr>
  # 
  # <tr><td align=right><i>Digit</i>&nbsp;&nbsp;::</td>
  # <td><tt>= [0-</tt><i>Rmax</i><tt>] | </tt><i>NonASCIIDigit</i></td></tr>
  # 
  # <tr><td>&nbsp;</td></tr>
  # 
  # <tr><td valign=top align=right><i>GroupedNumeral</i>&nbsp;&nbsp;::</td>
  # <td valign=top>
  # <table cellpadding=0 cellspacing=0>
  # <tr><td><tt>= (&nbsp;</tt></td>
  # <td><i>Non0Digit</i><tt>
  # </tt><i>Digit</i><tt>?
  # </tt><i>Digit</i><tt>?</tt></td></tr>
  # <tr><td></td>
  # <td><tt>(&nbsp;</tt><i>LocalGroupSeparator</i><tt>
  # </tt><i>Digit</i><tt>
  # </tt><i>Digit</i><tt>
  # </tt><i>Digit</i><tt> )+ )</tt></td></tr>
  # </table></td></tr>
  # 
  # <tr><td>&nbsp;</td></tr>
  # 
  # <tr><td align=right><i>Numeral</i>&nbsp;&nbsp;::</td>
  # <td><tt>= ( ( </tt><i>Digit</i><tt>+ )
  # | </tt><i>GroupedNumeral</i><tt> )</tt></td></tr>
  # 
  # <tr><td>&nbsp;</td></tr>
  # 
  # <tr><td valign=top align=right>
  # <a name="Integer-regex"><i>Integer</i>&nbsp;&nbsp;::</td>
  # <td valign=top><tt>= ( [-+]? ( </tt><i>Numeral</i><tt>
  # ) )</tt></td></tr>
  # <tr><td></td>
  # <td><tt>| </tt><i>LocalPositivePrefix</i><tt> </tt><i>Numeral</i><tt>
  # </tt><i>LocalPositiveSuffix</i></td></tr>
  # <tr><td></td>
  # <td><tt>| </tt><i>LocalNegativePrefix</i><tt> </tt><i>Numeral</i><tt>
  # </tt><i>LocalNegativeSuffix</i></td></tr>
  # 
  # <tr><td>&nbsp;</td></tr>
  # 
  # <tr><td align=right><i>DecimalNumeral</i>&nbsp;&nbsp;::</td>
  # <td><tt>= </tt><i>Numeral</i></td></tr>
  # <tr><td></td>
  # <td><tt>| </tt><i>Numeral</i><tt>
  # </tt><i>LocalDecimalSeparator</i><tt>
  # </tt><i>Digit</i><tt>*</tt></td></tr>
  # <tr><td></td>
  # <td><tt>| </tt><i>LocalDecimalSeparator</i><tt>
  # </tt><i>Digit</i><tt>+</tt></td></tr>
  # 
  # <tr><td>&nbsp;</td></tr>
  # 
  # <tr><td align=right><i>Exponent</i>&nbsp;&nbsp;::</td>
  # <td><tt>= ( [eE] [+-]? </tt><i>Digit</i><tt>+ )</tt></td></tr>
  # 
  # <tr><td>&nbsp;</td></tr>
  # 
  # <tr><td align=right>
  # <a name="Decimal-regex"><i>Decimal</i>&nbsp;&nbsp;::</td>
  # <td><tt>= ( [-+]? </tt><i>DecimalNumeral</i><tt>
  # </tt><i>Exponent</i><tt>? )</tt></td></tr>
  # <tr><td></td>
  # <td><tt>| </tt><i>LocalPositivePrefix</i><tt>
  # </tt><i>DecimalNumeral</i><tt>
  # </tt><i>LocalPositiveSuffix</i>
  # </tt><i>Exponent</i><tt>?</td></tr>
  # <tr><td></td>
  # <td><tt>| </tt><i>LocalNegativePrefix</i><tt>
  # </tt><i>DecimalNumeral</i><tt>
  # </tt><i>LocalNegativeSuffix</i>
  # </tt><i>Exponent</i><tt>?</td></tr>
  # 
  # <tr><td>&nbsp;</td></tr>
  # 
  # <tr><td align=right><i>HexFloat</i>&nbsp;&nbsp;::</td>
  # <td><tt>= [-+]? 0[xX][0-9a-fA-F]*\.[0-9a-fA-F]+
  # ([pP][-+]?[0-9]+)?</tt></td></tr>
  # 
  # <tr><td>&nbsp;</td></tr>
  # 
  # <tr><td align=right><i>NonNumber</i>&nbsp;&nbsp;::</td>
  # <td valign=top><tt>= NaN
  # | </tt><i>LocalNan</i><tt>
  # | Infinity
  # | </tt><i>LocalInfinity</i></td></tr>
  # 
  # <tr><td>&nbsp;</td></tr>
  # 
  # <tr><td align=right><i>SignedNonNumber</i>&nbsp;&nbsp;::</td>
  # <td><tt>= ( [-+]? </tt><i>NonNumber</i><tt> )</tt></td></tr>
  # <tr><td></td>
  # <td><tt>| </tt><i>LocalPositivePrefix</i><tt>
  # </tt><i>NonNumber</i><tt>
  # </tt><i>LocalPositiveSuffix</i></td></tr>
  # <tr><td></td>
  # <td><tt>| </tt><i>LocalNegativePrefix</i><tt>
  # </tt><i>NonNumber</i><tt>
  # </tt><i>LocalNegativeSuffix</i></td></tr>
  # 
  # <tr><td>&nbsp;</td></tr>
  # 
  # <tr><td valign=top align=right>
  # <a name="Float-regex"><i>Float</i>&nbsp;&nbsp;::</td>
  # <td valign=top><tt>= </tt><i>Decimal</i><tt></td></tr>
  # <tr><td></td>
  # <td><tt>| </tt><i>HexFloat</i><tt></td></tr>
  # <tr><td></td>
  # <td><tt>| </tt><i>SignedNonNumber</i><tt></td></tr>
  # 
  # </table>
  # </center>
  # 
  # <p> Whitespace is not significant in the above regular expressions.
  # 
  # @since   1.5
  class Scanner 
    include_class_members ScannerImports
    include Iterator
    
    # Internal buffer used to hold input
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    class_module.module_eval {
      # Size of internal character buffer
      const_set_lazy(:BUFFER_SIZE) { 1024 }
      const_attr_reader  :BUFFER_SIZE
    }
    
    # change to 1024;
    # The index into the buffer currently held by the Scanner
    attr_accessor :position
    alias_method :attr_position, :position
    undef_method :position
    alias_method :attr_position=, :position=
    undef_method :position=
    
    # Internal matcher used for finding delimiters
    attr_accessor :matcher
    alias_method :attr_matcher, :matcher
    undef_method :matcher
    alias_method :attr_matcher=, :matcher=
    undef_method :matcher=
    
    # Pattern used to delimit tokens
    attr_accessor :delim_pattern
    alias_method :attr_delim_pattern, :delim_pattern
    undef_method :delim_pattern
    alias_method :attr_delim_pattern=, :delim_pattern=
    undef_method :delim_pattern=
    
    # Pattern found in last hasNext operation
    attr_accessor :has_next_pattern
    alias_method :attr_has_next_pattern, :has_next_pattern
    undef_method :has_next_pattern
    alias_method :attr_has_next_pattern=, :has_next_pattern=
    undef_method :has_next_pattern=
    
    # Position after last hasNext operation
    attr_accessor :has_next_position
    alias_method :attr_has_next_position, :has_next_position
    undef_method :has_next_position
    alias_method :attr_has_next_position=, :has_next_position=
    undef_method :has_next_position=
    
    # Result after last hasNext operation
    attr_accessor :has_next_result
    alias_method :attr_has_next_result, :has_next_result
    undef_method :has_next_result
    alias_method :attr_has_next_result=, :has_next_result=
    undef_method :has_next_result=
    
    # The input source
    attr_accessor :source
    alias_method :attr_source, :source
    undef_method :source
    alias_method :attr_source=, :source=
    undef_method :source=
    
    # Boolean is true if source is done
    attr_accessor :source_closed
    alias_method :attr_source_closed, :source_closed
    undef_method :source_closed
    alias_method :attr_source_closed=, :source_closed=
    undef_method :source_closed=
    
    # Boolean indicating more input is required
    attr_accessor :need_input
    alias_method :attr_need_input, :need_input
    undef_method :need_input
    alias_method :attr_need_input=, :need_input=
    undef_method :need_input=
    
    # Boolean indicating if a delim has been skipped this operation
    attr_accessor :skipped
    alias_method :attr_skipped, :skipped
    undef_method :skipped
    alias_method :attr_skipped=, :skipped=
    undef_method :skipped=
    
    # A store of a position that the scanner may fall back to
    attr_accessor :saved_scanner_position
    alias_method :attr_saved_scanner_position, :saved_scanner_position
    undef_method :saved_scanner_position
    alias_method :attr_saved_scanner_position=, :saved_scanner_position=
    undef_method :saved_scanner_position=
    
    # A cache of the last primitive type scanned
    attr_accessor :type_cache
    alias_method :attr_type_cache, :type_cache
    undef_method :type_cache
    alias_method :attr_type_cache=, :type_cache=
    undef_method :type_cache=
    
    # Boolean indicating if a match result is available
    attr_accessor :match_valid
    alias_method :attr_match_valid, :match_valid
    undef_method :match_valid
    alias_method :attr_match_valid=, :match_valid=
    undef_method :match_valid=
    
    # Boolean indicating if this scanner has been closed
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    # The current radix used by this scanner
    attr_accessor :radix
    alias_method :attr_radix, :radix
    undef_method :radix
    alias_method :attr_radix=, :radix=
    undef_method :radix=
    
    # The default radix for this scanner
    attr_accessor :default_radix
    alias_method :attr_default_radix, :default_radix
    undef_method :default_radix
    alias_method :attr_default_radix=, :default_radix=
    undef_method :default_radix=
    
    # The locale used by this scanner
    attr_accessor :locale
    alias_method :attr_locale, :locale
    undef_method :locale
    alias_method :attr_locale=, :locale=
    undef_method :locale=
    
    # A cache of the last few recently used Patterns
    attr_accessor :pattern_cache
    alias_method :attr_pattern_cache, :pattern_cache
    undef_method :pattern_cache
    alias_method :attr_pattern_cache=, :pattern_cache=
    undef_method :pattern_cache=
    
    # A holder of the last IOException encountered
    attr_accessor :last_exception
    alias_method :attr_last_exception, :last_exception
    undef_method :last_exception
    alias_method :attr_last_exception=, :last_exception=
    undef_method :last_exception=
    
    class_module.module_eval {
      # A pattern for java whitespace
      
      def whitespace_pattern
        defined?(@@whitespace_pattern) ? @@whitespace_pattern : @@whitespace_pattern= Pattern.compile("\\p{javaWhitespace}+")
      end
      alias_method :attr_whitespace_pattern, :whitespace_pattern
      
      def whitespace_pattern=(value)
        @@whitespace_pattern = value
      end
      alias_method :attr_whitespace_pattern=, :whitespace_pattern=
      
      # A pattern for any token
      
      def find_any_pattern
        defined?(@@find_any_pattern) ? @@find_any_pattern : @@find_any_pattern= Pattern.compile("(?s).*")
      end
      alias_method :attr_find_any_pattern, :find_any_pattern
      
      def find_any_pattern=(value)
        @@find_any_pattern = value
      end
      alias_method :attr_find_any_pattern=, :find_any_pattern=
      
      # A pattern for non-ASCII digits
      
      def non_ascii_digit
        defined?(@@non_ascii_digit) ? @@non_ascii_digit : @@non_ascii_digit= Pattern.compile("[\\p{javaDigit}&&[^0-9]]")
      end
      alias_method :attr_non_ascii_digit, :non_ascii_digit
      
      def non_ascii_digit=(value)
        @@non_ascii_digit = value
      end
      alias_method :attr_non_ascii_digit=, :non_ascii_digit=
    }
    
    # Fields and methods to support scanning primitive types
    # 
    # Locale dependent values used to scan numbers
    attr_accessor :group_separator
    alias_method :attr_group_separator, :group_separator
    undef_method :group_separator
    alias_method :attr_group_separator=, :group_separator=
    undef_method :group_separator=
    
    attr_accessor :decimal_separator
    alias_method :attr_decimal_separator, :decimal_separator
    undef_method :decimal_separator
    alias_method :attr_decimal_separator=, :decimal_separator=
    undef_method :decimal_separator=
    
    attr_accessor :nan_string
    alias_method :attr_nan_string, :nan_string
    undef_method :nan_string
    alias_method :attr_nan_string=, :nan_string=
    undef_method :nan_string=
    
    attr_accessor :infinity_string
    alias_method :attr_infinity_string, :infinity_string
    undef_method :infinity_string
    alias_method :attr_infinity_string=, :infinity_string=
    undef_method :infinity_string=
    
    attr_accessor :positive_prefix
    alias_method :attr_positive_prefix, :positive_prefix
    undef_method :positive_prefix
    alias_method :attr_positive_prefix=, :positive_prefix=
    undef_method :positive_prefix=
    
    attr_accessor :negative_prefix
    alias_method :attr_negative_prefix, :negative_prefix
    undef_method :negative_prefix
    alias_method :attr_negative_prefix=, :negative_prefix=
    undef_method :negative_prefix=
    
    attr_accessor :positive_suffix
    alias_method :attr_positive_suffix, :positive_suffix
    undef_method :positive_suffix
    alias_method :attr_positive_suffix=, :positive_suffix=
    undef_method :positive_suffix=
    
    attr_accessor :negative_suffix
    alias_method :attr_negative_suffix, :negative_suffix
    undef_method :negative_suffix
    alias_method :attr_negative_suffix=, :negative_suffix=
    undef_method :negative_suffix=
    
    class_module.module_eval {
      # Fields and an accessor method to match booleans
      
      def bool_pattern
        defined?(@@bool_pattern) ? @@bool_pattern : @@bool_pattern= nil
      end
      alias_method :attr_bool_pattern, :bool_pattern
      
      def bool_pattern=(value)
        @@bool_pattern = value
      end
      alias_method :attr_bool_pattern=, :bool_pattern=
      
      const_set_lazy(:BOOLEAN_PATTERN) { "true|false" }
      const_attr_reader  :BOOLEAN_PATTERN
      
      typesig { [] }
      def bool_pattern
        bp = self.attr_bool_pattern
        if ((bp).nil?)
          self.attr_bool_pattern = bp = Pattern.compile(BOOLEAN_PATTERN, Pattern::CASE_INSENSITIVE)
        end
        return bp
      end
    }
    
    # Fields and methods to match bytes, shorts, ints, and longs
    attr_accessor :integer_pattern
    alias_method :attr_integer_pattern, :integer_pattern
    undef_method :integer_pattern
    alias_method :attr_integer_pattern=, :integer_pattern=
    undef_method :integer_pattern=
    
    attr_accessor :digits
    alias_method :attr_digits, :digits
    undef_method :digits
    alias_method :attr_digits=, :digits=
    undef_method :digits=
    
    attr_accessor :non0digit
    alias_method :attr_non0digit, :non0digit
    undef_method :non0digit
    alias_method :attr_non0digit=, :non0digit=
    undef_method :non0digit=
    
    attr_accessor :simple_group_index
    alias_method :attr_simple_group_index, :simple_group_index
    undef_method :simple_group_index
    alias_method :attr_simple_group_index=, :simple_group_index=
    undef_method :simple_group_index=
    
    typesig { [] }
    def build_integer_pattern_string
      radix_digits = @digits.substring(0, @radix)
      # \\p{javaDigit} is not guaranteed to be appropriate
      # here but what can we do? The final authority will be
      # whatever parse method is invoked, so ultimately the
      # Scanner will do the right thing
      digit = "((?i)[" + radix_digits + "]|\\p{javaDigit})"
      grouped_numeral = "(" + @non0digit + digit + "?" + digit + "?(" + @group_separator + digit + digit + digit + ")+)"
      # digit++ is the possessive form which is necessary for reducing
      # backtracking that would otherwise cause unacceptable performance
      numeral = "((" + digit + "++)|" + grouped_numeral + ")"
      java_style_integer = "([-+]?(" + numeral + "))"
      negative_integer = @negative_prefix + numeral + @negative_suffix
      positive_integer = @positive_prefix + numeral + @positive_suffix
      return "(" + java_style_integer + ")|(" + positive_integer + ")|(" + negative_integer + ")"
    end
    
    typesig { [] }
    def integer_pattern
      if ((@integer_pattern).nil?)
        @integer_pattern = @pattern_cache.for_name(build_integer_pattern_string)
      end
      return @integer_pattern
    end
    
    class_module.module_eval {
      # Fields and an accessor method to match line separators
      
      def separator_pattern
        defined?(@@separator_pattern) ? @@separator_pattern : @@separator_pattern= nil
      end
      alias_method :attr_separator_pattern, :separator_pattern
      
      def separator_pattern=(value)
        @@separator_pattern = value
      end
      alias_method :attr_separator_pattern=, :separator_pattern=
      
      
      def line_pattern
        defined?(@@line_pattern) ? @@line_pattern : @@line_pattern= nil
      end
      alias_method :attr_line_pattern, :line_pattern
      
      def line_pattern=(value)
        @@line_pattern = value
      end
      alias_method :attr_line_pattern=, :line_pattern=
      
      const_set_lazy(:LINE_SEPARATOR_PATTERN) { ("\r\n|[\n\r".to_u << 0x2028 << "".to_u << 0x2029 << "".to_u << 0x0085 << "]") }
      const_attr_reader  :LINE_SEPARATOR_PATTERN
      
      const_set_lazy(:LINE_PATTERN) { ".*(" + LINE_SEPARATOR_PATTERN + ")|.+$" }
      const_attr_reader  :LINE_PATTERN
      
      typesig { [] }
      def separator_pattern
        sp = self.attr_separator_pattern
        if ((sp).nil?)
          self.attr_separator_pattern = sp = Pattern.compile(LINE_SEPARATOR_PATTERN)
        end
        return sp
      end
      
      typesig { [] }
      def line_pattern
        lp = self.attr_line_pattern
        if ((lp).nil?)
          self.attr_line_pattern = lp = Pattern.compile(LINE_PATTERN)
        end
        return lp
      end
    }
    
    # Fields and methods to match floats and doubles
    attr_accessor :float_pattern
    alias_method :attr_float_pattern, :float_pattern
    undef_method :float_pattern
    alias_method :attr_float_pattern=, :float_pattern=
    undef_method :float_pattern=
    
    attr_accessor :decimal_pattern
    alias_method :attr_decimal_pattern, :decimal_pattern
    undef_method :decimal_pattern
    alias_method :attr_decimal_pattern=, :decimal_pattern=
    undef_method :decimal_pattern=
    
    typesig { [] }
    def build_float_and_decimal_pattern
      # \\p{javaDigit} may not be perfect, see above
      digit = "([0-9]|(\\p{javaDigit}))"
      exponent = "([eE][+-]?" + digit + "+)?"
      grouped_numeral = "(" + @non0digit + digit + "?" + digit + "?(" + @group_separator + digit + digit + digit + ")+)"
      # Once again digit++ is used for performance, as above
      numeral = "((" + digit + "++)|" + grouped_numeral + ")"
      decimal_numeral = "(" + numeral + "|" + numeral + @decimal_separator + digit + "*+|" + @decimal_separator + digit + "++)"
      non_number = "(NaN|" + @nan_string + "|Infinity|" + @infinity_string + ")"
      positive_float = "(" + @positive_prefix + decimal_numeral + @positive_suffix + exponent + ")"
      negative_float = "(" + @negative_prefix + decimal_numeral + @negative_suffix + exponent + ")"
      decimal = "(([-+]?" + decimal_numeral + exponent + ")|" + positive_float + "|" + negative_float + ")"
      hex_float = "[-+]?0[xX][0-9a-fA-F]*\\.[0-9a-fA-F]+([pP][-+]?[0-9]+)?"
      positive_non_number = "(" + @positive_prefix + non_number + @positive_suffix + ")"
      negative_non_number = "(" + @negative_prefix + non_number + @negative_suffix + ")"
      signed_non_number = "(([-+]?" + non_number + ")|" + positive_non_number + "|" + negative_non_number + ")"
      @float_pattern = Pattern.compile(decimal + "|" + hex_float + "|" + signed_non_number)
      @decimal_pattern = Pattern.compile(decimal)
    end
    
    typesig { [] }
    def float_pattern
      if ((@float_pattern).nil?)
        build_float_and_decimal_pattern
      end
      return @float_pattern
    end
    
    typesig { [] }
    def decimal_pattern
      if ((@decimal_pattern).nil?)
        build_float_and_decimal_pattern
      end
      return @decimal_pattern
    end
    
    typesig { [Readable, Pattern] }
    # Constructors
    # 
    # Constructs a <code>Scanner</code> that returns values scanned
    # from the specified source delimited by the specified pattern.
    # 
    # @param  source A character source implementing the Readable interface
    # @param pattern A delimiting pattern
    # @return A scanner with the specified source and pattern
    def initialize(source, pattern)
      @buf = nil
      @position = 0
      @matcher = nil
      @delim_pattern = nil
      @has_next_pattern = nil
      @has_next_position = 0
      @has_next_result = nil
      @source = nil
      @source_closed = false
      @need_input = false
      @skipped = false
      @saved_scanner_position = -1
      @type_cache = nil
      @match_valid = false
      @closed = false
      @radix = 10
      @default_radix = 10
      @locale = nil
      @pattern_cache = Class.new(LRUCache.class == Class ? LRUCache : Object) do
        extend LocalClass
        include_class_members Scanner
        include LRUCache if LRUCache.class == Module
        
        typesig { [String] }
        define_method :create do |s|
          return Pattern.compile(s)
        end
        
        typesig { [Pattern, String] }
        define_method :has_name do |p, s|
          return (p.pattern == s)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self, 7)
      @last_exception = nil
      @group_separator = "\\,"
      @decimal_separator = "\\."
      @nan_string = "NaN"
      @infinity_string = "Infinity"
      @positive_prefix = ""
      @negative_prefix = "\\-"
      @positive_suffix = ""
      @negative_suffix = ""
      @integer_pattern = nil
      @digits = "0123456789abcdefghijklmnopqrstuvwxyz"
      @non0digit = "[\\p{javaDigit}&&[^0]]"
      @simple_group_index = 5
      @float_pattern = nil
      @decimal_pattern = nil
      if ((source).nil?)
        raise NullPointerException.new("source")
      end
      if ((pattern).nil?)
        raise NullPointerException.new("pattern")
      end
      @source = source
      @delim_pattern = pattern
      @buf = CharBuffer.allocate(BUFFER_SIZE)
      @buf.limit(0)
      @matcher = @delim_pattern.matcher(@buf)
      @matcher.use_transparent_bounds(true)
      @matcher.use_anchoring_bounds(false)
      use_locale(Locale.get_default)
    end
    
    typesig { [Readable] }
    # Constructs a new <code>Scanner</code> that produces values scanned
    # from the specified source.
    # 
    # @param  source A character source implementing the {@link Readable}
    # interface
    def initialize(source)
      initialize__scanner(source, self.attr_whitespace_pattern)
    end
    
    typesig { [InputStream] }
    # Constructs a new <code>Scanner</code> that produces values scanned
    # from the specified input stream. Bytes from the stream are converted
    # into characters using the underlying platform's
    # {@linkplain java.nio.charset.Charset#defaultCharset() default charset}.
    # 
    # @param  source An input stream to be scanned
    def initialize(source)
      initialize__scanner(InputStreamReader.new(source), self.attr_whitespace_pattern)
    end
    
    typesig { [InputStream, String] }
    # Constructs a new <code>Scanner</code> that produces values scanned
    # from the specified input stream. Bytes from the stream are converted
    # into characters using the specified charset.
    # 
    # @param  source An input stream to be scanned
    # @param charsetName The encoding type used to convert bytes from the
    # stream into characters to be scanned
    # @throws IllegalArgumentException if the specified character set
    # does not exist
    def initialize(source, charset_name)
      initialize__scanner(make_readable(source, charset_name), self.attr_whitespace_pattern)
    end
    
    class_module.module_eval {
      typesig { [InputStream, String] }
      def make_readable(source, charset_name)
        if ((source).nil?)
          raise NullPointerException.new("source")
        end
        isr = nil
        begin
          isr = InputStreamReader.new(source, charset_name)
        rescue UnsupportedEncodingException => uee
          iae = IllegalArgumentException.new
          iae.init_cause(uee)
          raise iae
        end
        return isr
      end
    }
    
    typesig { [JavaFile] }
    # Constructs a new <code>Scanner</code> that produces values scanned
    # from the specified file. Bytes from the file are converted into
    # characters using the underlying platform's
    # {@linkplain java.nio.charset.Charset#defaultCharset() default charset}.
    # 
    # @param  source A file to be scanned
    # @throws FileNotFoundException if source is not found
    def initialize(source)
      initialize__scanner((FileInputStream.new(source).get_channel))
    end
    
    typesig { [JavaFile, String] }
    # Constructs a new <code>Scanner</code> that produces values scanned
    # from the specified file. Bytes from the file are converted into
    # characters using the specified charset.
    # 
    # @param  source A file to be scanned
    # @param charsetName The encoding type used to convert bytes from the file
    # into characters to be scanned
    # @throws FileNotFoundException if source is not found
    # @throws IllegalArgumentException if the specified encoding is
    # not found
    def initialize(source, charset_name)
      initialize__scanner((FileInputStream.new(source).get_channel), charset_name)
    end
    
    typesig { [String] }
    # Constructs a new <code>Scanner</code> that produces values scanned
    # from the specified string.
    # 
    # @param  source A string to scan
    def initialize(source)
      initialize__scanner(StringReader.new(source), self.attr_whitespace_pattern)
    end
    
    typesig { [ReadableByteChannel] }
    # Constructs a new <code>Scanner</code> that produces values scanned
    # from the specified channel. Bytes from the source are converted into
    # characters using the underlying platform's
    # {@linkplain java.nio.charset.Charset#defaultCharset() default charset}.
    # 
    # @param  source A channel to scan
    def initialize(source)
      initialize__scanner(make_readable(source), self.attr_whitespace_pattern)
    end
    
    class_module.module_eval {
      typesig { [ReadableByteChannel] }
      def make_readable(source)
        if ((source).nil?)
          raise NullPointerException.new("source")
        end
        default_charset_name = Java::Nio::Charset::Charset.default_charset.name
        return Channels.new_reader(source, Java::Nio::Charset::Charset.default_charset.name)
      end
    }
    
    typesig { [ReadableByteChannel, String] }
    # Constructs a new <code>Scanner</code> that produces values scanned
    # from the specified channel. Bytes from the source are converted into
    # characters using the specified charset.
    # 
    # @param  source A channel to scan
    # @param charsetName The encoding type used to convert bytes from the
    # channel into characters to be scanned
    # @throws IllegalArgumentException if the specified character set
    # does not exist
    def initialize(source, charset_name)
      initialize__scanner(make_readable(source, charset_name), self.attr_whitespace_pattern)
    end
    
    class_module.module_eval {
      typesig { [ReadableByteChannel, String] }
      def make_readable(source, charset_name)
        if ((source).nil?)
          raise NullPointerException.new("source")
        end
        if (!Charset.is_supported(charset_name))
          raise IllegalArgumentException.new(charset_name)
        end
        return Channels.new_reader(source, charset_name)
      end
    }
    
    typesig { [] }
    # Private primitives used to support scanning
    def save_state
      @saved_scanner_position = @position
    end
    
    typesig { [] }
    def revert_state
      @position = @saved_scanner_position
      @saved_scanner_position = -1
      @skipped = false
    end
    
    typesig { [::Java::Boolean] }
    def revert_state(b)
      @position = @saved_scanner_position
      @saved_scanner_position = -1
      @skipped = false
      return b
    end
    
    typesig { [] }
    def cache_result
      @has_next_result = RJava.cast_to_string(@matcher.group)
      @has_next_position = @matcher.end_
      @has_next_pattern = @matcher.pattern
    end
    
    typesig { [String] }
    def cache_result(result)
      @has_next_result = result
      @has_next_position = @matcher.end_
      @has_next_pattern = @matcher.pattern
    end
    
    typesig { [] }
    # Clears both regular cache and type cache
    def clear_caches
      @has_next_pattern = nil
      @type_cache = nil
    end
    
    typesig { [] }
    # Also clears both the regular cache and the type cache
    def get_cached_result
      @position = @has_next_position
      @has_next_pattern = nil
      @type_cache = nil
      return @has_next_result
    end
    
    typesig { [] }
    # Also clears both the regular cache and the type cache
    def use_type_cache
      if (@closed)
        raise IllegalStateException.new("Scanner closed")
      end
      @position = @has_next_position
      @has_next_pattern = nil
      @type_cache = nil
    end
    
    typesig { [] }
    # Tries to read more input. May block.
    def read_input
      if ((@buf.limit).equal?(@buf.capacity))
        make_space
      end
      # Prepare to receive data
      p = @buf.position
      @buf.position(@buf.limit)
      @buf.limit(@buf.capacity)
      n = 0
      begin
        n = @source.read(@buf)
      rescue IOException => ioe
        @last_exception = ioe
        n = -1
      end
      if ((n).equal?(-1))
        @source_closed = true
        @need_input = false
      end
      if (n > 0)
        @need_input = false
      end
      # Restore current position and limit for reading
      @buf.limit(@buf.position)
      @buf.position(p)
    end
    
    typesig { [] }
    # After this method is called there will either be an exception
    # or else there will be space in the buffer
    def make_space
      clear_caches
      offset = (@saved_scanner_position).equal?(-1) ? @position : @saved_scanner_position
      @buf.position(offset)
      # Gain space by compacting buffer
      if (offset > 0)
        @buf.compact
        translate_saved_indexes(offset)
        @position -= offset
        @buf.flip
        return true
      end
      # Gain space by growing buffer
      new_size = @buf.capacity * 2
      new_buf = CharBuffer.allocate(new_size)
      new_buf.put(@buf)
      new_buf.flip
      translate_saved_indexes(offset)
      @position -= offset
      @buf = new_buf
      @matcher.reset(@buf)
      return true
    end
    
    typesig { [::Java::Int] }
    # When a buffer compaction/reallocation occurs the saved indexes must
    # be modified appropriately
    def translate_saved_indexes(offset)
      if (!(@saved_scanner_position).equal?(-1))
        @saved_scanner_position -= offset
      end
    end
    
    typesig { [] }
    # If we are at the end of input then NoSuchElement;
    # If there is still input left then InputMismatch
    def throw_for
      @skipped = false
      if ((@source_closed) && ((@position).equal?(@buf.limit)))
        raise NoSuchElementException.new
      else
        raise InputMismatchException.new
      end
    end
    
    typesig { [] }
    # Returns true if a complete token or partial token is in the buffer.
    # It is not necessary to find a complete token since a partial token
    # means that there will be another token with or without more input.
    def has_token_in_buffer
      @match_valid = false
      @matcher.use_pattern(@delim_pattern)
      @matcher.region(@position, @buf.limit)
      # Skip delims first
      if (@matcher.looking_at)
        @position = @matcher.end_
      end
      # If we are sitting at the end, no more tokens in buffer
      if ((@position).equal?(@buf.limit))
        return false
      end
      return true
    end
    
    typesig { [Pattern] }
    # Returns a "complete token" that matches the specified pattern
    # 
    # A token is complete if surrounded by delims; a partial token
    # is prefixed by delims but not postfixed by them
    # 
    # The position is advanced to the end of that complete token
    # 
    # Pattern == null means accept any token at all
    # 
    # Triple return:
    # 1. valid string means it was found
    # 2. null with needInput=false means we won't ever find it
    # 3. null with needInput=true means try again after readInput
    def get_complete_token_in_buffer(pattern_)
      @match_valid = false
      # Skip delims first
      @matcher.use_pattern(@delim_pattern)
      if (!@skipped)
        # Enforcing only one skip of leading delims
        @matcher.region(@position, @buf.limit)
        if (@matcher.looking_at)
          # If more input could extend the delimiters then we must wait
          # for more input
          if (@matcher.hit_end && !@source_closed)
            @need_input = true
            return nil
          end
          # The delims were whole and the matcher should skip them
          @skipped = true
          @position = @matcher.end_
        end
      end
      # If we are sitting at the end, no more tokens in buffer
      if ((@position).equal?(@buf.limit))
        if (@source_closed)
          return nil
        end
        @need_input = true
        return nil
      end
      # Must look for next delims. Simply attempting to match the
      # pattern at this point may find a match but it might not be
      # the first longest match because of missing input, or it might
      # match a partial token instead of the whole thing.
      # Then look for next delims
      @matcher.region(@position, @buf.limit)
      found_next_delim = @matcher.find
      if (found_next_delim && ((@matcher.end_).equal?(@position)))
        # Zero length delimiter match; we should find the next one
        # using the automatic advance past a zero length match;
        # Otherwise we have just found the same one we just skipped
        found_next_delim = @matcher.find
      end
      if (found_next_delim)
        # In the rare case that more input could cause the match
        # to be lost and there is more input coming we must wait
        # for more input. Note that hitting the end is okay as long
        # as the match cannot go away. It is the beginning of the
        # next delims we want to be sure about, we don't care if
        # they potentially extend further.
        if (@matcher.require_end && !@source_closed)
          @need_input = true
          return nil
        end
        token_end = @matcher.start
        # There is a complete token.
        if ((pattern_).nil?)
          # Must continue with match to provide valid MatchResult
          pattern_ = self.attr_find_any_pattern
        end
        # Attempt to match against the desired pattern
        @matcher.use_pattern(pattern_)
        @matcher.region(@position, token_end)
        if (@matcher.matches)
          s = @matcher.group
          @position = @matcher.end_
          return s
        else
          # Complete token but it does not match
          return nil
        end
      end
      # If we can't find the next delims but no more input is coming,
      # then we can treat the remainder as a whole token
      if (@source_closed)
        if ((pattern_).nil?)
          # Must continue with match to provide valid MatchResult
          pattern_ = self.attr_find_any_pattern
        end
        # Last token; Match the pattern here or throw
        @matcher.use_pattern(pattern_)
        @matcher.region(@position, @buf.limit)
        if (@matcher.matches)
          s = @matcher.group
          @position = @matcher.end_
          return s
        end
        # Last piece does not match
        return nil
      end
      # There is a partial token in the buffer; must read more
      # to complete it
      @need_input = true
      return nil
    end
    
    typesig { [Pattern, ::Java::Int] }
    # Finds the specified pattern in the buffer up to horizon.
    # Returns a match for the specified input pattern.
    def find_pattern_in_buffer(pattern_, horizon)
      @match_valid = false
      @matcher.use_pattern(pattern_)
      buffer_limit = @buf.limit
      horizon_limit = -1
      search_limit = buffer_limit
      if (horizon > 0)
        horizon_limit = @position + horizon
        if (horizon_limit < buffer_limit)
          search_limit = horizon_limit
        end
      end
      @matcher.region(@position, search_limit)
      if (@matcher.find)
        if (@matcher.hit_end && (!@source_closed))
          # The match may be longer if didn't hit horizon or real end
          if (!(search_limit).equal?(horizon_limit))
            # Hit an artificial end; try to extend the match
            @need_input = true
            return nil
          end
          # The match could go away depending on what is next
          if (((search_limit).equal?(horizon_limit)) && @matcher.require_end)
            # Rare case: we hit the end of input and it happens
            # that it is at the horizon and the end of input is
            # required for the match.
            @need_input = true
            return nil
          end
        end
        # Did not hit end, or hit real end, or hit horizon
        @position = @matcher.end_
        return @matcher.group
      end
      if (@source_closed)
        return nil
      end
      # If there is no specified horizon, or if we have not searched
      # to the specified horizon yet, get more input
      if (((horizon).equal?(0)) || (!(search_limit).equal?(horizon_limit)))
        @need_input = true
      end
      return nil
    end
    
    typesig { [Pattern] }
    # Returns a match for the specified input pattern anchored at
    # the current position
    def match_pattern_in_buffer(pattern_)
      @match_valid = false
      @matcher.use_pattern(pattern_)
      @matcher.region(@position, @buf.limit)
      if (@matcher.looking_at)
        if (@matcher.hit_end && (!@source_closed))
          # Get more input and try again
          @need_input = true
          return nil
        end
        @position = @matcher.end_
        return @matcher.group
      end
      if (@source_closed)
        return nil
      end
      # Read more to find pattern
      @need_input = true
      return nil
    end
    
    typesig { [] }
    # Throws if the scanner is closed
    def ensure_open
      if (@closed)
        raise IllegalStateException.new("Scanner closed")
      end
    end
    
    typesig { [] }
    # Public methods
    # 
    # Closes this scanner.
    # 
    # <p> If this scanner has not yet been closed then if its underlying
    # {@linkplain java.lang.Readable readable} also implements the {@link
    # java.io.Closeable} interface then the readable's <tt>close</tt> method
    # will be invoked.  If this scanner is already closed then invoking this
    # method will have no effect.
    # 
    # <p>Attempting to perform search operations after a scanner has
    # been closed will result in an {@link IllegalStateException}.
    def close
      if (@closed)
        return
      end
      if (@source.is_a?(Closeable))
        begin
          (@source).close
        rescue IOException => ioe
          @last_exception = ioe
        end
      end
      @source_closed = true
      @source = nil
      @closed = true
    end
    
    typesig { [] }
    # Returns the <code>IOException</code> last thrown by this
    # <code>Scanner</code>'s underlying <code>Readable</code>. This method
    # returns <code>null</code> if no such exception exists.
    # 
    # @return the last exception thrown by this scanner's readable
    def io_exception
      return @last_exception
    end
    
    typesig { [] }
    # Returns the <code>Pattern</code> this <code>Scanner</code> is currently
    # using to match delimiters.
    # 
    # @return this scanner's delimiting pattern.
    def delimiter
      return @delim_pattern
    end
    
    typesig { [Pattern] }
    # Sets this scanner's delimiting pattern to the specified pattern.
    # 
    # @param pattern A delimiting pattern
    # @return this scanner
    def use_delimiter(pattern_)
      @delim_pattern = pattern_
      return self
    end
    
    typesig { [String] }
    # Sets this scanner's delimiting pattern to a pattern constructed from
    # the specified <code>String</code>.
    # 
    # <p> An invocation of this method of the form
    # <tt>useDelimiter(pattern)</tt> behaves in exactly the same way as the
    # invocation <tt>useDelimiter(Pattern.compile(pattern))</tt>.
    # 
    # <p> Invoking the {@link #reset} method will set the scanner's delimiter
    # to the <a href= "#default-delimiter">default</a>.
    # 
    # @param pattern A string specifying a delimiting pattern
    # @return this scanner
    def use_delimiter(pattern_)
      @delim_pattern = @pattern_cache.for_name(pattern_)
      return self
    end
    
    typesig { [] }
    # Returns this scanner's locale.
    # 
    # <p>A scanner's locale affects many elements of its default
    # primitive matching regular expressions; see
    # <a href= "#localized-numbers">localized numbers</a> above.
    # 
    # @return this scanner's locale
    def locale
      return @locale
    end
    
    typesig { [Locale] }
    # Sets this scanner's locale to the specified locale.
    # 
    # <p>A scanner's locale affects many elements of its default
    # primitive matching regular expressions; see
    # <a href= "#localized-numbers">localized numbers</a> above.
    # 
    # <p>Invoking the {@link #reset} method will set the scanner's locale to
    # the <a href= "#initial-locale">initial locale</a>.
    # 
    # @param locale A string specifying the locale to use
    # @return this scanner
    def use_locale(locale)
      if ((locale == @locale))
        return self
      end
      @locale = locale
      df = NumberFormat.get_number_instance(locale)
      dfs = DecimalFormatSymbols.get_instance(locale)
      # These must be literalized to avoid collision with regex
      # metacharacters such as dot or parenthesis
      @group_separator = "\\" + RJava.cast_to_string(dfs.get_grouping_separator)
      @decimal_separator = "\\" + RJava.cast_to_string(dfs.get_decimal_separator)
      # Quoting the nonzero length locale-specific things
      # to avoid potential conflict with metacharacters
      @nan_string = "\\Q" + RJava.cast_to_string(dfs.get_na_n) + "\\E"
      @infinity_string = "\\Q" + RJava.cast_to_string(dfs.get_infinity) + "\\E"
      @positive_prefix = RJava.cast_to_string(df.get_positive_prefix)
      if (@positive_prefix.length > 0)
        @positive_prefix = "\\Q" + @positive_prefix + "\\E"
      end
      @negative_prefix = RJava.cast_to_string(df.get_negative_prefix)
      if (@negative_prefix.length > 0)
        @negative_prefix = "\\Q" + @negative_prefix + "\\E"
      end
      @positive_suffix = RJava.cast_to_string(df.get_positive_suffix)
      if (@positive_suffix.length > 0)
        @positive_suffix = "\\Q" + @positive_suffix + "\\E"
      end
      @negative_suffix = RJava.cast_to_string(df.get_negative_suffix)
      if (@negative_suffix.length > 0)
        @negative_suffix = "\\Q" + @negative_suffix + "\\E"
      end
      # Force rebuilding and recompilation of locale dependent
      # primitive patterns
      @integer_pattern = nil
      @float_pattern = nil
      return self
    end
    
    typesig { [] }
    # Returns this scanner's default radix.
    # 
    # <p>A scanner's radix affects elements of its default
    # number matching regular expressions; see
    # <a href= "#localized-numbers">localized numbers</a> above.
    # 
    # @return the default radix of this scanner
    def radix
      return @default_radix
    end
    
    typesig { [::Java::Int] }
    # Sets this scanner's default radix to the specified radix.
    # 
    # <p>A scanner's radix affects elements of its default
    # number matching regular expressions; see
    # <a href= "#localized-numbers">localized numbers</a> above.
    # 
    # <p>If the radix is less than <code>Character.MIN_RADIX</code>
    # or greater than <code>Character.MAX_RADIX</code>, then an
    # <code>IllegalArgumentException</code> is thrown.
    # 
    # <p>Invoking the {@link #reset} method will set the scanner's radix to
    # <code>10</code>.
    # 
    # @param radix The radix to use when scanning numbers
    # @return this scanner
    # @throws IllegalArgumentException if radix is out of range
    def use_radix(radix)
      if ((radix < Character::MIN_RADIX) || (radix > Character::MAX_RADIX))
        raise IllegalArgumentException.new("radix:" + RJava.cast_to_string(radix))
      end
      if ((@default_radix).equal?(radix))
        return self
      end
      @default_radix = radix
      # Force rebuilding and recompilation of radix dependent patterns
      @integer_pattern = nil
      return self
    end
    
    typesig { [::Java::Int] }
    # The next operation should occur in the specified radix but
    # the default is left untouched.
    def set_radix(radix)
      if (!(@radix).equal?(radix))
        # Force rebuilding and recompilation of radix dependent patterns
        @integer_pattern = nil
        @radix = radix
      end
    end
    
    typesig { [] }
    # Returns the match result of the last scanning operation performed
    # by this scanner. This method throws <code>IllegalStateException</code>
    # if no match has been performed, or if the last match was
    # not successful.
    # 
    # <p>The various <code>next</code>methods of <code>Scanner</code>
    # make a match result available if they complete without throwing an
    # exception. For instance, after an invocation of the {@link #nextInt}
    # method that returned an int, this method returns a
    # <code>MatchResult</code> for the search of the
    # <a href="#Integer-regex"><i>Integer</i></a> regular expression
    # defined above. Similarly the {@link #findInLine},
    # {@link #findWithinHorizon}, and {@link #skip} methods will make a
    # match available if they succeed.
    # 
    # @return a match result for the last match operation
    # @throws IllegalStateException  If no match result is available
    def match
      if (!@match_valid)
        raise IllegalStateException.new("No match result available")
      end
      return @matcher.to_match_result
    end
    
    typesig { [] }
    # <p>Returns the string representation of this <code>Scanner</code>. The
    # string representation of a <code>Scanner</code> contains information
    # that may be useful for debugging. The exact format is unspecified.
    # 
    # @return  The string representation of this scanner
    def to_s
      sb = StringBuilder.new
      sb.append("java.util.Scanner")
      sb.append("[delimiters=" + RJava.cast_to_string(@delim_pattern) + "]")
      sb.append("[position=" + RJava.cast_to_string(@position) + "]")
      sb.append("[match valid=" + RJava.cast_to_string(@match_valid) + "]")
      sb.append("[need input=" + RJava.cast_to_string(@need_input) + "]")
      sb.append("[source closed=" + RJava.cast_to_string(@source_closed) + "]")
      sb.append("[skipped=" + RJava.cast_to_string(@skipped) + "]")
      sb.append("[group separator=" + @group_separator + "]")
      sb.append("[decimal separator=" + @decimal_separator + "]")
      sb.append("[positive prefix=" + @positive_prefix + "]")
      sb.append("[negative prefix=" + @negative_prefix + "]")
      sb.append("[positive suffix=" + @positive_suffix + "]")
      sb.append("[negative suffix=" + @negative_suffix + "]")
      sb.append("[NaN string=" + @nan_string + "]")
      sb.append("[infinity string=" + @infinity_string + "]")
      return sb.to_s
    end
    
    typesig { [] }
    # Returns true if this scanner has another token in its input.
    # This method may block while waiting for input to scan.
    # The scanner does not advance past any input.
    # 
    # @return true if and only if this scanner has another token
    # @throws IllegalStateException if this scanner is closed
    # @see java.util.Iterator
    def has_next
      ensure_open
      save_state
      while (!@source_closed)
        if (has_token_in_buffer)
          return revert_state(true)
        end
        read_input
      end
      result = has_token_in_buffer
      return revert_state(result)
    end
    
    typesig { [] }
    # Finds and returns the next complete token from this scanner.
    # A complete token is preceded and followed by input that matches
    # the delimiter pattern. This method may block while waiting for input
    # to scan, even if a previous invocation of {@link #hasNext} returned
    # <code>true</code>.
    # 
    # @return the next token
    # @throws NoSuchElementException if no more tokens are available
    # @throws IllegalStateException if this scanner is closed
    # @see java.util.Iterator
    def next_
      ensure_open
      clear_caches
      while (true)
        token = get_complete_token_in_buffer(nil)
        if (!(token).nil?)
          @match_valid = true
          @skipped = false
          return token
        end
        if (@need_input)
          read_input
        else
          throw_for
        end
      end
    end
    
    typesig { [] }
    # The remove operation is not supported by this implementation of
    # <code>Iterator</code>.
    # 
    # @throws UnsupportedOperationException if this method is invoked.
    # @see java.util.Iterator
    def remove
      raise UnsupportedOperationException.new
    end
    
    typesig { [String] }
    # Returns true if the next token matches the pattern constructed from the
    # specified string. The scanner does not advance past any input.
    # 
    # <p> An invocation of this method of the form <tt>hasNext(pattern)</tt>
    # behaves in exactly the same way as the invocation
    # <tt>hasNext(Pattern.compile(pattern))</tt>.
    # 
    # @param pattern a string specifying the pattern to scan
    # @return true if and only if this scanner has another token matching
    # the specified pattern
    # @throws IllegalStateException if this scanner is closed
    def has_next(pattern_)
      return has_next(@pattern_cache.for_name(pattern_))
    end
    
    typesig { [String] }
    # Returns the next token if it matches the pattern constructed from the
    # specified string.  If the match is successful, the scanner advances
    # past the input that matched the pattern.
    # 
    # <p> An invocation of this method of the form <tt>next(pattern)</tt>
    # behaves in exactly the same way as the invocation
    # <tt>next(Pattern.compile(pattern))</tt>.
    # 
    # @param pattern a string specifying the pattern to scan
    # @return the next token
    # @throws NoSuchElementException if no such tokens are available
    # @throws IllegalStateException if this scanner is closed
    def next_(pattern_)
      return next_(@pattern_cache.for_name(pattern_))
    end
    
    typesig { [Pattern] }
    # Returns true if the next complete token matches the specified pattern.
    # A complete token is prefixed and postfixed by input that matches
    # the delimiter pattern. This method may block while waiting for input.
    # The scanner does not advance past any input.
    # 
    # @param pattern the pattern to scan for
    # @return true if and only if this scanner has another token matching
    # the specified pattern
    # @throws IllegalStateException if this scanner is closed
    def has_next(pattern_)
      ensure_open
      if ((pattern_).nil?)
        raise NullPointerException.new
      end
      @has_next_pattern = nil
      save_state
      while (true)
        if (!(get_complete_token_in_buffer(pattern_)).nil?)
          @match_valid = true
          cache_result
          return revert_state(true)
        end
        if (@need_input)
          read_input
        else
          return revert_state(false)
        end
      end
    end
    
    typesig { [Pattern] }
    # Returns the next token if it matches the specified pattern. This
    # method may block while waiting for input to scan, even if a previous
    # invocation of {@link #hasNext(Pattern)} returned <code>true</code>.
    # If the match is successful, the scanner advances past the input that
    # matched the pattern.
    # 
    # @param pattern the pattern to scan for
    # @return the next token
    # @throws NoSuchElementException if no more tokens are available
    # @throws IllegalStateException if this scanner is closed
    def next_(pattern_)
      ensure_open
      if ((pattern_).nil?)
        raise NullPointerException.new
      end
      # Did we already find this pattern?
      if ((@has_next_pattern).equal?(pattern_))
        return get_cached_result
      end
      clear_caches
      # Search for the pattern
      while (true)
        token = get_complete_token_in_buffer(pattern_)
        if (!(token).nil?)
          @match_valid = true
          @skipped = false
          return token
        end
        if (@need_input)
          read_input
        else
          throw_for
        end
      end
    end
    
    typesig { [] }
    # Returns true if there is another line in the input of this scanner.
    # This method may block while waiting for input. The scanner does not
    # advance past any input.
    # 
    # @return true if and only if this scanner has another line of input
    # @throws IllegalStateException if this scanner is closed
    def has_next_line
      save_state
      result = find_within_horizon(line_pattern, 0)
      if (!(result).nil?)
        mr = self.match
        line_sep = mr.group(1)
        if (!(line_sep).nil?)
          result = RJava.cast_to_string(result.substring(0, result.length - line_sep.length))
          cache_result(result)
        else
          cache_result
        end
      end
      revert_state
      return (!(result).nil?)
    end
    
    typesig { [] }
    # Advances this scanner past the current line and returns the input
    # that was skipped.
    # 
    # This method returns the rest of the current line, excluding any line
    # separator at the end. The position is set to the beginning of the next
    # line.
    # 
    # <p>Since this method continues to search through the input looking
    # for a line separator, it may buffer all of the input searching for
    # the line to skip if no line separators are present.
    # 
    # @return the line that was skipped
    # @throws NoSuchElementException if no line was found
    # @throws IllegalStateException if this scanner is closed
    def next_line
      if ((@has_next_pattern).equal?(line_pattern))
        return get_cached_result
      end
      clear_caches
      result = find_within_horizon(self.attr_line_pattern, 0)
      if ((result).nil?)
        raise NoSuchElementException.new("No line found")
      end
      mr = self.match
      line_sep = mr.group(1)
      if (!(line_sep).nil?)
        result = RJava.cast_to_string(result.substring(0, result.length - line_sep.length))
      end
      if ((result).nil?)
        raise NoSuchElementException.new
      else
        return result
      end
    end
    
    typesig { [String] }
    # Public methods that ignore delimiters
    # 
    # Attempts to find the next occurrence of a pattern constructed from the
    # specified string, ignoring delimiters.
    # 
    # <p>An invocation of this method of the form <tt>findInLine(pattern)</tt>
    # behaves in exactly the same way as the invocation
    # <tt>findInLine(Pattern.compile(pattern))</tt>.
    # 
    # @param pattern a string specifying the pattern to search for
    # @return the text that matched the specified pattern
    # @throws IllegalStateException if this scanner is closed
    def find_in_line(pattern_)
      return find_in_line(@pattern_cache.for_name(pattern_))
    end
    
    typesig { [Pattern] }
    # Attempts to find the next occurrence of the specified pattern ignoring
    # delimiters. If the pattern is found before the next line separator, the
    # scanner advances past the input that matched and returns the string that
    # matched the pattern.
    # If no such pattern is detected in the input up to the next line
    # separator, then <code>null</code> is returned and the scanner's
    # position is unchanged. This method may block waiting for input that
    # matches the pattern.
    # 
    # <p>Since this method continues to search through the input looking
    # for the specified pattern, it may buffer all of the input searching for
    # the desired token if no line separators are present.
    # 
    # @param pattern the pattern to scan for
    # @return the text that matched the specified pattern
    # @throws IllegalStateException if this scanner is closed
    def find_in_line(pattern_)
      ensure_open
      if ((pattern_).nil?)
        raise NullPointerException.new
      end
      clear_caches
      # Expand buffer to include the next newline or end of input
      end_position = 0
      save_state
      while (true)
        token = find_pattern_in_buffer(separator_pattern, 0)
        if (!(token).nil?)
          end_position = @matcher.start
          break # up to next newline
        end
        if (@need_input)
          read_input
        else
          end_position = @buf.limit
          break # up to end of input
        end
      end
      revert_state
      horizon_for_line = end_position - @position
      # If there is nothing between the current pos and the next
      # newline simply return null, invoking findWithinHorizon
      # with "horizon=0" will scan beyond the line bound.
      if ((horizon_for_line).equal?(0))
        return nil
      end
      # Search for the pattern
      return find_within_horizon(pattern_, horizon_for_line)
    end
    
    typesig { [String, ::Java::Int] }
    # Attempts to find the next occurrence of a pattern constructed from the
    # specified string, ignoring delimiters.
    # 
    # <p>An invocation of this method of the form
    # <tt>findWithinHorizon(pattern)</tt> behaves in exactly the same way as
    # the invocation
    # <tt>findWithinHorizon(Pattern.compile(pattern, horizon))</tt>.
    # 
    # @param pattern a string specifying the pattern to search for
    # @return the text that matched the specified pattern
    # @throws IllegalStateException if this scanner is closed
    # @throws IllegalArgumentException if horizon is negative
    def find_within_horizon(pattern_, horizon)
      return find_within_horizon(@pattern_cache.for_name(pattern_), horizon)
    end
    
    typesig { [Pattern, ::Java::Int] }
    # Attempts to find the next occurrence of the specified pattern.
    # 
    # <p>This method searches through the input up to the specified
    # search horizon, ignoring delimiters. If the pattern is found the
    # scanner advances past the input that matched and returns the string
    # that matched the pattern. If no such pattern is detected then the
    # null is returned and the scanner's position remains unchanged. This
    # method may block waiting for input that matches the pattern.
    # 
    # <p>A scanner will never search more than <code>horizon</code> code
    # points beyond its current position. Note that a match may be clipped
    # by the horizon; that is, an arbitrary match result may have been
    # different if the horizon had been larger. The scanner treats the
    # horizon as a transparent, non-anchoring bound (see {@link
    # Matcher#useTransparentBounds} and {@link Matcher#useAnchoringBounds}).
    # 
    # <p>If horizon is <code>0</code>, then the horizon is ignored and
    # this method continues to search through the input looking for the
    # specified pattern without bound. In this case it may buffer all of
    # the input searching for the pattern.
    # 
    # <p>If horizon is negative, then an IllegalArgumentException is
    # thrown.
    # 
    # @param pattern the pattern to scan for
    # @return the text that matched the specified pattern
    # @throws IllegalStateException if this scanner is closed
    # @throws IllegalArgumentException if horizon is negative
    def find_within_horizon(pattern_, horizon)
      ensure_open
      if ((pattern_).nil?)
        raise NullPointerException.new
      end
      if (horizon < 0)
        raise IllegalArgumentException.new("horizon < 0")
      end
      clear_caches
      # Search for the pattern
      while (true)
        token = find_pattern_in_buffer(pattern_, horizon)
        if (!(token).nil?)
          @match_valid = true
          return token
        end
        if (@need_input)
          read_input
        else
          break
        end # up to end of input
      end
      return nil
    end
    
    typesig { [Pattern] }
    # Skips input that matches the specified pattern, ignoring delimiters.
    # This method will skip input if an anchored match of the specified
    # pattern succeeds.
    # 
    # <p>If a match to the specified pattern is not found at the
    # current position, then no input is skipped and a
    # <tt>NoSuchElementException</tt> is thrown.
    # 
    # <p>Since this method seeks to match the specified pattern starting at
    # the scanner's current position, patterns that can match a lot of
    # input (".*", for example) may cause the scanner to buffer a large
    # amount of input.
    # 
    # <p>Note that it is possible to skip something without risking a
    # <code>NoSuchElementException</code> by using a pattern that can
    # match nothing, e.g., <code>sc.skip("[ \t]*")</code>.
    # 
    # @param pattern a string specifying the pattern to skip over
    # @return this scanner
    # @throws NoSuchElementException if the specified pattern is not found
    # @throws IllegalStateException if this scanner is closed
    def skip(pattern_)
      ensure_open
      if ((pattern_).nil?)
        raise NullPointerException.new
      end
      clear_caches
      # Search for the pattern
      while (true)
        token = match_pattern_in_buffer(pattern_)
        if (!(token).nil?)
          @match_valid = true
          @position = @matcher.end_
          return self
        end
        if (@need_input)
          read_input
        else
          raise NoSuchElementException.new
        end
      end
    end
    
    typesig { [String] }
    # Skips input that matches a pattern constructed from the specified
    # string.
    # 
    # <p> An invocation of this method of the form <tt>skip(pattern)</tt>
    # behaves in exactly the same way as the invocation
    # <tt>skip(Pattern.compile(pattern))</tt>.
    # 
    # @param pattern a string specifying the pattern to skip over
    # @return this scanner
    # @throws IllegalStateException if this scanner is closed
    def skip(pattern_)
      return skip(@pattern_cache.for_name(pattern_))
    end
    
    typesig { [] }
    # Convenience methods for scanning primitives
    # 
    # Returns true if the next token in this scanner's input can be
    # interpreted as a boolean value using a case insensitive pattern
    # created from the string "true|false".  The scanner does not
    # advance past the input that matched.
    # 
    # @return true if and only if this scanner's next token is a valid
    # boolean value
    # @throws IllegalStateException if this scanner is closed
    def has_next_boolean
      return has_next(bool_pattern)
    end
    
    typesig { [] }
    # Scans the next token of the input into a boolean value and returns
    # that value. This method will throw <code>InputMismatchException</code>
    # if the next token cannot be translated into a valid boolean value.
    # If the match is successful, the scanner advances past the input that
    # matched.
    # 
    # @return the boolean scanned from the input
    # @throws InputMismatchException if the next token is not a valid boolean
    # @throws NoSuchElementException if input is exhausted
    # @throws IllegalStateException if this scanner is closed
    def next_boolean
      clear_caches
      return Boolean.parse_boolean(next_(bool_pattern))
    end
    
    typesig { [] }
    # Returns true if the next token in this scanner's input can be
    # interpreted as a byte value in the default radix using the
    # {@link #nextByte} method. The scanner does not advance past any input.
    # 
    # @return true if and only if this scanner's next token is a valid
    # byte value
    # @throws IllegalStateException if this scanner is closed
    def has_next_byte
      return has_next_byte(@default_radix)
    end
    
    typesig { [::Java::Int] }
    # Returns true if the next token in this scanner's input can be
    # interpreted as a byte value in the specified radix using the
    # {@link #nextByte} method. The scanner does not advance past any input.
    # 
    # @param radix the radix used to interpret the token as a byte value
    # @return true if and only if this scanner's next token is a valid
    # byte value
    # @throws IllegalStateException if this scanner is closed
    def has_next_byte(radix)
      set_radix(radix)
      result = has_next(integer_pattern)
      if (result)
        # Cache it
        begin
          s = ((@matcher.group(@simple_group_index)).nil?) ? process_integer_token(@has_next_result) : @has_next_result
          @type_cache = Byte.parse_byte(s, radix)
        rescue NumberFormatException => nfe
          result = false
        end
      end
      return result
    end
    
    typesig { [] }
    # Scans the next token of the input as a <tt>byte</tt>.
    # 
    # <p> An invocation of this method of the form
    # <tt>nextByte()</tt> behaves in exactly the same way as the
    # invocation <tt>nextByte(radix)</tt>, where <code>radix</code>
    # is the default radix of this scanner.
    # 
    # @return the <tt>byte</tt> scanned from the input
    # @throws InputMismatchException
    # if the next token does not match the <i>Integer</i>
    # regular expression, or is out of range
    # @throws NoSuchElementException if input is exhausted
    # @throws IllegalStateException if this scanner is closed
    def next_byte
      return next_byte(@default_radix)
    end
    
    typesig { [::Java::Int] }
    # Scans the next token of the input as a <tt>byte</tt>.
    # This method will throw <code>InputMismatchException</code>
    # if the next token cannot be translated into a valid byte value as
    # described below. If the translation is successful, the scanner advances
    # past the input that matched.
    # 
    # <p> If the next token matches the <a
    # href="#Integer-regex"><i>Integer</i></a> regular expression defined
    # above then the token is converted into a <tt>byte</tt> value as if by
    # removing all locale specific prefixes, group separators, and locale
    # specific suffixes, then mapping non-ASCII digits into ASCII
    # digits via {@link Character#digit Character.digit}, prepending a
    # negative sign (-) if the locale specific negative prefixes and suffixes
    # were present, and passing the resulting string to
    # {@link Byte#parseByte(String, int) Byte.parseByte} with the
    # specified radix.
    # 
    # @param radix the radix used to interpret the token as a byte value
    # @return the <tt>byte</tt> scanned from the input
    # @throws InputMismatchException
    # if the next token does not match the <i>Integer</i>
    # regular expression, or is out of range
    # @throws NoSuchElementException if input is exhausted
    # @throws IllegalStateException if this scanner is closed
    def next_byte(radix)
      # Check cached result
      if ((!(@type_cache).nil?) && (@type_cache.is_a?(Byte)) && (@radix).equal?(radix))
        val = (@type_cache).byte_value
        use_type_cache
        return val
      end
      set_radix(radix)
      clear_caches
      # Search for next byte
      begin
        s = next_(integer_pattern)
        if ((@matcher.group(@simple_group_index)).nil?)
          s = RJava.cast_to_string(process_integer_token(s))
        end
        return Byte.parse_byte(s, radix)
      rescue NumberFormatException => nfe
        @position = @matcher.start # don't skip bad token
        raise InputMismatchException.new(nfe.get_message)
      end
    end
    
    typesig { [] }
    # Returns true if the next token in this scanner's input can be
    # interpreted as a short value in the default radix using the
    # {@link #nextShort} method. The scanner does not advance past any input.
    # 
    # @return true if and only if this scanner's next token is a valid
    # short value in the default radix
    # @throws IllegalStateException if this scanner is closed
    def has_next_short
      return has_next_short(@default_radix)
    end
    
    typesig { [::Java::Int] }
    # Returns true if the next token in this scanner's input can be
    # interpreted as a short value in the specified radix using the
    # {@link #nextShort} method. The scanner does not advance past any input.
    # 
    # @param radix the radix used to interpret the token as a short value
    # @return true if and only if this scanner's next token is a valid
    # short value in the specified radix
    # @throws IllegalStateException if this scanner is closed
    def has_next_short(radix)
      set_radix(radix)
      result = has_next(integer_pattern)
      if (result)
        # Cache it
        begin
          s = ((@matcher.group(@simple_group_index)).nil?) ? process_integer_token(@has_next_result) : @has_next_result
          @type_cache = Short.parse_short(s, radix)
        rescue NumberFormatException => nfe
          result = false
        end
      end
      return result
    end
    
    typesig { [] }
    # Scans the next token of the input as a <tt>short</tt>.
    # 
    # <p> An invocation of this method of the form
    # <tt>nextShort()</tt> behaves in exactly the same way as the
    # invocation <tt>nextShort(radix)</tt>, where <code>radix</code>
    # is the default radix of this scanner.
    # 
    # @return the <tt>short</tt> scanned from the input
    # @throws InputMismatchException
    # if the next token does not match the <i>Integer</i>
    # regular expression, or is out of range
    # @throws NoSuchElementException if input is exhausted
    # @throws IllegalStateException if this scanner is closed
    def next_short
      return next_short(@default_radix)
    end
    
    typesig { [::Java::Int] }
    # Scans the next token of the input as a <tt>short</tt>.
    # This method will throw <code>InputMismatchException</code>
    # if the next token cannot be translated into a valid short value as
    # described below. If the translation is successful, the scanner advances
    # past the input that matched.
    # 
    # <p> If the next token matches the <a
    # href="#Integer-regex"><i>Integer</i></a> regular expression defined
    # above then the token is converted into a <tt>short</tt> value as if by
    # removing all locale specific prefixes, group separators, and locale
    # specific suffixes, then mapping non-ASCII digits into ASCII
    # digits via {@link Character#digit Character.digit}, prepending a
    # negative sign (-) if the locale specific negative prefixes and suffixes
    # were present, and passing the resulting string to
    # {@link Short#parseShort(String, int) Short.parseShort} with the
    # specified radix.
    # 
    # @param radix the radix used to interpret the token as a short value
    # @return the <tt>short</tt> scanned from the input
    # @throws InputMismatchException
    # if the next token does not match the <i>Integer</i>
    # regular expression, or is out of range
    # @throws NoSuchElementException if input is exhausted
    # @throws IllegalStateException if this scanner is closed
    def next_short(radix)
      # Check cached result
      if ((!(@type_cache).nil?) && (@type_cache.is_a?(Short)) && (@radix).equal?(radix))
        val = (@type_cache).short_value
        use_type_cache
        return val
      end
      set_radix(radix)
      clear_caches
      # Search for next short
      begin
        s = next_(integer_pattern)
        if ((@matcher.group(@simple_group_index)).nil?)
          s = RJava.cast_to_string(process_integer_token(s))
        end
        return Short.parse_short(s, radix)
      rescue NumberFormatException => nfe
        @position = @matcher.start # don't skip bad token
        raise InputMismatchException.new(nfe.get_message)
      end
    end
    
    typesig { [] }
    # Returns true if the next token in this scanner's input can be
    # interpreted as an int value in the default radix using the
    # {@link #nextInt} method. The scanner does not advance past any input.
    # 
    # @return true if and only if this scanner's next token is a valid
    # int value
    # @throws IllegalStateException if this scanner is closed
    def has_next_int
      return has_next_int(@default_radix)
    end
    
    typesig { [::Java::Int] }
    # Returns true if the next token in this scanner's input can be
    # interpreted as an int value in the specified radix using the
    # {@link #nextInt} method. The scanner does not advance past any input.
    # 
    # @param radix the radix used to interpret the token as an int value
    # @return true if and only if this scanner's next token is a valid
    # int value
    # @throws IllegalStateException if this scanner is closed
    def has_next_int(radix)
      set_radix(radix)
      result = has_next(integer_pattern)
      if (result)
        # Cache it
        begin
          s = ((@matcher.group(@simple_group_index)).nil?) ? process_integer_token(@has_next_result) : @has_next_result
          @type_cache = JavaInteger.parse_int(s, radix)
        rescue NumberFormatException => nfe
          result = false
        end
      end
      return result
    end
    
    typesig { [String] }
    # The integer token must be stripped of prefixes, group separators,
    # and suffixes, non ascii digits must be converted into ascii digits
    # before parse will accept it.
    def process_integer_token(token)
      result = token.replace_all("" + @group_separator, "")
      is_negative = false
      pre_len = @negative_prefix.length
      if ((pre_len > 0) && result.starts_with(@negative_prefix))
        is_negative = true
        result = RJava.cast_to_string(result.substring(pre_len))
      end
      suf_len = @negative_suffix.length
      if ((suf_len > 0) && result.ends_with(@negative_suffix))
        is_negative = true
        result = RJava.cast_to_string(result.substring(result.length - suf_len, result.length))
      end
      if (is_negative)
        result = "-" + result
      end
      return result
    end
    
    typesig { [] }
    # Scans the next token of the input as an <tt>int</tt>.
    # 
    # <p> An invocation of this method of the form
    # <tt>nextInt()</tt> behaves in exactly the same way as the
    # invocation <tt>nextInt(radix)</tt>, where <code>radix</code>
    # is the default radix of this scanner.
    # 
    # @return the <tt>int</tt> scanned from the input
    # @throws InputMismatchException
    # if the next token does not match the <i>Integer</i>
    # regular expression, or is out of range
    # @throws NoSuchElementException if input is exhausted
    # @throws IllegalStateException if this scanner is closed
    def next_int
      return next_int(@default_radix)
    end
    
    typesig { [::Java::Int] }
    # Scans the next token of the input as an <tt>int</tt>.
    # This method will throw <code>InputMismatchException</code>
    # if the next token cannot be translated into a valid int value as
    # described below. If the translation is successful, the scanner advances
    # past the input that matched.
    # 
    # <p> If the next token matches the <a
    # href="#Integer-regex"><i>Integer</i></a> regular expression defined
    # above then the token is converted into an <tt>int</tt> value as if by
    # removing all locale specific prefixes, group separators, and locale
    # specific suffixes, then mapping non-ASCII digits into ASCII
    # digits via {@link Character#digit Character.digit}, prepending a
    # negative sign (-) if the locale specific negative prefixes and suffixes
    # were present, and passing the resulting string to
    # {@link Integer#parseInt(String, int) Integer.parseInt} with the
    # specified radix.
    # 
    # @param radix the radix used to interpret the token as an int value
    # @return the <tt>int</tt> scanned from the input
    # @throws InputMismatchException
    # if the next token does not match the <i>Integer</i>
    # regular expression, or is out of range
    # @throws NoSuchElementException if input is exhausted
    # @throws IllegalStateException if this scanner is closed
    def next_int(radix)
      # Check cached result
      if ((!(@type_cache).nil?) && (@type_cache.is_a?(JavaInteger)) && (@radix).equal?(radix))
        val = (@type_cache).int_value
        use_type_cache
        return val
      end
      set_radix(radix)
      clear_caches
      # Search for next int
      begin
        s = next_(integer_pattern)
        if ((@matcher.group(@simple_group_index)).nil?)
          s = RJava.cast_to_string(process_integer_token(s))
        end
        return JavaInteger.parse_int(s, radix)
      rescue NumberFormatException => nfe
        @position = @matcher.start # don't skip bad token
        raise InputMismatchException.new(nfe.get_message)
      end
    end
    
    typesig { [] }
    # Returns true if the next token in this scanner's input can be
    # interpreted as a long value in the default radix using the
    # {@link #nextLong} method. The scanner does not advance past any input.
    # 
    # @return true if and only if this scanner's next token is a valid
    # long value
    # @throws IllegalStateException if this scanner is closed
    def has_next_long
      return has_next_long(@default_radix)
    end
    
    typesig { [::Java::Int] }
    # Returns true if the next token in this scanner's input can be
    # interpreted as a long value in the specified radix using the
    # {@link #nextLong} method. The scanner does not advance past any input.
    # 
    # @param radix the radix used to interpret the token as a long value
    # @return true if and only if this scanner's next token is a valid
    # long value
    # @throws IllegalStateException if this scanner is closed
    def has_next_long(radix)
      set_radix(radix)
      result = has_next(integer_pattern)
      if (result)
        # Cache it
        begin
          s = ((@matcher.group(@simple_group_index)).nil?) ? process_integer_token(@has_next_result) : @has_next_result
          @type_cache = Long.parse_long(s, radix)
        rescue NumberFormatException => nfe
          result = false
        end
      end
      return result
    end
    
    typesig { [] }
    # Scans the next token of the input as a <tt>long</tt>.
    # 
    # <p> An invocation of this method of the form
    # <tt>nextLong()</tt> behaves in exactly the same way as the
    # invocation <tt>nextLong(radix)</tt>, where <code>radix</code>
    # is the default radix of this scanner.
    # 
    # @return the <tt>long</tt> scanned from the input
    # @throws InputMismatchException
    # if the next token does not match the <i>Integer</i>
    # regular expression, or is out of range
    # @throws NoSuchElementException if input is exhausted
    # @throws IllegalStateException if this scanner is closed
    def next_long
      return next_long(@default_radix)
    end
    
    typesig { [::Java::Int] }
    # Scans the next token of the input as a <tt>long</tt>.
    # This method will throw <code>InputMismatchException</code>
    # if the next token cannot be translated into a valid long value as
    # described below. If the translation is successful, the scanner advances
    # past the input that matched.
    # 
    # <p> If the next token matches the <a
    # href="#Integer-regex"><i>Integer</i></a> regular expression defined
    # above then the token is converted into a <tt>long</tt> value as if by
    # removing all locale specific prefixes, group separators, and locale
    # specific suffixes, then mapping non-ASCII digits into ASCII
    # digits via {@link Character#digit Character.digit}, prepending a
    # negative sign (-) if the locale specific negative prefixes and suffixes
    # were present, and passing the resulting string to
    # {@link Long#parseLong(String, int) Long.parseLong} with the
    # specified radix.
    # 
    # @param radix the radix used to interpret the token as an int value
    # @return the <tt>long</tt> scanned from the input
    # @throws InputMismatchException
    # if the next token does not match the <i>Integer</i>
    # regular expression, or is out of range
    # @throws NoSuchElementException if input is exhausted
    # @throws IllegalStateException if this scanner is closed
    def next_long(radix)
      # Check cached result
      if ((!(@type_cache).nil?) && (@type_cache.is_a?(Long)) && (@radix).equal?(radix))
        val = (@type_cache).long_value
        use_type_cache
        return val
      end
      set_radix(radix)
      clear_caches
      begin
        s = next_(integer_pattern)
        if ((@matcher.group(@simple_group_index)).nil?)
          s = RJava.cast_to_string(process_integer_token(s))
        end
        return Long.parse_long(s, radix)
      rescue NumberFormatException => nfe
        @position = @matcher.start # don't skip bad token
        raise InputMismatchException.new(nfe.get_message)
      end
    end
    
    typesig { [String] }
    # The float token must be stripped of prefixes, group separators,
    # and suffixes, non ascii digits must be converted into ascii digits
    # before parseFloat will accept it.
    # 
    # If there are non-ascii digits in the token these digits must
    # be processed before the token is passed to parseFloat.
    def process_float_token(token)
      result = token.replace_all(@group_separator, "")
      if (!(@decimal_separator == "\\."))
        result = RJava.cast_to_string(result.replace_all(@decimal_separator, "."))
      end
      is_negative = false
      pre_len = @negative_prefix.length
      if ((pre_len > 0) && result.starts_with(@negative_prefix))
        is_negative = true
        result = RJava.cast_to_string(result.substring(pre_len))
      end
      suf_len = @negative_suffix.length
      if ((suf_len > 0) && result.ends_with(@negative_suffix))
        is_negative = true
        result = RJava.cast_to_string(result.substring(result.length - suf_len, result.length))
      end
      if ((result == @nan_string))
        result = "NaN"
      end
      if ((result == @infinity_string))
        result = "Infinity"
      end
      if (is_negative)
        result = "-" + result
      end
      # Translate non-ASCII digits
      m = self.attr_non_ascii_digit.matcher(result)
      if (m.find)
        in_ascii = StringBuilder.new
        i = 0
        while i < result.length
          next_char = result.char_at(i)
          if (Character.is_digit(next_char))
            d = Character.digit(next_char, 10)
            if (!(d).equal?(-1))
              in_ascii.append(d)
            else
              in_ascii.append(next_char)
            end
          else
            in_ascii.append(next_char)
          end
          i += 1
        end
        result = RJava.cast_to_string(in_ascii.to_s)
      end
      return result
    end
    
    typesig { [] }
    # Returns true if the next token in this scanner's input can be
    # interpreted as a float value using the {@link #nextFloat}
    # method. The scanner does not advance past any input.
    # 
    # @return true if and only if this scanner's next token is a valid
    # float value
    # @throws IllegalStateException if this scanner is closed
    def has_next_float
      set_radix(10)
      result = has_next(float_pattern)
      if (result)
        # Cache it
        begin
          s = process_float_token(@has_next_result)
          @type_cache = Float.value_of(Float.parse_float(s))
        rescue NumberFormatException => nfe
          result = false
        end
      end
      return result
    end
    
    typesig { [] }
    # Scans the next token of the input as a <tt>float</tt>.
    # This method will throw <code>InputMismatchException</code>
    # if the next token cannot be translated into a valid float value as
    # described below. If the translation is successful, the scanner advances
    # past the input that matched.
    # 
    # <p> If the next token matches the <a
    # href="#Float-regex"><i>Float</i></a> regular expression defined above
    # then the token is converted into a <tt>float</tt> value as if by
    # removing all locale specific prefixes, group separators, and locale
    # specific suffixes, then mapping non-ASCII digits into ASCII
    # digits via {@link Character#digit Character.digit}, prepending a
    # negative sign (-) if the locale specific negative prefixes and suffixes
    # were present, and passing the resulting string to
    # {@link Float#parseFloat Float.parseFloat}. If the token matches
    # the localized NaN or infinity strings, then either "Nan" or "Infinity"
    # is passed to {@link Float#parseFloat(String) Float.parseFloat} as
    # appropriate.
    # 
    # @return the <tt>float</tt> scanned from the input
    # @throws InputMismatchException
    # if the next token does not match the <i>Float</i>
    # regular expression, or is out of range
    # @throws NoSuchElementException if input is exhausted
    # @throws IllegalStateException if this scanner is closed
    def next_float
      # Check cached result
      if ((!(@type_cache).nil?) && (@type_cache.is_a?(Float)))
        val = (@type_cache).float_value
        use_type_cache
        return val
      end
      set_radix(10)
      clear_caches
      begin
        return Float.parse_float(process_float_token(next_(float_pattern)))
      rescue NumberFormatException => nfe
        @position = @matcher.start # don't skip bad token
        raise InputMismatchException.new(nfe.get_message)
      end
    end
    
    typesig { [] }
    # Returns true if the next token in this scanner's input can be
    # interpreted as a double value using the {@link #nextDouble}
    # method. The scanner does not advance past any input.
    # 
    # @return true if and only if this scanner's next token is a valid
    # double value
    # @throws IllegalStateException if this scanner is closed
    def has_next_double
      set_radix(10)
      result = has_next(float_pattern)
      if (result)
        # Cache it
        begin
          s = process_float_token(@has_next_result)
          @type_cache = Double.value_of(Double.parse_double(s))
        rescue NumberFormatException => nfe
          result = false
        end
      end
      return result
    end
    
    typesig { [] }
    # Scans the next token of the input as a <tt>double</tt>.
    # This method will throw <code>InputMismatchException</code>
    # if the next token cannot be translated into a valid double value.
    # If the translation is successful, the scanner advances past the input
    # that matched.
    # 
    # <p> If the next token matches the <a
    # href="#Float-regex"><i>Float</i></a> regular expression defined above
    # then the token is converted into a <tt>double</tt> value as if by
    # removing all locale specific prefixes, group separators, and locale
    # specific suffixes, then mapping non-ASCII digits into ASCII
    # digits via {@link Character#digit Character.digit}, prepending a
    # negative sign (-) if the locale specific negative prefixes and suffixes
    # were present, and passing the resulting string to
    # {@link Double#parseDouble Double.parseDouble}. If the token matches
    # the localized NaN or infinity strings, then either "Nan" or "Infinity"
    # is passed to {@link Double#parseDouble(String) Double.parseDouble} as
    # appropriate.
    # 
    # @return the <tt>double</tt> scanned from the input
    # @throws InputMismatchException
    # if the next token does not match the <i>Float</i>
    # regular expression, or is out of range
    # @throws NoSuchElementException if the input is exhausted
    # @throws IllegalStateException if this scanner is closed
    def next_double
      # Check cached result
      if ((!(@type_cache).nil?) && (@type_cache.is_a?(Double)))
        val = (@type_cache).double_value
        use_type_cache
        return val
      end
      set_radix(10)
      clear_caches
      # Search for next float
      begin
        return Double.parse_double(process_float_token(next_(float_pattern)))
      rescue NumberFormatException => nfe
        @position = @matcher.start # don't skip bad token
        raise InputMismatchException.new(nfe.get_message)
      end
    end
    
    typesig { [] }
    # Convenience methods for scanning multi precision numbers
    # 
    # Returns true if the next token in this scanner's input can be
    # interpreted as a <code>BigInteger</code> in the default radix using the
    # {@link #nextBigInteger} method. The scanner does not advance past any
    # input.
    # 
    # @return true if and only if this scanner's next token is a valid
    # <code>BigInteger</code>
    # @throws IllegalStateException if this scanner is closed
    def has_next_big_integer
      return has_next_big_integer(@default_radix)
    end
    
    typesig { [::Java::Int] }
    # Returns true if the next token in this scanner's input can be
    # interpreted as a <code>BigInteger</code> in the specified radix using
    # the {@link #nextBigInteger} method. The scanner does not advance past
    # any input.
    # 
    # @param radix the radix used to interpret the token as an integer
    # @return true if and only if this scanner's next token is a valid
    # <code>BigInteger</code>
    # @throws IllegalStateException if this scanner is closed
    def has_next_big_integer(radix)
      set_radix(radix)
      result = has_next(integer_pattern)
      if (result)
        # Cache it
        begin
          s = ((@matcher.group(@simple_group_index)).nil?) ? process_integer_token(@has_next_result) : @has_next_result
          @type_cache = BigInteger.new(s, radix)
        rescue NumberFormatException => nfe
          result = false
        end
      end
      return result
    end
    
    typesig { [] }
    # Scans the next token of the input as a {@link java.math.BigInteger
    # BigInteger}.
    # 
    # <p> An invocation of this method of the form
    # <tt>nextBigInteger()</tt> behaves in exactly the same way as the
    # invocation <tt>nextBigInteger(radix)</tt>, where <code>radix</code>
    # is the default radix of this scanner.
    # 
    # @return the <tt>BigInteger</tt> scanned from the input
    # @throws InputMismatchException
    # if the next token does not match the <i>Integer</i>
    # regular expression, or is out of range
    # @throws NoSuchElementException if the input is exhausted
    # @throws IllegalStateException if this scanner is closed
    def next_big_integer
      return next_big_integer(@default_radix)
    end
    
    typesig { [::Java::Int] }
    # Scans the next token of the input as a {@link java.math.BigInteger
    # BigInteger}.
    # 
    # <p> If the next token matches the <a
    # href="#Integer-regex"><i>Integer</i></a> regular expression defined
    # above then the token is converted into a <tt>BigInteger</tt> value as if
    # by removing all group separators, mapping non-ASCII digits into ASCII
    # digits via the {@link Character#digit Character.digit}, and passing the
    # resulting string to the {@link
    # java.math.BigInteger#BigInteger(java.lang.String)
    # BigInteger(String, int)} constructor with the specified radix.
    # 
    # @param radix the radix used to interpret the token
    # @return the <tt>BigInteger</tt> scanned from the input
    # @throws InputMismatchException
    # if the next token does not match the <i>Integer</i>
    # regular expression, or is out of range
    # @throws NoSuchElementException if the input is exhausted
    # @throws IllegalStateException if this scanner is closed
    def next_big_integer(radix)
      # Check cached result
      if ((!(@type_cache).nil?) && (@type_cache.is_a?(BigInteger)) && (@radix).equal?(radix))
        val = @type_cache
        use_type_cache
        return val
      end
      set_radix(radix)
      clear_caches
      # Search for next int
      begin
        s = next_(integer_pattern)
        if ((@matcher.group(@simple_group_index)).nil?)
          s = RJava.cast_to_string(process_integer_token(s))
        end
        return BigInteger.new(s, radix)
      rescue NumberFormatException => nfe
        @position = @matcher.start # don't skip bad token
        raise InputMismatchException.new(nfe.get_message)
      end
    end
    
    typesig { [] }
    # Returns true if the next token in this scanner's input can be
    # interpreted as a <code>BigDecimal</code> using the
    # {@link #nextBigDecimal} method. The scanner does not advance past any
    # input.
    # 
    # @return true if and only if this scanner's next token is a valid
    # <code>BigDecimal</code>
    # @throws IllegalStateException if this scanner is closed
    def has_next_big_decimal
      set_radix(10)
      result = has_next(decimal_pattern)
      if (result)
        # Cache it
        begin
          s = process_float_token(@has_next_result)
          @type_cache = BigDecimal.new(s)
        rescue NumberFormatException => nfe
          result = false
        end
      end
      return result
    end
    
    typesig { [] }
    # Scans the next token of the input as a {@link java.math.BigDecimal
    # BigDecimal}.
    # 
    # <p> If the next token matches the <a
    # href="#Decimal-regex"><i>Decimal</i></a> regular expression defined
    # above then the token is converted into a <tt>BigDecimal</tt> value as if
    # by removing all group separators, mapping non-ASCII digits into ASCII
    # digits via the {@link Character#digit Character.digit}, and passing the
    # resulting string to the {@link
    # java.math.BigDecimal#BigDecimal(java.lang.String) BigDecimal(String)}
    # constructor.
    # 
    # @return the <tt>BigDecimal</tt> scanned from the input
    # @throws InputMismatchException
    # if the next token does not match the <i>Decimal</i>
    # regular expression, or is out of range
    # @throws NoSuchElementException if the input is exhausted
    # @throws IllegalStateException if this scanner is closed
    def next_big_decimal
      # Check cached result
      if ((!(@type_cache).nil?) && (@type_cache.is_a?(BigDecimal)))
        val = @type_cache
        use_type_cache
        return val
      end
      set_radix(10)
      clear_caches
      # Search for next float
      begin
        s = process_float_token(next_(decimal_pattern))
        return BigDecimal.new(s)
      rescue NumberFormatException => nfe
        @position = @matcher.start # don't skip bad token
        raise InputMismatchException.new(nfe.get_message)
      end
    end
    
    typesig { [] }
    # Resets this scanner.
    # 
    # <p> Resetting a scanner discards all of its explicit state
    # information which may have been changed by invocations of {@link
    # #useDelimiter}, {@link #useLocale}, or {@link #useRadix}.
    # 
    # <p> An invocation of this method of the form
    # <tt>scanner.reset()</tt> behaves in exactly the same way as the
    # invocation
    # 
    # <blockquote><pre>
    # scanner.useDelimiter("\\p{javaWhitespace}+")
    # .useLocale(Locale.getDefault())
    # .useRadix(10);
    # </pre></blockquote>
    # 
    # @return this scanner
    # 
    # @since 1.6
    def reset
      @delim_pattern = self.attr_whitespace_pattern
      use_locale(Locale.get_default)
      use_radix(10)
      clear_caches
      return self
    end
    
    private
    alias_method :initialize__scanner, :initialize
  end
  
end
