require "rjava"

# Copyright 2003-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module FormatterImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Io, :BufferedWriter
      include_const ::Java::Io, :Closeable
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :FileOutputStream
      include_const ::Java::Io, :FileNotFoundException
      include_const ::Java::Io, :Flushable
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :OutputStreamWriter
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Java::Math, :BigDecimal
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Math, :MathContext
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Text, :DateFormatSymbols
      include_const ::Java::Text, :DecimalFormat
      include_const ::Java::Text, :DecimalFormatSymbols
      include_const ::Java::Text, :NumberFormat
      include_const ::Java::Util, :Calendar
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :Locale
      include_const ::Java::Util::Regex, :Matcher
      include_const ::Java::Util::Regex, :Pattern
      include_const ::Sun::Misc, :FpUtils
      include_const ::Sun::Misc, :DoubleConsts
      include_const ::Sun::Misc, :FormattedFloatingDecimal
    }
  end
  
  # An interpreter for printf-style format strings.  This class provides support
  # for layout justification and alignment, common formats for numeric, string,
  # and date/time data, and locale-specific output.  Common Java types such as
  # <tt>byte</tt>, {@link java.math.BigDecimal BigDecimal}, and {@link Calendar}
  # are supported.  Limited formatting customization for arbitrary user types is
  # provided through the {@link Formattable} interface.
  # 
  # <p> Formatters are not necessarily safe for multithreaded access.  Thread
  # safety is optional and is the responsibility of users of methods in this
  # class.
  # 
  # <p> Formatted printing for the Java language is heavily inspired by C's
  # <tt>printf</tt>.  Although the format strings are similar to C, some
  # customizations have been made to accommodate the Java language and exploit
  # some of its features.  Also, Java formatting is more strict than C's; for
  # example, if a conversion is incompatible with a flag, an exception will be
  # thrown.  In C inapplicable flags are silently ignored.  The format strings
  # are thus intended to be recognizable to C programmers but not necessarily
  # completely compatible with those in C.
  # 
  # <p> Examples of expected usage:
  # 
  # <blockquote><pre>
  # StringBuilder sb = new StringBuilder();
  # // Send all output to the Appendable object sb
  # Formatter formatter = new Formatter(sb, Locale.US);
  # 
  # // Explicit argument indices may be used to re-order output.
  # formatter.format("%4$2s %3$2s %2$2s %1$2s", "a", "b", "c", "d")
  # // -&gt; " d  c  b  a"
  # 
  # // Optional locale as the first argument can be used to get
  # // locale-specific formatting of numbers.  The precision and width can be
  # // given to round and align the value.
  # formatter.format(Locale.FRANCE, "e = %+10.4f", Math.E);
  # // -&gt; "e =    +2,7183"
  # 
  # // The '(' numeric flag may be used to format negative numbers with
  # // parentheses rather than a minus sign.  Group separators are
  # // automatically inserted.
  # formatter.format("Amount gained or lost since last statement: $ %(,.2f",
  # balanceDelta);
  # // -&gt; "Amount gained or lost since last statement: $ (6,217.58)"
  # </pre></blockquote>
  # 
  # <p> Convenience methods for common formatting requests exist as illustrated
  # by the following invocations:
  # 
  # <blockquote><pre>
  # // Writes a formatted string to System.out.
  # System.out.format("Local time: %tT", Calendar.getInstance());
  # // -&gt; "Local time: 13:34:18"
  # 
  # // Writes formatted output to System.err.
  # System.err.printf("Unable to open file '%1$s': %2$s",
  # fileName, exception.getMessage());
  # // -&gt; "Unable to open file 'food': No such file or directory"
  # </pre></blockquote>
  # 
  # <p> Like C's <tt>sprintf(3)</tt>, Strings may be formatted using the static
  # method {@link String#format(String,Object...) String.format}:
  # 
  # <blockquote><pre>
  # // Format a string containing a date.
  # import java.util.Calendar;
  # import java.util.GregorianCalendar;
  # import static java.util.Calendar.*;
  # 
  # Calendar c = new GregorianCalendar(1995, MAY, 23);
  # String s = String.format("Duke's Birthday: %1$tm %1$te,%1$tY", c);
  # // -&gt; s == "Duke's Birthday: May 23, 1995"
  # </pre></blockquote>
  # 
  # <h3><a name="org">Organization</a></h3>
  # 
  # <p> This specification is divided into two sections.  The first section, <a
  # href="#summary">Summary</a>, covers the basic formatting concepts.  This
  # section is intended for users who want to get started quickly and are
  # familiar with formatted printing in other programming languages.  The second
  # section, <a href="#detail">Details</a>, covers the specific implementation
  # details.  It is intended for users who want more precise specification of
  # formatting behavior.
  # 
  # <h3><a name="summary">Summary</a></h3>
  # 
  # <p> This section is intended to provide a brief overview of formatting
  # concepts.  For precise behavioral details, refer to the <a
  # href="#detail">Details</a> section.
  # 
  # <h4><a name="syntax">Format String Syntax</a></h4>
  # 
  # <p> Every method which produces formatted output requires a <i>format
  # string</i> and an <i>argument list</i>.  The format string is a {@link
  # String} which may contain fixed text and one or more embedded <i>format
  # specifiers</i>.  Consider the following example:
  # 
  # <blockquote><pre>
  # Calendar c = ...;
  # String s = String.format("Duke's Birthday: %1$tm %1$te,%1$tY", c);
  # </pre></blockquote>
  # 
  # This format string is the first argument to the <tt>format</tt> method.  It
  # contains three format specifiers "<tt>%1$tm</tt>", "<tt>%1$te</tt>", and
  # "<tt>%1$tY</tt>" which indicate how the arguments should be processed and
  # where they should be inserted in the text.  The remaining portions of the
  # format string are fixed text including <tt>"Dukes Birthday: "</tt> and any
  # other spaces or punctuation.
  # 
  # The argument list consists of all arguments passed to the method after the
  # format string.  In the above example, the argument list is of size one and
  # consists of the {@link java.util.Calendar Calendar} object <tt>c</tt>.
  # 
  # <ul>
  # 
  # <li> The format specifiers for general, character, and numeric types have
  # the following syntax:
  # 
  # <blockquote><pre>
  # %[argument_index$][flags][width][.precision]conversion
  # </pre></blockquote>
  # 
  # <p> The optional <i>argument_index</i> is a decimal integer indicating the
  # position of the argument in the argument list.  The first argument is
  # referenced by "<tt>1$</tt>", the second by "<tt>2$</tt>", etc.
  # 
  # <p> The optional <i>flags</i> is a set of characters that modify the output
  # format.  The set of valid flags depends on the conversion.
  # 
  # <p> The optional <i>width</i> is a non-negative decimal integer indicating
  # the minimum number of characters to be written to the output.
  # 
  # <p> The optional <i>precision</i> is a non-negative decimal integer usually
  # used to restrict the number of characters.  The specific behavior depends on
  # the conversion.
  # 
  # <p> The required <i>conversion</i> is a character indicating how the
  # argument should be formatted.  The set of valid conversions for a given
  # argument depends on the argument's data type.
  # 
  # <li> The format specifiers for types which are used to represents dates and
  # times have the following syntax:
  # 
  # <blockquote><pre>
  # %[argument_index$][flags][width]conversion
  # </pre></blockquote>
  # 
  # <p> The optional <i>argument_index</i>, <i>flags</i> and <i>width</i> are
  # defined as above.
  # 
  # <p> The required <i>conversion</i> is a two character sequence.  The first
  # character is <tt>'t'</tt> or <tt>'T'</tt>.  The second character indicates
  # the format to be used.  These characters are similar to but not completely
  # identical to those defined by GNU <tt>date</tt> and POSIX
  # <tt>strftime(3c)</tt>.
  # 
  # <li> The format specifiers which do not correspond to arguments have the
  # following syntax:
  # 
  # <blockquote><pre>
  # %[flags][width]conversion
  # </pre></blockquote>
  # 
  # <p> The optional <i>flags</i> and <i>width</i> is defined as above.
  # 
  # <p> The required <i>conversion</i> is a character indicating content to be
  # inserted in the output.
  # 
  # </ul>
  # 
  # <h4> Conversions </h4>
  # 
  # <p> Conversions are divided into the following categories:
  # 
  # <ol>
  # 
  # <li> <b>General</b> - may be applied to any argument
  # type
  # 
  # <li> <b>Character</b> - may be applied to basic types which represent
  # Unicode characters: <tt>char</tt>, {@link Character}, <tt>byte</tt>, {@link
  # Byte}, <tt>short</tt>, and {@link Short}. This conversion may also be
  # applied to the types <tt>int</tt> and {@link Integer} when {@link
  # Character#isValidCodePoint} returns <tt>true</tt>
  # 
  # <li> <b>Numeric</b>
  # 
  # <ol>
  # 
  # <li> <b>Integral</b> - may be applied to Java integral types: <tt>byte</tt>,
  # {@link Byte}, <tt>short</tt>, {@link Short}, <tt>int</tt> and {@link
  # Integer}, <tt>long</tt>, {@link Long}, and {@link java.math.BigInteger
  # BigInteger}
  # 
  # <li><b>Floating Point</b> - may be applied to Java floating-point types:
  # <tt>float</tt>, {@link Float}, <tt>double</tt>, {@link Double}, and {@link
  # java.math.BigDecimal BigDecimal}
  # 
  # </ol>
  # 
  # <li> <b>Date/Time</b> - may be applied to Java types which are capable of
  # encoding a date or time: <tt>long</tt>, {@link Long}, {@link Calendar}, and
  # {@link Date}.
  # 
  # <li> <b>Percent</b> - produces a literal <tt>'%'</tt>
  # (<tt>'&#92;u0025'</tt>)
  # 
  # <li> <b>Line Separator</b> - produces the platform-specific line separator
  # 
  # </ol>
  # 
  # <p> The following table summarizes the supported conversions.  Conversions
  # denoted by an upper-case character (i.e. <tt>'B'</tt>, <tt>'H'</tt>,
  # <tt>'S'</tt>, <tt>'C'</tt>, <tt>'X'</tt>, <tt>'E'</tt>, <tt>'G'</tt>,
  # <tt>'A'</tt>, and <tt>'T'</tt>) are the same as those for the corresponding
  # lower-case conversion characters except that the result is converted to
  # upper case according to the rules of the prevailing {@link java.util.Locale
  # Locale}.  The result is equivalent to the following invocation of {@link
  # String#toUpperCase()}
  # 
  # <pre>
  # out.toUpperCase() </pre>
  # 
  # <table cellpadding=5 summary="genConv">
  # 
  # <tr><th valign="bottom"> Conversion
  # <th valign="bottom"> Argument Category
  # <th valign="bottom"> Description
  # 
  # <tr><td valign="top"> <tt>'b'</tt>, <tt>'B'</tt>
  # <td valign="top"> general
  # <td> If the argument <i>arg</i> is <tt>null</tt>, then the result is
  # "<tt>false</tt>".  If <i>arg</i> is a <tt>boolean</tt> or {@link
  # Boolean}, then the result is the string returned by {@link
  # String#valueOf(boolean) String.valueOf(arg)}.  Otherwise, the result is
  # "true".
  # 
  # <tr><td valign="top"> <tt>'h'</tt>, <tt>'H'</tt>
  # <td valign="top"> general
  # <td> If the argument <i>arg</i> is <tt>null</tt>, then the result is
  # "<tt>null</tt>".  Otherwise, the result is obtained by invoking
  # <tt>Integer.toHexString(arg.hashCode())</tt>.
  # 
  # <tr><td valign="top"> <tt>'s'</tt>, <tt>'S'</tt>
  # <td valign="top"> general
  # <td> If the argument <i>arg</i> is <tt>null</tt>, then the result is
  # "<tt>null</tt>".  If <i>arg</i> implements {@link Formattable}, then
  # {@link Formattable#formatTo arg.formatTo} is invoked. Otherwise, the
  # result is obtained by invoking <tt>arg.toString()</tt>.
  # 
  # <tr><td valign="top"><tt>'c'</tt>, <tt>'C'</tt>
  # <td valign="top"> character
  # <td> The result is a Unicode character
  # 
  # <tr><td valign="top"><tt>'d'</tt>
  # <td valign="top"> integral
  # <td> The result is formatted as a decimal integer
  # 
  # <tr><td valign="top"><tt>'o'</tt>
  # <td valign="top"> integral
  # <td> The result is formatted as an octal integer
  # 
  # <tr><td valign="top"><tt>'x'</tt>, <tt>'X'</tt>
  # <td valign="top"> integral
  # <td> The result is formatted as a hexadecimal integer
  # 
  # <tr><td valign="top"><tt>'e'</tt>, <tt>'E'</tt>
  # <td valign="top"> floating point
  # <td> The result is formatted as a decimal number in computerized
  # scientific notation
  # 
  # <tr><td valign="top"><tt>'f'</tt>
  # <td valign="top"> floating point
  # <td> The result is formatted as a decimal number
  # 
  # <tr><td valign="top"><tt>'g'</tt>, <tt>'G'</tt>
  # <td valign="top"> floating point
  # <td> The result is formatted using computerized scientific notation or
  # decimal format, depending on the precision and the value after rounding.
  # 
  # <tr><td valign="top"><tt>'a'</tt>, <tt>'A'</tt>
  # <td valign="top"> floating point
  # <td> The result is formatted as a hexadecimal floating-point number with
  # a significand and an exponent
  # 
  # <tr><td valign="top"><tt>'t'</tt>, <tt>'T'</tt>
  # <td valign="top"> date/time
  # <td> Prefix for date and time conversion characters.  See <a
  # href="#dt">Date/Time Conversions</a>.
  # 
  # <tr><td valign="top"><tt>'%'</tt>
  # <td valign="top"> percent
  # <td> The result is a literal <tt>'%'</tt> (<tt>'&#92;u0025'</tt>)
  # 
  # <tr><td valign="top"><tt>'n'</tt>
  # <td valign="top"> line separator
  # <td> The result is the platform-specific line separator
  # 
  # </table>
  # 
  # <p> Any characters not explicitly defined as conversions are illegal and are
  # reserved for future extensions.
  # 
  # <h4><a name="dt">Date/Time Conversions</a></h4>
  # 
  # <p> The following date and time conversion suffix characters are defined for
  # the <tt>'t'</tt> and <tt>'T'</tt> conversions.  The types are similar to but
  # not completely identical to those defined by GNU <tt>date</tt> and POSIX
  # <tt>strftime(3c)</tt>.  Additional conversion types are provided to access
  # Java-specific functionality (e.g. <tt>'L'</tt> for milliseconds within the
  # second).
  # 
  # <p> The following conversion characters are used for formatting times:
  # 
  # <table cellpadding=5 summary="time">
  # 
  # <tr><td valign="top"> <tt>'H'</tt>
  # <td> Hour of the day for the 24-hour clock, formatted as two digits with
  # a leading zero as necessary i.e. <tt>00 - 23</tt>.
  # 
  # <tr><td valign="top"><tt>'I'</tt>
  # <td> Hour for the 12-hour clock, formatted as two digits with a leading
  # zero as necessary, i.e.  <tt>01 - 12</tt>.
  # 
  # <tr><td valign="top"><tt>'k'</tt>
  # <td> Hour of the day for the 24-hour clock, i.e. <tt>0 - 23</tt>.
  # 
  # <tr><td valign="top"><tt>'l'</tt>
  # <td> Hour for the 12-hour clock, i.e. <tt>1 - 12</tt>.
  # 
  # <tr><td valign="top"><tt>'M'</tt>
  # <td> Minute within the hour formatted as two digits with a leading zero
  # as necessary, i.e.  <tt>00 - 59</tt>.
  # 
  # <tr><td valign="top"><tt>'S'</tt>
  # <td> Seconds within the minute, formatted as two digits with a leading
  # zero as necessary, i.e. <tt>00 - 60</tt> ("<tt>60</tt>" is a special
  # value required to support leap seconds).
  # 
  # <tr><td valign="top"><tt>'L'</tt>
  # <td> Millisecond within the second formatted as three digits with
  # leading zeros as necessary, i.e. <tt>000 - 999</tt>.
  # 
  # <tr><td valign="top"><tt>'N'</tt>
  # <td> Nanosecond within the second, formatted as nine digits with leading
  # zeros as necessary, i.e. <tt>000000000 - 999999999</tt>.
  # 
  # <tr><td valign="top"><tt>'p'</tt>
  # <td> Locale-specific {@linkplain
  # java.text.DateFormatSymbols#getAmPmStrings morning or afternoon} marker
  # in lower case, e.g."<tt>am</tt>" or "<tt>pm</tt>". Use of the conversion
  # prefix <tt>'T'</tt> forces this output to upper case.
  # 
  # <tr><td valign="top"><tt>'z'</tt>
  # <td> <a href="http://www.ietf.org/rfc/rfc0822.txt">RFC&nbsp;822</a>
  # style numeric time zone offset from GMT, e.g. <tt>-0800</tt>.
  # 
  # <tr><td valign="top"><tt>'Z'</tt>
  # <td> A string representing the abbreviation for the time zone.  The
  # Formatter's locale will supersede the locale of the argument (if any).
  # 
  # <tr><td valign="top"><tt>'s'</tt>
  # <td> Seconds since the beginning of the epoch starting at 1 January 1970
  # <tt>00:00:00</tt> UTC, i.e. <tt>Long.MIN_VALUE/1000</tt> to
  # <tt>Long.MAX_VALUE/1000</tt>.
  # 
  # <tr><td valign="top"><tt>'Q'</tt>
  # <td> Milliseconds since the beginning of the epoch starting at 1 January
  # 1970 <tt>00:00:00</tt> UTC, i.e. <tt>Long.MIN_VALUE</tt> to
  # <tt>Long.MAX_VALUE</tt>.
  # 
  # </table>
  # 
  # <p> The following conversion characters are used for formatting dates:
  # 
  # <table cellpadding=5 summary="date">
  # 
  # <tr><td valign="top"><tt>'B'</tt>
  # <td> Locale-specific {@linkplain java.text.DateFormatSymbols#getMonths
  # full month name}, e.g. <tt>"January"</tt>, <tt>"February"</tt>.
  # 
  # <tr><td valign="top"><tt>'b'</tt>
  # <td> Locale-specific {@linkplain
  # java.text.DateFormatSymbols#getShortMonths abbreviated month name},
  # e.g. <tt>"Jan"</tt>, <tt>"Feb"</tt>.
  # 
  # <tr><td valign="top"><tt>'h'</tt>
  # <td> Same as <tt>'b'</tt>.
  # 
  # <tr><td valign="top"><tt>'A'</tt>
  # <td> Locale-specific full name of the {@linkplain
  # java.text.DateFormatSymbols#getWeekdays day of the week},
  # e.g. <tt>"Sunday"</tt>, <tt>"Monday"</tt>
  # 
  # <tr><td valign="top"><tt>'a'</tt>
  # <td> Locale-specific short name of the {@linkplain
  # java.text.DateFormatSymbols#getShortWeekdays day of the week},
  # e.g. <tt>"Sun"</tt>, <tt>"Mon"</tt>
  # 
  # <tr><td valign="top"><tt>'C'</tt>
  # <td> Four-digit year divided by <tt>100</tt>, formatted as two digits
  # with leading zero as necessary, i.e. <tt>00 - 99</tt>
  # 
  # <tr><td valign="top"><tt>'Y'</tt>
  # <td> Year, formatted as at least four digits with leading zeros as
  # necessary, e.g. <tt>0092</tt> equals <tt>92</tt> CE for the Gregorian
  # calendar.
  # 
  # <tr><td valign="top"><tt>'y'</tt>
  # <td> Last two digits of the year, formatted with leading zeros as
  # necessary, i.e. <tt>00 - 99</tt>.
  # 
  # <tr><td valign="top"><tt>'j'</tt>
  # <td> Day of year, formatted as three digits with leading zeros as
  # necessary, e.g. <tt>001 - 366</tt> for the Gregorian calendar.
  # 
  # <tr><td valign="top"><tt>'m'</tt>
  # <td> Month, formatted as two digits with leading zeros as necessary,
  # i.e. <tt>01 - 13</tt>.
  # 
  # <tr><td valign="top"><tt>'d'</tt>
  # <td> Day of month, formatted as two digits with leading zeros as
  # necessary, i.e. <tt>01 - 31</tt>
  # 
  # <tr><td valign="top"><tt>'e'</tt>
  # <td> Day of month, formatted as two digits, i.e. <tt>1 - 31</tt>.
  # 
  # </table>
  # 
  # <p> The following conversion characters are used for formatting common
  # date/time compositions.
  # 
  # <table cellpadding=5 summary="composites">
  # 
  # <tr><td valign="top"><tt>'R'</tt>
  # <td> Time formatted for the 24-hour clock as <tt>"%tH:%tM"</tt>
  # 
  # <tr><td valign="top"><tt>'T'</tt>
  # <td> Time formatted for the 24-hour clock as <tt>"%tH:%tM:%tS"</tt>.
  # 
  # <tr><td valign="top"><tt>'r'</tt>
  # <td> Time formatted for the 12-hour clock as <tt>"%tI:%tM:%tS %Tp"</tt>.
  # The location of the morning or afternoon marker (<tt>'%Tp'</tt>) may be
  # locale-dependent.
  # 
  # <tr><td valign="top"><tt>'D'</tt>
  # <td> Date formatted as <tt>"%tm/%td/%ty"</tt>.
  # 
  # <tr><td valign="top"><tt>'F'</tt>
  # <td> <a href="http://www.w3.org/TR/NOTE-datetime">ISO&nbsp;8601</a>
  # complete date formatted as <tt>"%tY-%tm-%td"</tt>.
  # 
  # <tr><td valign="top"><tt>'c'</tt>
  # <td> Date and time formatted as <tt>"%ta %tb %td %tT %tZ %tY"</tt>,
  # e.g. <tt>"Sun Jul 20 16:17:00 EDT 1969"</tt>.
  # 
  # </table>
  # 
  # <p> Any characters not explicitly defined as date/time conversion suffixes
  # are illegal and are reserved for future extensions.
  # 
  # <h4> Flags </h4>
  # 
  # <p> The following table summarizes the supported flags.  <i>y</i> means the
  # flag is supported for the indicated argument types.
  # 
  # <table cellpadding=5 summary="genConv">
  # 
  # <tr><th valign="bottom"> Flag <th valign="bottom"> General
  # <th valign="bottom"> Character <th valign="bottom"> Integral
  # <th valign="bottom"> Floating Point
  # <th valign="bottom"> Date/Time
  # <th valign="bottom"> Description
  # 
  # <tr><td> '-' <td align="center" valign="top"> y
  # <td align="center" valign="top"> y
  # <td align="center" valign="top"> y
  # <td align="center" valign="top"> y
  # <td align="center" valign="top"> y
  # <td> The result will be left-justified.
  # 
  # <tr><td> '#' <td align="center" valign="top"> y<sup>1</sup>
  # <td align="center" valign="top"> -
  # <td align="center" valign="top"> y<sup>3</sup>
  # <td align="center" valign="top"> y
  # <td align="center" valign="top"> -
  # <td> The result should use a conversion-dependent alternate form
  # 
  # <tr><td> '+' <td align="center" valign="top"> -
  # <td align="center" valign="top"> -
  # <td align="center" valign="top"> y<sup>4</sup>
  # <td align="center" valign="top"> y
  # <td align="center" valign="top"> -
  # <td> The result will always include a sign
  # 
  # <tr><td> '&nbsp;&nbsp;' <td align="center" valign="top"> -
  # <td align="center" valign="top"> -
  # <td align="center" valign="top"> y<sup>4</sup>
  # <td align="center" valign="top"> y
  # <td align="center" valign="top"> -
  # <td> The result will include a leading space for positive values
  # 
  # <tr><td> '0' <td align="center" valign="top"> -
  # <td align="center" valign="top"> -
  # <td align="center" valign="top"> y
  # <td align="center" valign="top"> y
  # <td align="center" valign="top"> -
  # <td> The result will be zero-padded
  # 
  # <tr><td> ',' <td align="center" valign="top"> -
  # <td align="center" valign="top"> -
  # <td align="center" valign="top"> y<sup>2</sup>
  # <td align="center" valign="top"> y<sup>5</sup>
  # <td align="center" valign="top"> -
  # <td> The result will include locale-specific {@linkplain
  # java.text.DecimalFormatSymbols#getGroupingSeparator grouping separators}
  # 
  # <tr><td> '(' <td align="center" valign="top"> -
  # <td align="center" valign="top"> -
  # <td align="center" valign="top"> y<sup>4</sup>
  # <td align="center" valign="top"> y<sup>5</sup>
  # <td align="center"> -
  # <td> The result will enclose negative numbers in parentheses
  # 
  # </table>
  # 
  # <p> <sup>1</sup> Depends on the definition of {@link Formattable}.
  # 
  # <p> <sup>2</sup> For <tt>'d'</tt> conversion only.
  # 
  # <p> <sup>3</sup> For <tt>'o'</tt>, <tt>'x'</tt>, and <tt>'X'</tt>
  # conversions only.
  # 
  # <p> <sup>4</sup> For <tt>'d'</tt>, <tt>'o'</tt>, <tt>'x'</tt>, and
  # <tt>'X'</tt> conversions applied to {@link java.math.BigInteger BigInteger}
  # or <tt>'d'</tt> applied to <tt>byte</tt>, {@link Byte}, <tt>short</tt>, {@link
  # Short}, <tt>int</tt> and {@link Integer}, <tt>long</tt>, and {@link Long}.
  # 
  # <p> <sup>5</sup> For <tt>'e'</tt>, <tt>'E'</tt>, <tt>'f'</tt>,
  # <tt>'g'</tt>, and <tt>'G'</tt> conversions only.
  # 
  # <p> Any characters not explicitly defined as flags are illegal and are
  # reserved for future extensions.
  # 
  # <h4> Width </h4>
  # 
  # <p> The width is the minimum number of characters to be written to the
  # output.  For the line separator conversion, width is not applicable; if it
  # is provided, an exception will be thrown.
  # 
  # <h4> Precision </h4>
  # 
  # <p> For general argument types, the precision is the maximum number of
  # characters to be written to the output.
  # 
  # <p> For the floating-point conversions <tt>'e'</tt>, <tt>'E'</tt>, and
  # <tt>'f'</tt> the precision is the number of digits after the decimal
  # separator.  If the conversion is <tt>'g'</tt> or <tt>'G'</tt>, then the
  # precision is the total number of digits in the resulting magnitude after
  # rounding.  If the conversion is <tt>'a'</tt> or <tt>'A'</tt>, then the
  # precision must not be specified.
  # 
  # <p> For character, integral, and date/time argument types and the percent
  # and line separator conversions, the precision is not applicable; if a
  # precision is provided, an exception will be thrown.
  # 
  # <h4> Argument Index </h4>
  # 
  # <p> The argument index is a decimal integer indicating the position of the
  # argument in the argument list.  The first argument is referenced by
  # "<tt>1$</tt>", the second by "<tt>2$</tt>", etc.
  # 
  # <p> Another way to reference arguments by position is to use the
  # <tt>'&lt;'</tt> (<tt>'&#92;u003c'</tt>) flag, which causes the argument for
  # the previous format specifier to be re-used.  For example, the following two
  # statements would produce identical strings:
  # 
  # <blockquote><pre>
  # Calendar c = ...;
  # String s1 = String.format("Duke's Birthday: %1$tm %1$te,%1$tY", c);
  # 
  # String s2 = String.format("Duke's Birthday: %1$tm %&lt;te,%&lt;tY", c);
  # </pre></blockquote>
  # 
  # <hr>
  # <h3><a name="detail">Details</a></h3>
  # 
  # <p> This section is intended to provide behavioral details for formatting,
  # including conditions and exceptions, supported data types, localization, and
  # interactions between flags, conversions, and data types.  For an overview of
  # formatting concepts, refer to the <a href="#summary">Summary</a>
  # 
  # <p> Any characters not explicitly defined as conversions, date/time
  # conversion suffixes, or flags are illegal and are reserved for
  # future extensions.  Use of such a character in a format string will
  # cause an {@link UnknownFormatConversionException} or {@link
  # UnknownFormatFlagsException} to be thrown.
  # 
  # <p> If the format specifier contains a width or precision with an invalid
  # value or which is otherwise unsupported, then a {@link
  # IllegalFormatWidthException} or {@link IllegalFormatPrecisionException}
  # respectively will be thrown.
  # 
  # <p> If a format specifier contains a conversion character that is not
  # applicable to the corresponding argument, then an {@link
  # IllegalFormatConversionException} will be thrown.
  # 
  # <p> All specified exceptions may be thrown by any of the <tt>format</tt>
  # methods of <tt>Formatter</tt> as well as by any <tt>format</tt> convenience
  # methods such as {@link String#format(String,Object...) String.format} and
  # {@link java.io.PrintStream#printf(String,Object...) PrintStream.printf}.
  # 
  # <p> Conversions denoted by an upper-case character (i.e. <tt>'B'</tt>,
  # <tt>'H'</tt>, <tt>'S'</tt>, <tt>'C'</tt>, <tt>'X'</tt>, <tt>'E'</tt>,
  # <tt>'G'</tt>, <tt>'A'</tt>, and <tt>'T'</tt>) are the same as those for the
  # corresponding lower-case conversion characters except that the result is
  # converted to upper case according to the rules of the prevailing {@link
  # java.util.Locale Locale}.  The result is equivalent to the following
  # invocation of {@link String#toUpperCase()}
  # 
  # <pre>
  # out.toUpperCase() </pre>
  # 
  # <h4><a name="dgen">General</a></h4>
  # 
  # <p> The following general conversions may be applied to any argument type:
  # 
  # <table cellpadding=5 summary="dgConv">
  # 
  # <tr><td valign="top"> <tt>'b'</tt>
  # <td valign="top"> <tt>'&#92;u0062'</tt>
  # <td> Produces either "<tt>true</tt>" or "<tt>false</tt>" as returned by
  # {@link Boolean#toString(boolean)}.
  # 
  # <p> If the argument is <tt>null</tt>, then the result is
  # "<tt>false</tt>".  If the argument is a <tt>boolean</tt> or {@link
  # Boolean}, then the result is the string returned by {@link
  # String#valueOf(boolean) String.valueOf()}.  Otherwise, the result is
  # "<tt>true</tt>".
  # 
  # <p> If the <tt>'#'</tt> flag is given, then a {@link
  # FormatFlagsConversionMismatchException} will be thrown.
  # 
  # <tr><td valign="top"> <tt>'B'</tt>
  # <td valign="top"> <tt>'&#92;u0042'</tt>
  # <td> The upper-case variant of <tt>'b'</tt>.
  # 
  # <tr><td valign="top"> <tt>'h'</tt>
  # <td valign="top"> <tt>'&#92;u0068'</tt>
  # <td> Produces a string representing the hash code value of the object.
  # 
  # <p> If the argument, <i>arg</i> is <tt>null</tt>, then the
  # result is "<tt>null</tt>".  Otherwise, the result is obtained
  # by invoking <tt>Integer.toHexString(arg.hashCode())</tt>.
  # 
  # <p> If the <tt>'#'</tt> flag is given, then a {@link
  # FormatFlagsConversionMismatchException} will be thrown.
  # 
  # <tr><td valign="top"> <tt>'H'</tt>
  # <td valign="top"> <tt>'&#92;u0048'</tt>
  # <td> The upper-case variant of <tt>'h'</tt>.
  # 
  # <tr><td valign="top"> <tt>'s'</tt>
  # <td valign="top"> <tt>'&#92;u0073'</tt>
  # <td> Produces a string.
  # 
  # <p> If the argument is <tt>null</tt>, then the result is
  # "<tt>null</tt>".  If the argument implements {@link Formattable}, then
  # its {@link Formattable#formatTo formatTo} method is invoked.
  # Otherwise, the result is obtained by invoking the argument's
  # <tt>toString()</tt> method.
  # 
  # <p> If the <tt>'#'</tt> flag is given and the argument is not a {@link
  # Formattable} , then a {@link FormatFlagsConversionMismatchException}
  # will be thrown.
  # 
  # <tr><td valign="top"> <tt>'S'</tt>
  # <td valign="top"> <tt>'&#92;u0053'</tt>
  # <td> The upper-case variant of <tt>'s'</tt>.
  # 
  # </table>
  # 
  # <p> The following <a name="dFlags">flags</a> apply to general conversions:
  # 
  # <table cellpadding=5 summary="dFlags">
  # 
  # <tr><td valign="top"> <tt>'-'</tt>
  # <td valign="top"> <tt>'&#92;u002d'</tt>
  # <td> Left justifies the output.  Spaces (<tt>'&#92;u0020'</tt>) will be
  # added at the end of the converted value as required to fill the minimum
  # width of the field.  If the width is not provided, then a {@link
  # MissingFormatWidthException} will be thrown.  If this flag is not given
  # then the output will be right-justified.
  # 
  # <tr><td valign="top"> <tt>'#'</tt>
  # <td valign="top"> <tt>'&#92;u0023'</tt>
  # <td> Requires the output use an alternate form.  The definition of the
  # form is specified by the conversion.
  # 
  # </table>
  # 
  # <p> The <a name="genWidth">width</a> is the minimum number of characters to
  # be written to the
  # output.  If the length of the converted value is less than the width then
  # the output will be padded by <tt>'&nbsp;&nbsp;'</tt> (<tt>&#92;u0020'</tt>)
  # until the total number of characters equals the width.  The padding is on
  # the left by default.  If the <tt>'-'</tt> flag is given, then the padding
  # will be on the right.  If the width is not specified then there is no
  # minimum.
  # 
  # <p> The precision is the maximum number of characters to be written to the
  # output.  The precision is applied before the width, thus the output will be
  # truncated to <tt>precision</tt> characters even if the width is greater than
  # the precision.  If the precision is not specified then there is no explicit
  # limit on the number of characters.
  # 
  # <h4><a name="dchar">Character</a></h4>
  # 
  # This conversion may be applied to <tt>char</tt> and {@link Character}.  It
  # may also be applied to the types <tt>byte</tt>, {@link Byte},
  # <tt>short</tt>, and {@link Short}, <tt>int</tt> and {@link Integer} when
  # {@link Character#isValidCodePoint} returns <tt>true</tt>.  If it returns
  # <tt>false</tt> then an {@link IllegalFormatCodePointException} will be
  # thrown.
  # 
  # <table cellpadding=5 summary="charConv">
  # 
  # <tr><td valign="top"> <tt>'c'</tt>
  # <td valign="top"> <tt>'&#92;u0063'</tt>
  # <td> Formats the argument as a Unicode character as described in <a
  # href="../lang/Character.html#unicode">Unicode Character
  # Representation</a>.  This may be more than one 16-bit <tt>char</tt> in
  # the case where the argument represents a supplementary character.
  # 
  # <p> If the <tt>'#'</tt> flag is given, then a {@link
  # FormatFlagsConversionMismatchException} will be thrown.
  # 
  # <tr><td valign="top"> <tt>'C'</tt>
  # <td valign="top"> <tt>'&#92;u0043'</tt>
  # <td> The upper-case variant of <tt>'c'</tt>.
  # 
  # </table>
  # 
  # <p> The <tt>'-'</tt> flag defined for <a href="#dFlags">General
  # conversions</a> applies.  If the <tt>'#'</tt> flag is given, then a {@link
  # FormatFlagsConversionMismatchException} will be thrown.
  # 
  # <p> The width is defined as for <a href="#genWidth">General conversions</a>.
  # 
  # <p> The precision is not applicable.  If the precision is specified then an
  # {@link IllegalFormatPrecisionException} will be thrown.
  # 
  # <h4><a name="dnum">Numeric</a></h4>
  # 
  # <p> Numeric conversions are divided into the following categories:
  # 
  # <ol>
  # 
  # <li> <a href="#dnint"><b>Byte, Short, Integer, and Long</b></a>
  # 
  # <li> <a href="#dnbint"><b>BigInteger</b></a>
  # 
  # <li> <a href="#dndec"><b>Float and Double</b></a>
  # 
  # <li> <a href="#dndec"><b>BigDecimal</b></a>
  # 
  # </ol>
  # 
  # <p> Numeric types will be formatted according to the following algorithm:
  # 
  # <p><b><a name="l10n algorithm"> Number Localization Algorithm</a></b>
  # 
  # <p> After digits are obtained for the integer part, fractional part, and
  # exponent (as appropriate for the data type), the following transformation
  # is applied:
  # 
  # <ol>
  # 
  # <li> Each digit character <i>d</i> in the string is replaced by a
  # locale-specific digit computed relative to the current locale's
  # {@linkplain java.text.DecimalFormatSymbols#getZeroDigit() zero digit}
  # <i>z</i>; that is <i>d&nbsp;-&nbsp;</i> <tt>'0'</tt>
  # <i>&nbsp;+&nbsp;z</i>.
  # 
  # <li> If a decimal separator is present, a locale-specific {@linkplain
  # java.text.DecimalFormatSymbols#getDecimalSeparator decimal separator} is
  # substituted.
  # 
  # <li> If the <tt>','</tt> (<tt>'&#92;u002c'</tt>)
  # <a name="l10n group">flag</a> is given, then the locale-specific {@linkplain
  # java.text.DecimalFormatSymbols#getGroupingSeparator grouping separator} is
  # inserted by scanning the integer part of the string from least significant
  # to most significant digits and inserting a separator at intervals defined by
  # the locale's {@linkplain java.text.DecimalFormat#getGroupingSize() grouping
  # size}.
  # 
  # <li> If the <tt>'0'</tt> flag is given, then the locale-specific {@linkplain
  # java.text.DecimalFormatSymbols#getZeroDigit() zero digits} are inserted
  # after the sign character, if any, and before the first non-zero digit, until
  # the length of the string is equal to the requested field width.
  # 
  # <li> If the value is negative and the <tt>'('</tt> flag is given, then a
  # <tt>'('</tt> (<tt>'&#92;u0028'</tt>) is prepended and a <tt>')'</tt>
  # (<tt>'&#92;u0029'</tt>) is appended.
  # 
  # <li> If the value is negative (or floating-point negative zero) and
  # <tt>'('</tt> flag is not given, then a <tt>'-'</tt> (<tt>'&#92;u002d'</tt>)
  # is prepended.
  # 
  # <li> If the <tt>'+'</tt> flag is given and the value is positive or zero (or
  # floating-point positive zero), then a <tt>'+'</tt> (<tt>'&#92;u002b'</tt>)
  # will be prepended.
  # 
  # </ol>
  # 
  # <p> If the value is NaN or positive infinity the literal strings "NaN" or
  # "Infinity" respectively, will be output.  If the value is negative infinity,
  # then the output will be "(Infinity)" if the <tt>'('</tt> flag is given
  # otherwise the output will be "-Infinity".  These values are not localized.
  # 
  # <p><a name="dnint"><b> Byte, Short, Integer, and Long </b></a>
  # 
  # <p> The following conversions may be applied to <tt>byte</tt>, {@link Byte},
  # <tt>short</tt>, {@link Short}, <tt>int</tt> and {@link Integer},
  # <tt>long</tt>, and {@link Long}.
  # 
  # <table cellpadding=5 summary="IntConv">
  # 
  # <tr><td valign="top"> <tt>'d'</tt>
  # <td valign="top"> <tt>'&#92;u0054'</tt>
  # <td> Formats the argument as a decimal integer. The <a
  # href="#l10n algorithm">localization algorithm</a> is applied.
  # 
  # <p> If the <tt>'0'</tt> flag is given and the value is negative, then
  # the zero padding will occur after the sign.
  # 
  # <p> If the <tt>'#'</tt> flag is given then a {@link
  # FormatFlagsConversionMismatchException} will be thrown.
  # 
  # <tr><td valign="top"> <tt>'o'</tt>
  # <td valign="top"> <tt>'&#92;u006f'</tt>
  # <td> Formats the argument as an integer in base eight.  No localization
  # is applied.
  # 
  # <p> If <i>x</i> is negative then the result will be an unsigned value
  # generated by adding 2<sup>n</sup> to the value where <tt>n</tt> is the
  # number of bits in the type as returned by the static <tt>SIZE</tt> field
  # in the {@linkplain Byte#SIZE Byte}, {@linkplain Short#SIZE Short},
  # {@linkplain Integer#SIZE Integer}, or {@linkplain Long#SIZE Long}
  # classes as appropriate.
  # 
  # <p> If the <tt>'#'</tt> flag is given then the output will always begin
  # with the radix indicator <tt>'0'</tt>.
  # 
  # <p> If the <tt>'0'</tt> flag is given then the output will be padded
  # with leading zeros to the field width following any indication of sign.
  # 
  # <p> If <tt>'('</tt>, <tt>'+'</tt>, '&nbsp&nbsp;', or <tt>','</tt> flags
  # are given then a {@link FormatFlagsConversionMismatchException} will be
  # thrown.
  # 
  # <tr><td valign="top"> <tt>'x'</tt>
  # <td valign="top"> <tt>'&#92;u0078'</tt>
  # <td> Formats the argument as an integer in base sixteen. No
  # localization is applied.
  # 
  # <p> If <i>x</i> is negative then the result will be an unsigned value
  # generated by adding 2<sup>n</sup> to the value where <tt>n</tt> is the
  # number of bits in the type as returned by the static <tt>SIZE</tt> field
  # in the {@linkplain Byte#SIZE Byte}, {@linkplain Short#SIZE Short},
  # {@linkplain Integer#SIZE Integer}, or {@linkplain Long#SIZE Long}
  # classes as appropriate.
  # 
  # <p> If the <tt>'#'</tt> flag is given then the output will always begin
  # with the radix indicator <tt>"0x"</tt>.
  # 
  # <p> If the <tt>'0'</tt> flag is given then the output will be padded to
  # the field width with leading zeros after the radix indicator or sign (if
  # present).
  # 
  # <p> If <tt>'('</tt>, <tt>'&nbsp;&nbsp;'</tt>, <tt>'+'</tt>, or
  # <tt>','</tt> flags are given then a {@link
  # FormatFlagsConversionMismatchException} will be thrown.
  # 
  # <tr><td valign="top"> <tt>'X'</tt>
  # <td valign="top"> <tt>'&#92;u0058'</tt>
  # <td> The upper-case variant of <tt>'x'</tt>.  The entire string
  # representing the number will be converted to {@linkplain
  # String#toUpperCase upper case} including the <tt>'x'</tt> (if any) and
  # all hexadecimal digits <tt>'a'</tt> - <tt>'f'</tt>
  # (<tt>'&#92;u0061'</tt> -  <tt>'&#92;u0066'</tt>).
  # 
  # </table>
  # 
  # <p> If the conversion is <tt>'o'</tt>, <tt>'x'</tt>, or <tt>'X'</tt> and
  # both the <tt>'#'</tt> and the <tt>'0'</tt> flags are given, then result will
  # contain the radix indicator (<tt>'0'</tt> for octal and <tt>"0x"</tt> or
  # <tt>"0X"</tt> for hexadecimal), some number of zeros (based on the width),
  # and the value.
  # 
  # <p> If the <tt>'-'</tt> flag is not given, then the space padding will occur
  # before the sign.
  # 
  # <p> The following <a name="intFlags">flags</a> apply to numeric integral
  # conversions:
  # 
  # <table cellpadding=5 summary="intFlags">
  # 
  # <tr><td valign="top"> <tt>'+'</tt>
  # <td valign="top"> <tt>'&#92;u002b'</tt>
  # <td> Requires the output to include a positive sign for all positive
  # numbers.  If this flag is not given then only negative values will
  # include a sign.
  # 
  # <p> If both the <tt>'+'</tt> and <tt>'&nbsp;&nbsp;'</tt> flags are given
  # then an {@link IllegalFormatFlagsException} will be thrown.
  # 
  # <tr><td valign="top"> <tt>'&nbsp;&nbsp;'</tt>
  # <td valign="top"> <tt>'&#92;u0020'</tt>
  # <td> Requires the output to include a single extra space
  # (<tt>'&#92;u0020'</tt>) for non-negative values.
  # 
  # <p> If both the <tt>'+'</tt> and <tt>'&nbsp;&nbsp;'</tt> flags are given
  # then an {@link IllegalFormatFlagsException} will be thrown.
  # 
  # <tr><td valign="top"> <tt>'0'</tt>
  # <td valign="top"> <tt>'&#92;u0030'</tt>
  # <td> Requires the output to be padded with leading {@linkplain
  # java.text.DecimalFormatSymbols#getZeroDigit zeros} to the minimum field
  # width following any sign or radix indicator except when converting NaN
  # or infinity.  If the width is not provided, then a {@link
  # MissingFormatWidthException} will be thrown.
  # 
  # <p> If both the <tt>'-'</tt> and <tt>'0'</tt> flags are given then an
  # {@link IllegalFormatFlagsException} will be thrown.
  # 
  # <tr><td valign="top"> <tt>','</tt>
  # <td valign="top"> <tt>'&#92;u002c'</tt>
  # <td> Requires the output to include the locale-specific {@linkplain
  # java.text.DecimalFormatSymbols#getGroupingSeparator group separators} as
  # described in the <a href="#l10n group">"group" section</a> of the
  # localization algorithm.
  # 
  # <tr><td valign="top"> <tt>'('</tt>
  # <td valign="top"> <tt>'&#92;u0028'</tt>
  # <td> Requires the output to prepend a <tt>'('</tt>
  # (<tt>'&#92;u0028'</tt>) and append a <tt>')'</tt>
  # (<tt>'&#92;u0029'</tt>) to negative values.
  # 
  # </table>
  # 
  # <p> If no <a name="intdFlags">flags</a> are given the default formatting is
  # as follows:
  # 
  # <ul>
  # 
  # <li> The output is right-justified within the <tt>width</tt>
  # 
  # <li> Negative numbers begin with a <tt>'-'</tt> (<tt>'&#92;u002d'</tt>)
  # 
  # <li> Positive numbers and zero do not include a sign or extra leading
  # space
  # 
  # <li> No grouping separators are included
  # 
  # </ul>
  # 
  # <p> The <a name="intWidth">width</a> is the minimum number of characters to
  # be written to the output.  This includes any signs, digits, grouping
  # separators, radix indicator, and parentheses.  If the length of the
  # converted value is less than the width then the output will be padded by
  # spaces (<tt>'&#92;u0020'</tt>) until the total number of characters equals
  # width.  The padding is on the left by default.  If <tt>'-'</tt> flag is
  # given then the padding will be on the right.  If width is not specified then
  # there is no minimum.
  # 
  # <p> The precision is not applicable.  If precision is specified then an
  # {@link IllegalFormatPrecisionException} will be thrown.
  # 
  # <p><a name="dnbint"><b> BigInteger </b></a>
  # 
  # <p> The following conversions may be applied to {@link
  # java.math.BigInteger}.
  # 
  # <table cellpadding=5 summary="BIntConv">
  # 
  # <tr><td valign="top"> <tt>'d'</tt>
  # <td valign="top"> <tt>'&#92;u0054'</tt>
  # <td> Requires the output to be formatted as a decimal integer. The <a
  # href="#l10n algorithm">localization algorithm</a> is applied.
  # 
  # <p> If the <tt>'#'</tt> flag is given {@link
  # FormatFlagsConversionMismatchException} will be thrown.
  # 
  # <tr><td valign="top"> <tt>'o'</tt>
  # <td valign="top"> <tt>'&#92;u006f'</tt>
  # <td> Requires the output to be formatted as an integer in base eight.
  # No localization is applied.
  # 
  # <p> If <i>x</i> is negative then the result will be a signed value
  # beginning with <tt>'-'</tt> (<tt>'&#92;u002d'</tt>).  Signed output is
  # allowed for this type because unlike the primitive types it is not
  # possible to create an unsigned equivalent without assuming an explicit
  # data-type size.
  # 
  # <p> If <i>x</i> is positive or zero and the <tt>'+'</tt> flag is given
  # then the result will begin with <tt>'+'</tt> (<tt>'&#92;u002b'</tt>).
  # 
  # <p> If the <tt>'#'</tt> flag is given then the output will always begin
  # with <tt>'0'</tt> prefix.
  # 
  # <p> If the <tt>'0'</tt> flag is given then the output will be padded
  # with leading zeros to the field width following any indication of sign.
  # 
  # <p> If the <tt>','</tt> flag is given then a {@link
  # FormatFlagsConversionMismatchException} will be thrown.
  # 
  # <tr><td valign="top"> <tt>'x'</tt>
  # <td valign="top"> <tt>'&#92;u0078'</tt>
  # <td> Requires the output to be formatted as an integer in base
  # sixteen.  No localization is applied.
  # 
  # <p> If <i>x</i> is negative then the result will be a signed value
  # beginning with <tt>'-'</tt> (<tt>'&#92;u002d'</tt>).  Signed output is
  # allowed for this type because unlike the primitive types it is not
  # possible to create an unsigned equivalent without assuming an explicit
  # data-type size.
  # 
  # <p> If <i>x</i> is positive or zero and the <tt>'+'</tt> flag is given
  # then the result will begin with <tt>'+'</tt> (<tt>'&#92;u002b'</tt>).
  # 
  # <p> If the <tt>'#'</tt> flag is given then the output will always begin
  # with the radix indicator <tt>"0x"</tt>.
  # 
  # <p> If the <tt>'0'</tt> flag is given then the output will be padded to
  # the field width with leading zeros after the radix indicator or sign (if
  # present).
  # 
  # <p> If the <tt>','</tt> flag is given then a {@link
  # FormatFlagsConversionMismatchException} will be thrown.
  # 
  # <tr><td valign="top"> <tt>'X'</tt>
  # <td valign="top"> <tt>'&#92;u0058'</tt>
  # <td> The upper-case variant of <tt>'x'</tt>.  The entire string
  # representing the number will be converted to {@linkplain
  # String#toUpperCase upper case} including the <tt>'x'</tt> (if any) and
  # all hexadecimal digits <tt>'a'</tt> - <tt>'f'</tt>
  # (<tt>'&#92;u0061'</tt> - <tt>'&#92;u0066'</tt>).
  # 
  # </table>
  # 
  # <p> If the conversion is <tt>'o'</tt>, <tt>'x'</tt>, or <tt>'X'</tt> and
  # both the <tt>'#'</tt> and the <tt>'0'</tt> flags are given, then result will
  # contain the base indicator (<tt>'0'</tt> for octal and <tt>"0x"</tt> or
  # <tt>"0X"</tt> for hexadecimal), some number of zeros (based on the width),
  # and the value.
  # 
  # <p> If the <tt>'0'</tt> flag is given and the value is negative, then the
  # zero padding will occur after the sign.
  # 
  # <p> If the <tt>'-'</tt> flag is not given, then the space padding will occur
  # before the sign.
  # 
  # <p> All <a href="#intFlags">flags</a> defined for Byte, Short, Integer, and
  # Long apply.  The <a href="#intdFlags">default behavior</a> when no flags are
  # given is the same as for Byte, Short, Integer, and Long.
  # 
  # <p> The specification of <a href="#intWidth">width</a> is the same as
  # defined for Byte, Short, Integer, and Long.
  # 
  # <p> The precision is not applicable.  If precision is specified then an
  # {@link IllegalFormatPrecisionException} will be thrown.
  # 
  # <p><a name="dndec"><b> Float and Double</b></a>
  # 
  # <p> The following conversions may be applied to <tt>float</tt>, {@link
  # Float}, <tt>double</tt> and {@link Double}.
  # 
  # <table cellpadding=5 summary="floatConv">
  # 
  # <tr><td valign="top"> <tt>'e'</tt>
  # <td valign="top"> <tt>'&#92;u0065'</tt>
  # <td> Requires the output to be formatted using <a
  # name="scientific">computerized scientific notation</a>.  The <a
  # href="#l10n algorithm">localization algorithm</a> is applied.
  # 
  # <p> The formatting of the magnitude <i>m</i> depends upon its value.
  # 
  # <p> If <i>m</i> is NaN or infinite, the literal strings "NaN" or
  # "Infinity", respectively, will be output.  These values are not
  # localized.
  # 
  # <p> If <i>m</i> is positive-zero or negative-zero, then the exponent
  # will be <tt>"+00"</tt>.
  # 
  # <p> Otherwise, the result is a string that represents the sign and
  # magnitude (absolute value) of the argument.  The formatting of the sign
  # is described in the <a href="#l10n algorithm">localization
  # algorithm</a>. The formatting of the magnitude <i>m</i> depends upon its
  # value.
  # 
  # <p> Let <i>n</i> be the unique integer such that 10<sup><i>n</i></sup>
  # &lt;= <i>m</i> &lt; 10<sup><i>n</i>+1</sup>; then let <i>a</i> be the
  # mathematically exact quotient of <i>m</i> and 10<sup><i>n</i></sup> so
  # that 1 &lt;= <i>a</i> &lt; 10. The magnitude is then represented as the
  # integer part of <i>a</i>, as a single decimal digit, followed by the
  # decimal separator followed by decimal digits representing the fractional
  # part of <i>a</i>, followed by the exponent symbol <tt>'e'</tt>
  # (<tt>'&#92;u0065'</tt>), followed by the sign of the exponent, followed
  # by a representation of <i>n</i> as a decimal integer, as produced by the
  # method {@link Long#toString(long, int)}, and zero-padded to include at
  # least two digits.
  # 
  # <p> The number of digits in the result for the fractional part of
  # <i>m</i> or <i>a</i> is equal to the precision.  If the precision is not
  # specified then the default value is <tt>6</tt>. If the precision is less
  # than the number of digits which would appear after the decimal point in
  # the string returned by {@link Float#toString(float)} or {@link
  # Double#toString(double)} respectively, then the value will be rounded
  # using the {@linkplain java.math.BigDecimal#ROUND_HALF_UP round half up
  # algorithm}.  Otherwise, zeros may be appended to reach the precision.
  # For a canonical representation of the value, use {@link
  # Float#toString(float)} or {@link Double#toString(double)} as
  # appropriate.
  # 
  # <p>If the <tt>','</tt> flag is given, then an {@link
  # FormatFlagsConversionMismatchException} will be thrown.
  # 
  # <tr><td valign="top"> <tt>'E'</tt>
  # <td valign="top"> <tt>'&#92;u0045'</tt>
  # <td> The upper-case variant of <tt>'e'</tt>.  The exponent symbol
  # will be <tt>'E'</tt> (<tt>'&#92;u0045'</tt>).
  # 
  # <tr><td valign="top"> <tt>'g'</tt>
  # <td valign="top"> <tt>'&#92;u0067'</tt>
  # <td> Requires the output to be formatted in general scientific notation
  # as described below. The <a href="#l10n algorithm">localization
  # algorithm</a> is applied.
  # 
  # <p> After rounding for the precision, the formatting of the resulting
  # magnitude <i>m</i> depends on its value.
  # 
  # <p> If <i>m</i> is greater than or equal to 10<sup>-4</sup> but less
  # than 10<sup>precision</sup> then it is represented in <i><a
  # href="#decimal">decimal format</a></i>.
  # 
  # <p> If <i>m</i> is less than 10<sup>-4</sup> or greater than or equal to
  # 10<sup>precision</sup>, then it is represented in <i><a
  # href="#scientific">computerized scientific notation</a></i>.
  # 
  # <p> The total number of significant digits in <i>m</i> is equal to the
  # precision.  If the precision is not specified, then the default value is
  # <tt>6</tt>.  If the precision is <tt>0</tt>, then it is taken to be
  # <tt>1</tt>.
  # 
  # <p> If the <tt>'#'</tt> flag is given then an {@link
  # FormatFlagsConversionMismatchException} will be thrown.
  # 
  # <tr><td valign="top"> <tt>'G'</tt>
  # <td valign="top"> <tt>'&#92;u0047'</tt>
  # <td> The upper-case variant of <tt>'g'</tt>.
  # 
  # <tr><td valign="top"> <tt>'f'</tt>
  # <td valign="top"> <tt>'&#92;u0066'</tt>
  # <td> Requires the output to be formatted using <a name="decimal">decimal
  # format</a>.  The <a href="#l10n algorithm">localization algorithm</a> is
  # applied.
  # 
  # <p> The result is a string that represents the sign and magnitude
  # (absolute value) of the argument.  The formatting of the sign is
  # described in the <a href="#l10n algorithm">localization
  # algorithm</a>. The formatting of the magnitude <i>m</i> depends upon its
  # value.
  # 
  # <p> If <i>m</i> NaN or infinite, the literal strings "NaN" or
  # "Infinity", respectively, will be output.  These values are not
  # localized.
  # 
  # <p> The magnitude is formatted as the integer part of <i>m</i>, with no
  # leading zeroes, followed by the decimal separator followed by one or
  # more decimal digits representing the fractional part of <i>m</i>.
  # 
  # <p> The number of digits in the result for the fractional part of
  # <i>m</i> or <i>a</i> is equal to the precision.  If the precision is not
  # specified then the default value is <tt>6</tt>. If the precision is less
  # than the number of digits which would appear after the decimal point in
  # the string returned by {@link Float#toString(float)} or {@link
  # Double#toString(double)} respectively, then the value will be rounded
  # using the {@linkplain java.math.BigDecimal#ROUND_HALF_UP round half up
  # algorithm}.  Otherwise, zeros may be appended to reach the precision.
  # For a canonical representation of the value,use {@link
  # Float#toString(float)} or {@link Double#toString(double)} as
  # appropriate.
  # 
  # <tr><td valign="top"> <tt>'a'</tt>
  # <td valign="top"> <tt>'&#92;u0061'</tt>
  # <td> Requires the output to be formatted in hexadecimal exponential
  # form.  No localization is applied.
  # 
  # <p> The result is a string that represents the sign and magnitude
  # (absolute value) of the argument <i>x</i>.
  # 
  # <p> If <i>x</i> is negative or a negative-zero value then the result
  # will begin with <tt>'-'</tt> (<tt>'&#92;u002d'</tt>).
  # 
  # <p> If <i>x</i> is positive or a positive-zero value and the
  # <tt>'+'</tt> flag is given then the result will begin with <tt>'+'</tt>
  # (<tt>'&#92;u002b'</tt>).
  # 
  # <p> The formatting of the magnitude <i>m</i> depends upon its value.
  # 
  # <ul>
  # 
  # <li> If the value is NaN or infinite, the literal strings "NaN" or
  # "Infinity", respectively, will be output.
  # 
  # <li> If <i>m</i> is zero then it is represented by the string
  # <tt>"0x0.0p0"</tt>.
  # 
  # <li> If <i>m</i> is a <tt>double</tt> value with a normalized
  # representation then substrings are used to represent the significand and
  # exponent fields.  The significand is represented by the characters
  # <tt>"0x1."</tt> followed by the hexadecimal representation of the rest
  # of the significand as a fraction.  The exponent is represented by
  # <tt>'p'</tt> (<tt>'&#92;u0070'</tt>) followed by a decimal string of the
  # unbiased exponent as if produced by invoking {@link
  # Integer#toString(int) Integer.toString} on the exponent value.
  # 
  # <li> If <i>m</i> is a <tt>double</tt> value with a subnormal
  # representation then the significand is represented by the characters
  # <tt>'0x0.'</tt> followed by the hexadecimal representation of the rest
  # of the significand as a fraction.  The exponent is represented by
  # <tt>'p-1022'</tt>.  Note that there must be at least one nonzero digit
  # in a subnormal significand.
  # 
  # </ul>
  # 
  # <p> If the <tt>'('</tt> or <tt>','</tt> flags are given, then a {@link
  # FormatFlagsConversionMismatchException} will be thrown.
  # 
  # <tr><td valign="top"> <tt>'A'</tt>
  # <td valign="top"> <tt>'&#92;u0041'</tt>
  # <td> The upper-case variant of <tt>'a'</tt>.  The entire string
  # representing the number will be converted to upper case including the
  # <tt>'x'</tt> (<tt>'&#92;u0078'</tt>) and <tt>'p'</tt>
  # (<tt>'&#92;u0070'</tt> and all hexadecimal digits <tt>'a'</tt> -
  # <tt>'f'</tt> (<tt>'&#92;u0061'</tt> - <tt>'&#92;u0066'</tt>).
  # 
  # </table>
  # 
  # <p> All <a href="#intFlags">flags</a> defined for Byte, Short, Integer, and
  # Long apply.
  # 
  # <p> If the <tt>'#'</tt> flag is given, then the decimal separator will
  # always be present.
  # 
  # <p> If no <a name="floatdFlags">flags</a> are given the default formatting
  # is as follows:
  # 
  # <ul>
  # 
  # <li> The output is right-justified within the <tt>width</tt>
  # 
  # <li> Negative numbers begin with a <tt>'-'</tt>
  # 
  # <li> Positive numbers and positive zero do not include a sign or extra
  # leading space
  # 
  # <li> No grouping separators are included
  # 
  # <li> The decimal separator will only appear if a digit follows it
  # 
  # </ul>
  # 
  # <p> The <a name="floatDWidth">width</a> is the minimum number of characters
  # to be written to the output.  This includes any signs, digits, grouping
  # separators, decimal separators, exponential symbol, radix indicator,
  # parentheses, and strings representing infinity and NaN as applicable.  If
  # the length of the converted value is less than the width then the output
  # will be padded by spaces (<tt>'&#92;u0020'</tt>) until the total number of
  # characters equals width.  The padding is on the left by default.  If the
  # <tt>'-'</tt> flag is given then the padding will be on the right.  If width
  # is not specified then there is no minimum.
  # 
  # <p> If the <a name="floatDPrec">conversion</a> is <tt>'e'</tt>,
  # <tt>'E'</tt> or <tt>'f'</tt>, then the precision is the number of digits
  # after the decimal separator.  If the precision is not specified, then it is
  # assumed to be <tt>6</tt>.
  # 
  # <p> If the conversion is <tt>'g'</tt> or <tt>'G'</tt>, then the precision is
  # the total number of significant digits in the resulting magnitude after
  # rounding.  If the precision is not specified, then the default value is
  # <tt>6</tt>.  If the precision is <tt>0</tt>, then it is taken to be
  # <tt>1</tt>.
  # 
  # <p> If the conversion is <tt>'a'</tt> or <tt>'A'</tt>, then the precision
  # is the number of hexadecimal digits after the decimal separator.  If the
  # precision is not provided, then all of the digits as returned by {@link
  # Double#toHexString(double)} will be output.
  # 
  # <p><a name="dndec"><b> BigDecimal </b></a>
  # 
  # <p> The following conversions may be applied {@link java.math.BigDecimal
  # BigDecimal}.
  # 
  # <table cellpadding=5 summary="floatConv">
  # 
  # <tr><td valign="top"> <tt>'e'</tt>
  # <td valign="top"> <tt>'&#92;u0065'</tt>
  # <td> Requires the output to be formatted using <a
  # name="scientific">computerized scientific notation</a>.  The <a
  # href="#l10n algorithm">localization algorithm</a> is applied.
  # 
  # <p> The formatting of the magnitude <i>m</i> depends upon its value.
  # 
  # <p> If <i>m</i> is positive-zero or negative-zero, then the exponent
  # will be <tt>"+00"</tt>.
  # 
  # <p> Otherwise, the result is a string that represents the sign and
  # magnitude (absolute value) of the argument.  The formatting of the sign
  # is described in the <a href="#l10n algorithm">localization
  # algorithm</a>. The formatting of the magnitude <i>m</i> depends upon its
  # value.
  # 
  # <p> Let <i>n</i> be the unique integer such that 10<sup><i>n</i></sup>
  # &lt;= <i>m</i> &lt; 10<sup><i>n</i>+1</sup>; then let <i>a</i> be the
  # mathematically exact quotient of <i>m</i> and 10<sup><i>n</i></sup> so
  # that 1 &lt;= <i>a</i> &lt; 10. The magnitude is then represented as the
  # integer part of <i>a</i>, as a single decimal digit, followed by the
  # decimal separator followed by decimal digits representing the fractional
  # part of <i>a</i>, followed by the exponent symbol <tt>'e'</tt>
  # (<tt>'&#92;u0065'</tt>), followed by the sign of the exponent, followed
  # by a representation of <i>n</i> as a decimal integer, as produced by the
  # method {@link Long#toString(long, int)}, and zero-padded to include at
  # least two digits.
  # 
  # <p> The number of digits in the result for the fractional part of
  # <i>m</i> or <i>a</i> is equal to the precision.  If the precision is not
  # specified then the default value is <tt>6</tt>.  If the precision is
  # less than the number of digits which would appear after the decimal
  # point in the string returned by {@link Float#toString(float)} or {@link
  # Double#toString(double)} respectively, then the value will be rounded
  # using the {@linkplain java.math.BigDecimal#ROUND_HALF_UP round half up
  # algorithm}.  Otherwise, zeros may be appended to reach the precision.
  # For a canonical representation of the value, use {@link
  # BigDecimal#toString()}.
  # 
  # <p> If the <tt>','</tt> flag is given, then an {@link
  # FormatFlagsConversionMismatchException} will be thrown.
  # 
  # <tr><td valign="top"> <tt>'E'</tt>
  # <td valign="top"> <tt>'&#92;u0045'</tt>
  # <td> The upper-case variant of <tt>'e'</tt>.  The exponent symbol
  # will be <tt>'E'</tt> (<tt>'&#92;u0045'</tt>).
  # 
  # <tr><td valign="top"> <tt>'g'</tt>
  # <td valign="top"> <tt>'&#92;u0067'</tt>
  # <td> Requires the output to be formatted in general scientific notation
  # as described below. The <a href="#l10n algorithm">localization
  # algorithm</a> is applied.
  # 
  # <p> After rounding for the precision, the formatting of the resulting
  # magnitude <i>m</i> depends on its value.
  # 
  # <p> If <i>m</i> is greater than or equal to 10<sup>-4</sup> but less
  # than 10<sup>precision</sup> then it is represented in <i><a
  # href="#decimal">decimal format</a></i>.
  # 
  # <p> If <i>m</i> is less than 10<sup>-4</sup> or greater than or equal to
  # 10<sup>precision</sup>, then it is represented in <i><a
  # href="#scientific">computerized scientific notation</a></i>.
  # 
  # <p> The total number of significant digits in <i>m</i> is equal to the
  # precision.  If the precision is not specified, then the default value is
  # <tt>6</tt>.  If the precision is <tt>0</tt>, then it is taken to be
  # <tt>1</tt>.
  # 
  # <p> If the <tt>'#'</tt> flag is given then an {@link
  # FormatFlagsConversionMismatchException} will be thrown.
  # 
  # <tr><td valign="top"> <tt>'G'</tt>
  # <td valign="top"> <tt>'&#92;u0047'</tt>
  # <td> The upper-case variant of <tt>'g'</tt>.
  # 
  # <tr><td valign="top"> <tt>'f'</tt>
  # <td valign="top"> <tt>'&#92;u0066'</tt>
  # <td> Requires the output to be formatted using <a name="decimal">decimal
  # format</a>.  The <a href="#l10n algorithm">localization algorithm</a> is
  # applied.
  # 
  # <p> The result is a string that represents the sign and magnitude
  # (absolute value) of the argument.  The formatting of the sign is
  # described in the <a href="#l10n algorithm">localization
  # algorithm</a>. The formatting of the magnitude <i>m</i> depends upon its
  # value.
  # 
  # <p> The magnitude is formatted as the integer part of <i>m</i>, with no
  # leading zeroes, followed by the decimal separator followed by one or
  # more decimal digits representing the fractional part of <i>m</i>.
  # 
  # <p> The number of digits in the result for the fractional part of
  # <i>m</i> or <i>a</i> is equal to the precision.  If the precision is not
  # specified then the default value is <tt>6</tt>.  If the precision is
  # less than the number of digits which would appear after the decimal
  # point in the string returned by {@link Float#toString(float)} or {@link
  # Double#toString(double)} respectively, then the value will be rounded
  # using the {@linkplain java.math.BigDecimal#ROUND_HALF_UP round half up
  # algorithm}.  Otherwise, zeros may be appended to reach the precision.
  # For a canonical representation of the value, use {@link
  # BigDecimal#toString()}.
  # 
  # </table>
  # 
  # <p> All <a href="#intFlags">flags</a> defined for Byte, Short, Integer, and
  # Long apply.
  # 
  # <p> If the <tt>'#'</tt> flag is given, then the decimal separator will
  # always be present.
  # 
  # <p> The <a href="#floatdFlags">default behavior</a> when no flags are
  # given is the same as for Float and Double.
  # 
  # <p> The specification of <a href="#floatDWidth">width</a> and <a
  # href="#floatDPrec">precision</a> is the same as defined for Float and
  # Double.
  # 
  # <h4><a name="ddt">Date/Time</a></h4>
  # 
  # <p> This conversion may be applied to <tt>long</tt>, {@link Long}, {@link
  # Calendar}, and {@link Date}.
  # 
  # <table cellpadding=5 summary="DTConv">
  # 
  # <tr><td valign="top"> <tt>'t'</tt>
  # <td valign="top"> <tt>'&#92;u0074'</tt>
  # <td> Prefix for date and time conversion characters.
  # <tr><td valign="top"> <tt>'T'</tt>
  # <td valign="top"> <tt>'&#92;u0054'</tt>
  # <td> The upper-case variant of <tt>'t'</tt>.
  # 
  # </table>
  # 
  # <p> The following date and time conversion character suffixes are defined
  # for the <tt>'t'</tt> and <tt>'T'</tt> conversions.  The types are similar to
  # but not completely identical to those defined by GNU <tt>date</tt> and
  # POSIX <tt>strftime(3c)</tt>.  Additional conversion types are provided to
  # access Java-specific functionality (e.g. <tt>'L'</tt> for milliseconds
  # within the second).
  # 
  # <p> The following conversion characters are used for formatting times:
  # 
  # <table cellpadding=5 summary="time">
  # 
  # <tr><td valign="top"> <tt>'H'</tt>
  # <td valign="top"> <tt>'&#92;u0048'</tt>
  # <td> Hour of the day for the 24-hour clock, formatted as two digits with
  # a leading zero as necessary i.e. <tt>00 - 23</tt>. <tt>00</tt>
  # corresponds to midnight.
  # 
  # <tr><td valign="top"><tt>'I'</tt>
  # <td valign="top"> <tt>'&#92;u0049'</tt>
  # <td> Hour for the 12-hour clock, formatted as two digits with a leading
  # zero as necessary, i.e.  <tt>01 - 12</tt>.  <tt>01</tt> corresponds to
  # one o'clock (either morning or afternoon).
  # 
  # <tr><td valign="top"><tt>'k'</tt>
  # <td valign="top"> <tt>'&#92;u006b'</tt>
  # <td> Hour of the day for the 24-hour clock, i.e. <tt>0 - 23</tt>.
  # <tt>0</tt> corresponds to midnight.
  # 
  # <tr><td valign="top"><tt>'l'</tt>
  # <td valign="top"> <tt>'&#92;u006c'</tt>
  # <td> Hour for the 12-hour clock, i.e. <tt>1 - 12</tt>.  <tt>1</tt>
  # corresponds to one o'clock (either morning or afternoon).
  # 
  # <tr><td valign="top"><tt>'M'</tt>
  # <td valign="top"> <tt>'&#92;u004d'</tt>
  # <td> Minute within the hour formatted as two digits with a leading zero
  # as necessary, i.e.  <tt>00 - 59</tt>.
  # 
  # <tr><td valign="top"><tt>'S'</tt>
  # <td valign="top"> <tt>'&#92;u0053'</tt>
  # <td> Seconds within the minute, formatted as two digits with a leading
  # zero as necessary, i.e. <tt>00 - 60</tt> ("<tt>60</tt>" is a special
  # value required to support leap seconds).
  # 
  # <tr><td valign="top"><tt>'L'</tt>
  # <td valign="top"> <tt>'&#92;u004c'</tt>
  # <td> Millisecond within the second formatted as three digits with
  # leading zeros as necessary, i.e. <tt>000 - 999</tt>.
  # 
  # <tr><td valign="top"><tt>'N'</tt>
  # <td valign="top"> <tt>'&#92;u004e'</tt>
  # <td> Nanosecond within the second, formatted as nine digits with leading
  # zeros as necessary, i.e. <tt>000000000 - 999999999</tt>.  The precision
  # of this value is limited by the resolution of the underlying operating
  # system or hardware.
  # 
  # <tr><td valign="top"><tt>'p'</tt>
  # <td valign="top"> <tt>'&#92;u0070'</tt>
  # <td> Locale-specific {@linkplain
  # java.text.DateFormatSymbols#getAmPmStrings morning or afternoon} marker
  # in lower case, e.g."<tt>am</tt>" or "<tt>pm</tt>".  Use of the
  # conversion prefix <tt>'T'</tt> forces this output to upper case.  (Note
  # that <tt>'p'</tt> produces lower-case output.  This is different from
  # GNU <tt>date</tt> and POSIX <tt>strftime(3c)</tt> which produce
  # upper-case output.)
  # 
  # <tr><td valign="top"><tt>'z'</tt>
  # <td valign="top"> <tt>'&#92;u007a'</tt>
  # <td> <a href="http://www.ietf.org/rfc/rfc0822.txt">RFC&nbsp;822</a>
  # style numeric time zone offset from GMT, e.g. <tt>-0800</tt>.
  # 
  # <tr><td valign="top"><tt>'Z'</tt>
  # <td valign="top"> <tt>'&#92;u005a'</tt>
  # <td> A string representing the abbreviation for the time zone.
  # 
  # <tr><td valign="top"><tt>'s'</tt>
  # <td valign="top"> <tt>'&#92;u0073'</tt>
  # <td> Seconds since the beginning of the epoch starting at 1 January 1970
  # <tt>00:00:00</tt> UTC, i.e. <tt>Long.MIN_VALUE/1000</tt> to
  # <tt>Long.MAX_VALUE/1000</tt>.
  # 
  # <tr><td valign="top"><tt>'Q'</tt>
  # <td valign="top"> <tt>'&#92;u004f'</tt>
  # <td> Milliseconds since the beginning of the epoch starting at 1 January
  # 1970 <tt>00:00:00</tt> UTC, i.e. <tt>Long.MIN_VALUE</tt> to
  # <tt>Long.MAX_VALUE</tt>. The precision of this value is limited by
  # the resolution of the underlying operating system or hardware.
  # 
  # </table>
  # 
  # <p> The following conversion characters are used for formatting dates:
  # 
  # <table cellpadding=5 summary="date">
  # 
  # <tr><td valign="top"><tt>'B'</tt>
  # <td valign="top"> <tt>'&#92;u0042'</tt>
  # <td> Locale-specific {@linkplain java.text.DateFormatSymbols#getMonths
  # full month name}, e.g. <tt>"January"</tt>, <tt>"February"</tt>.
  # 
  # <tr><td valign="top"><tt>'b'</tt>
  # <td valign="top"> <tt>'&#92;u0062'</tt>
  # <td> Locale-specific {@linkplain
  # java.text.DateFormatSymbols#getShortMonths abbreviated month name},
  # e.g. <tt>"Jan"</tt>, <tt>"Feb"</tt>.
  # 
  # <tr><td valign="top"><tt>'h'</tt>
  # <td valign="top"> <tt>'&#92;u0068'</tt>
  # <td> Same as <tt>'b'</tt>.
  # 
  # <tr><td valign="top"><tt>'A'</tt>
  # <td valign="top"> <tt>'&#92;u0041'</tt>
  # <td> Locale-specific full name of the {@linkplain
  # java.text.DateFormatSymbols#getWeekdays day of the week},
  # e.g. <tt>"Sunday"</tt>, <tt>"Monday"</tt>
  # 
  # <tr><td valign="top"><tt>'a'</tt>
  # <td valign="top"> <tt>'&#92;u0061'</tt>
  # <td> Locale-specific short name of the {@linkplain
  # java.text.DateFormatSymbols#getShortWeekdays day of the week},
  # e.g. <tt>"Sun"</tt>, <tt>"Mon"</tt>
  # 
  # <tr><td valign="top"><tt>'C'</tt>
  # <td valign="top"> <tt>'&#92;u0043'</tt>
  # <td> Four-digit year divided by <tt>100</tt>, formatted as two digits
  # with leading zero as necessary, i.e. <tt>00 - 99</tt>
  # 
  # <tr><td valign="top"><tt>'Y'</tt>
  # <td valign="top"> <tt>'&#92;u0059'</tt> <td> Year, formatted to at least
  # four digits with leading zeros as necessary, e.g. <tt>0092</tt> equals
  # <tt>92</tt> CE for the Gregorian calendar.
  # 
  # <tr><td valign="top"><tt>'y'</tt>
  # <td valign="top"> <tt>'&#92;u0079'</tt>
  # <td> Last two digits of the year, formatted with leading zeros as
  # necessary, i.e. <tt>00 - 99</tt>.
  # 
  # <tr><td valign="top"><tt>'j'</tt>
  # <td valign="top"> <tt>'&#92;u006a'</tt>
  # <td> Day of year, formatted as three digits with leading zeros as
  # necessary, e.g. <tt>001 - 366</tt> for the Gregorian calendar.
  # <tt>001</tt> corresponds to the first day of the year.
  # 
  # <tr><td valign="top"><tt>'m'</tt>
  # <td valign="top"> <tt>'&#92;u006d'</tt>
  # <td> Month, formatted as two digits with leading zeros as necessary,
  # i.e. <tt>01 - 13</tt>, where "<tt>01</tt>" is the first month of the
  # year and ("<tt>13</tt>" is a special value required to support lunar
  # calendars).
  # 
  # <tr><td valign="top"><tt>'d'</tt>
  # <td valign="top"> <tt>'&#92;u0064'</tt>
  # <td> Day of month, formatted as two digits with leading zeros as
  # necessary, i.e. <tt>01 - 31</tt>, where "<tt>01</tt>" is the first day
  # of the month.
  # 
  # <tr><td valign="top"><tt>'e'</tt>
  # <td valign="top"> <tt>'&#92;u0065'</tt>
  # <td> Day of month, formatted as two digits, i.e. <tt>1 - 31</tt> where
  # "<tt>1</tt>" is the first day of the month.
  # 
  # </table>
  # 
  # <p> The following conversion characters are used for formatting common
  # date/time compositions.
  # 
  # <table cellpadding=5 summary="composites">
  # 
  # <tr><td valign="top"><tt>'R'</tt>
  # <td valign="top"> <tt>'&#92;u0052'</tt>
  # <td> Time formatted for the 24-hour clock as <tt>"%tH:%tM"</tt>
  # 
  # <tr><td valign="top"><tt>'T'</tt>
  # <td valign="top"> <tt>'&#92;u0054'</tt>
  # <td> Time formatted for the 24-hour clock as <tt>"%tH:%tM:%tS"</tt>.
  # 
  # <tr><td valign="top"><tt>'r'</tt>
  # <td valign="top"> <tt>'&#92;u0072'</tt>
  # <td> Time formatted for the 12-hour clock as <tt>"%tI:%tM:%tS
  # %Tp"</tt>.  The location of the morning or afternoon marker
  # (<tt>'%Tp'</tt>) may be locale-dependent.
  # 
  # <tr><td valign="top"><tt>'D'</tt>
  # <td valign="top"> <tt>'&#92;u0044'</tt>
  # <td> Date formatted as <tt>"%tm/%td/%ty"</tt>.
  # 
  # <tr><td valign="top"><tt>'F'</tt>
  # <td valign="top"> <tt>'&#92;u0046'</tt>
  # <td> <a href="http://www.w3.org/TR/NOTE-datetime">ISO&nbsp;8601</a>
  # complete date formatted as <tt>"%tY-%tm-%td"</tt>.
  # 
  # <tr><td valign="top"><tt>'c'</tt>
  # <td valign="top"> <tt>'&#92;u0063'</tt>
  # <td> Date and time formatted as <tt>"%ta %tb %td %tT %tZ %tY"</tt>,
  # e.g. <tt>"Sun Jul 20 16:17:00 EDT 1969"</tt>.
  # 
  # </table>
  # 
  # <p> The <tt>'-'</tt> flag defined for <a href="#dFlags">General
  # conversions</a> applies.  If the <tt>'#'</tt> flag is given, then a {@link
  # FormatFlagsConversionMismatchException} will be thrown.
  # 
  # <p> The <a name="dtWidth">width</a> is the minimum number of characters to
  # be written to the output.  If the length of the converted value is less than
  # the <tt>width</tt> then the output will be padded by spaces
  # (<tt>'&#92;u0020'</tt>) until the total number of characters equals width.
  # The padding is on the left by default.  If the <tt>'-'</tt> flag is given
  # then the padding will be on the right.  If width is not specified then there
  # is no minimum.
  # 
  # <p> The precision is not applicable.  If the precision is specified then an
  # {@link IllegalFormatPrecisionException} will be thrown.
  # 
  # <h4><a name="dper">Percent</a></h4>
  # 
  # <p> The conversion does not correspond to any argument.
  # 
  # <table cellpadding=5 summary="DTConv">
  # 
  # <tr><td valign="top"><tt>'%'</tt>
  # <td> The result is a literal <tt>'%'</tt> (<tt>'&#92;u0025'</tt>)
  # 
  # <p> The <a name="dtWidth">width</a> is the minimum number of characters to
  # be written to the output including the <tt>'%'</tt>.  If the length of the
  # converted value is less than the <tt>width</tt> then the output will be
  # padded by spaces (<tt>'&#92;u0020'</tt>) until the total number of
  # characters equals width.  The padding is on the left.  If width is not
  # specified then just the <tt>'%'</tt> is output.
  # 
  # <p> The <tt>'-'</tt> flag defined for <a href="#dFlags">General
  # conversions</a> applies.  If any other flags are provided, then a
  # {@link FormatFlagsConversionMismatchException} will be thrown.
  # 
  # <p> The precision is not applicable.  If the precision is specified an
  # {@link IllegalFormatPrecisionException} will be thrown.
  # 
  # </table>
  # 
  # <h4><a name="dls">Line Separator</a></h4>
  # 
  # <p> The conversion does not correspond to any argument.
  # 
  # <table cellpadding=5 summary="DTConv">
  # 
  # <tr><td valign="top"><tt>'n'</tt>
  # <td> the platform-specific line separator as returned by {@link
  # System#getProperty System.getProperty("line.separator")}.
  # 
  # </table>
  # 
  # <p> Flags, width, and precision are not applicable.  If any are provided an
  # {@link IllegalFormatFlagsException}, {@link IllegalFormatWidthException},
  # and {@link IllegalFormatPrecisionException}, respectively will be thrown.
  # 
  # <h4><a name="dpos">Argument Index</a></h4>
  # 
  # <p> Format specifiers can reference arguments in three ways:
  # 
  # <ul>
  # 
  # <li> <i>Explicit indexing</i> is used when the format specifier contains an
  # argument index.  The argument index is a decimal integer indicating the
  # position of the argument in the argument list.  The first argument is
  # referenced by "<tt>1$</tt>", the second by "<tt>2$</tt>", etc.  An argument
  # may be referenced more than once.
  # 
  # <p> For example:
  # 
  # <blockquote><pre>
  # formatter.format("%4$s %3$s %2$s %1$s %4$s %3$s %2$s %1$s",
  # "a", "b", "c", "d")
  # // -&gt; "d c b a d c b a"
  # </pre></blockquote>
  # 
  # <li> <i>Relative indexing</i> is used when the format specifier contains a
  # <tt>'&lt;'</tt> (<tt>'&#92;u003c'</tt>) flag which causes the argument for
  # the previous format specifier to be re-used.  If there is no previous
  # argument, then a {@link MissingFormatArgumentException} is thrown.
  # 
  # <blockquote><pre>
  # formatter.format("%s %s %&lt;s %&lt;s", "a", "b", "c", "d")
  # // -&gt; "a b b b"
  # // "c" and "d" are ignored because they are not referenced
  # </pre></blockquote>
  # 
  # <li> <i>Ordinary indexing</i> is used when the format specifier contains
  # neither an argument index nor a <tt>'&lt;'</tt> flag.  Each format specifier
  # which uses ordinary indexing is assigned a sequential implicit index into
  # argument list which is independent of the indices used by explicit or
  # relative indexing.
  # 
  # <blockquote><pre>
  # formatter.format("%s %s %s %s", "a", "b", "c", "d")
  # // -&gt; "a b c d"
  # </pre></blockquote>
  # 
  # </ul>
  # 
  # <p> It is possible to have a format string which uses all forms of indexing,
  # for example:
  # 
  # <blockquote><pre>
  # formatter.format("%2$s %s %&lt;s %s", "a", "b", "c", "d")
  # // -&gt; "b a a b"
  # // "c" and "d" are ignored because they are not referenced
  # </pre></blockquote>
  # 
  # <p> The maximum number of arguments is limited by the maximum dimension of a
  # Java array as defined by the <a
  # href="http://java.sun.com/docs/books/vmspec/">Java Virtual Machine
  # Specification</a>.  If the argument index is does not correspond to an
  # available argument, then a {@link MissingFormatArgumentException} is thrown.
  # 
  # <p> If there are more arguments than format specifiers, the extra arguments
  # are ignored.
  # 
  # <p> Unless otherwise specified, passing a <tt>null</tt> argument to any
  # method or constructor in this class will cause a {@link
  # NullPointerException} to be thrown.
  # 
  # @author  Iris Clark
  # @since 1.5
  class Formatter 
    include_class_members FormatterImports
    include Closeable
    include Flushable
    
    attr_accessor :a
    alias_method :attr_a, :a
    undef_method :a
    alias_method :attr_a=, :a=
    undef_method :a=
    
    attr_accessor :l
    alias_method :attr_l, :l
    undef_method :l
    alias_method :attr_l=, :l=
    undef_method :l=
    
    attr_accessor :last_exception
    alias_method :attr_last_exception, :last_exception
    undef_method :last_exception
    alias_method :attr_last_exception=, :last_exception=
    undef_method :last_exception=
    
    attr_accessor :zero
    alias_method :attr_zero, :zero
    undef_method :zero
    alias_method :attr_zero=, :zero=
    undef_method :zero=
    
    class_module.module_eval {
      
      def scale_up
        defined?(@@scale_up) ? @@scale_up : @@scale_up= 0.0
      end
      alias_method :attr_scale_up, :scale_up
      
      def scale_up=(value)
        @@scale_up = value
      end
      alias_method :attr_scale_up=, :scale_up=
      
      # 1 (sign) + 19 (max # sig digits) + 1 ('.') + 1 ('e') + 1 (sign)
      # + 3 (max # exp digits) + 4 (error) = 30
      const_set_lazy(:MAX_FD_CHARS) { 30 }
      const_attr_reader  :MAX_FD_CHARS
    }
    
    typesig { [Appendable, Locale] }
    # Initialize internal data.
    def init(a, l)
      @a = a
      @l = l
      set_zero
    end
    
    typesig { [] }
    # Constructs a new formatter.
    # 
    # <p> The destination of the formatted output is a {@link StringBuilder}
    # which may be retrieved by invoking {@link #out out()} and whose
    # current content may be converted into a string by invoking {@link
    # #toString toString()}.  The locale used is the {@linkplain
    # Locale#getDefault() default locale} for this instance of the Java
    # virtual machine.
    def initialize
      @a = nil
      @l = nil
      @last_exception = nil
      @zero = Character.new(?0.ord)
      init(StringBuilder.new, Locale.get_default)
    end
    
    typesig { [Appendable] }
    # Constructs a new formatter with the specified destination.
    # 
    # <p> The locale used is the {@linkplain Locale#getDefault() default
    # locale} for this instance of the Java virtual machine.
    # 
    # @param  a
    # Destination for the formatted output.  If <tt>a</tt> is
    # <tt>null</tt> then a {@link StringBuilder} will be created.
    def initialize(a)
      @a = nil
      @l = nil
      @last_exception = nil
      @zero = Character.new(?0.ord)
      if ((a).nil?)
        a = StringBuilder.new
      end
      init(a, Locale.get_default)
    end
    
    typesig { [Locale] }
    # Constructs a new formatter with the specified locale.
    # 
    # <p> The destination of the formatted output is a {@link StringBuilder}
    # which may be retrieved by invoking {@link #out out()} and whose current
    # content may be converted into a string by invoking {@link #toString
    # toString()}.
    # 
    # @param  l
    # The {@linkplain java.util.Locale locale} to apply during
    # formatting.  If <tt>l</tt> is <tt>null</tt> then no localization
    # is applied.
    def initialize(l)
      @a = nil
      @l = nil
      @last_exception = nil
      @zero = Character.new(?0.ord)
      init(StringBuilder.new, l)
    end
    
    typesig { [Appendable, Locale] }
    # Constructs a new formatter with the specified destination and locale.
    # 
    # @param  a
    # Destination for the formatted output.  If <tt>a</tt> is
    # <tt>null</tt> then a {@link StringBuilder} will be created.
    # 
    # @param  l
    # The {@linkplain java.util.Locale locale} to apply during
    # formatting.  If <tt>l</tt> is <tt>null</tt> then no localization
    # is applied.
    def initialize(a, l)
      @a = nil
      @l = nil
      @last_exception = nil
      @zero = Character.new(?0.ord)
      if ((a).nil?)
        a = StringBuilder.new
      end
      init(a, l)
    end
    
    typesig { [String] }
    # Constructs a new formatter with the specified file name.
    # 
    # <p> The charset used is the {@linkplain
    # java.nio.charset.Charset#defaultCharset() default charset} for this
    # instance of the Java virtual machine.
    # 
    # <p> The locale used is the {@linkplain Locale#getDefault() default
    # locale} for this instance of the Java virtual machine.
    # 
    # @param  fileName
    # The name of the file to use as the destination of this
    # formatter.  If the file exists then it will be truncated to
    # zero size; otherwise, a new file will be created.  The output
    # will be written to the file and is buffered.
    # 
    # @throws  SecurityException
    # If a security manager is present and {@link
    # SecurityManager#checkWrite checkWrite(fileName)} denies write
    # access to the file
    # 
    # @throws  FileNotFoundException
    # If the given file name does not denote an existing, writable
    # regular file and a new regular file of that name cannot be
    # created, or if some other error occurs while opening or
    # creating the file
    def initialize(file_name)
      @a = nil
      @l = nil
      @last_exception = nil
      @zero = Character.new(?0.ord)
      init(BufferedWriter.new(OutputStreamWriter.new(FileOutputStream.new(file_name))), Locale.get_default)
    end
    
    typesig { [String, String] }
    # Constructs a new formatter with the specified file name and charset.
    # 
    # <p> The locale used is the {@linkplain Locale#getDefault default
    # locale} for this instance of the Java virtual machine.
    # 
    # @param  fileName
    # The name of the file to use as the destination of this
    # formatter.  If the file exists then it will be truncated to
    # zero size; otherwise, a new file will be created.  The output
    # will be written to the file and is buffered.
    # 
    # @param  csn
    # The name of a supported {@linkplain java.nio.charset.Charset
    # charset}
    # 
    # @throws  FileNotFoundException
    # If the given file name does not denote an existing, writable
    # regular file and a new regular file of that name cannot be
    # created, or if some other error occurs while opening or
    # creating the file
    # 
    # @throws  SecurityException
    # If a security manager is present and {@link
    # SecurityManager#checkWrite checkWrite(fileName)} denies write
    # access to the file
    # 
    # @throws  UnsupportedEncodingException
    # If the named charset is not supported
    def initialize(file_name, csn)
      initialize__formatter(file_name, csn, Locale.get_default)
    end
    
    typesig { [String, String, Locale] }
    # Constructs a new formatter with the specified file name, charset, and
    # locale.
    # 
    # @param  fileName
    # The name of the file to use as the destination of this
    # formatter.  If the file exists then it will be truncated to
    # zero size; otherwise, a new file will be created.  The output
    # will be written to the file and is buffered.
    # 
    # @param  csn
    # The name of a supported {@linkplain java.nio.charset.Charset
    # charset}
    # 
    # @param  l
    # The {@linkplain java.util.Locale locale} to apply during
    # formatting.  If <tt>l</tt> is <tt>null</tt> then no localization
    # is applied.
    # 
    # @throws  FileNotFoundException
    # If the given file name does not denote an existing, writable
    # regular file and a new regular file of that name cannot be
    # created, or if some other error occurs while opening or
    # creating the file
    # 
    # @throws  SecurityException
    # If a security manager is present and {@link
    # SecurityManager#checkWrite checkWrite(fileName)} denies write
    # access to the file
    # 
    # @throws  UnsupportedEncodingException
    # If the named charset is not supported
    def initialize(file_name, csn, l)
      @a = nil
      @l = nil
      @last_exception = nil
      @zero = Character.new(?0.ord)
      init(BufferedWriter.new(OutputStreamWriter.new(FileOutputStream.new(file_name), csn)), l)
    end
    
    typesig { [JavaFile] }
    # Constructs a new formatter with the specified file.
    # 
    # <p> The charset used is the {@linkplain
    # java.nio.charset.Charset#defaultCharset() default charset} for this
    # instance of the Java virtual machine.
    # 
    # <p> The locale used is the {@linkplain Locale#getDefault() default
    # locale} for this instance of the Java virtual machine.
    # 
    # @param  file
    # The file to use as the destination of this formatter.  If the
    # file exists then it will be truncated to zero size; otherwise,
    # a new file will be created.  The output will be written to the
    # file and is buffered.
    # 
    # @throws  SecurityException
    # If a security manager is present and {@link
    # SecurityManager#checkWrite checkWrite(file.getPath())} denies
    # write access to the file
    # 
    # @throws  FileNotFoundException
    # If the given file object does not denote an existing, writable
    # regular file and a new regular file of that name cannot be
    # created, or if some other error occurs while opening or
    # creating the file
    def initialize(file)
      @a = nil
      @l = nil
      @last_exception = nil
      @zero = Character.new(?0.ord)
      init(BufferedWriter.new(OutputStreamWriter.new(FileOutputStream.new(file))), Locale.get_default)
    end
    
    typesig { [JavaFile, String] }
    # Constructs a new formatter with the specified file and charset.
    # 
    # <p> The locale used is the {@linkplain Locale#getDefault default
    # locale} for this instance of the Java virtual machine.
    # 
    # @param  file
    # The file to use as the destination of this formatter.  If the
    # file exists then it will be truncated to zero size; otherwise,
    # a new file will be created.  The output will be written to the
    # file and is buffered.
    # 
    # @param  csn
    # The name of a supported {@linkplain java.nio.charset.Charset
    # charset}
    # 
    # @throws  FileNotFoundException
    # If the given file object does not denote an existing, writable
    # regular file and a new regular file of that name cannot be
    # created, or if some other error occurs while opening or
    # creating the file
    # 
    # @throws  SecurityException
    # If a security manager is present and {@link
    # SecurityManager#checkWrite checkWrite(file.getPath())} denies
    # write access to the file
    # 
    # @throws  UnsupportedEncodingException
    # If the named charset is not supported
    def initialize(file, csn)
      initialize__formatter(file, csn, Locale.get_default)
    end
    
    typesig { [JavaFile, String, Locale] }
    # Constructs a new formatter with the specified file, charset, and
    # locale.
    # 
    # @param  file
    # The file to use as the destination of this formatter.  If the
    # file exists then it will be truncated to zero size; otherwise,
    # a new file will be created.  The output will be written to the
    # file and is buffered.
    # 
    # @param  csn
    # The name of a supported {@linkplain java.nio.charset.Charset
    # charset}
    # 
    # @param  l
    # The {@linkplain java.util.Locale locale} to apply during
    # formatting.  If <tt>l</tt> is <tt>null</tt> then no localization
    # is applied.
    # 
    # @throws  FileNotFoundException
    # If the given file object does not denote an existing, writable
    # regular file and a new regular file of that name cannot be
    # created, or if some other error occurs while opening or
    # creating the file
    # 
    # @throws  SecurityException
    # If a security manager is present and {@link
    # SecurityManager#checkWrite checkWrite(file.getPath())} denies
    # write access to the file
    # 
    # @throws  UnsupportedEncodingException
    # If the named charset is not supported
    def initialize(file, csn, l)
      @a = nil
      @l = nil
      @last_exception = nil
      @zero = Character.new(?0.ord)
      init(BufferedWriter.new(OutputStreamWriter.new(FileOutputStream.new(file), csn)), l)
    end
    
    typesig { [PrintStream] }
    # Constructs a new formatter with the specified print stream.
    # 
    # <p> The locale used is the {@linkplain Locale#getDefault() default
    # locale} for this instance of the Java virtual machine.
    # 
    # <p> Characters are written to the given {@link java.io.PrintStream
    # PrintStream} object and are therefore encoded using that object's
    # charset.
    # 
    # @param  ps
    # The stream to use as the destination of this formatter.
    def initialize(ps)
      @a = nil
      @l = nil
      @last_exception = nil
      @zero = Character.new(?0.ord)
      if ((ps).nil?)
        raise NullPointerException.new
      end
      init(ps, Locale.get_default)
    end
    
    typesig { [OutputStream] }
    # Constructs a new formatter with the specified output stream.
    # 
    # <p> The charset used is the {@linkplain
    # java.nio.charset.Charset#defaultCharset() default charset} for this
    # instance of the Java virtual machine.
    # 
    # <p> The locale used is the {@linkplain Locale#getDefault() default
    # locale} for this instance of the Java virtual machine.
    # 
    # @param  os
    # The output stream to use as the destination of this formatter.
    # The output will be buffered.
    def initialize(os)
      @a = nil
      @l = nil
      @last_exception = nil
      @zero = Character.new(?0.ord)
      init(BufferedWriter.new(OutputStreamWriter.new(os)), Locale.get_default)
    end
    
    typesig { [OutputStream, String] }
    # Constructs a new formatter with the specified output stream and
    # charset.
    # 
    # <p> The locale used is the {@linkplain Locale#getDefault default
    # locale} for this instance of the Java virtual machine.
    # 
    # @param  os
    # The output stream to use as the destination of this formatter.
    # The output will be buffered.
    # 
    # @param  csn
    # The name of a supported {@linkplain java.nio.charset.Charset
    # charset}
    # 
    # @throws  UnsupportedEncodingException
    # If the named charset is not supported
    def initialize(os, csn)
      initialize__formatter(os, csn, Locale.get_default)
    end
    
    typesig { [OutputStream, String, Locale] }
    # Constructs a new formatter with the specified output stream, charset,
    # and locale.
    # 
    # @param  os
    # The output stream to use as the destination of this formatter.
    # The output will be buffered.
    # 
    # @param  csn
    # The name of a supported {@linkplain java.nio.charset.Charset
    # charset}
    # 
    # @param  l
    # The {@linkplain java.util.Locale locale} to apply during
    # formatting.  If <tt>l</tt> is <tt>null</tt> then no localization
    # is applied.
    # 
    # @throws  UnsupportedEncodingException
    # If the named charset is not supported
    def initialize(os, csn, l)
      @a = nil
      @l = nil
      @last_exception = nil
      @zero = Character.new(?0.ord)
      init(BufferedWriter.new(OutputStreamWriter.new(os, csn)), l)
    end
    
    typesig { [] }
    def set_zero
      if ((!(@l).nil?) && !(@l == Locale::US))
        dfs = DecimalFormatSymbols.get_instance(@l)
        @zero = dfs.get_zero_digit
      end
    end
    
    typesig { [] }
    # Returns the locale set by the construction of this formatter.
    # 
    # <p> The {@link #format(java.util.Locale,String,Object...) format} method
    # for this object which has a locale argument does not change this value.
    # 
    # @return  <tt>null</tt> if no localization is applied, otherwise a
    # locale
    # 
    # @throws  FormatterClosedException
    # If this formatter has been closed by invoking its {@link
    # #close()} method
    def locale
      ensure_open
      return @l
    end
    
    typesig { [] }
    # Returns the destination for the output.
    # 
    # @return  The destination for the output
    # 
    # @throws  FormatterClosedException
    # If this formatter has been closed by invoking its {@link
    # #close()} method
    def out
      ensure_open
      return @a
    end
    
    typesig { [] }
    # Returns the result of invoking <tt>toString()</tt> on the destination
    # for the output.  For example, the following code formats text into a
    # {@link StringBuilder} then retrieves the resultant string:
    # 
    # <blockquote><pre>
    # Formatter f = new Formatter();
    # f.format("Last reboot at %tc", lastRebootDate);
    # String s = f.toString();
    # // -&gt; s == "Last reboot at Sat Jan 01 00:00:00 PST 2000"
    # </pre></blockquote>
    # 
    # <p> An invocation of this method behaves in exactly the same way as the
    # invocation
    # 
    # <pre>
    # out().toString() </pre>
    # 
    # <p> Depending on the specification of <tt>toString</tt> for the {@link
    # Appendable}, the returned string may or may not contain the characters
    # written to the destination.  For instance, buffers typically return
    # their contents in <tt>toString()</tt>, but streams cannot since the
    # data is discarded.
    # 
    # @return  The result of invoking <tt>toString()</tt> on the destination
    # for the output
    # 
    # @throws  FormatterClosedException
    # If this formatter has been closed by invoking its {@link
    # #close()} method
    def to_s
      ensure_open
      return @a.to_s
    end
    
    typesig { [] }
    # Flushes this formatter.  If the destination implements the {@link
    # java.io.Flushable} interface, its <tt>flush</tt> method will be invoked.
    # 
    # <p> Flushing a formatter writes any buffered output in the destination
    # to the underlying stream.
    # 
    # @throws  FormatterClosedException
    # If this formatter has been closed by invoking its {@link
    # #close()} method
    def flush
      ensure_open
      if (@a.is_a?(Flushable))
        begin
          (@a).flush
        rescue IOException => ioe
          @last_exception = ioe
        end
      end
    end
    
    typesig { [] }
    # Closes this formatter.  If the destination implements the {@link
    # java.io.Closeable} interface, its <tt>close</tt> method will be invoked.
    # 
    # <p> Closing a formatter allows it to release resources it may be holding
    # (such as open files).  If the formatter is already closed, then invoking
    # this method has no effect.
    # 
    # <p> Attempting to invoke any methods except {@link #ioException()} in
    # this formatter after it has been closed will result in a {@link
    # FormatterClosedException}.
    def close
      if ((@a).nil?)
        return
      end
      begin
        if (@a.is_a?(Closeable))
          (@a).close
        end
      rescue IOException => ioe
        @last_exception = ioe
      ensure
        @a = nil
      end
    end
    
    typesig { [] }
    def ensure_open
      if ((@a).nil?)
        raise FormatterClosedException.new
      end
    end
    
    typesig { [] }
    # Returns the <tt>IOException</tt> last thrown by this formatter's {@link
    # Appendable}.
    # 
    # <p> If the destination's <tt>append()</tt> method never throws
    # <tt>IOException</tt>, then this method will always return <tt>null</tt>.
    # 
    # @return  The last exception thrown by the Appendable or <tt>null</tt> if
    # no such exception exists.
    def io_exception
      return @last_exception
    end
    
    typesig { [String, Object] }
    # Writes a formatted string to this object's destination using the
    # specified format string and arguments.  The locale used is the one
    # defined during the construction of this formatter.
    # 
    # @param  format
    # A format string as described in <a href="#syntax">Format string
    # syntax</a>.
    # 
    # @param  args
    # Arguments referenced by the format specifiers in the format
    # string.  If there are more arguments than format specifiers, the
    # extra arguments are ignored.  The maximum number of arguments is
    # limited by the maximum dimension of a Java array as defined by
    # the <a href="http://java.sun.com/docs/books/vmspec/">Java
    # Virtual Machine Specification</a>.
    # 
    # @throws  IllegalFormatException
    # If a format string contains an illegal syntax, a format
    # specifier that is incompatible with the given arguments,
    # insufficient arguments given the format string, or other
    # illegal conditions.  For specification of all possible
    # formatting errors, see the <a href="#detail">Details</a>
    # section of the formatter class specification.
    # 
    # @throws  FormatterClosedException
    # If this formatter has been closed by invoking its {@link
    # #close()} method
    # 
    # @return  This formatter
    def format(format, *args)
      return format(@l, format, args)
    end
    
    typesig { [Locale, String, Object] }
    # Writes a formatted string to this object's destination using the
    # specified locale, format string, and arguments.
    # 
    # @param  l
    # The {@linkplain java.util.Locale locale} to apply during
    # formatting.  If <tt>l</tt> is <tt>null</tt> then no localization
    # is applied.  This does not change this object's locale that was
    # set during construction.
    # 
    # @param  format
    # A format string as described in <a href="#syntax">Format string
    # syntax</a>
    # 
    # @param  args
    # Arguments referenced by the format specifiers in the format
    # string.  If there are more arguments than format specifiers, the
    # extra arguments are ignored.  The maximum number of arguments is
    # limited by the maximum dimension of a Java array as defined by
    # the <a href="http://java.sun.com/docs/books/vmspec/">Java
    # Virtual Machine Specification</a>
    # 
    # @throws  IllegalFormatException
    # If a format string contains an illegal syntax, a format
    # specifier that is incompatible with the given arguments,
    # insufficient arguments given the format string, or other
    # illegal conditions.  For specification of all possible
    # formatting errors, see the <a href="#detail">Details</a>
    # section of the formatter class specification.
    # 
    # @throws  FormatterClosedException
    # If this formatter has been closed by invoking its {@link
    # #close()} method
    # 
    # @return  This formatter
    def format(l, format_, *args)
      ensure_open
      # index of last argument referenced
      last = -1
      # last ordinary index
      lasto = -1
      fsa = parse(format_)
      i = 0
      while i < fsa.attr_length
        fs = fsa[i]
        index_ = fs.index
        begin
          case (index_)
          when -2
            # fixed string, "%n", or "%%"
            fs.print(nil, l)
          when -1
            # relative index
            if (last < 0 || (!(args).nil? && last > args.attr_length - 1))
              raise MissingFormatArgumentException.new(fs.to_s)
            end
            fs.print(((args).nil? ? nil : args[last]), l)
          when 0
            # ordinary index
            lasto += 1
            last = lasto
            if (!(args).nil? && lasto > args.attr_length - 1)
              raise MissingFormatArgumentException.new(fs.to_s)
            end
            fs.print(((args).nil? ? nil : args[lasto]), l)
          else
            # explicit index
            last = index_ - 1
            if (!(args).nil? && last > args.attr_length - 1)
              raise MissingFormatArgumentException.new(fs.to_s)
            end
            fs.print(((args).nil? ? nil : args[last]), l)
          end
        rescue IOException => x
          @last_exception = x
        end
        i += 1
      end
      return self
    end
    
    class_module.module_eval {
      # %[argument_index$][flags][width][.precision][t]conversion
      const_set_lazy(:FormatSpecifier) { "%(\\d+\\$)?([-#+ 0,(\\<]*)?(\\d+)?(\\.\\d+)?([tT])?([a-zA-Z%])" }
      const_attr_reader  :FormatSpecifier
      
      
      def fs_pattern
        defined?(@@fs_pattern) ? @@fs_pattern : @@fs_pattern= Pattern.compile(FormatSpecifier)
      end
      alias_method :attr_fs_pattern, :fs_pattern
      
      def fs_pattern=(value)
        @@fs_pattern = value
      end
      alias_method :attr_fs_pattern=, :fs_pattern=
    }
    
    typesig { [String] }
    # Look for format specifiers in the format string.
    def parse(s)
      al = ArrayList.new
      m = self.attr_fs_pattern.matcher(s)
      i = 0
      while (i < s.length)
        if (m.find(i))
          # Anything between the start of the string and the beginning
          # of the format specifier is either fixed text or contains
          # an invalid format string.
          if (!(m.start).equal?(i))
            # Make sure we didn't miss any invalid format specifiers
            check_text(s.substring(i, m.start))
            # Assume previous characters were fixed text
            al.add(FixedString.new_local(self, s.substring(i, m.start)))
          end
          # Expect 6 groups in regular expression
          sa = Array.typed(String).new(6) { nil }
          j = 0
          while j < m.group_count
            sa[j] = m.group(j + 1)
            j += 1
          end
          # System.out.println();
          al.add(FormatSpecifier.new_local(self, self, sa))
          i = m.end_
        else
          # No more valid format specifiers.  Check for possible invalid
          # format specifiers.
          check_text(s.substring(i))
          # The rest of the string is fixed text
          al.add(FixedString.new_local(self, s.substring(i)))
          break
        end
      end
      # FormatString[] fs = new FormatString[al.size()];
      # for (int j = 0; j < al.size(); j++)
      # System.out.println(((FormatString) al.get(j)).toString());
      return al.to_array(Array.typed(FormatString).new(0) { nil })
    end
    
    typesig { [String] }
    def check_text(s)
      idx = 0
      # If there are any '%' in the given string, we got a bad format
      # specifier.
      if (!((idx = s.index_of(Character.new(?%.ord)))).equal?(-1))
        c = (idx > s.length - 2 ? Character.new(?%.ord) : s.char_at(idx + 1))
        raise UnknownFormatConversionException.new(String.value_of(c))
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:FormatString) { Module.new do
        include_class_members Formatter
        
        typesig { [] }
        def index
          raise NotImplementedError
        end
        
        typesig { [Object, Locale] }
        def print(arg, l)
          raise NotImplementedError
        end
        
        typesig { [] }
        def to_s
          raise NotImplementedError
        end
      end }
      
      const_set_lazy(:FixedString) { Class.new do
        extend LocalClass
        include_class_members Formatter
        include FormatString
        
        attr_accessor :s
        alias_method :attr_s, :s
        undef_method :s
        alias_method :attr_s=, :s=
        undef_method :s=
        
        typesig { [String] }
        def initialize(s)
          @s = nil
          @s = s
        end
        
        typesig { [] }
        def index
          return -2
        end
        
        typesig { [Object, self::Locale] }
        def print(arg, l)
          self.attr_a.append(@s)
        end
        
        typesig { [] }
        def to_s
          return @s
        end
        
        private
        alias_method :initialize__fixed_string, :initialize
      end }
      
      const_set_lazy(:SCIENTIFIC) { BigDecimalLayoutForm::SCIENTIFIC }
      const_attr_reader  :SCIENTIFIC
      
      const_set_lazy(:DECIMAL_FLOAT) { BigDecimalLayoutForm::DECIMAL_FLOAT }
      const_attr_reader  :DECIMAL_FLOAT
      
      class BigDecimalLayoutForm 
        include_class_members Formatter
        
        class_module.module_eval {
          const_set_lazy(:SCIENTIFIC) { BigDecimalLayoutForm.new.set_value_name("SCIENTIFIC") }
          const_attr_reader  :SCIENTIFIC
          
          const_set_lazy(:DECIMAL_FLOAT) { BigDecimalLayoutForm.new.set_value_name("DECIMAL_FLOAT") }
          const_attr_reader  :DECIMAL_FLOAT
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
            [SCIENTIFIC, DECIMAL_FLOAT]
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__big_decimal_layout_form, :initialize
      end
      
      const_set_lazy(:FormatSpecifier) { Class.new do
        extend LocalClass
        include_class_members Formatter
        include FormatString
        
        attr_accessor :index
        alias_method :attr_index, :index
        undef_method :index
        alias_method :attr_index=, :index=
        undef_method :index=
        
        attr_accessor :f
        alias_method :attr_f, :f
        undef_method :f
        alias_method :attr_f=, :f=
        undef_method :f=
        
        attr_accessor :width
        alias_method :attr_width, :width
        undef_method :width
        alias_method :attr_width=, :width=
        undef_method :width=
        
        attr_accessor :precision
        alias_method :attr_precision, :precision
        undef_method :precision
        alias_method :attr_precision=, :precision=
        undef_method :precision=
        
        attr_accessor :dt
        alias_method :attr_dt, :dt
        undef_method :dt
        alias_method :attr_dt=, :dt=
        undef_method :dt=
        
        attr_accessor :c
        alias_method :attr_c, :c
        undef_method :c
        alias_method :attr_c=, :c=
        undef_method :c=
        
        attr_accessor :formatter
        alias_method :attr_formatter, :formatter
        undef_method :formatter
        alias_method :attr_formatter=, :formatter=
        undef_method :formatter=
        
        # cache the line separator
        attr_accessor :ls
        alias_method :attr_ls, :ls
        undef_method :ls
        alias_method :attr_ls=, :ls=
        undef_method :ls=
        
        typesig { [String] }
        def index(s)
          if (!(s).nil?)
            begin
              @index = JavaInteger.parse_int(s.substring(0, s.length - 1))
            rescue self.class::NumberFormatException => x
              raise AssertError if not ((false))
            end
          else
            @index = 0
          end
          return @index
        end
        
        typesig { [] }
        def index
          return @index
        end
        
        typesig { [String] }
        def flags(s)
          @f = Flags.parse(s)
          if (@f.contains(Flags::PREVIOUS))
            @index = -1
          end
          return @f
        end
        
        typesig { [] }
        def flags
          return @f
        end
        
        typesig { [String] }
        def width(s)
          @width = -1
          if (!(s).nil?)
            begin
              @width = JavaInteger.parse_int(s)
              if (@width < 0)
                raise self.class::IllegalFormatWidthException.new(@width)
              end
            rescue self.class::NumberFormatException => x
              raise AssertError if not ((false))
            end
          end
          return @width
        end
        
        typesig { [] }
        def width
          return @width
        end
        
        typesig { [String] }
        def precision(s)
          @precision = -1
          if (!(s).nil?)
            begin
              # remove the '.'
              @precision = JavaInteger.parse_int(s.substring(1))
              if (@precision < 0)
                raise self.class::IllegalFormatPrecisionException.new(@precision)
              end
            rescue self.class::NumberFormatException => x
              raise AssertError if not ((false))
            end
          end
          return @precision
        end
        
        typesig { [] }
        def precision
          return @precision
        end
        
        typesig { [String] }
        def conversion(s)
          @c = s.char_at(0)
          if (!@dt)
            if (!Conversion.is_valid(@c))
              raise self.class::UnknownFormatConversionException.new(String.value_of(@c))
            end
            if (Character.is_upper_case(@c))
              @f.add(Flags::UPPERCASE)
            end
            @c = Character.to_lower_case(@c)
            if (Conversion.is_text(@c))
              @index = -2
            end
          end
          return @c
        end
        
        typesig { [] }
        def conversion
          return @c
        end
        
        typesig { [self::Formatter, Array.typed(String)] }
        def initialize(formatter, sa)
          @index = -1
          @f = Flags::NONE
          @width = 0
          @precision = 0
          @dt = false
          @c = 0
          @formatter = nil
          @ls = nil
          @formatter = formatter
          idx = 0
          index(sa[((idx += 1) - 1)])
          flags(sa[((idx += 1) - 1)])
          width(sa[((idx += 1) - 1)])
          precision(sa[((idx += 1) - 1)])
          if (!(sa[idx]).nil?)
            @dt = true
            if ((sa[idx] == "T"))
              @f.add(Flags::UPPERCASE)
            end
          end
          conversion(sa[(idx += 1)])
          if (@dt)
            check_date_time
          else
            if (Conversion.is_general(@c))
              check_general
            else
              if (Conversion.is_character(@c))
                check_character
              else
                if (Conversion.is_integer(@c))
                  check_integer
                else
                  if (Conversion.is_float(@c))
                    check_float
                  else
                    if (Conversion.is_text(@c))
                      check_text
                    else
                      raise self.class::UnknownFormatConversionException.new(String.value_of(@c))
                    end
                  end
                end
              end
            end
          end
        end
        
        typesig { [Object, self::Locale] }
        def print(arg, l)
          if (@dt)
            print_date_time(arg, l)
            return
          end
          case (@c)
          when Conversion::DECIMAL_INTEGER, Conversion::OCTAL_INTEGER, Conversion::HEXADECIMAL_INTEGER
            print_integer(arg, l)
          when Conversion::SCIENTIFIC, Conversion::GENERAL, Conversion::DECIMAL_FLOAT, Conversion::HEXADECIMAL_FLOAT
            print_float(arg, l)
          when Conversion::CHARACTER, Conversion::CHARACTER_UPPER
            print_character(arg)
          when Conversion::BOOLEAN
            print_boolean(arg)
          when Conversion::STRING
            print_string(arg, l)
          when Conversion::HASHCODE
            print_hash_code(arg)
          when Conversion::LINE_SEPARATOR
            if ((@ls).nil?)
              @ls = RJava.cast_to_string(System.get_property("line.separator"))
            end
            self.attr_a.append(@ls)
          when Conversion::PERCENT_SIGN
            self.attr_a.append(Character.new(?%.ord))
          else
            raise AssertError if not (false)
          end
        end
        
        typesig { [Object, self::Locale] }
        def print_integer(arg, l)
          if ((arg).nil?)
            print("null")
          else
            if (arg.is_a?(self.class::Byte))
              print((arg).byte_value, l)
            else
              if (arg.is_a?(self.class::Short))
                print((arg).short_value, l)
              else
                if (arg.is_a?(self.class::JavaInteger))
                  print((arg).int_value, l)
                else
                  if (arg.is_a?(self.class::Long))
                    print((arg).long_value, l)
                  else
                    if (arg.is_a?(self.class::BigInteger))
                      print((arg), l)
                    else
                      fail_conversion(@c, arg)
                    end
                  end
                end
              end
            end
          end
        end
        
        typesig { [Object, self::Locale] }
        def print_float(arg, l)
          if ((arg).nil?)
            print("null")
          else
            if (arg.is_a?(self.class::Float))
              print((arg).float_value, l)
            else
              if (arg.is_a?(self.class::Double))
                print((arg).double_value, l)
              else
                if (arg.is_a?(self.class::BigDecimal))
                  print((arg), l)
                else
                  fail_conversion(@c, arg)
                end
              end
            end
          end
        end
        
        typesig { [Object, self::Locale] }
        def print_date_time(arg, l)
          if ((arg).nil?)
            print("null")
            return
          end
          cal = nil
          # Instead of Calendar.setLenient(true), perhaps we should
          # wrap the IllegalArgumentException that might be thrown?
          if (arg.is_a?(self.class::Long))
            # Note that the following method uses an instance of the
            # default time zone (TimeZone.getDefaultRef().
            cal = Calendar.get_instance((l).nil? ? Locale::US : l)
            cal.set_time_in_millis(arg)
          else
            if (arg.is_a?(self.class::Date))
              # Note that the following method uses an instance of the
              # default time zone (TimeZone.getDefaultRef().
              cal = Calendar.get_instance((l).nil? ? Locale::US : l)
              cal.set_time(arg)
            else
              if (arg.is_a?(self.class::Calendar))
                cal = (arg).clone
                cal.set_lenient(true)
              else
                fail_conversion(@c, arg)
              end
            end
          end
          # Use the provided locale so that invocations of
          # localizedMagnitude() use optimizations for null.
          print(cal, @c, l)
        end
        
        typesig { [Object] }
        def print_character(arg)
          if ((arg).nil?)
            print("null")
            return
          end
          s = nil
          if (arg.is_a?(self.class::Character))
            s = RJava.cast_to_string((arg).to_s)
          else
            if (arg.is_a?(self.class::Byte))
              i = (arg).byte_value
              if (Character.is_valid_code_point(i))
                s = RJava.cast_to_string(String.new(Character.to_chars(i)))
              else
                raise self.class::IllegalFormatCodePointException.new(i)
              end
            else
              if (arg.is_a?(self.class::Short))
                i = (arg).short_value
                if (Character.is_valid_code_point(i))
                  s = RJava.cast_to_string(String.new(Character.to_chars(i)))
                else
                  raise self.class::IllegalFormatCodePointException.new(i)
                end
              else
                if (arg.is_a?(self.class::JavaInteger))
                  i = (arg).int_value
                  if (Character.is_valid_code_point(i))
                    s = RJava.cast_to_string(String.new(Character.to_chars(i)))
                  else
                    raise self.class::IllegalFormatCodePointException.new(i)
                  end
                else
                  fail_conversion(@c, arg)
                end
              end
            end
          end
          print(s)
        end
        
        typesig { [Object, self::Locale] }
        def print_string(arg, l)
          if ((arg).nil?)
            print("null")
          else
            if (arg.is_a?(self.class::Formattable))
              fmt = @formatter
              if (!(@formatter.locale).equal?(l))
                fmt = self.class::Formatter.new(@formatter.out, l)
              end
              (arg).format_to(fmt, @f.value_of, @width, @precision)
            else
              print(arg.to_s)
            end
          end
        end
        
        typesig { [Object] }
        def print_boolean(arg)
          s = nil
          if (!(arg).nil?)
            s = RJava.cast_to_string(((arg.is_a?(self.class::Boolean)) ? (arg).to_s : Boolean.to_s(true)))
          else
            s = RJava.cast_to_string(Boolean.to_s(false))
          end
          print(s)
        end
        
        typesig { [Object] }
        def print_hash_code(arg)
          s = ((arg).nil? ? "null" : JavaInteger.to_hex_string(arg.hash_code))
          print(s)
        end
        
        typesig { [String] }
        def print(s)
          if (!(@precision).equal?(-1) && @precision < s.length)
            s = RJava.cast_to_string(s.substring(0, @precision))
          end
          if (@f.contains(Flags::UPPERCASE))
            s = RJava.cast_to_string(s.to_upper_case)
          end
          self.attr_a.append(justify(s))
        end
        
        typesig { [String] }
        def justify(s)
          if ((@width).equal?(-1))
            return s
          end
          sb = self.class::StringBuilder.new
          pad = @f.contains(Flags::LEFT_JUSTIFY)
          sp = @width - s.length
          if (!pad)
            i = 0
            while i < sp
              sb.append(Character.new(?\s.ord))
              i += 1
            end
          end
          sb.append(s)
          if (pad)
            i_ = 0
            while i_ < sp
              sb.append(Character.new(?\s.ord))
              i_ += 1
            end
          end
          return sb.to_s
        end
        
        typesig { [] }
        def to_s
          sb = self.class::StringBuilder.new(Character.new(?%.ord))
          # Flags.UPPERCASE is set internally for legal conversions.
          dupf = @f.dup.remove(Flags::UPPERCASE)
          sb.append(dupf.to_s)
          if (@index > 0)
            sb.append(@index).append(Character.new(?$.ord))
          end
          if (!(@width).equal?(-1))
            sb.append(@width)
          end
          if (!(@precision).equal?(-1))
            sb.append(Character.new(?..ord)).append(@precision)
          end
          if (@dt)
            sb.append(@f.contains(Flags::UPPERCASE) ? Character.new(?T.ord) : Character.new(?t.ord))
          end
          sb.append(@f.contains(Flags::UPPERCASE) ? Character.to_upper_case(@c) : @c)
          return sb.to_s
        end
        
        typesig { [] }
        def check_general
          if (((@c).equal?(Conversion::BOOLEAN) || (@c).equal?(Conversion::HASHCODE)) && @f.contains(Flags::ALTERNATE))
            fail_mismatch(Flags::ALTERNATE, @c)
          end
          # '-' requires a width
          if ((@width).equal?(-1) && @f.contains(Flags::LEFT_JUSTIFY))
            raise self.class::MissingFormatWidthException.new(to_s)
          end
          check_bad_flags(Flags::PLUS, Flags::LEADING_SPACE, Flags::ZERO_PAD, Flags::GROUP, Flags::PARENTHESES)
        end
        
        typesig { [] }
        def check_date_time
          if (!(@precision).equal?(-1))
            raise self.class::IllegalFormatPrecisionException.new(@precision)
          end
          if (!DateTime.is_valid(@c))
            raise self.class::UnknownFormatConversionException.new("t" + RJava.cast_to_string(@c))
          end
          check_bad_flags(Flags::ALTERNATE, Flags::PLUS, Flags::LEADING_SPACE, Flags::ZERO_PAD, Flags::GROUP, Flags::PARENTHESES)
          # '-' requires a width
          if ((@width).equal?(-1) && @f.contains(Flags::LEFT_JUSTIFY))
            raise self.class::MissingFormatWidthException.new(to_s)
          end
        end
        
        typesig { [] }
        def check_character
          if (!(@precision).equal?(-1))
            raise self.class::IllegalFormatPrecisionException.new(@precision)
          end
          check_bad_flags(Flags::ALTERNATE, Flags::PLUS, Flags::LEADING_SPACE, Flags::ZERO_PAD, Flags::GROUP, Flags::PARENTHESES)
          # '-' requires a width
          if ((@width).equal?(-1) && @f.contains(Flags::LEFT_JUSTIFY))
            raise self.class::MissingFormatWidthException.new(to_s)
          end
        end
        
        typesig { [] }
        def check_integer
          check_numeric
          if (!(@precision).equal?(-1))
            raise self.class::IllegalFormatPrecisionException.new(@precision)
          end
          if ((@c).equal?(Conversion::DECIMAL_INTEGER))
            check_bad_flags(Flags::ALTERNATE)
          else
            if ((@c).equal?(Conversion::OCTAL_INTEGER))
              check_bad_flags(Flags::GROUP)
            else
              check_bad_flags(Flags::GROUP)
            end
          end
        end
        
        typesig { [self::Flags] }
        def check_bad_flags(*bad_flags)
          i = 0
          while i < bad_flags.attr_length
            if (@f.contains(bad_flags[i]))
              fail_mismatch(bad_flags[i], @c)
            end
            i += 1
          end
        end
        
        typesig { [] }
        def check_float
          check_numeric
          if ((@c).equal?(Conversion::DECIMAL_FLOAT))
          else
            if ((@c).equal?(Conversion::HEXADECIMAL_FLOAT))
              check_bad_flags(Flags::PARENTHESES, Flags::GROUP)
            else
              if ((@c).equal?(Conversion::SCIENTIFIC))
                check_bad_flags(Flags::GROUP)
              else
                if ((@c).equal?(Conversion::GENERAL))
                  check_bad_flags(Flags::ALTERNATE)
                end
              end
            end
          end
        end
        
        typesig { [] }
        def check_numeric
          if (!(@width).equal?(-1) && @width < 0)
            raise self.class::IllegalFormatWidthException.new(@width)
          end
          if (!(@precision).equal?(-1) && @precision < 0)
            raise self.class::IllegalFormatPrecisionException.new(@precision)
          end
          # '-' and '0' require a width
          if ((@width).equal?(-1) && (@f.contains(Flags::LEFT_JUSTIFY) || @f.contains(Flags::ZERO_PAD)))
            raise self.class::MissingFormatWidthException.new(to_s)
          end
          # bad combination
          if ((@f.contains(Flags::PLUS) && @f.contains(Flags::LEADING_SPACE)) || (@f.contains(Flags::LEFT_JUSTIFY) && @f.contains(Flags::ZERO_PAD)))
            raise self.class::IllegalFormatFlagsException.new(@f.to_s)
          end
        end
        
        typesig { [] }
        def check_text
          if (!(@precision).equal?(-1))
            raise self.class::IllegalFormatPrecisionException.new(@precision)
          end
          case (@c)
          when Conversion::PERCENT_SIGN
            if (!(@f.value_of).equal?(Flags::LEFT_JUSTIFY.value_of) && !(@f.value_of).equal?(Flags::NONE.value_of))
              raise self.class::IllegalFormatFlagsException.new(@f.to_s)
            end
            # '-' requires a width
            if ((@width).equal?(-1) && @f.contains(Flags::LEFT_JUSTIFY))
              raise self.class::MissingFormatWidthException.new(to_s)
            end
          when Conversion::LINE_SEPARATOR
            if (!(@width).equal?(-1))
              raise self.class::IllegalFormatWidthException.new(@width)
            end
            if (!(@f.value_of).equal?(Flags::NONE.value_of))
              raise self.class::IllegalFormatFlagsException.new(@f.to_s)
            end
          else
            raise AssertError if not (false)
          end
        end
        
        typesig { [::Java::Byte, self::Locale] }
        def print(value, l)
          v = value
          if (value < 0 && ((@c).equal?(Conversion::OCTAL_INTEGER) || (@c).equal?(Conversion::HEXADECIMAL_INTEGER)))
            v += (1 << 8)
            raise AssertError, RJava.cast_to_string(v) if not (v >= 0)
          end
          print(v, l)
        end
        
        typesig { [::Java::Short, self::Locale] }
        def print(value, l)
          v = value
          if (value < 0 && ((@c).equal?(Conversion::OCTAL_INTEGER) || (@c).equal?(Conversion::HEXADECIMAL_INTEGER)))
            v += (1 << 16)
            raise AssertError, RJava.cast_to_string(v) if not (v >= 0)
          end
          print(v, l)
        end
        
        typesig { [::Java::Int, self::Locale] }
        def print(value, l)
          v = value
          if (value < 0 && ((@c).equal?(Conversion::OCTAL_INTEGER) || (@c).equal?(Conversion::HEXADECIMAL_INTEGER)))
            v += (1 << 32)
            raise AssertError, RJava.cast_to_string(v) if not (v >= 0)
          end
          print(v, l)
        end
        
        typesig { [::Java::Long, self::Locale] }
        def print(value, l)
          sb = self.class::StringBuilder.new
          if ((@c).equal?(Conversion::DECIMAL_INTEGER))
            neg = value < 0
            va = nil
            if (value < 0)
              va = Long.to_s(value, 10).substring(1).to_char_array
            else
              va = Long.to_s(value, 10).to_char_array
            end
            # leading sign indicator
            leading_sign(sb, neg)
            # the value
            localized_magnitude(sb, va, @f, adjust_width(@width, @f, neg), l)
            # trailing sign indicator
            trailing_sign(sb, neg)
          else
            if ((@c).equal?(Conversion::OCTAL_INTEGER))
              check_bad_flags(Flags::PARENTHESES, Flags::LEADING_SPACE, Flags::PLUS)
              s = Long.to_octal_string(value)
              len = (@f.contains(Flags::ALTERNATE) ? s.length + 1 : s.length)
              # apply ALTERNATE (radix indicator for octal) before ZERO_PAD
              if (@f.contains(Flags::ALTERNATE))
                sb.append(Character.new(?0.ord))
              end
              if (@f.contains(Flags::ZERO_PAD))
                i = 0
                while i < @width - len
                  sb.append(Character.new(?0.ord))
                  i += 1
                end
              end
              sb.append(s)
            else
              if ((@c).equal?(Conversion::HEXADECIMAL_INTEGER))
                check_bad_flags(Flags::PARENTHESES, Flags::LEADING_SPACE, Flags::PLUS)
                s = Long.to_hex_string(value)
                len = (@f.contains(Flags::ALTERNATE) ? s.length + 2 : s.length)
                # apply ALTERNATE (radix indicator for hex) before ZERO_PAD
                if (@f.contains(Flags::ALTERNATE))
                  sb.append(@f.contains(Flags::UPPERCASE) ? "0X" : "0x")
                end
                if (@f.contains(Flags::ZERO_PAD))
                  i = 0
                  while i < @width - len
                    sb.append(Character.new(?0.ord))
                    i += 1
                  end
                end
                if (@f.contains(Flags::UPPERCASE))
                  s = RJava.cast_to_string(s.to_upper_case)
                end
                sb.append(s)
              end
            end
          end
          # justify based on width
          self.attr_a.append(justify(sb.to_s))
        end
        
        typesig { [self::StringBuilder, ::Java::Boolean] }
        # neg := val < 0
        def leading_sign(sb, neg)
          if (!neg)
            if (@f.contains(Flags::PLUS))
              sb.append(Character.new(?+.ord))
            else
              if (@f.contains(Flags::LEADING_SPACE))
                sb.append(Character.new(?\s.ord))
              end
            end
          else
            if (@f.contains(Flags::PARENTHESES))
              sb.append(Character.new(?(.ord))
            else
              sb.append(Character.new(?-.ord))
            end
          end
          return sb
        end
        
        typesig { [self::StringBuilder, ::Java::Boolean] }
        # neg := val < 0
        def trailing_sign(sb, neg)
          if (neg && @f.contains(Flags::PARENTHESES))
            sb.append(Character.new(?).ord))
          end
          return sb
        end
        
        typesig { [self::BigInteger, self::Locale] }
        def print(value, l)
          sb = self.class::StringBuilder.new
          neg = (value.signum).equal?(-1)
          v = value.abs
          # leading sign indicator
          leading_sign(sb, neg)
          # the value
          if ((@c).equal?(Conversion::DECIMAL_INTEGER))
            va = v.to_s.to_char_array
            localized_magnitude(sb, va, @f, adjust_width(@width, @f, neg), l)
          else
            if ((@c).equal?(Conversion::OCTAL_INTEGER))
              s = v.to_s(8)
              len = s.length + sb.length
              if (neg && @f.contains(Flags::PARENTHESES))
                len += 1
              end
              # apply ALTERNATE (radix indicator for octal) before ZERO_PAD
              if (@f.contains(Flags::ALTERNATE))
                len += 1
                sb.append(Character.new(?0.ord))
              end
              if (@f.contains(Flags::ZERO_PAD))
                i = 0
                while i < @width - len
                  sb.append(Character.new(?0.ord))
                  i += 1
                end
              end
              sb.append(s)
            else
              if ((@c).equal?(Conversion::HEXADECIMAL_INTEGER))
                s = v.to_s(16)
                len = s.length + sb.length
                if (neg && @f.contains(Flags::PARENTHESES))
                  len += 1
                end
                # apply ALTERNATE (radix indicator for hex) before ZERO_PAD
                if (@f.contains(Flags::ALTERNATE))
                  len += 2
                  sb.append(@f.contains(Flags::UPPERCASE) ? "0X" : "0x")
                end
                if (@f.contains(Flags::ZERO_PAD))
                  i = 0
                  while i < @width - len
                    sb.append(Character.new(?0.ord))
                    i += 1
                  end
                end
                if (@f.contains(Flags::UPPERCASE))
                  s = RJava.cast_to_string(s.to_upper_case)
                end
                sb.append(s)
              end
            end
          end
          # trailing sign indicator
          trailing_sign(sb, ((value.signum).equal?(-1)))
          # justify based on width
          self.attr_a.append(justify(sb.to_s))
        end
        
        typesig { [::Java::Float, self::Locale] }
        def print(value, l)
          print((value).to_f, l)
        end
        
        typesig { [::Java::Double, self::Locale] }
        def print(value, l)
          sb = self.class::StringBuilder.new
          neg = (Double.compare(value, 0.0)).equal?(-1)
          if (!Double.is_na_n(value))
            v = Math.abs(value)
            # leading sign indicator
            leading_sign(sb, neg)
            # the value
            if (!Double.is_infinite(v))
              print(sb, v, l, @f, @c, @precision, neg)
            else
              sb.append(@f.contains(Flags::UPPERCASE) ? "INFINITY" : "Infinity")
            end
            # trailing sign indicator
            trailing_sign(sb, neg)
          else
            sb.append(@f.contains(Flags::UPPERCASE) ? "NAN" : "NaN")
          end
          # justify based on width
          self.attr_a.append(justify(sb.to_s))
        end
        
        typesig { [self::StringBuilder, ::Java::Double, self::Locale, self::Flags, ::Java::Char, ::Java::Int, ::Java::Boolean] }
        # !Double.isInfinite(value) && !Double.isNaN(value)
        def print(sb, value, l, f, c, precision_, neg)
          if ((c).equal?(Conversion::SCIENTIFIC))
            # Create a new FormattedFloatingDecimal with the desired
            # precision.
            prec = ((precision_).equal?(-1) ? 6 : precision_)
            fd = self.class::FormattedFloatingDecimal.new(value, prec, FormattedFloatingDecimal::Form::SCIENTIFIC)
            v = CharArray.new(MAX_FD_CHARS)
            len = fd.get_chars(v)
            mant = add_zeros(mantissa(v, len), prec)
            # If the precision is zero and the '#' flag is set, add the
            # requested decimal point.
            if (f.contains(Flags::ALTERNATE) && ((prec).equal?(0)))
              mant = add_dot(mant)
            end
            exp = ((value).equal?(0.0)) ? Array.typed(::Java::Char).new([Character.new(?+.ord), Character.new(?0.ord), Character.new(?0.ord)]) : exponent(v, len)
            new_w = @width
            if (!(@width).equal?(-1))
              new_w = adjust_width(@width - exp.attr_length - 1, f, neg)
            end
            localized_magnitude(sb, mant, f, new_w, l)
            sb.append(f.contains(Flags::UPPERCASE) ? Character.new(?E.ord) : Character.new(?e.ord))
            flags_ = f.dup.remove(Flags::GROUP)
            sign = exp[0]
            raise AssertError if not (((sign).equal?(Character.new(?+.ord)) || (sign).equal?(Character.new(?-.ord))))
            sb.append(sign)
            tmp = CharArray.new(exp.attr_length - 1)
            System.arraycopy(exp, 1, tmp, 0, exp.attr_length - 1)
            sb.append(localized_magnitude(nil, tmp, flags_, -1, l))
          else
            if ((c).equal?(Conversion::DECIMAL_FLOAT))
              # Create a new FormattedFloatingDecimal with the desired
              # precision.
              prec = ((precision_).equal?(-1) ? 6 : precision_)
              fd = self.class::FormattedFloatingDecimal.new(value, prec, FormattedFloatingDecimal::Form::DECIMAL_FLOAT)
              # MAX_FD_CHARS + 1 (round?)
              v = CharArray.new(MAX_FD_CHARS + 1 + Math.abs(fd.get_exponent))
              len = fd.get_chars(v)
              mant = add_zeros(mantissa(v, len), prec)
              # If the precision is zero and the '#' flag is set, add the
              # requested decimal point.
              if (f.contains(Flags::ALTERNATE) && ((prec).equal?(0)))
                mant = add_dot(mant)
              end
              new_w = @width
              if (!(@width).equal?(-1))
                new_w = adjust_width(@width, f, neg)
              end
              localized_magnitude(sb, mant, f, new_w, l)
            else
              if ((c).equal?(Conversion::GENERAL))
                prec = precision_
                if ((precision_).equal?(-1))
                  prec = 6
                else
                  if ((precision_).equal?(0))
                    prec = 1
                  end
                end
                fd = self.class::FormattedFloatingDecimal.new(value, prec, FormattedFloatingDecimal::Form::GENERAL)
                # MAX_FD_CHARS + 1 (round?)
                v = CharArray.new(MAX_FD_CHARS + 1 + Math.abs(fd.get_exponent))
                len = fd.get_chars(v)
                exp = exponent(v, len)
                if (!(exp).nil?)
                  prec -= 1
                else
                  prec = prec - ((value).equal?(0) ? 0 : fd.get_exponent_rounded) - 1
                end
                mant = add_zeros(mantissa(v, len), prec)
                # If the precision is zero and the '#' flag is set, add the
                # requested decimal point.
                if (f.contains(Flags::ALTERNATE) && ((prec).equal?(0)))
                  mant = add_dot(mant)
                end
                new_w = @width
                if (!(@width).equal?(-1))
                  if (!(exp).nil?)
                    new_w = adjust_width(@width - exp.attr_length - 1, f, neg)
                  else
                    new_w = adjust_width(@width, f, neg)
                  end
                end
                localized_magnitude(sb, mant, f, new_w, l)
                if (!(exp).nil?)
                  sb.append(f.contains(Flags::UPPERCASE) ? Character.new(?E.ord) : Character.new(?e.ord))
                  flags_ = f.dup.remove(Flags::GROUP)
                  sign = exp[0]
                  raise AssertError if not (((sign).equal?(Character.new(?+.ord)) || (sign).equal?(Character.new(?-.ord))))
                  sb.append(sign)
                  tmp = CharArray.new(exp.attr_length - 1)
                  System.arraycopy(exp, 1, tmp, 0, exp.attr_length - 1)
                  sb.append(localized_magnitude(nil, tmp, flags_, -1, l))
                end
              else
                if ((c).equal?(Conversion::HEXADECIMAL_FLOAT))
                  prec = precision_
                  if ((precision_).equal?(-1))
                    # assume that we want all of the digits
                    prec = 0
                  else
                    if ((precision_).equal?(0))
                      prec = 1
                    end
                  end
                  s = hex_double(value, prec)
                  va = nil
                  upper = f.contains(Flags::UPPERCASE)
                  sb.append(upper ? "0X" : "0x")
                  if (f.contains(Flags::ZERO_PAD))
                    i = 0
                    while i < @width - s.length - 2
                      sb.append(Character.new(?0.ord))
                      i += 1
                    end
                  end
                  idx = s.index_of(Character.new(?p.ord))
                  va = s.substring(0, idx).to_char_array
                  if (upper)
                    tmp = String.new(va)
                    # don't localize hex
                    tmp = RJava.cast_to_string(tmp.to_upper_case(Locale::US))
                    va = tmp.to_char_array
                  end
                  sb.append(!(prec).equal?(0) ? add_zeros(va, prec) : va)
                  sb.append(upper ? Character.new(?P.ord) : Character.new(?p.ord))
                  sb.append(s.substring(idx + 1))
                end
              end
            end
          end
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int] }
        def mantissa(v, len)
          i = 0
          i = 0
          while i < len
            if ((v[i]).equal?(Character.new(?e.ord)))
              break
            end
            i += 1
          end
          tmp = CharArray.new(i)
          System.arraycopy(v, 0, tmp, 0, i)
          return tmp
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int] }
        def exponent(v, len)
          i = 0
          i = len - 1
          while i >= 0
            if ((v[i]).equal?(Character.new(?e.ord)))
              break
            end
            i -= 1
          end
          if ((i).equal?(-1))
            return nil
          end
          tmp = CharArray.new(len - i - 1)
          System.arraycopy(v, i + 1, tmp, 0, len - i - 1)
          return tmp
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int] }
        # Add zeros to the requested precision.
        def add_zeros(v, prec)
          # Look for the dot.  If we don't find one, the we'll need to add
          # it before we add the zeros.
          i = 0
          i = 0
          while i < v.attr_length
            if ((v[i]).equal?(Character.new(?..ord)))
              break
            end
            i += 1
          end
          need_dot = false
          if ((i).equal?(v.attr_length))
            need_dot = true
          end
          # Determine existing precision.
          out_prec = v.attr_length - i - (need_dot ? 0 : 1)
          raise AssertError if not ((out_prec <= prec))
          if ((out_prec).equal?(prec))
            return v
          end
          # Create new array with existing contents.
          tmp = CharArray.new(v.attr_length + prec - out_prec + (need_dot ? 1 : 0))
          System.arraycopy(v, 0, tmp, 0, v.attr_length)
          # Add dot if previously determined to be necessary.
          start = v.attr_length
          if (need_dot)
            tmp[v.attr_length] = Character.new(?..ord)
            start += 1
          end
          # Add zeros.
          j = start
          while j < tmp.attr_length
            tmp[j] = Character.new(?0.ord)
            j += 1
          end
          return tmp
        end
        
        typesig { [::Java::Double, ::Java::Int] }
        # Method assumes that d > 0.
        def hex_double(d, prec)
          # Let Double.toHexString handle simple cases
          if (!FpUtils.is_finite(d) || (d).equal?(0.0) || (prec).equal?(0) || prec >= 13)
            # remove "0x"
            return Double.to_hex_string(d).substring(2)
          else
            raise AssertError if not ((prec >= 1 && prec <= 12))
            exponent_ = FpUtils.get_exponent(d)
            subnormal = ((exponent_).equal?(DoubleConsts::MIN_EXPONENT - 1))
            # If this is subnormal input so normalize (could be faster to
            # do as integer operation).
            if (subnormal)
              self.attr_scale_up = FpUtils.scalb(1.0, 54)
              d *= self.attr_scale_up
              # Calculate the exponent.  This is not just exponent + 54
              # since the former is not the normalized exponent.
              exponent_ = FpUtils.get_exponent(d)
              raise AssertError, RJava.cast_to_string(exponent_) if not (exponent_ >= DoubleConsts::MIN_EXPONENT && exponent_ <= DoubleConsts::MAX_EXPONENT)
            end
            precision_ = 1 + prec * 4
            shift_distance = DoubleConsts::SIGNIFICAND_WIDTH - precision_
            raise AssertError if not ((shift_distance >= 1 && shift_distance < DoubleConsts::SIGNIFICAND_WIDTH))
            doppel = Double.double_to_long_bits(d)
            # Deterime the number of bits to keep.
            new_signif = (doppel & (DoubleConsts::EXP_BIT_MASK | DoubleConsts::SIGNIF_BIT_MASK)) >> shift_distance
            # Bits to round away.
            rounding_bits = doppel & ~(~0 << shift_distance)
            # To decide how to round, look at the low-order bit of the
            # working significand, the highest order discarded bit (the
            # round bit) and whether any of the lower order discarded bits
            # are nonzero (the sticky bit).
            least_zero = ((new_signif & 0x1)).equal?(0)
            round = !(((1 << (shift_distance - 1)) & rounding_bits)).equal?(0)
            sticky = shift_distance > 1 && !((~(1 << (shift_distance - 1)) & rounding_bits)).equal?(0)
            if ((least_zero && round && sticky) || (!least_zero && round))
              new_signif += 1
            end
            sign_bit = doppel & DoubleConsts::SIGN_BIT_MASK
            new_signif = sign_bit | (new_signif << shift_distance)
            result = Double.long_bits_to_double(new_signif)
            if (Double.is_infinite(result))
              # Infinite result generated by rounding
              return "1.0p1024"
            else
              res = Double.to_hex_string(result).substring(2)
              if (!subnormal)
                return res
              else
                # Create a normalized subnormal string.
                idx = res.index_of(Character.new(?p.ord))
                if ((idx).equal?(-1))
                  # No 'p' character in hex string.
                  raise AssertError if not (false)
                  return nil
                else
                  # Get exponent and append at the end.
                  exp = res.substring(idx + 1)
                  iexp = JavaInteger.parse_int(exp) - 54
                  return RJava.cast_to_string(res.substring(0, idx)) + "p" + RJava.cast_to_string(JavaInteger.to_s(iexp))
                end
              end
            end
          end
        end
        
        typesig { [self::BigDecimal, self::Locale] }
        def print(value, l)
          if ((@c).equal?(Conversion::HEXADECIMAL_FLOAT))
            fail_conversion(@c, value)
          end
          sb = self.class::StringBuilder.new
          neg = (value.signum).equal?(-1)
          v = value.abs
          # leading sign indicator
          leading_sign(sb, neg)
          # the value
          print(sb, v, l, @f, @c, @precision, neg)
          # trailing sign indicator
          trailing_sign(sb, neg)
          # justify based on width
          self.attr_a.append(justify(sb.to_s))
        end
        
        typesig { [self::StringBuilder, self::BigDecimal, self::Locale, self::Flags, ::Java::Char, ::Java::Int, ::Java::Boolean] }
        # value > 0
        def print(sb, value, l, f, c, precision_, neg)
          if ((c).equal?(Conversion::SCIENTIFIC))
            # Create a new BigDecimal with the desired precision.
            prec = ((precision_).equal?(-1) ? 6 : precision_)
            scale_ = value.scale
            orig_prec = value.precision
            nzeros = 0
            comp_prec = 0
            if (prec > orig_prec - 1)
              comp_prec = orig_prec
              nzeros = prec - (orig_prec - 1)
            else
              comp_prec = prec + 1
            end
            mc = self.class::MathContext.new(comp_prec)
            v = self.class::BigDecimal.new(value.unscaled_value, scale_, mc)
            bdl = self.class::BigDecimalLayout.new_local(self, v.unscaled_value, v.scale, BigDecimalLayoutForm::SCIENTIFIC)
            mant = bdl.mantissa
            # Add a decimal point if necessary.  The mantissa may not
            # contain a decimal point if the scale is zero (the internal
            # representation has no fractional part) or the original
            # precision is one. Append a decimal point if '#' is set or if
            # we require zero padding to get to the requested precision.
            if (((orig_prec).equal?(1) || !bdl.has_dot) && (nzeros > 0 || (f.contains(Flags::ALTERNATE))))
              mant = add_dot(mant)
            end
            # Add trailing zeros in the case precision is greater than
            # the number of available digits after the decimal separator.
            mant = trailing_zeros(mant, nzeros)
            exp = bdl.exponent
            new_w = @width
            if (!(@width).equal?(-1))
              new_w = adjust_width(@width - exp.attr_length - 1, f, neg)
            end
            localized_magnitude(sb, mant, f, new_w, l)
            sb.append(f.contains(Flags::UPPERCASE) ? Character.new(?E.ord) : Character.new(?e.ord))
            flags_ = f.dup.remove(Flags::GROUP)
            sign = exp[0]
            raise AssertError if not (((sign).equal?(Character.new(?+.ord)) || (sign).equal?(Character.new(?-.ord))))
            sb.append(exp[0])
            tmp = CharArray.new(exp.attr_length - 1)
            System.arraycopy(exp, 1, tmp, 0, exp.attr_length - 1)
            sb.append(localized_magnitude(nil, tmp, flags_, -1, l))
          else
            if ((c).equal?(Conversion::DECIMAL_FLOAT))
              # Create a new BigDecimal with the desired precision.
              prec = ((precision_).equal?(-1) ? 6 : precision_)
              scale_ = value.scale
              comp_prec = value.precision
              if (scale_ > prec)
                comp_prec -= (scale_ - prec)
              end
              mc = self.class::MathContext.new(comp_prec)
              v = self.class::BigDecimal.new(value.unscaled_value, scale_, mc)
              bdl = self.class::BigDecimalLayout.new_local(self, v.unscaled_value, v.scale, BigDecimalLayoutForm::DECIMAL_FLOAT)
              mant = bdl.mantissa
              nzeros = (bdl.scale < prec ? prec - bdl.scale : 0)
              # Add a decimal point if necessary.  The mantissa may not
              # contain a decimal point if the scale is zero (the internal
              # representation has no fractional part).  Append a decimal
              # point if '#' is set or we require zero padding to get to the
              # requested precision.
              if ((bdl.scale).equal?(0) && (f.contains(Flags::ALTERNATE) || nzeros > 0))
                mant = add_dot(bdl.mantissa)
              end
              # Add trailing zeros if the precision is greater than the
              # number of available digits after the decimal separator.
              mant = trailing_zeros(mant, nzeros)
              localized_magnitude(sb, mant, f, adjust_width(@width, f, neg), l)
            else
              if ((c).equal?(Conversion::GENERAL))
                prec = precision_
                if ((precision_).equal?(-1))
                  prec = 6
                else
                  if ((precision_).equal?(0))
                    prec = 1
                  end
                end
                ten_to_the_neg_four = BigDecimal.value_of(1, 4)
                ten_to_the_prec = BigDecimal.value_of(1, -prec)
                if (((value == BigDecimal::ZERO)) || ((!((value <=> ten_to_the_neg_four)).equal?(-1)) && (((value <=> ten_to_the_prec)).equal?(-1))))
                  e = -value.scale + (value.unscaled_value.to_s.length - 1)
                  # xxx.yyy
                  # g precision (# sig digits) = #x + #y
                  # f precision = #y
                  # exponent = #x - 1
                  # => f precision = g precision - exponent - 1
                  # 0.000zzz
                  # g precision (# sig digits) = #z
                  # f precision = #0 (after '.') + #z
                  # exponent = - #0 (after '.') - 1
                  # => f precision = g precision - exponent - 1
                  prec = prec - e - 1
                  print(sb, value, l, f, Conversion::DECIMAL_FLOAT, prec, neg)
                else
                  print(sb, value, l, f, Conversion::SCIENTIFIC, prec - 1, neg)
                end
              else
                if ((c).equal?(Conversion::HEXADECIMAL_FLOAT))
                  # This conversion isn't supported.  The error should be
                  # reported earlier.
                  raise AssertError if not (false)
                end
              end
            end
          end
        end
        
        class_module.module_eval {
          const_set_lazy(:BigDecimalLayout) { Class.new do
            extend LocalClass
            include_class_members FormatSpecifier
            
            attr_accessor :mant
            alias_method :attr_mant, :mant
            undef_method :mant
            alias_method :attr_mant=, :mant=
            undef_method :mant=
            
            attr_accessor :exp
            alias_method :attr_exp, :exp
            undef_method :exp
            alias_method :attr_exp=, :exp=
            undef_method :exp=
            
            attr_accessor :dot
            alias_method :attr_dot, :dot
            undef_method :dot
            alias_method :attr_dot=, :dot=
            undef_method :dot=
            
            attr_accessor :scale
            alias_method :attr_scale, :scale
            undef_method :scale
            alias_method :attr_scale=, :scale=
            undef_method :scale=
            
            typesig { [self::BigInteger, ::Java::Int, self::BigDecimalLayoutForm] }
            def initialize(int_val, scale, form)
              @mant = nil
              @exp = nil
              @dot = false
              @scale = 0
              layout(int_val, scale, form)
            end
            
            typesig { [] }
            def has_dot
              return @dot
            end
            
            typesig { [] }
            def scale
              return @scale
            end
            
            typesig { [] }
            # char[] with canonical string representation
            def layout_chars
              sb = self.class::StringBuilder.new(@mant)
              if (!(@exp).nil?)
                sb.append(Character.new(?E.ord))
                sb.append(@exp)
              end
              return to_char_array(sb)
            end
            
            typesig { [] }
            def mantissa
              return to_char_array(@mant)
            end
            
            typesig { [] }
            # The exponent will be formatted as a sign ('+' or '-') followed
            # by the exponent zero-padded to include at least two digits.
            def exponent
              return to_char_array(@exp)
            end
            
            typesig { [self::StringBuilder] }
            def to_char_array(sb)
              if ((sb).nil?)
                return nil
              end
              result = CharArray.new(sb.length)
              sb.get_chars(0, result.attr_length, result, 0)
              return result
            end
            
            typesig { [self::BigInteger, ::Java::Int, self::BigDecimalLayoutForm] }
            def layout(int_val, scale, form)
              coeff = int_val.to_s.to_char_array
              @scale = scale
              # Construct a buffer, with sufficient capacity for all cases.
              # If E-notation is needed, length will be: +1 if negative, +1
              # if '.' needed, +2 for "E+", + up to 10 for adjusted
              # exponent.  Otherwise it could have +1 if negative, plus
              # leading "0.00000"
              @mant = self.class::StringBuilder.new(coeff.attr_length + 14)
              if ((scale).equal?(0))
                len = coeff.attr_length
                if (len > 1)
                  @mant.append(coeff[0])
                  if ((form).equal?(BigDecimalLayoutForm::SCIENTIFIC))
                    @mant.append(Character.new(?..ord))
                    @dot = true
                    @mant.append(coeff, 1, len - 1)
                    @exp = self.class::StringBuilder.new("+")
                    if (len < 10)
                      @exp.append("0").append(len - 1)
                    else
                      @exp.append(len - 1)
                    end
                  else
                    @mant.append(coeff, 1, len - 1)
                  end
                else
                  @mant.append(coeff)
                  if ((form).equal?(BigDecimalLayoutForm::SCIENTIFIC))
                    @exp = self.class::StringBuilder.new("+00")
                  end
                end
                return
              end
              adjusted = -scale + (coeff.attr_length - 1)
              if ((form).equal?(BigDecimalLayoutForm::DECIMAL_FLOAT))
                # count of padding zeros
                pad = scale - coeff.attr_length
                if (pad >= 0)
                  # 0.xxx form
                  @mant.append("0.")
                  @dot = true
                  while pad > 0
                    @mant.append(Character.new(?0.ord))
                    pad -= 1
                  end
                  @mant.append(coeff)
                else
                  if (-pad < coeff.attr_length)
                    # xx.xx form
                    @mant.append(coeff, 0, -pad)
                    @mant.append(Character.new(?..ord))
                    @dot = true
                    @mant.append(coeff, -pad, scale)
                  else
                    # xx form
                    @mant.append(coeff, 0, coeff.attr_length)
                    i = 0
                    while i < -scale
                      @mant.append(Character.new(?0.ord))
                      i += 1
                    end
                    @scale = 0
                  end
                end
              else
                # x.xxx form
                @mant.append(coeff[0])
                if (coeff.attr_length > 1)
                  @mant.append(Character.new(?..ord))
                  @dot = true
                  @mant.append(coeff, 1, coeff.attr_length - 1)
                end
                @exp = self.class::StringBuilder.new
                if (!(adjusted).equal?(0))
                  abs_ = Math.abs(adjusted)
                  # require sign
                  @exp.append(adjusted < 0 ? Character.new(?-.ord) : Character.new(?+.ord))
                  if (abs_ < 10)
                    @exp.append(Character.new(?0.ord))
                  end
                  @exp.append(abs_)
                else
                  @exp.append("+00")
                end
              end
            end
            
            private
            alias_method :initialize__big_decimal_layout, :initialize
          end }
        }
        
        typesig { [::Java::Int, self::Flags, ::Java::Boolean] }
        def adjust_width(width_, f, neg)
          new_w = width_
          if (!(new_w).equal?(-1) && neg && f.contains(Flags::PARENTHESES))
            new_w -= 1
          end
          return new_w
        end
        
        typesig { [Array.typed(::Java::Char)] }
        # Add a '.' to th mantissa if required
        def add_dot(mant)
          tmp = mant
          tmp = CharArray.new(mant.attr_length + 1)
          System.arraycopy(mant, 0, tmp, 0, mant.attr_length)
          tmp[tmp.attr_length - 1] = Character.new(?..ord)
          return tmp
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int] }
        # Add trailing zeros in the case precision is greater than the number
        # of available digits after the decimal separator.
        def trailing_zeros(mant, nzeros)
          tmp = mant
          if (nzeros > 0)
            tmp = CharArray.new(mant.attr_length + nzeros)
            System.arraycopy(mant, 0, tmp, 0, mant.attr_length)
            i = mant.attr_length
            while i < tmp.attr_length
              tmp[i] = Character.new(?0.ord)
              i += 1
            end
          end
          return tmp
        end
        
        typesig { [self::Calendar, ::Java::Char, self::Locale] }
        def print(t, c, l)
          sb = self.class::StringBuilder.new
          print(sb, t, c, l)
          # justify based on width
          s = justify(sb.to_s)
          if (@f.contains(Flags::UPPERCASE))
            s = RJava.cast_to_string(s.to_upper_case)
          end
          self.attr_a.append(s)
        end
        
        typesig { [self::StringBuilder, self::Calendar, ::Java::Char, self::Locale] }
        def print(sb, t, c, l)
          raise AssertError if not (((@width).equal?(-1)))
          if ((sb).nil?)
            sb = self.class::StringBuilder.new
          end
          case (c)
          # 'H' (00 - 23)
          # 'I' (01 - 12)
          # 'k' (0 - 23) -- like H
          # Date
          # 'a'
          # 'b'
          # 'h' -- same b
          # 'C' (00 - 99)
          # 'y' (00 - 99)
          # 'd' (01 - 31)
          # Composites
          # 'T' (24 hour hh:mm:ss - %tH:%tM:%tS)
          when DateTime::HOUR_OF_DAY_0, DateTime::HOUR_0, DateTime::HOUR_OF_DAY, DateTime::HOUR
            # 'l' (1 - 12) -- like I
            i = t.get(Calendar::HOUR_OF_DAY)
            if ((c).equal?(DateTime::HOUR_0) || (c).equal?(DateTime::HOUR))
              i = ((i).equal?(0) || (i).equal?(12) ? 12 : i % 12)
            end
            flags_ = ((c).equal?(DateTime::HOUR_OF_DAY_0) || (c).equal?(DateTime::HOUR_0) ? Flags::ZERO_PAD : Flags::NONE)
            sb.append(localized_magnitude(nil, i, flags_, 2, l))
          when DateTime::MINUTE
            # 'M' (00 - 59)
            i = t.get(Calendar::MINUTE)
            flags_ = Flags::ZERO_PAD
            sb.append(localized_magnitude(nil, i, flags_, 2, l))
          when DateTime::NANOSECOND
            # 'N' (000000000 - 999999999)
            i = t.get(Calendar::MILLISECOND) * 1000000
            flags_ = Flags::ZERO_PAD
            sb.append(localized_magnitude(nil, i, flags_, 9, l))
          when DateTime::MILLISECOND
            # 'L' (000 - 999)
            i = t.get(Calendar::MILLISECOND)
            flags_ = Flags::ZERO_PAD
            sb.append(localized_magnitude(nil, i, flags_, 3, l))
          when DateTime::MILLISECOND_SINCE_EPOCH
            # 'Q' (0 - 99...?)
            i = t.get_time_in_millis
            flags_ = Flags::NONE
            sb.append(localized_magnitude(nil, i, flags_, @width, l))
          when DateTime::AM_PM
            # 'p' (am or pm)
            # Calendar.AM = 0, Calendar.PM = 1, LocaleElements defines upper
            ampm = Array.typed(String).new(["AM", "PM"])
            if (!(l).nil? && !(l).equal?(Locale::US))
              dfs = DateFormatSymbols.get_instance(l)
              ampm = dfs.get_am_pm_strings
            end
            s = ampm[t.get(Calendar::AM_PM)]
            sb.append(s.to_lower_case(!(l).nil? ? l : Locale::US))
          when DateTime::SECONDS_SINCE_EPOCH
            # 's' (0 - 99...?)
            i = t.get_time_in_millis / 1000
            flags_ = Flags::NONE
            sb.append(localized_magnitude(nil, i, flags_, @width, l))
          when DateTime::SECOND
            # 'S' (00 - 60 - leap second)
            i = t.get(Calendar::SECOND)
            flags_ = Flags::ZERO_PAD
            sb.append(localized_magnitude(nil, i, flags_, 2, l))
          when DateTime::ZONE_NUMERIC
            # 'z' ({-|+}####) - ls minus?
            i = t.get(Calendar::ZONE_OFFSET) + t.get(Calendar::DST_OFFSET)
            neg = i < 0
            sb.append(neg ? Character.new(?-.ord) : Character.new(?+.ord))
            if (neg)
              i = -i
            end
            min = i / 60000
            # combine minute and hour into a single integer
            offset = (min / 60) * 100 + (min % 60)
            flags_ = Flags::ZERO_PAD
            sb.append(localized_magnitude(nil, offset, flags_, 4, l))
          when DateTime::ZONE
            # 'Z' (symbol)
            tz = t.get_time_zone
            sb.append(tz.get_display_name((!(t.get(Calendar::DST_OFFSET)).equal?(0)), TimeZone::SHORT, ((l).nil?) ? Locale::US : l))
          when DateTime::NAME_OF_DAY_ABBREV, DateTime::NAME_OF_DAY
            # 'A'
            i = t.get(Calendar::DAY_OF_WEEK)
            lt = (((l).nil?) ? Locale::US : l)
            dfs = DateFormatSymbols.get_instance(lt)
            if ((c).equal?(DateTime::NAME_OF_DAY))
              sb.append(dfs.get_weekdays[i])
            else
              sb.append(dfs.get_short_weekdays[i])
            end
          when DateTime::NAME_OF_MONTH_ABBREV, DateTime::NAME_OF_MONTH_ABBREV_X, DateTime::NAME_OF_MONTH
            # 'B'
            i = t.get(Calendar::MONTH)
            lt = (((l).nil?) ? Locale::US : l)
            dfs = DateFormatSymbols.get_instance(lt)
            if ((c).equal?(DateTime::NAME_OF_MONTH))
              sb.append(dfs.get_months[i])
            else
              sb.append(dfs.get_short_months[i])
            end
          when DateTime::CENTURY, DateTime::YEAR_2, DateTime::YEAR_4
            # 'Y' (0000 - 9999)
            i = t.get(Calendar::YEAR)
            size = 2
            case (c)
            when DateTime::CENTURY
              i /= 100
            when DateTime::YEAR_2
              i %= 100
            when DateTime::YEAR_4
              size = 4
            end
            flags_ = Flags::ZERO_PAD
            sb.append(localized_magnitude(nil, i, flags_, size, l))
          when DateTime::DAY_OF_MONTH_0, DateTime::DAY_OF_MONTH
            # 'e' (1 - 31) -- like d
            i = t.get(Calendar::DATE)
            flags_ = ((c).equal?(DateTime::DAY_OF_MONTH_0) ? Flags::ZERO_PAD : Flags::NONE)
            sb.append(localized_magnitude(nil, i, flags_, 2, l))
          when DateTime::DAY_OF_YEAR
            # 'j' (001 - 366)
            i = t.get(Calendar::DAY_OF_YEAR)
            flags_ = Flags::ZERO_PAD
            sb.append(localized_magnitude(nil, i, flags_, 3, l))
          when DateTime::MONTH
            # 'm' (01 - 12)
            i = t.get(Calendar::MONTH) + 1
            flags_ = Flags::ZERO_PAD
            sb.append(localized_magnitude(nil, i, flags_, 2, l))
          when DateTime::TIME, DateTime::TIME_24_HOUR
            # 'R' (hh:mm same as %H:%M)
            sep = Character.new(?:.ord)
            print(sb, t, DateTime::HOUR_OF_DAY_0, l).append(sep)
            print(sb, t, DateTime::MINUTE, l)
            if ((c).equal?(DateTime::TIME))
              sb.append(sep)
              print(sb, t, DateTime::SECOND, l)
            end
          when DateTime::TIME_12_HOUR
            # 'r' (hh:mm:ss [AP]M)
            sep = Character.new(?:.ord)
            print(sb, t, DateTime::HOUR_0, l).append(sep)
            print(sb, t, DateTime::MINUTE, l).append(sep)
            print(sb, t, DateTime::SECOND, l).append(Character.new(?\s.ord))
            # this may be in wrong place for some locales
            tsb = self.class::StringBuilder.new
            print(tsb, t, DateTime::AM_PM, l)
            sb.append(tsb.to_s.to_upper_case(!(l).nil? ? l : Locale::US))
          when DateTime::DATE_TIME
            # 'c' (Sat Nov 04 12:02:33 EST 1999)
            sep = Character.new(?\s.ord)
            print(sb, t, DateTime::NAME_OF_DAY_ABBREV, l).append(sep)
            print(sb, t, DateTime::NAME_OF_MONTH_ABBREV, l).append(sep)
            print(sb, t, DateTime::DAY_OF_MONTH_0, l).append(sep)
            print(sb, t, DateTime::TIME, l).append(sep)
            print(sb, t, DateTime::ZONE, l).append(sep)
            print(sb, t, DateTime::YEAR_4, l)
          when DateTime::DATE
            # 'D' (mm/dd/yy)
            sep = Character.new(?/.ord)
            print(sb, t, DateTime::MONTH, l).append(sep)
            print(sb, t, DateTime::DAY_OF_MONTH_0, l).append(sep)
            print(sb, t, DateTime::YEAR_2, l)
          when DateTime::ISO_STANDARD_DATE
            # 'F' (%Y-%m-%d)
            sep = Character.new(?-.ord)
            print(sb, t, DateTime::YEAR_4, l).append(sep)
            print(sb, t, DateTime::MONTH, l).append(sep)
            print(sb, t, DateTime::DAY_OF_MONTH_0, l)
          else
            raise AssertError if not (false)
          end
          return sb
        end
        
        typesig { [self::Flags, ::Java::Char] }
        # -- Methods to support throwing exceptions --
        def fail_mismatch(f, c)
          fs = f.to_s
          raise self.class::FormatFlagsConversionMismatchException.new(fs, c)
        end
        
        typesig { [::Java::Char, Object] }
        def fail_conversion(c, arg)
          raise self.class::IllegalFormatConversionException.new(c, arg.get_class)
        end
        
        typesig { [self::Locale] }
        def get_zero(l)
          if ((!(l).nil?) && !(l == locale))
            dfs = DecimalFormatSymbols.get_instance(l)
            return dfs.get_zero_digit
          end
          return self.attr_zero
        end
        
        typesig { [self::StringBuilder, ::Java::Long, self::Flags, ::Java::Int, self::Locale] }
        def localized_magnitude(sb, value, f, width_, l)
          va = Long.to_s(value, 10).to_char_array
          return localized_magnitude(sb, va, f, width_, l)
        end
        
        typesig { [self::StringBuilder, Array.typed(::Java::Char), self::Flags, ::Java::Int, self::Locale] }
        def localized_magnitude(sb, value, f, width_, l)
          if ((sb).nil?)
            sb = self.class::StringBuilder.new
          end
          begin_ = sb.length
          zero = get_zero(l)
          # determine localized grouping separator and size
          grp_sep = Character.new(?\0.ord)
          grp_size = -1
          dec_sep = Character.new(?\0.ord)
          len = value.attr_length
          dot = len
          j = 0
          while j < len
            if ((value[j]).equal?(Character.new(?..ord)))
              dot = j
              break
            end
            j += 1
          end
          if (dot < len)
            if ((l).nil? || (l == Locale::US))
              dec_sep = Character.new(?..ord)
            else
              dfs = DecimalFormatSymbols.get_instance(l)
              dec_sep = dfs.get_decimal_separator
            end
          end
          if (f.contains(Flags::GROUP))
            if ((l).nil? || (l == Locale::US))
              grp_sep = Character.new(?,.ord)
              grp_size = 3
            else
              dfs = DecimalFormatSymbols.get_instance(l)
              grp_sep = dfs.get_grouping_separator
              df = NumberFormat.get_integer_instance(l)
              grp_size = df.get_grouping_size
            end
          end
          # localize the digits inserting group separators as necessary
          j_ = 0
          while j_ < len
            if ((j_).equal?(dot))
              sb.append(dec_sep)
              # no more group separators after the decimal separator
              grp_sep = Character.new(?\0.ord)
              j_ += 1
              next
            end
            c = value[j_]
            sb.append(RJava.cast_to_char(((c - Character.new(?0.ord)) + zero)))
            if (!(grp_sep).equal?(Character.new(?\0.ord)) && !(j_).equal?(dot - 1) && (((dot - j_) % grp_size).equal?(1)))
              sb.append(grp_sep)
            end
            j_ += 1
          end
          # apply zero padding
          len = sb.length
          if (!(width_).equal?(-1) && f.contains(Flags::ZERO_PAD))
            k = 0
            while k < width_ - len
              sb.insert(begin_, zero)
              k += 1
            end
          end
          return sb
        end
        
        private
        alias_method :initialize__format_specifier, :initialize
      end }
      
      const_set_lazy(:Flags) { Class.new do
        include_class_members Formatter
        
        attr_accessor :flags
        alias_method :attr_flags, :flags
        undef_method :flags
        alias_method :attr_flags=, :flags=
        undef_method :flags=
        
        class_module.module_eval {
          const_set_lazy(:NONE) { self.class::Flags.new(0) }
          const_attr_reader  :NONE
          
          # ''
          # duplicate declarations from Formattable.java
          const_set_lazy(:LEFT_JUSTIFY) { self.class::Flags.new(1 << 0) }
          const_attr_reader  :LEFT_JUSTIFY
          
          # '-'
          const_set_lazy(:UPPERCASE) { self.class::Flags.new(1 << 1) }
          const_attr_reader  :UPPERCASE
          
          # '^'
          const_set_lazy(:ALTERNATE) { self.class::Flags.new(1 << 2) }
          const_attr_reader  :ALTERNATE
          
          # '#'
          # numerics
          const_set_lazy(:PLUS) { self.class::Flags.new(1 << 3) }
          const_attr_reader  :PLUS
          
          # '+'
          const_set_lazy(:LEADING_SPACE) { self.class::Flags.new(1 << 4) }
          const_attr_reader  :LEADING_SPACE
          
          # ' '
          const_set_lazy(:ZERO_PAD) { self.class::Flags.new(1 << 5) }
          const_attr_reader  :ZERO_PAD
          
          # '0'
          const_set_lazy(:GROUP) { self.class::Flags.new(1 << 6) }
          const_attr_reader  :GROUP
          
          # ','
          const_set_lazy(:PARENTHESES) { self.class::Flags.new(1 << 7) }
          const_attr_reader  :PARENTHESES
          
          # '('
          # indexing
          const_set_lazy(:PREVIOUS) { self.class::Flags.new(1 << 8) }
          const_attr_reader  :PREVIOUS
        }
        
        typesig { [::Java::Int] }
        # '<'
        def initialize(f)
          @flags = 0
          @flags = f
        end
        
        typesig { [] }
        def value_of
          return @flags
        end
        
        typesig { [self::Flags] }
        def contains(f)
          return ((@flags & f.value_of)).equal?(f.value_of)
        end
        
        typesig { [] }
        def dup
          return self.class::Flags.new(@flags)
        end
        
        typesig { [self::Flags] }
        def add(f)
          @flags |= f.value_of
          return self
        end
        
        typesig { [self::Flags] }
        def remove(f)
          @flags &= ~f.value_of
          return self
        end
        
        class_module.module_eval {
          typesig { [String] }
          def parse(s)
            ca = s.to_char_array
            f = self.class::Flags.new(0)
            i = 0
            while i < ca.attr_length
              v = parse(ca[i])
              if (f.contains(v))
                raise self.class::DuplicateFormatFlagsException.new(v.to_s)
              end
              f.add(v)
              i += 1
            end
            return f
          end
          
          typesig { [::Java::Char] }
          # parse those flags which may be provided by users
          def parse(c)
            case (c)
            when Character.new(?-.ord)
              return self.class::LEFT_JUSTIFY
            when Character.new(?#.ord)
              return self.class::ALTERNATE
            when Character.new(?+.ord)
              return self.class::PLUS
            when Character.new(?\s.ord)
              return self.class::LEADING_SPACE
            when Character.new(?0.ord)
              return self.class::ZERO_PAD
            when Character.new(?,.ord)
              return self.class::GROUP
            when Character.new(?(.ord)
              return self.class::PARENTHESES
            when Character.new(?<.ord)
              return self.class::PREVIOUS
            else
              raise self.class::UnknownFormatFlagsException.new(String.value_of(c))
            end
          end
          
          typesig { [self::Flags] }
          # Returns a string representation of the current <tt>Flags</tt>.
          def to_s(f)
            return f.to_s
          end
        }
        
        typesig { [] }
        def to_s
          sb = self.class::StringBuilder.new
          if (contains(self.class::LEFT_JUSTIFY))
            sb.append(Character.new(?-.ord))
          end
          if (contains(self.class::UPPERCASE))
            sb.append(Character.new(?^.ord))
          end
          if (contains(self.class::ALTERNATE))
            sb.append(Character.new(?#.ord))
          end
          if (contains(self.class::PLUS))
            sb.append(Character.new(?+.ord))
          end
          if (contains(self.class::LEADING_SPACE))
            sb.append(Character.new(?\s.ord))
          end
          if (contains(self.class::ZERO_PAD))
            sb.append(Character.new(?0.ord))
          end
          if (contains(self.class::GROUP))
            sb.append(Character.new(?,.ord))
          end
          if (contains(self.class::PARENTHESES))
            sb.append(Character.new(?(.ord))
          end
          if (contains(self.class::PREVIOUS))
            sb.append(Character.new(?<.ord))
          end
          return sb.to_s
        end
        
        private
        alias_method :initialize__flags, :initialize
      end }
      
      const_set_lazy(:Conversion) { Class.new do
        include_class_members Formatter
        
        class_module.module_eval {
          # Byte, Short, Integer, Long, BigInteger
          # (and associated primitives due to autoboxing)
          const_set_lazy(:DECIMAL_INTEGER) { Character.new(?d.ord) }
          const_attr_reader  :DECIMAL_INTEGER
          
          const_set_lazy(:OCTAL_INTEGER) { Character.new(?o.ord) }
          const_attr_reader  :OCTAL_INTEGER
          
          const_set_lazy(:HEXADECIMAL_INTEGER) { Character.new(?x.ord) }
          const_attr_reader  :HEXADECIMAL_INTEGER
          
          const_set_lazy(:HEXADECIMAL_INTEGER_UPPER) { Character.new(?X.ord) }
          const_attr_reader  :HEXADECIMAL_INTEGER_UPPER
          
          # Float, Double, BigDecimal
          # (and associated primitives due to autoboxing)
          const_set_lazy(:SCIENTIFIC) { Character.new(?e.ord) }
          const_attr_reader  :SCIENTIFIC
          
          const_set_lazy(:SCIENTIFIC_UPPER) { Character.new(?E.ord) }
          const_attr_reader  :SCIENTIFIC_UPPER
          
          const_set_lazy(:GENERAL) { Character.new(?g.ord) }
          const_attr_reader  :GENERAL
          
          const_set_lazy(:GENERAL_UPPER) { Character.new(?G.ord) }
          const_attr_reader  :GENERAL_UPPER
          
          const_set_lazy(:DECIMAL_FLOAT) { Character.new(?f.ord) }
          const_attr_reader  :DECIMAL_FLOAT
          
          const_set_lazy(:HEXADECIMAL_FLOAT) { Character.new(?a.ord) }
          const_attr_reader  :HEXADECIMAL_FLOAT
          
          const_set_lazy(:HEXADECIMAL_FLOAT_UPPER) { Character.new(?A.ord) }
          const_attr_reader  :HEXADECIMAL_FLOAT_UPPER
          
          # Character, Byte, Short, Integer
          # (and associated primitives due to autoboxing)
          const_set_lazy(:CHARACTER) { Character.new(?c.ord) }
          const_attr_reader  :CHARACTER
          
          const_set_lazy(:CHARACTER_UPPER) { Character.new(?C.ord) }
          const_attr_reader  :CHARACTER_UPPER
          
          # java.util.Date, java.util.Calendar, long
          const_set_lazy(:DATE_TIME) { Character.new(?t.ord) }
          const_attr_reader  :DATE_TIME
          
          const_set_lazy(:DATE_TIME_UPPER) { Character.new(?T.ord) }
          const_attr_reader  :DATE_TIME_UPPER
          
          # if (arg.TYPE != boolean) return boolean
          # if (arg != null) return true; else return false;
          const_set_lazy(:BOOLEAN) { Character.new(?b.ord) }
          const_attr_reader  :BOOLEAN
          
          const_set_lazy(:BOOLEAN_UPPER) { Character.new(?B.ord) }
          const_attr_reader  :BOOLEAN_UPPER
          
          # if (arg instanceof Formattable) arg.formatTo()
          # else arg.toString();
          const_set_lazy(:STRING) { Character.new(?s.ord) }
          const_attr_reader  :STRING
          
          const_set_lazy(:STRING_UPPER) { Character.new(?S.ord) }
          const_attr_reader  :STRING_UPPER
          
          # arg.hashCode()
          const_set_lazy(:HASHCODE) { Character.new(?h.ord) }
          const_attr_reader  :HASHCODE
          
          const_set_lazy(:HASHCODE_UPPER) { Character.new(?H.ord) }
          const_attr_reader  :HASHCODE_UPPER
          
          const_set_lazy(:LINE_SEPARATOR) { Character.new(?n.ord) }
          const_attr_reader  :LINE_SEPARATOR
          
          const_set_lazy(:PERCENT_SIGN) { Character.new(?%.ord) }
          const_attr_reader  :PERCENT_SIGN
          
          typesig { [::Java::Char] }
          def is_valid(c)
            return (is_general(c) || is_integer(c) || is_float(c) || is_text(c) || (c).equal?(Character.new(?t.ord)) || is_character(c))
          end
          
          typesig { [::Java::Char] }
          # Returns true iff the Conversion is applicable to all objects.
          def is_general(c)
            case (c)
            when self.class::BOOLEAN, self.class::BOOLEAN_UPPER, self.class::STRING, self.class::STRING_UPPER, self.class::HASHCODE, self.class::HASHCODE_UPPER
              return true
            else
              return false
            end
          end
          
          typesig { [::Java::Char] }
          # Returns true iff the Conversion is applicable to character.
          def is_character(c)
            case (c)
            when self.class::CHARACTER, self.class::CHARACTER_UPPER
              return true
            else
              return false
            end
          end
          
          typesig { [::Java::Char] }
          # Returns true iff the Conversion is an integer type.
          def is_integer(c)
            case (c)
            when self.class::DECIMAL_INTEGER, self.class::OCTAL_INTEGER, self.class::HEXADECIMAL_INTEGER, self.class::HEXADECIMAL_INTEGER_UPPER
              return true
            else
              return false
            end
          end
          
          typesig { [::Java::Char] }
          # Returns true iff the Conversion is a floating-point type.
          def is_float(c)
            case (c)
            when self.class::SCIENTIFIC, self.class::SCIENTIFIC_UPPER, self.class::GENERAL, self.class::GENERAL_UPPER, self.class::DECIMAL_FLOAT, self.class::HEXADECIMAL_FLOAT, self.class::HEXADECIMAL_FLOAT_UPPER
              return true
            else
              return false
            end
          end
          
          typesig { [::Java::Char] }
          # Returns true iff the Conversion does not require an argument
          def is_text(c)
            case (c)
            when self.class::LINE_SEPARATOR, self.class::PERCENT_SIGN
              return true
            else
              return false
            end
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__conversion, :initialize
      end }
      
      const_set_lazy(:DateTime) { Class.new do
        include_class_members Formatter
        
        class_module.module_eval {
          const_set_lazy(:HOUR_OF_DAY_0) { Character.new(?H.ord) }
          const_attr_reader  :HOUR_OF_DAY_0
          
          # (00 - 23)
          const_set_lazy(:HOUR_0) { Character.new(?I.ord) }
          const_attr_reader  :HOUR_0
          
          # (01 - 12)
          const_set_lazy(:HOUR_OF_DAY) { Character.new(?k.ord) }
          const_attr_reader  :HOUR_OF_DAY
          
          # (0 - 23) -- like H
          const_set_lazy(:HOUR) { Character.new(?l.ord) }
          const_attr_reader  :HOUR
          
          # (1 - 12) -- like I
          const_set_lazy(:MINUTE) { Character.new(?M.ord) }
          const_attr_reader  :MINUTE
          
          # (00 - 59)
          const_set_lazy(:NANOSECOND) { Character.new(?N.ord) }
          const_attr_reader  :NANOSECOND
          
          # (000000000 - 999999999)
          const_set_lazy(:MILLISECOND) { Character.new(?L.ord) }
          const_attr_reader  :MILLISECOND
          
          # jdk, not in gnu (000 - 999)
          const_set_lazy(:MILLISECOND_SINCE_EPOCH) { Character.new(?Q.ord) }
          const_attr_reader  :MILLISECOND_SINCE_EPOCH
          
          # (0 - 99...?)
          const_set_lazy(:AM_PM) { Character.new(?p.ord) }
          const_attr_reader  :AM_PM
          
          # (am or pm)
          const_set_lazy(:SECONDS_SINCE_EPOCH) { Character.new(?s.ord) }
          const_attr_reader  :SECONDS_SINCE_EPOCH
          
          # (0 - 99...?)
          const_set_lazy(:SECOND) { Character.new(?S.ord) }
          const_attr_reader  :SECOND
          
          # (00 - 60 - leap second)
          const_set_lazy(:TIME) { Character.new(?T.ord) }
          const_attr_reader  :TIME
          
          # (24 hour hh:mm:ss)
          const_set_lazy(:ZONE_NUMERIC) { Character.new(?z.ord) }
          const_attr_reader  :ZONE_NUMERIC
          
          # (-1200 - +1200) - ls minus?
          const_set_lazy(:ZONE) { Character.new(?Z.ord) }
          const_attr_reader  :ZONE
          
          # (symbol)
          # Date
          const_set_lazy(:NAME_OF_DAY_ABBREV) { Character.new(?a.ord) }
          const_attr_reader  :NAME_OF_DAY_ABBREV
          
          # 'a'
          const_set_lazy(:NAME_OF_DAY) { Character.new(?A.ord) }
          const_attr_reader  :NAME_OF_DAY
          
          # 'A'
          const_set_lazy(:NAME_OF_MONTH_ABBREV) { Character.new(?b.ord) }
          const_attr_reader  :NAME_OF_MONTH_ABBREV
          
          # 'b'
          const_set_lazy(:NAME_OF_MONTH) { Character.new(?B.ord) }
          const_attr_reader  :NAME_OF_MONTH
          
          # 'B'
          const_set_lazy(:CENTURY) { Character.new(?C.ord) }
          const_attr_reader  :CENTURY
          
          # (00 - 99)
          const_set_lazy(:DAY_OF_MONTH_0) { Character.new(?d.ord) }
          const_attr_reader  :DAY_OF_MONTH_0
          
          # (01 - 31)
          const_set_lazy(:DAY_OF_MONTH) { Character.new(?e.ord) }
          const_attr_reader  :DAY_OF_MONTH
          
          # (1 - 31) -- like d
          # *    static final char ISO_WEEK_OF_YEAR_2    = 'g'; // cross %y %V
          # *    static final char ISO_WEEK_OF_YEAR_4    = 'G'; // cross %Y %V
          const_set_lazy(:NAME_OF_MONTH_ABBREV_X) { Character.new(?h.ord) }
          const_attr_reader  :NAME_OF_MONTH_ABBREV_X
          
          # -- same b
          const_set_lazy(:DAY_OF_YEAR) { Character.new(?j.ord) }
          const_attr_reader  :DAY_OF_YEAR
          
          # (001 - 366)
          const_set_lazy(:MONTH) { Character.new(?m.ord) }
          const_attr_reader  :MONTH
          
          # (01 - 12)
          # *    static final char DAY_OF_WEEK_1         = 'u'; // (1 - 7) Monday
          # *    static final char WEEK_OF_YEAR_SUNDAY   = 'U'; // (0 - 53) Sunday+
          # *    static final char WEEK_OF_YEAR_MONDAY_01 = 'V'; // (01 - 53) Monday+
          # *    static final char DAY_OF_WEEK_0         = 'w'; // (0 - 6) Sunday
          # *    static final char WEEK_OF_YEAR_MONDAY   = 'W'; // (00 - 53) Monday
          const_set_lazy(:YEAR_2) { Character.new(?y.ord) }
          const_attr_reader  :YEAR_2
          
          # (00 - 99)
          const_set_lazy(:YEAR_4) { Character.new(?Y.ord) }
          const_attr_reader  :YEAR_4
          
          # (0000 - 9999)
          # Composites
          const_set_lazy(:TIME_12_HOUR) { Character.new(?r.ord) }
          const_attr_reader  :TIME_12_HOUR
          
          # (hh:mm:ss [AP]M)
          const_set_lazy(:TIME_24_HOUR) { Character.new(?R.ord) }
          const_attr_reader  :TIME_24_HOUR
          
          # (hh:mm same as %H:%M)
          # *    static final char LOCALE_TIME   = 'X'; // (%H:%M:%S) - parse format?
          const_set_lazy(:DATE_TIME) { Character.new(?c.ord) }
          const_attr_reader  :DATE_TIME
          
          # (Sat Nov 04 12:02:33 EST 1999)
          const_set_lazy(:DATE) { Character.new(?D.ord) }
          const_attr_reader  :DATE
          
          # (mm/dd/yy)
          const_set_lazy(:ISO_STANDARD_DATE) { Character.new(?F.ord) }
          const_attr_reader  :ISO_STANDARD_DATE
          
          typesig { [::Java::Char] }
          # (%Y-%m-%d)
          # *    static final char LOCALE_DATE           = 'x'; // (mm/dd/yy)
          def is_valid(c)
            case (c)
            # Date
            # *        case ISO_WEEK_OF_YEAR_2:
            # *        case ISO_WEEK_OF_YEAR_4:
            # *        case DAY_OF_WEEK_1:
            # *        case WEEK_OF_YEAR_SUNDAY:
            # *        case WEEK_OF_YEAR_MONDAY_01:
            # *        case DAY_OF_WEEK_0:
            # *        case WEEK_OF_YEAR_MONDAY:
            # Composites
            # *        case LOCALE_TIME:
            when self.class::HOUR_OF_DAY_0, self.class::HOUR_0, self.class::HOUR_OF_DAY, self.class::HOUR, self.class::MINUTE, self.class::NANOSECOND, self.class::MILLISECOND, self.class::MILLISECOND_SINCE_EPOCH, self.class::AM_PM, self.class::SECONDS_SINCE_EPOCH, self.class::SECOND, self.class::TIME, self.class::ZONE_NUMERIC, self.class::ZONE, self.class::NAME_OF_DAY_ABBREV, self.class::NAME_OF_DAY, self.class::NAME_OF_MONTH_ABBREV, self.class::NAME_OF_MONTH, self.class::CENTURY, self.class::DAY_OF_MONTH_0, self.class::DAY_OF_MONTH, self.class::NAME_OF_MONTH_ABBREV_X, self.class::DAY_OF_YEAR, self.class::MONTH, self.class::YEAR_2, self.class::YEAR_4, self.class::TIME_12_HOUR, self.class::TIME_24_HOUR, self.class::DATE_TIME, self.class::DATE, self.class::ISO_STANDARD_DATE
              # *        case LOCALE_DATE:
              return true
            else
              return false
            end
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__date_time, :initialize
      end }
    }
    
    private
    alias_method :initialize__formatter, :initialize
  end
  
end
