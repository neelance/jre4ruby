require "rjava"

# Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module JulianCalendarImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util::Calendar
      include_const ::Java::Util, :TimeZone
    }
  end
  
  # Julian calendar implementation.
  # 
  # @author Masayoshi Okutsu
  # @since 1.5
  class JulianCalendar < JulianCalendarImports.const_get :BaseCalendar
    include_class_members JulianCalendarImports
    
    class_module.module_eval {
      const_set_lazy(:BCE) { 0 }
      const_attr_reader  :BCE
      
      const_set_lazy(:CE) { 1 }
      const_attr_reader  :CE
      
      const_set_lazy(:Eras) { Array.typed(Era).new([Era.new("BeforeCommonEra", "B.C.E.", Long::MIN_VALUE, false), Era.new("CommonEra", "C.E.", -62135709175808, true)]) }
      const_attr_reader  :Eras
      
      const_set_lazy(:JULIAN_EPOCH) { -1 }
      const_attr_reader  :JULIAN_EPOCH
      
      const_set_lazy(:JavaDate) { Class.new(BaseCalendar::JavaDate) do
        include_class_members JulianCalendar
        
        typesig { [] }
        def initialize
          super()
          set_cache(1, -1, 365) # January 1, 1 CE (Julian)
        end
        
        typesig { [class_self::TimeZone] }
        def initialize(zone)
          super(zone)
          set_cache(1, -1, 365) # January 1, 1 CE (Julian)
        end
        
        typesig { [class_self::Era] }
        def set_era(era)
          if ((era).nil?)
            raise self.class::NullPointerException.new
          end
          if (!(era).equal?(Eras[0]) || !(era).equal?(Eras[1]))
            raise self.class::IllegalArgumentException.new("unknown era: " + RJava.cast_to_string(era))
          end
          super(era)
          return self
        end
        
        typesig { [class_self::Era] }
        def set_known_era(era)
          BaseCalendar::JavaDate.instance_method(:set_era).bind(self).call(era)
        end
        
        typesig { [] }
        def get_normalized_year
          if ((get_era).equal?(Eras[BCE]))
            return 1 - get_year
          end
          return get_year
        end
        
        typesig { [::Java::Int] }
        # Use the year numbering ..., -2, -1, 0, 1, 2, ... for
        # normalized years. This differs from "Calendrical
        # Calculations" in which the numbering is ..., -2, -1, 1, 2,
        # ...
        def set_normalized_year(year)
          if (year <= 0)
            set_year(1 - year)
            set_known_era(Eras[BCE])
          else
            set_year(year)
            set_known_era(Eras[CE])
          end
        end
        
        typesig { [] }
        def to_s
          time = super
          time = RJava.cast_to_string(time.substring(time.index_of(Character.new(?T.ord))))
          sb = self.class::StringBuffer.new
          era = get_era
          if (!(era).nil?)
            n = era.get_abbreviation
            if (!(n).nil?)
              sb.append(n).append(Character.new(?\s.ord))
            end
          end
          sb.append(get_year).append(Character.new(?-.ord))
          CalendarUtils.sprintf0d(sb, get_month, 2).append(Character.new(?-.ord))
          CalendarUtils.sprintf0d(sb, get_day_of_month, 2)
          sb.append(time)
          return sb.to_s
        end
        
        private
        alias_method :initialize__date, :initialize
      end }
    }
    
    typesig { [] }
    def initialize
      super()
      set_eras(Eras)
    end
    
    typesig { [] }
    def get_name
      return "julian"
    end
    
    typesig { [] }
    def get_calendar_date
      return get_calendar_date(System.current_time_millis, new_calendar_date)
    end
    
    typesig { [::Java::Long] }
    def get_calendar_date(millis)
      return get_calendar_date(millis, new_calendar_date)
    end
    
    typesig { [::Java::Long, CalendarDate] }
    def get_calendar_date(millis, date)
      return super(millis, date)
    end
    
    typesig { [::Java::Long, TimeZone] }
    def get_calendar_date(millis, zone)
      return get_calendar_date(millis, new_calendar_date(zone))
    end
    
    typesig { [] }
    def new_calendar_date
      return JavaDate.new
    end
    
    typesig { [TimeZone] }
    def new_calendar_date(zone)
      return JavaDate.new(zone)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, BaseCalendar::JavaDate] }
    # @param jyear normalized Julian year
    def get_fixed_date(jyear, month, day_of_month, cache)
      is_jan1 = (month).equal?(JANUARY) && (day_of_month).equal?(1)
      # Look up the one year cache
      if (!(cache).nil? && cache.hit(jyear))
        if (is_jan1)
          return cache.get_cached_jan1
        end
        return cache.get_cached_jan1 + get_day_of_year(jyear, month, day_of_month) - 1
      end
      y = jyear
      days = JULIAN_EPOCH - 1 + (365 * (y - 1)) + day_of_month
      if (y > 0)
        # CE years
        days += (y - 1) / 4
      else
        # BCE years
        days += CalendarUtils.floor_divide(y - 1, 4)
      end
      if (month > 0)
        days += ((367 * month) - 362) / 12
      else
        days += CalendarUtils.floor_divide((367 * month) - 362, 12)
      end
      if (month > FEBRUARY)
        days -= CalendarUtils.is_julian_leap_year(jyear) ? 1 : 2
      end
      # If it's January 1, update the cache.
      if (!(cache).nil? && is_jan1)
        cache.set_cache(jyear, days, CalendarUtils.is_julian_leap_year(jyear) ? 366 : 365)
      end
      return days
    end
    
    typesig { [CalendarDate, ::Java::Long] }
    def get_calendar_date_from_fixed_date(date, fixed_date)
      jdate = date
      fd = 4 * (fixed_date - JULIAN_EPOCH) + 1464
      year = 0
      if (fd >= 0)
        year = RJava.cast_to_int((fd / 1461))
      else
        year = RJava.cast_to_int(CalendarUtils.floor_divide(fd, 1461))
      end
      prior_days = RJava.cast_to_int((fixed_date - get_fixed_date(year, JANUARY, 1, jdate)))
      is_leap = CalendarUtils.is_julian_leap_year(year)
      if (fixed_date >= get_fixed_date(year, MARCH, 1, jdate))
        prior_days += is_leap ? 1 : 2
      end
      month = 12 * prior_days + 373
      if (month > 0)
        month /= 367
      else
        month = CalendarUtils.floor_divide(month, 367)
      end
      day_of_month = RJava.cast_to_int((fixed_date - get_fixed_date(year, month, 1, jdate))) + 1
      day_of_week = get_day_of_week_from_fixed_date(fixed_date)
      raise AssertError, "negative day of week " + RJava.cast_to_string(day_of_week) if not (day_of_week > 0)
      jdate.set_normalized_year(year)
      jdate.set_month(month)
      jdate.set_day_of_month(day_of_month)
      jdate.set_day_of_week(day_of_week)
      jdate.set_leap_year(is_leap)
      jdate.set_normalized(true)
    end
    
    typesig { [::Java::Long] }
    # Returns the normalized Julian year number of the given fixed date.
    def get_year_from_fixed_date(fixed_date)
      year = RJava.cast_to_int(CalendarUtils.floor_divide(4 * (fixed_date - JULIAN_EPOCH) + 1464, 1461))
      return year
    end
    
    typesig { [CalendarDate] }
    def get_day_of_week(date)
      # TODO: should replace this with a faster calculation, such
      # as cache table lookup
      fixed_date = get_fixed_date(date)
      return get_day_of_week_from_fixed_date(fixed_date)
    end
    
    typesig { [::Java::Int] }
    def is_leap_year(jyear)
      return CalendarUtils.is_julian_leap_year(jyear)
    end
    
    private
    alias_method :initialize__julian_calendar, :initialize
  end
  
end
