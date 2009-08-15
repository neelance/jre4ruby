require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util
  module SimpleTimeZoneImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Io, :ObjectOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Sun::Util::Calendar, :CalendarSystem
      include_const ::Sun::Util::Calendar, :CalendarUtils
      include_const ::Sun::Util::Calendar, :BaseCalendar
      include_const ::Sun::Util::Calendar, :Gregorian
    }
  end
  
  # <code>SimpleTimeZone</code> is a concrete subclass of <code>TimeZone</code>
  # that represents a time zone for use with a Gregorian calendar.
  # The class holds an offset from GMT, called <em>raw offset</em>, and start
  # and end rules for a daylight saving time schedule.  Since it only holds
  # single values for each, it cannot handle historical changes in the offset
  # from GMT and the daylight saving schedule, except that the {@link
  # #setStartYear setStartYear} method can specify the year when the daylight
  # saving time schedule starts in effect.
  # <p>
  # To construct a <code>SimpleTimeZone</code> with a daylight saving time
  # schedule, the schedule can be described with a set of rules,
  # <em>start-rule</em> and <em>end-rule</em>. A day when daylight saving time
  # starts or ends is specified by a combination of <em>month</em>,
  # <em>day-of-month</em>, and <em>day-of-week</em> values. The <em>month</em>
  # value is represented by a Calendar {@link Calendar#MONTH MONTH} field
  # value, such as {@link Calendar#MARCH}. The <em>day-of-week</em> value is
  # represented by a Calendar {@link Calendar#DAY_OF_WEEK DAY_OF_WEEK} value,
  # such as {@link Calendar#SUNDAY SUNDAY}. The meanings of value combinations
  # are as follows.
  # 
  # <ul>
  # <li><b>Exact day of month</b><br>
  # To specify an exact day of month, set the <em>month</em> and
  # <em>day-of-month</em> to an exact value, and <em>day-of-week</em> to zero. For
  # example, to specify March 1, set the <em>month</em> to {@link Calendar#MARCH
  # MARCH}, <em>day-of-month</em> to 1, and <em>day-of-week</em> to 0.</li>
  # 
  # <li><b>Day of week on or after day of month</b><br>
  # To specify a day of week on or after an exact day of month, set the
  # <em>month</em> to an exact month value, <em>day-of-month</em> to the day on
  # or after which the rule is applied, and <em>day-of-week</em> to a negative {@link
  # Calendar#DAY_OF_WEEK DAY_OF_WEEK} field value. For example, to specify the
  # second Sunday of April, set <em>month</em> to {@link Calendar#APRIL APRIL},
  # <em>day-of-month</em> to 8, and <em>day-of-week</em> to <code>-</code>{@link
  # Calendar#SUNDAY SUNDAY}.</li>
  # 
  # <li><b>Day of week on or before day of month</b><br>
  # To specify a day of the week on or before an exact day of the month, set
  # <em>day-of-month</em> and <em>day-of-week</em> to a negative value. For
  # example, to specify the last Wednesday on or before the 21st of March, set
  # <em>month</em> to {@link Calendar#MARCH MARCH}, <em>day-of-month</em> is -21
  # and <em>day-of-week</em> is <code>-</code>{@link Calendar#WEDNESDAY WEDNESDAY}. </li>
  # 
  # <li><b>Last day-of-week of month</b><br>
  # To specify, the last day-of-week of the month, set <em>day-of-week</em> to a
  # {@link Calendar#DAY_OF_WEEK DAY_OF_WEEK} value and <em>day-of-month</em> to
  # -1. For example, to specify the last Sunday of October, set <em>month</em>
  # to {@link Calendar#OCTOBER OCTOBER}, <em>day-of-week</em> to {@link
  # Calendar#SUNDAY SUNDAY} and <em>day-of-month</em> to -1.  </li>
  # 
  # </ul>
  # The time of the day at which daylight saving time starts or ends is
  # specified by a millisecond value within the day. There are three kinds of
  # <em>mode</em>s to specify the time: {@link #WALL_TIME}, {@link
  # #STANDARD_TIME} and {@link #UTC_TIME}. For example, if daylight
  # saving time ends
  # at 2:00 am in the wall clock time, it can be specified by 7200000
  # milliseconds in the {@link #WALL_TIME} mode. In this case, the wall clock time
  # for an <em>end-rule</em> means the same thing as the daylight time.
  # <p>
  # The following are examples of parameters for constructing time zone objects.
  # <pre><code>
  # // Base GMT offset: -8:00
  # // DST starts:      at 2:00am in standard time
  # //                  on the first Sunday in April
  # // DST ends:        at 2:00am in daylight time
  # //                  on the last Sunday in October
  # // Save:            1 hour
  # SimpleTimeZone(-28800000,
  # "America/Los_Angeles",
  # Calendar.APRIL, 1, -Calendar.SUNDAY,
  # 7200000,
  # Calendar.OCTOBER, -1, Calendar.SUNDAY,
  # 7200000,
  # 3600000)
  # 
  # // Base GMT offset: +1:00
  # // DST starts:      at 1:00am in UTC time
  # //                  on the last Sunday in March
  # // DST ends:        at 1:00am in UTC time
  # //                  on the last Sunday in October
  # // Save:            1 hour
  # SimpleTimeZone(3600000,
  # "Europe/Paris",
  # Calendar.MARCH, -1, Calendar.SUNDAY,
  # 3600000, SimpleTimeZone.UTC_TIME,
  # Calendar.OCTOBER, -1, Calendar.SUNDAY,
  # 3600000, SimpleTimeZone.UTC_TIME,
  # 3600000)
  # </code></pre>
  # These parameter rules are also applicable to the set rule methods, such as
  # <code>setStartRule</code>.
  # 
  # @since 1.1
  # @see      Calendar
  # @see      GregorianCalendar
  # @see      TimeZone
  # @author   David Goldsmith, Mark Davis, Chen-Lieh Huang, Alan Liu
  class SimpleTimeZone < SimpleTimeZoneImports.const_get :TimeZone
    include_class_members SimpleTimeZoneImports
    
    typesig { [::Java::Int, String] }
    # Constructs a SimpleTimeZone with the given base time zone offset from GMT
    # and time zone ID with no daylight saving time schedule.
    # 
    # @param rawOffset  The base time zone offset in milliseconds to GMT.
    # @param ID         The time zone name that is given to this instance.
    def initialize(raw_offset, id)
      @start_month = 0
      @start_day = 0
      @start_day_of_week = 0
      @start_time = 0
      @start_time_mode = 0
      @end_month = 0
      @end_day = 0
      @end_day_of_week = 0
      @end_time = 0
      @end_time_mode = 0
      @start_year = 0
      @raw_offset = 0
      @use_daylight = false
      @month_length = nil
      @start_mode = 0
      @end_mode = 0
      @dst_savings = 0
      @cache_year = 0
      @cache_start = 0
      @cache_end = 0
      @serial_version_on_stream = 0
      super()
      @use_daylight = false
      @month_length = StaticMonthLength
      @serial_version_on_stream = CurrentSerialVersion
      @raw_offset = raw_offset
      set_id(id)
      @dst_savings = MillisPerHour # In case user sets rules later
    end
    
    typesig { [::Java::Int, String, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Constructs a SimpleTimeZone with the given base time zone offset from
    # GMT, time zone ID, and rules for starting and ending the daylight
    # time.
    # Both <code>startTime</code> and <code>endTime</code> are specified to be
    # represented in the wall clock time. The amount of daylight saving is
    # assumed to be 3600000 milliseconds (i.e., one hour). This constructor is
    # equivalent to:
    # <pre><code>
    # SimpleTimeZone(rawOffset,
    # ID,
    # startMonth,
    # startDay,
    # startDayOfWeek,
    # startTime,
    # SimpleTimeZone.{@link #WALL_TIME},
    # endMonth,
    # endDay,
    # endDayOfWeek,
    # endTime,
    # SimpleTimeZone.{@link #WALL_TIME},
    # 3600000)
    # </code></pre>
    # 
    # @param rawOffset       The given base time zone offset from GMT.
    # @param ID              The time zone ID which is given to this object.
    # @param startMonth      The daylight saving time starting month. Month is
    # a {@link Calendar#MONTH MONTH} field value (0-based. e.g., 0
    # for January).
    # @param startDay        The day of the month on which the daylight saving time starts.
    # See the class description for the special cases of this parameter.
    # @param startDayOfWeek  The daylight saving time starting day-of-week.
    # See the class description for the special cases of this parameter.
    # @param startTime       The daylight saving time starting time in local wall clock
    # time (in milliseconds within the day), which is local
    # standard time in this case.
    # @param endMonth        The daylight saving time ending month. Month is
    # a {@link Calendar#MONTH MONTH} field
    # value (0-based. e.g., 9 for October).
    # @param endDay          The day of the month on which the daylight saving time ends.
    # See the class description for the special cases of this parameter.
    # @param endDayOfWeek    The daylight saving time ending day-of-week.
    # See the class description for the special cases of this parameter.
    # @param endTime         The daylight saving ending time in local wall clock time,
    # (in milliseconds within the day) which is local daylight
    # time in this case.
    # @exception IllegalArgumentException if the month, day, dayOfWeek, or time
    # parameters are out of range for the start or end rule
    def initialize(raw_offset, id, start_month, start_day, start_day_of_week, start_time, end_month, end_day, end_day_of_week, end_time)
      initialize__simple_time_zone(raw_offset, id, start_month, start_day, start_day_of_week, start_time, WALL_TIME, end_month, end_day, end_day_of_week, end_time, WALL_TIME, MillisPerHour)
    end
    
    typesig { [::Java::Int, String, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Constructs a SimpleTimeZone with the given base time zone offset from
    # GMT, time zone ID, and rules for starting and ending the daylight
    # time.
    # Both <code>startTime</code> and <code>endTime</code> are assumed to be
    # represented in the wall clock time. This constructor is equivalent to:
    # <pre><code>
    # SimpleTimeZone(rawOffset,
    # ID,
    # startMonth,
    # startDay,
    # startDayOfWeek,
    # startTime,
    # SimpleTimeZone.{@link #WALL_TIME},
    # endMonth,
    # endDay,
    # endDayOfWeek,
    # endTime,
    # SimpleTimeZone.{@link #WALL_TIME},
    # dstSavings)
    # </code></pre>
    # 
    # @param rawOffset       The given base time zone offset from GMT.
    # @param ID              The time zone ID which is given to this object.
    # @param startMonth      The daylight saving time starting month. Month is
    # a {@link Calendar#MONTH MONTH} field
    # value (0-based. e.g., 0 for January).
    # @param startDay        The day of the month on which the daylight saving time starts.
    # See the class description for the special cases of this parameter.
    # @param startDayOfWeek  The daylight saving time starting day-of-week.
    # See the class description for the special cases of this parameter.
    # @param startTime       The daylight saving time starting time in local wall clock
    # time, which is local standard time in this case.
    # @param endMonth        The daylight saving time ending month. Month is
    # a {@link Calendar#MONTH MONTH} field
    # value (0-based. e.g., 9 for October).
    # @param endDay          The day of the month on which the daylight saving time ends.
    # See the class description for the special cases of this parameter.
    # @param endDayOfWeek    The daylight saving time ending day-of-week.
    # See the class description for the special cases of this parameter.
    # @param endTime         The daylight saving ending time in local wall clock time,
    # which is local daylight time in this case.
    # @param dstSavings      The amount of time in milliseconds saved during
    # daylight saving time.
    # @exception IllegalArgumentException if the month, day, dayOfWeek, or time
    # parameters are out of range for the start or end rule
    # @since 1.2
    def initialize(raw_offset, id, start_month, start_day, start_day_of_week, start_time, end_month, end_day, end_day_of_week, end_time, dst_savings)
      initialize__simple_time_zone(raw_offset, id, start_month, start_day, start_day_of_week, start_time, WALL_TIME, end_month, end_day, end_day_of_week, end_time, WALL_TIME, dst_savings)
    end
    
    typesig { [::Java::Int, String, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Constructs a SimpleTimeZone with the given base time zone offset from
    # GMT, time zone ID, and rules for starting and ending the daylight
    # time.
    # This constructor takes the full set of the start and end rules
    # parameters, including modes of <code>startTime</code> and
    # <code>endTime</code>. The mode specifies either {@link #WALL_TIME wall
    # time} or {@link #STANDARD_TIME standard time} or {@link #UTC_TIME UTC
    # time}.
    # 
    # @param rawOffset       The given base time zone offset from GMT.
    # @param ID              The time zone ID which is given to this object.
    # @param startMonth      The daylight saving time starting month. Month is
    # a {@link Calendar#MONTH MONTH} field
    # value (0-based. e.g., 0 for January).
    # @param startDay        The day of the month on which the daylight saving time starts.
    # See the class description for the special cases of this parameter.
    # @param startDayOfWeek  The daylight saving time starting day-of-week.
    # See the class description for the special cases of this parameter.
    # @param startTime       The daylight saving time starting time in the time mode
    # specified by <code>startTimeMode</code>.
    # @param startTimeMode   The mode of the start time specified by startTime.
    # @param endMonth        The daylight saving time ending month. Month is
    # a {@link Calendar#MONTH MONTH} field
    # value (0-based. e.g., 9 for October).
    # @param endDay          The day of the month on which the daylight saving time ends.
    # See the class description for the special cases of this parameter.
    # @param endDayOfWeek    The daylight saving time ending day-of-week.
    # See the class description for the special cases of this parameter.
    # @param endTime         The daylight saving ending time in time time mode
    # specified by <code>endTimeMode</code>.
    # @param endTimeMode     The mode of the end time specified by endTime
    # @param dstSavings      The amount of time in milliseconds saved during
    # daylight saving time.
    # 
    # @exception IllegalArgumentException if the month, day, dayOfWeek, time more, or
    # time parameters are out of range for the start or end rule, or if a time mode
    # value is invalid.
    # 
    # @see #WALL_TIME
    # @see #STANDARD_TIME
    # @see #UTC_TIME
    # 
    # @since 1.4
    def initialize(raw_offset, id, start_month, start_day, start_day_of_week, start_time, start_time_mode, end_month, end_day, end_day_of_week, end_time, end_time_mode, dst_savings)
      @start_month = 0
      @start_day = 0
      @start_day_of_week = 0
      @start_time = 0
      @start_time_mode = 0
      @end_month = 0
      @end_day = 0
      @end_day_of_week = 0
      @end_time = 0
      @end_time_mode = 0
      @start_year = 0
      @raw_offset = 0
      @use_daylight = false
      @month_length = nil
      @start_mode = 0
      @end_mode = 0
      @dst_savings = 0
      @cache_year = 0
      @cache_start = 0
      @cache_end = 0
      @serial_version_on_stream = 0
      super()
      @use_daylight = false
      @month_length = StaticMonthLength
      @serial_version_on_stream = CurrentSerialVersion
      set_id(id)
      @raw_offset = raw_offset
      @start_month = start_month
      @start_day = start_day
      @start_day_of_week = start_day_of_week
      @start_time = start_time
      @start_time_mode = start_time_mode
      @end_month = end_month
      @end_day = end_day
      @end_day_of_week = end_day_of_week
      @end_time = end_time
      @end_time_mode = end_time_mode
      @dst_savings = dst_savings
      # this.useDaylight is set by decodeRules
      decode_rules
      if (dst_savings <= 0)
        raise IllegalArgumentException.new("Illegal daylight saving value: " + RJava.cast_to_string(dst_savings))
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the daylight saving time starting year.
    # 
    # @param year  The daylight saving starting year.
    def set_start_year(year)
      @start_year = year
      invalidate_cache
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Sets the daylight saving time start rule. For example, if daylight saving
    # time starts on the first Sunday in April at 2 am in local wall clock
    # time, you can set the start rule by calling:
    # <pre><code>setStartRule(Calendar.APRIL, 1, Calendar.SUNDAY, 2*60*60*1000);</code></pre>
    # 
    # @param startMonth      The daylight saving time starting month. Month is
    # a {@link Calendar#MONTH MONTH} field
    # value (0-based. e.g., 0 for January).
    # @param startDay        The day of the month on which the daylight saving time starts.
    # See the class description for the special cases of this parameter.
    # @param startDayOfWeek  The daylight saving time starting day-of-week.
    # See the class description for the special cases of this parameter.
    # @param startTime       The daylight saving time starting time in local wall clock
    # time, which is local standard time in this case.
    # @exception IllegalArgumentException if the <code>startMonth</code>, <code>startDay</code>,
    # <code>startDayOfWeek</code>, or <code>startTime</code> parameters are out of range
    def set_start_rule(start_month, start_day, start_day_of_week, start_time)
      @start_month = start_month
      @start_day = start_day
      @start_day_of_week = start_day_of_week
      @start_time = start_time
      @start_time_mode = WALL_TIME
      decode_start_rule
      invalidate_cache
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # Sets the daylight saving time start rule to a fixed date within a month.
    # This method is equivalent to:
    # <pre><code>setStartRule(startMonth, startDay, 0, startTime)</code></pre>
    # 
    # @param startMonth      The daylight saving time starting month. Month is
    # a {@link Calendar#MONTH MONTH} field
    # value (0-based. e.g., 0 for January).
    # @param startDay        The day of the month on which the daylight saving time starts.
    # @param startTime       The daylight saving time starting time in local wall clock
    # time, which is local standard time in this case.
    # See the class description for the special cases of this parameter.
    # @exception IllegalArgumentException if the <code>startMonth</code>,
    # <code>startDayOfMonth</code>, or <code>startTime</code> parameters are out of range
    # @since 1.2
    def set_start_rule(start_month, start_day, start_time)
      set_start_rule(start_month, start_day, 0, start_time)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Boolean] }
    # Sets the daylight saving time start rule to a weekday before or after the given date within
    # a month, e.g., the first Monday on or after the 8th.
    # 
    # @param startMonth      The daylight saving time starting month. Month is
    # a {@link Calendar#MONTH MONTH} field
    # value (0-based. e.g., 0 for January).
    # @param startDay        The day of the month on which the daylight saving time starts.
    # @param startDayOfWeek  The daylight saving time starting day-of-week.
    # @param startTime       The daylight saving time starting time in local wall clock
    # time, which is local standard time in this case.
    # @param after           If true, this rule selects the first <code>dayOfWeek</code> on or
    # <em>after</em> <code>dayOfMonth</code>.  If false, this rule
    # selects the last <code>dayOfWeek</code> on or <em>before</em>
    # <code>dayOfMonth</code>.
    # @exception IllegalArgumentException if the <code>startMonth</code>, <code>startDay</code>,
    # <code>startDayOfWeek</code>, or <code>startTime</code> parameters are out of range
    # @since 1.2
    def set_start_rule(start_month, start_day, start_day_of_week, start_time, after)
      # TODO: this method doesn't check the initial values of dayOfMonth or dayOfWeek.
      if (after)
        set_start_rule(start_month, start_day, -start_day_of_week, start_time)
      else
        set_start_rule(start_month, -start_day, -start_day_of_week, start_time)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Sets the daylight saving time end rule. For example, if daylight saving time
    # ends on the last Sunday in October at 2 am in wall clock time,
    # you can set the end rule by calling:
    # <code>setEndRule(Calendar.OCTOBER, -1, Calendar.SUNDAY, 2*60*60*1000);</code>
    # 
    # @param endMonth        The daylight saving time ending month. Month is
    # a {@link Calendar#MONTH MONTH} field
    # value (0-based. e.g., 9 for October).
    # @param endDay          The day of the month on which the daylight saving time ends.
    # See the class description for the special cases of this parameter.
    # @param endDayOfWeek    The daylight saving time ending day-of-week.
    # See the class description for the special cases of this parameter.
    # @param endTime         The daylight saving ending time in local wall clock time,
    # (in milliseconds within the day) which is local daylight
    # time in this case.
    # @exception IllegalArgumentException if the <code>endMonth</code>, <code>endDay</code>,
    # <code>endDayOfWeek</code>, or <code>endTime</code> parameters are out of range
    def set_end_rule(end_month, end_day, end_day_of_week, end_time)
      @end_month = end_month
      @end_day = end_day
      @end_day_of_week = end_day_of_week
      @end_time = end_time
      @end_time_mode = WALL_TIME
      decode_end_rule
      invalidate_cache
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # Sets the daylight saving time end rule to a fixed date within a month.
    # This method is equivalent to:
    # <pre><code>setEndRule(endMonth, endDay, 0, endTime)</code></pre>
    # 
    # @param endMonth        The daylight saving time ending month. Month is
    # a {@link Calendar#MONTH MONTH} field
    # value (0-based. e.g., 9 for October).
    # @param endDay          The day of the month on which the daylight saving time ends.
    # @param endTime         The daylight saving ending time in local wall clock time,
    # (in milliseconds within the day) which is local daylight
    # time in this case.
    # @exception IllegalArgumentException the <code>endMonth</code>, <code>endDay</code>,
    # or <code>endTime</code> parameters are out of range
    # @since 1.2
    def set_end_rule(end_month, end_day, end_time)
      set_end_rule(end_month, end_day, 0, end_time)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Boolean] }
    # Sets the daylight saving time end rule to a weekday before or after the given date within
    # a month, e.g., the first Monday on or after the 8th.
    # 
    # @param endMonth        The daylight saving time ending month. Month is
    # a {@link Calendar#MONTH MONTH} field
    # value (0-based. e.g., 9 for October).
    # @param endDay          The day of the month on which the daylight saving time ends.
    # @param endDayOfWeek    The daylight saving time ending day-of-week.
    # @param endTime         The daylight saving ending time in local wall clock time,
    # (in milliseconds within the day) which is local daylight
    # time in this case.
    # @param after           If true, this rule selects the first <code>endDayOfWeek</code> on
    # or <em>after</em> <code>endDay</code>.  If false, this rule
    # selects the last <code>endDayOfWeek</code> on or before
    # <code>endDay</code> of the month.
    # @exception IllegalArgumentException the <code>endMonth</code>, <code>endDay</code>,
    # <code>endDayOfWeek</code>, or <code>endTime</code> parameters are out of range
    # @since 1.2
    def set_end_rule(end_month, end_day, end_day_of_week, end_time, after)
      if (after)
        set_end_rule(end_month, end_day, -end_day_of_week, end_time)
      else
        set_end_rule(end_month, -end_day, -end_day_of_week, end_time)
      end
    end
    
    typesig { [::Java::Long] }
    # Returns the offset of this time zone from UTC at the given
    # time. If daylight saving time is in effect at the given time,
    # the offset value is adjusted with the amount of daylight
    # saving.
    # 
    # @param date the time at which the time zone offset is found
    # @return the amount of time in milliseconds to add to UTC to get
    # local time.
    # @since 1.4
    def get_offset(date)
      return get_offsets(date, nil)
    end
    
    typesig { [::Java::Long, Array.typed(::Java::Int)] }
    # @see TimeZone#getOffsets
    def get_offsets(date, offsets)
      offset = @raw_offset
      if (@use_daylight)
        synchronized((self)) do
          if (!(@cache_start).equal?(0))
            if (date >= @cache_start && date < @cache_end)
              offset += @dst_savings
              break
            end
          end
        end
        cal = date >= GregorianCalendar::DEFAULT_GREGORIAN_CUTOVER ? Gcal : CalendarSystem.for_name("julian")
        cdate = cal.new_calendar_date(TimeZone::NO_TIMEZONE)
        # Get the year in local time
        cal.get_calendar_date(date + @raw_offset, cdate)
        year = cdate.get_normalized_year
        if (year >= @start_year)
          # Clear time elements for the transition calculations
          cdate.set_time_of_day(0, 0, 0, 0)
          offset = get_offset(cal, cdate, year, date)
        end
      end
      if (!(offsets).nil?)
        offsets[0] = @raw_offset
        offsets[1] = offset - @raw_offset
      end
      return offset
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Returns the difference in milliseconds between local time and
    # UTC, taking into account both the raw offset and the effect of
    # daylight saving, for the specified date and time.  This method
    # assumes that the start and end month are distinct.  It also
    # uses a default {@link GregorianCalendar} object as its
    # underlying calendar, such as for determining leap years.  Do
    # not use the result of this method with a calendar other than a
    # default <code>GregorianCalendar</code>.
    # 
    # <p><em>Note:  In general, clients should use
    # <code>Calendar.get(ZONE_OFFSET) + Calendar.get(DST_OFFSET)</code>
    # instead of calling this method.</em>
    # 
    # @param era       The era of the given date.
    # @param year      The year in the given date.
    # @param month     The month in the given date. Month is 0-based. e.g.,
    # 0 for January.
    # @param day       The day-in-month of the given date.
    # @param dayOfWeek The day-of-week of the given date.
    # @param millis    The milliseconds in day in <em>standard</em> local time.
    # @return          The milliseconds to add to UTC to get local time.
    # @exception       IllegalArgumentException the <code>era</code>,
    # <code>month</code>, <code>day</code>, <code>dayOfWeek</code>,
    # or <code>millis</code> parameters are out of range
    def get_offset(era, year, month, day, day_of_week, millis)
      if (!(era).equal?(GregorianCalendar::AD) && !(era).equal?(GregorianCalendar::BC))
        raise IllegalArgumentException.new("Illegal era " + RJava.cast_to_string(era))
      end
      y = year
      if ((era).equal?(GregorianCalendar::BC))
        # adjust y with the GregorianCalendar-style year numbering.
        y = 1 - y
      end
      # If the year isn't representable with the 64-bit long
      # integer in milliseconds, convert the year to an
      # equivalent year. This is required to pass some JCK test cases
      # which are actually useless though because the specified years
      # can't be supported by the Java time system.
      if (y >= 292278994)
        y = 2800 + y % 2800
      else
        if (y <= -292269054)
          # y %= 28 also produces an equivalent year, but positive
          # year numbers would be convenient to use the UNIX cal
          # command.
          y = RJava.cast_to_int(CalendarUtils.mod(y, 28))
        end
      end
      # convert year to its 1-based month value
      m = month + 1
      # First, calculate time as a Gregorian date.
      cal = Gcal
      cdate = cal.new_calendar_date(TimeZone::NO_TIMEZONE)
      cdate.set_date(y, m, day)
      time = cal.get_time(cdate) # normalize cdate
      time += millis - @raw_offset # UTC time
      # If the time value represents a time before the default
      # Gregorian cutover, recalculate time using the Julian
      # calendar system. For the Julian calendar system, the
      # normalized year numbering is ..., -2 (BCE 2), -1 (BCE 1),
      # 1, 2 ... which is different from the GregorianCalendar
      # style year numbering (..., -1, 0 (BCE 1), 1, 2, ...).
      if (time < GregorianCalendar::DEFAULT_GREGORIAN_CUTOVER)
        cal = CalendarSystem.for_name("julian")
        cdate = cal.new_calendar_date(TimeZone::NO_TIMEZONE)
        cdate.set_normalized_date(y, m, day)
        time = cal.get_time(cdate) + millis - @raw_offset
      end
      # The validation should be cdate.getDayOfWeek() ==
      # dayOfWeek. However, we don't check dayOfWeek for
      # compatibility.
      if ((!(cdate.get_normalized_year).equal?(y)) || (!(cdate.get_month).equal?(m)) || (!(cdate.get_day_of_month).equal?(day)) || (day_of_week < Calendar::SUNDAY || day_of_week > Calendar::SATURDAY) || (millis < 0 || millis >= (24 * 60 * 60 * 1000)))
        raise IllegalArgumentException.new
      end
      if (!@use_daylight || year < @start_year || !(era).equal?(GregorianCalendar::CE))
        return @raw_offset
      end
      return get_offset(cal, cdate, y, time)
    end
    
    typesig { [BaseCalendar, BaseCalendar::Date, ::Java::Int, ::Java::Long] }
    def get_offset(cal, cdate, year, time)
      synchronized((self)) do
        if (!(@cache_start).equal?(0))
          if (time >= @cache_start && time < @cache_end)
            return @raw_offset + @dst_savings
          end
          if ((year).equal?(@cache_year))
            return @raw_offset
          end
        end
      end
      start = get_start(cal, cdate, year)
      end_ = get_end(cal, cdate, year)
      offset = @raw_offset
      if (start <= end_)
        if (time >= start && time < end_)
          offset += @dst_savings
        end
        synchronized((self)) do
          @cache_year = year
          @cache_start = start
          @cache_end = end_
        end
      else
        if (time < end_)
          # TODO: support Gregorian cutover. The previous year
          # may be in the other calendar system.
          start = get_start(cal, cdate, year - 1)
          if (time >= start)
            offset += @dst_savings
          end
        else
          if (time >= start)
            # TODO: support Gregorian cutover. The next year
            # may be in the other calendar system.
            end_ = get_end(cal, cdate, year + 1)
            if (time < end_)
              offset += @dst_savings
            end
          end
        end
        if (start <= end_)
          synchronized((self)) do
            # The start and end transitions are in multiple years.
            @cache_year = @start_year - 1
            @cache_start = start
            @cache_end = end_
          end
        end
      end
      return offset
    end
    
    typesig { [BaseCalendar, BaseCalendar::Date, ::Java::Int] }
    def get_start(cal, cdate, year)
      time = @start_time
      if (!(@start_time_mode).equal?(UTC_TIME))
        time -= @raw_offset
      end
      return get_transition(cal, cdate, @start_mode, year, @start_month, @start_day, @start_day_of_week, time)
    end
    
    typesig { [BaseCalendar, BaseCalendar::Date, ::Java::Int] }
    def get_end(cal, cdate, year)
      time = @end_time
      if (!(@end_time_mode).equal?(UTC_TIME))
        time -= @raw_offset
      end
      if ((@end_time_mode).equal?(WALL_TIME))
        time -= @dst_savings
      end
      return get_transition(cal, cdate, @end_mode, year, @end_month, @end_day, @end_day_of_week, time)
    end
    
    typesig { [BaseCalendar, BaseCalendar::Date, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    def get_transition(cal, cdate, mode, year, month, day_of_month, day_of_week, time_of_day)
      cdate.set_normalized_year(year)
      cdate.set_month(month + 1)
      case (mode)
      when DOM_MODE
        cdate.set_day_of_month(day_of_month)
      when DOW_IN_MONTH_MODE
        cdate.set_day_of_month(1)
        if (day_of_month < 0)
          cdate.set_day_of_month(cal.get_month_length(cdate))
        end
        cdate = cal.get_nth_day_of_week(day_of_month, day_of_week, cdate)
      when DOW_GE_DOM_MODE
        cdate.set_day_of_month(day_of_month)
        cdate = cal.get_nth_day_of_week(1, day_of_week, cdate)
      when DOW_LE_DOM_MODE
        cdate.set_day_of_month(day_of_month)
        cdate = cal.get_nth_day_of_week(-1, day_of_week, cdate)
      end
      return cal.get_time(cdate) + time_of_day
    end
    
    typesig { [] }
    # Gets the GMT offset for this time zone.
    # @return the GMT offset value in milliseconds
    # @see #setRawOffset
    def get_raw_offset
      # The given date will be taken into account while
      # we have the historical time zone data in place.
      return @raw_offset
    end
    
    typesig { [::Java::Int] }
    # Sets the base time zone offset to GMT.
    # This is the offset to add to UTC to get local time.
    # @see #getRawOffset
    def set_raw_offset(offset_millis)
      @raw_offset = offset_millis
    end
    
    typesig { [::Java::Int] }
    # Sets the amount of time in milliseconds that the clock is advanced
    # during daylight saving time.
    # @param millisSavedDuringDST the number of milliseconds the time is
    # advanced with respect to standard time when the daylight saving time rules
    # are in effect. A positive number, typically one hour (3600000).
    # @see #getDSTSavings
    # @since 1.2
    def set_dstsavings(millis_saved_during_dst)
      if (millis_saved_during_dst <= 0)
        raise IllegalArgumentException.new("Illegal daylight saving value: " + RJava.cast_to_string(millis_saved_during_dst))
      end
      @dst_savings = millis_saved_during_dst
    end
    
    typesig { [] }
    # Returns the amount of time in milliseconds that the clock is
    # advanced during daylight saving time.
    # 
    # @return the number of milliseconds the time is advanced with
    # respect to standard time when the daylight saving rules are in
    # effect, or 0 (zero) if this time zone doesn't observe daylight
    # saving time.
    # 
    # @see #setDSTSavings
    # @since 1.2
    def get_dstsavings
      if (@use_daylight)
        return @dst_savings
      end
      return 0
    end
    
    typesig { [] }
    # Queries if this time zone uses daylight saving time.
    # @return true if this time zone uses daylight saving time;
    # false otherwise.
    def use_daylight_time
      return @use_daylight
    end
    
    typesig { [Date] }
    # Queries if the given date is in daylight saving time.
    # @return true if daylight saving time is in effective at the
    # given date; false otherwise.
    def in_daylight_time(date)
      return (!(get_offset(date.get_time)).equal?(@raw_offset))
    end
    
    typesig { [] }
    # Returns a clone of this <code>SimpleTimeZone</code> instance.
    # @return a clone of this instance.
    def clone
      return super
    end
    
    typesig { [] }
    # Generates the hash code for the SimpleDateFormat object.
    # @return the hash code for this object
    def hash_code
      synchronized(self) do
        return @start_month ^ @start_day ^ @start_day_of_week ^ @start_time ^ @end_month ^ @end_day ^ @end_day_of_week ^ @end_time ^ @raw_offset
      end
    end
    
    typesig { [Object] }
    # Compares the equality of two <code>SimpleTimeZone</code> objects.
    # 
    # @param obj  The <code>SimpleTimeZone</code> object to be compared with.
    # @return     True if the given <code>obj</code> is the same as this
    # <code>SimpleTimeZone</code> object; false otherwise.
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(SimpleTimeZone)))
        return false
      end
      that = obj
      return (get_id == that.get_id) && has_same_rules(that)
    end
    
    typesig { [TimeZone] }
    # Returns <code>true</code> if this zone has the same rules and offset as another zone.
    # @param other the TimeZone object to be compared with
    # @return <code>true</code> if the given zone is a SimpleTimeZone and has the
    # same rules and offset as this one
    # @since 1.2
    def has_same_rules(other)
      if ((self).equal?(other))
        return true
      end
      if (!(other.is_a?(SimpleTimeZone)))
        return false
      end
      that = other
      # Only check rules if using DST
      return (@raw_offset).equal?(that.attr_raw_offset) && (@use_daylight).equal?(that.attr_use_daylight) && (!@use_daylight || ((@dst_savings).equal?(that.attr_dst_savings) && (@start_mode).equal?(that.attr_start_mode) && (@start_month).equal?(that.attr_start_month) && (@start_day).equal?(that.attr_start_day) && (@start_day_of_week).equal?(that.attr_start_day_of_week) && (@start_time).equal?(that.attr_start_time) && (@start_time_mode).equal?(that.attr_start_time_mode) && (@end_mode).equal?(that.attr_end_mode) && (@end_month).equal?(that.attr_end_month) && (@end_day).equal?(that.attr_end_day) && (@end_day_of_week).equal?(that.attr_end_day_of_week) && (@end_time).equal?(that.attr_end_time) && (@end_time_mode).equal?(that.attr_end_time_mode) && (@start_year).equal?(that.attr_start_year)))
    end
    
    typesig { [] }
    # Returns a string representation of this time zone.
    # @return a string representation of this time zone.
    def to_s
      return RJava.cast_to_string(get_class.get_name) + "[id=" + RJava.cast_to_string(get_id) + ",offset=" + RJava.cast_to_string(@raw_offset) + ",dstSavings=" + RJava.cast_to_string(@dst_savings) + ",useDaylight=" + RJava.cast_to_string(@use_daylight) + ",startYear=" + RJava.cast_to_string(@start_year) + ",startMode=" + RJava.cast_to_string(@start_mode) + ",startMonth=" + RJava.cast_to_string(@start_month) + ",startDay=" + RJava.cast_to_string(@start_day) + ",startDayOfWeek=" + RJava.cast_to_string(@start_day_of_week) + ",startTime=" + RJava.cast_to_string(@start_time) + ",startTimeMode=" + RJava.cast_to_string(@start_time_mode) + ",endMode=" + RJava.cast_to_string(@end_mode) + ",endMonth=" + RJava.cast_to_string(@end_month) + ",endDay=" + RJava.cast_to_string(@end_day) + ",endDayOfWeek=" + RJava.cast_to_string(@end_day_of_week) + ",endTime=" + RJava.cast_to_string(@end_time) + ",endTimeMode=" + RJava.cast_to_string(@end_time_mode) + RJava.cast_to_string(Character.new(?].ord))
    end
    
    # =======================privates===============================
    # 
    # The month in which daylight saving time starts.  This value must be
    # between <code>Calendar.JANUARY</code> and
    # <code>Calendar.DECEMBER</code> inclusive.  This value must not equal
    # <code>endMonth</code>.
    # <p>If <code>useDaylight</code> is false, this value is ignored.
    # @serial
    attr_accessor :start_month
    alias_method :attr_start_month, :start_month
    undef_method :start_month
    alias_method :attr_start_month=, :start_month=
    undef_method :start_month=
    
    # This field has two possible interpretations:
    # <dl>
    # <dt><code>startMode == DOW_IN_MONTH</code></dt>
    # <dd>
    # <code>startDay</code> indicates the day of the month of
    # <code>startMonth</code> on which daylight
    # saving time starts, from 1 to 28, 30, or 31, depending on the
    # <code>startMonth</code>.
    # </dd>
    # <dt><code>startMode != DOW_IN_MONTH</code></dt>
    # <dd>
    # <code>startDay</code> indicates which <code>startDayOfWeek</code> in the
    # month <code>startMonth</code> daylight
    # saving time starts on.  For example, a value of +1 and a
    # <code>startDayOfWeek</code> of <code>Calendar.SUNDAY</code> indicates the
    # first Sunday of <code>startMonth</code>.  Likewise, +2 would indicate the
    # second Sunday, and -1 the last Sunday.  A value of 0 is illegal.
    # </dd>
    # </dl>
    # <p>If <code>useDaylight</code> is false, this value is ignored.
    # @serial
    attr_accessor :start_day
    alias_method :attr_start_day, :start_day
    undef_method :start_day
    alias_method :attr_start_day=, :start_day=
    undef_method :start_day=
    
    # The day of the week on which daylight saving time starts.  This value
    # must be between <code>Calendar.SUNDAY</code> and
    # <code>Calendar.SATURDAY</code> inclusive.
    # <p>If <code>useDaylight</code> is false or
    # <code>startMode == DAY_OF_MONTH</code>, this value is ignored.
    # @serial
    attr_accessor :start_day_of_week
    alias_method :attr_start_day_of_week, :start_day_of_week
    undef_method :start_day_of_week
    alias_method :attr_start_day_of_week=, :start_day_of_week=
    undef_method :start_day_of_week=
    
    # The time in milliseconds after midnight at which daylight saving
    # time starts.  This value is expressed as wall time, standard time,
    # or UTC time, depending on the setting of <code>startTimeMode</code>.
    # <p>If <code>useDaylight</code> is false, this value is ignored.
    # @serial
    attr_accessor :start_time
    alias_method :attr_start_time, :start_time
    undef_method :start_time
    alias_method :attr_start_time=, :start_time=
    undef_method :start_time=
    
    # The format of startTime, either WALL_TIME, STANDARD_TIME, or UTC_TIME.
    # @serial
    # @since 1.3
    attr_accessor :start_time_mode
    alias_method :attr_start_time_mode, :start_time_mode
    undef_method :start_time_mode
    alias_method :attr_start_time_mode=, :start_time_mode=
    undef_method :start_time_mode=
    
    # The month in which daylight saving time ends.  This value must be
    # between <code>Calendar.JANUARY</code> and
    # <code>Calendar.UNDECIMBER</code>.  This value must not equal
    # <code>startMonth</code>.
    # <p>If <code>useDaylight</code> is false, this value is ignored.
    # @serial
    attr_accessor :end_month
    alias_method :attr_end_month, :end_month
    undef_method :end_month
    alias_method :attr_end_month=, :end_month=
    undef_method :end_month=
    
    # This field has two possible interpretations:
    # <dl>
    # <dt><code>endMode == DOW_IN_MONTH</code></dt>
    # <dd>
    # <code>endDay</code> indicates the day of the month of
    # <code>endMonth</code> on which daylight
    # saving time ends, from 1 to 28, 30, or 31, depending on the
    # <code>endMonth</code>.
    # </dd>
    # <dt><code>endMode != DOW_IN_MONTH</code></dt>
    # <dd>
    # <code>endDay</code> indicates which <code>endDayOfWeek</code> in th
    # month <code>endMonth</code> daylight
    # saving time ends on.  For example, a value of +1 and a
    # <code>endDayOfWeek</code> of <code>Calendar.SUNDAY</code> indicates the
    # first Sunday of <code>endMonth</code>.  Likewise, +2 would indicate the
    # second Sunday, and -1 the last Sunday.  A value of 0 is illegal.
    # </dd>
    # </dl>
    # <p>If <code>useDaylight</code> is false, this value is ignored.
    # @serial
    attr_accessor :end_day
    alias_method :attr_end_day, :end_day
    undef_method :end_day
    alias_method :attr_end_day=, :end_day=
    undef_method :end_day=
    
    # The day of the week on which daylight saving time ends.  This value
    # must be between <code>Calendar.SUNDAY</code> and
    # <code>Calendar.SATURDAY</code> inclusive.
    # <p>If <code>useDaylight</code> is false or
    # <code>endMode == DAY_OF_MONTH</code>, this value is ignored.
    # @serial
    attr_accessor :end_day_of_week
    alias_method :attr_end_day_of_week, :end_day_of_week
    undef_method :end_day_of_week
    alias_method :attr_end_day_of_week=, :end_day_of_week=
    undef_method :end_day_of_week=
    
    # The time in milliseconds after midnight at which daylight saving
    # time ends.  This value is expressed as wall time, standard time,
    # or UTC time, depending on the setting of <code>endTimeMode</code>.
    # <p>If <code>useDaylight</code> is false, this value is ignored.
    # @serial
    attr_accessor :end_time
    alias_method :attr_end_time, :end_time
    undef_method :end_time
    alias_method :attr_end_time=, :end_time=
    undef_method :end_time=
    
    # The format of endTime, either <code>WALL_TIME</code>,
    # <code>STANDARD_TIME</code>, or <code>UTC_TIME</code>.
    # @serial
    # @since 1.3
    attr_accessor :end_time_mode
    alias_method :attr_end_time_mode, :end_time_mode
    undef_method :end_time_mode
    alias_method :attr_end_time_mode=, :end_time_mode=
    undef_method :end_time_mode=
    
    # The year in which daylight saving time is first observed.  This is an {@link GregorianCalendar#AD AD}
    # value.  If this value is less than 1 then daylight saving time is observed
    # for all <code>AD</code> years.
    # <p>If <code>useDaylight</code> is false, this value is ignored.
    # @serial
    attr_accessor :start_year
    alias_method :attr_start_year, :start_year
    undef_method :start_year
    alias_method :attr_start_year=, :start_year=
    undef_method :start_year=
    
    # The offset in milliseconds between this zone and GMT.  Negative offsets
    # are to the west of Greenwich.  To obtain local <em>standard</em> time,
    # add the offset to GMT time.  To obtain local wall time it may also be
    # necessary to add <code>dstSavings</code>.
    # @serial
    attr_accessor :raw_offset
    alias_method :attr_raw_offset, :raw_offset
    undef_method :raw_offset
    alias_method :attr_raw_offset=, :raw_offset=
    undef_method :raw_offset=
    
    # A boolean value which is true if and only if this zone uses daylight
    # saving time.  If this value is false, several other fields are ignored.
    # @serial
    attr_accessor :use_daylight
    alias_method :attr_use_daylight, :use_daylight
    undef_method :use_daylight
    alias_method :attr_use_daylight=, :use_daylight=
    undef_method :use_daylight=
    
    class_module.module_eval {
      # indicate if this time zone uses DST
      const_set_lazy(:MillisPerHour) { 60 * 60 * 1000 }
      const_attr_reader  :MillisPerHour
      
      const_set_lazy(:MillisPerDay) { 24 * MillisPerHour }
      const_attr_reader  :MillisPerDay
    }
    
    # This field was serialized in JDK 1.1, so we have to keep it that way
    # to maintain serialization compatibility. However, there's no need to
    # recreate the array each time we create a new time zone.
    # @serial An array of bytes containing the values {31, 28, 31, 30, 31, 30,
    # 31, 31, 30, 31, 30, 31}.  This is ignored as of the Java 2 platform v1.2, however, it must
    # be streamed out for compatibility with JDK 1.1.
    attr_accessor :month_length
    alias_method :attr_month_length, :month_length
    undef_method :month_length
    alias_method :attr_month_length=, :month_length=
    undef_method :month_length=
    
    class_module.module_eval {
      const_set_lazy(:StaticMonthLength) { Array.typed(::Java::Byte).new([31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]) }
      const_attr_reader  :StaticMonthLength
      
      const_set_lazy(:StaticLeapMonthLength) { Array.typed(::Java::Byte).new([31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]) }
      const_attr_reader  :StaticLeapMonthLength
    }
    
    # Variables specifying the mode of the start rule.  Takes the following
    # values:
    # <dl>
    # <dt><code>DOM_MODE</code></dt>
    # <dd>
    # Exact day of week; e.g., March 1.
    # </dd>
    # <dt><code>DOW_IN_MONTH_MODE</code></dt>
    # <dd>
    # Day of week in month; e.g., last Sunday in March.
    # </dd>
    # <dt><code>DOW_GE_DOM_MODE</code></dt>
    # <dd>
    # Day of week after day of month; e.g., Sunday on or after March 15.
    # </dd>
    # <dt><code>DOW_LE_DOM_MODE</code></dt>
    # <dd>
    # Day of week before day of month; e.g., Sunday on or before March 15.
    # </dd>
    # </dl>
    # The setting of this field affects the interpretation of the
    # <code>startDay</code> field.
    # <p>If <code>useDaylight</code> is false, this value is ignored.
    # @serial
    # @since 1.1.4
    attr_accessor :start_mode
    alias_method :attr_start_mode, :start_mode
    undef_method :start_mode
    alias_method :attr_start_mode=, :start_mode=
    undef_method :start_mode=
    
    # Variables specifying the mode of the end rule.  Takes the following
    # values:
    # <dl>
    # <dt><code>DOM_MODE</code></dt>
    # <dd>
    # Exact day of week; e.g., March 1.
    # </dd>
    # <dt><code>DOW_IN_MONTH_MODE</code></dt>
    # <dd>
    # Day of week in month; e.g., last Sunday in March.
    # </dd>
    # <dt><code>DOW_GE_DOM_MODE</code></dt>
    # <dd>
    # Day of week after day of month; e.g., Sunday on or after March 15.
    # </dd>
    # <dt><code>DOW_LE_DOM_MODE</code></dt>
    # <dd>
    # Day of week before day of month; e.g., Sunday on or before March 15.
    # </dd>
    # </dl>
    # The setting of this field affects the interpretation of the
    # <code>endDay</code> field.
    # <p>If <code>useDaylight</code> is false, this value is ignored.
    # @serial
    # @since 1.1.4
    attr_accessor :end_mode
    alias_method :attr_end_mode, :end_mode
    undef_method :end_mode
    alias_method :attr_end_mode=, :end_mode=
    undef_method :end_mode=
    
    # A positive value indicating the amount of time saved during DST in
    # milliseconds.
    # Typically one hour (3600000); sometimes 30 minutes (1800000).
    # <p>If <code>useDaylight</code> is false, this value is ignored.
    # @serial
    # @since 1.1.4
    attr_accessor :dst_savings
    alias_method :attr_dst_savings, :dst_savings
    undef_method :dst_savings
    alias_method :attr_dst_savings=, :dst_savings=
    undef_method :dst_savings=
    
    class_module.module_eval {
      const_set_lazy(:Gcal) { CalendarSystem.get_gregorian_calendar }
      const_attr_reader  :Gcal
    }
    
    # Cache values representing a single period of daylight saving
    # time. When the cache values are valid, cacheStart is the start
    # time (inclusive) of daylight saving time and cacheEnd is the
    # end time (exclusive).
    # 
    # cacheYear has a year value if both cacheStart and cacheEnd are
    # in the same year. cacheYear is set to startYear - 1 if
    # cacheStart and cacheEnd are in different years. cacheStart is 0
    # if the cache values are void. cacheYear is a long to support
    # Integer.MIN_VALUE - 1 (JCK requirement).
    attr_accessor :cache_year
    alias_method :attr_cache_year, :cache_year
    undef_method :cache_year
    alias_method :attr_cache_year=, :cache_year=
    undef_method :cache_year=
    
    attr_accessor :cache_start
    alias_method :attr_cache_start, :cache_start
    undef_method :cache_start
    alias_method :attr_cache_start=, :cache_start=
    undef_method :cache_start=
    
    attr_accessor :cache_end
    alias_method :attr_cache_end, :cache_end
    undef_method :cache_end
    alias_method :attr_cache_end=, :cache_end=
    undef_method :cache_end=
    
    class_module.module_eval {
      # Constants specifying values of startMode and endMode.
      const_set_lazy(:DOM_MODE) { 1 }
      const_attr_reader  :DOM_MODE
      
      # Exact day of month, "Mar 1"
      const_set_lazy(:DOW_IN_MONTH_MODE) { 2 }
      const_attr_reader  :DOW_IN_MONTH_MODE
      
      # Day of week in month, "lastSun"
      const_set_lazy(:DOW_GE_DOM_MODE) { 3 }
      const_attr_reader  :DOW_GE_DOM_MODE
      
      # Day of week after day of month, "Sun>=15"
      const_set_lazy(:DOW_LE_DOM_MODE) { 4 }
      const_attr_reader  :DOW_LE_DOM_MODE
      
      # Day of week before day of month, "Sun<=21"
      # 
      # Constant for a mode of start or end time specified as wall clock
      # time.  Wall clock time is standard time for the onset rule, and
      # daylight time for the end rule.
      # @since 1.4
      const_set_lazy(:WALL_TIME) { 0 }
      const_attr_reader  :WALL_TIME
      
      # Zero for backward compatibility
      # 
      # Constant for a mode of start or end time specified as standard time.
      # @since 1.4
      const_set_lazy(:STANDARD_TIME) { 1 }
      const_attr_reader  :STANDARD_TIME
      
      # Constant for a mode of start or end time specified as UTC. European
      # Union rules are specified as UTC time, for example.
      # @since 1.4
      const_set_lazy(:UTC_TIME) { 2 }
      const_attr_reader  :UTC_TIME
      
      # Proclaim compatibility with 1.1
      const_set_lazy(:SerialVersionUID) { -403250971215465050 }
      const_attr_reader  :SerialVersionUID
      
      # the internal serial version which says which version was written
      # - 0 (default) for version up to JDK 1.1.3
      # - 1 for version from JDK 1.1.4, which includes 3 new fields
      # - 2 for JDK 1.3, which includes 2 new fields
      const_set_lazy(:CurrentSerialVersion) { 2 }
      const_attr_reader  :CurrentSerialVersion
    }
    
    # The version of the serialized data on the stream.  Possible values:
    # <dl>
    # <dt><b>0</b> or not present on stream</dt>
    # <dd>
    # JDK 1.1.3 or earlier.
    # </dd>
    # <dt><b>1</b></dt>
    # <dd>
    # JDK 1.1.4 or later.  Includes three new fields: <code>startMode</code>,
    # <code>endMode</code>, and <code>dstSavings</code>.
    # </dd>
    # <dt><b>2</b></dt>
    # <dd>
    # JDK 1.3 or later.  Includes two new fields: <code>startTimeMode</code>
    # and <code>endTimeMode</code>.
    # </dd>
    # </dl>
    # When streaming out this class, the most recent format
    # and the highest allowable <code>serialVersionOnStream</code>
    # is written.
    # @serial
    # @since 1.1.4
    attr_accessor :serial_version_on_stream
    alias_method :attr_serial_version_on_stream, :serial_version_on_stream
    undef_method :serial_version_on_stream
    alias_method :attr_serial_version_on_stream=, :serial_version_on_stream=
    undef_method :serial_version_on_stream=
    
    typesig { [] }
    def invalidate_cache
      synchronized(self) do
        @cache_year = @start_year - 1
        @cache_start = @cache_end = 0
      end
    end
    
    typesig { [] }
    # ----------------------------------------------------------------------
    # Rule representation
    # 
    # We represent the following flavors of rules:
    # 5        the fifth of the month
    # lastSun  the last Sunday in the month
    # lastMon  the last Monday in the month
    # Sun>=8   first Sunday on or after the eighth
    # Sun<=25  last Sunday on or before the 25th
    # This is further complicated by the fact that we need to remain
    # backward compatible with the 1.1 FCS.  Finally, we need to minimize
    # API changes.  In order to satisfy these requirements, we support
    # three representation systems, and we translate between them.
    # 
    # INTERNAL REPRESENTATION
    # This is the format SimpleTimeZone objects take after construction or
    # streaming in is complete.  Rules are represented directly, using an
    # unencoded format.  We will discuss the start rule only below; the end
    # rule is analogous.
    # startMode      Takes on enumerated values DAY_OF_MONTH,
    # DOW_IN_MONTH, DOW_AFTER_DOM, or DOW_BEFORE_DOM.
    # startDay       The day of the month, or for DOW_IN_MONTH mode, a
    # value indicating which DOW, such as +1 for first,
    # +2 for second, -1 for last, etc.
    # startDayOfWeek The day of the week.  Ignored for DAY_OF_MONTH.
    # 
    # ENCODED REPRESENTATION
    # This is the format accepted by the constructor and by setStartRule()
    # and setEndRule().  It uses various combinations of positive, negative,
    # and zero values to encode the different rules.  This representation
    # allows us to specify all the different rule flavors without altering
    # the API.
    # MODE              startMonth    startDay    startDayOfWeek
    # DOW_IN_MONTH_MODE >=0           !=0         >0
    # DOM_MODE          >=0           >0          ==0
    # DOW_GE_DOM_MODE   >=0           >0          <0
    # DOW_LE_DOM_MODE   >=0           <0          <0
    # (no DST)          don't care    ==0         don't care
    # 
    # STREAMED REPRESENTATION
    # We must retain binary compatibility with the 1.1 FCS.  The 1.1 code only
    # handles DOW_IN_MONTH_MODE and non-DST mode, the latter indicated by the
    # flag useDaylight.  When we stream an object out, we translate into an
    # approximate DOW_IN_MONTH_MODE representation so the object can be parsed
    # and used by 1.1 code.  Following that, we write out the full
    # representation separately so that contemporary code can recognize and
    # parse it.  The full representation is written in a "packed" format,
    # consisting of a version number, a length, and an array of bytes.  Future
    # versions of this class may specify different versions.  If they wish to
    # include additional data, they should do so by storing them after the
    # packed representation below.
    # ----------------------------------------------------------------------
    # 
    # Given a set of encoded rules in startDay and startDayOfMonth, decode
    # them and set the startMode appropriately.  Do the same for endDay and
    # endDayOfMonth.  Upon entry, the day of week variables may be zero or
    # negative, in order to indicate special modes.  The day of month
    # variables may also be negative.  Upon exit, the mode variables will be
    # set, and the day of week and day of month variables will be positive.
    # This method also recognizes a startDay or endDay of zero as indicating
    # no DST.
    def decode_rules
      decode_start_rule
      decode_end_rule
    end
    
    typesig { [] }
    # Decode the start rule and validate the parameters.  The parameters are
    # expected to be in encoded form, which represents the various rule modes
    # by negating or zeroing certain values.  Representation formats are:
    # <p>
    # <pre>
    # DOW_IN_MONTH  DOM    DOW>=DOM  DOW<=DOM  no DST
    # ------------  -----  --------  --------  ----------
    # month       0..11        same    same      same     don't care
    # day        -5..5         1..31   1..31    -1..-31   0
    # dayOfWeek   1..7         0      -1..-7    -1..-7    don't care
    # time        0..ONEDAY    same    same      same     don't care
    # </pre>
    # The range for month does not include UNDECIMBER since this class is
    # really specific to GregorianCalendar, which does not use that month.
    # The range for time includes ONEDAY (vs. ending at ONEDAY-1) because the
    # end rule is an exclusive limit point.  That is, the range of times that
    # are in DST include those >= the start and < the end.  For this reason,
    # it should be possible to specify an end of ONEDAY in order to include the
    # entire day.  Although this is equivalent to time 0 of the following day,
    # it's not always possible to specify that, for example, on December 31.
    # While arguably the start range should still be 0..ONEDAY-1, we keep
    # the start and end ranges the same for consistency.
    def decode_start_rule
      @use_daylight = (!(@start_day).equal?(0)) && (!(@end_day).equal?(0))
      if (!(@start_day).equal?(0))
        if (@start_month < Calendar::JANUARY || @start_month > Calendar::DECEMBER)
          raise IllegalArgumentException.new("Illegal start month " + RJava.cast_to_string(@start_month))
        end
        if (@start_time < 0 || @start_time >= MillisPerDay)
          raise IllegalArgumentException.new("Illegal start time " + RJava.cast_to_string(@start_time))
        end
        if ((@start_day_of_week).equal?(0))
          @start_mode = DOM_MODE
        else
          if (@start_day_of_week > 0)
            @start_mode = DOW_IN_MONTH_MODE
          else
            @start_day_of_week = -@start_day_of_week
            if (@start_day > 0)
              @start_mode = DOW_GE_DOM_MODE
            else
              @start_day = -@start_day
              @start_mode = DOW_LE_DOM_MODE
            end
          end
          if (@start_day_of_week > Calendar::SATURDAY)
            raise IllegalArgumentException.new("Illegal start day of week " + RJava.cast_to_string(@start_day_of_week))
          end
        end
        if ((@start_mode).equal?(DOW_IN_MONTH_MODE))
          if (@start_day < -5 || @start_day > 5)
            raise IllegalArgumentException.new("Illegal start day of week in month " + RJava.cast_to_string(@start_day))
          end
        else
          if (@start_day < 1 || @start_day > StaticMonthLength[@start_month])
            raise IllegalArgumentException.new("Illegal start day " + RJava.cast_to_string(@start_day))
          end
        end
      end
    end
    
    typesig { [] }
    # Decode the end rule and validate the parameters.  This method is exactly
    # analogous to decodeStartRule().
    # @see decodeStartRule
    def decode_end_rule
      @use_daylight = (!(@start_day).equal?(0)) && (!(@end_day).equal?(0))
      if (!(@end_day).equal?(0))
        if (@end_month < Calendar::JANUARY || @end_month > Calendar::DECEMBER)
          raise IllegalArgumentException.new("Illegal end month " + RJava.cast_to_string(@end_month))
        end
        if (@end_time < 0 || @end_time >= MillisPerDay)
          raise IllegalArgumentException.new("Illegal end time " + RJava.cast_to_string(@end_time))
        end
        if ((@end_day_of_week).equal?(0))
          @end_mode = DOM_MODE
        else
          if (@end_day_of_week > 0)
            @end_mode = DOW_IN_MONTH_MODE
          else
            @end_day_of_week = -@end_day_of_week
            if (@end_day > 0)
              @end_mode = DOW_GE_DOM_MODE
            else
              @end_day = -@end_day
              @end_mode = DOW_LE_DOM_MODE
            end
          end
          if (@end_day_of_week > Calendar::SATURDAY)
            raise IllegalArgumentException.new("Illegal end day of week " + RJava.cast_to_string(@end_day_of_week))
          end
        end
        if ((@end_mode).equal?(DOW_IN_MONTH_MODE))
          if (@end_day < -5 || @end_day > 5)
            raise IllegalArgumentException.new("Illegal end day of week in month " + RJava.cast_to_string(@end_day))
          end
        else
          if (@end_day < 1 || @end_day > StaticMonthLength[@end_month])
            raise IllegalArgumentException.new("Illegal end day " + RJava.cast_to_string(@end_day))
          end
        end
      end
    end
    
    typesig { [] }
    # Make rules compatible to 1.1 FCS code.  Since 1.1 FCS code only understands
    # day-of-week-in-month rules, we must modify other modes of rules to their
    # approximate equivalent in 1.1 FCS terms.  This method is used when streaming
    # out objects of this class.  After it is called, the rules will be modified,
    # with a possible loss of information.  startMode and endMode will NOT be
    # altered, even though semantically they should be set to DOW_IN_MONTH_MODE,
    # since the rule modification is only intended to be temporary.
    def make_rules_compatible
      case (@start_mode)
      when DOM_MODE
        @start_day = 1 + (@start_day / 7)
        @start_day_of_week = Calendar::SUNDAY
      when DOW_GE_DOM_MODE
        # A day-of-month of 1 is equivalent to DOW_IN_MONTH_MODE
        # that is, Sun>=1 == firstSun.
        if (!(@start_day).equal?(1))
          @start_day = 1 + (@start_day / 7)
        end
      when DOW_LE_DOM_MODE
        if (@start_day >= 30)
          @start_day = -1
        else
          @start_day = 1 + (@start_day / 7)
        end
      end
      case (@end_mode)
      when DOM_MODE
        @end_day = 1 + (@end_day / 7)
        @end_day_of_week = Calendar::SUNDAY
      when DOW_GE_DOM_MODE
        # A day-of-month of 1 is equivalent to DOW_IN_MONTH_MODE
        # that is, Sun>=1 == firstSun.
        if (!(@end_day).equal?(1))
          @end_day = 1 + (@end_day / 7)
        end
      when DOW_LE_DOM_MODE
        if (@end_day >= 30)
          @end_day = -1
        else
          @end_day = 1 + (@end_day / 7)
        end
      end
      # Adjust the start and end times to wall time.  This works perfectly
      # well unless it pushes into the next or previous day.  If that
      # happens, we attempt to adjust the day rule somewhat crudely.  The day
      # rules have been forced into DOW_IN_MONTH mode already, so we change
      # the day of week to move forward or back by a day.  It's possible to
      # make a more refined adjustment of the original rules first, but in
      # most cases this extra effort will go to waste once we adjust the day
      # rules anyway.
      case (@start_time_mode)
      when UTC_TIME
        @start_time += @raw_offset
      end
      while (@start_time < 0)
        @start_time += MillisPerDay
        @start_day_of_week = 1 + ((@start_day_of_week + 5) % 7) # Back 1 day
      end
      while (@start_time >= MillisPerDay)
        @start_time -= MillisPerDay
        @start_day_of_week = 1 + (@start_day_of_week % 7) # Forward 1 day
      end
      case (@end_time_mode)
      when UTC_TIME
        @end_time += @raw_offset + @dst_savings
      when STANDARD_TIME
        @end_time += @dst_savings
      end
      while (@end_time < 0)
        @end_time += MillisPerDay
        @end_day_of_week = 1 + ((@end_day_of_week + 5) % 7) # Back 1 day
      end
      while (@end_time >= MillisPerDay)
        @end_time -= MillisPerDay
        @end_day_of_week = 1 + (@end_day_of_week % 7) # Forward 1 day
      end
    end
    
    typesig { [] }
    # Pack the start and end rules into an array of bytes.  Only pack
    # data which is not preserved by makeRulesCompatible.
    def pack_rules
      rules = Array.typed(::Java::Byte).new(6) { 0 }
      rules[0] = @start_day
      rules[1] = @start_day_of_week
      rules[2] = @end_day
      rules[3] = @end_day_of_week
      # As of serial version 2, include time modes
      rules[4] = @start_time_mode
      rules[5] = @end_time_mode
      return rules
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Given an array of bytes produced by packRules, interpret them
    # as the start and end rules.
    def unpack_rules(rules)
      @start_day = rules[0]
      @start_day_of_week = rules[1]
      @end_day = rules[2]
      @end_day_of_week = rules[3]
      # As of serial version 2, include time modes
      if (rules.attr_length >= 6)
        @start_time_mode = rules[4]
        @end_time_mode = rules[5]
      end
    end
    
    typesig { [] }
    # Pack the start and end times into an array of bytes.  This is required
    # as of serial version 2.
    def pack_times
      times = Array.typed(::Java::Int).new(2) { 0 }
      times[0] = @start_time
      times[1] = @end_time
      return times
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # Unpack the start and end times from an array of bytes.  This is required
    # as of serial version 2.
    def unpack_times(times)
      @start_time = times[0]
      @end_time = times[1]
    end
    
    typesig { [ObjectOutputStream] }
    # Save the state of this object to a stream (i.e., serialize it).
    # 
    # @serialData We write out two formats, a JDK 1.1 compatible format, using
    # <code>DOW_IN_MONTH_MODE</code> rules, in the required section, followed
    # by the full rules, in packed format, in the optional section.  The
    # optional section will be ignored by JDK 1.1 code upon stream in.
    # <p> Contents of the optional section: The length of a byte array is
    # emitted (int); this is 4 as of this release. The byte array of the given
    # length is emitted. The contents of the byte array are the true values of
    # the fields <code>startDay</code>, <code>startDayOfWeek</code>,
    # <code>endDay</code>, and <code>endDayOfWeek</code>.  The values of these
    # fields in the required section are approximate values suited to the rule
    # mode <code>DOW_IN_MONTH_MODE</code>, which is the only mode recognized by
    # JDK 1.1.
    def write_object(stream)
      # Construct a binary rule
      rules = pack_rules
      times = pack_times
      # Convert to 1.1 FCS rules.  This step may cause us to lose information.
      make_rules_compatible
      # Write out the 1.1 FCS rules
      stream.default_write_object
      # Write out the binary rules in the optional data area of the stream.
      stream.write_int(rules.attr_length)
      stream.write(rules)
      stream.write_object(times)
      # Recover the original rules.  This recovers the information lost
      # by makeRulesCompatible.
      unpack_rules(rules)
      unpack_times(times)
    end
    
    typesig { [ObjectInputStream] }
    # Reconstitute this object from a stream (i.e., deserialize it).
    # 
    # We handle both JDK 1.1
    # binary formats and full formats with a packed byte array.
    def read_object(stream)
      stream.default_read_object
      if (@serial_version_on_stream < 1)
        # Fix a bug in the 1.1 SimpleTimeZone code -- namely,
        # startDayOfWeek and endDayOfWeek were usually uninitialized.  We can't do
        # too much, so we assume SUNDAY, which actually works most of the time.
        if ((@start_day_of_week).equal?(0))
          @start_day_of_week = Calendar::SUNDAY
        end
        if ((@end_day_of_week).equal?(0))
          @end_day_of_week = Calendar::SUNDAY
        end
        # The variables dstSavings, startMode, and endMode are post-1.1, so they
        # won't be present if we're reading from a 1.1 stream.  Fix them up.
        @start_mode = @end_mode = DOW_IN_MONTH_MODE
        @dst_savings = MillisPerHour
      else
        # For 1.1.4, in addition to the 3 new instance variables, we also
        # store the actual rules (which have not be made compatible with 1.1)
        # in the optional area.  Read them in here and parse them.
        length = stream.read_int
        rules = Array.typed(::Java::Byte).new(length) { 0 }
        stream.read_fully(rules)
        unpack_rules(rules)
      end
      if (@serial_version_on_stream >= 2)
        times = stream.read_object
        unpack_times(times)
      end
      @serial_version_on_stream = CurrentSerialVersion
    end
    
    private
    alias_method :initialize__simple_time_zone, :initialize
  end
  
end
