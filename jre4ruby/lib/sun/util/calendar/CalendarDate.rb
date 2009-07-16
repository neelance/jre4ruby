require "rjava"

# 
# Copyright 2000-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CalendarDateImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util::Calendar
      include_const ::Java::Lang, :Cloneable
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :TimeZone
    }
  end
  
  # 
  # The <code>CalendarDate</code> class represents a specific instant
  # in time by calendar date and time fields that are multiple cycles
  # in different time unites. The semantics of each calendar field is
  # given by a concrete calendar system rather than this
  # <code>CalendarDate</code> class that holds calendar field values
  # without interpreting them. Therefore, this class can be used to
  # represent an amount of time, such as 2 years and 3 months.
  # 
  # <p>A <code>CalendarDate</code> instance can be created by calling
  # the <code>newCalendarDate</code> or <code>getCalendarDate</code>
  # methods in <code>CalendarSystem</code>. A
  # <code>CalendarSystem</code> instance is obtained by calling one of
  # the factory methods in <code>CalendarSystem</code>. Manipulations
  # of calendar dates must be handled by the calendar system by which
  # <code>CalendarDate</code> instances have been created.
  # 
  # <p>Some calendar fields can be modified through method calls. Any
  # modification of a calendar field brings the state of a
  # <code>CalendarDate</code> to <I>not normalized</I>. The
  # normalization must be performed to make all the calendar fields
  # consistent with a calendar system.
  # 
  # <p>The <code>protected</code> methods are intended to be used for
  # implementing a concrete calendar system, not for general use as an
  # API.
  # 
  # @see CalendarSystem
  # @author Masayoshi Okutsu
  # @since 1.5
  class CalendarDate 
    include_class_members CalendarDateImports
    include Cloneable
    
    class_module.module_eval {
      const_set_lazy(:FIELD_UNDEFINED) { JavaInteger::MIN_VALUE }
      const_attr_reader  :FIELD_UNDEFINED
      
      const_set_lazy(:TIME_UNDEFINED) { Long::MIN_VALUE }
      const_attr_reader  :TIME_UNDEFINED
    }
    
    attr_accessor :era
    alias_method :attr_era, :era
    undef_method :era
    alias_method :attr_era=, :era=
    undef_method :era=
    
    attr_accessor :year
    alias_method :attr_year, :year
    undef_method :year
    alias_method :attr_year=, :year=
    undef_method :year=
    
    attr_accessor :month
    alias_method :attr_month, :month
    undef_method :month
    alias_method :attr_month=, :month=
    undef_method :month=
    
    attr_accessor :day_of_month
    alias_method :attr_day_of_month, :day_of_month
    undef_method :day_of_month
    alias_method :attr_day_of_month=, :day_of_month=
    undef_method :day_of_month=
    
    attr_accessor :day_of_week
    alias_method :attr_day_of_week, :day_of_week
    undef_method :day_of_week
    alias_method :attr_day_of_week=, :day_of_week=
    undef_method :day_of_week=
    
    attr_accessor :leap_year
    alias_method :attr_leap_year, :leap_year
    undef_method :leap_year
    alias_method :attr_leap_year=, :leap_year=
    undef_method :leap_year=
    
    attr_accessor :hours
    alias_method :attr_hours, :hours
    undef_method :hours
    alias_method :attr_hours=, :hours=
    undef_method :hours=
    
    attr_accessor :minutes
    alias_method :attr_minutes, :minutes
    undef_method :minutes
    alias_method :attr_minutes=, :minutes=
    undef_method :minutes=
    
    attr_accessor :seconds
    alias_method :attr_seconds, :seconds
    undef_method :seconds
    alias_method :attr_seconds=, :seconds=
    undef_method :seconds=
    
    attr_accessor :millis
    alias_method :attr_millis, :millis
    undef_method :millis
    alias_method :attr_millis=, :millis=
    undef_method :millis=
    
    # fractional part of the second
    attr_accessor :fraction
    alias_method :attr_fraction, :fraction
    undef_method :fraction
    alias_method :attr_fraction=, :fraction=
    undef_method :fraction=
    
    # time of day value in millisecond
    attr_accessor :normalized
    alias_method :attr_normalized, :normalized
    undef_method :normalized
    alias_method :attr_normalized=, :normalized=
    undef_method :normalized=
    
    attr_accessor :zoneinfo
    alias_method :attr_zoneinfo, :zoneinfo
    undef_method :zoneinfo
    alias_method :attr_zoneinfo=, :zoneinfo=
    undef_method :zoneinfo=
    
    attr_accessor :zone_offset
    alias_method :attr_zone_offset, :zone_offset
    undef_method :zone_offset
    alias_method :attr_zone_offset=, :zone_offset=
    undef_method :zone_offset=
    
    attr_accessor :daylight_saving
    alias_method :attr_daylight_saving, :daylight_saving
    undef_method :daylight_saving
    alias_method :attr_daylight_saving=, :daylight_saving=
    undef_method :daylight_saving=
    
    attr_accessor :force_standard_time
    alias_method :attr_force_standard_time, :force_standard_time
    undef_method :force_standard_time
    alias_method :attr_force_standard_time=, :force_standard_time=
    undef_method :force_standard_time=
    
    attr_accessor :locale
    alias_method :attr_locale, :locale
    undef_method :locale
    alias_method :attr_locale=, :locale=
    undef_method :locale=
    
    typesig { [] }
    def initialize
      initialize__calendar_date(TimeZone.get_default)
    end
    
    typesig { [TimeZone] }
    def initialize(zone)
      @era = nil
      @year = 0
      @month = 0
      @day_of_month = 0
      @day_of_week = FIELD_UNDEFINED
      @leap_year = false
      @hours = 0
      @minutes = 0
      @seconds = 0
      @millis = 0
      @fraction = 0
      @normalized = false
      @zoneinfo = nil
      @zone_offset = 0
      @daylight_saving = 0
      @force_standard_time = false
      @locale = nil
      @zoneinfo = zone
    end
    
    typesig { [] }
    def get_era
      return @era
    end
    
    typesig { [Era] }
    # 
    # Sets the era of the date to the specified era. The default
    # implementation of this method accepts any Era value, including
    # <code>null</code>.
    # 
    # @exception NullPointerException if the calendar system for this
    # <code>CalendarDate</code> requires eras and the specified era
    # is null.
    # @exception IllegalArgumentException if the specified
    # <code>era</code> is unknown to the calendar
    # system for this <code>CalendarDate</code>.
    def set_era(era)
      if ((@era).equal?(era))
        return self
      end
      @era = era
      @normalized = false
      return self
    end
    
    typesig { [] }
    def get_year
      return @year
    end
    
    typesig { [::Java::Int] }
    def set_year(year)
      if (!(@year).equal?(year))
        @year = year
        @normalized = false
      end
      return self
    end
    
    typesig { [::Java::Int] }
    def add_year(n)
      if (!(n).equal?(0))
        @year += n
        @normalized = false
      end
      return self
    end
    
    typesig { [] }
    # 
    # Returns whether the year represented by this
    # <code>CalendarDate</code> is a leap year. If leap years are
    # not applicable to the calendar system, this method always
    # returns <code>false</code>.
    # 
    # <p>If this <code>CalendarDate</code> hasn't been normalized,
    # <code>false</code> is returned. The normalization must be
    # performed to retrieve the correct leap year information.
    # 
    # @return <code>true</code> if this <code>CalendarDate</code> is
    # normalized and the year of this <code>CalendarDate</code> is a
    # leap year, or <code>false</code> otherwise.
    # @see BaseCalendar#isGregorianLeapYear
    def is_leap_year
      return @leap_year
    end
    
    typesig { [::Java::Boolean] }
    def set_leap_year(leap_year)
      @leap_year = leap_year
    end
    
    typesig { [] }
    def get_month
      return @month
    end
    
    typesig { [::Java::Int] }
    def set_month(month)
      if (!(@month).equal?(month))
        @month = month
        @normalized = false
      end
      return self
    end
    
    typesig { [::Java::Int] }
    def add_month(n)
      if (!(n).equal?(0))
        @month += n
        @normalized = false
      end
      return self
    end
    
    typesig { [] }
    def get_day_of_month
      return @day_of_month
    end
    
    typesig { [::Java::Int] }
    def set_day_of_month(date)
      if (!(@day_of_month).equal?(date))
        @day_of_month = date
        @normalized = false
      end
      return self
    end
    
    typesig { [::Java::Int] }
    def add_day_of_month(n)
      if (!(n).equal?(0))
        @day_of_month += n
        @normalized = false
      end
      return self
    end
    
    typesig { [] }
    # 
    # Returns the day of week value. If this CalendarDate is not
    # normalized, {@link #FIELD_UNDEFINED} is returned.
    # 
    # @return day of week or {@link #FIELD_UNDEFINED}
    def get_day_of_week
      if (!is_normalized)
        @day_of_week = FIELD_UNDEFINED
      end
      return @day_of_week
    end
    
    typesig { [] }
    def get_hours
      return @hours
    end
    
    typesig { [::Java::Int] }
    def set_hours(hours)
      if (!(@hours).equal?(hours))
        @hours = hours
        @normalized = false
      end
      return self
    end
    
    typesig { [::Java::Int] }
    def add_hours(n)
      if (!(n).equal?(0))
        @hours += n
        @normalized = false
      end
      return self
    end
    
    typesig { [] }
    def get_minutes
      return @minutes
    end
    
    typesig { [::Java::Int] }
    def set_minutes(minutes)
      if (!(@minutes).equal?(minutes))
        @minutes = minutes
        @normalized = false
      end
      return self
    end
    
    typesig { [::Java::Int] }
    def add_minutes(n)
      if (!(n).equal?(0))
        @minutes += n
        @normalized = false
      end
      return self
    end
    
    typesig { [] }
    def get_seconds
      return @seconds
    end
    
    typesig { [::Java::Int] }
    def set_seconds(seconds)
      if (!(@seconds).equal?(seconds))
        @seconds = seconds
        @normalized = false
      end
      return self
    end
    
    typesig { [::Java::Int] }
    def add_seconds(n)
      if (!(n).equal?(0))
        @seconds += n
        @normalized = false
      end
      return self
    end
    
    typesig { [] }
    def get_millis
      return @millis
    end
    
    typesig { [::Java::Int] }
    def set_millis(millis)
      if (!(@millis).equal?(millis))
        @millis = millis
        @normalized = false
      end
      return self
    end
    
    typesig { [::Java::Int] }
    def add_millis(n)
      if (!(n).equal?(0))
        @millis += n
        @normalized = false
      end
      return self
    end
    
    typesig { [] }
    def get_time_of_day
      if (!is_normalized)
        return @fraction = TIME_UNDEFINED
      end
      return @fraction
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    def set_date(year, month, day_of_month)
      set_year(year)
      set_month(month)
      set_day_of_month(day_of_month)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    def add_date(year, month, day_of_month)
      add_year(year)
      add_month(month)
      add_day_of_month(day_of_month)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    def set_time_of_day(hours, minutes, seconds, millis)
      set_hours(hours)
      set_minutes(minutes)
      set_seconds(seconds)
      set_millis(millis)
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    def add_time_of_day(hours, minutes, seconds, millis)
      add_hours(hours)
      add_minutes(minutes)
      add_seconds(seconds)
      add_millis(millis)
      return self
    end
    
    typesig { [::Java::Long] }
    def set_time_of_day(fraction)
      @fraction = fraction
    end
    
    typesig { [] }
    def is_normalized
      return @normalized
    end
    
    typesig { [] }
    def is_standard_time
      return @force_standard_time
    end
    
    typesig { [::Java::Boolean] }
    def set_standard_time(standard_time)
      @force_standard_time = standard_time
    end
    
    typesig { [] }
    def is_daylight_time
      if (is_standard_time)
        return false
      end
      return !(@daylight_saving).equal?(0)
    end
    
    typesig { [Locale] }
    def set_locale(loc)
      @locale = loc
    end
    
    typesig { [] }
    def get_zone
      return @zoneinfo
    end
    
    typesig { [TimeZone] }
    def set_zone(zoneinfo)
      @zoneinfo = zoneinfo
      return self
    end
    
    typesig { [CalendarDate] }
    # 
    # Returns whether the specified date is the same date of this
    # <code>CalendarDate</code>. The time of the day fields are
    # ignored for the comparison.
    def is_same_date(date)
      return (get_day_of_week).equal?(date.get_day_of_week) && (get_month).equal?(date.get_month) && (get_year).equal?(date.get_year) && (get_era).equal?(date.get_era)
    end
    
    typesig { [Object] }
    def equals(obj)
      if (!(obj.is_a?(CalendarDate)))
        return false
      end
      that = obj
      if (!(is_normalized).equal?(that.is_normalized))
        return false
      end
      has_zone = !(@zoneinfo).nil?
      that_has_zone = !(that.attr_zoneinfo).nil?
      if (!(has_zone).equal?(that_has_zone))
        return false
      end
      if (has_zone && !(@zoneinfo == that.attr_zoneinfo))
        return false
      end
      return ((get_era).equal?(that.get_era) && (@year).equal?(that.attr_year) && (@month).equal?(that.attr_month) && (@day_of_month).equal?(that.attr_day_of_month) && (@hours).equal?(that.attr_hours) && (@minutes).equal?(that.attr_minutes) && (@seconds).equal?(that.attr_seconds) && (@millis).equal?(that.attr_millis) && (@zone_offset).equal?(that.attr_zone_offset))
    end
    
    typesig { [] }
    def hash_code
      # a pseudo (local standard) time stamp value in milliseconds
      # from the Epoch, assuming Gregorian calendar fields.
      hash = (((((@year - 1970) * 12) + (@month - 1)) * 30) + @day_of_month) * 24
      hash = ((((((hash + @hours) * 60) + @minutes) * 60) + @seconds) * 1000) + @millis
      hash -= @zone_offset
      normalized = is_normalized ? 1 : 0
      era = 0
      e = get_era
      if (!(e).nil?)
        era = e.hash_code
      end
      zone = !(@zoneinfo).nil? ? @zoneinfo.hash_code : 0
      return RJava.cast_to_int(hash) * RJava.cast_to_int((hash >> 32)) ^ era ^ normalized ^ zone
    end
    
    typesig { [] }
    # 
    # Returns a copy of this <code>CalendarDate</code>. The
    # <code>TimeZone</code> object, if any, is not cloned.
    # 
    # @return a copy of this <code>CalendarDate</code>
    def clone
      begin
        return super
      rescue CloneNotSupportedException => e
        # this shouldn't happen
        raise InternalError.new
      end
    end
    
    typesig { [] }
    # 
    # Converts calendar date values to a <code>String</code> in the
    # following format.
    # <pre>
    # yyyy-MM-dd'T'HH:mm:ss.SSSz
    # </pre>
    # 
    # @see java.text.SimpleDateFormat
    def to_s
      sb = StringBuilder.new
      CalendarUtils.sprintf0d(sb, @year, 4).append(Character.new(?-.ord))
      CalendarUtils.sprintf0d(sb, @month, 2).append(Character.new(?-.ord))
      CalendarUtils.sprintf0d(sb, @day_of_month, 2).append(Character.new(?T.ord))
      CalendarUtils.sprintf0d(sb, @hours, 2).append(Character.new(?:.ord))
      CalendarUtils.sprintf0d(sb, @minutes, 2).append(Character.new(?:.ord))
      CalendarUtils.sprintf0d(sb, @seconds, 2).append(Character.new(?..ord))
      CalendarUtils.sprintf0d(sb, @millis, 3)
      if ((@zone_offset).equal?(0))
        sb.append(Character.new(?Z.ord))
      else
        if (!(@zone_offset).equal?(FIELD_UNDEFINED))
          offset = 0
          sign = 0
          if (@zone_offset > 0)
            offset = @zone_offset
            sign = Character.new(?+.ord)
          else
            offset = -@zone_offset
            sign = Character.new(?-.ord)
          end
          offset /= 60000
          sb.append(sign)
          CalendarUtils.sprintf0d(sb, offset / 60, 2)
          CalendarUtils.sprintf0d(sb, offset % 60, 2)
        else
          sb.append(" local time")
        end
      end
      return sb.to_s
    end
    
    typesig { [::Java::Int] }
    def set_day_of_week(day_of_week)
      @day_of_week = day_of_week
    end
    
    typesig { [::Java::Boolean] }
    def set_normalized(normalized)
      @normalized = normalized
    end
    
    typesig { [] }
    def get_zone_offset
      return @zone_offset
    end
    
    typesig { [::Java::Int] }
    def set_zone_offset(offset)
      @zone_offset = offset
    end
    
    typesig { [] }
    def get_daylight_saving
      return @daylight_saving
    end
    
    typesig { [::Java::Int] }
    def set_daylight_saving(daylight_saving)
      @daylight_saving = daylight_saving
    end
    
    private
    alias_method :initialize__calendar_date, :initialize
  end
  
end
