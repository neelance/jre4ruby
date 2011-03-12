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
  module AbstractCalendarImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util::Calendar
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :TimeZone
    }
  end
  
  # The <code>AbstractCalendar</code> class provides a framework for
  # implementing a concrete calendar system.
  # 
  # <p><a name="fixed_date"></a><B>Fixed Date</B><br>
  # 
  # For implementing a concrete calendar system, each calendar must
  # have the common date numbering, starting from midnight the onset of
  # Monday, January 1, 1 (Gregorian). It is called a <I>fixed date</I>
  # in this class. January 1, 1 (Gregorian) is fixed date 1. (See
  # Nachum Dershowitz and Edward M. Reingold, <I>CALENDRICAL
  # CALCULATION The Millennium Edition</I>, Section 1.2 for details.)
  # 
  # @author Masayoshi Okutsu
  # @since 1.5
  class AbstractCalendar < AbstractCalendarImports.const_get :CalendarSystem
    include_class_members AbstractCalendarImports
    
    class_module.module_eval {
      # The constants assume no leap seconds support.
      const_set_lazy(:SECOND_IN_MILLIS) { 1000 }
      const_attr_reader  :SECOND_IN_MILLIS
      
      const_set_lazy(:MINUTE_IN_MILLIS) { SECOND_IN_MILLIS * 60 }
      const_attr_reader  :MINUTE_IN_MILLIS
      
      const_set_lazy(:HOUR_IN_MILLIS) { MINUTE_IN_MILLIS * 60 }
      const_attr_reader  :HOUR_IN_MILLIS
      
      const_set_lazy(:DAY_IN_MILLIS) { HOUR_IN_MILLIS * 24 }
      const_attr_reader  :DAY_IN_MILLIS
      
      # The number of days between January 1, 1 and January 1, 1970 (Gregorian)
      const_set_lazy(:EPOCH_OFFSET) { 719163 }
      const_attr_reader  :EPOCH_OFFSET
    }
    
    attr_accessor :eras
    alias_method :attr_eras, :eras
    undef_method :eras
    alias_method :attr_eras=, :eras=
    undef_method :eras=
    
    typesig { [] }
    def initialize
      @eras = nil
      super()
    end
    
    typesig { [String] }
    def get_era(era_name)
      if (!(@eras).nil?)
        i = 0
        while i < @eras.attr_length
          if ((@eras[i] == era_name))
            return @eras[i]
          end
          i += 1
        end
      end
      return nil
    end
    
    typesig { [] }
    def get_eras
      e = nil
      if (!(@eras).nil?)
        e = Array.typed(Era).new(@eras.attr_length) { nil }
        System.arraycopy(@eras, 0, e, 0, @eras.attr_length)
      end
      return e
    end
    
    typesig { [CalendarDate, String] }
    def set_era(date, era_name)
      if ((@eras).nil?)
        return # should report an error???
      end
      i = 0
      while i < @eras.attr_length
        e = @eras[i]
        if (!(e).nil? && (e.get_name == era_name))
          date.set_era(e)
          return
        end
        i += 1
      end
      raise IllegalArgumentException.new("unknown era name: " + era_name)
    end
    
    typesig { [Array.typed(Era)] }
    def set_eras(eras)
      @eras = eras
    end
    
    typesig { [] }
    def get_calendar_date
      return get_calendar_date(System.current_time_millis, new_calendar_date)
    end
    
    typesig { [::Java::Long] }
    def get_calendar_date(millis)
      return get_calendar_date(millis, new_calendar_date)
    end
    
    typesig { [::Java::Long, TimeZone] }
    def get_calendar_date(millis, zone)
      date = new_calendar_date(zone)
      return get_calendar_date(millis, date)
    end
    
    typesig { [::Java::Long, CalendarDate] }
    def get_calendar_date(millis, date)
      ms = 0 # time of day
      zone_offset = 0
      saving = 0
      days = 0 # fixed date
      # adjust to local time if `date' has time zone.
      zi = date.get_zone
      if (!(zi).nil?)
        offsets = Array.typed(::Java::Int).new(2) { 0 }
        if (zi.is_a?(ZoneInfo))
          zone_offset = (zi).get_offsets(millis, offsets)
        else
          zone_offset = zi.get_offset(millis)
          offsets[0] = zi.get_raw_offset
          offsets[1] = zone_offset - offsets[0]
        end
        # We need to calculate the given millis and time zone
        # offset separately for java.util.GregorianCalendar
        # compatibility. (i.e., millis + zoneOffset could cause
        # overflow or underflow, which must be avoided.) Usually
        # days should be 0 and ms is in the range of -13:00 to
        # +14:00. However, we need to deal with extreme cases.
        days = zone_offset / DAY_IN_MILLIS
        ms = zone_offset % DAY_IN_MILLIS
        saving = offsets[1]
      end
      date.set_zone_offset(zone_offset)
      date.set_daylight_saving(saving)
      days += millis / DAY_IN_MILLIS
      ms += ((millis % DAY_IN_MILLIS)).to_int
      if (ms >= DAY_IN_MILLIS)
        # at most ms is (DAY_IN_MILLIS - 1) * 2.
        ms -= DAY_IN_MILLIS
        (days += 1)
      else
        # at most ms is (1 - DAY_IN_MILLIS) * 2. Adding one
        # DAY_IN_MILLIS results in still negative.
        while (ms < 0)
          ms += DAY_IN_MILLIS
          (days -= 1)
        end
      end
      # convert to fixed date (offset from Jan. 1, 1 (Gregorian))
      days += EPOCH_OFFSET
      # calculate date fields from the fixed date
      get_calendar_date_from_fixed_date(date, days)
      # calculate time fields from the time of day
      set_time_of_day(date, ms)
      date.set_leap_year(is_leap_year(date))
      date.set_normalized(true)
      return date
    end
    
    typesig { [CalendarDate] }
    def get_time(date)
      gd = get_fixed_date(date)
      ms = (gd - EPOCH_OFFSET) * DAY_IN_MILLIS + get_time_of_day(date)
      zone_offset = 0
      zi = date.get_zone
      if (!(zi).nil?)
        if (date.is_normalized)
          return ms - date.get_zone_offset
        end
        # adjust time zone and daylight saving
        offsets = Array.typed(::Java::Int).new(2) { 0 }
        if (date.is_standard_time)
          # 1) 2:30am during starting-DST transition is
          #    intrepreted as 2:30am ST
          # 2) 5:00pm during DST is still interpreted as 5:00pm ST
          # 3) 1:30am during ending-DST transition is interpreted
          #    as 1:30am ST (after transition)
          if (zi.is_a?(ZoneInfo))
            (zi).get_offsets_by_standard(ms, offsets)
            zone_offset = offsets[0]
          else
            zone_offset = zi.get_offset(ms - zi.get_raw_offset)
          end
        else
          # 1) 2:30am during starting-DST transition is
          #    intrepreted as 3:30am DT
          # 2) 5:00pm during DST is intrepreted as 5:00pm DT
          # 3) 1:30am during ending-DST transition is interpreted
          #    as 1:30am DT/0:30am ST (before transition)
          if (zi.is_a?(ZoneInfo))
            zone_offset = (zi).get_offsets_by_wall(ms, offsets)
          else
            zone_offset = zi.get_offset(ms - zi.get_raw_offset)
          end
        end
      end
      ms -= zone_offset
      get_calendar_date(ms, date)
      return ms
    end
    
    typesig { [CalendarDate] }
    def get_time_of_day(date)
      fraction = date.get_time_of_day
      if (!(fraction).equal?(CalendarDate::TIME_UNDEFINED))
        return fraction
      end
      fraction = get_time_of_day_value(date)
      date.set_time_of_day(fraction)
      return fraction
    end
    
    typesig { [CalendarDate] }
    def get_time_of_day_value(date)
      fraction = date.get_hours
      fraction *= 60
      fraction += date.get_minutes
      fraction *= 60
      fraction += date.get_seconds
      fraction *= 1000
      fraction += date.get_millis
      return fraction
    end
    
    typesig { [CalendarDate, ::Java::Int] }
    def set_time_of_day(cdate, fraction)
      if (fraction < 0)
        raise IllegalArgumentException.new
      end
      normalized_state = cdate.is_normalized
      time = fraction
      hours = time / HOUR_IN_MILLIS
      time %= HOUR_IN_MILLIS
      minutes = time / MINUTE_IN_MILLIS
      time %= MINUTE_IN_MILLIS
      seconds = time / SECOND_IN_MILLIS
      time %= SECOND_IN_MILLIS
      cdate.set_hours(hours)
      cdate.set_minutes(minutes)
      cdate.set_seconds(seconds)
      cdate.set_millis(time)
      cdate.set_time_of_day(fraction)
      if (hours < 24 && normalized_state)
        # If this time of day setting doesn't affect the date,
        # then restore the normalized state.
        cdate.set_normalized(normalized_state)
      end
      return cdate
    end
    
    typesig { [] }
    # Returns 7 in this default implementation.
    # 
    # @return 7
    def get_week_length
      return 7
    end
    
    typesig { [CalendarDate] }
    def is_leap_year(date)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Int, CalendarDate] }
    def get_nth_day_of_week(nth, day_of_week, date)
      ndate = date.clone
      normalize(ndate)
      fd = get_fixed_date(ndate)
      nfd = 0
      if (nth > 0)
        nfd = 7 * nth + get_day_of_week_date_before(fd, day_of_week)
      else
        nfd = 7 * nth + get_day_of_week_date_after(fd, day_of_week)
      end
      get_calendar_date_from_fixed_date(ndate, nfd)
      return ndate
    end
    
    class_module.module_eval {
      typesig { [::Java::Long, ::Java::Int] }
      # Returns a date of the given day of week before the given fixed
      # date.
      # 
      # @param fixedDate the fixed date
      # @param dayOfWeek the day of week
      # @return the calculated date
      def get_day_of_week_date_before(fixed_date, day_of_week)
        return get_day_of_week_date_on_or_before(fixed_date - 1, day_of_week)
      end
      
      typesig { [::Java::Long, ::Java::Int] }
      # Returns a date of the given day of week that is closest to and
      # after the given fixed date.
      # 
      # @param fixedDate the fixed date
      # @param dayOfWeek the day of week
      # @return the calculated date
      def get_day_of_week_date_after(fixed_date, day_of_week)
        return get_day_of_week_date_on_or_before(fixed_date + 7, day_of_week)
      end
      
      typesig { [::Java::Long, ::Java::Int] }
      # Returns a date of the given day of week on or before the given fixed
      # date.
      # 
      # @param fixedDate the fixed date
      # @param dayOfWeek the day of week
      # @return the calculated date
      # public for java.util.GregorianCalendar
      def get_day_of_week_date_on_or_before(fixed_date, day_of_week)
        fd = fixed_date - (day_of_week - 1)
        if (fd >= 0)
          return fixed_date - (fd % 7)
        end
        return fixed_date - CalendarUtils.mod(fd, 7)
      end
    }
    
    typesig { [CalendarDate] }
    # Returns the fixed date calculated with the specified calendar
    # date. If the specified date is not normalized, its date fields
    # are normalized.
    # 
    # @param date a <code>CalendarDate</code> with which the fixed
    # date is calculated
    # @return the calculated fixed date
    # @see AbstractCalendar.html#fixed_date
    def get_fixed_date(date)
      raise NotImplementedError
    end
    
    typesig { [CalendarDate, ::Java::Long] }
    # Calculates calendar fields from the specified fixed date. This
    # method stores the calculated calendar field values in the specified
    # <code>CalendarDate</code>.
    # 
    # @param date a <code>CalendarDate</code> to stored the
    # calculated calendar fields.
    # @param fixedDate a fixed date to calculate calendar fields
    # @see AbstractCalendar.html#fixed_date
    def get_calendar_date_from_fixed_date(date, fixed_date)
      raise NotImplementedError
    end
    
    typesig { [CalendarDate] }
    def validate_time(date)
      t = date.get_hours
      if (t < 0 || t >= 24)
        return false
      end
      t = date.get_minutes
      if (t < 0 || t >= 60)
        return false
      end
      t = date.get_seconds
      # TODO: Leap second support.
      if (t < 0 || t >= 60)
        return false
      end
      t = date.get_millis
      if (t < 0 || t >= 1000)
        return false
      end
      return true
    end
    
    typesig { [CalendarDate] }
    def normalize_time(date)
      fraction = get_time_of_day(date)
      days = 0
      if (fraction >= DAY_IN_MILLIS)
        days = fraction / DAY_IN_MILLIS
        fraction %= DAY_IN_MILLIS
      else
        if (fraction < 0)
          days = CalendarUtils.floor_divide(fraction, DAY_IN_MILLIS)
          if (!(days).equal?(0))
            fraction -= DAY_IN_MILLIS * days # mod(fraction, DAY_IN_MILLIS)
          end
        end
      end
      if (!(days).equal?(0))
        date.set_time_of_day(fraction)
      end
      date.set_millis(((fraction % 1000)).to_int)
      fraction /= 1000
      date.set_seconds(((fraction % 60)).to_int)
      fraction /= 60
      date.set_minutes(((fraction % 60)).to_int)
      date.set_hours(((fraction / 60)).to_int)
      return (days).to_int
    end
    
    private
    alias_method :initialize__abstract_calendar, :initialize
  end
  
end
