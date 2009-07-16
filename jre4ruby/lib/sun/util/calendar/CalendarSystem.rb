require "rjava"

# 
# Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Util::Calendar
  module CalendarSystemImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util::Calendar
      include_const ::Java::Lang::Reflect, :Field
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :TimeZone
      include_const ::Java::Util::Concurrent, :ConcurrentHashMap
      include_const ::Java::Util::Concurrent, :ConcurrentMap
    }
  end
  
  # 
  # <code>CalendarSystem</code> is an abstract class that defines the
  # programming interface to deal with calendar date and time.
  # 
  # <p><code>CalendarSystem</code> instances are singletons. For
  # example, there exists only one Gregorian calendar instance in the
  # Java runtime environment. A singleton instance can be obtained
  # calling one of the static factory methods.
  # 
  # <h4>CalendarDate</h4>
  # 
  # <p>For the methods in a <code>CalendarSystem</code> that manipulate
  # a <code>CalendarDate</code>, <code>CalendarDate</code>s that have
  # been created by the <code>CalendarSystem</code> must be
  # specified. Otherwise, the methods throw an exception. This is
  # because, for example, a Chinese calendar date can't be understood
  # by the Hebrew calendar system.
  # 
  # <h4>Calendar names</h4>
  # 
  # Each calendar system has a unique name to be identified. The Java
  # runtime in this release supports the following calendar systems.
  # 
  # <pre>
  # Name          Calendar System
  # ---------------------------------------
  # gregorian     Gregorian Calendar
  # julian        Julian Calendar
  # japanese      Japanese Imperial Calendar
  # </pre>
  # 
  # @see CalendarDate
  # @author Masayoshi Okutsu
  # @since 1.5
  class CalendarSystem 
    include_class_members CalendarSystemImports
    
    class_module.module_eval {
      # ///////////////////// Calendar Factory Methods /////////////////////////
      
      def initialized
        defined?(@@initialized) ? @@initialized : @@initialized= false
      end
      alias_method :attr_initialized, :initialized
      
      def initialized=(value)
        @@initialized = value
      end
      alias_method :attr_initialized=, :initialized=
      
      # Map of calendar names and calendar class names
      
      def names
        defined?(@@names) ? @@names : @@names= nil
      end
      alias_method :attr_names, :names
      
      def names=(value)
        @@names = value
      end
      alias_method :attr_names=, :names=
      
      # Map of calendar names and CalendarSystem instances
      
      def calendars
        defined?(@@calendars) ? @@calendars : @@calendars= nil
      end
      alias_method :attr_calendars, :calendars
      
      def calendars=(value)
        @@calendars = value
      end
      alias_method :attr_calendars=, :calendars=
      
      const_set_lazy(:PACKAGE_NAME) { "sun.util.calendar." }
      const_attr_reader  :PACKAGE_NAME
      
      # 
      # "hebrew", "HebrewCalendar",
      # "iso8601", "ISOCalendar",
      # "taiwanese", "LocalGregorianCalendar",
      # "thaibuddhist", "LocalGregorianCalendar",
      const_set_lazy(:NamePairs) { Array.typed(String).new(["gregorian", "Gregorian", "japanese", "LocalGregorianCalendar", "julian", "JulianCalendar", ]) }
      const_attr_reader  :NamePairs
      
      typesig { [] }
      def init_names
        name_map = ConcurrentHashMap.new
        # Associate a calendar name with its class name and the
        # calendar class name with its date class name.
        cl_name = StringBuilder.new
        i = 0
        while i < NamePairs.attr_length
          cl_name.set_length(0)
          cl = cl_name.append(PACKAGE_NAME).append(NamePairs[i + 1]).to_s
          name_map.put(NamePairs[i], cl)
          i += 2
        end
        synchronized((CalendarSystem.class)) do
          if (!self.attr_initialized)
            self.attr_names = name_map
            self.attr_calendars = ConcurrentHashMap.new
            self.attr_initialized = true
          end
        end
      end
      
      const_set_lazy(:GREGORIAN_INSTANCE) { Gregorian.new }
      const_attr_reader  :GREGORIAN_INSTANCE
      
      typesig { [] }
      # 
      # Returns the singleton instance of the <code>Gregorian</code>
      # calendar system.
      # 
      # @return the <code>Gregorian</code> instance
      def get_gregorian_calendar
        return GREGORIAN_INSTANCE
      end
      
      typesig { [String] }
      # 
      # Returns a <code>CalendarSystem</code> specified by the calendar
      # name. The calendar name has to be one of the supported calendar
      # names.
      # 
      # @param calendarName the calendar name
      # @return the <code>CalendarSystem</code> specified by
      # <code>calendarName</code>, or null if there is no
      # <code>CalendarSystem</code> associated with the given calendar name.
      def for_name(calendar_name)
        if (("gregorian" == calendar_name))
          return GREGORIAN_INSTANCE
        end
        if (!self.attr_initialized)
          init_names
        end
        cal = self.attr_calendars.get(calendar_name)
        if (!(cal).nil?)
          return cal
        end
        class_name = self.attr_names.get(calendar_name)
        if ((class_name).nil?)
          return nil # Unknown calendar name
        end
        if (class_name.ends_with("LocalGregorianCalendar"))
          # Create the specific kind of local Gregorian calendar system
          cal = LocalGregorianCalendar.get_local_gregorian_calendar(calendar_name)
        else
          begin
            cl = Class.for_name(class_name)
            cal = cl.new_instance
          rescue Exception => e
            raise RuntimeException.new("internal error", e)
          end
        end
        if ((cal).nil?)
          return nil
        end
        cs = self.attr_calendars.put_if_absent(calendar_name, cal)
        return ((cs).nil?) ? cal : cs
      end
    }
    
    typesig { [] }
    # ////////////////////////////// Calendar API //////////////////////////////////
    # 
    # Returns the name of this calendar system.
    def get_name
      raise NotImplementedError
    end
    
    typesig { [] }
    def get_calendar_date
      raise NotImplementedError
    end
    
    typesig { [::Java::Long] }
    # 
    # Calculates calendar fields from the specified number of
    # milliseconds since the Epoch, January 1, 1970 00:00:00 UTC
    # (Gregorian). This method doesn't check overflow or underflow
    # when adjusting the millisecond value (representing UTC) with
    # the time zone offsets (i.e., the GMT offset and amount of
    # daylight saving).
    # 
    # @param millis the offset value in milliseconds from January 1,
    # 1970 00:00:00 UTC (Gregorian).
    # @return a <code>CalendarDate</code> instance that contains the
    # calculated calendar field values.
    def get_calendar_date(millis)
      raise NotImplementedError
    end
    
    typesig { [::Java::Long, CalendarDate] }
    def get_calendar_date(millis, date)
      raise NotImplementedError
    end
    
    typesig { [::Java::Long, TimeZone] }
    def get_calendar_date(millis, zone)
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Constructs a <code>CalendarDate</code> that is specific to this
    # calendar system. All calendar fields have their initial
    # values. The {@link TimeZone#getDefault() default time zone} is
    # set to the instance.
    # 
    # @return a <code>CalendarDate</code> instance that contains the initial
    # calendar field values.
    def new_calendar_date
      raise NotImplementedError
    end
    
    typesig { [TimeZone] }
    def new_calendar_date(zone)
      raise NotImplementedError
    end
    
    typesig { [CalendarDate] }
    # 
    # Returns the number of milliseconds since the Epoch, January 1,
    # 1970 00:00:00 UTC (Gregorian), represented by the specified
    # <code>CalendarDate</code>.
    # 
    # @param date the <code>CalendarDate</code> from which the time
    # value is calculated
    # @return the number of milliseconds since the Epoch.
    def get_time(date)
      raise NotImplementedError
    end
    
    typesig { [CalendarDate] }
    # 
    # Returns the length in days of the specified year by
    # <code>date</code>. This method does not perform the
    # normalization with the specified <code>CalendarDate</code>. The
    # <code>CalendarDate</code> must be normalized to get a correct
    # value.
    def get_year_length(date)
      raise NotImplementedError
    end
    
    typesig { [CalendarDate] }
    # 
    # Returns the number of months of the specified year. This method
    # does not perform the normalization with the specified
    # <code>CalendarDate</code>. The <code>CalendarDate</code> must
    # be normalized to get a correct value.
    def get_year_length_in_months(date)
      raise NotImplementedError
    end
    
    typesig { [CalendarDate] }
    # 
    # Returns the length in days of the month specified by the calendar
    # date. This method does not perform the normalization with the
    # specified calendar date. The <code>CalendarDate</code> must
    # be normalized to get a correct value.
    # 
    # @param date the date from which the month value is obtained
    # @return the number of days in the month
    # @exception IllegalArgumentException if the specified calendar date
    # doesn't have a valid month value in this calendar system.
    def get_month_length(date)
      raise NotImplementedError
    end
    
    typesig { [] }
    # no setter
    # 
    # Returns the length in days of a week in this calendar
    # system. If this calendar system has multiple radix weeks, this
    # method returns only one of them.
    def get_week_length
      raise NotImplementedError
    end
    
    typesig { [String] }
    # 
    # Returns the <code>Era</code> designated by the era name that
    # has to be known to this calendar system. If no Era is
    # applicable to this calendar system, null is returned.
    # 
    # @param eraName the name of the era
    # @return the <code>Era</code> designated by
    # <code>eraName</code>, or <code>null</code> if no Era is
    # applicable to this calendar system or the specified era name is
    # not known to this calendar system.
    def get_era(era_name)
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns valid <code>Era</code>s of this calendar system. The
    # return value is sorted in the descendant order. (i.e., the first
    # element of the returned array is the oldest era.) If no era is
    # applicable to this calendar system, <code>null</code> is returned.
    # 
    # @return an array of valid <code>Era</code>s, or
    # <code>null</code> if no era is applicable to this calendar
    # system.
    def get_eras
      raise NotImplementedError
    end
    
    typesig { [CalendarDate, String] }
    # 
    # @throws IllegalArgumentException if the specified era name is
    # unknown to this calendar system.
    # @see Era
    def set_era(date, era_name)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Int, CalendarDate] }
    # 
    # Returns a <code>CalendarDate</code> of the n-th day of week
    # which is on, after or before the specified date. For example, the
    # first Sunday in April 2002 (Gregorian) can be obtained as
    # below:
    # 
    # <pre><code>
    # Gregorian cal = CalendarSystem.getGregorianCalendar();
    # CalendarDate date = cal.newCalendarDate();
    # date.setDate(2004, cal.APRIL, 1);
    # CalendarDate firstSun = cal.getNthDayOfWeek(1, cal.SUNDAY, date);
    # // firstSun represents April 4, 2004.
    # </code></pre>
    # 
    # This method returns a new <code>CalendarDate</code> instance
    # and doesn't modify the original date.
    # 
    # @param nth specifies the n-th one. A positive number specifies
    # <em>on or after</em> the <code>date</code>. A non-positive number
    # specifies <em>on or before</em> the <code>date</code>.
    # @param dayOfWeek the day of week
    # @param date the date
    # @return the date of the nth <code>dayOfWeek</code> after
    # or before the specified <code>CalendarDate</code>
    def get_nth_day_of_week(nth, day_of_week, date)
      raise NotImplementedError
    end
    
    typesig { [CalendarDate, ::Java::Int] }
    def set_time_of_day(date, time_of_day)
      raise NotImplementedError
    end
    
    typesig { [CalendarDate] }
    # 
    # Checks whether the calendar fields specified by <code>date</code>
    # represents a valid date and time in this calendar system. If the
    # given date is valid, <code>date</code> is marked as <em>normalized</em>.
    # 
    # @param date the <code>CalendarDate</code> to be validated
    # @return <code>true</code> if all the calendar fields are consistent,
    # otherwise, <code>false</code> is returned.
    # @exception NullPointerException if the specified
    # <code>date</code> is <code>null</code>
    def validate(date)
      raise NotImplementedError
    end
    
    typesig { [CalendarDate] }
    # 
    # Normalizes calendar fields in the specified
    # <code>date</code>. Also all {@link CalendarDate#FIELD_UNDEFINED
    # undefined} fields are set to correct values. The actual
    # normalization process is calendar system dependent.
    # 
    # @param date the calendar date to be validated
    # @return <code>true</code> if all fields have been normalized;
    # <code>false</code> otherwise.
    # @exception NullPointerException if the specified
    # <code>date</code> is <code>null</code>
    def normalize(date)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__calendar_system, :initialize
  end
  
end
