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
# (C) Copyright Taligent, Inc. 1996 - All Rights Reserved
# (C) Copyright IBM Corp. 1996-1998 - All Rights Reserved
# 
# The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module SimpleDateFormatImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InvalidObjectException
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Util, :Calendar
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :GregorianCalendar
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util, :SimpleTimeZone
      include_const ::Java::Util, :TimeZone
      include_const ::Sun::Util::Calendar, :CalendarUtils
      include_const ::Sun::Util::Calendar, :ZoneInfoFile
      include_const ::Sun::Util::Resources, :LocaleData
    }
  end
  
  # <code>SimpleDateFormat</code> is a concrete class for formatting and
  # parsing dates in a locale-sensitive manner. It allows for formatting
  # (date -> text), parsing (text -> date), and normalization.
  # 
  # <p>
  # <code>SimpleDateFormat</code> allows you to start by choosing
  # any user-defined patterns for date-time formatting. However, you
  # are encouraged to create a date-time formatter with either
  # <code>getTimeInstance</code>, <code>getDateInstance</code>, or
  # <code>getDateTimeInstance</code> in <code>DateFormat</code>. Each
  # of these class methods can return a date/time formatter initialized
  # with a default format pattern. You may modify the format pattern
  # using the <code>applyPattern</code> methods as desired.
  # For more information on using these methods, see
  # {@link DateFormat}.
  # 
  # <h4>Date and Time Patterns</h4>
  # <p>
  # Date and time formats are specified by <em>date and time pattern</em>
  # strings.
  # Within date and time pattern strings, unquoted letters from
  # <code>'A'</code> to <code>'Z'</code> and from <code>'a'</code> to
  # <code>'z'</code> are interpreted as pattern letters representing the
  # components of a date or time string.
  # Text can be quoted using single quotes (<code>'</code>) to avoid
  # interpretation.
  # <code>"''"</code> represents a single quote.
  # All other characters are not interpreted; they're simply copied into the
  # output string during formatting or matched against the input string
  # during parsing.
  # <p>
  # The following pattern letters are defined (all other characters from
  # <code>'A'</code> to <code>'Z'</code> and from <code>'a'</code> to
  # <code>'z'</code> are reserved):
  # <blockquote>
  # <table border=0 cellspacing=3 cellpadding=0 summary="Chart shows pattern letters, date/time component, presentation, and examples.">
  # <tr bgcolor="#ccccff">
  # <th align=left>Letter
  # <th align=left>Date or Time Component
  # <th align=left>Presentation
  # <th align=left>Examples
  # <tr>
  # <td><code>G</code>
  # <td>Era designator
  # <td><a href="#text">Text</a>
  # <td><code>AD</code>
  # <tr bgcolor="#eeeeff">
  # <td><code>y</code>
  # <td>Year
  # <td><a href="#year">Year</a>
  # <td><code>1996</code>; <code>96</code>
  # <tr>
  # <td><code>M</code>
  # <td>Month in year
  # <td><a href="#month">Month</a>
  # <td><code>July</code>; <code>Jul</code>; <code>07</code>
  # <tr bgcolor="#eeeeff">
  # <td><code>w</code>
  # <td>Week in year
  # <td><a href="#number">Number</a>
  # <td><code>27</code>
  # <tr>
  # <td><code>W</code>
  # <td>Week in month
  # <td><a href="#number">Number</a>
  # <td><code>2</code>
  # <tr bgcolor="#eeeeff">
  # <td><code>D</code>
  # <td>Day in year
  # <td><a href="#number">Number</a>
  # <td><code>189</code>
  # <tr>
  # <td><code>d</code>
  # <td>Day in month
  # <td><a href="#number">Number</a>
  # <td><code>10</code>
  # <tr bgcolor="#eeeeff">
  # <td><code>F</code>
  # <td>Day of week in month
  # <td><a href="#number">Number</a>
  # <td><code>2</code>
  # <tr>
  # <td><code>E</code>
  # <td>Day in week
  # <td><a href="#text">Text</a>
  # <td><code>Tuesday</code>; <code>Tue</code>
  # <tr bgcolor="#eeeeff">
  # <td><code>a</code>
  # <td>Am/pm marker
  # <td><a href="#text">Text</a>
  # <td><code>PM</code>
  # <tr>
  # <td><code>H</code>
  # <td>Hour in day (0-23)
  # <td><a href="#number">Number</a>
  # <td><code>0</code>
  # <tr bgcolor="#eeeeff">
  # <td><code>k</code>
  # <td>Hour in day (1-24)
  # <td><a href="#number">Number</a>
  # <td><code>24</code>
  # <tr>
  # <td><code>K</code>
  # <td>Hour in am/pm (0-11)
  # <td><a href="#number">Number</a>
  # <td><code>0</code>
  # <tr bgcolor="#eeeeff">
  # <td><code>h</code>
  # <td>Hour in am/pm (1-12)
  # <td><a href="#number">Number</a>
  # <td><code>12</code>
  # <tr>
  # <td><code>m</code>
  # <td>Minute in hour
  # <td><a href="#number">Number</a>
  # <td><code>30</code>
  # <tr bgcolor="#eeeeff">
  # <td><code>s</code>
  # <td>Second in minute
  # <td><a href="#number">Number</a>
  # <td><code>55</code>
  # <tr>
  # <td><code>S</code>
  # <td>Millisecond
  # <td><a href="#number">Number</a>
  # <td><code>978</code>
  # <tr bgcolor="#eeeeff">
  # <td><code>z</code>
  # <td>Time zone
  # <td><a href="#timezone">General time zone</a>
  # <td><code>Pacific Standard Time</code>; <code>PST</code>; <code>GMT-08:00</code>
  # <tr>
  # <td><code>Z</code>
  # <td>Time zone
  # <td><a href="#rfc822timezone">RFC 822 time zone</a>
  # <td><code>-0800</code>
  # </table>
  # </blockquote>
  # Pattern letters are usually repeated, as their number determines the
  # exact presentation:
  # <ul>
  # <li><strong><a name="text">Text:</a></strong>
  # For formatting, if the number of pattern letters is 4 or more,
  # the full form is used; otherwise a short or abbreviated form
  # is used if available.
  # For parsing, both forms are accepted, independent of the number
  # of pattern letters.
  # <li><strong><a name="number">Number:</a></strong>
  # For formatting, the number of pattern letters is the minimum
  # number of digits, and shorter numbers are zero-padded to this amount.
  # For parsing, the number of pattern letters is ignored unless
  # it's needed to separate two adjacent fields.
  # <li><strong><a name="year">Year:</a></strong>
  # If the formatter's {@link #getCalendar() Calendar} is the Gregorian
  # calendar, the following rules are applied.<br>
  # <ul>
  # <li>For formatting, if the number of pattern letters is 2, the year
  # is truncated to 2 digits; otherwise it is interpreted as a
  # <a href="#number">number</a>.
  # <li>For parsing, if the number of pattern letters is more than 2,
  # the year is interpreted literally, regardless of the number of
  # digits. So using the pattern "MM/dd/yyyy", "01/11/12" parses to
  # Jan 11, 12 A.D.
  # <li>For parsing with the abbreviated year pattern ("y" or "yy"),
  # <code>SimpleDateFormat</code> must interpret the abbreviated year
  # relative to some century.  It does this by adjusting dates to be
  # within 80 years before and 20 years after the time the <code>SimpleDateFormat</code>
  # instance is created. For example, using a pattern of "MM/dd/yy" and a
  # <code>SimpleDateFormat</code> instance created on Jan 1, 1997,  the string
  # "01/11/12" would be interpreted as Jan 11, 2012 while the string "05/04/64"
  # would be interpreted as May 4, 1964.
  # During parsing, only strings consisting of exactly two digits, as defined by
  # {@link Character#isDigit(char)}, will be parsed into the default century.
  # Any other numeric string, such as a one digit string, a three or more digit
  # string, or a two digit string that isn't all digits (for example, "-1"), is
  # interpreted literally.  So "01/02/3" or "01/02/003" are parsed, using the
  # same pattern, as Jan 2, 3 AD.  Likewise, "01/02/-3" is parsed as Jan 2, 4 BC.
  # </ul>
  # Otherwise, calendar system specific forms are applied.
  # For both formatting and parsing, if the number of pattern
  # letters is 4 or more, a calendar specific {@linkplain
  # Calendar#LONG long form} is used. Otherwise, a calendar
  # specific {@linkplain Calendar#SHORT short or abbreviated form}
  # is used.
  # <li><strong><a name="month">Month:</a></strong>
  # If the number of pattern letters is 3 or more, the month is
  # interpreted as <a href="#text">text</a>; otherwise,
  # it is interpreted as a <a href="#number">number</a>.
  # <li><strong><a name="timezone">General time zone:</a></strong>
  # Time zones are interpreted as <a href="#text">text</a> if they have
  # names. For time zones representing a GMT offset value, the
  # following syntax is used:
  # <pre>
  # <a name="GMTOffsetTimeZone"><i>GMTOffsetTimeZone:</i></a>
  # <code>GMT</code> <i>Sign</i> <i>Hours</i> <code>:</code> <i>Minutes</i>
  # <i>Sign:</i> one of
  # <code>+ -</code>
  # <i>Hours:</i>
  # <i>Digit</i>
  # <i>Digit</i> <i>Digit</i>
  # <i>Minutes:</i>
  # <i>Digit</i> <i>Digit</i>
  # <i>Digit:</i> one of
  # <code>0 1 2 3 4 5 6 7 8 9</code></pre>
  # <i>Hours</i> must be between 0 and 23, and <i>Minutes</i> must be between
  # 00 and 59. The format is locale independent and digits must be taken
  # from the Basic Latin block of the Unicode standard.
  # <p>For parsing, <a href="#rfc822timezone">RFC 822 time zones</a> are also
  # accepted.
  # <li><strong><a name="rfc822timezone">RFC 822 time zone:</a></strong>
  # For formatting, the RFC 822 4-digit time zone format is used:
  # <pre>
  # <i>RFC822TimeZone:</i>
  # <i>Sign</i> <i>TwoDigitHours</i> <i>Minutes</i>
  # <i>TwoDigitHours:</i>
  # <i>Digit Digit</i></pre>
  # <i>TwoDigitHours</i> must be between 00 and 23. Other definitions
  # are as for <a href="#timezone">general time zones</a>.
  # <p>For parsing, <a href="#timezone">general time zones</a> are also
  # accepted.
  # </ul>
  # <code>SimpleDateFormat</code> also supports <em>localized date and time
  # pattern</em> strings. In these strings, the pattern letters described above
  # may be replaced with other, locale dependent, pattern letters.
  # <code>SimpleDateFormat</code> does not deal with the localization of text
  # other than the pattern letters; that's up to the client of the class.
  # <p>
  # 
  # <h4>Examples</h4>
  # 
  # The following examples show how date and time patterns are interpreted in
  # the U.S. locale. The given date and time are 2001-07-04 12:08:56 local time
  # in the U.S. Pacific Time time zone.
  # <blockquote>
  # <table border=0 cellspacing=3 cellpadding=0 summary="Examples of date and time patterns interpreted in the U.S. locale">
  # <tr bgcolor="#ccccff">
  # <th align=left>Date and Time Pattern
  # <th align=left>Result
  # <tr>
  # <td><code>"yyyy.MM.dd G 'at' HH:mm:ss z"</code>
  # <td><code>2001.07.04 AD at 12:08:56 PDT</code>
  # <tr bgcolor="#eeeeff">
  # <td><code>"EEE, MMM d, ''yy"</code>
  # <td><code>Wed, Jul 4, '01</code>
  # <tr>
  # <td><code>"h:mm a"</code>
  # <td><code>12:08 PM</code>
  # <tr bgcolor="#eeeeff">
  # <td><code>"hh 'o''clock' a, zzzz"</code>
  # <td><code>12 o'clock PM, Pacific Daylight Time</code>
  # <tr>
  # <td><code>"K:mm a, z"</code>
  # <td><code>0:08 PM, PDT</code>
  # <tr bgcolor="#eeeeff">
  # <td><code>"yyyyy.MMMMM.dd GGG hh:mm aaa"</code>
  # <td><code>02001.July.04 AD 12:08 PM</code>
  # <tr>
  # <td><code>"EEE, d MMM yyyy HH:mm:ss Z"</code>
  # <td><code>Wed, 4 Jul 2001 12:08:56 -0700</code>
  # <tr bgcolor="#eeeeff">
  # <td><code>"yyMMddHHmmssZ"</code>
  # <td><code>010704120856-0700</code>
  # <tr>
  # <td><code>"yyyy-MM-dd'T'HH:mm:ss.SSSZ"</code>
  # <td><code>2001-07-04T12:08:56.235-0700</code>
  # </table>
  # </blockquote>
  # 
  # <h4><a name="synchronization">Synchronization</a></h4>
  # 
  # <p>
  # Date formats are not synchronized.
  # It is recommended to create separate format instances for each thread.
  # If multiple threads access a format concurrently, it must be synchronized
  # externally.
  # 
  # @see          <a href="http://java.sun.com/docs/books/tutorial/i18n/format/simpleDateFormat.html">Java Tutorial</a>
  # @see          java.util.Calendar
  # @see          java.util.TimeZone
  # @see          DateFormat
  # @see          DateFormatSymbols
  # @author       Mark Davis, Chen-Lieh Huang, Alan Liu
  class SimpleDateFormat < SimpleDateFormatImports.const_get :DateFormat
    include_class_members SimpleDateFormatImports
    
    class_module.module_eval {
      # the official serial version ID which says cryptically
      # which version we're compatible with
      const_set_lazy(:SerialVersionUID) { 4774881970558875024 }
      const_attr_reader  :SerialVersionUID
      
      # the internal serial version which says which version was written
      # - 0 (default) for version up to JDK 1.1.3
      # - 1 for version from JDK 1.1.4, which includes a new field
      const_set_lazy(:CurrentSerialVersion) { 1 }
      const_attr_reader  :CurrentSerialVersion
    }
    
    # The version of the serialized data on the stream.  Possible values:
    # <ul>
    # <li><b>0</b> or not present on stream: JDK 1.1.3.  This version
    # has no <code>defaultCenturyStart</code> on stream.
    # <li><b>1</b> JDK 1.1.4 or later.  This version adds
    # <code>defaultCenturyStart</code>.
    # </ul>
    # When streaming out this class, the most recent format
    # and the highest allowable <code>serialVersionOnStream</code>
    # is written.
    # @serial
    # @since JDK1.1.4
    attr_accessor :serial_version_on_stream
    alias_method :attr_serial_version_on_stream, :serial_version_on_stream
    undef_method :serial_version_on_stream
    alias_method :attr_serial_version_on_stream=, :serial_version_on_stream=
    undef_method :serial_version_on_stream=
    
    # The pattern string of this formatter.  This is always a non-localized
    # pattern.  May not be null.  See class documentation for details.
    # @serial
    attr_accessor :pattern
    alias_method :attr_pattern, :pattern
    undef_method :pattern
    alias_method :attr_pattern=, :pattern=
    undef_method :pattern=
    
    # The compiled pattern.
    attr_accessor :compiled_pattern
    alias_method :attr_compiled_pattern, :compiled_pattern
    undef_method :compiled_pattern
    alias_method :attr_compiled_pattern=, :compiled_pattern=
    undef_method :compiled_pattern=
    
    class_module.module_eval {
      # Tags for the compiled pattern.
      const_set_lazy(:TAG_QUOTE_ASCII_CHAR) { 100 }
      const_attr_reader  :TAG_QUOTE_ASCII_CHAR
      
      const_set_lazy(:TAG_QUOTE_CHARS) { 101 }
      const_attr_reader  :TAG_QUOTE_CHARS
    }
    
    # Locale dependent digit zero.
    # @see #zeroPaddingNumber
    # @see java.text.DecimalFormatSymbols#getZeroDigit
    attr_accessor :zero_digit
    alias_method :attr_zero_digit, :zero_digit
    undef_method :zero_digit
    alias_method :attr_zero_digit=, :zero_digit=
    undef_method :zero_digit=
    
    # The symbols used by this formatter for week names, month names,
    # etc.  May not be null.
    # @serial
    # @see java.text.DateFormatSymbols
    attr_accessor :format_data
    alias_method :attr_format_data, :format_data
    undef_method :format_data
    alias_method :attr_format_data=, :format_data=
    undef_method :format_data=
    
    # We map dates with two-digit years into the century starting at
    # <code>defaultCenturyStart</code>, which may be any date.  May
    # not be null.
    # @serial
    # @since JDK1.1.4
    attr_accessor :default_century_start
    alias_method :attr_default_century_start, :default_century_start
    undef_method :default_century_start
    alias_method :attr_default_century_start=, :default_century_start=
    undef_method :default_century_start=
    
    attr_accessor :default_century_start_year
    alias_method :attr_default_century_start_year, :default_century_start_year
    undef_method :default_century_start_year
    alias_method :attr_default_century_start_year=, :default_century_start_year=
    undef_method :default_century_start_year=
    
    class_module.module_eval {
      const_set_lazy(:MillisPerHour) { 60 * 60 * 1000 }
      const_attr_reader  :MillisPerHour
      
      const_set_lazy(:MillisPerMinute) { 60 * 1000 }
      const_attr_reader  :MillisPerMinute
      
      # For time zones that have no names, use strings GMT+minutes and
      # GMT-minutes. For instance, in France the time zone is GMT+60.
      const_set_lazy(:GMT) { "GMT" }
      const_attr_reader  :GMT
      
      # Cache to hold the DateTimePatterns of a Locale.
      
      def cached_locale_data
        defined?(@@cached_locale_data) ? @@cached_locale_data : @@cached_locale_data= Hashtable.new(3)
      end
      alias_method :attr_cached_locale_data, :cached_locale_data
      
      def cached_locale_data=(value)
        @@cached_locale_data = value
      end
      alias_method :attr_cached_locale_data=, :cached_locale_data=
      
      # Cache NumberFormat instances with Locale key.
      
      def cached_number_format_data
        defined?(@@cached_number_format_data) ? @@cached_number_format_data : @@cached_number_format_data= Hashtable.new(3)
      end
      alias_method :attr_cached_number_format_data, :cached_number_format_data
      
      def cached_number_format_data=(value)
        @@cached_number_format_data = value
      end
      alias_method :attr_cached_number_format_data=, :cached_number_format_data=
    }
    
    # The Locale used to instantiate this
    # <code>SimpleDateFormat</code>. The value may be null if this object
    # has been created by an older <code>SimpleDateFormat</code> and
    # deserialized.
    # 
    # @serial
    # @since 1.6
    attr_accessor :locale
    alias_method :attr_locale, :locale
    undef_method :locale
    alias_method :attr_locale=, :locale=
    undef_method :locale=
    
    # Indicates whether this <code>SimpleDateFormat</code> should use
    # the DateFormatSymbols. If true, the format and parse methods
    # use the DateFormatSymbols values. If false, the format and
    # parse methods call Calendar.getDisplayName or
    # Calendar.getDisplayNames.
    attr_accessor :use_date_format_symbols
    alias_method :attr_use_date_format_symbols, :use_date_format_symbols
    undef_method :use_date_format_symbols
    alias_method :attr_use_date_format_symbols=, :use_date_format_symbols=
    undef_method :use_date_format_symbols=
    
    typesig { [] }
    # Constructs a <code>SimpleDateFormat</code> using the default pattern and
    # date format symbols for the default locale.
    # <b>Note:</b> This constructor may not support all locales.
    # For full coverage, use the factory methods in the {@link DateFormat}
    # class.
    def initialize
      initialize__simple_date_format(SHORT, SHORT, Locale.get_default)
    end
    
    typesig { [String] }
    # Constructs a <code>SimpleDateFormat</code> using the given pattern and
    # the default date format symbols for the default locale.
    # <b>Note:</b> This constructor may not support all locales.
    # For full coverage, use the factory methods in the {@link DateFormat}
    # class.
    # 
    # @param pattern the pattern describing the date and time format
    # @exception NullPointerException if the given pattern is null
    # @exception IllegalArgumentException if the given pattern is invalid
    def initialize(pattern)
      initialize__simple_date_format(pattern, Locale.get_default)
    end
    
    typesig { [String, Locale] }
    # Constructs a <code>SimpleDateFormat</code> using the given pattern and
    # the default date format symbols for the given locale.
    # <b>Note:</b> This constructor may not support all locales.
    # For full coverage, use the factory methods in the {@link DateFormat}
    # class.
    # 
    # @param pattern the pattern describing the date and time format
    # @param locale the locale whose date format symbols should be used
    # @exception NullPointerException if the given pattern or locale is null
    # @exception IllegalArgumentException if the given pattern is invalid
    def initialize(pattern, locale)
      @serial_version_on_stream = 0
      @pattern = nil
      @compiled_pattern = nil
      @zero_digit = 0
      @format_data = nil
      @default_century_start = nil
      @default_century_start_year = 0
      @locale = nil
      @use_date_format_symbols = false
      super()
      @serial_version_on_stream = CurrentSerialVersion
      if ((pattern).nil? || (locale).nil?)
        raise NullPointerException.new
      end
      initialize_calendar(locale)
      @pattern = pattern
      @format_data = DateFormatSymbols.get_instance(locale)
      @locale = locale
      initialize_(locale)
    end
    
    typesig { [String, DateFormatSymbols] }
    # Constructs a <code>SimpleDateFormat</code> using the given pattern and
    # date format symbols.
    # 
    # @param pattern the pattern describing the date and time format
    # @param formatSymbols the date format symbols to be used for formatting
    # @exception NullPointerException if the given pattern or formatSymbols is null
    # @exception IllegalArgumentException if the given pattern is invalid
    def initialize(pattern, format_symbols)
      @serial_version_on_stream = 0
      @pattern = nil
      @compiled_pattern = nil
      @zero_digit = 0
      @format_data = nil
      @default_century_start = nil
      @default_century_start_year = 0
      @locale = nil
      @use_date_format_symbols = false
      super()
      @serial_version_on_stream = CurrentSerialVersion
      if ((pattern).nil? || (format_symbols).nil?)
        raise NullPointerException.new
      end
      @pattern = pattern
      @format_data = format_symbols.clone
      @locale = Locale.get_default
      initialize_calendar(@locale)
      initialize_(@locale)
      @use_date_format_symbols = true
    end
    
    typesig { [::Java::Int, ::Java::Int, Locale] }
    # Package-private, called by DateFormat factory methods
    def initialize(time_style, date_style, loc)
      @serial_version_on_stream = 0
      @pattern = nil
      @compiled_pattern = nil
      @zero_digit = 0
      @format_data = nil
      @default_century_start = nil
      @default_century_start_year = 0
      @locale = nil
      @use_date_format_symbols = false
      super()
      @serial_version_on_stream = CurrentSerialVersion
      if ((loc).nil?)
        raise NullPointerException.new
      end
      @locale = loc
      # initialize calendar and related fields
      initialize_calendar(loc)
      # try the cache first
      key = get_key
      date_time_patterns = self.attr_cached_locale_data.get(key)
      if ((date_time_patterns).nil?)
        # cache miss
        r = LocaleData.get_date_format_data(loc)
        if (!is_gregorian_calendar)
          begin
            date_time_patterns = r.get_string_array((get_calendar_name).to_s + ".DateTimePatterns")
          rescue MissingResourceException => e
          end
        end
        if ((date_time_patterns).nil?)
          date_time_patterns = r.get_string_array("DateTimePatterns")
        end
        # update cache
        self.attr_cached_locale_data.put(key, date_time_patterns)
      end
      @format_data = DateFormatSymbols.get_instance(loc)
      if ((time_style >= 0) && (date_style >= 0))
        date_time_args = Array.typed(Object).new([date_time_patterns[time_style], date_time_patterns[date_style + 4]])
        @pattern = (MessageFormat.format(date_time_patterns[8], date_time_args)).to_s
      else
        if (time_style >= 0)
          @pattern = (date_time_patterns[time_style]).to_s
        else
          if (date_style >= 0)
            @pattern = (date_time_patterns[date_style + 4]).to_s
          else
            raise IllegalArgumentException.new("No date or time style specified")
          end
        end
      end
      initialize_(loc)
    end
    
    typesig { [Locale] }
    # Initialize compiledPattern and numberFormat fields
    def initialize_(loc)
      # Verify and compile the given pattern.
      @compiled_pattern = compile(@pattern)
      # try the cache first
      self.attr_number_format = self.attr_cached_number_format_data.get(loc)
      if ((self.attr_number_format).nil?)
        # cache miss
        self.attr_number_format = NumberFormat.get_integer_instance(loc)
        self.attr_number_format.set_grouping_used(false)
        # update cache
        self.attr_cached_number_format_data.put(loc, self.attr_number_format)
      end
      self.attr_number_format = self.attr_number_format.clone
      initialize_default_century
    end
    
    typesig { [Locale] }
    def initialize_calendar(loc)
      if ((self.attr_calendar).nil?)
        raise AssertError if not (!(loc).nil?)
        # The format object must be constructed using the symbols for this zone.
        # However, the calendar should use the current default TimeZone.
        # If this is not contained in the locale zone strings, then the zone
        # will be formatted using generic GMT+/-H:MM nomenclature.
        self.attr_calendar = Calendar.get_instance(TimeZone.get_default, loc)
      end
    end
    
    typesig { [] }
    def get_key
      sb = StringBuilder.new
      sb.append(get_calendar_name).append(Character.new(?..ord))
      sb.append(@locale.get_language).append(Character.new(?_.ord)).append(@locale.get_country).append(Character.new(?_.ord)).append(@locale.get_variant)
      return sb.to_s
    end
    
    typesig { [String] }
    # Returns the compiled form of the given pattern. The syntax of
    # the compiled pattern is:
    # <blockquote>
    # CompiledPattern:
    # EntryList
    # EntryList:
    # Entry
    # EntryList Entry
    # Entry:
    # TagField
    # TagField data
    # TagField:
    # Tag Length
    # TaggedData
    # Tag:
    # pattern_char_index
    # TAG_QUOTE_CHARS
    # Length:
    # short_length
    # long_length
    # TaggedData:
    # TAG_QUOTE_ASCII_CHAR ascii_char
    # 
    # </blockquote>
    # 
    # where `short_length' is an 8-bit unsigned integer between 0 and
    # 254.  `long_length' is a sequence of an 8-bit integer 255 and a
    # 32-bit signed integer value which is split into upper and lower
    # 16-bit fields in two char's. `pattern_char_index' is an 8-bit
    # integer between 0 and 18. `ascii_char' is an 7-bit ASCII
    # character value. `data' depends on its Tag value.
    # <p>
    # If Length is short_length, Tag and short_length are packed in a
    # single char, as illustrated below.
    # <blockquote>
    # char[0] = (Tag << 8) | short_length;
    # </blockquote>
    # 
    # If Length is long_length, Tag and 255 are packed in the first
    # char and a 32-bit integer, as illustrated below.
    # <blockquote>
    # char[0] = (Tag << 8) | 255;
    # char[1] = (char) (long_length >>> 16);
    # char[2] = (char) (long_length & 0xffff);
    # </blockquote>
    # <p>
    # If Tag is a pattern_char_index, its Length is the number of
    # pattern characters. For example, if the given pattern is
    # "yyyy", Tag is 1 and Length is 4, followed by no data.
    # <p>
    # If Tag is TAG_QUOTE_CHARS, its Length is the number of char's
    # following the TagField. For example, if the given pattern is
    # "'o''clock'", Length is 7 followed by a char sequence of
    # <code>o&nbs;'&nbs;c&nbs;l&nbs;o&nbs;c&nbs;k</code>.
    # <p>
    # TAG_QUOTE_ASCII_CHAR is a special tag and has an ASCII
    # character in place of Length. For example, if the given pattern
    # is "'o'", the TaggedData entry is
    # <code>((TAG_QUOTE_ASCII_CHAR&nbs;<<&nbs;8)&nbs;|&nbs;'o')</code>.
    # 
    # @exception NullPointerException if the given pattern is null
    # @exception IllegalArgumentException if the given pattern is invalid
    def compile(pattern)
      length_ = pattern.length
      in_quote = false
      compiled_pattern = StringBuilder.new(length_ * 2)
      tmp_buffer = nil
      count = 0
      last_tag = -1
      i = 0
      while i < length_
        c = pattern.char_at(i)
        if ((c).equal?(Character.new(?\'.ord)))
          # '' is treated as a single quote regardless of being
          # in a quoted section.
          if ((i + 1) < length_)
            c = pattern.char_at(i + 1)
            if ((c).equal?(Character.new(?\'.ord)))
              i += 1
              if (!(count).equal?(0))
                encode(last_tag, count, compiled_pattern)
                last_tag = -1
                count = 0
              end
              if (in_quote)
                tmp_buffer.append(c)
              else
                compiled_pattern.append(RJava.cast_to_char((TAG_QUOTE_ASCII_CHAR << 8 | c)))
              end
              i += 1
              next
            end
          end
          if (!in_quote)
            if (!(count).equal?(0))
              encode(last_tag, count, compiled_pattern)
              last_tag = -1
              count = 0
            end
            if ((tmp_buffer).nil?)
              tmp_buffer = StringBuilder.new(length_)
            else
              tmp_buffer.set_length(0)
            end
            in_quote = true
          else
            len = tmp_buffer.length
            if ((len).equal?(1))
              ch = tmp_buffer.char_at(0)
              if (ch < 128)
                compiled_pattern.append(RJava.cast_to_char((TAG_QUOTE_ASCII_CHAR << 8 | ch)))
              else
                compiled_pattern.append(RJava.cast_to_char((TAG_QUOTE_CHARS << 8 | 1)))
                compiled_pattern.append(ch)
              end
            else
              encode(TAG_QUOTE_CHARS, len, compiled_pattern)
              compiled_pattern.append(tmp_buffer)
            end
            in_quote = false
          end
          i += 1
          next
        end
        if (in_quote)
          tmp_buffer.append(c)
          i += 1
          next
        end
        if (!(c >= Character.new(?a.ord) && c <= Character.new(?z.ord) || c >= Character.new(?A.ord) && c <= Character.new(?Z.ord)))
          if (!(count).equal?(0))
            encode(last_tag, count, compiled_pattern)
            last_tag = -1
            count = 0
          end
          if (c < 128)
            # In most cases, c would be a delimiter, such as ':'.
            compiled_pattern.append(RJava.cast_to_char((TAG_QUOTE_ASCII_CHAR << 8 | c)))
          else
            # Take any contiguous non-ASCII alphabet characters and
            # put them in a single TAG_QUOTE_CHARS.
            j = 0
            j = i + 1
            while j < length_
              d = pattern.char_at(j)
              if ((d).equal?(Character.new(?\'.ord)) || (d >= Character.new(?a.ord) && d <= Character.new(?z.ord) || d >= Character.new(?A.ord) && d <= Character.new(?Z.ord)))
                break
              end
              j += 1
            end
            compiled_pattern.append(RJava.cast_to_char((TAG_QUOTE_CHARS << 8 | (j - i))))
            while i < j
              compiled_pattern.append(pattern.char_at(i))
              i += 1
            end
            i -= 1
          end
          i += 1
          next
        end
        tag = 0
        if (((tag = DateFormatSymbols.attr_pattern_chars.index_of(c))).equal?(-1))
          raise IllegalArgumentException.new("Illegal pattern character " + "'" + (c).to_s + "'")
        end
        if ((last_tag).equal?(-1) || (last_tag).equal?(tag))
          last_tag = tag
          count += 1
          i += 1
          next
        end
        encode(last_tag, count, compiled_pattern)
        last_tag = tag
        count = 1
        i += 1
      end
      if (in_quote)
        raise IllegalArgumentException.new("Unterminated quote")
      end
      if (!(count).equal?(0))
        encode(last_tag, count, compiled_pattern)
      end
      # Copy the compiled pattern to a char array
      len = compiled_pattern.length
      r = CharArray.new(len)
      compiled_pattern.get_chars(0, len, r, 0)
      return r
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Int, StringBuilder] }
      # Encodes the given tag and length and puts encoded char(s) into buffer.
      def encode(tag, length_, buffer)
        if (length_ < 255)
          buffer.append(RJava.cast_to_char((tag << 8 | length_)))
        else
          buffer.append(RJava.cast_to_char(((tag << 8) | 0xff)))
          buffer.append(RJava.cast_to_char((length_ >> 16)))
          buffer.append(RJava.cast_to_char((length_ & 0xffff)))
        end
      end
    }
    
    typesig { [] }
    # Initialize the fields we use to disambiguate ambiguous years. Separate
    # so we can call it from readObject().
    def initialize_default_century
      self.attr_calendar.set_time(Date.new)
      self.attr_calendar.add(Calendar::YEAR, -80)
      parse_ambiguous_dates_as_after(self.attr_calendar.get_time)
    end
    
    typesig { [Date] }
    # Define one-century window into which to disambiguate dates using
    # two-digit years.
    def parse_ambiguous_dates_as_after(start_date)
      @default_century_start = start_date
      self.attr_calendar.set_time(start_date)
      @default_century_start_year = self.attr_calendar.get(Calendar::YEAR)
    end
    
    typesig { [Date] }
    # Sets the 100-year period 2-digit years will be interpreted as being in
    # to begin on the date the user specifies.
    # 
    # @param startDate During parsing, two digit years will be placed in the range
    # <code>startDate</code> to <code>startDate + 100 years</code>.
    # @see #get2DigitYearStart
    # @since 1.2
    def set2_digit_year_start(start_date)
      parse_ambiguous_dates_as_after(start_date)
    end
    
    typesig { [] }
    # Returns the beginning date of the 100-year period 2-digit years are interpreted
    # as being within.
    # 
    # @return the start of the 100-year period into which two digit years are
    # parsed
    # @see #set2DigitYearStart
    # @since 1.2
    def get2_digit_year_start
      return @default_century_start
    end
    
    typesig { [Date, StringBuffer, FieldPosition] }
    # Formats the given <code>Date</code> into a date/time string and appends
    # the result to the given <code>StringBuffer</code>.
    # 
    # @param date the date-time value to be formatted into a date-time string.
    # @param toAppendTo where the new date-time text is to be appended.
    # @param pos the formatting position. On input: an alignment field,
    # if desired. On output: the offsets of the alignment field.
    # @return the formatted date-time string.
    # @exception NullPointerException if the given date is null
    def format(date, to_append_to, pos)
      pos.attr_begin_index = pos.attr_end_index = 0
      return format(date, to_append_to, pos.get_field_delegate)
    end
    
    typesig { [Date, StringBuffer, FieldDelegate] }
    # Called from Format after creating a FieldDelegate
    def format(date, to_append_to, delegate)
      # Convert input date to time field list
      self.attr_calendar.set_time(date)
      use_date_format_symbols_ = use_date_format_symbols
      i = 0
      while i < @compiled_pattern.attr_length
        tag = @compiled_pattern[i] >> 8
        count = @compiled_pattern[((i += 1) - 1)] & 0xff
        if ((count).equal?(255))
          count = @compiled_pattern[((i += 1) - 1)] << 16
          count |= @compiled_pattern[((i += 1) - 1)]
        end
        case (tag)
        when TAG_QUOTE_ASCII_CHAR
          to_append_to.append(RJava.cast_to_char(count))
        when TAG_QUOTE_CHARS
          to_append_to.append(@compiled_pattern, i, count)
          i += count
        else
          sub_format(tag, count, delegate, to_append_to, use_date_format_symbols_)
        end
      end
      return to_append_to
    end
    
    typesig { [Object] }
    # Formats an Object producing an <code>AttributedCharacterIterator</code>.
    # You can use the returned <code>AttributedCharacterIterator</code>
    # to build the resulting String, as well as to determine information
    # about the resulting String.
    # <p>
    # Each attribute key of the AttributedCharacterIterator will be of type
    # <code>DateFormat.Field</code>, with the corresponding attribute value
    # being the same as the attribute key.
    # 
    # @exception NullPointerException if obj is null.
    # @exception IllegalArgumentException if the Format cannot format the
    # given object, or if the Format's pattern string is invalid.
    # @param obj The object to format
    # @return AttributedCharacterIterator describing the formatted value.
    # @since 1.4
    def format_to_character_iterator(obj)
      sb = StringBuffer.new
      delegate = CharacterIteratorFieldDelegate.new
      if (obj.is_a?(Date))
        format(obj, sb, delegate)
      else
        if (obj.is_a?(Numeric))
          format(Date.new((obj).long_value), sb, delegate)
        else
          if ((obj).nil?)
            raise NullPointerException.new("formatToCharacterIterator must be passed non-null object")
          else
            raise IllegalArgumentException.new("Cannot format given Object as a Date")
          end
        end
      end
      return delegate.get_iterator(sb.to_s)
    end
    
    class_module.module_eval {
      # Map index into pattern character string to Calendar field number
      const_set_lazy(:PATTERN_INDEX_TO_CALENDAR_FIELD) { Array.typed(::Java::Int).new([Calendar::ERA, Calendar::YEAR, Calendar::MONTH, Calendar::DATE, Calendar::HOUR_OF_DAY, Calendar::HOUR_OF_DAY, Calendar::MINUTE, Calendar::SECOND, Calendar::MILLISECOND, Calendar::DAY_OF_WEEK, Calendar::DAY_OF_YEAR, Calendar::DAY_OF_WEEK_IN_MONTH, Calendar::WEEK_OF_YEAR, Calendar::WEEK_OF_MONTH, Calendar::AM_PM, Calendar::HOUR, Calendar::HOUR, Calendar::ZONE_OFFSET, Calendar::ZONE_OFFSET]) }
      const_attr_reader  :PATTERN_INDEX_TO_CALENDAR_FIELD
      
      # Map index into pattern character string to DateFormat field number
      const_set_lazy(:PATTERN_INDEX_TO_DATE_FORMAT_FIELD) { Array.typed(::Java::Int).new([DateFormat::ERA_FIELD, DateFormat::YEAR_FIELD, DateFormat::MONTH_FIELD, DateFormat::DATE_FIELD, DateFormat::HOUR_OF_DAY1_FIELD, DateFormat::HOUR_OF_DAY0_FIELD, DateFormat::MINUTE_FIELD, DateFormat::SECOND_FIELD, DateFormat::MILLISECOND_FIELD, DateFormat::DAY_OF_WEEK_FIELD, DateFormat::DAY_OF_YEAR_FIELD, DateFormat::DAY_OF_WEEK_IN_MONTH_FIELD, DateFormat::WEEK_OF_YEAR_FIELD, DateFormat::WEEK_OF_MONTH_FIELD, DateFormat::AM_PM_FIELD, DateFormat::HOUR1_FIELD, DateFormat::HOUR0_FIELD, DateFormat::TIMEZONE_FIELD, DateFormat::TIMEZONE_FIELD, ]) }
      const_attr_reader  :PATTERN_INDEX_TO_DATE_FORMAT_FIELD
      
      # Maps from DecimalFormatSymbols index to Field constant
      const_set_lazy(:PATTERN_INDEX_TO_DATE_FORMAT_FIELD_ID) { Array.typed(Field).new([Field::ERA, Field::YEAR, Field::MONTH, Field::DAY_OF_MONTH, Field::HOUR_OF_DAY1, Field::HOUR_OF_DAY0, Field::MINUTE, Field::SECOND, Field::MILLISECOND, Field::DAY_OF_WEEK, Field::DAY_OF_YEAR, Field::DAY_OF_WEEK_IN_MONTH, Field::WEEK_OF_YEAR, Field::WEEK_OF_MONTH, Field::AM_PM, Field::HOUR1, Field::HOUR0, Field::TIME_ZONE, Field::TIME_ZONE, ]) }
      const_attr_reader  :PATTERN_INDEX_TO_DATE_FORMAT_FIELD_ID
    }
    
    typesig { [::Java::Int, ::Java::Int, FieldDelegate, StringBuffer, ::Java::Boolean] }
    # Private member function that does the real date/time formatting.
    def sub_format(pattern_char_index, count, delegate, buffer, use_date_format_symbols_)
      max_int_count = JavaInteger::MAX_VALUE
      current = nil
      begin_offset = buffer.length
      field = PATTERN_INDEX_TO_CALENDAR_FIELD[pattern_char_index]
      value = self.attr_calendar.get(field)
      style = (count >= 4) ? Calendar::LONG : Calendar::SHORT
      if (!use_date_format_symbols_)
        current = (self.attr_calendar.get_display_name(field, style, @locale)).to_s
      end
      # Note: zeroPaddingNumber() assumes that maxDigits is either
      # 2 or maxIntCount. If we make any changes to this,
      # zeroPaddingNumber() must be fixed.
      case (pattern_char_index)
      when 0
        # 'G' - ERA
        if (use_date_format_symbols_)
          eras = @format_data.get_eras
          if (value < eras.attr_length)
            current = (eras[value]).to_s
          end
        end
        if ((current).nil?)
          current = ""
        end
      when 1
        # 'y' - YEAR
        if (self.attr_calendar.is_a?(GregorianCalendar))
          if (count >= 4)
            zero_padding_number(value, count, max_int_count, buffer)
          else
            # count < 4
            zero_padding_number(value, 2, 2, buffer)
          end # clip 1996 to 96
        else
          if ((current).nil?)
            zero_padding_number(value, (style).equal?(Calendar::LONG) ? 1 : count, max_int_count, buffer)
          end
        end
      when 2
        # 'M' - MONTH
        if (use_date_format_symbols_)
          months = nil
          if (count >= 4)
            months = @format_data.get_months
            current = (months[value]).to_s
          else
            if ((count).equal?(3))
              months = @format_data.get_short_months
              current = (months[value]).to_s
            end
          end
        else
          if (count < 3)
            current = (nil).to_s
          end
        end
        if ((current).nil?)
          zero_padding_number(value + 1, count, max_int_count, buffer)
        end
      when 4
        # 'k' - HOUR_OF_DAY: 1-based.  eg, 23:59 + 1 hour =>> 24:59
        if ((current).nil?)
          if ((value).equal?(0))
            zero_padding_number(self.attr_calendar.get_maximum(Calendar::HOUR_OF_DAY) + 1, count, max_int_count, buffer)
          else
            zero_padding_number(value, count, max_int_count, buffer)
          end
        end
      when 9
        # 'E' - DAY_OF_WEEK
        if (use_date_format_symbols_)
          weekdays = nil
          if (count >= 4)
            weekdays = @format_data.get_weekdays
            current = (weekdays[value]).to_s
          else
            # count < 4, use abbreviated form if exists
            weekdays = @format_data.get_short_weekdays
            current = (weekdays[value]).to_s
          end
        end
      when 14
        # 'a' - AM_PM
        if (use_date_format_symbols_)
          ampm = @format_data.get_am_pm_strings
          current = (ampm[value]).to_s
        end
      when 15
        # 'h' - HOUR:1-based.  eg, 11PM + 1 hour =>> 12 AM
        if ((current).nil?)
          if ((value).equal?(0))
            zero_padding_number(self.attr_calendar.get_least_maximum(Calendar::HOUR) + 1, count, max_int_count, buffer)
          else
            zero_padding_number(value, count, max_int_count, buffer)
          end
        end
      when 17
        # 'z' - ZONE_OFFSET
        if ((current).nil?)
          if ((@format_data.attr_locale).nil? || @format_data.attr_is_zone_strings_set)
            zone_index = @format_data.get_zone_index(self.attr_calendar.get_time_zone.get_id)
            if ((zone_index).equal?(-1))
              value = self.attr_calendar.get(Calendar::ZONE_OFFSET) + self.attr_calendar.get(Calendar::DST_OFFSET)
              buffer.append(ZoneInfoFile.to_custom_id(value))
            else
              index = ((self.attr_calendar.get(Calendar::DST_OFFSET)).equal?(0)) ? 1 : 3
              if (count < 4)
                # Use the short name
                index += 1
              end
              zone_strings = @format_data.get_zone_strings_wrapper
              buffer.append(zone_strings[zone_index][index])
            end
          else
            tz = self.attr_calendar.get_time_zone
            daylight = (!(self.attr_calendar.get(Calendar::DST_OFFSET)).equal?(0))
            tzstyle = (count < 4 ? TimeZone::SHORT : TimeZone::LONG)
            buffer.append(tz.get_display_name(daylight, tzstyle, @format_data.attr_locale))
          end
        end
      when 18
        # 'Z' - ZONE_OFFSET ("-/+hhmm" form)
        value = (self.attr_calendar.get(Calendar::ZONE_OFFSET) + self.attr_calendar.get(Calendar::DST_OFFSET)) / 60000
        width = 4
        if (value >= 0)
          buffer.append(Character.new(?+.ord))
        else
          width += 1
        end
        num = (value / 60) * 100 + (value % 60)
        CalendarUtils.sprintf0d(buffer, num, width)
      else
        # case 3: // 'd' - DATE
        # case 5: // 'H' - HOUR_OF_DAY:0-based.  eg, 23:59 + 1 hour =>> 00:59
        # case 6: // 'm' - MINUTE
        # case 7: // 's' - SECOND
        # case 8: // 'S' - MILLISECOND
        # case 10: // 'D' - DAY_OF_YEAR
        # case 11: // 'F' - DAY_OF_WEEK_IN_MONTH
        # case 12: // 'w' - WEEK_OF_YEAR
        # case 13: // 'W' - WEEK_OF_MONTH
        # case 16: // 'K' - HOUR: 0-based.  eg, 11PM + 1 hour =>> 0 AM
        if ((current).nil?)
          zero_padding_number(value, count, max_int_count, buffer)
        end
      end
      # switch (patternCharIndex)
      if (!(current).nil?)
        buffer.append(current)
      end
      field_id = PATTERN_INDEX_TO_DATE_FORMAT_FIELD[pattern_char_index]
      f = PATTERN_INDEX_TO_DATE_FORMAT_FIELD_ID[pattern_char_index]
      delegate.formatted(field_id, f, f, begin_offset, buffer.length, buffer)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, StringBuffer] }
    # Formats a number with the specified minimum and maximum number of digits.
    def zero_padding_number(value, min_digits, max_digits, buffer)
      # Optimization for 1, 2 and 4 digit numbers. This should
      # cover most cases of formatting date/time related items.
      # Note: This optimization code assumes that maxDigits is
      # either 2 or Integer.MAX_VALUE (maxIntCount in format()).
      begin
        if ((@zero_digit).equal?(0))
          @zero_digit = (self.attr_number_format).get_decimal_format_symbols.get_zero_digit
        end
        if (value >= 0)
          if (value < 100 && min_digits >= 1 && min_digits <= 2)
            if (value < 10)
              if ((min_digits).equal?(2))
                buffer.append(@zero_digit)
              end
              buffer.append(RJava.cast_to_char((@zero_digit + value)))
            else
              buffer.append(RJava.cast_to_char((@zero_digit + value / 10)))
              buffer.append(RJava.cast_to_char((@zero_digit + value % 10)))
            end
            return
          else
            if (value >= 1000 && value < 10000)
              if ((min_digits).equal?(4))
                buffer.append(RJava.cast_to_char((@zero_digit + value / 1000)))
                value %= 1000
                buffer.append(RJava.cast_to_char((@zero_digit + value / 100)))
                value %= 100
                buffer.append(RJava.cast_to_char((@zero_digit + value / 10)))
                buffer.append(RJava.cast_to_char((@zero_digit + value % 10)))
                return
              end
              if ((min_digits).equal?(2) && (max_digits).equal?(2))
                zero_padding_number(value % 100, 2, 2, buffer)
                return
              end
            end
          end
        end
      rescue Exception => e
      end
      self.attr_number_format.set_minimum_integer_digits(min_digits)
      self.attr_number_format.set_maximum_integer_digits(max_digits)
      self.attr_number_format.format(value, buffer, DontCareFieldPosition::INSTANCE)
    end
    
    typesig { [String, ParsePosition] }
    # Parses text from a string to produce a <code>Date</code>.
    # <p>
    # The method attempts to parse text starting at the index given by
    # <code>pos</code>.
    # If parsing succeeds, then the index of <code>pos</code> is updated
    # to the index after the last character used (parsing does not necessarily
    # use all characters up to the end of the string), and the parsed
    # date is returned. The updated <code>pos</code> can be used to
    # indicate the starting point for the next call to this method.
    # If an error occurs, then the index of <code>pos</code> is not
    # changed, the error index of <code>pos</code> is set to the index of
    # the character where the error occurred, and null is returned.
    # 
    # @param text  A <code>String</code>, part of which should be parsed.
    # @param pos   A <code>ParsePosition</code> object with index and error
    # index information as described above.
    # @return A <code>Date</code> parsed from the string. In case of
    # error, returns null.
    # @exception NullPointerException if <code>text</code> or <code>pos</code> is null.
    def parse(text, pos)
      start = pos.attr_index
      old_start = start
      text_length = text.length
      self.attr_calendar.clear # Clears all the time fields
      ambiguous_year = Array.typed(::Java::Boolean).new([false])
      i = 0
      while i < @compiled_pattern.attr_length
        tag = @compiled_pattern[i] >> 8
        count = @compiled_pattern[((i += 1) - 1)] & 0xff
        if ((count).equal?(255))
          count = @compiled_pattern[((i += 1) - 1)] << 16
          count |= @compiled_pattern[((i += 1) - 1)]
        end
        case (tag)
        when TAG_QUOTE_ASCII_CHAR
          if (start >= text_length || !(text.char_at(start)).equal?(RJava.cast_to_char(count)))
            pos.attr_index = old_start
            pos.attr_error_index = start
            return nil
          end
          start += 1
        when TAG_QUOTE_CHARS
          while (((count -= 1) + 1) > 0)
            if (start >= text_length || !(text.char_at(start)).equal?(@compiled_pattern[((i += 1) - 1)]))
              pos.attr_index = old_start
              pos.attr_error_index = start
              return nil
            end
            start += 1
          end
        else
          # Peek the next pattern to determine if we need to
          # obey the number of pattern letters for
          # parsing. It's required when parsing contiguous
          # digit text (e.g., "20010704") with a pattern which
          # has no delimiters between fields, like "yyyyMMdd".
          obey_count = false
          if (i < @compiled_pattern.attr_length)
            next_tag = @compiled_pattern[i] >> 8
            if (!((next_tag).equal?(TAG_QUOTE_ASCII_CHAR) || (next_tag).equal?(TAG_QUOTE_CHARS)))
              obey_count = true
            end
          end
          start = sub_parse(text, start, tag, count, obey_count, ambiguous_year, pos)
          if (start < 0)
            pos.attr_index = old_start
            return nil
          end
        end
      end
      # At this point the fields of Calendar have been set.  Calendar
      # will fill in default values for missing fields when the time
      # is computed.
      pos.attr_index = start
      # This part is a problem:  When we call parsedDate.after, we compute the time.
      # Take the date April 3 2004 at 2:30 am.  When this is first set up, the year
      # will be wrong if we're parsing a 2-digit year pattern.  It will be 1904.
      # April 3 1904 is a Sunday (unlike 2004) so it is the DST onset day.  2:30 am
      # is therefore an "impossible" time, since the time goes from 1:59 to 3:00 am
      # on that day.  It is therefore parsed out to fields as 3:30 am.  Then we
      # add 100 years, and get April 3 2004 at 3:30 am.  Note that April 3 2004 is
      # a Saturday, so it can have a 2:30 am -- and it should. [LIU]
      # 
      # Date parsedDate = calendar.getTime();
      # if( ambiguousYear[0] && !parsedDate.after(defaultCenturyStart) ) {
      # calendar.add(Calendar.YEAR, 100);
      # parsedDate = calendar.getTime();
      # }
      # 
      # Because of the above condition, save off the fields in case we need to readjust.
      # The procedure we use here is not particularly efficient, but there is no other
      # way to do this given the API restrictions present in Calendar.  We minimize
      # inefficiency by only performing this computation when it might apply, that is,
      # when the two-digit year is equal to the start year, and thus might fall at the
      # front or the back of the default century.  This only works because we adjust
      # the year correctly to start with in other cases -- see subParse().
      parsed_date = nil
      begin
        if (ambiguous_year[0])
          # If this is true then the two-digit year == the default start year
          # We need a copy of the fields, and we need to avoid triggering a call to
          # complete(), which will recalculate the fields.  Since we can't access
          # the fields[] array in Calendar, we clone the entire object.  This will
          # stop working if Calendar.clone() is ever rewritten to call complete().
          saved_calendar = self.attr_calendar.clone
          parsed_date = self.attr_calendar.get_time
          if (parsed_date.before(@default_century_start))
            # We can't use add here because that does a complete() first.
            saved_calendar.set(Calendar::YEAR, @default_century_start_year + 100)
            parsed_date = saved_calendar.get_time
          end
        else
          parsed_date = self.attr_calendar.get_time
        end
      # An IllegalArgumentException will be thrown by Calendar.getTime()
      # if any fields are out of range, e.g., MONTH == 17.
      rescue IllegalArgumentException => e
        pos.attr_error_index = start
        pos.attr_index = old_start
        return nil
      end
      return parsed_date
    end
    
    typesig { [String, ::Java::Int, ::Java::Int, Array.typed(String)] }
    # Private code-size reduction function used by subParse.
    # @param text the time text being parsed.
    # @param start where to start parsing.
    # @param field the date field being parsed.
    # @param data the string array to parsed.
    # @return the new start position if matching succeeded; a negative number
    # indicating matching failure, otherwise.
    def match_string(text, start, field, data)
      i = 0
      count = data.attr_length
      if ((field).equal?(Calendar::DAY_OF_WEEK))
        i = 1
      end
      # There may be multiple strings in the data[] array which begin with
      # the same prefix (e.g., Cerven and Cervenec (June and July) in Czech).
      # We keep track of the longest match, and return that.  Note that this
      # unfortunately requires us to test all array elements.
      best_match_length = 0
      best_match = -1
      while i < count
        length_ = data[i].length
        # Always compare if we have no match yet; otherwise only compare
        # against potentially better matches (longer strings).
        if (length_ > best_match_length && text.region_matches(true, start, data[i], 0, length_))
          best_match = i
          best_match_length = length_
        end
        (i += 1)
      end
      if (best_match >= 0)
        self.attr_calendar.set(field, best_match)
        return start + best_match_length
      end
      return -start
    end
    
    typesig { [String, ::Java::Int, ::Java::Int, Map] }
    # Performs the same thing as matchString(String, int, int,
    # String[]). This method takes a Map<String, Integer> instead of
    # String[].
    def match_string(text, start, field, data)
      if (!(data).nil?)
        best_match = nil
        data.key_set.each do |name|
          length_ = name.length
          if ((best_match).nil? || length_ > best_match.length)
            if (text.region_matches(true, start, name, 0, length_))
              best_match = name
            end
          end
        end
        if (!(best_match).nil?)
          self.attr_calendar.set(field, data.get(best_match))
          return start + best_match.length
        end
      end
      return -start
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    def match_zone_string(text, start, zone_index)
      j = 1
      while j <= 4
        # Checking long and short zones [1 & 2],
        # and long and short daylight [3 & 4].
        zone_strings = @format_data.get_zone_strings_wrapper
        zone_name = zone_strings[zone_index][j]
        if (text.region_matches(true, start, zone_name, 0, zone_name.length))
          return j
        end
        (j += 1)
      end
      return -1
    end
    
    typesig { [String, ::Java::Int, ::Java::Int, ::Java::Int] }
    def match_dststring(text, start, zone_index, standard_index)
      index = standard_index + 2
      zone_strings = @format_data.get_zone_strings_wrapper
      zone_name = zone_strings[zone_index][index]
      if (text.region_matches(true, start, zone_name, 0, zone_name.length))
        return true
      end
      return false
    end
    
    typesig { [String, ::Java::Int] }
    # find time zone 'text' matched zoneStrings and set to internal
    # calendar.
    def sub_parse_zone_string(text, start)
      use_same_name = false # true if standard and daylight time use the same abbreviation.
      current_time_zone = get_time_zone
      # At this point, check for named time zones by looking through
      # the locale data from the TimeZoneNames strings.
      # Want to be able to parse both short and long forms.
      zone_index = @format_data.get_zone_index(current_time_zone.get_id)
      tz = nil
      zone_strings = @format_data.get_zone_strings_wrapper
      j = 0
      i = 0
      if ((!(zone_index).equal?(-1)) && ((j = match_zone_string(text, start, zone_index)) > 0))
        if (j <= 2)
          use_same_name = match_dststring(text, start, zone_index, j)
        end
        tz = TimeZone.get_time_zone(zone_strings[zone_index][0])
        i = zone_index
      end
      if ((tz).nil?)
        zone_index = @format_data.get_zone_index(TimeZone.get_default.get_id)
        if ((!(zone_index).equal?(-1)) && ((j = match_zone_string(text, start, zone_index)) > 0))
          if (j <= 2)
            use_same_name = match_dststring(text, start, zone_index, j)
          end
          tz = TimeZone.get_time_zone(zone_strings[zone_index][0])
          i = zone_index
        end
      end
      if ((tz).nil?)
        i = 0
        while i < zone_strings.attr_length
          if ((j = match_zone_string(text, start, i)) > 0)
            if (j <= 2)
              use_same_name = match_dststring(text, start, i, j)
            end
            tz = TimeZone.get_time_zone(zone_strings[i][0])
            break
          end
          i += 1
        end
      end
      if (!(tz).nil?)
        # Matched any ?
        if (!(tz == current_time_zone))
          set_time_zone(tz)
        end
        # If the time zone matched uses the same name
        # (abbreviation) for both standard and daylight time,
        # let the time zone in the Calendar decide which one.
        if (!use_same_name)
          self.attr_calendar.set(Calendar::ZONE_OFFSET, tz.get_raw_offset)
          self.attr_calendar.set(Calendar::DST_OFFSET, j >= 3 ? tz.get_dstsavings : 0)
        end
        return (start + zone_strings[i][j].length)
      end
      return 0
    end
    
    typesig { [String, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Boolean, Array.typed(::Java::Boolean), ParsePosition] }
    # Private member function that converts the parsed date strings into
    # timeFields. Returns -start (for ParsePosition) if failed.
    # @param text the time text to be parsed.
    # @param start where to start parsing.
    # @param ch the pattern character for the date field text to be parsed.
    # @param count the count of a pattern character.
    # @param obeyCount if true, then the next field directly abuts this one,
    # and we should use the count to know when to stop parsing.
    # @param ambiguousYear return parameter; upon return, if ambiguousYear[0]
    # is true, then a two-digit year was parsed and may need to be readjusted.
    # @param origPos origPos.errorIndex is used to return an error index
    # at which a parse error occurred, if matching failure occurs.
    # @return the new start position if matching succeeded; -1 indicating
    # matching failure, otherwise. In case matching failure occurred,
    # an error index is set to origPos.errorIndex.
    def sub_parse(text, start, pattern_char_index, count, obey_count, ambiguous_year, orig_pos)
      number = nil
      value = 0
      pos = ParsePosition.new(0)
      pos.attr_index = start
      field = PATTERN_INDEX_TO_CALENDAR_FIELD[pattern_char_index]
      # If there are any spaces here, skip over them.  If we hit the end
      # of the string, then fail.
      loop do
        if (pos.attr_index >= text.length)
          orig_pos.attr_error_index = start
          return -1
        end
        c = text.char_at(pos.attr_index)
        if (!(c).equal?(Character.new(?\s.ord)) && !(c).equal?(Character.new(?\t.ord)))
          break
        end
        (pos.attr_index += 1)
      end
      # We handle a few special cases here where we need to parse
      # a number value.  We handle further, more generic cases below.  We need
      # to handle some of them here because some fields require extra processing on
      # the parsed value.
      # HOUR_OF_DAY1_FIELD
      # HOUR1_FIELD
      # MONTH_FIELD
      if ((pattern_char_index).equal?(4) || (pattern_char_index).equal?(15) || ((pattern_char_index).equal?(2) && count <= 2) || (pattern_char_index).equal?(1))
        # It would be good to unify this with the obeyCount logic below,
        # but that's going to be difficult.
        if (obey_count)
          if ((start + count) > text.length)
            orig_pos.attr_error_index = start
            return -1
          end
          number = self.attr_number_format.parse(text.substring(0, start + count), pos)
        else
          number = self.attr_number_format.parse(text, pos)
        end
        if ((number).nil?)
          if (!(pattern_char_index).equal?(1) || self.attr_calendar.is_a?(GregorianCalendar))
            orig_pos.attr_error_index = pos.attr_index
            return -1
          end
        else
          value = number.int_value
        end
      end
      use_date_format_symbols_ = use_date_format_symbols
      index = 0
      case (pattern_char_index)
      # 'z' - ZONE_OFFSET
      when 0
        # 'G' - ERA
        if (use_date_format_symbols_)
          if ((index = match_string(text, start, Calendar::ERA, @format_data.get_eras)) > 0)
            return index
          end
        else
          map = self.attr_calendar.get_display_names(field, Calendar::ALL_STYLES, @locale)
          if ((index = match_string(text, start, field, map)) > 0)
            return index
          end
        end
        orig_pos.attr_error_index = pos.attr_index
        return -1
      when 1
        # 'y' - YEAR
        if (!(self.attr_calendar.is_a?(GregorianCalendar)))
          # calendar might have text representations for year values,
          # such as "\u5143" in JapaneseImperialCalendar.
          style = (count >= 4) ? Calendar::LONG : Calendar::SHORT
          map = self.attr_calendar.get_display_names(field, style, @locale)
          if (!(map).nil?)
            if ((index = match_string(text, start, field, map)) > 0)
              return index
            end
          end
          self.attr_calendar.set(field, value)
          return pos.attr_index
        end
        # If there are 3 or more YEAR pattern characters, this indicates
        # that the year value is to be treated literally, without any
        # two-digit year adjustments (e.g., from "01" to 2001).  Otherwise
        # we made adjustments to place the 2-digit year in the proper
        # century, for parsed strings from "00" to "99".  Any other string
        # is treated literally:  "2250", "-1", "1", "002".
        if (count <= 2 && ((pos.attr_index - start)).equal?(2) && Character.is_digit(text.char_at(start)) && Character.is_digit(text.char_at(start + 1)))
          # Assume for example that the defaultCenturyStart is 6/18/1903.
          # This means that two-digit years will be forced into the range
          # 6/18/1903 to 6/17/2003.  As a result, years 00, 01, and 02
          # correspond to 2000, 2001, and 2002.  Years 04, 05, etc. correspond
          # to 1904, 1905, etc.  If the year is 03, then it is 2003 if the
          # other fields specify a date before 6/18, or 1903 if they specify a
          # date afterwards.  As a result, 03 is an ambiguous year.  All other
          # two-digit years are unambiguous.
          ambiguous_two_digit_year = @default_century_start_year % 100
          ambiguous_year[0] = (value).equal?(ambiguous_two_digit_year)
          value += (@default_century_start_year / 100) * 100 + (value < ambiguous_two_digit_year ? 100 : 0)
        end
        self.attr_calendar.set(Calendar::YEAR, value)
        return pos.attr_index
      when 2
        # 'M' - MONTH
        if (count <= 2)
          # i.e., M or MM.
          # Don't want to parse the month if it is a string
          # while pattern uses numeric style: M or MM.
          # [We computed 'value' above.]
          self.attr_calendar.set(Calendar::MONTH, value - 1)
          return pos.attr_index
        else
          if (use_date_format_symbols_)
            # count >= 3 // i.e., MMM or MMMM
            # Want to be able to parse both short and long forms.
            # Try count == 4 first:
            new_start = 0
            if ((new_start = match_string(text, start, Calendar::MONTH, @format_data.get_months)) > 0)
              return new_start
            else
              # count == 4 failed, now try count == 3
              if ((index = match_string(text, start, Calendar::MONTH, @format_data.get_short_months)) > 0)
                return index
              end
            end
          else
            map = self.attr_calendar.get_display_names(field, Calendar::ALL_STYLES, @locale)
            if ((index = match_string(text, start, field, map)) > 0)
              return index
            end
          end
        end
        orig_pos.attr_error_index = pos.attr_index
        return -1
      when 4
        # 'k' - HOUR_OF_DAY: 1-based.  eg, 23:59 + 1 hour =>> 24:59
        # [We computed 'value' above.]
        if ((value).equal?(self.attr_calendar.get_maximum(Calendar::HOUR_OF_DAY) + 1))
          value = 0
        end
        self.attr_calendar.set(Calendar::HOUR_OF_DAY, value)
        return pos.attr_index
      when 9
        # 'E' - DAY_OF_WEEK
        if (use_date_format_symbols_)
          # Want to be able to parse both short and long forms.
          # Try count == 4 (DDDD) first:
          new_start = 0
          if ((new_start = match_string(text, start, Calendar::DAY_OF_WEEK, @format_data.get_weekdays)) > 0)
            return new_start
          else
            # DDDD failed, now try DDD
            if ((index = match_string(text, start, Calendar::DAY_OF_WEEK, @format_data.get_short_weekdays)) > 0)
              return index
            end
          end
        else
          styles = Array.typed(::Java::Int).new([Calendar::LONG, Calendar::SHORT])
          styles.each do |style|
            map = self.attr_calendar.get_display_names(field, style, @locale)
            if ((index = match_string(text, start, field, map)) > 0)
              return index
            end
          end
        end
        orig_pos.attr_error_index = pos.attr_index
        return -1
      when 14
        # 'a' - AM_PM
        if (use_date_format_symbols_)
          if ((index = match_string(text, start, Calendar::AM_PM, @format_data.get_am_pm_strings)) > 0)
            return index
          end
        else
          map = self.attr_calendar.get_display_names(field, Calendar::ALL_STYLES, @locale)
          if ((index = match_string(text, start, field, map)) > 0)
            return index
          end
        end
        orig_pos.attr_error_index = pos.attr_index
        return -1
      when 15
        # 'h' - HOUR:1-based.  eg, 11PM + 1 hour =>> 12 AM
        # [We computed 'value' above.]
        if ((value).equal?(self.attr_calendar.get_least_maximum(Calendar::HOUR) + 1))
          value = 0
        end
        self.attr_calendar.set(Calendar::HOUR, value)
        return pos.attr_index
      when 17, 18
        # 'Z' - ZONE_OFFSET
        # First try to parse generic forms such as GMT-07:00. Do this first
        # in case localized TimeZoneNames contains the string "GMT"
        # for a zone; in that case, we don't want to match the first three
        # characters of GMT+/-hh:mm etc.
        sign = 0
        offset = 0
        # For time zones that have no known names, look for strings
        # of the form:
        # GMT[+-]hours:minutes or
        # GMT.
        if ((text.length - start) >= GMT.length && text.region_matches(true, start, GMT, 0, GMT.length))
          num = 0
          self.attr_calendar.set(Calendar::DST_OFFSET, 0)
          pos.attr_index = start + GMT.length
          begin
            # try-catch for "GMT" only time zone string
            if ((text.char_at(pos.attr_index)).equal?(Character.new(?+.ord)))
              sign = 1
            else
              if ((text.char_at(pos.attr_index)).equal?(Character.new(?-.ord)))
                sign = -1
              end
            end
          rescue StringIndexOutOfBoundsException => e
          end
          if ((sign).equal?(0))
            # "GMT" without offset
            self.attr_calendar.set(Calendar::ZONE_OFFSET, 0)
            return pos.attr_index
          end
          # Look for hours.
          begin
            c = text.char_at((pos.attr_index += 1))
            if (c < Character.new(?0.ord) || c > Character.new(?9.ord))
              # must be from '0' to '9'.
              orig_pos.attr_error_index = pos.attr_index
              return -1 # Wasn't actually a number.
            else
              num = c - Character.new(?0.ord)
            end
            if (!(text.char_at((pos.attr_index += 1))).equal?(Character.new(?:.ord)))
              c = text.char_at(pos.attr_index)
              if (c < Character.new(?0.ord) || c > Character.new(?9.ord))
                # must be from '0' to '9'.
                orig_pos.attr_error_index = pos.attr_index
                return -1 # Wasn't actually a number.
              else
                num *= 10
                num += c - Character.new(?0.ord)
                pos.attr_index += 1
              end
            end
            if (num > 23)
              orig_pos.attr_error_index = pos.attr_index - 1
              return -1 # Wasn't actually a number.
            end
            if (!(text.char_at(pos.attr_index)).equal?(Character.new(?:.ord)))
              orig_pos.attr_error_index = pos.attr_index
              return -1 # Wasn't actually a number.
            end
          rescue StringIndexOutOfBoundsException => e
            orig_pos.attr_error_index = pos.attr_index
            return -1 # Wasn't actually a number.
          end
          # Look for minutes.
          offset = num * 60
          begin
            c_ = text.char_at((pos.attr_index += 1))
            if (c_ < Character.new(?0.ord) || c_ > Character.new(?9.ord))
              # must be from '0' to '9'.
              orig_pos.attr_error_index = pos.attr_index
              return -1 # Wasn't actually a number.
            else
              num = c_ - Character.new(?0.ord)
              c_ = text.char_at((pos.attr_index += 1))
              if (c_ < Character.new(?0.ord) || c_ > Character.new(?9.ord))
                # must be from '0' to '9'.
                orig_pos.attr_error_index = pos.attr_index
                return -1 # Wasn't actually a number.
              else
                num *= 10
                num += c_ - Character.new(?0.ord)
              end
            end
            if (num > 59)
              orig_pos.attr_error_index = pos.attr_index
              return -1 # Wasn't actually a number.
            end
          rescue StringIndexOutOfBoundsException => e
            orig_pos.attr_error_index = pos.attr_index
            return -1 # Wasn't actually a number.
          end
          offset += num
          # Fall through for final processing below of 'offset' and 'sign'.
        else
          # At this point, check for named time zones by looking through
          # the locale data from the TimeZoneNames strings.
          # Want to be able to parse both short and long forms.
          i = sub_parse_zone_string(text, pos.attr_index)
          if (!(i).equal?(0))
            return i
          end
          # As a last resort, look for numeric timezones of the form
          # [+-]hhmm as specified by RFC 822.  This code is actually
          # a little more permissive than RFC 822.  It will try to do
          # its best with numbers that aren't strictly 4 digits long.
          begin
            if ((text.char_at(pos.attr_index)).equal?(Character.new(?+.ord)))
              sign = 1
            else
              if ((text.char_at(pos.attr_index)).equal?(Character.new(?-.ord)))
                sign = -1
              end
            end
            if ((sign).equal?(0))
              orig_pos.attr_error_index = pos.attr_index
              return -1
            end
            # Look for hh.
            hours = 0
            c = text.char_at((pos.attr_index += 1))
            if (c < Character.new(?0.ord) || c > Character.new(?9.ord))
              # must be from '0' to '9'.
              orig_pos.attr_error_index = pos.attr_index
              return -1 # Wasn't actually a number.
            else
              hours = c - Character.new(?0.ord)
              c = text.char_at((pos.attr_index += 1))
              if (c < Character.new(?0.ord) || c > Character.new(?9.ord))
                # must be from '0' to '9'.
                orig_pos.attr_error_index = pos.attr_index
                return -1 # Wasn't actually a number.
              else
                hours *= 10
                hours += c - Character.new(?0.ord)
              end
            end
            if (hours > 23)
              orig_pos.attr_error_index = pos.attr_index
              return -1 # Wasn't actually a number.
            end
            # Look for mm.
            minutes = 0
            c = text.char_at((pos.attr_index += 1))
            if (c < Character.new(?0.ord) || c > Character.new(?9.ord))
              # must be from '0' to '9'.
              orig_pos.attr_error_index = pos.attr_index
              return -1 # Wasn't actually a number.
            else
              minutes = c - Character.new(?0.ord)
              c = text.char_at((pos.attr_index += 1))
              if (c < Character.new(?0.ord) || c > Character.new(?9.ord))
                # must be from '0' to '9'.
                orig_pos.attr_error_index = pos.attr_index
                return -1 # Wasn't actually a number.
              else
                minutes *= 10
                minutes += c - Character.new(?0.ord)
              end
            end
            if (minutes > 59)
              orig_pos.attr_error_index = pos.attr_index
              return -1 # Wasn't actually a number.
            end
            offset = hours * 60 + minutes
          rescue StringIndexOutOfBoundsException => e
            orig_pos.attr_error_index = pos.attr_index
            return -1 # Wasn't actually a number.
          end
        end
        # Do the final processing for both of the above cases.  We only
        # arrive here if the form GMT+/-... or an RFC 822 form was seen.
        if (!(sign).equal?(0))
          offset *= MillisPerMinute * sign
          self.attr_calendar.set(Calendar::ZONE_OFFSET, offset)
          self.attr_calendar.set(Calendar::DST_OFFSET, 0)
          return (pos.attr_index += 1)
        end
        # All efforts to parse a zone failed.
        orig_pos.attr_error_index = pos.attr_index
        return -1
      else
        # case 3: // 'd' - DATE
        # case 5: // 'H' - HOUR_OF_DAY:0-based.  eg, 23:59 + 1 hour =>> 00:59
        # case 6: // 'm' - MINUTE
        # case 7: // 's' - SECOND
        # case 8: // 'S' - MILLISECOND
        # case 10: // 'D' - DAY_OF_YEAR
        # case 11: // 'F' - DAY_OF_WEEK_IN_MONTH
        # case 12: // 'w' - WEEK_OF_YEAR
        # case 13: // 'W' - WEEK_OF_MONTH
        # case 16: // 'K' - HOUR: 0-based.  eg, 11PM + 1 hour =>> 0 AM
        # Handle "generic" fields
        if (obey_count)
          if ((start + count) > text.length)
            orig_pos.attr_error_index = pos.attr_index
            return -1
          end
          number = self.attr_number_format.parse(text.substring(0, start + count), pos)
        else
          number = self.attr_number_format.parse(text, pos)
        end
        if (!(number).nil?)
          self.attr_calendar.set(field, number.int_value)
          return pos.attr_index
        end
        orig_pos.attr_error_index = pos.attr_index
        return -1
      end
    end
    
    typesig { [] }
    def get_calendar_name
      return self.attr_calendar.get_class.get_name
    end
    
    typesig { [] }
    def use_date_format_symbols
      if (@use_date_format_symbols)
        return true
      end
      return is_gregorian_calendar || (@locale).nil?
    end
    
    typesig { [] }
    def is_gregorian_calendar
      return ("java.util.GregorianCalendar" == get_calendar_name)
    end
    
    typesig { [String, String, String] }
    # Translates a pattern, mapping each character in the from string to the
    # corresponding character in the to string.
    # 
    # @exception IllegalArgumentException if the given pattern is invalid
    def translate_pattern(pattern, from, to)
      result = StringBuilder.new
      in_quote = false
      i = 0
      while i < pattern.length
        c = pattern.char_at(i)
        if (in_quote)
          if ((c).equal?(Character.new(?\'.ord)))
            in_quote = false
          end
        else
          if ((c).equal?(Character.new(?\'.ord)))
            in_quote = true
          else
            if ((c >= Character.new(?a.ord) && c <= Character.new(?z.ord)) || (c >= Character.new(?A.ord) && c <= Character.new(?Z.ord)))
              ci = from.index_of(c)
              if ((ci).equal?(-1))
                raise IllegalArgumentException.new("Illegal pattern " + " character '" + (c).to_s + "'")
              end
              c = to.char_at(ci)
            end
          end
        end
        result.append(c)
        (i += 1)
      end
      if (in_quote)
        raise IllegalArgumentException.new("Unfinished quote in pattern")
      end
      return result.to_s
    end
    
    typesig { [] }
    # Returns a pattern string describing this date format.
    # 
    # @return a pattern string describing this date format.
    def to_pattern
      return @pattern
    end
    
    typesig { [] }
    # Returns a localized pattern string describing this date format.
    # 
    # @return a localized pattern string describing this date format.
    def to_localized_pattern
      return translate_pattern(@pattern, DateFormatSymbols.attr_pattern_chars, @format_data.get_local_pattern_chars)
    end
    
    typesig { [String] }
    # Applies the given pattern string to this date format.
    # 
    # @param pattern the new date and time pattern for this date format
    # @exception NullPointerException if the given pattern is null
    # @exception IllegalArgumentException if the given pattern is invalid
    def apply_pattern(pattern)
      @compiled_pattern = compile(pattern)
      @pattern = pattern
    end
    
    typesig { [String] }
    # Applies the given localized pattern string to this date format.
    # 
    # @param pattern a String to be mapped to the new date and time format
    # pattern for this format
    # @exception NullPointerException if the given pattern is null
    # @exception IllegalArgumentException if the given pattern is invalid
    def apply_localized_pattern(pattern)
      p = translate_pattern(pattern, @format_data.get_local_pattern_chars, DateFormatSymbols.attr_pattern_chars)
      @compiled_pattern = compile(p)
      @pattern = p
    end
    
    typesig { [] }
    # Gets a copy of the date and time format symbols of this date format.
    # 
    # @return the date and time format symbols of this date format
    # @see #setDateFormatSymbols
    def get_date_format_symbols
      return @format_data.clone
    end
    
    typesig { [DateFormatSymbols] }
    # Sets the date and time format symbols of this date format.
    # 
    # @param newFormatSymbols the new date and time format symbols
    # @exception NullPointerException if the given newFormatSymbols is null
    # @see #getDateFormatSymbols
    def set_date_format_symbols(new_format_symbols)
      @format_data = new_format_symbols.clone
      @use_date_format_symbols = true
    end
    
    typesig { [] }
    # Creates a copy of this <code>SimpleDateFormat</code>. This also
    # clones the format's date format symbols.
    # 
    # @return a clone of this <code>SimpleDateFormat</code>
    def clone
      other = super
      other.attr_format_data = @format_data.clone
      return other
    end
    
    typesig { [] }
    # Returns the hash code value for this <code>SimpleDateFormat</code> object.
    # 
    # @return the hash code value for this <code>SimpleDateFormat</code> object.
    def hash_code
      return @pattern.hash_code
      # just enough fields for a reasonable distribution
    end
    
    typesig { [Object] }
    # Compares the given object with this <code>SimpleDateFormat</code> for
    # equality.
    # 
    # @return true if the given object is equal to this
    # <code>SimpleDateFormat</code>
    def equals(obj)
      if (!super(obj))
        return false
      end # super does class check
      that = obj
      return ((@pattern == that.attr_pattern) && (@format_data == that.attr_format_data))
    end
    
    typesig { [ObjectInputStream] }
    # After reading an object from the input stream, the format
    # pattern in the object is verified.
    # <p>
    # @exception InvalidObjectException if the pattern is invalid
    def read_object(stream)
      stream.default_read_object
      begin
        @compiled_pattern = compile(@pattern)
      rescue Exception => e
        raise InvalidObjectException.new("invalid pattern")
      end
      if (@serial_version_on_stream < 1)
        # didn't have defaultCenturyStart field
        initialize_default_century
      else
        # fill in dependent transient field
        parse_ambiguous_dates_as_after(@default_century_start)
      end
      @serial_version_on_stream = CurrentSerialVersion
      # If the deserialized object has a SimpleTimeZone, try
      # to replace it with a ZoneInfo equivalent in order to
      # be compatible with the SimpleTimeZone-based
      # implementation as much as possible.
      tz = get_time_zone
      if (tz.is_a?(SimpleTimeZone))
        id = tz.get_id
        zi = TimeZone.get_time_zone(id)
        if (!(zi).nil? && zi.has_same_rules(tz) && (zi.get_id == id))
          set_time_zone(zi)
        end
      end
    end
    
    private
    alias_method :initialize__simple_date_format, :initialize
  end
  
end
