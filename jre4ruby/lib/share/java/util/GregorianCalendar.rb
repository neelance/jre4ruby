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
# (C) Copyright Taligent, Inc. 1996-1998 - All Rights Reserved
# (C) Copyright IBM Corp. 1996-1998 - All Rights Reserved
# 
# The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Util
  module GregorianCalendarImports
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
      include_const ::Sun::Util::Calendar, :JulianCalendar
      include_const ::Sun::Util::Calendar, :ZoneInfo
    }
  end
  
  # <code>GregorianCalendar</code> is a concrete subclass of
  # <code>Calendar</code> and provides the standard calendar system
  # used by most of the world.
  # 
  # <p> <code>GregorianCalendar</code> is a hybrid calendar that
  # supports both the Julian and Gregorian calendar systems with the
  # support of a single discontinuity, which corresponds by default to
  # the Gregorian date when the Gregorian calendar was instituted
  # (October 15, 1582 in some countries, later in others).  The cutover
  # date may be changed by the caller by calling {@link
  # #setGregorianChange(Date) setGregorianChange()}.
  # 
  # <p>
  # Historically, in those countries which adopted the Gregorian calendar first,
  # October 4, 1582 (Julian) was thus followed by October 15, 1582 (Gregorian). This calendar models
  # this correctly.  Before the Gregorian cutover, <code>GregorianCalendar</code>
  # implements the Julian calendar.  The only difference between the Gregorian
  # and the Julian calendar is the leap year rule. The Julian calendar specifies
  # leap years every four years, whereas the Gregorian calendar omits century
  # years which are not divisible by 400.
  # 
  # <p>
  # <code>GregorianCalendar</code> implements <em>proleptic</em> Gregorian and
  # Julian calendars. That is, dates are computed by extrapolating the current
  # rules indefinitely far backward and forward in time. As a result,
  # <code>GregorianCalendar</code> may be used for all years to generate
  # meaningful and consistent results. However, dates obtained using
  # <code>GregorianCalendar</code> are historically accurate only from March 1, 4
  # AD onward, when modern Julian calendar rules were adopted.  Before this date,
  # leap year rules were applied irregularly, and before 45 BC the Julian
  # calendar did not even exist.
  # 
  # <p>
  # Prior to the institution of the Gregorian calendar, New Year's Day was
  # March 25. To avoid confusion, this calendar always uses January 1. A manual
  # adjustment may be made if desired for dates that are prior to the Gregorian
  # changeover and which fall between January 1 and March 24.
  # 
  # <p>Values calculated for the <code>WEEK_OF_YEAR</code> field range from 1 to
  # 53.  Week 1 for a year is the earliest seven day period starting on
  # <code>getFirstDayOfWeek()</code> that contains at least
  # <code>getMinimalDaysInFirstWeek()</code> days from that year.  It thus
  # depends on the values of <code>getMinimalDaysInFirstWeek()</code>,
  # <code>getFirstDayOfWeek()</code>, and the day of the week of January 1.
  # Weeks between week 1 of one year and week 1 of the following year are
  # numbered sequentially from 2 to 52 or 53 (as needed).
  # 
  # <p>For example, January 1, 1998 was a Thursday.  If
  # <code>getFirstDayOfWeek()</code> is <code>MONDAY</code> and
  # <code>getMinimalDaysInFirstWeek()</code> is 4 (these are the values
  # reflecting ISO 8601 and many national standards), then week 1 of 1998 starts
  # on December 29, 1997, and ends on January 4, 1998.  If, however,
  # <code>getFirstDayOfWeek()</code> is <code>SUNDAY</code>, then week 1 of 1998
  # starts on January 4, 1998, and ends on January 10, 1998; the first three days
  # of 1998 then are part of week 53 of 1997.
  # 
  # <p>Values calculated for the <code>WEEK_OF_MONTH</code> field range from 0
  # to 6.  Week 1 of a month (the days with <code>WEEK_OF_MONTH =
  # 1</code>) is the earliest set of at least
  # <code>getMinimalDaysInFirstWeek()</code> contiguous days in that month,
  # ending on the day before <code>getFirstDayOfWeek()</code>.  Unlike
  # week 1 of a year, week 1 of a month may be shorter than 7 days, need
  # not start on <code>getFirstDayOfWeek()</code>, and will not include days of
  # the previous month.  Days of a month before week 1 have a
  # <code>WEEK_OF_MONTH</code> of 0.
  # 
  # <p>For example, if <code>getFirstDayOfWeek()</code> is <code>SUNDAY</code>
  # and <code>getMinimalDaysInFirstWeek()</code> is 4, then the first week of
  # January 1998 is Sunday, January 4 through Saturday, January 10.  These days
  # have a <code>WEEK_OF_MONTH</code> of 1.  Thursday, January 1 through
  # Saturday, January 3 have a <code>WEEK_OF_MONTH</code> of 0.  If
  # <code>getMinimalDaysInFirstWeek()</code> is changed to 3, then January 1
  # through January 3 have a <code>WEEK_OF_MONTH</code> of 1.
  # 
  # <p>The <code>clear</code> methods set calendar field(s)
  # undefined. <code>GregorianCalendar</code> uses the following
  # default value for each calendar field if its value is undefined.
  # 
  # <table cellpadding="0" cellspacing="3" border="0"
  # summary="GregorianCalendar default field values"
  # style="text-align: left; width: 66%;">
  # <tbody>
  # <tr>
  # <th style="vertical-align: top; background-color: rgb(204, 204, 255);
  # text-align: center;">Field<br>
  # </th>
  # <th style="vertical-align: top; background-color: rgb(204, 204, 255);
  # text-align: center;">Default Value<br>
  # </th>
  # </tr>
  # <tr>
  # <td style="vertical-align: middle;">
  # <code>ERA<br></code>
  # </td>
  # <td style="vertical-align: middle;">
  # <code>AD<br></code>
  # </td>
  # </tr>
  # <tr>
  # <td style="vertical-align: middle; background-color: rgb(238, 238, 255);">
  # <code>YEAR<br></code>
  # </td>
  # <td style="vertical-align: middle; background-color: rgb(238, 238, 255);">
  # <code>1970<br></code>
  # </td>
  # </tr>
  # <tr>
  # <td style="vertical-align: middle;">
  # <code>MONTH<br></code>
  # </td>
  # <td style="vertical-align: middle;">
  # <code>JANUARY<br></code>
  # </td>
  # </tr>
  # <tr>
  # <td style="vertical-align: top; background-color: rgb(238, 238, 255);">
  # <code>DAY_OF_MONTH<br></code>
  # </td>
  # <td style="vertical-align: top; background-color: rgb(238, 238, 255);">
  # <code>1<br></code>
  # </td>
  # </tr>
  # <tr>
  # <td style="vertical-align: middle;">
  # <code>DAY_OF_WEEK<br></code>
  # </td>
  # <td style="vertical-align: middle;">
  # <code>the first day of week<br></code>
  # </td>
  # </tr>
  # <tr>
  # <td style="vertical-align: top; background-color: rgb(238, 238, 255);">
  # <code>WEEK_OF_MONTH<br></code>
  # </td>
  # <td style="vertical-align: top; background-color: rgb(238, 238, 255);">
  # <code>0<br></code>
  # </td>
  # </tr>
  # <tr>
  # <td style="vertical-align: top;">
  # <code>DAY_OF_WEEK_IN_MONTH<br></code>
  # </td>
  # <td style="vertical-align: top;">
  # <code>1<br></code>
  # </td>
  # </tr>
  # <tr>
  # <td style="vertical-align: middle; background-color: rgb(238, 238, 255);">
  # <code>AM_PM<br></code>
  # </td>
  # <td style="vertical-align: middle; background-color: rgb(238, 238, 255);">
  # <code>AM<br></code>
  # </td>
  # </tr>
  # <tr>
  # <td style="vertical-align: middle;">
  # <code>HOUR, HOUR_OF_DAY, MINUTE, SECOND, MILLISECOND<br></code>
  # </td>
  # <td style="vertical-align: middle;">
  # <code>0<br></code>
  # </td>
  # </tr>
  # </tbody>
  # </table>
  # <br>Default values are not applicable for the fields not listed above.
  # 
  # <p>
  # <strong>Example:</strong>
  # <blockquote>
  # <pre>
  # // get the supported ids for GMT-08:00 (Pacific Standard Time)
  # String[] ids = TimeZone.getAvailableIDs(-8 * 60 * 60 * 1000);
  # // if no ids were returned, something is wrong. get out.
  # if (ids.length == 0)
  # System.exit(0);
  # 
  # // begin output
  # System.out.println("Current Time");
  # 
  # // create a Pacific Standard Time time zone
  # SimpleTimeZone pdt = new SimpleTimeZone(-8 * 60 * 60 * 1000, ids[0]);
  # 
  # // set up rules for daylight savings time
  # pdt.setStartRule(Calendar.APRIL, 1, Calendar.SUNDAY, 2 * 60 * 60 * 1000);
  # pdt.setEndRule(Calendar.OCTOBER, -1, Calendar.SUNDAY, 2 * 60 * 60 * 1000);
  # 
  # // create a GregorianCalendar with the Pacific Daylight time zone
  # // and the current date and time
  # Calendar calendar = new GregorianCalendar(pdt);
  # Date trialTime = new Date();
  # calendar.setTime(trialTime);
  # 
  # // print out a bunch of interesting things
  # System.out.println("ERA: " + calendar.get(Calendar.ERA));
  # System.out.println("YEAR: " + calendar.get(Calendar.YEAR));
  # System.out.println("MONTH: " + calendar.get(Calendar.MONTH));
  # System.out.println("WEEK_OF_YEAR: " + calendar.get(Calendar.WEEK_OF_YEAR));
  # System.out.println("WEEK_OF_MONTH: " + calendar.get(Calendar.WEEK_OF_MONTH));
  # System.out.println("DATE: " + calendar.get(Calendar.DATE));
  # System.out.println("DAY_OF_MONTH: " + calendar.get(Calendar.DAY_OF_MONTH));
  # System.out.println("DAY_OF_YEAR: " + calendar.get(Calendar.DAY_OF_YEAR));
  # System.out.println("DAY_OF_WEEK: " + calendar.get(Calendar.DAY_OF_WEEK));
  # System.out.println("DAY_OF_WEEK_IN_MONTH: "
  # + calendar.get(Calendar.DAY_OF_WEEK_IN_MONTH));
  # System.out.println("AM_PM: " + calendar.get(Calendar.AM_PM));
  # System.out.println("HOUR: " + calendar.get(Calendar.HOUR));
  # System.out.println("HOUR_OF_DAY: " + calendar.get(Calendar.HOUR_OF_DAY));
  # System.out.println("MINUTE: " + calendar.get(Calendar.MINUTE));
  # System.out.println("SECOND: " + calendar.get(Calendar.SECOND));
  # System.out.println("MILLISECOND: " + calendar.get(Calendar.MILLISECOND));
  # System.out.println("ZONE_OFFSET: "
  # + (calendar.get(Calendar.ZONE_OFFSET)/(60*60*1000)));
  # System.out.println("DST_OFFSET: "
  # + (calendar.get(Calendar.DST_OFFSET)/(60*60*1000)));
  # 
  # System.out.println("Current Time, with hour reset to 3");
  # calendar.clear(Calendar.HOUR_OF_DAY); // so doesn't override
  # calendar.set(Calendar.HOUR, 3);
  # System.out.println("ERA: " + calendar.get(Calendar.ERA));
  # System.out.println("YEAR: " + calendar.get(Calendar.YEAR));
  # System.out.println("MONTH: " + calendar.get(Calendar.MONTH));
  # System.out.println("WEEK_OF_YEAR: " + calendar.get(Calendar.WEEK_OF_YEAR));
  # System.out.println("WEEK_OF_MONTH: " + calendar.get(Calendar.WEEK_OF_MONTH));
  # System.out.println("DATE: " + calendar.get(Calendar.DATE));
  # System.out.println("DAY_OF_MONTH: " + calendar.get(Calendar.DAY_OF_MONTH));
  # System.out.println("DAY_OF_YEAR: " + calendar.get(Calendar.DAY_OF_YEAR));
  # System.out.println("DAY_OF_WEEK: " + calendar.get(Calendar.DAY_OF_WEEK));
  # System.out.println("DAY_OF_WEEK_IN_MONTH: "
  # + calendar.get(Calendar.DAY_OF_WEEK_IN_MONTH));
  # System.out.println("AM_PM: " + calendar.get(Calendar.AM_PM));
  # System.out.println("HOUR: " + calendar.get(Calendar.HOUR));
  # System.out.println("HOUR_OF_DAY: " + calendar.get(Calendar.HOUR_OF_DAY));
  # System.out.println("MINUTE: " + calendar.get(Calendar.MINUTE));
  # System.out.println("SECOND: " + calendar.get(Calendar.SECOND));
  # System.out.println("MILLISECOND: " + calendar.get(Calendar.MILLISECOND));
  # System.out.println("ZONE_OFFSET: "
  # + (calendar.get(Calendar.ZONE_OFFSET)/(60*60*1000))); // in hours
  # System.out.println("DST_OFFSET: "
  # + (calendar.get(Calendar.DST_OFFSET)/(60*60*1000))); // in hours
  # </pre>
  # </blockquote>
  # 
  # @see          TimeZone
  # @author David Goldsmith, Mark Davis, Chen-Lieh Huang, Alan Liu
  # @since JDK1.1
  class GregorianCalendar < GregorianCalendarImports.const_get :Calendar
    include_class_members GregorianCalendarImports
    
    class_module.module_eval {
      # Implementation Notes
      # 
      # The epoch is the number of days or milliseconds from some defined
      # starting point. The epoch for java.util.Date is used here; that is,
      # milliseconds from January 1, 1970 (Gregorian), midnight UTC.  Other
      # epochs which are used are January 1, year 1 (Gregorian), which is day 1
      # of the Gregorian calendar, and December 30, year 0 (Gregorian), which is
      # day 1 of the Julian calendar.
      # 
      # We implement the proleptic Julian and Gregorian calendars.  This means we
      # implement the modern definition of the calendar even though the
      # historical usage differs.  For example, if the Gregorian change is set
      # to new Date(Long.MIN_VALUE), we have a pure Gregorian calendar which
      # labels dates preceding the invention of the Gregorian calendar in 1582 as
      # if the calendar existed then.
      # 
      # Likewise, with the Julian calendar, we assume a consistent
      # 4-year leap year rule, even though the historical pattern of
      # leap years is irregular, being every 3 years from 45 BCE
      # through 9 BCE, then every 4 years from 8 CE onwards, with no
      # leap years in-between.  Thus date computations and functions
      # such as isLeapYear() are not intended to be historically
      # accurate.
      # 
      # ////////////////
      # Class Variables
      # ////////////////
      # 
      # Value of the <code>ERA</code> field indicating
      # the period before the common era (before Christ), also known as BCE.
      # The sequence of years at the transition from <code>BC</code> to <code>AD</code> is
      # ..., 2 BC, 1 BC, 1 AD, 2 AD,...
      # 
      # @see #ERA
      const_set_lazy(:BC) { 0 }
      const_attr_reader  :BC
      
      # Value of the {@link #ERA} field indicating
      # the period before the common era, the same value as {@link #BC}.
      # 
      # @see #CE
      const_set_lazy(:BCE) { 0 }
      const_attr_reader  :BCE
      
      # Value of the <code>ERA</code> field indicating
      # the common era (Anno Domini), also known as CE.
      # The sequence of years at the transition from <code>BC</code> to <code>AD</code> is
      # ..., 2 BC, 1 BC, 1 AD, 2 AD,...
      # 
      # @see #ERA
      const_set_lazy(:AD) { 1 }
      const_attr_reader  :AD
      
      # Value of the {@link #ERA} field indicating
      # the common era, the same value as {@link #AD}.
      # 
      # @see #BCE
      const_set_lazy(:CE) { 1 }
      const_attr_reader  :CE
      
      const_set_lazy(:EPOCH_OFFSET) { 719163 }
      const_attr_reader  :EPOCH_OFFSET
      
      # Fixed date of January 1, 1970 (Gregorian)
      const_set_lazy(:EPOCH_YEAR) { 1970 }
      const_attr_reader  :EPOCH_YEAR
      
      const_set_lazy(:MONTH_LENGTH) { Array.typed(::Java::Int).new([31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]) }
      const_attr_reader  :MONTH_LENGTH
      
      # 0-based
      const_set_lazy(:LEAP_MONTH_LENGTH) { Array.typed(::Java::Int).new([31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]) }
      const_attr_reader  :LEAP_MONTH_LENGTH
      
      # 0-based
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
      
      # <pre>
      # Greatest       Least
      # Field name        Minimum   Minimum     Maximum     Maximum
      # ----------        -------   -------     -------     -------
      # ERA                     0         0           1           1
      # YEAR                    1         1   292269054   292278994
      # MONTH                   0         0          11          11
      # WEEK_OF_YEAR            1         1          52*         53
      # WEEK_OF_MONTH           0         0           4*          6
      # DAY_OF_MONTH            1         1          28*         31
      # DAY_OF_YEAR             1         1         365*        366
      # DAY_OF_WEEK             1         1           7           7
      # DAY_OF_WEEK_IN_MONTH   -1        -1           4*          6
      # AM_PM                   0         0           1           1
      # HOUR                    0         0          11          11
      # HOUR_OF_DAY             0         0          23          23
      # MINUTE                  0         0          59          59
      # SECOND                  0         0          59          59
      # MILLISECOND             0         0         999         999
      # ZONE_OFFSET        -13:00    -13:00       14:00       14:00
      # DST_OFFSET           0:00      0:00        0:20        2:00
      # </pre>
      # *: depends on the Gregorian change date
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
      const_set_lazy(:MIN_VALUES) { Array.typed(::Java::Int).new([BCE, 1, JANUARY, 1, 0, 1, 1, SUNDAY, 1, AM, 0, 0, 0, 0, 0, -13 * ONE_HOUR, 0]) }
      const_attr_reader  :MIN_VALUES
      
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
      # DST_OFFSET (historical least maximum)
      const_set_lazy(:LEAST_MAX_VALUES) { Array.typed(::Java::Int).new([CE, 292269054, DECEMBER, 52, 4, 28, 365, SATURDAY, 4, PM, 11, 23, 59, 59, 999, 14 * ONE_HOUR, 20 * ONE_MINUTE]) }
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
      const_set_lazy(:MAX_VALUES) { Array.typed(::Java::Int).new([CE, 292278994, DECEMBER, 53, 6, 31, 366, SATURDAY, 6, PM, 11, 23, 59, 59, 999, 14 * ONE_HOUR, 2 * ONE_HOUR]) }
      const_attr_reader  :MAX_VALUES
      
      # Proclaim serialization compatibility with JDK 1.1
      const_set_lazy(:SerialVersionUID) { -8125100834729963327 }
      const_attr_reader  :SerialVersionUID
      
      # Reference to the sun.util.calendar.Gregorian instance (singleton).
      const_set_lazy(:Gcal) { CalendarSystem.get_gregorian_calendar }
      const_attr_reader  :Gcal
      
      # Reference to the JulianCalendar instance (singleton), set as needed. See
      # getJulianCalendarSystem().
      
      def jcal
        defined?(@@jcal) ? @@jcal : @@jcal= nil
      end
      alias_method :attr_jcal, :jcal
      
      def jcal=(value)
        @@jcal = value
      end
      alias_method :attr_jcal=, :jcal=
      
      # JulianCalendar eras. See getJulianCalendarSystem().
      
      def jeras
        defined?(@@jeras) ? @@jeras : @@jeras= nil
      end
      alias_method :attr_jeras, :jeras
      
      def jeras=(value)
        @@jeras = value
      end
      alias_method :attr_jeras=, :jeras=
      
      # The default value of gregorianCutover.
      const_set_lazy(:DEFAULT_GREGORIAN_CUTOVER) { -12219292800000 }
      const_attr_reader  :DEFAULT_GREGORIAN_CUTOVER
    }
    
    # ///////////////////
    # Instance Variables
    # ///////////////////
    # 
    # The point at which the Gregorian calendar rules are used, measured in
    # milliseconds from the standard epoch.  Default is October 15, 1582
    # (Gregorian) 00:00:00 UTC or -12219292800000L.  For this value, October 4,
    # 1582 (Julian) is followed by October 15, 1582 (Gregorian).  This
    # corresponds to Julian day number 2299161.
    # @serial
    attr_accessor :gregorian_cutover
    alias_method :attr_gregorian_cutover, :gregorian_cutover
    undef_method :gregorian_cutover
    alias_method :attr_gregorian_cutover=, :gregorian_cutover=
    undef_method :gregorian_cutover=
    
    # The fixed date of the gregorianCutover.
    attr_accessor :gregorian_cutover_date
    alias_method :attr_gregorian_cutover_date, :gregorian_cutover_date
    undef_method :gregorian_cutover_date
    alias_method :attr_gregorian_cutover_date=, :gregorian_cutover_date=
    undef_method :gregorian_cutover_date=
    
    # == 577736
    # 
    # The normalized year of the gregorianCutover in Gregorian, with
    # 0 representing 1 BCE, -1 representing 2 BCE, etc.
    attr_accessor :gregorian_cutover_year
    alias_method :attr_gregorian_cutover_year, :gregorian_cutover_year
    undef_method :gregorian_cutover_year
    alias_method :attr_gregorian_cutover_year=, :gregorian_cutover_year=
    undef_method :gregorian_cutover_year=
    
    # The normalized year of the gregorianCutover in Julian, with 0
    # representing 1 BCE, -1 representing 2 BCE, etc.
    attr_accessor :gregorian_cutover_year_julian
    alias_method :attr_gregorian_cutover_year_julian, :gregorian_cutover_year_julian
    undef_method :gregorian_cutover_year_julian
    alias_method :attr_gregorian_cutover_year_julian=, :gregorian_cutover_year_julian=
    undef_method :gregorian_cutover_year_julian=
    
    # gdate always has a sun.util.calendar.Gregorian.Date instance to
    # avoid overhead of creating it. The assumption is that most
    # applications will need only Gregorian calendar calculations.
    attr_accessor :gdate
    alias_method :attr_gdate, :gdate
    undef_method :gdate
    alias_method :attr_gdate=, :gdate=
    undef_method :gdate=
    
    # Reference to either gdate or a JulianCalendar.Date
    # instance. After calling complete(), this value is guaranteed to
    # be set.
    attr_accessor :cdate
    alias_method :attr_cdate, :cdate
    undef_method :cdate
    alias_method :attr_cdate=, :cdate=
    undef_method :cdate=
    
    # The CalendarSystem used to calculate the date in cdate. After
    # calling complete(), this value is guaranteed to be set and
    # consistent with the cdate value.
    attr_accessor :calsys
    alias_method :attr_calsys, :calsys
    undef_method :calsys
    alias_method :attr_calsys=, :calsys=
    undef_method :calsys=
    
    # Temporary int[2] to get time zone offsets. zoneOffsets[0] gets
    # the GMT offset value and zoneOffsets[1] gets the DST saving
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
    
    typesig { [] }
    # /////////////
    # Constructors
    # /////////////
    # 
    # Constructs a default <code>GregorianCalendar</code> using the current time
    # in the default time zone with the default locale.
    def initialize
      initialize__gregorian_calendar(TimeZone.get_default_ref, Locale.get_default)
      set_zone_shared(true)
    end
    
    typesig { [TimeZone] }
    # Constructs a <code>GregorianCalendar</code> based on the current time
    # in the given time zone with the default locale.
    # 
    # @param zone the given time zone.
    def initialize(zone)
      initialize__gregorian_calendar(zone, Locale.get_default)
    end
    
    typesig { [Locale] }
    # Constructs a <code>GregorianCalendar</code> based on the current time
    # in the default time zone with the given locale.
    # 
    # @param aLocale the given locale.
    def initialize(a_locale)
      initialize__gregorian_calendar(TimeZone.get_default_ref, a_locale)
      set_zone_shared(true)
    end
    
    typesig { [TimeZone, Locale] }
    # Constructs a <code>GregorianCalendar</code> based on the current time
    # in the given time zone with the given locale.
    # 
    # @param zone the given time zone.
    # @param aLocale the given locale.
    def initialize(zone, a_locale)
      @gregorian_cutover = 0
      @gregorian_cutover_date = 0
      @gregorian_cutover_year = 0
      @gregorian_cutover_year_julian = 0
      @gdate = nil
      @cdate = nil
      @calsys = nil
      @zone_offsets = nil
      @original_fields = nil
      @cached_fixed_date = 0
      super(zone, a_locale)
      @gregorian_cutover = DEFAULT_GREGORIAN_CUTOVER
      @gregorian_cutover_date = (((DEFAULT_GREGORIAN_CUTOVER + 1) / ONE_DAY) - 1) + EPOCH_OFFSET
      @gregorian_cutover_year = 1582
      @gregorian_cutover_year_julian = 1582
      @cached_fixed_date = Long::MIN_VALUE
      @gdate = Gcal.new_calendar_date(zone)
      set_time_in_millis(System.current_time_millis)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # Constructs a <code>GregorianCalendar</code> with the given date set
    # in the default time zone with the default locale.
    # 
    # @param year the value used to set the <code>YEAR</code> calendar field in the calendar.
    # @param month the value used to set the <code>MONTH</code> calendar field in the calendar.
    # Month value is 0-based. e.g., 0 for January.
    # @param dayOfMonth the value used to set the <code>DAY_OF_MONTH</code> calendar field in the calendar.
    def initialize(year, month, day_of_month)
      initialize__gregorian_calendar(year, month, day_of_month, 0, 0, 0, 0)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Constructs a <code>GregorianCalendar</code> with the given date
    # and time set for the default time zone with the default locale.
    # 
    # @param year the value used to set the <code>YEAR</code> calendar field in the calendar.
    # @param month the value used to set the <code>MONTH</code> calendar field in the calendar.
    # Month value is 0-based. e.g., 0 for January.
    # @param dayOfMonth the value used to set the <code>DAY_OF_MONTH</code> calendar field in the calendar.
    # @param hourOfDay the value used to set the <code>HOUR_OF_DAY</code> calendar field
    # in the calendar.
    # @param minute the value used to set the <code>MINUTE</code> calendar field
    # in the calendar.
    def initialize(year, month, day_of_month, hour_of_day, minute)
      initialize__gregorian_calendar(year, month, day_of_month, hour_of_day, minute, 0, 0)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Constructs a GregorianCalendar with the given date
    # and time set for the default time zone with the default locale.
    # 
    # @param year the value used to set the <code>YEAR</code> calendar field in the calendar.
    # @param month the value used to set the <code>MONTH</code> calendar field in the calendar.
    # Month value is 0-based. e.g., 0 for January.
    # @param dayOfMonth the value used to set the <code>DAY_OF_MONTH</code> calendar field in the calendar.
    # @param hourOfDay the value used to set the <code>HOUR_OF_DAY</code> calendar field
    # in the calendar.
    # @param minute the value used to set the <code>MINUTE</code> calendar field
    # in the calendar.
    # @param second the value used to set the <code>SECOND</code> calendar field
    # in the calendar.
    def initialize(year, month, day_of_month, hour_of_day, minute, second)
      initialize__gregorian_calendar(year, month, day_of_month, hour_of_day, minute, second, 0)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Constructs a <code>GregorianCalendar</code> with the given date
    # and time set for the default time zone with the default locale.
    # 
    # @param year the value used to set the <code>YEAR</code> calendar field in the calendar.
    # @param month the value used to set the <code>MONTH</code> calendar field in the calendar.
    # Month value is 0-based. e.g., 0 for January.
    # @param dayOfMonth the value used to set the <code>DAY_OF_MONTH</code> calendar field in the calendar.
    # @param hourOfDay the value used to set the <code>HOUR_OF_DAY</code> calendar field
    # in the calendar.
    # @param minute the value used to set the <code>MINUTE</code> calendar field
    # in the calendar.
    # @param second the value used to set the <code>SECOND</code> calendar field
    # in the calendar.
    # @param millis the value used to set the <code>MILLISECOND</code> calendar field
    def initialize(year, month, day_of_month, hour_of_day, minute, second, millis)
      @gregorian_cutover = 0
      @gregorian_cutover_date = 0
      @gregorian_cutover_year = 0
      @gregorian_cutover_year_julian = 0
      @gdate = nil
      @cdate = nil
      @calsys = nil
      @zone_offsets = nil
      @original_fields = nil
      @cached_fixed_date = 0
      super()
      @gregorian_cutover = DEFAULT_GREGORIAN_CUTOVER
      @gregorian_cutover_date = (((DEFAULT_GREGORIAN_CUTOVER + 1) / ONE_DAY) - 1) + EPOCH_OFFSET
      @gregorian_cutover_year = 1582
      @gregorian_cutover_year_julian = 1582
      @cached_fixed_date = Long::MIN_VALUE
      @gdate = Gcal.new_calendar_date(get_zone)
      self.set(YEAR, year)
      self.set(MONTH, month)
      self.set(DAY_OF_MONTH, day_of_month)
      # Set AM_PM and HOUR here to set their stamp values before
      # setting HOUR_OF_DAY (6178071).
      if (hour_of_day >= 12 && hour_of_day <= 23)
        # If hourOfDay is a valid PM hour, set the correct PM values
        # so that it won't throw an exception in case it's set to
        # non-lenient later.
        self.internal_set(AM_PM, PM)
        self.internal_set(HOUR, hour_of_day - 12)
      else
        # The default value for AM_PM is AM.
        # We don't care any out of range value here for leniency.
        self.internal_set(HOUR, hour_of_day)
      end
      # The stamp values of AM_PM and HOUR must be COMPUTED. (6440854)
      set_fields_computed(HOUR_MASK | AM_PM_MASK)
      self.set(HOUR_OF_DAY, hour_of_day)
      self.set(MINUTE, minute)
      self.set(SECOND, second)
      # should be changed to set() when this constructor is made
      # public.
      self.internal_set(MILLISECOND, millis)
    end
    
    typesig { [JavaDate] }
    # ///////////////
    # Public methods
    # ///////////////
    # 
    # Sets the <code>GregorianCalendar</code> change date. This is the point when the switch
    # from Julian dates to Gregorian dates occurred. Default is October 15,
    # 1582 (Gregorian). Previous to this, dates will be in the Julian calendar.
    # <p>
    # To obtain a pure Julian calendar, set the change date to
    # <code>Date(Long.MAX_VALUE)</code>.  To obtain a pure Gregorian calendar,
    # set the change date to <code>Date(Long.MIN_VALUE)</code>.
    # 
    # @param date the given Gregorian cutover date.
    def set_gregorian_change(date)
      cutover_time = date.get_time
      if ((cutover_time).equal?(@gregorian_cutover))
        return
      end
      # Before changing the cutover date, make sure to have the
      # time of this calendar.
      complete
      set_gregorian_change(cutover_time)
    end
    
    typesig { [::Java::Long] }
    def set_gregorian_change(cutover_time)
      @gregorian_cutover = cutover_time
      @gregorian_cutover_date = CalendarUtils.floor_divide(cutover_time, ONE_DAY) + EPOCH_OFFSET
      # To provide the "pure" Julian calendar as advertised.
      # Strictly speaking, the last millisecond should be a
      # Gregorian date. However, the API doc specifies that setting
      # the cutover date to Long.MAX_VALUE will make this calendar
      # a pure Julian calendar. (See 4167995)
      if ((cutover_time).equal?(Long::MAX_VALUE))
        @gregorian_cutover_date += 1
      end
      d = get_gregorian_cutover_date
      # Set the cutover year (in the Gregorian year numbering)
      @gregorian_cutover_year = d.get_year
      jcal = get_julian_calendar_system
      d = jcal.new_calendar_date(TimeZone::NO_TIMEZONE)
      jcal.get_calendar_date_from_fixed_date(d, @gregorian_cutover_date - 1)
      @gregorian_cutover_year_julian = d.get_normalized_year
      if (self.attr_time < @gregorian_cutover)
        # The field values are no longer valid under the new
        # cutover date.
        set_unnormalized
      end
    end
    
    typesig { [] }
    # Gets the Gregorian Calendar change date.  This is the point when the
    # switch from Julian dates to Gregorian dates occurred. Default is
    # October 15, 1582 (Gregorian). Previous to this, dates will be in the Julian
    # calendar.
    # 
    # @return the Gregorian cutover date for this <code>GregorianCalendar</code> object.
    def get_gregorian_change
      return JavaDate.new(@gregorian_cutover)
    end
    
    typesig { [::Java::Int] }
    # Determines if the given year is a leap year. Returns <code>true</code> if
    # the given year is a leap year. To specify BC year numbers,
    # <code>1 - year number</code> must be given. For example, year BC 4 is
    # specified as -3.
    # 
    # @param year the given year.
    # @return <code>true</code> if the given year is a leap year; <code>false</code> otherwise.
    def is_leap_year(year)
      if (!((year & 3)).equal?(0))
        return false
      end
      if (year > @gregorian_cutover_year)
        return (!(year % 100).equal?(0)) || ((year % 400).equal?(0)) # Gregorian
      end
      if (year < @gregorian_cutover_year_julian)
        return true # Julian
      end
      gregorian = false
      # If the given year is the Gregorian cutover year, we need to
      # determine which calendar system to be applied to February in the year.
      if ((@gregorian_cutover_year).equal?(@gregorian_cutover_year_julian))
        d = get_calendar_date(@gregorian_cutover_date) # Gregorian
        gregorian = d.get_month < BaseCalendar::MARCH
      else
        gregorian = (year).equal?(@gregorian_cutover_year)
      end
      return gregorian ? (!(year % 100).equal?(0)) || ((year % 400).equal?(0)) : true
    end
    
    typesig { [Object] }
    # Compares this <code>GregorianCalendar</code> to the specified
    # <code>Object</code>. The result is <code>true</code> if and
    # only if the argument is a <code>GregorianCalendar</code> object
    # that represents the same time value (millisecond offset from
    # the <a href="Calendar.html#Epoch">Epoch</a>) under the same
    # <code>Calendar</code> parameters and Gregorian change date as
    # this object.
    # 
    # @param obj the object to compare with.
    # @return <code>true</code> if this object is equal to <code>obj</code>;
    # <code>false</code> otherwise.
    # @see Calendar#compareTo(Calendar)
    def ==(obj)
      return obj.is_a?(GregorianCalendar) && super(obj) && (@gregorian_cutover).equal?((obj).attr_gregorian_cutover)
    end
    
    typesig { [] }
    # Generates the hash code for this <code>GregorianCalendar</code> object.
    def hash_code
      return super ^ RJava.cast_to_int(@gregorian_cutover_date)
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
        year = internal_get(YEAR)
        if ((internal_get_era).equal?(CE))
          year += amount
          if (year > 0)
            set(YEAR, year)
          else
            # year <= 0
            set(YEAR, 1 - year)
            # if year == 0, you get 1 BCE.
            set(ERA, BCE)
          end
        else
          # era == BCE
          year -= amount
          if (year > 0)
            set(YEAR, year)
          else
            # year <= 0
            set(YEAR, 1 - year)
            # if year == 0, you get 1 CE
            set(ERA, CE)
          end
        end
        pin_day_of_month
      else
        if ((field).equal?(MONTH))
          month = internal_get(MONTH) + amount
          year = internal_get(YEAR)
          y_amount = 0
          if (month >= 0)
            y_amount = month / 12
          else
            y_amount = (month + 1) / 12 - 1
          end
          if (!(y_amount).equal?(0))
            if ((internal_get_era).equal?(CE))
              year += y_amount
              if (year > 0)
                set(YEAR, year)
              else
                # year <= 0
                set(YEAR, 1 - year)
                # if year == 0, you get 1 BCE
                set(ERA, BCE)
              end
            else
              # era == BCE
              year -= y_amount
              if (year > 0)
                set(YEAR, year)
              else
                # year <= 0
                set(YEAR, 1 - year)
                # if year == 0, you get 1 CE
                set(ERA, CE)
              end
            end
          end
          if (month >= 0)
            set(MONTH, RJava.cast_to_int((month % 12)))
          else
            # month < 0
            month %= 12
            if (month < 0)
              month += 12
            end
            set(MONTH, JANUARY + month)
          end
          pin_day_of_month
        else
          if ((field).equal?(ERA))
            era = internal_get(ERA) + amount
            if (era < 0)
              era = 0
            end
            if (era > 1)
              era = 1
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
              delta *= 60 * 60 * 1000 # hours to minutes
            when MINUTE
              delta *= 60 * 1000 # minutes to seconds
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
            fd = get_current_fixed_date
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
              fd2 = get_current_fixed_date
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
    # Adds or subtracts (up/down) a single unit of time on the given time
    # field without changing larger fields.
    # <p>
    # <em>Example</em>: Consider a <code>GregorianCalendar</code>
    # originally set to December 31, 1999. Calling {@link #roll(int,boolean) roll(Calendar.MONTH, true)}
    # sets the calendar to January 31, 1999.  The <code>YEAR</code> field is unchanged
    # because it is a larger field than <code>MONTH</code>.</p>
    # 
    # @param up indicates if the value of the specified calendar field is to be
    # rolled up or rolled down. Use <code>true</code> if rolling up, <code>false</code> otherwise.
    # @exception IllegalArgumentException if <code>field</code> is
    # <code>ZONE_OFFSET</code>, <code>DST_OFFSET</code>, or unknown,
    # or if any calendar fields have out-of-range values in
    # non-lenient mode.
    # @see #add(int,int)
    # @see #set(int,int)
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
    # <p>
    # <em>Example</em>: Consider a <code>GregorianCalendar</code>
    # originally set to August 31, 1999. Calling <code>roll(Calendar.MONTH,
    # 8)</code> sets the calendar to April 30, <strong>1999</strong>. Using a
    # <code>GregorianCalendar</code>, the <code>DAY_OF_MONTH</code> field cannot
    # be 31 in the month April. <code>DAY_OF_MONTH</code> is set to the closest possible
    # value, 30. The <code>YEAR</code> field maintains the value of 1999 because it
    # is a larger field than <code>MONTH</code>.
    # <p>
    # <em>Example</em>: Consider a <code>GregorianCalendar</code>
    # originally set to Sunday June 6, 1999. Calling
    # <code>roll(Calendar.WEEK_OF_MONTH, -1)</code> sets the calendar to
    # Tuesday June 1, 1999, whereas calling
    # <code>add(Calendar.WEEK_OF_MONTH, -1)</code> sets the calendar to
    # Sunday May 30, 1999. This is because the roll rule imposes an
    # additional constraint: The <code>MONTH</code> must not change when the
    # <code>WEEK_OF_MONTH</code> is rolled. Taken together with add rule 1,
    # the resultant date must be between Tuesday June 1 and Saturday June
    # 5. According to add rule 2, the <code>DAY_OF_WEEK</code>, an invariant
    # when changing the <code>WEEK_OF_MONTH</code>, is set to Tuesday, the
    # closest possible value to Sunday (where Sunday is the first day of the
    # week).</p>
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
    # @since 1.2
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
      min = get_minimum(field)
      max = get_maximum(field)
      catch(:break_case) do
        case (field)
        when AM_PM, ERA, YEAR, MINUTE, SECOND, MILLISECOND
          # These fields are handled simply, since they have fixed minima
          # and maxima.  The field DAY_OF_MONTH is almost as simple.  Other
          # fields are complicated, since the range within they must roll
          # varies depending on the date.
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
          d = @calsys.get_calendar_date(self.attr_time, get_zone)
          if (!(internal_get(DAY_OF_MONTH)).equal?(d.get_day_of_month))
            d.set_date(internal_get(YEAR), internal_get(MONTH) + 1, internal_get(DAY_OF_MONTH))
            if ((field).equal?(HOUR))
              raise AssertError if not (((internal_get(AM_PM)).equal?(PM)))
              d.add_hours(+12) # restore PM
            end
            self.attr_time = @calsys.get_time(d)
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
        when MONTH
          # Rolling the month involves both pinning the final value to [0, 11]
          # and adjusting the DAY_OF_MONTH if necessary.  We only adjust the
          # DAY_OF_MONTH if, after updating the MONTH field, it is illegal.
          # E.g., <jan31>.roll(MONTH, 1) -> <feb28> or <feb29>.
          if (!is_cutover_year(@cdate.get_normalized_year))
            mon = (internal_get(MONTH) + amount) % 12
            if (mon < 0)
              mon += 12
            end
            set(MONTH, mon)
            # Keep the day of month in the range.  We don't want to spill over
            # into the next month; e.g., we don't want jan31 + 1 mo -> feb31 ->
            # mar3.
            month_len = month_length(mon)
            if (internal_get(DAY_OF_MONTH) > month_len)
              set(DAY_OF_MONTH, month_len)
            end
          else
            # We need to take care of different lengths in
            # year and month due to the cutover.
            year_length = get_actual_maximum(MONTH) + 1
            mon = (internal_get(MONTH) + amount) % year_length
            if (mon < 0)
              mon += year_length
            end
            set(MONTH, mon)
            month_len = get_actual_maximum(DAY_OF_MONTH)
            if (internal_get(DAY_OF_MONTH) > month_len)
              set(DAY_OF_MONTH, month_len)
            end
          end
          return
        when WEEK_OF_YEAR
          y = @cdate.get_normalized_year
          max = get_actual_maximum(WEEK_OF_YEAR)
          set(DAY_OF_WEEK, internal_get(DAY_OF_WEEK))
          woy = internal_get(WEEK_OF_YEAR)
          value = woy + amount
          if (!is_cutover_year(y))
            # If the new value is in between min and max
            # (exclusive), then we can use the value.
            if (value > min && value < max)
              set(WEEK_OF_YEAR, value)
              return
            end
            fd = get_current_fixed_date
            # Make sure that the min week has the current DAY_OF_WEEK
            day1 = fd - (7 * (woy - min))
            if (!(@calsys.get_year_from_fixed_date(day1)).equal?(y))
              min += 1
            end
            # Make sure the same thing for the max week
            fd += 7 * (max - internal_get(WEEK_OF_YEAR))
            if (!(@calsys.get_year_from_fixed_date(fd)).equal?(y))
              max -= 1
            end
            throw :break_case, :thrown
          end
          # Handle cutover here.
          fd = get_current_fixed_date
          cal = nil
          if ((@gregorian_cutover_year).equal?(@gregorian_cutover_year_julian))
            cal = get_cutover_calendar_system
          else
            if ((y).equal?(@gregorian_cutover_year))
              cal = Gcal
            else
              cal = get_julian_calendar_system
            end
          end
          day1 = fd - (7 * (woy - min))
          # Make sure that the min week has the current DAY_OF_WEEK
          if (!(cal.get_year_from_fixed_date(day1)).equal?(y))
            min += 1
          end
          # Make sure the same thing for the max week
          fd += 7 * (max - woy)
          cal = (fd >= @gregorian_cutover_date) ? Gcal : get_julian_calendar_system
          if (!(cal.get_year_from_fixed_date(fd)).equal?(y))
            max -= 1
          end
          # value: the new WEEK_OF_YEAR which must be converted
          # to month and day of month.
          value = get_rolled_value(woy, amount, min, max) - 1
          d = get_calendar_date(day1 + value * 7)
          set(MONTH, d.get_month - 1)
          set(DAY_OF_MONTH, d.get_day_of_month)
          return
        when WEEK_OF_MONTH
          is_cutover_year_ = is_cutover_year(@cdate.get_normalized_year)
          # dow: relative day of week from first day of week
          dow = internal_get(DAY_OF_WEEK) - get_first_day_of_week
          if (dow < 0)
            dow += 7
          end
          fd = get_current_fixed_date
          month1 = 0 # fixed date of the first day (usually 1) of the month
          month_length_ = 0 # actual month length
          if (is_cutover_year_)
            month1 = get_fixed_date_month1(@cdate, fd)
            month_length_ = actual_month_length
          else
            month1 = fd - internal_get(DAY_OF_MONTH) + 1
            month_length_ = @calsys.get_month_length(@cdate)
          end
          # the first day of week of the month.
          month_day1st = @calsys.get_day_of_week_date_on_or_before(month1 + 6, get_first_day_of_week)
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
          day_of_month = 0
          if (is_cutover_year_)
            # If we are in the cutover year, convert nfd to
            # its calendar date and use dayOfMonth.
            d = get_calendar_date(nfd)
            day_of_month = d.get_day_of_month
          else
            day_of_month = RJava.cast_to_int((nfd - month1)) + 1
          end
          set(DAY_OF_MONTH, day_of_month)
          return
        when DAY_OF_MONTH
          if (!is_cutover_year(@cdate.get_normalized_year))
            max = @calsys.get_month_length(@cdate)
            throw :break_case, :thrown
          end
          # Cutover year handling
          fd = get_current_fixed_date
          month1 = get_fixed_date_month1(@cdate, fd)
          # It may not be a regular month. Convert the date and range to
          # the relative values, perform the roll, and
          # convert the result back to the rolled date.
          value = get_rolled_value(RJava.cast_to_int((fd - month1)), amount, 0, actual_month_length - 1)
          d = get_calendar_date(month1 + value)
          raise AssertError if not ((d.get_month - 1).equal?(internal_get(MONTH)))
          set(DAY_OF_MONTH, d.get_day_of_month)
          return
        when DAY_OF_YEAR
          max = get_actual_maximum(field)
          if (!is_cutover_year(@cdate.get_normalized_year))
            throw :break_case, :thrown
          end
          # Handle cutover here.
          fd = get_current_fixed_date
          jan1 = fd - internal_get(DAY_OF_YEAR) + 1
          value = get_rolled_value(RJava.cast_to_int((fd - jan1)) + 1, amount, min, max)
          d = get_calendar_date(jan1 + value - 1)
          set(MONTH, d.get_month - 1)
          set(DAY_OF_MONTH, d.get_day_of_month)
          return
        when DAY_OF_WEEK
          if (!is_cutover_year(@cdate.get_normalized_year))
            # If the week of year is in the same year, we can
            # just change DAY_OF_WEEK.
            week_of_year = internal_get(WEEK_OF_YEAR)
            if (week_of_year > 1 && week_of_year < 52)
              set(WEEK_OF_YEAR, week_of_year) # update stamp[WEEK_OF_YEAR]
              max = SATURDAY
              throw :break_case, :thrown
            end
          end
          # We need to handle it in a different way around year
          # boundaries and in the cutover year. Note that
          # changing era and year values violates the roll
          # rule: not changing larger calendar fields...
          amount %= 7
          if ((amount).equal?(0))
            return
          end
          fd = get_current_fixed_date
          dow_first = @calsys.get_day_of_week_date_on_or_before(fd, get_first_day_of_week)
          fd += amount
          if (fd < dow_first)
            fd += 7
          else
            if (fd >= dow_first + 7)
              fd -= 7
            end
          end
          d = get_calendar_date(fd)
          set(ERA, (d.get_normalized_year <= 0 ? BCE : CE))
          set(d.get_year, d.get_month - 1, d.get_day_of_month)
          return
        when DAY_OF_WEEK_IN_MONTH
          min = 1 # after normalized, min should be 1.
          if (!is_cutover_year(@cdate.get_normalized_year))
            dom = internal_get(DAY_OF_MONTH)
            month_length_ = @calsys.get_month_length(@cdate)
            last_days = month_length_ % 7
            max = month_length_ / 7
            x = (dom - 1) % 7
            if (x < last_days)
              max += 1
            end
            set(DAY_OF_WEEK, internal_get(DAY_OF_WEEK))
            throw :break_case, :thrown
          end
          # Cutover year handling
          fd = get_current_fixed_date
          month1 = get_fixed_date_month1(@cdate, fd)
          month_length_ = actual_month_length
          last_days = month_length_ % 7
          max = month_length_ / 7
          x = RJava.cast_to_int((fd - month1)) % 7
          if (x < last_days)
            max += 1
          end
          value = get_rolled_value(internal_get(field), amount, min, max) - 1
          fd = month1 + value * 7 + x
          cal = (fd >= @gregorian_cutover_date) ? Gcal : get_julian_calendar_system
          d = cal.new_calendar_date(TimeZone::NO_TIMEZONE)
          cal.get_calendar_date_from_fixed_date(d, fd)
          set(DAY_OF_MONTH, d.get_day_of_month)
          return
        end
      end
      set(field, get_rolled_value(internal_get(field), amount, min, max))
    end
    
    typesig { [::Java::Int] }
    # Returns the minimum value for the given calendar field of this
    # <code>GregorianCalendar</code> instance. The minimum value is
    # defined as the smallest value returned by the {@link
    # Calendar#get(int) get} method for any possible time value,
    # taking into consideration the current values of the
    # {@link Calendar#getFirstDayOfWeek() getFirstDayOfWeek},
    # {@link Calendar#getMinimalDaysInFirstWeek() getMinimalDaysInFirstWeek},
    # {@link #getGregorianChange() getGregorianChange} and
    # {@link Calendar#getTimeZone() getTimeZone} methods.
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
    # {@link #getGregorianChange() getGregorianChange} and
    # {@link Calendar#getTimeZone() getTimeZone} methods.
    # 
    # @param field the calendar field.
    # @return the maximum value for the given calendar field.
    # @see #getMinimum(int)
    # @see #getGreatestMinimum(int)
    # @see #getLeastMaximum(int)
    # @see #getActualMinimum(int)
    # @see #getActualMaximum(int)
    def get_maximum(field)
      catch(:break_case) do
        case (field)
        when MONTH, DAY_OF_MONTH, DAY_OF_YEAR, WEEK_OF_YEAR, WEEK_OF_MONTH, DAY_OF_WEEK_IN_MONTH, YEAR
          # On or after Gregorian 200-3-1, Julian and Gregorian
          # calendar dates are the same or Gregorian dates are
          # larger (i.e., there is a "gap") after 300-3-1.
          if (@gregorian_cutover_year > 200)
            throw :break_case, :thrown
          end
          # There might be "overlapping" dates.
          gc = clone
          gc.set_lenient(true)
          gc.set_time_in_millis(@gregorian_cutover)
          v1 = gc.get_actual_maximum(field)
          gc.set_time_in_millis(@gregorian_cutover - 1)
          v2 = gc.get_actual_maximum(field)
          return Math.max(MAX_VALUES[field], Math.max(v1, v2))
        end
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
    # {@link #getGregorianChange() getGregorianChange} and
    # {@link Calendar#getTimeZone() getTimeZone} methods.
    # 
    # @param field the calendar field.
    # @return the highest minimum value for the given calendar field.
    # @see #getMinimum(int)
    # @see #getMaximum(int)
    # @see #getLeastMaximum(int)
    # @see #getActualMinimum(int)
    # @see #getActualMaximum(int)
    def get_greatest_minimum(field)
      if ((field).equal?(DAY_OF_MONTH))
        d = get_gregorian_cutover_date
        mon1 = get_fixed_date_month1(d, @gregorian_cutover_date)
        d = get_calendar_date(mon1)
        return Math.max(MIN_VALUES[field], d.get_day_of_month)
      end
      return MIN_VALUES[field]
    end
    
    typesig { [::Java::Int] }
    # Returns the lowest maximum value for the given calendar field
    # of this <code>GregorianCalendar</code> instance. The lowest
    # maximum value is defined as the smallest value returned by
    # {@link #getActualMaximum(int)} for any possible time value,
    # taking into consideration the current values of the
    # {@link Calendar#getFirstDayOfWeek() getFirstDayOfWeek},
    # {@link Calendar#getMinimalDaysInFirstWeek() getMinimalDaysInFirstWeek},
    # {@link #getGregorianChange() getGregorianChange} and
    # {@link Calendar#getTimeZone() getTimeZone} methods.
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
      when MONTH, DAY_OF_MONTH, DAY_OF_YEAR, WEEK_OF_YEAR, WEEK_OF_MONTH, DAY_OF_WEEK_IN_MONTH, YEAR
        gc = clone
        gc.set_lenient(true)
        gc.set_time_in_millis(@gregorian_cutover)
        v1 = gc.get_actual_maximum(field)
        gc.set_time_in_millis(@gregorian_cutover - 1)
        v2 = gc.get_actual_maximum(field)
        return Math.min(LEAST_MAX_VALUES[field], Math.min(v1, v2))
      end
      return LEAST_MAX_VALUES[field]
    end
    
    typesig { [::Java::Int] }
    # Returns the minimum value that this calendar field could have,
    # taking into consideration the given time value and the current
    # values of the
    # {@link Calendar#getFirstDayOfWeek() getFirstDayOfWeek},
    # {@link Calendar#getMinimalDaysInFirstWeek() getMinimalDaysInFirstWeek},
    # {@link #getGregorianChange() getGregorianChange} and
    # {@link Calendar#getTimeZone() getTimeZone} methods.
    # 
    # <p>For example, if the Gregorian change date is January 10,
    # 1970 and the date of this <code>GregorianCalendar</code> is
    # January 20, 1970, the actual minimum value of the
    # <code>DAY_OF_MONTH</code> field is 10 because the previous date
    # of January 10, 1970 is December 27, 1996 (in the Julian
    # calendar). Therefore, December 28, 1969 to January 9, 1970
    # don't exist.
    # 
    # @param field the calendar field
    # @return the minimum of the given field for the time value of
    # this <code>GregorianCalendar</code>
    # @see #getMinimum(int)
    # @see #getMaximum(int)
    # @see #getGreatestMinimum(int)
    # @see #getLeastMaximum(int)
    # @see #getActualMaximum(int)
    # @since 1.2
    def get_actual_minimum(field)
      if ((field).equal?(DAY_OF_MONTH))
        gc = get_normalized_calendar
        year = gc.attr_cdate.get_normalized_year
        if ((year).equal?(@gregorian_cutover_year) || (year).equal?(@gregorian_cutover_year_julian))
          month1 = get_fixed_date_month1(gc.attr_cdate, gc.attr_calsys.get_fixed_date(gc.attr_cdate))
          d = get_calendar_date(month1)
          return d.get_day_of_month
        end
      end
      return get_minimum(field)
    end
    
    typesig { [::Java::Int] }
    # Returns the maximum value that this calendar field could have,
    # taking into consideration the given time value and the current
    # values of the
    # {@link Calendar#getFirstDayOfWeek() getFirstDayOfWeek},
    # {@link Calendar#getMinimalDaysInFirstWeek() getMinimalDaysInFirstWeek},
    # {@link #getGregorianChange() getGregorianChange} and
    # {@link Calendar#getTimeZone() getTimeZone} methods.
    # For example, if the date of this instance is February 1, 2004,
    # the actual maximum value of the <code>DAY_OF_MONTH</code> field
    # is 29 because 2004 is a leap year, and if the date of this
    # instance is February 1, 2005, it's 28.
    # 
    # @param field the calendar field
    # @return the maximum of the given field for the time value of
    # this <code>GregorianCalendar</code>
    # @see #getMinimum(int)
    # @see #getMaximum(int)
    # @see #getGreatestMinimum(int)
    # @see #getLeastMaximum(int)
    # @see #getActualMinimum(int)
    # @since 1.2
    def get_actual_maximum(field)
      fields_for_fixed_max = ERA_MASK | DAY_OF_WEEK_MASK | HOUR_MASK | AM_PM_MASK | HOUR_OF_DAY_MASK | MINUTE_MASK | SECOND_MASK | MILLISECOND_MASK | ZONE_OFFSET_MASK | DST_OFFSET_MASK
      if (!((fields_for_fixed_max & (1 << field))).equal?(0))
        return get_maximum(field)
      end
      gc = get_normalized_calendar
      date = gc.attr_cdate
      cal = gc.attr_calsys
      normalized_year = date.get_normalized_year
      value = -1
      catch(:break_case) do
        case (field)
        when MONTH
          if (!gc.is_cutover_year(normalized_year))
            value = DECEMBER
            throw :break_case, :thrown
          end
          # January 1 of the next year may or may not exist.
          next_jan1 = 0
          begin
            next_jan1 = Gcal.get_fixed_date((normalized_year += 1), BaseCalendar::JANUARY, 1, nil)
          end while (next_jan1 < @gregorian_cutover_date)
          d = date.clone
          cal.get_calendar_date_from_fixed_date(d, next_jan1 - 1)
          value = d.get_month - 1
        when DAY_OF_MONTH
          value = cal.get_month_length(date)
          if (!gc.is_cutover_year(normalized_year) || (date.get_day_of_month).equal?(value))
            throw :break_case, :thrown
          end
          # Handle cutover year.
          fd = gc.get_current_fixed_date
          if (fd >= @gregorian_cutover_date)
            throw :break_case, :thrown
          end
          month_length_ = gc.actual_month_length
          month_end = gc.get_fixed_date_month1(gc.attr_cdate, fd) + month_length_ - 1
          # Convert the fixed date to its calendar date.
          d = gc.get_calendar_date(month_end)
          value = d.get_day_of_month
        when DAY_OF_YEAR
          if (!gc.is_cutover_year(normalized_year))
            value = cal.get_year_length(date)
            throw :break_case, :thrown
          end
          # Handle cutover year.
          jan1 = 0
          if ((@gregorian_cutover_year).equal?(@gregorian_cutover_year_julian))
            cocal = gc.get_cutover_calendar_system
            jan1 = cocal.get_fixed_date(normalized_year, 1, 1, nil)
          else
            if ((normalized_year).equal?(@gregorian_cutover_year_julian))
              jan1 = cal.get_fixed_date(normalized_year, 1, 1, nil)
            else
              jan1 = @gregorian_cutover_date
            end
          end
          # January 1 of the next year may or may not exist.
          next_jan1 = Gcal.get_fixed_date((normalized_year += 1), 1, 1, nil)
          if (next_jan1 < @gregorian_cutover_date)
            next_jan1 = @gregorian_cutover_date
          end
          raise AssertError if not (jan1 <= cal.get_fixed_date(date.get_normalized_year, date.get_month, date.get_day_of_month, date))
          raise AssertError if not (next_jan1 >= cal.get_fixed_date(date.get_normalized_year, date.get_month, date.get_day_of_month, date))
          value = RJava.cast_to_int((next_jan1 - jan1))
        when WEEK_OF_YEAR
          if (!gc.is_cutover_year(normalized_year))
            # Get the day of week of January 1 of the year
            d = cal.new_calendar_date(TimeZone::NO_TIMEZONE)
            d.set_date(date.get_year, BaseCalendar::JANUARY, 1)
            day_of_week = cal.get_day_of_week(d)
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
            throw :break_case, :thrown
          end
          if ((gc).equal?(self))
            gc = gc.clone
          end
          gc.set(DAY_OF_YEAR, get_actual_maximum(DAY_OF_YEAR))
          value = gc.get(WEEK_OF_YEAR)
        when WEEK_OF_MONTH
          if (!gc.is_cutover_year(normalized_year))
            d = cal.new_calendar_date(nil)
            d.set_date(date.get_year, date.get_month, 1)
            day_of_week = cal.get_day_of_week(d)
            month_length_ = cal.get_month_length(d)
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
            throw :break_case, :thrown
          end
          # Cutover year handling
          if ((gc).equal?(self))
            gc = gc.clone
          end
          y = gc.internal_get(YEAR)
          m = gc.internal_get(MONTH)
          begin
            value = gc.get(WEEK_OF_MONTH)
            gc.add(WEEK_OF_MONTH, +1)
          end while ((gc.get(YEAR)).equal?(y) && (gc.get(MONTH)).equal?(m))
        when DAY_OF_WEEK_IN_MONTH
          # may be in the Gregorian cutover month
          ndays = 0
          dow1 = 0
          dow = date.get_day_of_week
          if (!gc.is_cutover_year(normalized_year))
            d = date.clone
            ndays = cal.get_month_length(d)
            d.set_day_of_month(1)
            cal.normalize(d)
            dow1 = d.get_day_of_week
          else
            # Let a cloned GregorianCalendar take care of the cutover cases.
            if ((gc).equal?(self))
              gc = clone
            end
            ndays = gc.actual_month_length
            gc.set(DAY_OF_MONTH, gc.get_actual_minimum(DAY_OF_MONTH))
            dow1 = gc.get(DAY_OF_WEEK)
          end
          x = dow - dow1
          if (x < 0)
            x += 7
          end
          ndays -= x
          value = (ndays + 6) / 7
        when YEAR
          # The year computation is no different, in principle, from the
          # others, however, the range of possible maxima is large.  In
          # addition, the way we know we've exceeded the range is different.
          # For these reasons, we use the special case code below to handle
          # this field.
          # 
          # The actual maxima for YEAR depend on the type of calendar:
          # 
          # Gregorian = May 17, 292275056 BCE - Aug 17, 292278994 CE
          # Julian    = Dec  2, 292269055 BCE - Jan  3, 292272993 CE
          # Hybrid    = Dec  2, 292269055 BCE - Aug 17, 292278994 CE
          # 
          # We know we've exceeded the maximum when either the month, date,
          # time, or era changes in response to setting the year.  We don't
          # check for month, date, and time here because the year and era are
          # sufficient to detect an invalid year setting.  NOTE: If code is
          # added to check the month and date in the future for some reason,
          # Feb 29 must be allowed to shift to Mar 1 when setting the year.
          if ((gc).equal?(self))
            gc = clone
          end
          # Calculate the millisecond offset from the beginning
          # of the year of this calendar and adjust the max
          # year value if we are beyond the limit in the max
          # year.
          current = gc.get_year_offset_in_millis
          if ((gc.internal_get_era).equal?(CE))
            gc.set_time_in_millis(Long::MAX_VALUE)
            value = gc.get(YEAR)
            max_end = gc.get_year_offset_in_millis
            if (current > max_end)
              value -= 1
            end
          else
            mincal = gc.get_time_in_millis >= @gregorian_cutover ? Gcal : get_julian_calendar_system
            d = mincal.get_calendar_date(Long::MIN_VALUE, get_zone)
            max_end = (cal.get_day_of_year(d) - 1) * 24 + d.get_hours
            max_end *= 60
            max_end += d.get_minutes
            max_end *= 60
            max_end += d.get_seconds
            max_end *= 1000
            max_end += d.get_millis
            value = d.get_year
            if (value <= 0)
              raise AssertError if not ((mincal).equal?(Gcal))
              value = 1 - value
            end
            if (current < max_end)
              value -= 1
            end
          end
        else
          raise ArrayIndexOutOfBoundsException.new(field)
        end
      end
      return value
    end
    
    typesig { [] }
    # Returns the millisecond offset from the beginning of this
    # year. This Calendar object must have been normalized.
    def get_year_offset_in_millis
      t = (internal_get(DAY_OF_YEAR) - 1) * 24
      t += internal_get(HOUR_OF_DAY)
      t *= 60
      t += internal_get(MINUTE)
      t *= 60
      t += internal_get(SECOND)
      t *= 1000
      return t + internal_get(MILLISECOND) - (internal_get(ZONE_OFFSET) + internal_get(DST_OFFSET))
    end
    
    typesig { [] }
    def clone
      other = super
      other.attr_gdate = @gdate.clone
      if (!(@cdate).nil?)
        if (!(@cdate).equal?(@gdate))
          other.attr_cdate = @cdate.clone
        else
          other.attr_cdate = other.attr_gdate
        end
      end
      other.attr_original_fields = nil
      other.attr_zone_offsets = nil
      return other
    end
    
    typesig { [] }
    def get_time_zone
      zone = super
      # To share the zone by CalendarDates
      @gdate.set_zone(zone)
      if (!(@cdate).nil? && !(@cdate).equal?(@gdate))
        @cdate.set_zone(zone)
      end
      return zone
    end
    
    typesig { [TimeZone] }
    def set_time_zone(zone)
      super(zone)
      # To share the zone by CalendarDates
      @gdate.set_zone(zone)
      if (!(@cdate).nil? && !(@cdate).equal?(@gdate))
        @cdate.set_zone(zone)
      end
    end
    
    # ////////////////////
    # Proposed public API
    # ////////////////////
    # 
    # Returns the year that corresponds to the <code>WEEK_OF_YEAR</code> field.
    # This may be one year before or after the Gregorian or Julian year stored
    # in the <code>YEAR</code> field.  For example, January 1, 1999 is considered
    # Friday of week 53 of 1998 (if minimal days in first week is
    # 2 or less, and the first day of the week is Sunday).  Given
    # these same settings, the ISO year of January 1, 1999 is
    # 1998.
    # 
    # <p>This method calls {@link Calendar#complete} before
    # calculating the week-based year.
    # 
    # @return the year corresponding to the <code>WEEK_OF_YEAR</code> field, which
    # may be one year before or after the <code>YEAR</code> field.
    # @see #YEAR
    # @see #WEEK_OF_YEAR
    # 
    # 
    # public int getWeekBasedYear() {
    # complete();
    # // TODO: Below doesn't work for gregorian cutover...
    # int weekOfYear = internalGet(WEEK_OF_YEAR);
    # int year = internalGet(YEAR);
    # if (internalGet(MONTH) == Calendar.JANUARY) {
    # if (weekOfYear >= 52) {
    # --year;
    # }
    # } else {
    # if (weekOfYear == 1) {
    # ++year;
    # }
    # }
    # return year;
    # }
    # 
    # ///////////////////////////
    # Time => Fields computation
    # ///////////////////////////
    # 
    # The fixed date corresponding to gdate. If the value is
    # Long.MIN_VALUE, the fixed date value is unknown. Currently,
    # Julian calendar dates are not cached.
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
        # We have to call computTime in case calsys == null in
        # order to set calsys and cdate. (6263644)
        if (!(field_mask).equal?(0) || (@calsys).nil?)
          mask |= compute_fields(field_mask, mask & (ZONE_OFFSET_MASK | DST_OFFSET_MASK))
          raise AssertError if not ((mask).equal?(ALL_FIELDS))
        end
      else
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
      era = CE
      year = 0
      if (fixed_date >= @gregorian_cutover_date)
        # Handle Gregorian dates.
        raise AssertError, "cache control: not normalized" if not ((@cached_fixed_date).equal?(Long::MIN_VALUE) || @gdate.is_normalized)
        raise AssertError, "cache control: inconsictency" + ", cachedFixedDate=" + RJava.cast_to_string(@cached_fixed_date) + ", computed=" + RJava.cast_to_string(Gcal.get_fixed_date(@gdate.get_normalized_year, @gdate.get_month, @gdate.get_day_of_month, @gdate)) + ", date=" + RJava.cast_to_string(@gdate) if not ((@cached_fixed_date).equal?(Long::MIN_VALUE) || (Gcal.get_fixed_date(@gdate.get_normalized_year, @gdate.get_month, @gdate.get_day_of_month, @gdate)).equal?(@cached_fixed_date))
        # See if we can use gdate to avoid date calculation.
        if (!(fixed_date).equal?(@cached_fixed_date))
          Gcal.get_calendar_date_from_fixed_date(@gdate, fixed_date)
          @cached_fixed_date = fixed_date
        end
        year = @gdate.get_year
        if (year <= 0)
          year = 1 - year
          era = BCE
        end
        @calsys = Gcal
        @cdate = @gdate
        raise AssertError, "dow=" + RJava.cast_to_string(@cdate.get_day_of_week) + ", date=" + RJava.cast_to_string(@cdate) if not (@cdate.get_day_of_week > 0)
      else
        # Handle Julian calendar dates.
        @calsys = get_julian_calendar_system
        @cdate = self.attr_jcal.new_calendar_date(get_zone)
        self.attr_jcal.get_calendar_date_from_fixed_date(@cdate, fixed_date)
        e = @cdate.get_era
        if ((e).equal?(self.attr_jeras[0]))
          era = BCE
        end
        year = @cdate.get_year
      end
      # Always set the ERA and YEAR values.
      internal_set(ERA, era)
      internal_set(YEAR, year)
      mask = field_mask | (ERA_MASK | YEAR_MASK)
      month = @cdate.get_month - 1 # 0-based
      day_of_month = @cdate.get_day_of_month
      # Set the basic date fields.
      if (!((field_mask & (MONTH_MASK | DAY_OF_MONTH_MASK | DAY_OF_WEEK_MASK))).equal?(0))
        internal_set(MONTH, month)
        internal_set(DAY_OF_MONTH, day_of_month)
        internal_set(DAY_OF_WEEK, @cdate.get_day_of_week)
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
        normalized_year = @cdate.get_normalized_year
        fixed_date_jan1 = @calsys.get_fixed_date(normalized_year, 1, 1, @cdate)
        day_of_year = RJava.cast_to_int((fixed_date - fixed_date_jan1)) + 1
        fixed_date_month1 = fixed_date - day_of_month + 1
        cutover_gap = 0
        cutover_year = ((@calsys).equal?(Gcal)) ? @gregorian_cutover_year : @gregorian_cutover_year_julian
        relative_day_of_month = day_of_month - 1
        # If we are in the cutover year, we need some special handling.
        if ((normalized_year).equal?(cutover_year))
          # Need to take care of the "missing" days.
          if ((get_cutover_calendar_system).equal?(self.attr_jcal))
            # We need to find out where we are. The cutover
            # gap could even be more than one year.  (One
            # year difference in ~48667 years.)
            fixed_date_jan1 = get_fixed_date_jan1(@cdate, fixed_date)
            if (fixed_date >= @gregorian_cutover_date)
              fixed_date_month1 = get_fixed_date_month1(@cdate, fixed_date)
            end
          end
          real_day_of_year = RJava.cast_to_int((fixed_date - fixed_date_jan1)) + 1
          cutover_gap = day_of_year - real_day_of_year
          day_of_year = real_day_of_year
          relative_day_of_month = RJava.cast_to_int((fixed_date - fixed_date_month1))
        end
        internal_set(DAY_OF_YEAR, day_of_year)
        internal_set(DAY_OF_WEEK_IN_MONTH, relative_day_of_month / 7 + 1)
        week_of_year = get_week_number(fixed_date_jan1, fixed_date)
        # The spec is to calculate WEEK_OF_YEAR in the
        # ISO8601-style. This creates problems, though.
        if ((week_of_year).equal?(0))
          # If the date belongs to the last week of the
          # previous year, use the week number of "12/31" of
          # the "previous" year. Again, if the previous year is
          # the Gregorian cutover year, we need to take care of
          # it.  Usually the previous day of January 1 is
          # December 31, which is not always true in
          # GregorianCalendar.
          fixed_dec31 = fixed_date_jan1 - 1
          prev_jan1 = 0
          if (normalized_year > (cutover_year + 1))
            prev_jan1 = fixed_date_jan1 - 365
            if (CalendarUtils.is_gregorian_leap_year(normalized_year - 1))
              (prev_jan1 -= 1)
            end
          else
            cal_for_jan1 = @calsys
            prev_year = normalized_year - 1
            if ((prev_year).equal?(cutover_year))
              cal_for_jan1 = get_cutover_calendar_system
            end
            prev_jan1 = cal_for_jan1.get_fixed_date(prev_year, BaseCalendar::JANUARY, 1, nil)
            while (prev_jan1 > fixed_dec31)
              prev_jan1 = get_julian_calendar_system.get_fixed_date((prev_year -= 1), BaseCalendar::JANUARY, 1, nil)
            end
          end
          week_of_year = get_week_number(prev_jan1, fixed_dec31)
        else
          if (normalized_year > @gregorian_cutover_year || normalized_year < (@gregorian_cutover_year_julian - 1))
            # Regular years
            if (week_of_year >= 52)
              next_jan1 = fixed_date_jan1 + 365
              if (@cdate.is_leap_year)
                next_jan1 += 1
              end
              next_jan1st = @calsys.get_day_of_week_date_on_or_before(next_jan1 + 6, get_first_day_of_week)
              ndays = RJava.cast_to_int((next_jan1st - next_jan1))
              if (ndays >= get_minimal_days_in_first_week && fixed_date >= (next_jan1st - 7))
                # The first days forms a week in which the date is included.
                week_of_year = 1
              end
            end
          else
            cal_for_jan1 = @calsys
            next_year = normalized_year + 1
            if ((next_year).equal?((@gregorian_cutover_year_julian + 1)) && next_year < @gregorian_cutover_year)
              # In case the gap is more than one year.
              next_year = @gregorian_cutover_year
            end
            if ((next_year).equal?(@gregorian_cutover_year))
              cal_for_jan1 = get_cutover_calendar_system
            end
            next_jan1 = cal_for_jan1.get_fixed_date(next_year, BaseCalendar::JANUARY, 1, nil)
            if (next_jan1 < fixed_date)
              next_jan1 = @gregorian_cutover_date
              cal_for_jan1 = Gcal
            end
            next_jan1st = cal_for_jan1.get_day_of_week_date_on_or_before(next_jan1 + 6, get_first_day_of_week)
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
      # We can always use `gcal' since Julian and Gregorian are the
      # same thing for this calculation.
      fixed_day1st = Gcal.get_day_of_week_date_on_or_before(fixed_day1 + 6, get_first_day_of_week)
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
      # The year defaults to the epoch start. We don't check
      # fieldMask for YEAR because YEAR is a mandatory field to
      # determine the date.
      year = is_set(YEAR) ? internal_get(YEAR) : EPOCH_YEAR
      era = internal_get_era
      if ((era).equal?(BCE))
        year = 1 - year
      else
        if (!(era).equal?(CE))
          # Even in lenient mode we disallow ERA values other than CE & BCE.
          # (The same normalization rule as add()/roll() could be
          # applied here in lenient mode. But this checking is kept
          # unchanged for compatibility as of 1.5.)
          raise IllegalArgumentException.new("Invalid era")
        end
      end
      # If year is 0 or negative, we need to set the ERA value later.
      if (year <= 0 && !is_set(ERA))
        field_mask |= ERA_MASK
        set_fields_computed(ERA_MASK)
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
      catch(:break_calculate_fixed_date) do
        # Calculate the fixed date since January 1, 1 (Gregorian).
        gfd = 0
        jfd = 0
        if (year > @gregorian_cutover_year && year > @gregorian_cutover_year_julian)
          gfd = fixed_date + get_fixed_date(Gcal, year, field_mask)
          if (gfd >= @gregorian_cutover_date)
            fixed_date = gfd
            throw :break_calculate_fixed_date, :thrown
          end
          jfd = fixed_date + get_fixed_date(get_julian_calendar_system, year, field_mask)
        else
          if (year < @gregorian_cutover_year && year < @gregorian_cutover_year_julian)
            jfd = fixed_date + get_fixed_date(get_julian_calendar_system, year, field_mask)
            if (jfd < @gregorian_cutover_date)
              fixed_date = jfd
              throw :break_calculate_fixed_date, :thrown
            end
            gfd = jfd
          else
            gfd = fixed_date + get_fixed_date(Gcal, year, field_mask)
            jfd = fixed_date + get_fixed_date(get_julian_calendar_system, year, field_mask)
          end
        end
        # Now we have to determine which calendar date it is.
        if (gfd >= @gregorian_cutover_date)
          if (jfd >= @gregorian_cutover_date)
            fixed_date = gfd
          else
            # The date is in an "overlapping" period. No way
            # to disambiguate it. Determine it using the
            # previous date calculation.
            if ((@calsys).equal?(Gcal) || (@calsys).nil?)
              fixed_date = gfd
            else
              fixed_date = jfd
            end
          end
        else
          if (jfd < @gregorian_cutover_date)
            fixed_date = jfd
          else
            # The date is in a "missing" period.
            if (!is_lenient)
              raise IllegalArgumentException.new("the specified date doesn't exist")
            end
            # Take the Julian date for compatibility, which
            # will produce a Gregorian date.
            fixed_date = jfd
          end
        end
      end
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
          gmt_offset = is_field_set(field_mask, ZONE_OFFSET) ? internal_get(ZONE_OFFSET) : zone.get_raw_offset
          zone.get_offsets(millis - gmt_offset, @zone_offsets)
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
            # Restore the original field values
            System.arraycopy(@original_fields, 0, self.attr_fields, 0, self.attr_fields.attr_length)
            raise IllegalArgumentException.new(get_field_name(field))
          end
          field += 1
        end
      end
      set_fields_normalized(mask)
    end
    
    typesig { [BaseCalendar, ::Java::Int, ::Java::Int] }
    # Computes the fixed date under either the Gregorian or the
    # Julian calendar, using the given year and the specified calendar fields.
    # 
    # @param cal the CalendarSystem to be used for the date calculation
    # @param year the normalized year number, with 0 indicating the
    # year 1 BCE, -1 indicating 2 BCE, etc.
    # @param fieldMask the calendar fields to be used for the date calculation
    # @return the fixed date
    # @see Calendar#selectFields
    def get_fixed_date(cal, year, field_mask)
      month = JANUARY
      if (is_field_set(field_mask, MONTH))
        # No need to check if MONTH has been set (no isSet(MONTH)
        # call) since its unset value happens to be JANUARY (0).
        month = internal_get(MONTH)
        # If the month is out of range, adjust it into range
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
      end
      # Get the fixed date since Jan 1, 1 (Gregorian). We are on
      # the first day of either `month' or January in 'year'.
      fixed_date = cal.get_fixed_date(year, month + 1, 1, (cal).equal?(Gcal) ? @gdate : nil)
      if (is_field_set(field_mask, MONTH))
        # Month-based calculations
        if (is_field_set(field_mask, DAY_OF_MONTH))
          # We are on the first day of the month. Just add the
          # offset if DAY_OF_MONTH is set. If the isSet call
          # returns false, that means DAY_OF_MONTH has been
          # selected just because of the selected
          # combination. We don't need to add any since the
          # default value is the 1st.
          if (is_set(DAY_OF_MONTH))
            # To avoid underflow with DAY_OF_MONTH-1, add
            # DAY_OF_MONTH, then subtract 1.
            fixed_date += internal_get(DAY_OF_MONTH)
            fixed_date -= 1
          end
        else
          if (is_field_set(field_mask, WEEK_OF_MONTH))
            first_day_of_week = cal.get_day_of_week_date_on_or_before(fixed_date + 6, get_first_day_of_week)
            # If we have enough days in the first week, then
            # move to the previous week.
            if ((first_day_of_week - fixed_date) >= get_minimal_days_in_first_week)
              first_day_of_week -= 7
            end
            if (is_field_set(field_mask, DAY_OF_WEEK))
              first_day_of_week = cal.get_day_of_week_date_on_or_before(first_day_of_week + 6, internal_get(DAY_OF_WEEK))
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
              fixed_date = cal.get_day_of_week_date_on_or_before(fixed_date + (7 * dowim) - 1, day_of_week)
            else
              # Go to the first day of the next week of
              # the specified week boundary.
              last_date = month_length(month, year) + (7 * (dowim + 1))
              # Then, get the day of week date on or before the last date.
              fixed_date = cal.get_day_of_week_date_on_or_before(fixed_date + last_date - 1, day_of_week)
            end
          end
        end
      else
        if ((year).equal?(@gregorian_cutover_year) && (cal).equal?(Gcal) && fixed_date < @gregorian_cutover_date && !(@gregorian_cutover_year).equal?(@gregorian_cutover_year_julian))
          # January 1 of the year doesn't exist.  Use
          # gregorianCutoverDate as the first day of the
          # year.
          fixed_date = @gregorian_cutover_date
        end
        # We are on the first day of the year.
        if (is_field_set(field_mask, DAY_OF_YEAR))
          # Add the offset, then subtract 1. (Make sure to avoid underflow.)
          fixed_date += internal_get(DAY_OF_YEAR)
          fixed_date -= 1
        else
          first_day_of_week = cal.get_day_of_week_date_on_or_before(fixed_date + 6, get_first_day_of_week)
          # If we have enough days in the first week, then move
          # to the previous week.
          if ((first_day_of_week - fixed_date) >= get_minimal_days_in_first_week)
            first_day_of_week -= 7
          end
          if (is_field_set(field_mask, DAY_OF_WEEK))
            day_of_week = internal_get(DAY_OF_WEEK)
            if (!(day_of_week).equal?(get_first_day_of_week))
              first_day_of_week = cal.get_day_of_week_date_on_or_before(first_day_of_week + 6, day_of_week)
            end
          end
          fixed_date = first_day_of_week + 7 * (internal_get(WEEK_OF_YEAR) - 1)
        end
      end
      return fixed_date
    end
    
    typesig { [] }
    # Returns this object if it's normalized (all fields and time are
    # in sync). Otherwise, a cloned object is returned after calling
    # complete() in lenient mode.
    def get_normalized_calendar
      gc = nil
      if (is_fully_normalized)
        gc = self
      else
        # Create a clone and normalize the calendar fields
        gc = self.clone
        gc.set_lenient(true)
        gc.complete
      end
      return gc
    end
    
    class_module.module_eval {
      typesig { [] }
      # Returns the Julian calendar system instance (singleton). 'jcal'
      # and 'jeras' are set upon the return.
      def get_julian_calendar_system
        synchronized(self) do
          if ((self.attr_jcal).nil?)
            self.attr_jcal = CalendarSystem.for_name("julian")
            self.attr_jeras = self.attr_jcal.get_eras
          end
          return self.attr_jcal
        end
      end
    }
    
    typesig { [] }
    # Returns the calendar system for dates before the cutover date
    # in the cutover year. If the cutover date is January 1, the
    # method returns Gregorian. Otherwise, Julian.
    def get_cutover_calendar_system
      date = get_gregorian_cutover_date
      if ((date.get_month).equal?(BaseCalendar::JANUARY) && (date.get_day_of_month).equal?(1))
        return Gcal
      end
      return get_julian_calendar_system
    end
    
    typesig { [::Java::Int] }
    # Determines if the specified year (normalized) is the Gregorian
    # cutover year. This object must have been normalized.
    def is_cutover_year(normalized_year)
      cutover_year = ((@calsys).equal?(Gcal)) ? @gregorian_cutover_year : @gregorian_cutover_year_julian
      return (normalized_year).equal?(cutover_year)
    end
    
    typesig { [BaseCalendar::JavaDate, ::Java::Long] }
    # Returns the fixed date of the first day of the year (usually
    # January 1) before the specified date.
    # 
    # @param date the date for which the first day of the year is
    # calculated. The date has to be in the cut-over year (Gregorian
    # or Julian).
    # @param fixedDate the fixed date representation of the date
    def get_fixed_date_jan1(date, fixed_date)
      raise AssertError if not ((date.get_normalized_year).equal?(@gregorian_cutover_year) || (date.get_normalized_year).equal?(@gregorian_cutover_year_julian))
      if (!(@gregorian_cutover_year).equal?(@gregorian_cutover_year_julian))
        if (fixed_date >= @gregorian_cutover_date)
          # Dates before the cutover date don't exist
          # in the same (Gregorian) year. So, no
          # January 1 exists in the year. Use the
          # cutover date as the first day of the year.
          return @gregorian_cutover_date
        end
      end
      # January 1 of the normalized year should exist.
      jcal = get_julian_calendar_system
      return jcal.get_fixed_date(date.get_normalized_year, BaseCalendar::JANUARY, 1, nil)
    end
    
    typesig { [BaseCalendar::JavaDate, ::Java::Long] }
    # Returns the fixed date of the first date of the month (usually
    # the 1st of the month) before the specified date.
    # 
    # @param date the date for which the first day of the month is
    # calculated. The date has to be in the cut-over year (Gregorian
    # or Julian).
    # @param fixedDate the fixed date representation of the date
    def get_fixed_date_month1(date, fixed_date)
      raise AssertError if not ((date.get_normalized_year).equal?(@gregorian_cutover_year) || (date.get_normalized_year).equal?(@gregorian_cutover_year_julian))
      g_cutover = get_gregorian_cutover_date
      if ((g_cutover.get_month).equal?(BaseCalendar::JANUARY) && (g_cutover.get_day_of_month).equal?(1))
        # The cutover happened on January 1.
        return fixed_date - date.get_day_of_month + 1
      end
      fixed_date_month1 = 0
      # The cutover happened sometime during the year.
      if ((date.get_month).equal?(g_cutover.get_month))
        # The cutover happened in the month.
        j_last_date = get_last_julian_date
        if ((@gregorian_cutover_year).equal?(@gregorian_cutover_year_julian) && (g_cutover.get_month).equal?(j_last_date.get_month))
          # The "gap" fits in the same month.
          fixed_date_month1 = self.attr_jcal.get_fixed_date(date.get_normalized_year, date.get_month, 1, nil)
        else
          # Use the cutover date as the first day of the month.
          fixed_date_month1 = @gregorian_cutover_date
        end
      else
        # The cutover happened before the month.
        fixed_date_month1 = fixed_date - date.get_day_of_month + 1
      end
      return fixed_date_month1
    end
    
    typesig { [::Java::Long] }
    # Returns a CalendarDate produced from the specified fixed date.
    # 
    # @param fd the fixed date
    def get_calendar_date(fd)
      cal = (fd >= @gregorian_cutover_date) ? Gcal : get_julian_calendar_system
      d = cal.new_calendar_date(TimeZone::NO_TIMEZONE)
      cal.get_calendar_date_from_fixed_date(d, fd)
      return d
    end
    
    typesig { [] }
    # Returns the Gregorian cutover date as a BaseCalendar.Date. The
    # date is a Gregorian date.
    def get_gregorian_cutover_date
      return get_calendar_date(@gregorian_cutover_date)
    end
    
    typesig { [] }
    # Returns the day before the Gregorian cutover date as a
    # BaseCalendar.Date. The date is a Julian date.
    def get_last_julian_date
      return get_calendar_date(@gregorian_cutover_date - 1)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns the length of the specified month in the specified
    # year. The year number must be normalized.
    # 
    # @see #isLeapYear(int)
    def month_length(month, year)
      return is_leap_year(year) ? LEAP_MONTH_LENGTH[month] : MONTH_LENGTH[month]
    end
    
    typesig { [::Java::Int] }
    # Returns the length of the specified month in the year provided
    # by internalGet(YEAR).
    # 
    # @see #isLeapYear(int)
    def month_length(month)
      year = internal_get(YEAR)
      if ((internal_get_era).equal?(BCE))
        year = 1 - year
      end
      return month_length(month, year)
    end
    
    typesig { [] }
    def actual_month_length
      year = @cdate.get_normalized_year
      if (!(year).equal?(@gregorian_cutover_year) && !(year).equal?(@gregorian_cutover_year_julian))
        return @calsys.get_month_length(@cdate)
      end
      date = @cdate.clone
      fd = @calsys.get_fixed_date(date)
      month1 = get_fixed_date_month1(date, fd)
      next1 = month1 + @calsys.get_month_length(date)
      if (next1 < @gregorian_cutover_date)
        return RJava.cast_to_int((next1 - month1))
      end
      if (!(@cdate).equal?(@gdate))
        date = Gcal.new_calendar_date(TimeZone::NO_TIMEZONE)
      end
      Gcal.get_calendar_date_from_fixed_date(date, next1)
      next1 = get_fixed_date_month1(date, next1)
      return RJava.cast_to_int((next1 - month1))
    end
    
    typesig { [::Java::Int] }
    # Returns the length (in days) of the specified year. The year
    # must be normalized.
    def year_length(year)
      return is_leap_year(year) ? 366 : 365
    end
    
    typesig { [] }
    # Returns the length (in days) of the year provided by
    # internalGet(YEAR).
    def year_length
      year = internal_get(YEAR)
      if ((internal_get_era).equal?(BCE))
        year = 1 - year
      end
      return year_length(year)
    end
    
    typesig { [] }
    # After adjustments such as add(MONTH), add(YEAR), we don't want the
    # month to jump around.  E.g., we don't want Jan 31 + 1 month to go to Mar
    # 3, we want it to go to Feb 28.  Adjustments which might run into this
    # problem call this method to retain the proper month.
    def pin_day_of_month
      year = internal_get(YEAR)
      month_len = 0
      if (year > @gregorian_cutover_year || year < @gregorian_cutover_year_julian)
        month_len = month_length(internal_get(MONTH))
      else
        gc = get_normalized_calendar
        month_len = gc.get_actual_maximum(DAY_OF_MONTH)
      end
      dom = internal_get(DAY_OF_MONTH)
      if (dom > month_len)
        set(DAY_OF_MONTH, month_len)
      end
    end
    
    typesig { [] }
    # Returns the fixed date value of this object. The time value and
    # calendar fields must be in synch.
    def get_current_fixed_date
      return ((@calsys).equal?(Gcal)) ? @cached_fixed_date : @calsys.get_fixed_date(@cdate)
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
    # default ERA is CE, but a zero (unset) ERA is BCE.
    def internal_get_era
      return is_set(ERA) ? internal_get(ERA) : CE
    end
    
    typesig { [ObjectInputStream] }
    # Updates internal state.
    def read_object(stream)
      stream.default_read_object
      if ((@gdate).nil?)
        @gdate = Gcal.new_calendar_date(get_zone)
        @cached_fixed_date = Long::MIN_VALUE
      end
      set_gregorian_change(@gregorian_cutover)
    end
    
    private
    alias_method :initialize__gregorian_calendar, :initialize
  end
  
end
