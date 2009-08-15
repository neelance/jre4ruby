require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module JapaneseImperialCalendarImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Sun::Util::Calendar, :BaseCalendar
      include_const ::Sun::Util::Calendar, :CalendarDate
      include_const ::Sun::Util::Calendar, :CalendarSystem
      include_const ::Sun::Util::Calendar, :CalendarUtils
      include_const ::Sun::Util::Calendar, :Era
      include_const ::Sun::Util::Calendar, :Gregorian
      include_const ::Sun::Util::Calendar, :LocalGregorianCalendar
      include_const ::Sun::Util::Calendar, :ZoneInfo
      include_const ::Sun::Util::Resources, :LocaleData
    }
  end
  
  # <code>JapaneseImperialCalendar</code> implements a Japanese
  # calendar system in which the imperial era-based year numbering is
  # supported from the Meiji era. The following are the eras supported
  # by this calendar system.
  # <pre><tt>
  # ERA value   Era name    Since (in Gregorian)
  # ------------------------------------------------------
  # 0       N/A         N/A
  # 1       Meiji       1868-01-01 midnight local time
  # 2       Taisho      1912-07-30 midnight local time
  # 3       Showa       1926-12-25 midnight local time
  # 4       Heisei      1989-01-08 midnight local time
  # ------------------------------------------------------
  # </tt></pre>
  # 
  # <p><code>ERA</code> value 0 specifies the years before Meiji and
  # the Gregorian year values are used. Unlike {@link
  # GregorianCalendar}, the Julian to Gregorian transition is not
  # supported because it doesn't make any sense to the Japanese
  # calendar systems used before Meiji. To represent the years before
  # Gregorian year 1, 0 and negative values are used. The Japanese
  # Imperial rescripts and government decrees don't specify how to deal
  # with time differences for applying the era transitions. This
  # calendar implementation assumes local time for all transitions.
  # 
  # @author Masayoshi Okutsu
  # @since 1.6
  class JapaneseImperialCalendar < JapaneseImperialCalendarImports.const_get :Calendar
    include_class_members JapaneseImperialCalendarImports
    
    class_module.module_eval {
      # Implementation Notes
      # 
      # This implementation uses
      # sun.util.calendar.LocalGregorianCalendar to perform most of the
      # calendar calculations. LocalGregorianCalendar is configurable
      # and reads <JRE_HOME>/lib/calendars.properties at the start-up.
      # 
      # 
      # The ERA constant designating the era before Meiji.
      const_set_lazy(:BEFORE_MEIJI) { 0 }
      const_attr_reader  :BEFORE_MEIJI
      
      # The ERA constant designating the Meiji era.
      const_set_lazy(:MEIJI) { 1 }
      const_attr_reader  :MEIJI
      
      # The ERA constant designating the Taisho era.
      const_set_lazy(:TAISHO) { 2 }
      const_attr_reader  :TAISHO
      
      # The ERA constant designating the Showa era.
      const_set_lazy(:SHOWA) { 3 }
      const_attr_reader  :SHOWA
      
      # The ERA constant designating the Heisei era.
      const_set_lazy(:HEISEI) { 4 }
      const_attr_reader  :HEISEI
      
      const_set_lazy(:EPOCH_OFFSET) { 719163 }
      const_attr_reader  :EPOCH_OFFSET
      
      # Fixed date of January 1, 1970 (Gregorian)
      const_set_lazy(:EPOCH_YEAR) { 1970 }
      const_attr_reader  :EPOCH_YEAR
      
      # Useful millisecond constants.  Although ONE_DAY and ONE_WEEK can fit
      # into ints, they must be longs in order to prevent arithmetic overflow
      # when performing (bug 4173516).
      const_set_lazy(:ONE_SECOND) { 1000 }
      const_attr_reader  :ONE_SECOND
      
      const_set_lazy(:ONE_MINUTE) { 60 * ONE_SECOND }
      const_attr_reader  :ONE_MINUTE
      
      const_set_lazy(:ONE_HOUR) { 60 * ONE_MINUTE }
      const_attr_reader  :ONE_HOUR
      
      const_set_lazy(:ONE_DAY) { 24 * ONE_HOUR }
      const_attr_reader  :ONE_DAY
      
      const_set_lazy(:ONE_WEEK) { 7 * ONE_DAY }
      const_attr_reader  :ONE_WEEK
      
      # Reference to the sun.util.calendar.LocalGregorianCalendar instance (singleton).
      const_set_lazy(:Jcal) { CalendarSystem.for_name("japanese") }
      const_attr_reader  :Jcal
      
      # Gregorian calendar instance. This is required because era
      # transition dates are given in Gregorian dates.
      const_set_lazy(:Gcal) { CalendarSystem.get_gregorian_calendar }
      const_attr_reader  :Gcal
      
      # The Era instance representing "before Meiji".
      const_set_lazy(:BEFORE_MEIJI_ERA) { Era.new("BeforeMeiji", "BM", Long::MIN_VALUE, false) }
      const_attr_reader  :BEFORE_MEIJI_ERA
      
      # <pre>
      # Greatest       Least
      # Field name             Minimum   Minimum     Maximum     Maximum
      # ----------             -------   -------     -------     -------
      # ERA                          0         0           1           1
      # YEAR                -292275055         1           ?           ?
      # MONTH                        0         0          11          11
      # WEEK_OF_YEAR                 1         1          52*         53
      # WEEK_OF_MONTH                0         0           4*          6
      # DAY_OF_MONTH                 1         1          28*         31
      # DAY_OF_YEAR                  1         1         365*        366
      # DAY_OF_WEEK                  1         1           7           7
      # DAY_OF_WEEK_IN_MONTH        -1        -1           4*          6
      # AM_PM                        0         0           1           1
      # HOUR                         0         0          11          11
      # HOUR_OF_DAY                  0         0          23          23
      # MINUTE                       0         0          59          59
      # SECOND                       0         0          59          59
      # MILLISECOND                  0         0         999         999
      # ZONE_OFFSET             -13:00    -13:00       14:00       14:00
      # DST_OFFSET                0:00      0:00        0:20        2:00
      # </pre>
      # *: depends on eras
      # 
      # ERA
      # YEAR
      # MONTH
      # WEEK_OF_YEAR
      # WEEK_OF_MONTH
      # DAY_OF_MONTH
      # DAY_OF_YEAR
      # DAY_OF_WEEK
      # DAY_OF_WEEK_IN_MONTH
      # AM_PM
      # HOUR
      # HOUR_OF_DAY
      # MINUTE
      # SECOND
      # MILLISECOND
      # ZONE_OFFSET (UNIX compatibility)
      # DST_OFFSET
      const_set_lazy(:MIN_VALUES) { Array.typed(::Java::Int).new([0, -292275055, JANUARY, 1, 0, 1, 1, SUNDAY, 1, AM, 0, 0, 0, 0, 0, -13 * ONE_HOUR, 0]) }
      const_attr_reader  :MIN_VALUES
      
      # ERA (initialized later)
      # YEAR (initialized later)
      # MONTH (Showa 64 ended in January.)
      # WEEK_OF_YEAR (Showa 1 has only 6 days which could be 0 weeks.)
      # WEEK_OF_MONTH
      # DAY_OF_MONTH
      # DAY_OF_YEAR (initialized later)
      # DAY_OF_WEEK
      # DAY_OF_WEEK_IN
      # AM_PM
      # HOUR
      # HOUR_OF_DAY
      # MINUTE
      # SECOND
      # MILLISECOND
      # ZONE_OFFSET
      # DST_OFFSET (historical least maximum)
      const_set_lazy(:LEAST_MAX_VALUES) { Array.typed(::Java::Int).new([0, 0, JANUARY, 0, 4, 28, 0, SATURDAY, 4, PM, 11, 23, 59, 59, 999, 14 * ONE_HOUR, 20 * ONE_MINUTE]) }
      const_attr_reader  :LEAST_MAX_VALUES
      
      # ERA
      # YEAR
      # MONTH
      # WEEK_OF_YEAR
      # WEEK_OF_MONTH
      # DAY_OF_MONTH
      # DAY_OF_YEAR
      # DAY_OF_WEEK
      # DAY_OF_WEEK_IN
      # AM_PM
      # HOUR
      # HOUR_OF_DAY
      # MINUTE
      # SECOND
      # MILLISECOND
      # ZONE_OFFSET
      # DST_OFFSET (double summer time)
      const_set_lazy(:MAX_VALUES) { Array.typed(::Java::Int).new([0, 292278994, DECEMBER, 53, 6, 31, 366, SATURDAY, 6, PM, 11, 23, 59, 59, 999, 14 * ONE_HOUR, 2 * ONE_HOUR]) }
      const_attr_reader  :MAX_VALUES
      
      # Proclaim serialization compatibility with JDK 1.6
      const_set_lazy(:SerialVersionUID) { -3364572813905467929 }
      const_attr_reader  :SerialVersionUID
      
      when_class_loaded do
        es = Jcal.get_eras
        length = es.attr_length + 1
        const_set :Eras, Array.typed(Era).new(length) { nil }
        const_set :SinceFixedDates, Array.typed(::Java::Long).new(length) { 0 }
        # eras[BEFORE_MEIJI] and sinceFixedDate[BEFORE_MEIJI] are the
        # same as Gregorian.
        index = BEFORE_MEIJI
        SinceFixedDates[index] = Gcal.get_fixed_date(BEFORE_MEIJI_ERA.get_since_date)
        Eras[((index += 1) - 1)] = BEFORE_MEIJI_ERA
        es.each do |e|
          d = e.get_since_date
          SinceFixedDates[index] = Gcal.get_fixed_date(d)
          Eras[((index += 1) - 1)] = e
        end
        LEAST_MAX_VALUES[ERA] = MAX_VALUES[ERA] = Eras.attr_length - 1
        # Calculate the least maximum year and least day of Year
        # values. The following code assumes that there's at most one
        # era transition in a Gregorian year.
        year = JavaInteger::MAX_VALUE
        day_of_year = JavaInteger::MAX_VALUE
        date = Gcal.new_calendar_date(TimeZone::NO_TIMEZONE)
        i = 1
        while i < Eras.attr_length
          fd = SinceFixedDates[i]
          transition_date = Eras[i].get_since_date
          date.set_date(transition_date.get_year, BaseCalendar::JANUARY, 1)
          fdd = Gcal.get_fixed_date(date)
          day_of_year = Math.min(RJava.cast_to_int((fdd - fd)), day_of_year)
          date.set_date(transition_date.get_year, BaseCalendar::DECEMBER, 31)
          fdd = Gcal.get_fixed_date(date) + 1
          day_of_year = Math.min(RJava.cast_to_int((fd - fdd)), day_of_year)
          lgd = get_calendar_date(fd - 1)
          y = lgd.get_year
          # Unless the first year starts from January 1, the actual
          # max value could be one year short. For example, if it's
          # Showa 63 January 8, 63 is the actual max value since
          # Showa 64 January 8 doesn't exist.
          if (!((lgd.get_month).equal?(BaseCalendar::JANUARY) && (lgd.get_day_of_month).equal?(1)))
            y -= 1
          end
          year = Math.min(y, year)
          i += 1
        end
        LEAST_MAX_VALUES[YEAR] = year # Max year could be smaller than this value.
        LEAST_MAX_VALUES[DAY_OF_YEAR] = day_of_year
      end
    }
    
    # jdate always has a sun.util.calendar.LocalGregorianCalendar.Date instance to
    # avoid overhead of creating it for each calculation.
    attr_accessor :jdate
    alias_method :attr_jdate, :jdate
    undef_method :jdate
    alias_method :attr_jdate=, :jdate=
    undef_method :jdate=
    
    # Temporary int[2] to get time zone offsets. zoneOffsets[0] gets
    # the GMT offset value and zoneOffsets[1] gets the daylight saving
    # value.
    attr_accessor :zone_offsets
    alias_method :attr_zone_offsets, :zone_offsets
    undef_method :zone_offsets
    alias_method :attr_zone_offsets=, :zone_offsets=
    undef_method :zone_offsets=
    
    # Temporary storage for saving original fields[] values in
    # non-lenient mode.
    attr_accessor :original_fields
    alias_method :attr_original_fields, :original_fields
    undef_method :original_fields
    alias_method :attr_original_fields=, :original_fields=
    undef_method :original_fields=
    
    typesig { [TimeZone, Locale] }
    # Constructs a <code>JapaneseImperialCalendar</code> based on the current time
    # in the given time zone with the given locale.
    # 
    # @param zone the given time zone.
    # @param aLocale the given locale.
    def initialize(zone, a_locale)
      @jdate = nil
      @zone_offsets = nil
      @original_fields = nil
      @cached_fixed_date = 0
      super(zone, a_locale)
      @cached_fixed_date = Long::MIN_VALUE
      @jdate = Jcal.new_calendar_date(zone)
      set_time_in_millis(System.current_time_millis)
    end
    
    typesig { [Object] }
    # Compares this <code>JapaneseImperialCalendar</code> to the specified
    # <code>Object</code>. The result is <code>true</code> if and
    # only if the argument is a <code>JapaneseImperialCalendar</code> object
    # that represents the same time value (millisecond offset from
    # the <a href="Calendar.html#Epoch">Epoch</a>) under the same
    # <code>Calendar</code> parameters.
    # 
    # @param obj the object to compare with.
    # @return <code>true</code> if this object is equal to <code>obj</code>;
    # <code>false</code> otherwise.
    # @see Calendar#compareTo(Calendar)
    def ==(obj)
      return obj.is_a?(JapaneseImperialCalendar) && super(obj)
    end
    
    typesig { [] }
    # Generates the hash code for this
    # <code>JapaneseImperialCalendar</code> object.
    def hash_code
      return super ^ @jdate.hash_code
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Adds the specified (signed) amount of time to the given calendar field,
    # based on the calendar's rules.
    # 
    # <p><em>Add rule 1</em>. The value of <code>field</code>
    # after the call minus the value of <code>field</code> before the
    # call is <code>amount</code>, modulo any overflow that has occurred in
    # <code>field</code>. Overflow occurs when a field value exceeds its
    # range and, as a result, the next larger field is incremented or
    # decremented and the field value is adjusted back into its range.</p>
    # 
    # <p><em>Add rule 2</em>. If a smaller field is expected to be
    # invariant, but it is impossible for it to be equal to its
    # prior value because of changes in its minimum or maximum after
    # <code>field</code> is changed, then its value is adjusted to be as close
    # as possible to its expected value. A smaller field represents a
    # smaller unit of time. <code>HOUR</code> is a smaller field than
    # <code>DAY_OF_MONTH</code>. No adjustment is made to smaller fields
    # that are not expected to be invariant. The calendar system
    # determines what fields are expected to be invariant.</p>
    # 
    # @param field the calendar field.
    # @param amount the amount of date or time to be added to the field.
    # @exception IllegalArgumentException if <code>field</code> is
    # <code>ZONE_OFFSET</code>, <code>DST_OFFSET</code>, or unknown,
    # or if any calendar fields have out-of-range values in
    # non-lenient mode.
    def add(field, amount)
      # If amount == 0, do nothing even the given field is out of
      # range. This is tested by JCK.
      if ((amount).equal?(0))
        return # Do nothing!
      end
      if (field < 0 || field >= ZONE_OFFSET)
        raise IllegalArgumentException.new
      end
      # Sync the time and calendar fields.
      complete
      if ((field).equal?(YEAR))
        d = @jdate.clone
        d.add_year(amount)
        pin_day_of_month(d)
        set(ERA, get_era_index(d))
        set(YEAR, d.get_year)
        set(MONTH, d.get_month - 1)
        set(DAY_OF_MONTH, d.get_day_of_month)
      else
        if ((field).equal?(MONTH))
          d = @jdate.clone
          d.add_month(amount)
          pin_day_of_month(d)
          set(ERA, get_era_index(d))
          set(YEAR, d.get_year)
          set(MONTH, d.get_month - 1)
          set(DAY_OF_MONTH, d.get_day_of_month)
        else
          if ((field).equal?(ERA))
            era = internal_get(ERA) + amount
            if (era < 0)
              era = 0
            else
              if (era > Eras.attr_length - 1)
                era = Eras.attr_length - 1
              end
            end
            set(ERA, era)
          else
            delta = amount
            time_of_day = 0
            case (field)
            # Handle the time fields here. Convert the given
            # amount to milliseconds and call setTimeInMillis.
            # Handle week, day and AM_PM fields which involves
            # time zone offset change adjustment. Convert the
            # given amount to the number of days.
            # synonym of DATE
            when HOUR, HOUR_OF_DAY
              delta *= 60 * 60 * 1000 # hours to milliseconds
            when MINUTE
              delta *= 60 * 1000 # minutes to milliseconds
            when SECOND
              delta *= 1000 # seconds to milliseconds
            when MILLISECOND
            when WEEK_OF_YEAR, WEEK_OF_MONTH, DAY_OF_WEEK_IN_MONTH
              delta *= 7
            when DAY_OF_MONTH, DAY_OF_YEAR, DAY_OF_WEEK
            when AM_PM
              # Convert the amount to the number of days (delta)
              # and +12 or -12 hours (timeOfDay).
              delta = amount / 2
              time_of_day = 12 * (amount % 2)
            end
            # The time fields don't require time zone offset change
            # adjustment.
            if (field >= HOUR)
              set_time_in_millis(self.attr_time + delta)
              return
            end
            # The rest of the fields (week, day or AM_PM fields)
            # require time zone offset (both GMT and DST) change
            # adjustment.
            # Translate the current time to the fixed date and time
            # of the day.
            fd = @cached_fixed_date
            time_of_day += internal_get(HOUR_OF_DAY)
            time_of_day *= 60
            time_of_day += internal_get(MINUTE)
            time_of_day *= 60
            time_of_day += internal_get(SECOND)
            time_of_day *= 1000
            time_of_day += internal_get(MILLISECOND)
            if (time_of_day >= ONE_DAY)
              fd += 1
              time_of_day -= ONE_DAY
            else
              if (time_of_day < 0)
                fd -= 1
                time_of_day += ONE_DAY
              end
            end
            fd += delta # fd is the expected fixed date after the calculation
            zone_offset = internal_get(ZONE_OFFSET) + internal_get(DST_OFFSET)
            set_time_in_millis((fd - EPOCH_OFFSET) * ONE_DAY + time_of_day - zone_offset)
            zone_offset -= internal_get(ZONE_OFFSET) + internal_get(DST_OFFSET)
            # If the time zone offset has changed, then adjust the difference.
            if (!(zone_offset).equal?(0))
              set_time_in_millis(self.attr_time + zone_offset)
              fd2 = @cached_fixed_date
              # If the adjustment has changed the date, then take
              # the previous one.
              if (!(fd2).equal?(fd))
                set_time_in_millis(self.attr_time - zone_offset)
              end
            end
          end
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    def roll(field, up)
      roll(field, up ? +1 : -1)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Adds a signed amount to the specified calendar field without changing larger fields.
    # A negative roll amount means to subtract from field without changing
    # larger fields. If the specified amount is 0, this method performs nothing.
    # 
    # <p>This method calls {@link #complete()} before adding the
    # amount so that all the calendar fields are normalized. If there
    # is any calendar field having an out-of-range value in non-lenient mode, then an
    # <code>IllegalArgumentException</code> is thrown.
    # 
    # @param field the calendar field.
    # @param amount the signed amount to add to <code>field</code>.
    # @exception IllegalArgumentException if <code>field</code> is
    # <code>ZONE_OFFSET</code>, <code>DST_OFFSET</code>, or unknown,
    # or if any calendar fields have out-of-range values in
    # non-lenient mode.
    # @see #roll(int,boolean)
    # @see #add(int,int)
    # @see #set(int,int)
    def roll(field, amount)
      # If amount == 0, do nothing even the given field is out of
      # range. This is tested by JCK.
      if ((amount).equal?(0))
        return
      end
      if (field < 0 || field >= ZONE_OFFSET)
        raise IllegalArgumentException.new
      end
      # Sync the time and calendar fields.
      complete
      min_ = get_minimum(field)
      max = get_maximum(field)
      catch(:break_case) do
        case (field)
        when ERA, AM_PM, MINUTE, SECOND, MILLISECOND
          # These fields are handled simply, since they have fixed
          # minima and maxima. Other fields are complicated, since
          # the range within they must roll varies depending on the
          # date, a time zone and the era transitions.
        when HOUR, HOUR_OF_DAY
          unit = max + 1 # 12 or 24 hours
          h = internal_get(field)
          nh = (h + amount) % unit
          if (nh < 0)
            nh += unit
          end
          self.attr_time += ONE_HOUR * (nh - h)
          # The day might have changed, which could happen if
          # the daylight saving time transition brings it to
          # the next day, although it's very unlikely. But we
          # have to make sure not to change the larger fields.
          d = Jcal.get_calendar_date(self.attr_time, get_zone)
          if (!(internal_get(DAY_OF_MONTH)).equal?(d.get_day_of_month))
            d.set_era(@jdate.get_era)
            d.set_date(internal_get(YEAR), internal_get(MONTH) + 1, internal_get(DAY_OF_MONTH))
            if ((field).equal?(HOUR))
              raise AssertError if not (((internal_get(AM_PM)).equal?(PM)))
              d.add_hours(+12) # restore PM
            end
            self.attr_time = Jcal.get_time(d)
          end
          hour_of_day = d.get_hours
          internal_set(field, hour_of_day % unit)
          if ((field).equal?(HOUR))
            internal_set(HOUR_OF_DAY, hour_of_day)
          else
            internal_set(AM_PM, hour_of_day / 12)
            internal_set(HOUR, hour_of_day % 12)
          end
          # Time zone offset and/or daylight saving might have changed.
          zone_offset = d.get_zone_offset
          saving = d.get_daylight_saving
          internal_set(ZONE_OFFSET, zone_offset - saving)
          internal_set(DST_OFFSET, saving)
          return
        when YEAR
          min_ = get_actual_minimum(field)
          max = get_actual_maximum(field)
        when MONTH
          # Rolling the month involves both pinning the final value to [0, 11]
          # and adjusting the DAY_OF_MONTH if necessary.  We only adjust the
          # DAY_OF_MONTH if, after updating the MONTH field, it is illegal.
          # E.g., <jan31>.roll(MONTH, 1) -> <feb28> or <feb29>.
          if (!is_transition_year(@jdate.get_normalized_year))
            year = @jdate.get_year
            if ((year).equal?(get_maximum(YEAR)))
              jd = Jcal.get_calendar_date(self.attr_time, get_zone)
              d = Jcal.get_calendar_date(Long::MAX_VALUE, get_zone)
              max = d.get_month - 1
              n = get_rolled_value(internal_get(field), amount, min_, max)
              if ((n).equal?(max))
                # To avoid overflow, use an equivalent year.
                jd.add_year(-400)
                jd.set_month(n + 1)
                if (jd.get_day_of_month > d.get_day_of_month)
                  jd.set_day_of_month(d.get_day_of_month)
                  Jcal.normalize(jd)
                end
                if ((jd.get_day_of_month).equal?(d.get_day_of_month) && jd.get_time_of_day > d.get_time_of_day)
                  jd.set_month(n + 1)
                  jd.set_day_of_month(d.get_day_of_month - 1)
                  Jcal.normalize(jd)
                  # Month may have changed by the normalization.
                  n = jd.get_month - 1
                end
                set(DAY_OF_MONTH, jd.get_day_of_month)
              end
              set(MONTH, n)
            else
              if ((year).equal?(get_minimum(YEAR)))
                jd = Jcal.get_calendar_date(self.attr_time, get_zone)
                d = Jcal.get_calendar_date(Long::MIN_VALUE, get_zone)
                min_ = d.get_month - 1
                n = get_rolled_value(internal_get(field), amount, min_, max)
                if ((n).equal?(min_))
                  # To avoid underflow, use an equivalent year.
                  jd.add_year(+400)
                  jd.set_month(n + 1)
                  if (jd.get_day_of_month < d.get_day_of_month)
                    jd.set_day_of_month(d.get_day_of_month)
                    Jcal.normalize(jd)
                  end
                  if ((jd.get_day_of_month).equal?(d.get_day_of_month) && jd.get_time_of_day < d.get_time_of_day)
                    jd.set_month(n + 1)
                    jd.set_day_of_month(d.get_day_of_month + 1)
                    Jcal.normalize(jd)
                    # Month may have changed by the normalization.
                    n = jd.get_month - 1
                  end
                  set(DAY_OF_MONTH, jd.get_day_of_month)
                end
                set(MONTH, n)
              else
                mon = (internal_get(MONTH) + amount) % 12
                if (mon < 0)
                  mon += 12
                end
                set(MONTH, mon)
                # Keep the day of month in the range.  We
                # don't want to spill over into the next
                # month; e.g., we don't want jan31 + 1 mo ->
                # feb31 -> mar3.
                month_len = month_length(mon)
                if (internal_get(DAY_OF_MONTH) > month_len)
                  set(DAY_OF_MONTH, month_len)
                end
              end
            end
          else
            era_index = get_era_index(@jdate)
            transition = nil
            if ((@jdate.get_year).equal?(1))
              transition = Eras[era_index].get_since_date
              min_ = transition.get_month - 1
            else
              if (era_index < Eras.attr_length - 1)
                transition = Eras[era_index + 1].get_since_date
                if ((transition.get_year).equal?(@jdate.get_normalized_year))
                  max = transition.get_month - 1
                  if ((transition.get_day_of_month).equal?(1))
                    max -= 1
                  end
                end
              end
            end
            if ((min_).equal?(max))
              # The year has only one month. No need to
              # process further. (Showa Gan-nen (year 1)
              # and the last year have only one month.)
              return
            end
            n = get_rolled_value(internal_get(field), amount, min_, max)
            set(MONTH, n)
            if ((n).equal?(min_))
              if (!((transition.get_month).equal?(BaseCalendar::JANUARY) && (transition.get_day_of_month).equal?(1)))
                if (@jdate.get_day_of_month < transition.get_day_of_month)
                  set(DAY_OF_MONTH, transition.get_day_of_month)
                end
              end
            else
              if ((n).equal?(max) && ((transition.get_month - 1).equal?(n)))
                dom = transition.get_day_of_month
                if (@jdate.get_day_of_month >= dom)
                  set(DAY_OF_MONTH, dom - 1)
                end
              end
            end
          end
          return
        when WEEK_OF_YEAR
          y = @jdate.get_normalized_year
          max = get_actual_maximum(WEEK_OF_YEAR)
          set(DAY_OF_WEEK, internal_get(DAY_OF_WEEK)) # update stamp[field]
          woy = internal_get(WEEK_OF_YEAR)
          value = woy + amount
          if (!is_transition_year(@jdate.get_normalized_year))
            year = @jdate.get_year
            if ((year).equal?(get_maximum(YEAR)))
              max = get_actual_maximum(WEEK_OF_YEAR)
            else
              if ((year).equal?(get_minimum(YEAR)))
                min_ = get_actual_minimum(WEEK_OF_YEAR)
                max = get_actual_maximum(WEEK_OF_YEAR)
                if (value > min_ && value < max)
                  set(WEEK_OF_YEAR, value)
                  return
                end
              end
            end
            # If the new value is in between min and max
            # (exclusive), then we can use the value.
            if (value > min_ && value < max)
              set(WEEK_OF_YEAR, value)
              return
            end
            fd = @cached_fixed_date
            # Make sure that the min week has the current DAY_OF_WEEK
            day1 = fd - (7 * (woy - min_))
            if (!(year).equal?(get_minimum(YEAR)))
              if (!(Gcal.get_year_from_fixed_date(day1)).equal?(y))
                min_ += 1
              end
            else
              d = Jcal.get_calendar_date(Long::MIN_VALUE, get_zone)
              if (day1 < Jcal.get_fixed_date(d))
                min_ += 1
              end
            end
            # Make sure the same thing for the max week
            fd += 7 * (max - internal_get(WEEK_OF_YEAR))
            if (!(Gcal.get_year_from_fixed_date(fd)).equal?(y))
              max -= 1
            end
            throw :break_case, :thrown
          end
          # Handle transition here.
          fd = @cached_fixed_date
          day1 = fd - (7 * (woy - min_))
          # Make sure that the min week has the current DAY_OF_WEEK
          d = get_calendar_date(day1)
          if (!((d.get_era).equal?(@jdate.get_era) && (d.get_year).equal?(@jdate.get_year)))
            min_ += 1
          end
          # Make sure the same thing for the max week
          fd += 7 * (max - woy)
          Jcal.get_calendar_date_from_fixed_date(d, fd)
          if (!((d.get_era).equal?(@jdate.get_era) && (d.get_year).equal?(@jdate.get_year)))
            max -= 1
          end
          # value: the new WEEK_OF_YEAR which must be converted
          # to month and day of month.
          value = get_rolled_value(woy, amount, min_, max) - 1
          d = get_calendar_date(day1 + value * 7)
          set(MONTH, d.get_month - 1)
          set(DAY_OF_MONTH, d.get_day_of_month)
          return
        when WEEK_OF_MONTH
          is_transition_year_ = is_transition_year(@jdate.get_normalized_year)
          # dow: relative day of week from the first day of week
          dow = internal_get(DAY_OF_WEEK) - get_first_day_of_week
          if (dow < 0)
            dow += 7
          end
          fd = @cached_fixed_date
          month1 = 0 # fixed date of the first day (usually 1) of the month
          month_length_ = 0 # actual month length
          if (is_transition_year_)
            month1 = get_fixed_date_month1(@jdate, fd)
            month_length_ = actual_month_length
          else
            month1 = fd - internal_get(DAY_OF_MONTH) + 1
            month_length_ = Jcal.get_month_length(@jdate)
          end
          # the first day of week of the month.
          month_day1st = Jcal.get_day_of_week_date_on_or_before(month1 + 6, get_first_day_of_week)
          # if the week has enough days to form a week, the
          # week starts from the previous month.
          if (RJava.cast_to_int((month_day1st - month1)) >= get_minimal_days_in_first_week)
            month_day1st -= 7
          end
          max = get_actual_maximum(field)
          # value: the new WEEK_OF_MONTH value
          value = get_rolled_value(internal_get(field), amount, 1, max) - 1
          # nfd: fixed date of the rolled date
          nfd = month_day1st + value * 7 + dow
          # Unlike WEEK_OF_YEAR, we need to change day of week if the
          # nfd is out of the month.
          if (nfd < month1)
            nfd = month1
          else
            if (nfd >= (month1 + month_length_))
              nfd = month1 + month_length_ - 1
            end
          end
          set(DAY_OF_MONTH, RJava.cast_to_int((nfd - month1)) + 1)
          return
        when DAY_OF_MONTH
          if (!is_transition_year(@jdate.get_normalized_year))
            max = Jcal.get_month_length(@jdate)
            throw :break_case, :thrown
          end
          # TODO: Need to change the spec to be usable DAY_OF_MONTH rolling...
          # Transition handling. We can't change year and era
          # values here due to the Calendar roll spec!
          month1 = get_fixed_date_month1(@jdate, @cached_fixed_date)
          # It may not be a regular month. Convert the date and range to
          # the relative values, perform the roll, and
          # convert the result back to the rolled date.
          value = get_rolled_value(RJava.cast_to_int((@cached_fixed_date - month1)), amount, 0, actual_month_length - 1)
          d = get_calendar_date(month1 + value)
          raise AssertError if not ((get_era_index(d)).equal?(internal_get_era) && (d.get_year).equal?(internal_get(YEAR)) && (d.get_month - 1).equal?(internal_get(MONTH)))
          set(DAY_OF_MONTH, d.get_day_of_month)
          return
        when DAY_OF_YEAR
          max = get_actual_maximum(field)
          if (!is_transition_year(@jdate.get_normalized_year))
            throw :break_case, :thrown
          end
          # Handle transition. We can't change year and era values
          # here due to the Calendar roll spec.
          value = get_rolled_value(internal_get(DAY_OF_YEAR), amount, min_, max)
          jan0 = @cached_fixed_date - internal_get(DAY_OF_YEAR)
          d = get_calendar_date(jan0 + value)
          raise AssertError if not ((get_era_index(d)).equal?(internal_get_era) && (d.get_year).equal?(internal_get(YEAR)))
          set(MONTH, d.get_month - 1)
          set(DAY_OF_MONTH, d.get_day_of_month)
          return
        when DAY_OF_WEEK
          normalized_year = @jdate.get_normalized_year
          if (!is_transition_year(normalized_year) && !is_transition_year(normalized_year - 1))
            # If the week of year is in the same year, we can
            # just change DAY_OF_WEEK.
            week_of_year = internal_get(WEEK_OF_YEAR)
            if (week_of_year > 1 && week_of_year < 52)
              set(WEEK_OF_YEAR, internal_get(WEEK_OF_YEAR))
              max = SATURDAY
              throw :break_case, :thrown
            end
          end
          # We need to handle it in a different way around year
          # boundaries and in the transition year. Note that
          # changing era and year values violates the roll
          # rule: not changing larger calendar fields...
          amount %= 7
          if ((amount).equal?(0))
            return
          end
          fd = @cached_fixed_date
          dow_first = Jcal.get_day_of_week_date_on_or_before(fd, get_first_day_of_week)
          fd += amount
          if (fd < dow_first)
            fd += 7
          else
            if (fd >= dow_first + 7)
              fd -= 7
            end
          end
          d = get_calendar_date(fd)
          set(ERA, get_era_index(d))
          set(d.get_year, d.get_month - 1, d.get_day_of_month)
          return
        when DAY_OF_WEEK_IN_MONTH
          min_ = 1 # after having normalized, min should be 1.
          if (!is_transition_year(@jdate.get_normalized_year))
            dom = internal_get(DAY_OF_MONTH)
            month_length_ = Jcal.get_month_length(@jdate)
            last_days = month_length_ % 7
            max = month_length_ / 7
            x = (dom - 1) % 7
            if (x < last_days)
              max += 1
            end
            set(DAY_OF_WEEK, internal_get(DAY_OF_WEEK))
            throw :break_case, :thrown
          end
          # Transition year handling.
          fd = @cached_fixed_date
          month1 = get_fixed_date_month1(@jdate, fd)
          month_length_ = actual_month_length
          last_days = month_length_ % 7
          max = month_length_ / 7
          x = RJava.cast_to_int((fd - month1)) % 7
          if (x < last_days)
            max += 1
          end
          value = get_rolled_value(internal_get(field), amount, min_, max) - 1
          fd = month1 + value * 7 + x
          d = get_calendar_date(fd)
          set(DAY_OF_MONTH, d.get_day_of_month)
          return
        end
      end
      set(field, get_rolled_value(internal_get(field), amount, min_, max))
    end
    
    typesig { [::Java::Int, ::Java::Int, Locale] }
    def get_display_name(field, style, locale)
      if (!check_display_name_params(field, style, SHORT, LONG, locale, ERA_MASK | YEAR_MASK | MONTH_MASK | DAY_OF_WEEK_MASK | AM_PM_MASK))
        return nil
      end
      # "GanNen" is supported only in the LONG style.
      if ((field).equal?(YEAR) && ((style).equal?(SHORT) || !(get(YEAR)).equal?(1) || (get(ERA)).equal?(0)))
        return nil
      end
      rb = LocaleData.get_date_format_data(locale)
      name = nil
      key = get_key(field, style)
      if (!(key).nil?)
        strings = rb.get_string_array(key)
        if ((field).equal?(YEAR))
          if (strings.attr_length > 0)
            name = RJava.cast_to_string(strings[0])
          end
        else
          index = get(field)
          # If the ERA value is out of range for strings, then
          # try to get its name or abbreviation from the Era instance.
          if ((field).equal?(ERA) && index >= strings.attr_length && index < Eras.attr_length)
            era = Eras[index]
            name = RJava.cast_to_string(((style).equal?(SHORT)) ? era.get_abbreviation : era.get_name)
          else
            if ((field).equal?(DAY_OF_WEEK))
              (index -= 1)
            end
            name = RJava.cast_to_string(strings[index])
          end
        end
      end
      return name
    end
    
    typesig { [::Java::Int, ::Java::Int, Locale] }
    def get_display_names(field, style, locale)
      if (!check_display_name_params(field, style, ALL_STYLES, LONG, locale, ERA_MASK | YEAR_MASK | MONTH_MASK | DAY_OF_WEEK_MASK | AM_PM_MASK))
        return nil
      end
      if ((style).equal?(ALL_STYLES))
        short_names = get_display_names_impl(field, SHORT, locale)
        if ((field).equal?(AM_PM))
          return short_names
        end
        long_names = get_display_names_impl(field, LONG, locale)
        if ((short_names).nil?)
          return long_names
        end
        if (!(long_names).nil?)
          short_names.put_all(long_names)
        end
        return short_names
      end
      # SHORT or LONG
      return get_display_names_impl(field, style, locale)
    end
    
    typesig { [::Java::Int, ::Java::Int, Locale] }
    def get_display_names_impl(field, style, locale)
      rb = LocaleData.get_date_format_data(locale)
      key = get_key(field, style)
      map = HashMap.new
      if (!(key).nil?)
        strings = rb.get_string_array(key)
        if ((field).equal?(YEAR))
          if (strings.attr_length > 0)
            map.put(strings[0], 1)
          end
        else
          base = ((field).equal?(DAY_OF_WEEK)) ? 1 : 0
          i = 0
          while i < strings.attr_length
            map.put(strings[i], base + i)
            i += 1
          end
          # If strings[] has fewer than eras[], get more names from eras[].
          if ((field).equal?(ERA) && strings.attr_length < Eras.attr_length)
            i_ = strings.attr_length
            while i_ < Eras.attr_length
              era = Eras[i_]
              name = ((style).equal?(SHORT)) ? era.get_abbreviation : era.get_name
              map.put(name, i_)
              i_ += 1
            end
          end
        end
      end
      return map.size > 0 ? map : nil
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def get_key(field, style)
      class_name = JapaneseImperialCalendar.get_name
      key = StringBuilder.new
      case (field)
      when ERA
        key.append(class_name)
        if ((style).equal?(SHORT))
          key.append(".short")
        end
        key.append(".Eras")
      when YEAR
        key.append(class_name).append(".FirstYear")
      when MONTH
        key.append((style).equal?(SHORT) ? "MonthAbbreviations" : "MonthNames")
      when DAY_OF_WEEK
        key.append((style).equal?(SHORT) ? "DayAbbreviations" : "DayNames")
      when AM_PM
        key.append("AmPmMarkers")
      end
      return key.length > 0 ? key.to_s : nil
    end
    
    typesig { [::Java::Int] }
    # Returns the minimum value for the given calendar field of this
    # <code>Calendar</code> instance. The minimum value is
    # defined as the smallest value returned by the {@link
    # Calendar#get(int) get} method for any possible time value,
    # taking into consideration the current values of the
    # {@link Calendar#getFirstDayOfWeek() getFirstDayOfWeek},
    # {@link Calendar#getMinimalDaysInFirstWeek() getMinimalDaysInFirstWeek},
    # and {@link Calendar#getTimeZone() getTimeZone} methods.
    # 
    # @param field the calendar field.
    # @return the minimum value for the given calendar field.
    # @see #getMaximum(int)
    # @see #getGreatestMinimum(int)
    # @see #getLeastMaximum(int)
    # @see #getActualMinimum(int)
    # @see #getActualMaximum(int)
    def get_minimum(field)
      return MIN_VALUES[field]
    end
    
    typesig { [::Java::Int] }
    # Returns the maximum value for the given calendar field of this
    # <code>GregorianCalendar</code> instance. The maximum value is
    # defined as the largest value returned by the {@link
    # Calendar#get(int) get} method for any possible time value,
    # taking into consideration the current values of the
    # {@link Calendar#getFirstDayOfWeek() getFirstDayOfWeek},
    # {@link Calendar#getMinimalDaysInFirstWeek() getMinimalDaysInFirstWeek},
    # and {@link Calendar#getTimeZone() getTimeZone} methods.
    # 
    # @param field the calendar field.
    # @return the maximum value for the given calendar field.
    # @see #getMinimum(int)
    # @see #getGreatestMinimum(int)
    # @see #getLeastMaximum(int)
    # @see #getActualMinimum(int)
    # @see #getActualMaximum(int)
    def get_maximum(field)
      case (field)
      when YEAR
        # The value should depend on the time zone of this calendar.
        d = Jcal.get_calendar_date(Long::MAX_VALUE, get_zone)
        return Math.max(LEAST_MAX_VALUES[YEAR], d.get_year)
      end
      return MAX_VALUES[field]
    end
    
    typesig { [::Java::Int] }
    # Returns the highest minimum value for the given calendar field
    # of this <code>GregorianCalendar</code> instance. The highest
    # minimum value is defined as the largest value returned by
    # {@link #getActualMinimum(int)} for any possible time value,
    # taking into consideration the current values of the
    # {@link Calendar#getFirstDayOfWeek() getFirstDayOfWeek},
    # {@link Calendar#getMinimalDaysInFirstWeek() getMinimalDaysInFirstWeek},
    # and {@link Calendar#getTimeZone() getTimeZone} methods.
    # 
    # @param field the calendar field.
    # @return the highest minimum value for the given calendar field.
    # @see #getMinimum(int)
    # @see #getMaximum(int)
    # @see #getLeastMaximum(int)
    # @see #getActualMinimum(int)
    # @see #getActualMaximum(int)
    def get_greatest_minimum(field)
      return (field).equal?(YEAR) ? 1 : MIN_VALUES[field]
    end
    
    typesig { [::Java::Int] }
    # Returns the lowest maximum value for the given calendar field
    # of this <code>GregorianCalendar</code> instance. The lowest
    # maximum value is defined as the smallest value returned by
    # {@link #getActualMaximum(int)} for any possible time value,
    # taking into consideration the current values of the
    # {@link Calendar#getFirstDayOfWeek() getFirstDayOfWeek},
    # {@link Calendar#getMinimalDaysInFirstWeek() getMinimalDaysInFirstWeek},
    # and {@link Calendar#getTimeZone() getTimeZone} methods.
    # 
    # @param field the calendar field
    # @return the lowest maximum value for the given calendar field.
    # @see #getMinimum(int)
    # @see #getMaximum(int)
    # @see #getGreatestMinimum(int)
    # @see #getActualMinimum(int)
    # @see #getActualMaximum(int)
    def get_least_maximum(field)
      case (field)
      when YEAR
        return Math.min(LEAST_MAX_VALUES[YEAR], get_maximum(YEAR))
      end
      return LEAST_MAX_VALUES[field]
    end
    
    typesig { [::Java::Int] }
    # Returns the minimum value that this calendar field could have,
    # taking into consideration the given time value and the current
    # values of the
    # {@link Calendar#getFirstDayOfWeek() getFirstDayOfWeek},
    # {@link Calendar#getMinimalDaysInFirstWeek() getMinimalDaysInFirstWeek},
    # and {@link Calendar#getTimeZone() getTimeZone} methods.
    # 
    # @param field the calendar field
    # @return the minimum of the given field for the time value of
    # this <code>JapaneseImperialCalendar</code>
    # @see #getMinimum(int)
    # @see #getMaximum(int)
    # @see #getGreatestMinimum(int)
    # @see #getLeastMaximum(int)
    # @see #getActualMaximum(int)
    def get_actual_minimum(field)
      if (!is_field_set(YEAR_MASK | MONTH_MASK | WEEK_OF_YEAR_MASK, field))
        return get_minimum(field)
      end
      value = 0
      jc = get_normalized_calendar
      # Get a local date which includes time of day and time zone,
      # which are missing in jc.jdate.
      jd = Jcal.get_calendar_date(jc.get_time_in_millis, get_zone)
      era_index = get_era_index(jd)
      case (field)
      when YEAR
        if (era_index > BEFORE_MEIJI)
          value = 1
          since = Eras[era_index].get_since(get_zone)
          d = Jcal.get_calendar_date(since, get_zone)
          # Use the same year in jd to take care of leap
          # years. i.e., both jd and d must agree on leap
          # or common years.
          jd.set_year(d.get_year)
          Jcal.normalize(jd)
          raise AssertError if not ((jd.is_leap_year).equal?(d.is_leap_year))
          if (get_year_offset_in_millis(jd) < get_year_offset_in_millis(d))
            value += 1
          end
        else
          value = get_minimum(field)
          d = Jcal.get_calendar_date(Long::MIN_VALUE, get_zone)
          # Use an equvalent year of d.getYear() if
          # possible. Otherwise, ignore the leap year and
          # common year difference.
          y = d.get_year
          if (y > 400)
            y -= 400
          end
          jd.set_year(y)
          Jcal.normalize(jd)
          if (get_year_offset_in_millis(jd) < get_year_offset_in_millis(d))
            value += 1
          end
        end
      when MONTH
        # In Before Meiji and Meiji, January is the first month.
        if (era_index > MEIJI && (jd.get_year).equal?(1))
          since = Eras[era_index].get_since(get_zone)
          d = Jcal.get_calendar_date(since, get_zone)
          value = d.get_month - 1
          if (jd.get_day_of_month < d.get_day_of_month)
            value += 1
          end
        end
      when WEEK_OF_YEAR
        value = 1
        d = Jcal.get_calendar_date(Long::MIN_VALUE, get_zone)
        # shift 400 years to avoid underflow
        d.add_year(+400)
        Jcal.normalize(d)
        jd.set_era(d.get_era)
        jd.set_year(d.get_year)
        Jcal.normalize(jd)
        jan1 = Jcal.get_fixed_date(d)
        fd = Jcal.get_fixed_date(jd)
        woy = get_week_number(jan1, fd)
        day1 = fd - (7 * (woy - 1))
        if ((day1 < jan1) || ((day1).equal?(jan1) && jd.get_time_of_day < d.get_time_of_day))
          value += 1
        end
      end
      return value
    end
    
    typesig { [::Java::Int] }
    # Returns the maximum value that this calendar field could have,
    # taking into consideration the given time value and the current
    # values of the
    # {@link Calendar#getFirstDayOfWeek() getFirstDayOfWeek},
    # {@link Calendar#getMinimalDaysInFirstWeek() getMinimalDaysInFirstWeek},
    # and
    # {@link Calendar#getTimeZone() getTimeZone} methods.
    # For example, if the date of this instance is Heisei 16February 1,
    # the actual maximum value of the <code>DAY_OF_MONTH</code> field
    # is 29 because Heisei 16 is a leap year, and if the date of this
    # instance is Heisei 17 February 1, it's 28.
    # 
    # @param field the calendar field
    # @return the maximum of the given field for the time value of
    # this <code>JapaneseImperialCalendar</code>
    # @see #getMinimum(int)
    # @see #getMaximum(int)
    # @see #getGreatestMinimum(int)
    # @see #getLeastMaximum(int)
    # @see #getActualMinimum(int)
    def get_actual_maximum(field)
      fields_for_fixed_max = ERA_MASK | DAY_OF_WEEK_MASK | HOUR_MASK | AM_PM_MASK | HOUR_OF_DAY_MASK | MINUTE_MASK | SECOND_MASK | MILLISECOND_MASK | ZONE_OFFSET_MASK | DST_OFFSET_MASK
      if (!((fields_for_fixed_max & (1 << field))).equal?(0))
        return get_maximum(field)
      end
      jc = get_normalized_calendar
      date = jc.attr_jdate
      normalized_year = date.get_normalized_year
      value = -1
      catch(:break_case) do
        case (field)
        when MONTH
          value = DECEMBER
          if (is_transition_year(date.get_normalized_year))
            # TODO: there may be multiple transitions in a year.
            era_index = get_era_index(date)
            if (!(date.get_year).equal?(1))
              era_index += 1
              raise AssertError if not (era_index < Eras.attr_length)
            end
            transition = SinceFixedDates[era_index]
            fd = jc.attr_cached_fixed_date
            if (fd < transition)
              ldate = date.clone
              Jcal.get_calendar_date_from_fixed_date(ldate, transition - 1)
              value = ldate.get_month - 1
            end
          else
            d = Jcal.get_calendar_date(Long::MAX_VALUE, get_zone)
            if ((date.get_era).equal?(d.get_era) && (date.get_year).equal?(d.get_year))
              value = d.get_month - 1
            end
          end
        when DAY_OF_MONTH
          value = Jcal.get_month_length(date)
        when DAY_OF_YEAR
          if (is_transition_year(date.get_normalized_year))
            # Handle transition year.
            # TODO: there may be multiple transitions in a year.
            era_index = get_era_index(date)
            if (!(date.get_year).equal?(1))
              era_index += 1
              raise AssertError if not (era_index < Eras.attr_length)
            end
            transition = SinceFixedDates[era_index]
            fd = jc.attr_cached_fixed_date
            d = Gcal.new_calendar_date(TimeZone::NO_TIMEZONE)
            d.set_date(date.get_normalized_year, BaseCalendar::JANUARY, 1)
            if (fd < transition)
              value = RJava.cast_to_int((transition - Gcal.get_fixed_date(d)))
            else
              d.add_year(+1)
              value = RJava.cast_to_int((Gcal.get_fixed_date(d) - transition))
            end
          else
            d = Jcal.get_calendar_date(Long::MAX_VALUE, get_zone)
            if ((date.get_era).equal?(d.get_era) && (date.get_year).equal?(d.get_year))
              fd = Jcal.get_fixed_date(d)
              jan1 = get_fixed_date_jan1(d, fd)
              value = RJava.cast_to_int((fd - jan1)) + 1
            else
              if ((date.get_year).equal?(get_minimum(YEAR)))
                d1 = Jcal.get_calendar_date(Long::MIN_VALUE, get_zone)
                fd1 = Jcal.get_fixed_date(d1)
                d1.add_year(1)
                d1.set_month(BaseCalendar::JANUARY).set_day_of_month(1)
                Jcal.normalize(d1)
                fd2 = Jcal.get_fixed_date(d1)
                value = RJava.cast_to_int((fd2 - fd1))
              else
                value = Jcal.get_year_length(date)
              end
            end
          end
        when WEEK_OF_YEAR
          if (!is_transition_year(date.get_normalized_year))
            jd = Jcal.get_calendar_date(Long::MAX_VALUE, get_zone)
            if ((date.get_era).equal?(jd.get_era) && (date.get_year).equal?(jd.get_year))
              fd = Jcal.get_fixed_date(jd)
              jan1 = get_fixed_date_jan1(jd, fd)
              value = get_week_number(jan1, fd)
            else
              if ((date.get_era).nil? && (date.get_year).equal?(get_minimum(YEAR)))
                d = Jcal.get_calendar_date(Long::MIN_VALUE, get_zone)
                # shift 400 years to avoid underflow
                d.add_year(+400)
                Jcal.normalize(d)
                jd.set_era(d.get_era)
                jd.set_date(d.get_year + 1, BaseCalendar::JANUARY, 1)
                Jcal.normalize(jd)
                jan1 = Jcal.get_fixed_date(d)
                next_jan1 = Jcal.get_fixed_date(jd)
                next_jan1st = Jcal.get_day_of_week_date_on_or_before(next_jan1 + 6, get_first_day_of_week)
                ndays = RJava.cast_to_int((next_jan1st - next_jan1))
                if (ndays >= get_minimal_days_in_first_week)
                  next_jan1st -= 7
                end
                value = get_week_number(jan1, next_jan1st)
              else
                # Get the day of week of January 1 of the year
                d = Gcal.new_calendar_date(TimeZone::NO_TIMEZONE)
                d.set_date(date.get_normalized_year, BaseCalendar::JANUARY, 1)
                day_of_week = Gcal.get_day_of_week(d)
                # Normalize the day of week with the firstDayOfWeek value
                day_of_week -= get_first_day_of_week
                if (day_of_week < 0)
                  day_of_week += 7
                end
                value = 52
                magic = day_of_week + get_minimal_days_in_first_week - 1
                if (((magic).equal?(6)) || (date.is_leap_year && ((magic).equal?(5) || (magic).equal?(12))))
                  value += 1
                end
              end
            end
            throw :break_case, :thrown
          end
          if ((jc).equal?(self))
            jc = jc.clone
          end
          max_ = get_actual_maximum(DAY_OF_YEAR)
          jc.set(DAY_OF_YEAR, max_)
          value = jc.get(WEEK_OF_YEAR)
          if ((value).equal?(1) && max_ > 7)
            jc.add(WEEK_OF_YEAR, -1)
            value = jc.get(WEEK_OF_YEAR)
          end
        when WEEK_OF_MONTH
          jd = Jcal.get_calendar_date(Long::MAX_VALUE, get_zone)
          if (!((date.get_era).equal?(jd.get_era) && (date.get_year).equal?(jd.get_year)))
            d = Gcal.new_calendar_date(TimeZone::NO_TIMEZONE)
            d.set_date(date.get_normalized_year, date.get_month, 1)
            day_of_week = Gcal.get_day_of_week(d)
            month_length_ = Gcal.get_month_length(d)
            day_of_week -= get_first_day_of_week
            if (day_of_week < 0)
              day_of_week += 7
            end
            n_days_first_week = 7 - day_of_week # # of days in the first week
            value = 3
            if (n_days_first_week >= get_minimal_days_in_first_week)
              value += 1
            end
            month_length_ -= n_days_first_week + 7 * 3
            if (month_length_ > 0)
              value += 1
              if (month_length_ > 7)
                value += 1
              end
            end
          else
            fd = Jcal.get_fixed_date(jd)
            month1 = fd - jd.get_day_of_month + 1
            value = get_week_number(month1, fd)
          end
        when DAY_OF_WEEK_IN_MONTH
          ndays = 0
          dow1 = 0
          dow = date.get_day_of_week
          d = date.clone
          ndays = Jcal.get_month_length(d)
          d.set_day_of_month(1)
          Jcal.normalize(d)
          dow1 = d.get_day_of_week
          x = dow - dow1
          if (x < 0)
            x += 7
          end
          ndays -= x
          value = (ndays + 6) / 7
        when YEAR
          jd = Jcal.get_calendar_date(jc.get_time_in_millis, get_zone)
          d = nil
          era_index = get_era_index(date)
          if ((era_index).equal?(Eras.attr_length - 1))
            d = Jcal.get_calendar_date(Long::MAX_VALUE, get_zone)
            value = d.get_year
            # Use an equivalent year for the
            # getYearOffsetInMillis call to avoid overflow.
            if (value > 400)
              jd.set_year(value - 400)
            end
          else
            d = Jcal.get_calendar_date(Eras[era_index + 1].get_since(get_zone) - 1, get_zone)
            value = d.get_year
            # Use the same year as d.getYear() to be
            # consistent with leap and common years.
            jd.set_year(value)
          end
          Jcal.normalize(jd)
          if (get_year_offset_in_millis(jd) > get_year_offset_in_millis(d))
            value -= 1
          end
        else
          raise ArrayIndexOutOfBoundsException.new(field)
        end
      end
      return value
    end
    
    typesig { [CalendarDate] }
    # Returns the millisecond offset from the beginning of the
    # year. In the year for Long.MIN_VALUE, it's a pseudo value
    # beyond the limit. The given CalendarDate object must have been
    # normalized before calling this method.
    def get_year_offset_in_millis(date)
      t = (Jcal.get_day_of_year(date) - 1) * ONE_DAY
      return t + date.get_time_of_day - date.get_zone_offset
    end
    
    typesig { [] }
    def clone
      other = super
      other.attr_jdate = @jdate.clone
      other.attr_original_fields = nil
      other.attr_zone_offsets = nil
      return other
    end
    
    typesig { [] }
    def get_time_zone
      zone = super
      # To share the zone by the CalendarDate
      @jdate.set_zone(zone)
      return zone
    end
    
    typesig { [TimeZone] }
    def set_time_zone(zone)
      super(zone)
      # To share the zone by the CalendarDate
      @jdate.set_zone(zone)
    end
    
    # The fixed date corresponding to jdate. If the value is
    # Long.MIN_VALUE, the fixed date value is unknown.
    attr_accessor :cached_fixed_date
    alias_method :attr_cached_fixed_date, :cached_fixed_date
    undef_method :cached_fixed_date
    alias_method :attr_cached_fixed_date=, :cached_fixed_date=
    undef_method :cached_fixed_date=
    
    typesig { [] }
    # Converts the time value (millisecond offset from the <a
    # href="Calendar.html#Epoch">Epoch</a>) to calendar field values.
    # The time is <em>not</em>
    # recomputed first; to recompute the time, then the fields, call the
    # <code>complete</code> method.
    # 
    # @see Calendar#complete
    def compute_fields
      mask = 0
      if (is_partially_normalized)
        # Determine which calendar fields need to be computed.
        mask = get_set_state_fields
        field_mask = ~mask & ALL_FIELDS
        if (!(field_mask).equal?(0) || (@cached_fixed_date).equal?(Long::MIN_VALUE))
          mask |= compute_fields(field_mask, mask & (ZONE_OFFSET_MASK | DST_OFFSET_MASK))
          raise AssertError if not ((mask).equal?(ALL_FIELDS))
        end
      else
        # Specify all fields
        mask = ALL_FIELDS
        compute_fields(mask, 0)
      end
      # After computing all the fields, set the field state to `COMPUTED'.
      set_fields_computed(mask)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # This computeFields implements the conversion from UTC
    # (millisecond offset from the Epoch) to calendar
    # field values. fieldMask specifies which fields to change the
    # setting state to COMPUTED, although all fields are set to
    # the correct values. This is required to fix 4685354.
    # 
    # @param fieldMask a bit mask to specify which fields to change
    # the setting state.
    # @param tzMask a bit mask to specify which time zone offset
    # fields to be used for time calculations
    # @return a new field mask that indicates what field values have
    # actually been set.
    def compute_fields(field_mask, tz_mask)
      zone_offset = 0
      tz = get_zone
      if ((@zone_offsets).nil?)
        @zone_offsets = Array.typed(::Java::Int).new(2) { 0 }
      end
      if (!(tz_mask).equal?((ZONE_OFFSET_MASK | DST_OFFSET_MASK)))
        if (tz.is_a?(ZoneInfo))
          zone_offset = (tz).get_offsets(self.attr_time, @zone_offsets)
        else
          zone_offset = tz.get_offset(self.attr_time)
          @zone_offsets[0] = tz.get_raw_offset
          @zone_offsets[1] = zone_offset - @zone_offsets[0]
        end
      end
      if (!(tz_mask).equal?(0))
        if (is_field_set(tz_mask, ZONE_OFFSET))
          @zone_offsets[0] = internal_get(ZONE_OFFSET)
        end
        if (is_field_set(tz_mask, DST_OFFSET))
          @zone_offsets[1] = internal_get(DST_OFFSET)
        end
        zone_offset = @zone_offsets[0] + @zone_offsets[1]
      end
      # By computing time and zoneOffset separately, we can take
      # the wider range of time+zoneOffset than the previous
      # implementation.
      fixed_date = zone_offset / ONE_DAY
      time_of_day = zone_offset % RJava.cast_to_int(ONE_DAY)
      fixed_date += self.attr_time / ONE_DAY
      time_of_day += RJava.cast_to_int((self.attr_time % ONE_DAY))
      if (time_of_day >= ONE_DAY)
        time_of_day -= ONE_DAY
        (fixed_date += 1)
      else
        while (time_of_day < 0)
          time_of_day += ONE_DAY
          (fixed_date -= 1)
        end
      end
      fixed_date += EPOCH_OFFSET
      # See if we can use jdate to avoid date calculation.
      if (!(fixed_date).equal?(@cached_fixed_date) || fixed_date < 0)
        Jcal.get_calendar_date_from_fixed_date(@jdate, fixed_date)
        @cached_fixed_date = fixed_date
      end
      era = get_era_index(@jdate)
      year = @jdate.get_year
      # Always set the ERA and YEAR values.
      internal_set(ERA, era)
      internal_set(YEAR, year)
      mask = field_mask | (ERA_MASK | YEAR_MASK)
      month = @jdate.get_month - 1 # 0-based
      day_of_month = @jdate.get_day_of_month
      # Set the basic date fields.
      if (!((field_mask & (MONTH_MASK | DAY_OF_MONTH_MASK | DAY_OF_WEEK_MASK))).equal?(0))
        internal_set(MONTH, month)
        internal_set(DAY_OF_MONTH, day_of_month)
        internal_set(DAY_OF_WEEK, @jdate.get_day_of_week)
        mask |= MONTH_MASK | DAY_OF_MONTH_MASK | DAY_OF_WEEK_MASK
      end
      if (!((field_mask & (HOUR_OF_DAY_MASK | AM_PM_MASK | HOUR_MASK | MINUTE_MASK | SECOND_MASK | MILLISECOND_MASK))).equal?(0))
        if (!(time_of_day).equal?(0))
          hours = time_of_day / ONE_HOUR
          internal_set(HOUR_OF_DAY, hours)
          internal_set(AM_PM, hours / 12) # Assume AM == 0
          internal_set(HOUR, hours % 12)
          r = time_of_day % ONE_HOUR
          internal_set(MINUTE, r / ONE_MINUTE)
          r %= ONE_MINUTE
          internal_set(SECOND, r / ONE_SECOND)
          internal_set(MILLISECOND, r % ONE_SECOND)
        else
          internal_set(HOUR_OF_DAY, 0)
          internal_set(AM_PM, AM)
          internal_set(HOUR, 0)
          internal_set(MINUTE, 0)
          internal_set(SECOND, 0)
          internal_set(MILLISECOND, 0)
        end
        mask |= (HOUR_OF_DAY_MASK | AM_PM_MASK | HOUR_MASK | MINUTE_MASK | SECOND_MASK | MILLISECOND_MASK)
      end
      if (!((field_mask & (ZONE_OFFSET_MASK | DST_OFFSET_MASK))).equal?(0))
        internal_set(ZONE_OFFSET, @zone_offsets[0])
        internal_set(DST_OFFSET, @zone_offsets[1])
        mask |= (ZONE_OFFSET_MASK | DST_OFFSET_MASK)
      end
      if (!((field_mask & (DAY_OF_YEAR_MASK | WEEK_OF_YEAR_MASK | WEEK_OF_MONTH_MASK | DAY_OF_WEEK_IN_MONTH_MASK))).equal?(0))
        normalized_year = @jdate.get_normalized_year
        # If it's a year of an era transition, we need to handle
        # irregular year boundaries.
        transition_year = is_transition_year(@jdate.get_normalized_year)
        day_of_year = 0
        fixed_date_jan1 = 0
        if (transition_year)
          fixed_date_jan1 = get_fixed_date_jan1(@jdate, fixed_date)
          day_of_year = RJava.cast_to_int((fixed_date - fixed_date_jan1)) + 1
        else
          if ((normalized_year).equal?(MIN_VALUES[YEAR]))
            dx = Jcal.get_calendar_date(Long::MIN_VALUE, get_zone)
            fixed_date_jan1 = Jcal.get_fixed_date(dx)
            day_of_year = RJava.cast_to_int((fixed_date - fixed_date_jan1)) + 1
          else
            day_of_year = RJava.cast_to_int(Jcal.get_day_of_year(@jdate))
            fixed_date_jan1 = fixed_date - day_of_year + 1
          end
        end
        fixed_date_month1 = transition_year ? get_fixed_date_month1(@jdate, fixed_date) : fixed_date - day_of_month + 1
        internal_set(DAY_OF_YEAR, day_of_year)
        internal_set(DAY_OF_WEEK_IN_MONTH, (day_of_month - 1) / 7 + 1)
        week_of_year = get_week_number(fixed_date_jan1, fixed_date)
        # The spec is to calculate WEEK_OF_YEAR in the
        # ISO8601-style. This creates problems, though.
        if ((week_of_year).equal?(0))
          # If the date belongs to the last week of the
          # previous year, use the week number of "12/31" of
          # the "previous" year. Again, if the previous year is
          # a transition year, we need to take care of it.
          # Usually the previous day of the first day of a year
          # is December 31, which is not always true in the
          # Japanese imperial calendar system.
          fixed_dec31 = fixed_date_jan1 - 1
          prev_jan1 = 0
          d = get_calendar_date(fixed_dec31)
          if (!(transition_year || is_transition_year(d.get_normalized_year)))
            prev_jan1 = fixed_date_jan1 - 365
            if (d.is_leap_year)
              (prev_jan1 -= 1)
            end
          else
            if (transition_year)
              if ((@jdate.get_year).equal?(1))
                # As of Heisei (since Meiji) there's no case
                # that there are multiple transitions in a
                # year.  Historically there was such
                # case. There might be such case again in the
                # future.
                if (era > HEISEI)
                  pd = Eras[era - 1].get_since_date
                  if ((normalized_year).equal?(pd.get_year))
                    d.set_month(pd.get_month).set_day_of_month(pd.get_day_of_month)
                  end
                else
                  d.set_month(Jcal.attr_january).set_day_of_month(1)
                end
                Jcal.normalize(d)
                prev_jan1 = Jcal.get_fixed_date(d)
              else
                prev_jan1 = fixed_date_jan1 - 365
                if (d.is_leap_year)
                  (prev_jan1 -= 1)
                end
              end
            else
              cd = Eras[get_era_index(@jdate)].get_since_date
              d.set_month(cd.get_month).set_day_of_month(cd.get_day_of_month)
              Jcal.normalize(d)
              prev_jan1 = Jcal.get_fixed_date(d)
            end
          end
          week_of_year = get_week_number(prev_jan1, fixed_dec31)
        else
          if (!transition_year)
            # Regular years
            if (week_of_year >= 52)
              next_jan1 = fixed_date_jan1 + 365
              if (@jdate.is_leap_year)
                next_jan1 += 1
              end
              next_jan1st = Jcal.get_day_of_week_date_on_or_before(next_jan1 + 6, get_first_day_of_week)
              ndays = RJava.cast_to_int((next_jan1st - next_jan1))
              if (ndays >= get_minimal_days_in_first_week && fixed_date >= (next_jan1st - 7))
                # The first days forms a week in which the date is included.
                week_of_year = 1
              end
            end
          else
            d = @jdate.clone
            next_jan1 = 0
            if ((@jdate.get_year).equal?(1))
              d.add_year(+1)
              d.set_month(Jcal.attr_january).set_day_of_month(1)
              next_jan1 = Jcal.get_fixed_date(d)
            else
              next_era_index = get_era_index(d) + 1
              cd = Eras[next_era_index].get_since_date
              d.set_era(Eras[next_era_index])
              d.set_date(1, cd.get_month, cd.get_day_of_month)
              Jcal.normalize(d)
              next_jan1 = Jcal.get_fixed_date(d)
            end
            next_jan1st = Jcal.get_day_of_week_date_on_or_before(next_jan1 + 6, get_first_day_of_week)
            ndays = RJava.cast_to_int((next_jan1st - next_jan1))
            if (ndays >= get_minimal_days_in_first_week && fixed_date >= (next_jan1st - 7))
              # The first days forms a week in which the date is included.
              week_of_year = 1
            end
          end
        end
        internal_set(WEEK_OF_YEAR, week_of_year)
        internal_set(WEEK_OF_MONTH, get_week_number(fixed_date_month1, fixed_date))
        mask |= (DAY_OF_YEAR_MASK | WEEK_OF_YEAR_MASK | WEEK_OF_MONTH_MASK | DAY_OF_WEEK_IN_MONTH_MASK)
      end
      return mask
    end
    
    typesig { [::Java::Long, ::Java::Long] }
    # Returns the number of weeks in a period between fixedDay1 and
    # fixedDate. The getFirstDayOfWeek-getMinimalDaysInFirstWeek rule
    # is applied to calculate the number of weeks.
    # 
    # @param fixedDay1 the fixed date of the first day of the period
    # @param fixedDate the fixed date of the last day of the period
    # @return the number of weeks of the given period
    def get_week_number(fixed_day1, fixed_date)
      # We can always use `jcal' since Julian and Gregorian are the
      # same thing for this calculation.
      fixed_day1st = Jcal.get_day_of_week_date_on_or_before(fixed_day1 + 6, get_first_day_of_week)
      ndays = RJava.cast_to_int((fixed_day1st - fixed_day1))
      raise AssertError if not (ndays <= 7)
      if (ndays >= get_minimal_days_in_first_week)
        fixed_day1st -= 7
      end
      normalized_day_of_period = RJava.cast_to_int((fixed_date - fixed_day1st))
      if (normalized_day_of_period >= 0)
        return normalized_day_of_period / 7 + 1
      end
      return CalendarUtils.floor_divide(normalized_day_of_period, 7) + 1
    end
    
    typesig { [] }
    # Converts calendar field values to the time value (millisecond
    # offset from the <a href="Calendar.html#Epoch">Epoch</a>).
    # 
    # @exception IllegalArgumentException if any calendar fields are invalid.
    def compute_time
      # In non-lenient mode, perform brief checking of calendar
      # fields which have been set externally. Through this
      # checking, the field values are stored in originalFields[]
      # to see if any of them are normalized later.
      if (!is_lenient)
        if ((@original_fields).nil?)
          @original_fields = Array.typed(::Java::Int).new(FIELD_COUNT) { 0 }
        end
        field = 0
        while field < FIELD_COUNT
          value = internal_get(field)
          if (is_externally_set(field))
            # Quick validation for any out of range values
            if (value < get_minimum(field) || value > get_maximum(field))
              raise IllegalArgumentException.new(get_field_name(field))
            end
          end
          @original_fields[field] = value
          field += 1
        end
      end
      # Let the super class determine which calendar fields to be
      # used to calculate the time.
      field_mask = select_fields
      year = 0
      era = 0
      if (is_set(ERA))
        era = internal_get(ERA)
        year = is_set(YEAR) ? internal_get(YEAR) : 1
      else
        if (is_set(YEAR))
          era = Eras.attr_length - 1
          year = internal_get(YEAR)
        else
          # Equivalent to 1970 (Gregorian)
          era = SHOWA
          year = 45
        end
      end
      # Calculate the time of day. We rely on the convention that
      # an UNSET field has 0.
      time_of_day = 0
      if (is_field_set(field_mask, HOUR_OF_DAY))
        time_of_day += internal_get(HOUR_OF_DAY)
      else
        time_of_day += internal_get(HOUR)
        # The default value of AM_PM is 0 which designates AM.
        if (is_field_set(field_mask, AM_PM))
          time_of_day += 12 * internal_get(AM_PM)
        end
      end
      time_of_day *= 60
      time_of_day += internal_get(MINUTE)
      time_of_day *= 60
      time_of_day += internal_get(SECOND)
      time_of_day *= 1000
      time_of_day += internal_get(MILLISECOND)
      # Convert the time of day to the number of days and the
      # millisecond offset from midnight.
      fixed_date = time_of_day / ONE_DAY
      time_of_day %= ONE_DAY
      while (time_of_day < 0)
        time_of_day += ONE_DAY
        (fixed_date -= 1)
      end
      # Calculate the fixed date since January 1, 1 (Gregorian).
      fixed_date += get_fixed_date(era, year, field_mask)
      # millis represents local wall-clock time in milliseconds.
      millis = (fixed_date - EPOCH_OFFSET) * ONE_DAY + time_of_day
      # Compute the time zone offset and DST offset.  There are two potential
      # ambiguities here.  We'll assume a 2:00 am (wall time) switchover time
      # for discussion purposes here.
      # 1. The transition into DST.  Here, a designated time of 2:00 am - 2:59 am
      # can be in standard or in DST depending.  However, 2:00 am is an invalid
      # representation (the representation jumps from 1:59:59 am Std to 3:00:00 am DST).
      # We assume standard time.
      # 2. The transition out of DST.  Here, a designated time of 1:00 am - 1:59 am
      # can be in standard or DST.  Both are valid representations (the rep
      # jumps from 1:59:59 DST to 1:00:00 Std).
      # Again, we assume standard time.
      # We use the TimeZone object, unless the user has explicitly set the ZONE_OFFSET
      # or DST_OFFSET fields; then we use those fields.
      zone = get_zone
      if ((@zone_offsets).nil?)
        @zone_offsets = Array.typed(::Java::Int).new(2) { 0 }
      end
      tz_mask = field_mask & (ZONE_OFFSET_MASK | DST_OFFSET_MASK)
      if (!(tz_mask).equal?((ZONE_OFFSET_MASK | DST_OFFSET_MASK)))
        if (zone.is_a?(ZoneInfo))
          (zone).get_offsets_by_wall(millis, @zone_offsets)
        else
          zone.get_offsets(millis - zone.get_raw_offset, @zone_offsets)
        end
      end
      if (!(tz_mask).equal?(0))
        if (is_field_set(tz_mask, ZONE_OFFSET))
          @zone_offsets[0] = internal_get(ZONE_OFFSET)
        end
        if (is_field_set(tz_mask, DST_OFFSET))
          @zone_offsets[1] = internal_get(DST_OFFSET)
        end
      end
      # Adjust the time zone offset values to get the UTC time.
      millis -= @zone_offsets[0] + @zone_offsets[1]
      # Set this calendar's time in milliseconds
      self.attr_time = millis
      mask = compute_fields(field_mask | get_set_state_fields, tz_mask)
      if (!is_lenient)
        field = 0
        while field < FIELD_COUNT
          if (!is_externally_set(field))
            field += 1
            next
          end
          if (!(@original_fields[field]).equal?(internal_get(field)))
            wrong_value = internal_get(field)
            # Restore the original field values
            System.arraycopy(@original_fields, 0, self.attr_fields, 0, self.attr_fields.attr_length)
            raise IllegalArgumentException.new(RJava.cast_to_string(get_field_name(field)) + "=" + RJava.cast_to_string(wrong_value) + ", expected " + RJava.cast_to_string(@original_fields[field]))
          end
          field += 1
        end
      end
      set_fields_normalized(mask)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # Computes the fixed date under either the Gregorian or the
    # Julian calendar, using the given year and the specified calendar fields.
    # 
    # @param cal the CalendarSystem to be used for the date calculation
    # @param year the normalized year number, with 0 indicating the
    # year 1 BCE, -1 indicating 2 BCE, etc.
    # @param fieldMask the calendar fields to be used for the date calculation
    # @return the fixed date
    # @see Calendar#selectFields
    def get_fixed_date(era, year, field_mask)
      month = JANUARY
      first_day_of_month = 1
      if (is_field_set(field_mask, MONTH))
        # No need to check if MONTH has been set (no isSet(MONTH)
        # call) since its unset value happens to be JANUARY (0).
        month = internal_get(MONTH)
        # If the month is out of range, adjust it into range.
        if (month > DECEMBER)
          year += month / 12
          month %= 12
        else
          if (month < JANUARY)
            rem = Array.typed(::Java::Int).new(1) { 0 }
            year += CalendarUtils.floor_divide(month, 12, rem)
            month = rem[0]
          end
        end
      else
        if ((year).equal?(1) && !(era).equal?(0))
          d = Eras[era].get_since_date
          month = d.get_month - 1
          first_day_of_month = d.get_day_of_month
        end
      end
      # Adjust the base date if year is the minimum value.
      if ((year).equal?(MIN_VALUES[YEAR]))
        dx = Jcal.get_calendar_date(Long::MIN_VALUE, get_zone)
        m = dx.get_month - 1
        if (month < m)
          month = m
        end
        if ((month).equal?(m))
          first_day_of_month = dx.get_day_of_month
        end
      end
      date = Jcal.new_calendar_date(TimeZone::NO_TIMEZONE)
      date.set_era(era > 0 ? Eras[era] : nil)
      date.set_date(year, month + 1, first_day_of_month)
      Jcal.normalize(date)
      # Get the fixed date since Jan 1, 1 (Gregorian). We are on
      # the first day of either `month' or January in 'year'.
      fixed_date = Jcal.get_fixed_date(date)
      if (is_field_set(field_mask, MONTH))
        # Month-based calculations
        if (is_field_set(field_mask, DAY_OF_MONTH))
          # We are on the "first day" of the month (which may
          # not be 1). Just add the offset if DAY_OF_MONTH is
          # set. If the isSet call returns false, that means
          # DAY_OF_MONTH has been selected just because of the
          # selected combination. We don't need to add any
          # since the default value is the "first day".
          if (is_set(DAY_OF_MONTH))
            # To avoid underflow with DAY_OF_MONTH-firstDayOfMonth, add
            # DAY_OF_MONTH, then subtract firstDayOfMonth.
            fixed_date += internal_get(DAY_OF_MONTH)
            fixed_date -= first_day_of_month
          end
        else
          if (is_field_set(field_mask, WEEK_OF_MONTH))
            first_day_of_week = Jcal.get_day_of_week_date_on_or_before(fixed_date + 6, get_first_day_of_week)
            # If we have enough days in the first week, then
            # move to the previous week.
            if ((first_day_of_week - fixed_date) >= get_minimal_days_in_first_week)
              first_day_of_week -= 7
            end
            if (is_field_set(field_mask, DAY_OF_WEEK))
              first_day_of_week = Jcal.get_day_of_week_date_on_or_before(first_day_of_week + 6, internal_get(DAY_OF_WEEK))
            end
            # In lenient mode, we treat days of the previous
            # months as a part of the specified
            # WEEK_OF_MONTH. See 4633646.
            fixed_date = first_day_of_week + 7 * (internal_get(WEEK_OF_MONTH) - 1)
          else
            day_of_week = 0
            if (is_field_set(field_mask, DAY_OF_WEEK))
              day_of_week = internal_get(DAY_OF_WEEK)
            else
              day_of_week = get_first_day_of_week
            end
            # We are basing this on the day-of-week-in-month.  The only
            # trickiness occurs if the day-of-week-in-month is
            # negative.
            dowim = 0
            if (is_field_set(field_mask, DAY_OF_WEEK_IN_MONTH))
              dowim = internal_get(DAY_OF_WEEK_IN_MONTH)
            else
              dowim = 1
            end
            if (dowim >= 0)
              fixed_date = Jcal.get_day_of_week_date_on_or_before(fixed_date + (7 * dowim) - 1, day_of_week)
            else
              # Go to the first day of the next week of
              # the specified week boundary.
              last_date = month_length(month, year) + (7 * (dowim + 1))
              # Then, get the day of week date on or before the last date.
              fixed_date = Jcal.get_day_of_week_date_on_or_before(fixed_date + last_date - 1, day_of_week)
            end
          end
        end
      else
        # We are on the first day of the year.
        if (is_field_set(field_mask, DAY_OF_YEAR))
          if (is_transition_year(date.get_normalized_year))
            fixed_date = get_fixed_date_jan1(date, fixed_date)
          end
          # Add the offset, then subtract 1. (Make sure to avoid underflow.)
          fixed_date += internal_get(DAY_OF_YEAR)
          fixed_date -= 1
        else
          first_day_of_week = Jcal.get_day_of_week_date_on_or_before(fixed_date + 6, get_first_day_of_week)
          # If we have enough days in the first week, then move
          # to the previous week.
          if ((first_day_of_week - fixed_date) >= get_minimal_days_in_first_week)
            first_day_of_week -= 7
          end
          if (is_field_set(field_mask, DAY_OF_WEEK))
            day_of_week = internal_get(DAY_OF_WEEK)
            if (!(day_of_week).equal?(get_first_day_of_week))
              first_day_of_week = Jcal.get_day_of_week_date_on_or_before(first_day_of_week + 6, day_of_week)
            end
          end
          fixed_date = first_day_of_week + 7 * (internal_get(WEEK_OF_YEAR) - 1)
        end
      end
      return fixed_date
    end
    
    typesig { [LocalGregorianCalendar::Date, ::Java::Long] }
    # Returns the fixed date of the first day of the year (usually
    # January 1) before the specified date.
    # 
    # @param date the date for which the first day of the year is
    # calculated. The date has to be in the cut-over year.
    # @param fixedDate the fixed date representation of the date
    def get_fixed_date_jan1(date, fixed_date)
      era = date.get_era
      if (!(date.get_era).nil? && (date.get_year).equal?(1))
        era_index = get_era_index(date)
        while era_index > 0
          d = Eras[era_index].get_since_date
          fd = Gcal.get_fixed_date(d)
          # There might be multiple era transitions in a year.
          if (fd > fixed_date)
            era_index -= 1
            next
          end
          return fd
          era_index -= 1
        end
      end
      d = Gcal.new_calendar_date(TimeZone::NO_TIMEZONE)
      d.set_date(date.get_normalized_year, Gcal.attr_january, 1)
      return Gcal.get_fixed_date(d)
    end
    
    typesig { [LocalGregorianCalendar::Date, ::Java::Long] }
    # Returns the fixed date of the first date of the month (usually
    # the 1st of the month) before the specified date.
    # 
    # @param date the date for which the first day of the month is
    # calculated. The date must be in the era transition year.
    # @param fixedDate the fixed date representation of the date
    def get_fixed_date_month1(date, fixed_date)
      era_index = get_transition_era_index(date)
      if (!(era_index).equal?(-1))
        transition = SinceFixedDates[era_index]
        # If the given date is on or after the transition date, then
        # return the transition date.
        if (transition <= fixed_date)
          return transition
        end
      end
      # Otherwise, we can use the 1st day of the month.
      return fixed_date - date.get_day_of_month + 1
    end
    
    class_module.module_eval {
      typesig { [::Java::Long] }
      # Returns a LocalGregorianCalendar.Date produced from the specified fixed date.
      # 
      # @param fd the fixed date
      def get_calendar_date(fd)
        d = Jcal.new_calendar_date(TimeZone::NO_TIMEZONE)
        Jcal.get_calendar_date_from_fixed_date(d, fd)
        return d
      end
    }
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns the length of the specified month in the specified
    # Gregorian year. The year number must be normalized.
    # 
    # @see #isLeapYear(int)
    def month_length(month, gregorian_year)
      return CalendarUtils.is_gregorian_leap_year(gregorian_year) ? GregorianCalendar::LEAP_MONTH_LENGTH[month] : GregorianCalendar::MONTH_LENGTH[month]
    end
    
    typesig { [::Java::Int] }
    # Returns the length of the specified month in the year provided
    # by internalGet(YEAR).
    # 
    # @see #isLeapYear(int)
    def month_length(month)
      raise AssertError if not (@jdate.is_normalized)
      return @jdate.is_leap_year ? GregorianCalendar::LEAP_MONTH_LENGTH[month] : GregorianCalendar::MONTH_LENGTH[month]
    end
    
    typesig { [] }
    def actual_month_length
      length_ = Jcal.get_month_length(@jdate)
      era_index = get_transition_era_index(@jdate)
      if ((era_index).equal?(-1))
        transition_fixed_date = SinceFixedDates[era_index]
        d = Eras[era_index].get_since_date
        if (transition_fixed_date <= @cached_fixed_date)
          length_ -= d.get_day_of_month - 1
        else
          length_ = d.get_day_of_month - 1
        end
      end
      return length_
    end
    
    class_module.module_eval {
      typesig { [LocalGregorianCalendar::Date] }
      # Returns the index to the new era if the given date is in a
      # transition month.  For example, if the give date is Heisei 1
      # (1989) January 20, then the era index for Heisei is
      # returned. Likewise, if the given date is Showa 64 (1989)
      # January 3, then the era index for Heisei is returned. If the
      # given date is not in any transition month, then -1 is returned.
      def get_transition_era_index(date)
        era_index = get_era_index(date)
        transition_date = Eras[era_index].get_since_date
        if ((transition_date.get_year).equal?(date.get_normalized_year) && (transition_date.get_month).equal?(date.get_month))
          return era_index
        end
        if (era_index < Eras.attr_length - 1)
          transition_date = Eras[(era_index += 1)].get_since_date
          if ((transition_date.get_year).equal?(date.get_normalized_year) && (transition_date.get_month).equal?(date.get_month))
            return era_index
          end
        end
        return -1
      end
    }
    
    typesig { [::Java::Int] }
    def is_transition_year(normalized_year)
      i = Eras.attr_length - 1
      while i > 0
        transition_year = Eras[i].get_since_date.get_year
        if ((normalized_year).equal?(transition_year))
          return true
        end
        if (normalized_year > transition_year)
          break
        end
        i -= 1
      end
      return false
    end
    
    class_module.module_eval {
      typesig { [LocalGregorianCalendar::Date] }
      def get_era_index(date)
        era = date.get_era
        i = Eras.attr_length - 1
        while i > 0
          if ((Eras[i]).equal?(era))
            return i
          end
          i -= 1
        end
        return 0
      end
    }
    
    typesig { [] }
    # Returns this object if it's normalized (all fields and time are
    # in sync). Otherwise, a cloned object is returned after calling
    # complete() in lenient mode.
    def get_normalized_calendar
      jc = nil
      if (is_fully_normalized)
        jc = self
      else
        # Create a clone and normalize the calendar fields
        jc = self.clone
        jc.set_lenient(true)
        jc.complete
      end
      return jc
    end
    
    typesig { [LocalGregorianCalendar::Date] }
    # After adjustments such as add(MONTH), add(YEAR), we don't want the
    # month to jump around.  E.g., we don't want Jan 31 + 1 month to go to Mar
    # 3, we want it to go to Feb 28.  Adjustments which might run into this
    # problem call this method to retain the proper month.
    def pin_day_of_month(date)
      year = date.get_year
      dom = date.get_day_of_month
      if (!(year).equal?(get_minimum(YEAR)))
        date.set_day_of_month(1)
        Jcal.normalize(date)
        month_length_ = Jcal.get_month_length(date)
        if (dom > month_length_)
          date.set_day_of_month(month_length_)
        else
          date.set_day_of_month(dom)
        end
        Jcal.normalize(date)
      else
        d = Jcal.get_calendar_date(Long::MIN_VALUE, get_zone)
        real_date = Jcal.get_calendar_date(self.attr_time, get_zone)
        tod = real_date.get_time_of_day
        # Use an equivalent year.
        real_date.add_year(+400)
        real_date.set_month(date.get_month)
        real_date.set_day_of_month(1)
        Jcal.normalize(real_date)
        month_length_ = Jcal.get_month_length(real_date)
        if (dom > month_length_)
          real_date.set_day_of_month(month_length_)
        else
          if (dom < d.get_day_of_month)
            real_date.set_day_of_month(d.get_day_of_month)
          else
            real_date.set_day_of_month(dom)
          end
        end
        if ((real_date.get_day_of_month).equal?(d.get_day_of_month) && tod < d.get_time_of_day)
          real_date.set_day_of_month(Math.min(dom + 1, month_length_))
        end
        # restore the year.
        date.set_date(year, real_date.get_month, real_date.get_day_of_month)
        # Don't normalize date here so as not to cause underflow.
      end
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
      # Returns the new value after 'roll'ing the specified value and amount.
      def get_rolled_value(value, amount, min_, max_)
        raise AssertError if not (value >= min_ && value <= max_)
        range = max_ - min_ + 1
        amount %= range
        n = value + amount
        if (n > max_)
          n -= range
        else
          if (n < min_)
            n += range
          end
        end
        raise AssertError if not (n >= min_ && n <= max_)
        return n
      end
    }
    
    typesig { [] }
    # Returns the ERA.  We need a special method for this because the
    # default ERA is the current era, but a zero (unset) ERA means before Meiji.
    def internal_get_era
      return is_set(ERA) ? internal_get(ERA) : Eras.attr_length - 1
    end
    
    typesig { [ObjectInputStream] }
    # Updates internal state.
    def read_object(stream)
      stream.default_read_object
      if ((@jdate).nil?)
        @jdate = Jcal.new_calendar_date(get_zone)
        @cached_fixed_date = Long::MIN_VALUE
      end
    end
    
    private
    alias_method :initialize__japanese_imperial_calendar, :initialize
  end
  
end
