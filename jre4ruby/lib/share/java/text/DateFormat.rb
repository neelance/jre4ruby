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
# (C) Copyright IBM Corp. 1996 - All Rights Reserved
# 
# The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module DateFormatImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Io, :InvalidObjectException
      include_const ::Java::Text::Spi, :DateFormatProvider
      include_const ::Java::Util, :Calendar
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :GregorianCalendar
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util, :TimeZone
      include_const ::Java::Util::Spi, :LocaleServiceProvider
      include_const ::Sun::Util, :LocaleServiceProviderPool
    }
  end
  
  # DateFormat is an abstract class for date/time formatting subclasses which
  # formats and parses dates or time in a language-independent manner.
  # The date/time formatting subclass, such as SimpleDateFormat, allows for
  # formatting (i.e., date -> text), parsing (text -> date), and
  # normalization.  The date is represented as a <code>Date</code> object or
  # as the milliseconds since January 1, 1970, 00:00:00 GMT.
  # 
  # <p>DateFormat provides many class methods for obtaining default date/time
  # formatters based on the default or a given locale and a number of formatting
  # styles. The formatting styles include FULL, LONG, MEDIUM, and SHORT. More
  # detail and examples of using these styles are provided in the method
  # descriptions.
  # 
  # <p>DateFormat helps you to format and parse dates for any locale.
  # Your code can be completely independent of the locale conventions for
  # months, days of the week, or even the calendar format: lunar vs. solar.
  # 
  # <p>To format a date for the current Locale, use one of the
  # static factory methods:
  # <pre>
  # myString = DateFormat.getDateInstance().format(myDate);
  # </pre>
  # <p>If you are formatting multiple dates, it is
  # more efficient to get the format and use it multiple times so that
  # the system doesn't have to fetch the information about the local
  # language and country conventions multiple times.
  # <pre>
  # DateFormat df = DateFormat.getDateInstance();
  # for (int i = 0; i < myDate.length; ++i) {
  # output.println(df.format(myDate[i]) + "; ");
  # }
  # </pre>
  # <p>To format a date for a different Locale, specify it in the
  # call to getDateInstance().
  # <pre>
  # DateFormat df = DateFormat.getDateInstance(DateFormat.LONG, Locale.FRANCE);
  # </pre>
  # <p>You can use a DateFormat to parse also.
  # <pre>
  # myDate = df.parse(myString);
  # </pre>
  # <p>Use getDateInstance to get the normal date format for that country.
  # There are other static factory methods available.
  # Use getTimeInstance to get the time format for that country.
  # Use getDateTimeInstance to get a date and time format. You can pass in
  # different options to these factory methods to control the length of the
  # result; from SHORT to MEDIUM to LONG to FULL. The exact result depends
  # on the locale, but generally:
  # <ul><li>SHORT is completely numeric, such as 12.13.52 or 3:30pm
  # <li>MEDIUM is longer, such as Jan 12, 1952
  # <li>LONG is longer, such as January 12, 1952 or 3:30:32pm
  # <li>FULL is pretty completely specified, such as
  # Tuesday, April 12, 1952 AD or 3:30:42pm PST.
  # </ul>
  # 
  # <p>You can also set the time zone on the format if you wish.
  # If you want even more control over the format or parsing,
  # (or want to give your users more control),
  # you can try casting the DateFormat you get from the factory methods
  # to a SimpleDateFormat. This will work for the majority
  # of countries; just remember to put it in a try block in case you
  # encounter an unusual one.
  # 
  # <p>You can also use forms of the parse and format methods with
  # ParsePosition and FieldPosition to
  # allow you to
  # <ul><li>progressively parse through pieces of a string.
  # <li>align any particular field, or find out where it is for selection
  # on the screen.
  # </ul>
  # 
  # <h4><a name="synchronization">Synchronization</a></h4>
  # 
  # <p>
  # Date formats are not synchronized.
  # It is recommended to create separate format instances for each thread.
  # If multiple threads access a format concurrently, it must be synchronized
  # externally.
  # 
  # @see          Format
  # @see          NumberFormat
  # @see          SimpleDateFormat
  # @see          java.util.Calendar
  # @see          java.util.GregorianCalendar
  # @see          java.util.TimeZone
  # @author       Mark Davis, Chen-Lieh Huang, Alan Liu
  class DateFormat < DateFormatImports.const_get :Format
    include_class_members DateFormatImports
    
    # The calendar that <code>DateFormat</code> uses to produce the time field
    # values needed to implement date and time formatting.  Subclasses should
    # initialize this to a calendar appropriate for the locale associated with
    # this <code>DateFormat</code>.
    # @serial
    attr_accessor :calendar
    alias_method :attr_calendar, :calendar
    undef_method :calendar
    alias_method :attr_calendar=, :calendar=
    undef_method :calendar=
    
    # The number formatter that <code>DateFormat</code> uses to format numbers
    # in dates and times.  Subclasses should initialize this to a number format
    # appropriate for the locale associated with this <code>DateFormat</code>.
    # @serial
    attr_accessor :number_format
    alias_method :attr_number_format, :number_format
    undef_method :number_format
    alias_method :attr_number_format=, :number_format=
    undef_method :number_format=
    
    class_module.module_eval {
      # Useful constant for ERA field alignment.
      # Used in FieldPosition of date/time formatting.
      const_set_lazy(:ERA_FIELD) { 0 }
      const_attr_reader  :ERA_FIELD
      
      # Useful constant for YEAR field alignment.
      # Used in FieldPosition of date/time formatting.
      const_set_lazy(:YEAR_FIELD) { 1 }
      const_attr_reader  :YEAR_FIELD
      
      # Useful constant for MONTH field alignment.
      # Used in FieldPosition of date/time formatting.
      const_set_lazy(:MONTH_FIELD) { 2 }
      const_attr_reader  :MONTH_FIELD
      
      # Useful constant for DATE field alignment.
      # Used in FieldPosition of date/time formatting.
      const_set_lazy(:DATE_FIELD) { 3 }
      const_attr_reader  :DATE_FIELD
      
      # Useful constant for one-based HOUR_OF_DAY field alignment.
      # Used in FieldPosition of date/time formatting.
      # HOUR_OF_DAY1_FIELD is used for the one-based 24-hour clock.
      # For example, 23:59 + 01:00 results in 24:59.
      const_set_lazy(:HOUR_OF_DAY1_FIELD) { 4 }
      const_attr_reader  :HOUR_OF_DAY1_FIELD
      
      # Useful constant for zero-based HOUR_OF_DAY field alignment.
      # Used in FieldPosition of date/time formatting.
      # HOUR_OF_DAY0_FIELD is used for the zero-based 24-hour clock.
      # For example, 23:59 + 01:00 results in 00:59.
      const_set_lazy(:HOUR_OF_DAY0_FIELD) { 5 }
      const_attr_reader  :HOUR_OF_DAY0_FIELD
      
      # Useful constant for MINUTE field alignment.
      # Used in FieldPosition of date/time formatting.
      const_set_lazy(:MINUTE_FIELD) { 6 }
      const_attr_reader  :MINUTE_FIELD
      
      # Useful constant for SECOND field alignment.
      # Used in FieldPosition of date/time formatting.
      const_set_lazy(:SECOND_FIELD) { 7 }
      const_attr_reader  :SECOND_FIELD
      
      # Useful constant for MILLISECOND field alignment.
      # Used in FieldPosition of date/time formatting.
      const_set_lazy(:MILLISECOND_FIELD) { 8 }
      const_attr_reader  :MILLISECOND_FIELD
      
      # Useful constant for DAY_OF_WEEK field alignment.
      # Used in FieldPosition of date/time formatting.
      const_set_lazy(:DAY_OF_WEEK_FIELD) { 9 }
      const_attr_reader  :DAY_OF_WEEK_FIELD
      
      # Useful constant for DAY_OF_YEAR field alignment.
      # Used in FieldPosition of date/time formatting.
      const_set_lazy(:DAY_OF_YEAR_FIELD) { 10 }
      const_attr_reader  :DAY_OF_YEAR_FIELD
      
      # Useful constant for DAY_OF_WEEK_IN_MONTH field alignment.
      # Used in FieldPosition of date/time formatting.
      const_set_lazy(:DAY_OF_WEEK_IN_MONTH_FIELD) { 11 }
      const_attr_reader  :DAY_OF_WEEK_IN_MONTH_FIELD
      
      # Useful constant for WEEK_OF_YEAR field alignment.
      # Used in FieldPosition of date/time formatting.
      const_set_lazy(:WEEK_OF_YEAR_FIELD) { 12 }
      const_attr_reader  :WEEK_OF_YEAR_FIELD
      
      # Useful constant for WEEK_OF_MONTH field alignment.
      # Used in FieldPosition of date/time formatting.
      const_set_lazy(:WEEK_OF_MONTH_FIELD) { 13 }
      const_attr_reader  :WEEK_OF_MONTH_FIELD
      
      # Useful constant for AM_PM field alignment.
      # Used in FieldPosition of date/time formatting.
      const_set_lazy(:AM_PM_FIELD) { 14 }
      const_attr_reader  :AM_PM_FIELD
      
      # Useful constant for one-based HOUR field alignment.
      # Used in FieldPosition of date/time formatting.
      # HOUR1_FIELD is used for the one-based 12-hour clock.
      # For example, 11:30 PM + 1 hour results in 12:30 AM.
      const_set_lazy(:HOUR1_FIELD) { 15 }
      const_attr_reader  :HOUR1_FIELD
      
      # Useful constant for zero-based HOUR field alignment.
      # Used in FieldPosition of date/time formatting.
      # HOUR0_FIELD is used for the zero-based 12-hour clock.
      # For example, 11:30 PM + 1 hour results in 00:30 AM.
      const_set_lazy(:HOUR0_FIELD) { 16 }
      const_attr_reader  :HOUR0_FIELD
      
      # Useful constant for TIMEZONE field alignment.
      # Used in FieldPosition of date/time formatting.
      const_set_lazy(:TIMEZONE_FIELD) { 17 }
      const_attr_reader  :TIMEZONE_FIELD
      
      # Proclaim serial compatibility with 1.1 FCS
      const_set_lazy(:SerialVersionUID) { 7218322306649953788 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [Object, StringBuffer, FieldPosition] }
    # Overrides Format.
    # Formats a time object into a time string. Examples of time objects
    # are a time value expressed in milliseconds and a Date object.
    # @param obj must be a Number or a Date.
    # @param toAppendTo the string buffer for the returning time string.
    # @return the string buffer passed in as toAppendTo, with formatted text appended.
    # @param fieldPosition keeps track of the position of the field
    # within the returned string.
    # On input: an alignment field,
    # if desired. On output: the offsets of the alignment field. For
    # example, given a time text "1996.07.10 AD at 15:08:56 PDT",
    # if the given fieldPosition is DateFormat.YEAR_FIELD, the
    # begin index and end index of fieldPosition will be set to
    # 0 and 4, respectively.
    # Notice that if the same time field appears
    # more than once in a pattern, the fieldPosition will be set for the first
    # occurrence of that time field. For instance, formatting a Date to
    # the time string "1 PM PDT (Pacific Daylight Time)" using the pattern
    # "h a z (zzzz)" and the alignment field DateFormat.TIMEZONE_FIELD,
    # the begin index and end index of fieldPosition will be set to
    # 5 and 8, respectively, for the first occurrence of the timezone
    # pattern character 'z'.
    # @see java.text.Format
    def format(obj, to_append_to, field_position)
      if (obj.is_a?(Date))
        return format(obj, to_append_to, field_position)
      else
        if (obj.is_a?(Numeric))
          return format(Date.new((obj).long_value), to_append_to, field_position)
        else
          raise IllegalArgumentException.new("Cannot format given Object as a Date")
        end
      end
    end
    
    typesig { [Date, StringBuffer, FieldPosition] }
    # Formats a Date into a date/time string.
    # @param date a Date to be formatted into a date/time string.
    # @param toAppendTo the string buffer for the returning date/time string.
    # @param fieldPosition keeps track of the position of the field
    # within the returned string.
    # On input: an alignment field,
    # if desired. On output: the offsets of the alignment field. For
    # example, given a time text "1996.07.10 AD at 15:08:56 PDT",
    # if the given fieldPosition is DateFormat.YEAR_FIELD, the
    # begin index and end index of fieldPosition will be set to
    # 0 and 4, respectively.
    # Notice that if the same time field appears
    # more than once in a pattern, the fieldPosition will be set for the first
    # occurrence of that time field. For instance, formatting a Date to
    # the time string "1 PM PDT (Pacific Daylight Time)" using the pattern
    # "h a z (zzzz)" and the alignment field DateFormat.TIMEZONE_FIELD,
    # the begin index and end index of fieldPosition will be set to
    # 5 and 8, respectively, for the first occurrence of the timezone
    # pattern character 'z'.
    # @return the string buffer passed in as toAppendTo, with formatted text appended.
    def format(date, to_append_to, field_position)
      raise NotImplementedError
    end
    
    typesig { [Date] }
    # Formats a Date into a date/time string.
    # @param date the time value to be formatted into a time string.
    # @return the formatted time string.
    def format(date)
      return format(date, StringBuffer.new, DontCareFieldPosition::INSTANCE).to_s
    end
    
    typesig { [String] }
    # Parses text from the beginning of the given string to produce a date.
    # The method may not use the entire text of the given string.
    # <p>
    # See the {@link #parse(String, ParsePosition)} method for more information
    # on date parsing.
    # 
    # @param source A <code>String</code> whose beginning should be parsed.
    # @return A <code>Date</code> parsed from the string.
    # @exception ParseException if the beginning of the specified string
    # cannot be parsed.
    def parse(source)
      pos = ParsePosition.new(0)
      result = parse(source, pos)
      if ((pos.attr_index).equal?(0))
        raise ParseException.new("Unparseable date: \"" + source + "\"", pos.attr_error_index)
      end
      return result
    end
    
    typesig { [String, ParsePosition] }
    # Parse a date/time string according to the given parse position.  For
    # example, a time text "07/10/96 4:5 PM, PDT" will be parsed into a Date
    # that is equivalent to Date(837039928046).
    # 
    # <p> By default, parsing is lenient: If the input is not in the form used
    # by this object's format method but can still be parsed as a date, then
    # the parse succeeds.  Clients may insist on strict adherence to the
    # format by calling setLenient(false).
    # 
    # @see java.text.DateFormat#setLenient(boolean)
    # 
    # @param source  The date/time string to be parsed
    # 
    # @param pos   On input, the position at which to start parsing; on
    # output, the position at which parsing terminated, or the
    # start position if the parse failed.
    # 
    # @return      A Date, or null if the input could not be parsed
    def parse(source, pos)
      raise NotImplementedError
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
    # <p>
    # See the {@link #parse(String, ParsePosition)} method for more information
    # on date parsing.
    # 
    # @param source A <code>String</code>, part of which should be parsed.
    # @param pos A <code>ParsePosition</code> object with index and error
    # index information as described above.
    # @return A <code>Date</code> parsed from the string. In case of
    # error, returns null.
    # @exception NullPointerException if <code>pos</code> is null.
    def parse_object(source, pos)
      return parse(source, pos)
    end
    
    class_module.module_eval {
      # Constant for full style pattern.
      const_set_lazy(:FULL) { 0 }
      const_attr_reader  :FULL
      
      # Constant for long style pattern.
      const_set_lazy(:LONG) { 1 }
      const_attr_reader  :LONG
      
      # Constant for medium style pattern.
      const_set_lazy(:MEDIUM) { 2 }
      const_attr_reader  :MEDIUM
      
      # Constant for short style pattern.
      const_set_lazy(:SHORT) { 3 }
      const_attr_reader  :SHORT
      
      # Constant for default style pattern.  Its value is MEDIUM.
      const_set_lazy(:DEFAULT) { MEDIUM }
      const_attr_reader  :DEFAULT
      
      typesig { [] }
      # Gets the time formatter with the default formatting style
      # for the default locale.
      # @return a time formatter.
      def get_time_instance
        return get(DEFAULT, 0, 1, Locale.get_default)
      end
      
      typesig { [::Java::Int] }
      # Gets the time formatter with the given formatting style
      # for the default locale.
      # @param style the given formatting style. For example,
      # SHORT for "h:mm a" in the US locale.
      # @return a time formatter.
      def get_time_instance(style)
        return get(style, 0, 1, Locale.get_default)
      end
      
      typesig { [::Java::Int, Locale] }
      # Gets the time formatter with the given formatting style
      # for the given locale.
      # @param style the given formatting style. For example,
      # SHORT for "h:mm a" in the US locale.
      # @param aLocale the given locale.
      # @return a time formatter.
      def get_time_instance(style, a_locale)
        return get(style, 0, 1, a_locale)
      end
      
      typesig { [] }
      # Gets the date formatter with the default formatting style
      # for the default locale.
      # @return a date formatter.
      def get_date_instance
        return get(0, DEFAULT, 2, Locale.get_default)
      end
      
      typesig { [::Java::Int] }
      # Gets the date formatter with the given formatting style
      # for the default locale.
      # @param style the given formatting style. For example,
      # SHORT for "M/d/yy" in the US locale.
      # @return a date formatter.
      def get_date_instance(style)
        return get(0, style, 2, Locale.get_default)
      end
      
      typesig { [::Java::Int, Locale] }
      # Gets the date formatter with the given formatting style
      # for the given locale.
      # @param style the given formatting style. For example,
      # SHORT for "M/d/yy" in the US locale.
      # @param aLocale the given locale.
      # @return a date formatter.
      def get_date_instance(style, a_locale)
        return get(0, style, 2, a_locale)
      end
      
      typesig { [] }
      # Gets the date/time formatter with the default formatting style
      # for the default locale.
      # @return a date/time formatter.
      def get_date_time_instance
        return get(DEFAULT, DEFAULT, 3, Locale.get_default)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Gets the date/time formatter with the given date and time
      # formatting styles for the default locale.
      # @param dateStyle the given date formatting style. For example,
      # SHORT for "M/d/yy" in the US locale.
      # @param timeStyle the given time formatting style. For example,
      # SHORT for "h:mm a" in the US locale.
      # @return a date/time formatter.
      def get_date_time_instance(date_style, time_style)
        return get(time_style, date_style, 3, Locale.get_default)
      end
      
      typesig { [::Java::Int, ::Java::Int, Locale] }
      # Gets the date/time formatter with the given formatting styles
      # for the given locale.
      # @param dateStyle the given date formatting style.
      # @param timeStyle the given time formatting style.
      # @param aLocale the given locale.
      # @return a date/time formatter.
      def get_date_time_instance(date_style, time_style, a_locale)
        return get(time_style, date_style, 3, a_locale)
      end
      
      typesig { [] }
      # Get a default date/time formatter that uses the SHORT style for both the
      # date and the time.
      def get_instance
        return get_date_time_instance(SHORT, SHORT)
      end
      
      typesig { [] }
      # Returns an array of all locales for which the
      # <code>get*Instance</code> methods of this class can return
      # localized instances.
      # The returned array represents the union of locales supported by the Java
      # runtime and by installed
      # {@link java.text.spi.DateFormatProvider DateFormatProvider} implementations.
      # It must contain at least a <code>Locale</code> instance equal to
      # {@link java.util.Locale#US Locale.US}.
      # 
      # @return An array of locales for which localized
      # <code>DateFormat</code> instances are available.
      def get_available_locales
        pool = LocaleServiceProviderPool.get_pool(DateFormatProvider)
        return pool.get_available_locales
      end
    }
    
    typesig { [Calendar] }
    # Set the calendar to be used by this date format.  Initially, the default
    # calendar for the specified or default locale is used.
    # @param newCalendar the new Calendar to be used by the date format
    def set_calendar(new_calendar)
      @calendar = new_calendar
    end
    
    typesig { [] }
    # Gets the calendar associated with this date/time formatter.
    # @return the calendar associated with this date/time formatter.
    def get_calendar
      return @calendar
    end
    
    typesig { [NumberFormat] }
    # Allows you to set the number formatter.
    # @param newNumberFormat the given new NumberFormat.
    def set_number_format(new_number_format)
      @number_format = new_number_format
    end
    
    typesig { [] }
    # Gets the number formatter which this date/time formatter uses to
    # format and parse a time.
    # @return the number formatter which this date/time formatter uses.
    def get_number_format
      return @number_format
    end
    
    typesig { [TimeZone] }
    # Sets the time zone for the calendar of this DateFormat object.
    # @param zone the given new time zone.
    def set_time_zone(zone)
      @calendar.set_time_zone(zone)
    end
    
    typesig { [] }
    # Gets the time zone.
    # @return the time zone associated with the calendar of DateFormat.
    def get_time_zone
      return @calendar.get_time_zone
    end
    
    typesig { [::Java::Boolean] }
    # Specify whether or not date/time parsing is to be lenient.  With
    # lenient parsing, the parser may use heuristics to interpret inputs that
    # do not precisely match this object's format.  With strict parsing,
    # inputs must match this object's format.
    # @param lenient when true, parsing is lenient
    # @see java.util.Calendar#setLenient
    def set_lenient(lenient)
      @calendar.set_lenient(lenient)
    end
    
    typesig { [] }
    # Tell whether date/time parsing is to be lenient.
    def is_lenient
      return @calendar.is_lenient
    end
    
    typesig { [] }
    # Overrides hashCode
    def hash_code
      return @number_format.hash_code
      # just enough fields for a reasonable distribution
    end
    
    typesig { [Object] }
    # Overrides equals
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if ((obj).nil? || !(get_class).equal?(obj.get_class))
        return false
      end
      other = obj
      # calendar.equivalentTo(other.calendar) // THIS API DOESN'T EXIST YET!
      return ((@calendar.get_first_day_of_week).equal?(other.attr_calendar.get_first_day_of_week) && (@calendar.get_minimal_days_in_first_week).equal?(other.attr_calendar.get_minimal_days_in_first_week) && (@calendar.is_lenient).equal?(other.attr_calendar.is_lenient) && (@calendar.get_time_zone == other.attr_calendar.get_time_zone) && (@number_format == other.attr_number_format))
    end
    
    typesig { [] }
    # Overrides Cloneable
    def clone
      other = super
      other.attr_calendar = @calendar.clone
      other.attr_number_format = @number_format.clone
      return other
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Int, ::Java::Int, Locale] }
      # Creates a DateFormat with the given time and/or date style in the given
      # locale.
      # @param timeStyle a value from 0 to 3 indicating the time format,
      # ignored if flags is 2
      # @param dateStyle a value from 0 to 3 indicating the time format,
      # ignored if flags is 1
      # @param flags either 1 for a time format, 2 for a date format,
      # or 3 for a date/time format
      # @param loc the locale for the format
      def get(time_style, date_style, flags, loc)
        if (!((flags & 1)).equal?(0))
          if (time_style < 0 || time_style > 3)
            raise IllegalArgumentException.new("Illegal time style " + RJava.cast_to_string(time_style))
          end
        else
          time_style = -1
        end
        if (!((flags & 2)).equal?(0))
          if (date_style < 0 || date_style > 3)
            raise IllegalArgumentException.new("Illegal date style " + RJava.cast_to_string(date_style))
          end
        else
          date_style = -1
        end
        begin
          # Check whether a provider can provide an implementation that's closer
          # to the requested locale than what the Java runtime itself can provide.
          pool = LocaleServiceProviderPool.get_pool(DateFormatProvider)
          if (pool.has_providers)
            providers_instance = pool.get_localized_object(DateFormatGetter::INSTANCE, loc, time_style, date_style, flags)
            if (!(providers_instance).nil?)
              return providers_instance
            end
          end
          return SimpleDateFormat.new(time_style, date_style, loc)
        rescue MissingResourceException => e
          return SimpleDateFormat.new("M/d/yy h:mm a")
        end
      end
    }
    
    typesig { [] }
    # Create a new date format.
    def initialize
      @calendar = nil
      @number_format = nil
      super()
    end
    
    class_module.module_eval {
      # Defines constants that are used as attribute keys in the
      # <code>AttributedCharacterIterator</code> returned
      # from <code>DateFormat.formatToCharacterIterator</code> and as
      # field identifiers in <code>FieldPosition</code>.
      # <p>
      # The class also provides two methods to map
      # between its constants and the corresponding Calendar constants.
      # 
      # @since 1.4
      # @see java.util.Calendar
      const_set_lazy(:Field) { Class.new(Format::Field) do
        include_class_members DateFormat
        
        class_module.module_eval {
          # Proclaim serial compatibility with 1.4 FCS
          const_set_lazy(:SerialVersionUID) { 7441350119349544720 }
          const_attr_reader  :SerialVersionUID
          
          # table of all instances in this class, used by readResolve
          const_set_lazy(:InstanceMap) { self.class::HashMap.new(18) }
          const_attr_reader  :InstanceMap
          
          # Maps from Calendar constant (such as Calendar.ERA) to Field
          # constant (such as Field.ERA).
          const_set_lazy(:CalendarToFieldMapping) { Array.typed(self.class::Field).new(Calendar::FIELD_COUNT) { nil } }
          const_attr_reader  :CalendarToFieldMapping
        }
        
        # Calendar field.
        attr_accessor :calendar_field
        alias_method :attr_calendar_field, :calendar_field
        undef_method :calendar_field
        alias_method :attr_calendar_field=, :calendar_field=
        undef_method :calendar_field=
        
        class_module.module_eval {
          typesig { [::Java::Int] }
          # Returns the <code>Field</code> constant that corresponds to
          # the <code>Calendar</code> constant <code>calendarField</code>.
          # If there is no direct mapping between the <code>Calendar</code>
          # constant and a <code>Field</code>, null is returned.
          # 
          # @throws IllegalArgumentException if <code>calendarField</code> is
          # not the value of a <code>Calendar</code> field constant.
          # @param calendarField Calendar field constant
          # @return Field instance representing calendarField.
          # @see java.util.Calendar
          def of_calendar_field(calendar_field)
            if (calendar_field < 0 || calendar_field >= self.class::CalendarToFieldMapping.attr_length)
              raise self.class::IllegalArgumentException.new("Unknown Calendar constant " + RJava.cast_to_string(calendar_field))
            end
            return self.class::CalendarToFieldMapping[calendar_field]
          end
        }
        
        typesig { [self::String, ::Java::Int] }
        # Creates a <code>Field</code>.
        # 
        # @param name the name of the <code>Field</code>
        # @param calendarField the <code>Calendar</code> constant this
        # <code>Field</code> corresponds to; any value, even one
        # outside the range of legal <code>Calendar</code> values may
        # be used, but <code>-1</code> should be used for values
        # that don't correspond to legal <code>Calendar</code> values
        def initialize(name, calendar_field)
          @calendar_field = 0
          super(name)
          @calendar_field = calendar_field
          if ((self.get_class).equal?(DateFormat::Field))
            self.class::InstanceMap.put(name, self)
            if (calendar_field >= 0)
              # assert(calendarField < Calendar.FIELD_COUNT);
              self.class::CalendarToFieldMapping[calendar_field] = self
            end
          end
        end
        
        typesig { [] }
        # Returns the <code>Calendar</code> field associated with this
        # attribute. For example, if this represents the hours field of
        # a <code>Calendar</code>, this would return
        # <code>Calendar.HOUR</code>. If there is no corresponding
        # <code>Calendar</code> constant, this will return -1.
        # 
        # @return Calendar constant for this field
        # @see java.util.Calendar
        def get_calendar_field
          return @calendar_field
        end
        
        typesig { [] }
        # Resolves instances being deserialized to the predefined constants.
        # 
        # @throws InvalidObjectException if the constant could not be
        # resolved.
        # @return resolved DateFormat.Field constant
        def read_resolve
          if (!(self.get_class).equal?(DateFormat::Field))
            raise self.class::InvalidObjectException.new("subclass didn't correctly implement readResolve")
          end
          instance = self.class::InstanceMap.get(get_name)
          if (!(instance).nil?)
            return instance
          else
            raise self.class::InvalidObjectException.new("unknown attribute name")
          end
        end
        
        class_module.module_eval {
          # The constants
          # 
          # 
          # Constant identifying the era field.
          const_set_lazy(:ERA) { self.class::Field.new("era", Calendar::ERA) }
          const_attr_reader  :ERA
          
          # Constant identifying the year field.
          const_set_lazy(:YEAR) { self.class::Field.new("year", Calendar::YEAR) }
          const_attr_reader  :YEAR
          
          # Constant identifying the month field.
          const_set_lazy(:MONTH) { self.class::Field.new("month", Calendar::MONTH) }
          const_attr_reader  :MONTH
          
          # Constant identifying the day of month field.
          const_set_lazy(:DAY_OF_MONTH) { self.class::Field.new("day of month", Calendar::DAY_OF_MONTH) }
          const_attr_reader  :DAY_OF_MONTH
          
          # Constant identifying the hour of day field, where the legal values
          # are 1 to 24.
          const_set_lazy(:HOUR_OF_DAY1) { self.class::Field.new("hour of day 1", -1) }
          const_attr_reader  :HOUR_OF_DAY1
          
          # Constant identifying the hour of day field, where the legal values
          # are 0 to 23.
          const_set_lazy(:HOUR_OF_DAY0) { self.class::Field.new("hour of day", Calendar::HOUR_OF_DAY) }
          const_attr_reader  :HOUR_OF_DAY0
          
          # Constant identifying the minute field.
          const_set_lazy(:MINUTE) { self.class::Field.new("minute", Calendar::MINUTE) }
          const_attr_reader  :MINUTE
          
          # Constant identifying the second field.
          const_set_lazy(:SECOND) { self.class::Field.new("second", Calendar::SECOND) }
          const_attr_reader  :SECOND
          
          # Constant identifying the millisecond field.
          const_set_lazy(:MILLISECOND) { self.class::Field.new("millisecond", Calendar::MILLISECOND) }
          const_attr_reader  :MILLISECOND
          
          # Constant identifying the day of week field.
          const_set_lazy(:DAY_OF_WEEK) { self.class::Field.new("day of week", Calendar::DAY_OF_WEEK) }
          const_attr_reader  :DAY_OF_WEEK
          
          # Constant identifying the day of year field.
          const_set_lazy(:DAY_OF_YEAR) { self.class::Field.new("day of year", Calendar::DAY_OF_YEAR) }
          const_attr_reader  :DAY_OF_YEAR
          
          # Constant identifying the day of week field.
          const_set_lazy(:DAY_OF_WEEK_IN_MONTH) { self.class::Field.new("day of week in month", Calendar::DAY_OF_WEEK_IN_MONTH) }
          const_attr_reader  :DAY_OF_WEEK_IN_MONTH
          
          # Constant identifying the week of year field.
          const_set_lazy(:WEEK_OF_YEAR) { self.class::Field.new("week of year", Calendar::WEEK_OF_YEAR) }
          const_attr_reader  :WEEK_OF_YEAR
          
          # Constant identifying the week of month field.
          const_set_lazy(:WEEK_OF_MONTH) { self.class::Field.new("week of month", Calendar::WEEK_OF_MONTH) }
          const_attr_reader  :WEEK_OF_MONTH
          
          # Constant identifying the time of day indicator
          # (e.g. "a.m." or "p.m.") field.
          const_set_lazy(:AM_PM) { self.class::Field.new("am pm", Calendar::AM_PM) }
          const_attr_reader  :AM_PM
          
          # Constant identifying the hour field, where the legal values are
          # 1 to 12.
          const_set_lazy(:HOUR1) { self.class::Field.new("hour 1", -1) }
          const_attr_reader  :HOUR1
          
          # Constant identifying the hour field, where the legal values are
          # 0 to 11.
          const_set_lazy(:HOUR0) { self.class::Field.new("hour", Calendar::HOUR) }
          const_attr_reader  :HOUR0
          
          # Constant identifying the time zone field.
          const_set_lazy(:TIME_ZONE) { self.class::Field.new("time zone", -1) }
          const_attr_reader  :TIME_ZONE
        }
        
        private
        alias_method :initialize__field, :initialize
      end }
      
      # Obtains a DateFormat instance from a DateFormatProvider
      # implementation.
      const_set_lazy(:DateFormatGetter) { Class.new do
        include_class_members DateFormat
        include LocaleServiceProviderPool::LocalizedObjectGetter
        
        class_module.module_eval {
          const_set_lazy(:INSTANCE) { self.class::DateFormatGetter.new }
          const_attr_reader  :INSTANCE
        }
        
        typesig { [self::DateFormatProvider, self::Locale, self::String, Object] }
        def get_object(date_format_provider, locale, key, *params)
          raise AssertError if not ((params.attr_length).equal?(3))
          time_style = params[0]
          date_style = params[1]
          flags = params[2]
          case (flags)
          when 1
            return date_format_provider.get_time_instance(time_style, locale)
          when 2
            return date_format_provider.get_date_instance(date_style, locale)
          when 3
            return date_format_provider.get_date_time_instance(date_style, time_style, locale)
          else
            raise AssertError, "should not happen" if not (false)
          end
          return nil
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__date_format_getter, :initialize
      end }
    }
    
    private
    alias_method :initialize__date_format, :initialize
  end
  
end
