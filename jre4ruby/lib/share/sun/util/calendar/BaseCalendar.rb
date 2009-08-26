require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module BaseCalendarImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util::Calendar
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :TimeZone
    }
  end
  
  # The <code>BaseCalendar</code> provides basic calendar calculation
  # functions to support the Julian, Gregorian, and Gregorian-based
  # calendar systems.
  # 
  # @author Masayoshi Okutsu
  # @since 1.5
  class BaseCalendar < BaseCalendarImports.const_get :AbstractCalendar
    include_class_members BaseCalendarImports
    
    class_module.module_eval {
      const_set_lazy(:JANUARY) { 1 }
      const_attr_reader  :JANUARY
      
      const_set_lazy(:FEBRUARY) { 2 }
      const_attr_reader  :FEBRUARY
      
      const_set_lazy(:MARCH) { 3 }
      const_attr_reader  :MARCH
      
      const_set_lazy(:APRIL) { 4 }
      const_attr_reader  :APRIL
      
      const_set_lazy(:MAY) { 5 }
      const_attr_reader  :MAY
      
      const_set_lazy(:JUNE) { 6 }
      const_attr_reader  :JUNE
      
      const_set_lazy(:JULY) { 7 }
      const_attr_reader  :JULY
      
      const_set_lazy(:AUGUST) { 8 }
      const_attr_reader  :AUGUST
      
      const_set_lazy(:SEPTEMBER) { 9 }
      const_attr_reader  :SEPTEMBER
      
      const_set_lazy(:OCTOBER) { 10 }
      const_attr_reader  :OCTOBER
      
      const_set_lazy(:NOVEMBER) { 11 }
      const_attr_reader  :NOVEMBER
      
      const_set_lazy(:DECEMBER) { 12 }
      const_attr_reader  :DECEMBER
      
      # day of week constants
      const_set_lazy(:SUNDAY) { 1 }
      const_attr_reader  :SUNDAY
      
      const_set_lazy(:MONDAY) { 2 }
      const_attr_reader  :MONDAY
      
      const_set_lazy(:TUESDAY) { 3 }
      const_attr_reader  :TUESDAY
      
      const_set_lazy(:WEDNESDAY) { 4 }
      const_attr_reader  :WEDNESDAY
      
      const_set_lazy(:THURSDAY) { 5 }
      const_attr_reader  :THURSDAY
      
      const_set_lazy(:FRIDAY) { 6 }
      const_attr_reader  :FRIDAY
      
      const_set_lazy(:SATURDAY) { 7 }
      const_attr_reader  :SATURDAY
      
      # The base Gregorian year of FIXED_DATES[]
      const_set_lazy(:BASE_YEAR) { 1970 }
      const_attr_reader  :BASE_YEAR
      
      # Pre-calculated fixed dates of January 1 from BASE_YEAR
      # (Gregorian). This table covers all the years that can be
      # supported by the POSIX time_t (32-bit) after the Epoch. Note
      # that the data type is int[].
      # 1970
      # 1971
      # 1972
      # 1973
      # 1974
      # 1975
      # 1976
      # 1977
      # 1978
      # 1979
      # 1980
      # 1981
      # 1982
      # 1983
      # 1984
      # 1985
      # 1986
      # 1987
      # 1988
      # 1989
      # 1990
      # 1991
      # 1992
      # 1993
      # 1994
      # 1995
      # 1996
      # 1997
      # 1998
      # 1999
      # 2000
      # 2001
      # 2002
      # 2003
      # 2004
      # 2005
      # 2006
      # 2007
      # 2008
      # 2009
      # 2010
      # 2011
      # 2012
      # 2013
      # 2014
      # 2015
      # 2016
      # 2017
      # 2018
      # 2019
      # 2020
      # 2021
      # 2022
      # 2023
      # 2024
      # 2025
      # 2026
      # 2027
      # 2028
      # 2029
      # 2030
      # 2031
      # 2032
      # 2033
      # 2034
      # 2035
      # 2036
      # 2037
      # 2038
      # 2039
      const_set_lazy(:FIXED_DATES) { Array.typed(::Java::Int).new([719163, 719528, 719893, 720259, 720624, 720989, 721354, 721720, 722085, 722450, 722815, 723181, 723546, 723911, 724276, 724642, 725007, 725372, 725737, 726103, 726468, 726833, 727198, 727564, 727929, 728294, 728659, 729025, 729390, 729755, 730120, 730486, 730851, 731216, 731581, 731947, 732312, 732677, 733042, 733408, 733773, 734138, 734503, 734869, 735234, 735599, 735964, 736330, 736695, 737060, 737425, 737791, 738156, 738521, 738886, 739252, 739617, 739982, 740347, 740713, 741078, 741443, 741808, 742174, 742539, 742904, 743269, 743635, 744000, 744365, ]) }
      const_attr_reader  :FIXED_DATES
      
      const_set_lazy(:Date) { Class.new(CalendarDate) do
        include_class_members BaseCalendar
        
        typesig { [] }
        def initialize
          @cached_year = 0
          @cached_fixed_date_jan1 = 0
          @cached_fixed_date_next_jan1 = 0
          super()
          @cached_year = 2004
          @cached_fixed_date_jan1 = 731581
          @cached_fixed_date_next_jan1 = @cached_fixed_date_jan1 + 366
        end
        
        typesig { [self::TimeZone] }
        def initialize(zone)
          @cached_year = 0
          @cached_fixed_date_jan1 = 0
          @cached_fixed_date_next_jan1 = 0
          super(zone)
          @cached_year = 2004
          @cached_fixed_date_jan1 = 731581
          @cached_fixed_date_next_jan1 = @cached_fixed_date_jan1 + 366
        end
        
        typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
        def set_normalized_date(normalized_year, month, day_of_month)
          set_normalized_year(normalized_year)
          set_month(month).set_day_of_month(day_of_month)
          return self
        end
        
        typesig { [] }
        def get_normalized_year
          raise NotImplementedError
        end
        
        typesig { [::Java::Int] }
        def set_normalized_year(normalized_year)
          raise NotImplementedError
        end
        
        # Cache for the fixed date of January 1 and year length of the
        # cachedYear. A simple benchmark showed 7% performance
        # improvement with >90% cache hit. The initial values are for Gregorian.
        attr_accessor :cached_year
        alias_method :attr_cached_year, :cached_year
        undef_method :cached_year
        alias_method :attr_cached_year=, :cached_year=
        undef_method :cached_year=
        
        attr_accessor :cached_fixed_date_jan1
        alias_method :attr_cached_fixed_date_jan1, :cached_fixed_date_jan1
        undef_method :cached_fixed_date_jan1
        alias_method :attr_cached_fixed_date_jan1=, :cached_fixed_date_jan1=
        undef_method :cached_fixed_date_jan1=
        
        attr_accessor :cached_fixed_date_next_jan1
        alias_method :attr_cached_fixed_date_next_jan1, :cached_fixed_date_next_jan1
        undef_method :cached_fixed_date_next_jan1
        alias_method :attr_cached_fixed_date_next_jan1=, :cached_fixed_date_next_jan1=
        undef_method :cached_fixed_date_next_jan1=
        
        typesig { [::Java::Int] }
        def hit(year)
          return (year).equal?(@cached_year)
        end
        
        typesig { [::Java::Long] }
        def hit(fixed_date)
          return (fixed_date >= @cached_fixed_date_jan1 && fixed_date < @cached_fixed_date_next_jan1)
        end
        
        typesig { [] }
        def get_cached_year
          return @cached_year
        end
        
        typesig { [] }
        def get_cached_jan1
          return @cached_fixed_date_jan1
        end
        
        typesig { [::Java::Int, ::Java::Long, ::Java::Int] }
        def set_cache(year, jan1, len)
          @cached_year = year
          @cached_fixed_date_jan1 = jan1
          @cached_fixed_date_next_jan1 = jan1 + len
        end
        
        private
        alias_method :initialize__date, :initialize
      end }
    }
    
    typesig { [CalendarDate] }
    def validate(date)
      bdate = date
      if (bdate.is_normalized)
        return true
      end
      month = bdate.get_month
      if (month < JANUARY || month > DECEMBER)
        return false
      end
      d = bdate.get_day_of_month
      if (d <= 0 || d > get_month_length(bdate.get_normalized_year, month))
        return false
      end
      dow = bdate.get_day_of_week
      if (!(dow).equal?(bdate.attr_field_undefined) && !(dow).equal?(get_day_of_week(bdate)))
        return false
      end
      if (!validate_time(date))
        return false
      end
      bdate.set_normalized(true)
      return true
    end
    
    typesig { [CalendarDate] }
    def normalize(date)
      if (date.is_normalized)
        return true
      end
      bdate = date
      zi = bdate.get_zone
      # If the date has a time zone, then we need to recalculate
      # the calendar fields. Let getTime() do it.
      if (!(zi).nil?)
        get_time(date)
        return true
      end
      days = normalize_time(bdate)
      normalize_month(bdate)
      d = bdate.get_day_of_month + days
      m = bdate.get_month
      y = bdate.get_normalized_year
      ml = get_month_length(y, m)
      if (!(d > 0 && d <= ml))
        if (d <= 0 && d > -28)
          ml = get_month_length(y, (m -= 1))
          d += ml
          bdate.set_day_of_month(RJava.cast_to_int(d))
          if ((m).equal?(0))
            m = DECEMBER
            bdate.set_normalized_year(y - 1)
          end
          bdate.set_month(m)
        else
          if (d > ml && d < (ml + 28))
            d -= ml
            (m += 1)
            bdate.set_day_of_month(RJava.cast_to_int(d))
            if (m > DECEMBER)
              bdate.set_normalized_year(y + 1)
              m = JANUARY
            end
            bdate.set_month(m)
          else
            fixed_date = d + get_fixed_date(y, m, 1, bdate) - 1
            get_calendar_date_from_fixed_date(bdate, fixed_date)
          end
        end
      else
        bdate.set_day_of_week(get_day_of_week(bdate))
      end
      date.set_leap_year(is_leap_year(bdate.get_normalized_year))
      date.set_zone_offset(0)
      date.set_daylight_saving(0)
      bdate.set_normalized(true)
      return true
    end
    
    typesig { [CalendarDate] }
    def normalize_month(date)
      bdate = date
      year = bdate.get_normalized_year
      month = bdate.get_month
      if (month <= 0)
        xm = 1 - month
        year -= RJava.cast_to_int(((xm / 12) + 1))
        month = 13 - (xm % 12)
        bdate.set_normalized_year(year)
        bdate.set_month(RJava.cast_to_int(month))
      else
        if (month > DECEMBER)
          year += RJava.cast_to_int(((month - 1) / 12))
          month = ((month - 1)) % 12 + 1
          bdate.set_normalized_year(year)
          bdate.set_month(RJava.cast_to_int(month))
        end
      end
    end
    
    typesig { [CalendarDate] }
    # Returns 366 if the specified date is in a leap year, or 365
    # otherwise This method does not perform the normalization with
    # the specified <code>CalendarDate</code>. The
    # <code>CalendarDate</code> must be normalized to get a correct
    # value.
    # 
    # @param a <code>CalendarDate</code>
    # @return a year length in days
    # @throws ClassCastException if the specified date is not a
    # {@link BaseCalendar.Date}
    def get_year_length(date)
      return is_leap_year((date).get_normalized_year) ? 366 : 365
    end
    
    typesig { [CalendarDate] }
    def get_year_length_in_months(date)
      return 12
    end
    
    class_module.module_eval {
      # 12   1   2   3   4   5   6   7   8   9  10  11  12
      const_set_lazy(:DAYS_IN_MONTH) { Array.typed(::Java::Int).new([31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]) }
      const_attr_reader  :DAYS_IN_MONTH
      
      # 12/1 1/1 2/1 3/1 4/1 5/1 6/1 7/1 8/1 9/1 10/1 11/1 12/1
      const_set_lazy(:ACCUMULATED_DAYS_IN_MONTH) { Array.typed(::Java::Int).new([-30, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]) }
      const_attr_reader  :ACCUMULATED_DAYS_IN_MONTH
      
      # 12/1 1/1 2/1   3/1   4/1   5/1   6/1   7/1   8/1   9/1   10/1   11/1   12/1
      const_set_lazy(:ACCUMULATED_DAYS_IN_MONTH_LEAP) { Array.typed(::Java::Int).new([-30, 0, 31, 59 + 1, 90 + 1, 120 + 1, 151 + 1, 181 + 1, 212 + 1, 243 + 1, 273 + 1, 304 + 1, 334 + 1]) }
      const_attr_reader  :ACCUMULATED_DAYS_IN_MONTH_LEAP
    }
    
    typesig { [CalendarDate] }
    def get_month_length(date)
      gdate = date
      month = gdate.get_month
      if (month < JANUARY || month > DECEMBER)
        raise IllegalArgumentException.new("Illegal month value: " + RJava.cast_to_string(month))
      end
      return get_month_length(gdate.get_normalized_year, month)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # accepts 0 (December in the previous year) to 12.
    def get_month_length(year, month)
      days = DAYS_IN_MONTH[month]
      if ((month).equal?(FEBRUARY) && is_leap_year(year))
        days += 1
      end
      return days
    end
    
    typesig { [CalendarDate] }
    def get_day_of_year(date)
      return get_day_of_year((date).get_normalized_year, date.get_month, date.get_day_of_month)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    def get_day_of_year(year, month, day_of_month)
      return day_of_month + (is_leap_year(year) ? ACCUMULATED_DAYS_IN_MONTH_LEAP[month] : ACCUMULATED_DAYS_IN_MONTH[month])
    end
    
    typesig { [CalendarDate] }
    # protected
    def get_fixed_date(date)
      if (!date.is_normalized)
        normalize_month(date)
      end
      return get_fixed_date((date).get_normalized_year, date.get_month, date.get_day_of_month, date)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, BaseCalendar::Date] }
    # public for java.util.GregorianCalendar
    def get_fixed_date(year, month, day_of_month, cache)
      is_jan1 = (month).equal?(JANUARY) && (day_of_month).equal?(1)
      # Look up the one year cache
      if (!(cache).nil? && cache.hit(year))
        if (is_jan1)
          return cache.get_cached_jan1
        end
        return cache.get_cached_jan1 + get_day_of_year(year, month, day_of_month) - 1
      end
      # Look up the pre-calculated fixed date table
      n = year - BASE_YEAR
      if (n >= 0 && n < FIXED_DATES.attr_length)
        jan1 = FIXED_DATES[n]
        if (!(cache).nil?)
          cache.set_cache(year, jan1, is_leap_year(year) ? 366 : 365)
        end
        return is_jan1 ? jan1 : jan1 + get_day_of_year(year, month, day_of_month) - 1
      end
      prevyear = year - 1
      days = day_of_month
      if (prevyear >= 0)
        days += (365 * prevyear) + (prevyear / 4) - (prevyear / 100) + (prevyear / 400) + ((367 * month - 362) / 12)
      else
        days += (365 * prevyear) + CalendarUtils.floor_divide(prevyear, 4) - CalendarUtils.floor_divide(prevyear, 100) + CalendarUtils.floor_divide(prevyear, 400) + CalendarUtils.floor_divide((367 * month - 362), 12)
      end
      if (month > FEBRUARY)
        days -= is_leap_year(year) ? 1 : 2
      end
      # If it's January 1, update the cache.
      if (!(cache).nil? && is_jan1)
        cache.set_cache(year, days, is_leap_year(year) ? 366 : 365)
      end
      return days
    end
    
    typesig { [CalendarDate, ::Java::Long] }
    # Calculates calendar fields and store them in the specified
    # <code>CalendarDate</code>.
    # 
    # should be 'protected'
    def get_calendar_date_from_fixed_date(date, fixed_date)
      gdate = date
      year = 0
      jan1 = 0
      is_leap = false
      if (gdate.hit(fixed_date))
        year = gdate.get_cached_year
        jan1 = gdate.get_cached_jan1
        is_leap = is_leap_year(year)
      else
        # Looking up FIXED_DATES[] here didn't improve performance
        # much. So we calculate year and jan1. getFixedDate()
        # will look up FIXED_DATES[] actually.
        year = get_gregorian_year_from_fixed_date(fixed_date)
        jan1 = get_fixed_date(year, JANUARY, 1, nil)
        is_leap = is_leap_year(year)
        # Update the cache data
        gdate.set_cache(year, jan1, is_leap ? 366 : 365)
      end
      prior_days = RJava.cast_to_int((fixed_date - jan1))
      mar1 = jan1 + 31 + 28
      if (is_leap)
        (mar1 += 1)
      end
      if (fixed_date >= mar1)
        prior_days += is_leap ? 1 : 2
      end
      month = 12 * prior_days + 373
      if (month > 0)
        month /= 367
      else
        month = CalendarUtils.floor_divide(month, 367)
      end
      month1 = jan1 + ACCUMULATED_DAYS_IN_MONTH[month]
      if (is_leap && month >= MARCH)
        (month1 += 1)
      end
      day_of_month = RJava.cast_to_int((fixed_date - month1)) + 1
      day_of_week = get_day_of_week_from_fixed_date(fixed_date)
      raise AssertError, "negative day of week " + RJava.cast_to_string(day_of_week) if not (day_of_week > 0)
      gdate.set_normalized_year(year)
      gdate.set_month(month)
      gdate.set_day_of_month(day_of_month)
      gdate.set_day_of_week(day_of_week)
      gdate.set_leap_year(is_leap)
      gdate.set_normalized(true)
    end
    
    typesig { [CalendarDate] }
    # Returns the day of week of the given Gregorian date.
    def get_day_of_week(date)
      fixed_date = get_fixed_date(date)
      return get_day_of_week_from_fixed_date(fixed_date)
    end
    
    class_module.module_eval {
      typesig { [::Java::Long] }
      def get_day_of_week_from_fixed_date(fixed_date)
        # The fixed day 1 (January 1, 1 Gregorian) is Monday.
        if (fixed_date >= 0)
          return RJava.cast_to_int((fixed_date % 7)) + SUNDAY
        end
        return RJava.cast_to_int(CalendarUtils.mod(fixed_date, 7)) + SUNDAY
      end
    }
    
    typesig { [::Java::Long] }
    def get_year_from_fixed_date(fixed_date)
      return get_gregorian_year_from_fixed_date(fixed_date)
    end
    
    typesig { [::Java::Long] }
    # Returns the Gregorian year number of the given fixed date.
    def get_gregorian_year_from_fixed_date(fixed_date)
      d0 = 0
      d1 = 0
      d2 = 0
      d3 = 0
      d4 = 0
      n400 = 0
      n100 = 0
      n4 = 0
      n1 = 0
      year = 0
      if (fixed_date > 0)
        d0 = fixed_date - 1
        n400 = RJava.cast_to_int((d0 / 146097))
        d1 = RJava.cast_to_int((d0 % 146097))
        n100 = d1 / 36524
        d2 = d1 % 36524
        n4 = d2 / 1461
        d3 = d2 % 1461
        n1 = d3 / 365
        d4 = (d3 % 365) + 1
      else
        d0 = fixed_date - 1
        n400 = RJava.cast_to_int(CalendarUtils.floor_divide(d0, 146097))
        d1 = RJava.cast_to_int(CalendarUtils.mod(d0, 146097))
        n100 = CalendarUtils.floor_divide(d1, 36524)
        d2 = CalendarUtils.mod(d1, 36524)
        n4 = CalendarUtils.floor_divide(d2, 1461)
        d3 = CalendarUtils.mod(d2, 1461)
        n1 = CalendarUtils.floor_divide(d3, 365)
        d4 = CalendarUtils.mod(d3, 365) + 1
      end
      year = 400 * n400 + 100 * n100 + 4 * n4 + n1
      if (!((n100).equal?(4) || (n1).equal?(4)))
        (year += 1)
      end
      return year
    end
    
    typesig { [CalendarDate] }
    # @return true if the specified year is a Gregorian leap year, or
    # false otherwise.
    # @see BaseCalendar#isGregorianLeapYear
    def is_leap_year(date)
      return is_leap_year((date).get_normalized_year)
    end
    
    typesig { [::Java::Int] }
    def is_leap_year(normalized_year)
      return CalendarUtils.is_gregorian_leap_year(normalized_year)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__base_calendar, :initialize
  end
  
end
