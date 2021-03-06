require "rjava"

# Copyright 1996-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright Taligent, Inc. 1996-1998 - All Rights Reserved
# (C) Copyright IBM Corp. 1996-1998 - All Rights Reserved
# 
#   The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
#   Taligent is a registered trademark of Taligent, Inc.
module Java::Util
  module CalendarImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Io, :ObjectOutputStream
      include_const ::Java::Io, :OptionalDataException
      include_const ::Java::Io, :Serializable
      include_const ::Java::Security, :AccessControlContext
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PermissionCollection
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :ProtectionDomain
      include_const ::Java::Text, :DateFormat
      include_const ::Java::Text, :DateFormatSymbols
      include_const ::Sun::Util, :BuddhistCalendar
      include_const ::Sun::Util::Calendar, :ZoneInfo
      include_const ::Sun::Util::Resources, :LocaleData
    }
  end
  
  # The <code>Calendar</code> class is an abstract class that provides methods
  # for converting between a specific instant in time and a set of {@link
  # #fields calendar fields} such as <code>YEAR</code>, <code>MONTH</code>,
  # <code>DAY_OF_MONTH</code>, <code>HOUR</code>, and so on, and for
  # manipulating the calendar fields, such as getting the date of the next
  # week. An instant in time can be represented by a millisecond value that is
  # an offset from the <a name="Epoch"><em>Epoch</em></a>, January 1, 1970
  # 00:00:00.000 GMT (Gregorian).
  # 
  # <p>The class also provides additional fields and methods for
  # implementing a concrete calendar system outside the package. Those
  # fields and methods are defined as <code>protected</code>.
  # 
  # <p>
  # Like other locale-sensitive classes, <code>Calendar</code> provides a
  # class method, <code>getInstance</code>, for getting a generally useful
  # object of this type. <code>Calendar</code>'s <code>getInstance</code> method
  # returns a <code>Calendar</code> object whose
  # calendar fields have been initialized with the current date and time:
  # <blockquote>
  # <pre>
  #     Calendar rightNow = Calendar.getInstance();
  # </pre>
  # </blockquote>
  # 
  # <p>A <code>Calendar</code> object can produce all the calendar field values
  # needed to implement the date-time formatting for a particular language and
  # calendar style (for example, Japanese-Gregorian, Japanese-Traditional).
  # <code>Calendar</code> defines the range of values returned by
  # certain calendar fields, as well as their meaning.  For example,
  # the first month of the calendar system has value <code>MONTH ==
  # JANUARY</code> for all calendars.  Other values are defined by the
  # concrete subclass, such as <code>ERA</code>.  See individual field
  # documentation and subclass documentation for details.
  # 
  # <h4>Getting and Setting Calendar Field Values</h4>
  # 
  # <p>The calendar field values can be set by calling the <code>set</code>
  # methods. Any field values set in a <code>Calendar</code> will not be
  # interpreted until it needs to calculate its time value (milliseconds from
  # the Epoch) or values of the calendar fields. Calling the
  # <code>get</code>, <code>getTimeInMillis</code>, <code>getTime</code>,
  # <code>add</code> and <code>roll</code> involves such calculation.
  # 
  # <h4>Leniency</h4>
  # 
  # <p><code>Calendar</code> has two modes for interpreting the calendar
  # fields, <em>lenient</em> and <em>non-lenient</em>.  When a
  # <code>Calendar</code> is in lenient mode, it accepts a wider range of
  # calendar field values than it produces.  When a <code>Calendar</code>
  # recomputes calendar field values for return by <code>get()</code>, all of
  # the calendar fields are normalized. For example, a lenient
  # <code>GregorianCalendar</code> interprets <code>MONTH == JANUARY</code>,
  # <code>DAY_OF_MONTH == 32</code> as February 1.
  # 
  # <p>When a <code>Calendar</code> is in non-lenient mode, it throws an
  # exception if there is any inconsistency in its calendar fields. For
  # example, a <code>GregorianCalendar</code> always produces
  # <code>DAY_OF_MONTH</code> values between 1 and the length of the month. A
  # non-lenient <code>GregorianCalendar</code> throws an exception upon
  # calculating its time or calendar field values if any out-of-range field
  # value has been set.
  # 
  # <h4>First Week</h4>
  # 
  # <code>Calendar</code> defines a locale-specific seven day week using two
  # parameters: the first day of the week and the minimal days in first week
  # (from 1 to 7).  These numbers are taken from the locale resource data when a
  # <code>Calendar</code> is constructed.  They may also be specified explicitly
  # through the methods for setting their values.
  # 
  # <p>When setting or getting the <code>WEEK_OF_MONTH</code> or
  # <code>WEEK_OF_YEAR</code> fields, <code>Calendar</code> must determine the
  # first week of the month or year as a reference point.  The first week of a
  # month or year is defined as the earliest seven day period beginning on
  # <code>getFirstDayOfWeek()</code> and containing at least
  # <code>getMinimalDaysInFirstWeek()</code> days of that month or year.  Weeks
  # numbered ..., -1, 0 precede the first week; weeks numbered 2, 3,... follow
  # it.  Note that the normalized numbering returned by <code>get()</code> may be
  # different.  For example, a specific <code>Calendar</code> subclass may
  # designate the week before week 1 of a year as week <code><i>n</i></code> of
  # the previous year.
  # 
  # <h4>Calendar Fields Resolution</h4>
  # 
  # When computing a date and time from the calendar fields, there
  # may be insufficient information for the computation (such as only
  # year and month with no day of month), or there may be inconsistent
  # information (such as Tuesday, July 15, 1996 (Gregorian) -- July 15,
  # 1996 is actually a Monday). <code>Calendar</code> will resolve
  # calendar field values to determine the date and time in the
  # following way.
  # 
  # <p>If there is any conflict in calendar field values,
  # <code>Calendar</code> gives priorities to calendar fields that have been set
  # more recently. The following are the default combinations of the
  # calendar fields. The most recent combination, as determined by the
  # most recently set single field, will be used.
  # 
  # <p><a name="date_resolution">For the date fields</a>:
  # <blockquote>
  # <pre>
  # YEAR + MONTH + DAY_OF_MONTH
  # YEAR + MONTH + WEEK_OF_MONTH + DAY_OF_WEEK
  # YEAR + MONTH + DAY_OF_WEEK_IN_MONTH + DAY_OF_WEEK
  # YEAR + DAY_OF_YEAR
  # YEAR + DAY_OF_WEEK + WEEK_OF_YEAR
  # </pre></blockquote>
  # 
  # <a name="time_resolution">For the time of day fields</a>:
  # <blockquote>
  # <pre>
  # HOUR_OF_DAY
  # AM_PM + HOUR
  # </pre></blockquote>
  # 
  # <p>If there are any calendar fields whose values haven't been set in the selected
  # field combination, <code>Calendar</code> uses their default values. The default
  # value of each field may vary by concrete calendar systems. For example, in
  # <code>GregorianCalendar</code>, the default of a field is the same as that
  # of the start of the Epoch: i.e., <code>YEAR = 1970</code>, <code>MONTH =
  # JANUARY</code>, <code>DAY_OF_MONTH = 1</code>, etc.
  # 
  # <p>
  # <strong>Note:</strong> There are certain possible ambiguities in
  # interpretation of certain singular times, which are resolved in the
  # following ways:
  # <ol>
  #     <li> 23:59 is the last minute of the day and 00:00 is the first
  #          minute of the next day. Thus, 23:59 on Dec 31, 1999 &lt; 00:00 on
  #          Jan 1, 2000 &lt; 00:01 on Jan 1, 2000.
  # 
  #     <li> Although historically not precise, midnight also belongs to "am",
  #          and noon belongs to "pm", so on the same day,
  #          12:00 am (midnight) &lt; 12:01 am, and 12:00 pm (noon) &lt; 12:01 pm
  # </ol>
  # 
  # <p>
  # The date or time format strings are not part of the definition of a
  # calendar, as those must be modifiable or overridable by the user at
  # runtime. Use {@link DateFormat}
  # to format dates.
  # 
  # <h4>Field Manipulation</h4>
  # 
  # The calendar fields can be changed using three methods:
  # <code>set()</code>, <code>add()</code>, and <code>roll()</code>.</p>
  # 
  # <p><strong><code>set(f, value)</code></strong> changes calendar field
  # <code>f</code> to <code>value</code>.  In addition, it sets an
  # internal member variable to indicate that calendar field <code>f</code> has
  # been changed. Although calendar field <code>f</code> is changed immediately,
  # the calendar's time value in milliseconds is not recomputed until the next call to
  # <code>get()</code>, <code>getTime()</code>, <code>getTimeInMillis()</code>,
  # <code>add()</code>, or <code>roll()</code> is made. Thus, multiple calls to
  # <code>set()</code> do not trigger multiple, unnecessary
  # computations. As a result of changing a calendar field using
  # <code>set()</code>, other calendar fields may also change, depending on the
  # calendar field, the calendar field value, and the calendar system. In addition,
  # <code>get(f)</code> will not necessarily return <code>value</code> set by
  # the call to the <code>set</code> method
  # after the calendar fields have been recomputed. The specifics are determined by
  # the concrete calendar class.</p>
  # 
  # <p><em>Example</em>: Consider a <code>GregorianCalendar</code>
  # originally set to August 31, 1999. Calling <code>set(Calendar.MONTH,
  # Calendar.SEPTEMBER)</code> sets the date to September 31,
  # 1999. This is a temporary internal representation that resolves to
  # October 1, 1999 if <code>getTime()</code>is then called. However, a
  # call to <code>set(Calendar.DAY_OF_MONTH, 30)</code> before the call to
  # <code>getTime()</code> sets the date to September 30, 1999, since
  # no recomputation occurs after <code>set()</code> itself.</p>
  # 
  # <p><strong><code>add(f, delta)</code></strong> adds <code>delta</code>
  # to field <code>f</code>.  This is equivalent to calling <code>set(f,
  # get(f) + delta)</code> with two adjustments:</p>
  # 
  # <blockquote>
  #   <p><strong>Add rule 1</strong>. The value of field <code>f</code>
  #   after the call minus the value of field <code>f</code> before the
  #   call is <code>delta</code>, modulo any overflow that has occurred in
  #   field <code>f</code>. Overflow occurs when a field value exceeds its
  #   range and, as a result, the next larger field is incremented or
  #   decremented and the field value is adjusted back into its range.</p>
  # 
  #   <p><strong>Add rule 2</strong>. If a smaller field is expected to be
  #   invariant, but it is impossible for it to be equal to its
  #   prior value because of changes in its minimum or maximum after field
  #   <code>f</code> is changed or other constraints, such as time zone
  #   offset changes, then its value is adjusted to be as close
  #   as possible to its expected value. A smaller field represents a
  #   smaller unit of time. <code>HOUR</code> is a smaller field than
  #   <code>DAY_OF_MONTH</code>. No adjustment is made to smaller fields
  #   that are not expected to be invariant. The calendar system
  #   determines what fields are expected to be invariant.</p>
  # </blockquote>
  # 
  # <p>In addition, unlike <code>set()</code>, <code>add()</code> forces
  # an immediate recomputation of the calendar's milliseconds and all
  # fields.</p>
  # 
  # <p><em>Example</em>: Consider a <code>GregorianCalendar</code>
  # originally set to August 31, 1999. Calling <code>add(Calendar.MONTH,
  # 13)</code> sets the calendar to September 30, 2000. <strong>Add rule
  # 1</strong> sets the <code>MONTH</code> field to September, since
  # adding 13 months to August gives September of the next year. Since
  # <code>DAY_OF_MONTH</code> cannot be 31 in September in a
  # <code>GregorianCalendar</code>, <strong>add rule 2</strong> sets the
  # <code>DAY_OF_MONTH</code> to 30, the closest possible value. Although
  # it is a smaller field, <code>DAY_OF_WEEK</code> is not adjusted by
  # rule 2, since it is expected to change when the month changes in a
  # <code>GregorianCalendar</code>.</p>
  # 
  # <p><strong><code>roll(f, delta)</code></strong> adds
  # <code>delta</code> to field <code>f</code> without changing larger
  # fields. This is equivalent to calling <code>add(f, delta)</code> with
  # the following adjustment:</p>
  # 
  # <blockquote>
  #   <p><strong>Roll rule</strong>. Larger fields are unchanged after the
  #   call. A larger field represents a larger unit of
  #   time. <code>DAY_OF_MONTH</code> is a larger field than
  #   <code>HOUR</code>.</p>
  # </blockquote>
  # 
  # <p><em>Example</em>: See {@link java.util.GregorianCalendar#roll(int, int)}.
  # 
  # <p><strong>Usage model</strong>. To motivate the behavior of
  # <code>add()</code> and <code>roll()</code>, consider a user interface
  # component with increment and decrement buttons for the month, day, and
  # year, and an underlying <code>GregorianCalendar</code>. If the
  # interface reads January 31, 1999 and the user presses the month
  # increment button, what should it read? If the underlying
  # implementation uses <code>set()</code>, it might read March 3, 1999. A
  # better result would be February 28, 1999. Furthermore, if the user
  # presses the month increment button again, it should read March 31,
  # 1999, not March 28, 1999. By saving the original date and using either
  # <code>add()</code> or <code>roll()</code>, depending on whether larger
  # fields should be affected, the user interface can behave as most users
  # will intuitively expect.</p>
  # 
  # @see          java.lang.System#currentTimeMillis()
  # @see          Date
  # @see          GregorianCalendar
  # @see          TimeZone
  # @see          java.text.DateFormat
  # @author Mark Davis, David Goldsmith, Chen-Lieh Huang, Alan Liu
  # @since JDK1.1
  class Calendar 
    include_class_members CalendarImports
    include Serializable
    include Cloneable
    include JavaComparable
    
    class_module.module_eval {
      # Data flow in Calendar
      # ---------------------
      # The current time is represented in two ways by Calendar: as UTC
      # milliseconds from the epoch (1 January 1970 0:00 UTC), and as local
      # fields such as MONTH, HOUR, AM_PM, etc.  It is possible to compute the
      # millis from the fields, and vice versa.  The data needed to do this
      # conversion is encapsulated by a TimeZone object owned by the Calendar.
      # The data provided by the TimeZone object may also be overridden if the
      # user sets the ZONE_OFFSET and/or DST_OFFSET fields directly. The class
      # keeps track of what information was most recently set by the caller, and
      # uses that to compute any other information as needed.
      # If the user sets the fields using set(), the data flow is as follows.
      # This is implemented by the Calendar subclass's computeTime() method.
      # During this process, certain fields may be ignored.  The disambiguation
      # algorithm for resolving which fields to pay attention to is described
      # in the class documentation.
      #   local fields (YEAR, MONTH, DATE, HOUR, MINUTE, etc.)
      #           |
      #           | Using Calendar-specific algorithm
      #           V
      #   local standard millis
      #           |
      #           | Using TimeZone or user-set ZONE_OFFSET / DST_OFFSET
      #           V
      #   UTC millis (in time data member)
      # If the user sets the UTC millis using setTime() or setTimeInMillis(),
      # the data flow is as follows.  This is implemented by the Calendar
      # subclass's computeFields() method.
      #   UTC millis (in time data member)
      #           |
      #           | Using TimeZone getOffset()
      #           V
      #   local standard millis
      #           |
      #           | Using Calendar-specific algorithm
      #           V
      #   local fields (YEAR, MONTH, DATE, HOUR, MINUTE, etc.)
      # In general, a round trip from fields, through local and UTC millis, and
      # back out to fields is made when necessary.  This is implemented by the
      # complete() method.  Resolving a partial set of fields into a UTC millis
      # value allows all remaining fields to be generated from that value.  If
      # the Calendar is lenient, the fields are also renormalized to standard
      # ranges when they are regenerated.
      # Field number for <code>get</code> and <code>set</code> indicating the
      # era, e.g., AD or BC in the Julian calendar. This is a calendar-specific
      # value; see subclass documentation.
      # 
      # @see GregorianCalendar#AD
      # @see GregorianCalendar#BC
      const_set_lazy(:ERA) { 0 }
      const_attr_reader  :ERA
      
      # Field number for <code>get</code> and <code>set</code> indicating the
      # year. This is a calendar-specific value; see subclass documentation.
      const_set_lazy(:YEAR) { 1 }
      const_attr_reader  :YEAR
      
      # Field number for <code>get</code> and <code>set</code> indicating the
      # month. This is a calendar-specific value. The first month of
      # the year in the Gregorian and Julian calendars is
      # <code>JANUARY</code> which is 0; the last depends on the number
      # of months in a year.
      # 
      # @see #JANUARY
      # @see #FEBRUARY
      # @see #MARCH
      # @see #APRIL
      # @see #MAY
      # @see #JUNE
      # @see #JULY
      # @see #AUGUST
      # @see #SEPTEMBER
      # @see #OCTOBER
      # @see #NOVEMBER
      # @see #DECEMBER
      # @see #UNDECIMBER
      const_set_lazy(:MONTH) { 2 }
      const_attr_reader  :MONTH
      
      # Field number for <code>get</code> and <code>set</code> indicating the
      # week number within the current year.  The first week of the year, as
      # defined by <code>getFirstDayOfWeek()</code> and
      # <code>getMinimalDaysInFirstWeek()</code>, has value 1.  Subclasses define
      # the value of <code>WEEK_OF_YEAR</code> for days before the first week of
      # the year.
      # 
      # @see #getFirstDayOfWeek
      # @see #getMinimalDaysInFirstWeek
      const_set_lazy(:WEEK_OF_YEAR) { 3 }
      const_attr_reader  :WEEK_OF_YEAR
      
      # Field number for <code>get</code> and <code>set</code> indicating the
      # week number within the current month.  The first week of the month, as
      # defined by <code>getFirstDayOfWeek()</code> and
      # <code>getMinimalDaysInFirstWeek()</code>, has value 1.  Subclasses define
      # the value of <code>WEEK_OF_MONTH</code> for days before the first week of
      # the month.
      # 
      # @see #getFirstDayOfWeek
      # @see #getMinimalDaysInFirstWeek
      const_set_lazy(:WEEK_OF_MONTH) { 4 }
      const_attr_reader  :WEEK_OF_MONTH
      
      # Field number for <code>get</code> and <code>set</code> indicating the
      # day of the month. This is a synonym for <code>DAY_OF_MONTH</code>.
      # The first day of the month has value 1.
      # 
      # @see #DAY_OF_MONTH
      const_set_lazy(:DATE) { 5 }
      const_attr_reader  :DATE
      
      # Field number for <code>get</code> and <code>set</code> indicating the
      # day of the month. This is a synonym for <code>DATE</code>.
      # The first day of the month has value 1.
      # 
      # @see #DATE
      const_set_lazy(:DAY_OF_MONTH) { 5 }
      const_attr_reader  :DAY_OF_MONTH
      
      # Field number for <code>get</code> and <code>set</code> indicating the day
      # number within the current year.  The first day of the year has value 1.
      const_set_lazy(:DAY_OF_YEAR) { 6 }
      const_attr_reader  :DAY_OF_YEAR
      
      # Field number for <code>get</code> and <code>set</code> indicating the day
      # of the week.  This field takes values <code>SUNDAY</code>,
      # <code>MONDAY</code>, <code>TUESDAY</code>, <code>WEDNESDAY</code>,
      # <code>THURSDAY</code>, <code>FRIDAY</code>, and <code>SATURDAY</code>.
      # 
      # @see #SUNDAY
      # @see #MONDAY
      # @see #TUESDAY
      # @see #WEDNESDAY
      # @see #THURSDAY
      # @see #FRIDAY
      # @see #SATURDAY
      const_set_lazy(:DAY_OF_WEEK) { 7 }
      const_attr_reader  :DAY_OF_WEEK
      
      # Field number for <code>get</code> and <code>set</code> indicating the
      # ordinal number of the day of the week within the current month. Together
      # with the <code>DAY_OF_WEEK</code> field, this uniquely specifies a day
      # within a month.  Unlike <code>WEEK_OF_MONTH</code> and
      # <code>WEEK_OF_YEAR</code>, this field's value does <em>not</em> depend on
      # <code>getFirstDayOfWeek()</code> or
      # <code>getMinimalDaysInFirstWeek()</code>.  <code>DAY_OF_MONTH 1</code>
      # through <code>7</code> always correspond to <code>DAY_OF_WEEK_IN_MONTH
      # 1</code>; <code>8</code> through <code>14</code> correspond to
      # <code>DAY_OF_WEEK_IN_MONTH 2</code>, and so on.
      # <code>DAY_OF_WEEK_IN_MONTH 0</code> indicates the week before
      # <code>DAY_OF_WEEK_IN_MONTH 1</code>.  Negative values count back from the
      # end of the month, so the last Sunday of a month is specified as
      # <code>DAY_OF_WEEK = SUNDAY, DAY_OF_WEEK_IN_MONTH = -1</code>.  Because
      # negative values count backward they will usually be aligned differently
      # within the month than positive values.  For example, if a month has 31
      # days, <code>DAY_OF_WEEK_IN_MONTH -1</code> will overlap
      # <code>DAY_OF_WEEK_IN_MONTH 5</code> and the end of <code>4</code>.
      # 
      # @see #DAY_OF_WEEK
      # @see #WEEK_OF_MONTH
      const_set_lazy(:DAY_OF_WEEK_IN_MONTH) { 8 }
      const_attr_reader  :DAY_OF_WEEK_IN_MONTH
      
      # Field number for <code>get</code> and <code>set</code> indicating
      # whether the <code>HOUR</code> is before or after noon.
      # E.g., at 10:04:15.250 PM the <code>AM_PM</code> is <code>PM</code>.
      # 
      # @see #AM
      # @see #PM
      # @see #HOUR
      const_set_lazy(:AM_PM) { 9 }
      const_attr_reader  :AM_PM
      
      # Field number for <code>get</code> and <code>set</code> indicating the
      # hour of the morning or afternoon. <code>HOUR</code> is used for the
      # 12-hour clock (0 - 11). Noon and midnight are represented by 0, not by 12.
      # E.g., at 10:04:15.250 PM the <code>HOUR</code> is 10.
      # 
      # @see #AM_PM
      # @see #HOUR_OF_DAY
      const_set_lazy(:HOUR) { 10 }
      const_attr_reader  :HOUR
      
      # Field number for <code>get</code> and <code>set</code> indicating the
      # hour of the day. <code>HOUR_OF_DAY</code> is used for the 24-hour clock.
      # E.g., at 10:04:15.250 PM the <code>HOUR_OF_DAY</code> is 22.
      # 
      # @see #HOUR
      const_set_lazy(:HOUR_OF_DAY) { 11 }
      const_attr_reader  :HOUR_OF_DAY
      
      # Field number for <code>get</code> and <code>set</code> indicating the
      # minute within the hour.
      # E.g., at 10:04:15.250 PM the <code>MINUTE</code> is 4.
      const_set_lazy(:MINUTE) { 12 }
      const_attr_reader  :MINUTE
      
      # Field number for <code>get</code> and <code>set</code> indicating the
      # second within the minute.
      # E.g., at 10:04:15.250 PM the <code>SECOND</code> is 15.
      const_set_lazy(:SECOND) { 13 }
      const_attr_reader  :SECOND
      
      # Field number for <code>get</code> and <code>set</code> indicating the
      # millisecond within the second.
      # E.g., at 10:04:15.250 PM the <code>MILLISECOND</code> is 250.
      const_set_lazy(:MILLISECOND) { 14 }
      const_attr_reader  :MILLISECOND
      
      # Field number for <code>get</code> and <code>set</code>
      # indicating the raw offset from GMT in milliseconds.
      # <p>
      # This field reflects the correct GMT offset value of the time
      # zone of this <code>Calendar</code> if the
      # <code>TimeZone</code> implementation subclass supports
      # historical GMT offset changes.
      const_set_lazy(:ZONE_OFFSET) { 15 }
      const_attr_reader  :ZONE_OFFSET
      
      # Field number for <code>get</code> and <code>set</code> indicating the
      # daylight savings offset in milliseconds.
      # <p>
      # This field reflects the correct daylight saving offset value of
      # the time zone of this <code>Calendar</code> if the
      # <code>TimeZone</code> implementation subclass supports
      # historical Daylight Saving Time schedule changes.
      const_set_lazy(:DST_OFFSET) { 16 }
      const_attr_reader  :DST_OFFSET
      
      # The number of distinct fields recognized by <code>get</code> and <code>set</code>.
      # Field numbers range from <code>0..FIELD_COUNT-1</code>.
      const_set_lazy(:FIELD_COUNT) { 17 }
      const_attr_reader  :FIELD_COUNT
      
      # Value of the {@link #DAY_OF_WEEK} field indicating
      # Sunday.
      const_set_lazy(:SUNDAY) { 1 }
      const_attr_reader  :SUNDAY
      
      # Value of the {@link #DAY_OF_WEEK} field indicating
      # Monday.
      const_set_lazy(:MONDAY) { 2 }
      const_attr_reader  :MONDAY
      
      # Value of the {@link #DAY_OF_WEEK} field indicating
      # Tuesday.
      const_set_lazy(:TUESDAY) { 3 }
      const_attr_reader  :TUESDAY
      
      # Value of the {@link #DAY_OF_WEEK} field indicating
      # Wednesday.
      const_set_lazy(:WEDNESDAY) { 4 }
      const_attr_reader  :WEDNESDAY
      
      # Value of the {@link #DAY_OF_WEEK} field indicating
      # Thursday.
      const_set_lazy(:THURSDAY) { 5 }
      const_attr_reader  :THURSDAY
      
      # Value of the {@link #DAY_OF_WEEK} field indicating
      # Friday.
      const_set_lazy(:FRIDAY) { 6 }
      const_attr_reader  :FRIDAY
      
      # Value of the {@link #DAY_OF_WEEK} field indicating
      # Saturday.
      const_set_lazy(:SATURDAY) { 7 }
      const_attr_reader  :SATURDAY
      
      # Value of the {@link #MONTH} field indicating the
      # first month of the year in the Gregorian and Julian calendars.
      const_set_lazy(:JANUARY) { 0 }
      const_attr_reader  :JANUARY
      
      # Value of the {@link #MONTH} field indicating the
      # second month of the year in the Gregorian and Julian calendars.
      const_set_lazy(:FEBRUARY) { 1 }
      const_attr_reader  :FEBRUARY
      
      # Value of the {@link #MONTH} field indicating the
      # third month of the year in the Gregorian and Julian calendars.
      const_set_lazy(:MARCH) { 2 }
      const_attr_reader  :MARCH
      
      # Value of the {@link #MONTH} field indicating the
      # fourth month of the year in the Gregorian and Julian calendars.
      const_set_lazy(:APRIL) { 3 }
      const_attr_reader  :APRIL
      
      # Value of the {@link #MONTH} field indicating the
      # fifth month of the year in the Gregorian and Julian calendars.
      const_set_lazy(:MAY) { 4 }
      const_attr_reader  :MAY
      
      # Value of the {@link #MONTH} field indicating the
      # sixth month of the year in the Gregorian and Julian calendars.
      const_set_lazy(:JUNE) { 5 }
      const_attr_reader  :JUNE
      
      # Value of the {@link #MONTH} field indicating the
      # seventh month of the year in the Gregorian and Julian calendars.
      const_set_lazy(:JULY) { 6 }
      const_attr_reader  :JULY
      
      # Value of the {@link #MONTH} field indicating the
      # eighth month of the year in the Gregorian and Julian calendars.
      const_set_lazy(:AUGUST) { 7 }
      const_attr_reader  :AUGUST
      
      # Value of the {@link #MONTH} field indicating the
      # ninth month of the year in the Gregorian and Julian calendars.
      const_set_lazy(:SEPTEMBER) { 8 }
      const_attr_reader  :SEPTEMBER
      
      # Value of the {@link #MONTH} field indicating the
      # tenth month of the year in the Gregorian and Julian calendars.
      const_set_lazy(:OCTOBER) { 9 }
      const_attr_reader  :OCTOBER
      
      # Value of the {@link #MONTH} field indicating the
      # eleventh month of the year in the Gregorian and Julian calendars.
      const_set_lazy(:NOVEMBER) { 10 }
      const_attr_reader  :NOVEMBER
      
      # Value of the {@link #MONTH} field indicating the
      # twelfth month of the year in the Gregorian and Julian calendars.
      const_set_lazy(:DECEMBER) { 11 }
      const_attr_reader  :DECEMBER
      
      # Value of the {@link #MONTH} field indicating the
      # thirteenth month of the year. Although <code>GregorianCalendar</code>
      # does not use this value, lunar calendars do.
      const_set_lazy(:UNDECIMBER) { 12 }
      const_attr_reader  :UNDECIMBER
      
      # Value of the {@link #AM_PM} field indicating the
      # period of the day from midnight to just before noon.
      const_set_lazy(:AM) { 0 }
      const_attr_reader  :AM
      
      # Value of the {@link #AM_PM} field indicating the
      # period of the day from noon to just before midnight.
      const_set_lazy(:PM) { 1 }
      const_attr_reader  :PM
      
      # A style specifier for {@link #getDisplayNames(int, int, Locale)
      # getDisplayNames} indicating names in all styles, such as
      # "January" and "Jan".
      # 
      # @see #SHORT
      # @see #LONG
      # @since 1.6
      const_set_lazy(:ALL_STYLES) { 0 }
      const_attr_reader  :ALL_STYLES
      
      # A style specifier for {@link #getDisplayName(int, int, Locale)
      # getDisplayName} and {@link #getDisplayNames(int, int, Locale)
      # getDisplayNames} indicating a short name, such as "Jan".
      # 
      # @see #LONG
      # @since 1.6
      const_set_lazy(:SHORT) { 1 }
      const_attr_reader  :SHORT
      
      # A style specifier for {@link #getDisplayName(int, int, Locale)
      # getDisplayName} and {@link #getDisplayNames(int, int, Locale)
      # getDisplayNames} indicating a long name, such as "January".
      # 
      # @see #SHORT
      # @since 1.6
      const_set_lazy(:LONG) { 2 }
      const_attr_reader  :LONG
    }
    
    # Internal notes:
    # Calendar contains two kinds of time representations: current "time" in
    # milliseconds, and a set of calendar "fields" representing the current time.
    # The two representations are usually in sync, but can get out of sync
    # as follows.
    # 1. Initially, no fields are set, and the time is invalid.
    # 2. If the time is set, all fields are computed and in sync.
    # 3. If a single field is set, the time is invalid.
    # Recomputation of the time and fields happens when the object needs
    # to return a result to the user, or use a result for a computation.
    # The calendar field values for the currently set time for this calendar.
    # This is an array of <code>FIELD_COUNT</code> integers, with index values
    # <code>ERA</code> through <code>DST_OFFSET</code>.
    # @serial
    attr_accessor :fields
    alias_method :attr_fields, :fields
    undef_method :fields
    alias_method :attr_fields=, :fields=
    undef_method :fields=
    
    # The flags which tell if a specified calendar field for the calendar is set.
    # A new object has no fields set.  After the first call to a method
    # which generates the fields, they all remain set after that.
    # This is an array of <code>FIELD_COUNT</code> booleans, with index values
    # <code>ERA</code> through <code>DST_OFFSET</code>.
    # @serial
    attr_accessor :is_set
    alias_method :attr_is_set, :is_set
    undef_method :is_set
    alias_method :attr_is_set=, :is_set=
    undef_method :is_set=
    
    # Pseudo-time-stamps which specify when each field was set. There
    # are two special values, UNSET and COMPUTED. Values from
    # MINIMUM_USER_SET to Integer.MAX_VALUE are legal user set values.
    attr_accessor :stamp
    alias_method :attr_stamp, :stamp
    undef_method :stamp
    alias_method :attr_stamp=, :stamp=
    undef_method :stamp=
    
    # The currently set time for this calendar, expressed in milliseconds after
    # January 1, 1970, 0:00:00 GMT.
    # @see #isTimeSet
    # @serial
    attr_accessor :time
    alias_method :attr_time, :time
    undef_method :time
    alias_method :attr_time=, :time=
    undef_method :time=
    
    # True if then the value of <code>time</code> is valid.
    # The time is made invalid by a change to an item of <code>field[]</code>.
    # @see #time
    # @serial
    attr_accessor :is_time_set
    alias_method :attr_is_time_set, :is_time_set
    undef_method :is_time_set
    alias_method :attr_is_time_set=, :is_time_set=
    undef_method :is_time_set=
    
    # True if <code>fields[]</code> are in sync with the currently set time.
    # If false, then the next attempt to get the value of a field will
    # force a recomputation of all fields from the current value of
    # <code>time</code>.
    # @serial
    attr_accessor :are_fields_set
    alias_method :attr_are_fields_set, :are_fields_set
    undef_method :are_fields_set
    alias_method :attr_are_fields_set=, :are_fields_set=
    undef_method :are_fields_set=
    
    # True if all fields have been set.
    # @serial
    attr_accessor :are_all_fields_set
    alias_method :attr_are_all_fields_set, :are_all_fields_set
    undef_method :are_all_fields_set
    alias_method :attr_are_all_fields_set=, :are_all_fields_set=
    undef_method :are_all_fields_set=
    
    # <code>True</code> if this calendar allows out-of-range field values during computation
    # of <code>time</code> from <code>fields[]</code>.
    # @see #setLenient
    # @see #isLenient
    # @serial
    attr_accessor :lenient
    alias_method :attr_lenient, :lenient
    undef_method :lenient
    alias_method :attr_lenient=, :lenient=
    undef_method :lenient=
    
    # The <code>TimeZone</code> used by this calendar. <code>Calendar</code>
    # uses the time zone data to translate between locale and GMT time.
    # @serial
    attr_accessor :zone
    alias_method :attr_zone, :zone
    undef_method :zone
    alias_method :attr_zone=, :zone=
    undef_method :zone=
    
    # <code>True</code> if zone references to a shared TimeZone object.
    attr_accessor :shared_zone
    alias_method :attr_shared_zone, :shared_zone
    undef_method :shared_zone
    alias_method :attr_shared_zone=, :shared_zone=
    undef_method :shared_zone=
    
    # The first day of the week, with possible values <code>SUNDAY</code>,
    # <code>MONDAY</code>, etc.  This is a locale-dependent value.
    # @serial
    attr_accessor :first_day_of_week
    alias_method :attr_first_day_of_week, :first_day_of_week
    undef_method :first_day_of_week
    alias_method :attr_first_day_of_week=, :first_day_of_week=
    undef_method :first_day_of_week=
    
    # The number of days required for the first week in a month or year,
    # with possible values from 1 to 7.  This is a locale-dependent value.
    # @serial
    attr_accessor :minimal_days_in_first_week
    alias_method :attr_minimal_days_in_first_week, :minimal_days_in_first_week
    undef_method :minimal_days_in_first_week
    alias_method :attr_minimal_days_in_first_week=, :minimal_days_in_first_week=
    undef_method :minimal_days_in_first_week=
    
    class_module.module_eval {
      # Cache to hold the firstDayOfWeek and minimalDaysInFirstWeek
      # of a Locale.
      
      def cached_locale_data
        defined?(@@cached_locale_data) ? @@cached_locale_data : @@cached_locale_data= Hashtable.new(3)
      end
      alias_method :attr_cached_locale_data, :cached_locale_data
      
      def cached_locale_data=(value)
        @@cached_locale_data = value
      end
      alias_method :attr_cached_locale_data=, :cached_locale_data=
      
      # Special values of stamp[]
      # The corresponding fields[] has no value.
      const_set_lazy(:UNSET) { 0 }
      const_attr_reader  :UNSET
      
      # The value of the corresponding fields[] has been calculated internally.
      const_set_lazy(:COMPUTED) { 1 }
      const_attr_reader  :COMPUTED
      
      # The value of the corresponding fields[] has been set externally. Stamp
      # values which are greater than 1 represents the (pseudo) time when the
      # corresponding fields[] value was set.
      const_set_lazy(:MINIMUM_USER_STAMP) { 2 }
      const_attr_reader  :MINIMUM_USER_STAMP
      
      # The mask value that represents all of the fields.
      const_set_lazy(:ALL_FIELDS) { (1 << FIELD_COUNT) - 1 }
      const_attr_reader  :ALL_FIELDS
    }
    
    # The next available value for <code>stamp[]</code>, an internal array.
    # This actually should not be written out to the stream, and will probably
    # be removed from the stream in the near future.  In the meantime,
    # a value of <code>MINIMUM_USER_STAMP</code> should be used.
    # @serial
    attr_accessor :next_stamp
    alias_method :attr_next_stamp, :next_stamp
    undef_method :next_stamp
    alias_method :attr_next_stamp=, :next_stamp=
    undef_method :next_stamp=
    
    class_module.module_eval {
      # the internal serial version which says which version was written
      # - 0 (default) for version up to JDK 1.1.5
      # - 1 for version from JDK 1.1.6, which writes a correct 'time' value
      #     as well as compatible values for other fields.  This is a
      #     transitional format.
      # - 2 (not implemented yet) a future version, in which fields[],
      #     areFieldsSet, and isTimeSet become transient, and isSet[] is
      #     removed. In JDK 1.1.6 we write a format compatible with version 2.
      const_set_lazy(:CurrentSerialVersion) { 1 }
      const_attr_reader  :CurrentSerialVersion
    }
    
    # The version of the serialized data on the stream.  Possible values:
    # <dl>
    # <dt><b>0</b> or not present on stream</dt>
    # <dd>
    # JDK 1.1.5 or earlier.
    # </dd>
    # <dt><b>1</b></dt>
    # <dd>
    # JDK 1.1.6 or later.  Writes a correct 'time' value
    # as well as compatible values for other fields.  This is a
    # transitional format.
    # </dd>
    # </dl>
    # When streaming out this class, the most recent format
    # and the highest allowable <code>serialVersionOnStream</code>
    # is written.
    # @serial
    # @since JDK1.1.6
    attr_accessor :serial_version_on_stream
    alias_method :attr_serial_version_on_stream, :serial_version_on_stream
    undef_method :serial_version_on_stream
    alias_method :attr_serial_version_on_stream=, :serial_version_on_stream=
    undef_method :serial_version_on_stream=
    
    class_module.module_eval {
      # Proclaim serialization compatibility with JDK 1.1
      const_set_lazy(:SerialVersionUID) { -1807547505821590642 }
      const_attr_reader  :SerialVersionUID
      
      # Mask values for calendar fields
      const_set_lazy(:ERA_MASK) { (1 << ERA) }
      const_attr_reader  :ERA_MASK
      
      const_set_lazy(:YEAR_MASK) { (1 << YEAR) }
      const_attr_reader  :YEAR_MASK
      
      const_set_lazy(:MONTH_MASK) { (1 << MONTH) }
      const_attr_reader  :MONTH_MASK
      
      const_set_lazy(:WEEK_OF_YEAR_MASK) { (1 << WEEK_OF_YEAR) }
      const_attr_reader  :WEEK_OF_YEAR_MASK
      
      const_set_lazy(:WEEK_OF_MONTH_MASK) { (1 << WEEK_OF_MONTH) }
      const_attr_reader  :WEEK_OF_MONTH_MASK
      
      const_set_lazy(:DAY_OF_MONTH_MASK) { (1 << DAY_OF_MONTH) }
      const_attr_reader  :DAY_OF_MONTH_MASK
      
      const_set_lazy(:DATE_MASK) { DAY_OF_MONTH_MASK }
      const_attr_reader  :DATE_MASK
      
      const_set_lazy(:DAY_OF_YEAR_MASK) { (1 << DAY_OF_YEAR) }
      const_attr_reader  :DAY_OF_YEAR_MASK
      
      const_set_lazy(:DAY_OF_WEEK_MASK) { (1 << DAY_OF_WEEK) }
      const_attr_reader  :DAY_OF_WEEK_MASK
      
      const_set_lazy(:DAY_OF_WEEK_IN_MONTH_MASK) { (1 << DAY_OF_WEEK_IN_MONTH) }
      const_attr_reader  :DAY_OF_WEEK_IN_MONTH_MASK
      
      const_set_lazy(:AM_PM_MASK) { (1 << AM_PM) }
      const_attr_reader  :AM_PM_MASK
      
      const_set_lazy(:HOUR_MASK) { (1 << HOUR) }
      const_attr_reader  :HOUR_MASK
      
      const_set_lazy(:HOUR_OF_DAY_MASK) { (1 << HOUR_OF_DAY) }
      const_attr_reader  :HOUR_OF_DAY_MASK
      
      const_set_lazy(:MINUTE_MASK) { (1 << MINUTE) }
      const_attr_reader  :MINUTE_MASK
      
      const_set_lazy(:SECOND_MASK) { (1 << SECOND) }
      const_attr_reader  :SECOND_MASK
      
      const_set_lazy(:MILLISECOND_MASK) { (1 << MILLISECOND) }
      const_attr_reader  :MILLISECOND_MASK
      
      const_set_lazy(:ZONE_OFFSET_MASK) { (1 << ZONE_OFFSET) }
      const_attr_reader  :ZONE_OFFSET_MASK
      
      const_set_lazy(:DST_OFFSET_MASK) { (1 << DST_OFFSET) }
      const_attr_reader  :DST_OFFSET_MASK
    }
    
    typesig { [] }
    # Constructs a Calendar with the default time zone
    # and locale.
    # @see     TimeZone#getDefault
    def initialize
      initialize__calendar(TimeZone.get_default_ref, Locale.get_default)
      @shared_zone = true
    end
    
    typesig { [TimeZone, Locale] }
    # Constructs a calendar with the specified time zone and locale.
    # 
    # @param zone the time zone to use
    # @param aLocale the locale for the week data
    def initialize(zone, a_locale)
      @fields = nil
      @is_set = nil
      @stamp = nil
      @time = 0
      @is_time_set = false
      @are_fields_set = false
      @are_all_fields_set = false
      @lenient = true
      @zone = nil
      @shared_zone = false
      @first_day_of_week = 0
      @minimal_days_in_first_week = 0
      @next_stamp = MINIMUM_USER_STAMP
      @serial_version_on_stream = CurrentSerialVersion
      @fields = Array.typed(::Java::Int).new(FIELD_COUNT) { 0 }
      @is_set = Array.typed(::Java::Boolean).new(FIELD_COUNT) { false }
      @stamp = Array.typed(::Java::Int).new(FIELD_COUNT) { 0 }
      @zone = zone
      set_week_count_data(a_locale)
    end
    
    class_module.module_eval {
      typesig { [] }
      # Gets a calendar using the default time zone and locale. The
      # <code>Calendar</code> returned is based on the current time
      # in the default time zone with the default locale.
      # 
      # @return a Calendar.
      def get_instance
        cal = create_calendar(TimeZone.get_default_ref, Locale.get_default)
        cal.attr_shared_zone = true
        return cal
      end
      
      typesig { [TimeZone] }
      # Gets a calendar using the specified time zone and default locale.
      # The <code>Calendar</code> returned is based on the current time
      # in the given time zone with the default locale.
      # 
      # @param zone the time zone to use
      # @return a Calendar.
      def get_instance(zone)
        return create_calendar(zone, Locale.get_default)
      end
      
      typesig { [Locale] }
      # Gets a calendar using the default time zone and specified locale.
      # The <code>Calendar</code> returned is based on the current time
      # in the default time zone with the given locale.
      # 
      # @param aLocale the locale for the week data
      # @return a Calendar.
      def get_instance(a_locale)
        cal = create_calendar(TimeZone.get_default_ref, a_locale)
        cal.attr_shared_zone = true
        return cal
      end
      
      typesig { [TimeZone, Locale] }
      # Gets a calendar with the specified time zone and locale.
      # The <code>Calendar</code> returned is based on the current time
      # in the given time zone with the given locale.
      # 
      # @param zone the time zone to use
      # @param aLocale the locale for the week data
      # @return a Calendar.
      def get_instance(zone, a_locale)
        return create_calendar(zone, a_locale)
      end
      
      typesig { [TimeZone, Locale] }
      def create_calendar(zone, a_locale)
        # If the specified locale is a Thai locale, returns a BuddhistCalendar
        # instance.
        if (("th" == a_locale.get_language) && (("TH" == a_locale.get_country)))
          return Sun::Util::BuddhistCalendar.new(zone, a_locale)
        else
          if (("JP" == a_locale.get_variant) && ("JP" == a_locale.get_country) && ("ja" == a_locale.get_language))
            return JapaneseImperialCalendar.new(zone, a_locale)
          end
        end
        # else create the default calendar
        return GregorianCalendar.new(zone, a_locale)
      end
      
      typesig { [] }
      # Returns an array of all locales for which the <code>getInstance</code>
      # methods of this class can return localized instances.
      # The array returned must contain at least a <code>Locale</code>
      # instance equal to {@link java.util.Locale#US Locale.US}.
      # 
      # @return An array of locales for which localized
      #         <code>Calendar</code> instances are available.
      def get_available_locales
        synchronized(self) do
          return DateFormat.get_available_locales
        end
      end
    }
    
    typesig { [] }
    # Converts the current calendar field values in {@link #fields fields[]}
    # to the millisecond time value
    # {@link #time}.
    # 
    # @see #complete()
    # @see #computeFields()
    def compute_time
      raise NotImplementedError
    end
    
    typesig { [] }
    # Converts the current millisecond time value {@link #time}
    # to calendar field values in {@link #fields fields[]}.
    # This allows you to sync up the calendar field values with
    # a new time that is set for the calendar.  The time is <em>not</em>
    # recomputed first; to recompute the time, then the fields, call the
    # {@link #complete()} method.
    # 
    # @see #computeTime()
    def compute_fields
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a <code>Date</code> object representing this
    # <code>Calendar</code>'s time value (millisecond offset from the <a
    # href="#Epoch">Epoch</a>").
    # 
    # @return a <code>Date</code> representing the time value.
    # @see #setTime(Date)
    # @see #getTimeInMillis()
    def get_time
      return JavaDate.new(get_time_in_millis)
    end
    
    typesig { [JavaDate] }
    # Sets this Calendar's time with the given <code>Date</code>.
    # <p>
    # Note: Calling <code>setTime()</code> with
    # <code>Date(Long.MAX_VALUE)</code> or <code>Date(Long.MIN_VALUE)</code>
    # may yield incorrect field values from <code>get()</code>.
    # 
    # @param date the given Date.
    # @see #getTime()
    # @see #setTimeInMillis(long)
    def set_time(date)
      set_time_in_millis(date.get_time)
    end
    
    typesig { [] }
    # Returns this Calendar's time value in milliseconds.
    # 
    # @return the current time as UTC milliseconds from the epoch.
    # @see #getTime()
    # @see #setTimeInMillis(long)
    def get_time_in_millis
      if (!@is_time_set)
        update_time
      end
      return @time
    end
    
    typesig { [::Java::Long] }
    # Sets this Calendar's current time from the given long value.
    # 
    # @param millis the new time in UTC milliseconds from the epoch.
    # @see #setTime(Date)
    # @see #getTimeInMillis()
    def set_time_in_millis(millis)
      # If we don't need to recalculate the calendar field values,
      # do nothing.
      if ((@time).equal?(millis) && @is_time_set && @are_fields_set && @are_all_fields_set && (@zone.is_a?(ZoneInfo)) && !(@zone).is_dirty)
        return
      end
      @time = millis
      @is_time_set = true
      @are_fields_set = false
      compute_fields
      @are_all_fields_set = @are_fields_set = true
    end
    
    typesig { [::Java::Int] }
    # Returns the value of the given calendar field. In lenient mode,
    # all calendar fields are normalized. In non-lenient mode, all
    # calendar fields are validated and this method throws an
    # exception if any calendar fields have out-of-range values. The
    # normalization and validation are handled by the
    # {@link #complete()} method, which process is calendar
    # system dependent.
    # 
    # @param field the given calendar field.
    # @return the value for the given calendar field.
    # @throws ArrayIndexOutOfBoundsException if the specified field is out of range
    #             (<code>field &lt; 0 || field &gt;= FIELD_COUNT</code>).
    # @see #set(int,int)
    # @see #complete()
    def get(field)
      complete
      return internal_get(field)
    end
    
    typesig { [::Java::Int] }
    # Returns the value of the given calendar field. This method does
    # not involve normalization or validation of the field value.
    # 
    # @param field the given calendar field.
    # @return the value for the given calendar field.
    # @see #get(int)
    def internal_get(field)
      return @fields[field]
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the value of the given calendar field. This method does
    # not affect any setting state of the field in this
    # <code>Calendar</code> instance.
    # 
    # @throws IndexOutOfBoundsException if the specified field is out of range
    #             (<code>field &lt; 0 || field &gt;= FIELD_COUNT</code>).
    # @see #areFieldsSet
    # @see #isTimeSet
    # @see #areAllFieldsSet
    # @see #set(int,int)
    def internal_set(field, value)
      @fields[field] = value
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the given calendar field to the given value. The value is not
    # interpreted by this method regardless of the leniency mode.
    # 
    # @param field the given calendar field.
    # @param value the value to be set for the given calendar field.
    # @throws ArrayIndexOutOfBoundsException if the specified field is out of range
    #             (<code>field &lt; 0 || field &gt;= FIELD_COUNT</code>).
    # in non-lenient mode.
    # @see #set(int,int,int)
    # @see #set(int,int,int,int,int)
    # @see #set(int,int,int,int,int,int)
    # @see #get(int)
    def set(field, value)
      if (is_lenient && @are_fields_set && !@are_all_fields_set)
        compute_fields
      end
      internal_set(field, value)
      @is_time_set = false
      @are_fields_set = false
      @is_set[field] = true
      @stamp[field] = ((@next_stamp += 1) - 1)
      if ((@next_stamp).equal?(JavaInteger::MAX_VALUE))
        adjust_stamp
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # Sets the values for the calendar fields <code>YEAR</code>,
    # <code>MONTH</code>, and <code>DAY_OF_MONTH</code>.
    # Previous values of other calendar fields are retained.  If this is not desired,
    # call {@link #clear()} first.
    # 
    # @param year the value used to set the <code>YEAR</code> calendar field.
    # @param month the value used to set the <code>MONTH</code> calendar field.
    # Month value is 0-based. e.g., 0 for January.
    # @param date the value used to set the <code>DAY_OF_MONTH</code> calendar field.
    # @see #set(int,int)
    # @see #set(int,int,int,int,int)
    # @see #set(int,int,int,int,int,int)
    def set(year, month, date)
      set(YEAR, year)
      set(MONTH, month)
      set(DATE, date)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Sets the values for the calendar fields <code>YEAR</code>,
    # <code>MONTH</code>, <code>DAY_OF_MONTH</code>,
    # <code>HOUR_OF_DAY</code>, and <code>MINUTE</code>.
    # Previous values of other fields are retained.  If this is not desired,
    # call {@link #clear()} first.
    # 
    # @param year the value used to set the <code>YEAR</code> calendar field.
    # @param month the value used to set the <code>MONTH</code> calendar field.
    # Month value is 0-based. e.g., 0 for January.
    # @param date the value used to set the <code>DAY_OF_MONTH</code> calendar field.
    # @param hourOfDay the value used to set the <code>HOUR_OF_DAY</code> calendar field.
    # @param minute the value used to set the <code>MINUTE</code> calendar field.
    # @see #set(int,int)
    # @see #set(int,int,int)
    # @see #set(int,int,int,int,int,int)
    def set(year, month, date, hour_of_day, minute)
      set(YEAR, year)
      set(MONTH, month)
      set(DATE, date)
      set(HOUR_OF_DAY, hour_of_day)
      set(MINUTE, minute)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Sets the values for the fields <code>YEAR</code>, <code>MONTH</code>,
    # <code>DAY_OF_MONTH</code>, <code>HOUR</code>, <code>MINUTE</code>, and
    # <code>SECOND</code>.
    # Previous values of other fields are retained.  If this is not desired,
    # call {@link #clear()} first.
    # 
    # @param year the value used to set the <code>YEAR</code> calendar field.
    # @param month the value used to set the <code>MONTH</code> calendar field.
    # Month value is 0-based. e.g., 0 for January.
    # @param date the value used to set the <code>DAY_OF_MONTH</code> calendar field.
    # @param hourOfDay the value used to set the <code>HOUR_OF_DAY</code> calendar field.
    # @param minute the value used to set the <code>MINUTE</code> calendar field.
    # @param second the value used to set the <code>SECOND</code> calendar field.
    # @see #set(int,int)
    # @see #set(int,int,int)
    # @see #set(int,int,int,int,int)
    def set(year, month, date, hour_of_day, minute, second)
      set(YEAR, year)
      set(MONTH, month)
      set(DATE, date)
      set(HOUR_OF_DAY, hour_of_day)
      set(MINUTE, minute)
      set(SECOND, second)
    end
    
    typesig { [] }
    # Sets all the calendar field values and the time value
    # (millisecond offset from the <a href="#Epoch">Epoch</a>) of
    # this <code>Calendar</code> undefined. This means that {@link
    # #isSet(int) isSet()} will return <code>false</code> for all the
    # calendar fields, and the date and time calculations will treat
    # the fields as if they had never been set. A
    # <code>Calendar</code> implementation class may use its specific
    # default field values for date/time calculations. For example,
    # <code>GregorianCalendar</code> uses 1970 if the
    # <code>YEAR</code> field value is undefined.
    # 
    # @see #clear(int)
    def clear
      i = 0
      while i < @fields.attr_length
        @stamp[i] = @fields[i] = 0 # UNSET == 0
        @is_set[((i += 1) - 1)] = false
      end
      @are_all_fields_set = @are_fields_set = false
      @is_time_set = false
    end
    
    typesig { [::Java::Int] }
    # Sets the given calendar field value and the time value
    # (millisecond offset from the <a href="#Epoch">Epoch</a>) of
    # this <code>Calendar</code> undefined. This means that {@link
    # #isSet(int) isSet(field)} will return <code>false</code>, and
    # the date and time calculations will treat the field as if it
    # had never been set. A <code>Calendar</code> implementation
    # class may use the field's specific default value for date and
    # time calculations.
    # 
    # <p>The {@link #HOUR_OF_DAY}, {@link #HOUR} and {@link #AM_PM}
    # fields are handled independently and the <a
    # href="#time_resolution">the resolution rule for the time of
    # day</a> is applied. Clearing one of the fields doesn't reset
    # the hour of day value of this <code>Calendar</code>. Use {@link
    # #set(int,int) set(Calendar.HOUR_OF_DAY, 0)} to reset the hour
    # value.
    # 
    # @param field the calendar field to be cleared.
    # @see #clear()
    def clear(field)
      @fields[field] = 0
      @stamp[field] = UNSET
      @is_set[field] = false
      @are_all_fields_set = @are_fields_set = false
      @is_time_set = false
    end
    
    typesig { [::Java::Int] }
    # Determines if the given calendar field has a value set,
    # including cases that the value has been set by internal fields
    # calculations triggered by a <code>get</code> method call.
    # 
    # @return <code>true</code> if the given calendar field has a value set;
    # <code>false</code> otherwise.
    def is_set(field)
      return !(@stamp[field]).equal?(UNSET)
    end
    
    typesig { [::Java::Int, ::Java::Int, Locale] }
    # Returns the string representation of the calendar
    # <code>field</code> value in the given <code>style</code> and
    # <code>locale</code>.  If no string representation is
    # applicable, <code>null</code> is returned. This method calls
    # {@link Calendar#get(int) get(field)} to get the calendar
    # <code>field</code> value if the string representation is
    # applicable to the given calendar <code>field</code>.
    # 
    # <p>For example, if this <code>Calendar</code> is a
    # <code>GregorianCalendar</code> and its date is 2005-01-01, then
    # the string representation of the {@link #MONTH} field would be
    # "January" in the long style in an English locale or "Jan" in
    # the short style. However, no string representation would be
    # available for the {@link #DAY_OF_MONTH} field, and this method
    # would return <code>null</code>.
    # 
    # <p>The default implementation supports the calendar fields for
    # which a {@link DateFormatSymbols} has names in the given
    # <code>locale</code>.
    # 
    # @param field
    #        the calendar field for which the string representation
    #        is returned
    # @param style
    #        the style applied to the string representation; one of
    #        {@link #SHORT} or {@link #LONG}.
    # @param locale
    #        the locale for the string representation
    # @return the string representation of the given
    #        <code>field</code> in the given <code>style</code>, or
    #        <code>null</code> if no string representation is
    #        applicable.
    # @exception IllegalArgumentException
    #        if <code>field</code> or <code>style</code> is invalid,
    #        or if this <code>Calendar</code> is non-lenient and any
    #        of the calendar fields have invalid values
    # @exception NullPointerException
    #        if <code>locale</code> is null
    # @since 1.6
    def get_display_name(field, style, locale)
      if (!check_display_name_params(field, style, ALL_STYLES, LONG, locale, ERA_MASK | MONTH_MASK | DAY_OF_WEEK_MASK | AM_PM_MASK))
        return nil
      end
      symbols = DateFormatSymbols.get_instance(locale)
      strings = get_field_strings(field, style, symbols)
      if (!(strings).nil?)
        field_value = get(field)
        if (field_value < strings.attr_length)
          return strings[field_value]
        end
      end
      return nil
    end
    
    typesig { [::Java::Int, ::Java::Int, Locale] }
    # Returns a <code>Map</code> containing all names of the calendar
    # <code>field</code> in the given <code>style</code> and
    # <code>locale</code> and their corresponding field values. For
    # example, if this <code>Calendar</code> is a {@link
    # GregorianCalendar}, the returned map would contain "Jan" to
    # {@link #JANUARY}, "Feb" to {@link #FEBRUARY}, and so on, in the
    # {@linkplain #SHORT short} style in an English locale.
    # 
    # <p>The values of other calendar fields may be taken into
    # account to determine a set of display names. For example, if
    # this <code>Calendar</code> is a lunisolar calendar system and
    # the year value given by the {@link #YEAR} field has a leap
    # month, this method would return month names containing the leap
    # month name, and month names are mapped to their values specific
    # for the year.
    # 
    # <p>The default implementation supports display names contained in
    # a {@link DateFormatSymbols}. For example, if <code>field</code>
    # is {@link #MONTH} and <code>style</code> is {@link
    # #ALL_STYLES}, this method returns a <code>Map</code> containing
    # all strings returned by {@link DateFormatSymbols#getShortMonths()}
    # and {@link DateFormatSymbols#getMonths()}.
    # 
    # @param field
    #        the calendar field for which the display names are returned
    # @param style
    #        the style applied to the display names; one of {@link
    #        #SHORT}, {@link #LONG}, or {@link #ALL_STYLES}.
    # @param locale
    #        the locale for the display names
    # @return a <code>Map</code> containing all display names in
    #        <code>style</code> and <code>locale</code> and their
    #        field values, or <code>null</code> if no display names
    #        are defined for <code>field</code>
    # @exception IllegalArgumentException
    #        if <code>field</code> or <code>style</code> is invalid,
    #        or if this <code>Calendar</code> is non-lenient and any
    #        of the calendar fields have invalid values
    # @exception NullPointerException
    #        if <code>locale</code> is null
    # @since 1.6
    def get_display_names(field, style, locale)
      if (!check_display_name_params(field, style, ALL_STYLES, LONG, locale, ERA_MASK | MONTH_MASK | DAY_OF_WEEK_MASK | AM_PM_MASK))
        return nil
      end
      # ALL_STYLES
      if ((style).equal?(ALL_STYLES))
        short_names = get_display_names_impl(field, SHORT, locale)
        if ((field).equal?(ERA) || (field).equal?(AM_PM))
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
      symbols = DateFormatSymbols.get_instance(locale)
      strings = get_field_strings(field, style, symbols)
      if (!(strings).nil?)
        names = HashMap.new
        i = 0
        while i < strings.attr_length
          if ((strings[i].length).equal?(0))
            i += 1
            next
          end
          names.put(strings[i], i)
          i += 1
        end
        return names
      end
      return nil
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, Locale, ::Java::Int] }
    def check_display_name_params(field, style, min_style, max_style, locale, field_mask)
      if (field < 0 || field >= @fields.attr_length || style < min_style || style > max_style)
        raise IllegalArgumentException.new
      end
      if ((locale).nil?)
        raise NullPointerException.new
      end
      return is_field_set(field_mask, field)
    end
    
    typesig { [::Java::Int, ::Java::Int, DateFormatSymbols] }
    def get_field_strings(field, style, symbols)
      strings = nil
      case (field)
      when ERA
        strings = symbols.get_eras
      when MONTH
        strings = ((style).equal?(LONG)) ? symbols.get_months : symbols.get_short_months
      when DAY_OF_WEEK
        strings = ((style).equal?(LONG)) ? symbols.get_weekdays : symbols.get_short_weekdays
      when AM_PM
        strings = symbols.get_am_pm_strings
      end
      return strings
    end
    
    typesig { [] }
    # Fills in any unset fields in the calendar fields. First, the {@link
    # #computeTime()} method is called if the time value (millisecond offset
    # from the <a href="#Epoch">Epoch</a>) has not been calculated from
    # calendar field values. Then, the {@link #computeFields()} method is
    # called to calculate all calendar field values.
    def complete
      if (!@is_time_set)
        update_time
      end
      if (!@are_fields_set || !@are_all_fields_set)
        compute_fields # fills in unset fields
        @are_all_fields_set = @are_fields_set = true
      end
    end
    
    typesig { [::Java::Int] }
    # Returns whether the value of the specified calendar field has been set
    # externally by calling one of the setter methods rather than by the
    # internal time calculation.
    # 
    # @return <code>true</code> if the field has been set externally,
    # <code>false</code> otherwise.
    # @exception IndexOutOfBoundsException if the specified
    #                <code>field</code> is out of range
    #               (<code>field &lt; 0 || field &gt;= FIELD_COUNT</code>).
    # @see #selectFields()
    # @see #setFieldsComputed(int)
    def is_externally_set(field)
      return @stamp[field] >= MINIMUM_USER_STAMP
    end
    
    typesig { [] }
    # Returns a field mask (bit mask) indicating all calendar fields that
    # have the state of externally or internally set.
    # 
    # @return a bit mask indicating set state fields
    def get_set_state_fields
      mask = 0
      i = 0
      while i < @fields.attr_length
        if (!(@stamp[i]).equal?(UNSET))
          mask |= 1 << i
        end
        i += 1
      end
      return mask
    end
    
    typesig { [::Java::Int] }
    # Sets the state of the specified calendar fields to
    # <em>computed</em>. This state means that the specified calendar fields
    # have valid values that have been set by internal time calculation
    # rather than by calling one of the setter methods.
    # 
    # @param fieldMask the field to be marked as computed.
    # @exception IndexOutOfBoundsException if the specified
    #                <code>field</code> is out of range
    #               (<code>field &lt; 0 || field &gt;= FIELD_COUNT</code>).
    # @see #isExternallySet(int)
    # @see #selectFields()
    def set_fields_computed(field_mask)
      if ((field_mask).equal?(ALL_FIELDS))
        i = 0
        while i < @fields.attr_length
          @stamp[i] = COMPUTED
          @is_set[i] = true
          i += 1
        end
        @are_fields_set = @are_all_fields_set = true
      else
        i = 0
        while i < @fields.attr_length
          if (((field_mask & 1)).equal?(1))
            @stamp[i] = COMPUTED
            @is_set[i] = true
          else
            if (@are_all_fields_set && !@is_set[i])
              @are_all_fields_set = false
            end
          end
          field_mask >>= 1
          i += 1
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the state of the calendar fields that are <em>not</em> specified
    # by <code>fieldMask</code> to <em>unset</em>. If <code>fieldMask</code>
    # specifies all the calendar fields, then the state of this
    # <code>Calendar</code> becomes that all the calendar fields are in sync
    # with the time value (millisecond offset from the Epoch).
    # 
    # @param fieldMask the field mask indicating which calendar fields are in
    # sync with the time value.
    # @exception IndexOutOfBoundsException if the specified
    #                <code>field</code> is out of range
    #               (<code>field &lt; 0 || field &gt;= FIELD_COUNT</code>).
    # @see #isExternallySet(int)
    # @see #selectFields()
    def set_fields_normalized(field_mask)
      if (!(field_mask).equal?(ALL_FIELDS))
        i = 0
        while i < @fields.attr_length
          if (((field_mask & 1)).equal?(0))
            @stamp[i] = @fields[i] = 0 # UNSET == 0
            @is_set[i] = false
          end
          field_mask >>= 1
          i += 1
        end
      end
      # Some or all of the fields are in sync with the
      # milliseconds, but the stamp values are not normalized yet.
      @are_fields_set = true
      @are_all_fields_set = false
    end
    
    typesig { [] }
    # Returns whether the calendar fields are partially in sync with the time
    # value or fully in sync but not stamp values are not normalized yet.
    def is_partially_normalized
      return @are_fields_set && !@are_all_fields_set
    end
    
    typesig { [] }
    # Returns whether the calendar fields are fully in sync with the time
    # value.
    def is_fully_normalized
      return @are_fields_set && @are_all_fields_set
    end
    
    typesig { [] }
    # Marks this Calendar as not sync'd.
    def set_unnormalized
      @are_fields_set = @are_all_fields_set = false
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Int] }
      # Returns whether the specified <code>field</code> is on in the
      # <code>fieldMask</code>.
      def is_field_set(field_mask, field)
        return !((field_mask & (1 << field))).equal?(0)
      end
    }
    
    typesig { [] }
    # Returns a field mask indicating which calendar field values
    # to be used to calculate the time value. The calendar fields are
    # returned as a bit mask, each bit of which corresponds to a field, i.e.,
    # the mask value of <code>field</code> is <code>(1 &lt;&lt;
    # field)</code>. For example, 0x26 represents the <code>YEAR</code>,
    # <code>MONTH</code>, and <code>DAY_OF_MONTH</code> fields (i.e., 0x26 is
    # equal to
    # <code>(1&lt;&lt;YEAR)|(1&lt;&lt;MONTH)|(1&lt;&lt;DAY_OF_MONTH))</code>.
    # 
    # <p>This method supports the calendar fields resolution as described in
    # the class description. If the bit mask for a given field is on and its
    # field has not been set (i.e., <code>isSet(field)</code> is
    # <code>false</code>), then the default value of the field has to be
    # used, which case means that the field has been selected because the
    # selected combination involves the field.
    # 
    # @return a bit mask of selected fields
    # @see #isExternallySet(int)
    # @see #setInternallySetState(int)
    def select_fields
      # This implementation has been taken from the GregorianCalendar class.
      # The YEAR field must always be used regardless of its SET
      # state because YEAR is a mandatory field to determine the date
      # and the default value (EPOCH_YEAR) may change through the
      # normalization process.
      field_mask = YEAR_MASK
      if (!(@stamp[ERA]).equal?(UNSET))
        field_mask |= ERA_MASK
      end
      # Find the most recent group of fields specifying the day within
      # the year.  These may be any of the following combinations:
      #   MONTH + DAY_OF_MONTH
      #   MONTH + WEEK_OF_MONTH + DAY_OF_WEEK
      #   MONTH + DAY_OF_WEEK_IN_MONTH + DAY_OF_WEEK
      #   DAY_OF_YEAR
      #   WEEK_OF_YEAR + DAY_OF_WEEK
      # We look for the most recent of the fields in each group to determine
      # the age of the group.  For groups involving a week-related field such
      # as WEEK_OF_MONTH, DAY_OF_WEEK_IN_MONTH, or WEEK_OF_YEAR, both the
      # week-related field and the DAY_OF_WEEK must be set for the group as a
      # whole to be considered.  (See bug 4153860 - liu 7/24/98.)
      dow_stamp = @stamp[DAY_OF_WEEK]
      month_stamp = @stamp[MONTH]
      dom_stamp = @stamp[DAY_OF_MONTH]
      wom_stamp = aggregate_stamp(@stamp[WEEK_OF_MONTH], dow_stamp)
      dowim_stamp = aggregate_stamp(@stamp[DAY_OF_WEEK_IN_MONTH], dow_stamp)
      doy_stamp = @stamp[DAY_OF_YEAR]
      woy_stamp = aggregate_stamp(@stamp[WEEK_OF_YEAR], dow_stamp)
      best_stamp = dom_stamp
      if (wom_stamp > best_stamp)
        best_stamp = wom_stamp
      end
      if (dowim_stamp > best_stamp)
        best_stamp = dowim_stamp
      end
      if (doy_stamp > best_stamp)
        best_stamp = doy_stamp
      end
      if (woy_stamp > best_stamp)
        best_stamp = woy_stamp
      end
      # No complete combination exists.  Look for WEEK_OF_MONTH,
      # DAY_OF_WEEK_IN_MONTH, or WEEK_OF_YEAR alone.  Treat DAY_OF_WEEK alone
      # as DAY_OF_WEEK_IN_MONTH.
      if ((best_stamp).equal?(UNSET))
        wom_stamp = @stamp[WEEK_OF_MONTH]
        dowim_stamp = Math.max(@stamp[DAY_OF_WEEK_IN_MONTH], dow_stamp)
        woy_stamp = @stamp[WEEK_OF_YEAR]
        best_stamp = Math.max(Math.max(wom_stamp, dowim_stamp), woy_stamp)
        # Treat MONTH alone or no fields at all as DAY_OF_MONTH.  This may
        # result in bestStamp = domStamp = UNSET if no fields are set,
        # which indicates DAY_OF_MONTH.
        if ((best_stamp).equal?(UNSET))
          best_stamp = dom_stamp = month_stamp
        end
      end
      if ((best_stamp).equal?(dom_stamp) || ((best_stamp).equal?(wom_stamp) && @stamp[WEEK_OF_MONTH] >= @stamp[WEEK_OF_YEAR]) || ((best_stamp).equal?(dowim_stamp) && @stamp[DAY_OF_WEEK_IN_MONTH] >= @stamp[WEEK_OF_YEAR]))
        field_mask |= MONTH_MASK
        if ((best_stamp).equal?(dom_stamp))
          field_mask |= DAY_OF_MONTH_MASK
        else
          raise AssertError if not (((best_stamp).equal?(wom_stamp) || (best_stamp).equal?(dowim_stamp)))
          if (!(dow_stamp).equal?(UNSET))
            field_mask |= DAY_OF_WEEK_MASK
          end
          if ((wom_stamp).equal?(dowim_stamp))
            # When they are equal, give the priority to
            # WEEK_OF_MONTH for compatibility.
            if (@stamp[WEEK_OF_MONTH] >= @stamp[DAY_OF_WEEK_IN_MONTH])
              field_mask |= WEEK_OF_MONTH_MASK
            else
              field_mask |= DAY_OF_WEEK_IN_MONTH_MASK
            end
          else
            if ((best_stamp).equal?(wom_stamp))
              field_mask |= WEEK_OF_MONTH_MASK
            else
              raise AssertError if not (((best_stamp).equal?(dowim_stamp)))
              if (!(@stamp[DAY_OF_WEEK_IN_MONTH]).equal?(UNSET))
                field_mask |= DAY_OF_WEEK_IN_MONTH_MASK
              end
            end
          end
        end
      else
        raise AssertError if not (((best_stamp).equal?(doy_stamp) || (best_stamp).equal?(woy_stamp) || (best_stamp).equal?(UNSET)))
        if ((best_stamp).equal?(doy_stamp))
          field_mask |= DAY_OF_YEAR_MASK
        else
          raise AssertError if not (((best_stamp).equal?(woy_stamp)))
          if (!(dow_stamp).equal?(UNSET))
            field_mask |= DAY_OF_WEEK_MASK
          end
          field_mask |= WEEK_OF_YEAR_MASK
        end
      end
      # Find the best set of fields specifying the time of day.  There
      # are only two possibilities here; the HOUR_OF_DAY or the
      # AM_PM and the HOUR.
      hour_of_day_stamp = @stamp[HOUR_OF_DAY]
      hour_stamp = aggregate_stamp(@stamp[HOUR], @stamp[AM_PM])
      best_stamp = (hour_stamp > hour_of_day_stamp) ? hour_stamp : hour_of_day_stamp
      # if bestStamp is still UNSET, then take HOUR or AM_PM. (See 4846659)
      if ((best_stamp).equal?(UNSET))
        best_stamp = Math.max(@stamp[HOUR], @stamp[AM_PM])
      end
      # Hours
      if (!(best_stamp).equal?(UNSET))
        if ((best_stamp).equal?(hour_of_day_stamp))
          field_mask |= HOUR_OF_DAY_MASK
        else
          field_mask |= HOUR_MASK
          if (!(@stamp[AM_PM]).equal?(UNSET))
            field_mask |= AM_PM_MASK
          end
        end
      end
      if (!(@stamp[MINUTE]).equal?(UNSET))
        field_mask |= MINUTE_MASK
      end
      if (!(@stamp[SECOND]).equal?(UNSET))
        field_mask |= SECOND_MASK
      end
      if (!(@stamp[MILLISECOND]).equal?(UNSET))
        field_mask |= MILLISECOND_MASK
      end
      if (@stamp[ZONE_OFFSET] >= MINIMUM_USER_STAMP)
        field_mask |= ZONE_OFFSET_MASK
      end
      if (@stamp[DST_OFFSET] >= MINIMUM_USER_STAMP)
        field_mask |= DST_OFFSET_MASK
      end
      return field_mask
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Int] }
      # Returns the pseudo-time-stamp for two fields, given their
      # individual pseudo-time-stamps.  If either of the fields
      # is unset, then the aggregate is unset.  Otherwise, the
      # aggregate is the later of the two stamps.
      def aggregate_stamp(stamp_a, stamp_b)
        if ((stamp_a).equal?(UNSET) || (stamp_b).equal?(UNSET))
          return UNSET
        end
        return (stamp_a > stamp_b) ? stamp_a : stamp_b
      end
    }
    
    typesig { [Object] }
    # Compares this <code>Calendar</code> to the specified
    # <code>Object</code>.  The result is <code>true</code> if and only if
    # the argument is a <code>Calendar</code> object of the same calendar
    # system that represents the same time value (millisecond offset from the
    # <a href="#Epoch">Epoch</a>) under the same
    # <code>Calendar</code> parameters as this object.
    # 
    # <p>The <code>Calendar</code> parameters are the values represented
    # by the <code>isLenient</code>, <code>getFirstDayOfWeek</code>,
    # <code>getMinimalDaysInFirstWeek</code> and <code>getTimeZone</code>
    # methods. If there is any difference in those parameters
    # between the two <code>Calendar</code>s, this method returns
    # <code>false</code>.
    # 
    # <p>Use the {@link #compareTo(Calendar) compareTo} method to
    # compare only the time values.
    # 
    # @param obj the object to compare with.
    # @return <code>true</code> if this object is equal to <code>obj</code>;
    # <code>false</code> otherwise.
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      begin
        that = obj
        return (compare_to(get_millis_of(that))).equal?(0) && (@lenient).equal?(that.attr_lenient) && (@first_day_of_week).equal?(that.attr_first_day_of_week) && (@minimal_days_in_first_week).equal?(that.attr_minimal_days_in_first_week) && (@zone == that.attr_zone)
      rescue JavaException => e
        # Note: GregorianCalendar.computeTime throws
        # IllegalArgumentException if the ERA value is invalid
        # even it's in lenient mode.
      end
      return false
    end
    
    typesig { [] }
    # Returns a hash code for this calendar.
    # 
    # @return a hash code value for this object.
    # @since 1.2
    def hash_code
      # 'otheritems' represents the hash code for the previous versions.
      otheritems = (@lenient ? 1 : 0) | (@first_day_of_week << 1) | (@minimal_days_in_first_week << 4) | (@zone.hash_code << 7)
      t = get_millis_of(self)
      return (t).to_int ^ ((t >> 32)).to_int ^ otheritems
    end
    
    typesig { [Object] }
    # Returns whether this <code>Calendar</code> represents a time
    # before the time represented by the specified
    # <code>Object</code>. This method is equivalent to:
    # <pre><blockquote>
    #         compareTo(when) < 0
    # </blockquote></pre>
    # if and only if <code>when</code> is a <code>Calendar</code>
    # instance. Otherwise, the method returns <code>false</code>.
    # 
    # @param when the <code>Object</code> to be compared
    # @return <code>true</code> if the time of this
    # <code>Calendar</code> is before the time represented by
    # <code>when</code>; <code>false</code> otherwise.
    # @see     #compareTo(Calendar)
    def before(when_)
      return when_.is_a?(Calendar) && compare_to(when_) < 0
    end
    
    typesig { [Object] }
    # Returns whether this <code>Calendar</code> represents a time
    # after the time represented by the specified
    # <code>Object</code>. This method is equivalent to:
    # <pre><blockquote>
    #         compareTo(when) > 0
    # </blockquote></pre>
    # if and only if <code>when</code> is a <code>Calendar</code>
    # instance. Otherwise, the method returns <code>false</code>.
    # 
    # @param when the <code>Object</code> to be compared
    # @return <code>true</code> if the time of this <code>Calendar</code> is
    # after the time represented by <code>when</code>; <code>false</code>
    # otherwise.
    # @see     #compareTo(Calendar)
    def after(when_)
      return when_.is_a?(Calendar) && compare_to(when_) > 0
    end
    
    typesig { [Calendar] }
    # Compares the time values (millisecond offsets from the <a
    # href="#Epoch">Epoch</a>) represented by two
    # <code>Calendar</code> objects.
    # 
    # @param anotherCalendar the <code>Calendar</code> to be compared.
    # @return the value <code>0</code> if the time represented by the argument
    # is equal to the time represented by this <code>Calendar</code>; a value
    # less than <code>0</code> if the time of this <code>Calendar</code> is
    # before the time represented by the argument; and a value greater than
    # <code>0</code> if the time of this <code>Calendar</code> is after the
    # time represented by the argument.
    # @exception NullPointerException if the specified <code>Calendar</code> is
    #            <code>null</code>.
    # @exception IllegalArgumentException if the time value of the
    # specified <code>Calendar</code> object can't be obtained due to
    # any invalid calendar values.
    # @since   1.5
    def compare_to(another_calendar)
      return compare_to(get_millis_of(another_calendar))
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Adds or subtracts the specified amount of time to the given calendar field,
    # based on the calendar's rules. For example, to subtract 5 days from
    # the current time of the calendar, you can achieve it by calling:
    # <p><code>add(Calendar.DAY_OF_MONTH, -5)</code>.
    # 
    # @param field the calendar field.
    # @param amount the amount of date or time to be added to the field.
    # @see #roll(int,int)
    # @see #set(int,int)
    def add(field, amount)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Adds or subtracts (up/down) a single unit of time on the given time
    # field without changing larger fields. For example, to roll the current
    # date up by one day, you can achieve it by calling:
    # <p>roll(Calendar.DATE, true).
    # When rolling on the year or Calendar.YEAR field, it will roll the year
    # value in the range between 1 and the value returned by calling
    # <code>getMaximum(Calendar.YEAR)</code>.
    # When rolling on the month or Calendar.MONTH field, other fields like
    # date might conflict and, need to be changed. For instance,
    # rolling the month on the date 01/31/96 will result in 02/29/96.
    # When rolling on the hour-in-day or Calendar.HOUR_OF_DAY field, it will
    # roll the hour value in the range between 0 and 23, which is zero-based.
    # 
    # @param field the time field.
    # @param up indicates if the value of the specified time field is to be
    # rolled up or rolled down. Use true if rolling up, false otherwise.
    # @see Calendar#add(int,int)
    # @see Calendar#set(int,int)
    def roll(field, up)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Adds the specified (signed) amount to the specified calendar field
    # without changing larger fields.  A negative amount means to roll
    # down.
    # 
    # <p>NOTE:  This default implementation on <code>Calendar</code> just repeatedly calls the
    # version of {@link #roll(int,boolean) roll()} that rolls by one unit.  This may not
    # always do the right thing.  For example, if the <code>DAY_OF_MONTH</code> field is 31,
    # rolling through February will leave it set to 28.  The <code>GregorianCalendar</code>
    # version of this function takes care of this problem.  Other subclasses
    # should also provide overrides of this function that do the right thing.
    # 
    # @param field the calendar field.
    # @param amount the signed amount to add to the calendar <code>field</code>.
    # @since 1.2
    # @see #roll(int,boolean)
    # @see #add(int,int)
    # @see #set(int,int)
    def roll(field, amount)
      while (amount > 0)
        roll(field, true)
        amount -= 1
      end
      while (amount < 0)
        roll(field, false)
        amount += 1
      end
    end
    
    typesig { [TimeZone] }
    # Sets the time zone with the given time zone value.
    # 
    # @param value the given time zone.
    def set_time_zone(value)
      @zone = value
      @shared_zone = false
      # Recompute the fields from the time using the new zone.  This also
      # works if isTimeSet is false (after a call to set()).  In that case
      # the time will be computed from the fields using the new zone, then
      # the fields will get recomputed from that.  Consider the sequence of
      # calls: cal.setTimeZone(EST); cal.set(HOUR, 1); cal.setTimeZone(PST).
      # Is cal set to 1 o'clock EST or 1 o'clock PST?  Answer: PST.  More
      # generally, a call to setTimeZone() affects calls to set() BEFORE AND
      # AFTER it up to the next call to complete().
      @are_all_fields_set = @are_fields_set = false
    end
    
    typesig { [] }
    # Gets the time zone.
    # 
    # @return the time zone object associated with this calendar.
    def get_time_zone
      # If the TimeZone object is shared by other Calendar instances, then
      # create a clone.
      if (@shared_zone)
        @zone = @zone.clone
        @shared_zone = false
      end
      return @zone
    end
    
    typesig { [] }
    # Returns the time zone (without cloning).
    def get_zone
      return @zone
    end
    
    typesig { [::Java::Boolean] }
    # Sets the sharedZone flag to <code>shared</code>.
    def set_zone_shared(shared)
      @shared_zone = shared
    end
    
    typesig { [::Java::Boolean] }
    # Specifies whether or not date/time interpretation is to be lenient.  With
    # lenient interpretation, a date such as "February 942, 1996" will be
    # treated as being equivalent to the 941st day after February 1, 1996.
    # With strict (non-lenient) interpretation, such dates will cause an exception to be
    # thrown. The default is lenient.
    # 
    # @param lenient <code>true</code> if the lenient mode is to be turned
    # on; <code>false</code> if it is to be turned off.
    # @see #isLenient()
    # @see java.text.DateFormat#setLenient
    def set_lenient(lenient)
      @lenient = lenient
    end
    
    typesig { [] }
    # Tells whether date/time interpretation is to be lenient.
    # 
    # @return <code>true</code> if the interpretation mode of this calendar is lenient;
    # <code>false</code> otherwise.
    # @see #setLenient(boolean)
    def is_lenient
      return @lenient
    end
    
    typesig { [::Java::Int] }
    # Sets what the first day of the week is; e.g., <code>SUNDAY</code> in the U.S.,
    # <code>MONDAY</code> in France.
    # 
    # @param value the given first day of the week.
    # @see #getFirstDayOfWeek()
    # @see #getMinimalDaysInFirstWeek()
    def set_first_day_of_week(value)
      if ((@first_day_of_week).equal?(value))
        return
      end
      @first_day_of_week = value
      invalidate_week_fields
    end
    
    typesig { [] }
    # Gets what the first day of the week is; e.g., <code>SUNDAY</code> in the U.S.,
    # <code>MONDAY</code> in France.
    # 
    # @return the first day of the week.
    # @see #setFirstDayOfWeek(int)
    # @see #getMinimalDaysInFirstWeek()
    def get_first_day_of_week
      return @first_day_of_week
    end
    
    typesig { [::Java::Int] }
    # Sets what the minimal days required in the first week of the year are;
    # For example, if the first week is defined as one that contains the first
    # day of the first month of a year, call this method with value 1. If it
    # must be a full week, use value 7.
    # 
    # @param value the given minimal days required in the first week
    # of the year.
    # @see #getMinimalDaysInFirstWeek()
    def set_minimal_days_in_first_week(value)
      if ((@minimal_days_in_first_week).equal?(value))
        return
      end
      @minimal_days_in_first_week = value
      invalidate_week_fields
    end
    
    typesig { [] }
    # Gets what the minimal days required in the first week of the year are;
    # e.g., if the first week is defined as one that contains the first day
    # of the first month of a year, this method returns 1. If
    # the minimal days required must be a full week, this method
    # returns 7.
    # 
    # @return the minimal days required in the first week of the year.
    # @see #setMinimalDaysInFirstWeek(int)
    def get_minimal_days_in_first_week
      return @minimal_days_in_first_week
    end
    
    typesig { [::Java::Int] }
    # Returns the minimum value for the given calendar field of this
    # <code>Calendar</code> instance. The minimum value is defined as
    # the smallest value returned by the {@link #get(int) get} method
    # for any possible time value.  The minimum value depends on
    # calendar system specific parameters of the instance.
    # 
    # @param field the calendar field.
    # @return the minimum value for the given calendar field.
    # @see #getMaximum(int)
    # @see #getGreatestMinimum(int)
    # @see #getLeastMaximum(int)
    # @see #getActualMinimum(int)
    # @see #getActualMaximum(int)
    def get_minimum(field)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the maximum value for the given calendar field of this
    # <code>Calendar</code> instance. The maximum value is defined as
    # the largest value returned by the {@link #get(int) get} method
    # for any possible time value. The maximum value depends on
    # calendar system specific parameters of the instance.
    # 
    # @param field the calendar field.
    # @return the maximum value for the given calendar field.
    # @see #getMinimum(int)
    # @see #getGreatestMinimum(int)
    # @see #getLeastMaximum(int)
    # @see #getActualMinimum(int)
    # @see #getActualMaximum(int)
    def get_maximum(field)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the highest minimum value for the given calendar field
    # of this <code>Calendar</code> instance. The highest minimum
    # value is defined as the largest value returned by {@link
    # #getActualMinimum(int)} for any possible time value. The
    # greatest minimum value depends on calendar system specific
    # parameters of the instance.
    # 
    # @param field the calendar field.
    # @return the highest minimum value for the given calendar field.
    # @see #getMinimum(int)
    # @see #getMaximum(int)
    # @see #getLeastMaximum(int)
    # @see #getActualMinimum(int)
    # @see #getActualMaximum(int)
    def get_greatest_minimum(field)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the lowest maximum value for the given calendar field
    # of this <code>Calendar</code> instance. The lowest maximum
    # value is defined as the smallest value returned by {@link
    # #getActualMaximum(int)} for any possible time value. The least
    # maximum value depends on calendar system specific parameters of
    # the instance. For example, a <code>Calendar</code> for the
    # Gregorian calendar system returns 28 for the
    # <code>DAY_OF_MONTH</code> field, because the 28th is the last
    # day of the shortest month of this calendar, February in a
    # common year.
    # 
    # @param field the calendar field.
    # @return the lowest maximum value for the given calendar field.
    # @see #getMinimum(int)
    # @see #getMaximum(int)
    # @see #getGreatestMinimum(int)
    # @see #getActualMinimum(int)
    # @see #getActualMaximum(int)
    def get_least_maximum(field)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the minimum value that the specified calendar field
    # could have, given the time value of this <code>Calendar</code>.
    # 
    # <p>The default implementation of this method uses an iterative
    # algorithm to determine the actual minimum value for the
    # calendar field. Subclasses should, if possible, override this
    # with a more efficient implementation - in many cases, they can
    # simply return <code>getMinimum()</code>.
    # 
    # @param field the calendar field
    # @return the minimum of the given calendar field for the time
    # value of this <code>Calendar</code>
    # @see #getMinimum(int)
    # @see #getMaximum(int)
    # @see #getGreatestMinimum(int)
    # @see #getLeastMaximum(int)
    # @see #getActualMaximum(int)
    # @since 1.2
    def get_actual_minimum(field)
      field_value = get_greatest_minimum(field)
      end_value = get_minimum(field)
      # if we know that the minimum value is always the same, just return it
      if ((field_value).equal?(end_value))
        return field_value
      end
      # clone the calendar so we don't mess with the real one, and set it to
      # accept anything for the field values
      work = self.clone
      work.set_lenient(true)
      # now try each value from getLeastMaximum() to getMaximum() one by one until
      # we get a value that normalizes to another value.  The last value that
      # normalizes to itself is the actual minimum for the current date
      result = field_value
      begin
        work.set(field, field_value)
        if (!(work.get(field)).equal?(field_value))
          break
        else
          result = field_value
          field_value -= 1
        end
      end while (field_value >= end_value)
      return result
    end
    
    typesig { [::Java::Int] }
    # Returns the maximum value that the specified calendar field
    # could have, given the time value of this
    # <code>Calendar</code>. For example, the actual maximum value of
    # the <code>MONTH</code> field is 12 in some years, and 13 in
    # other years in the Hebrew calendar system.
    # 
    # <p>The default implementation of this method uses an iterative
    # algorithm to determine the actual maximum value for the
    # calendar field. Subclasses should, if possible, override this
    # with a more efficient implementation.
    # 
    # @param field the calendar field
    # @return the maximum of the given calendar field for the time
    # value of this <code>Calendar</code>
    # @see #getMinimum(int)
    # @see #getMaximum(int)
    # @see #getGreatestMinimum(int)
    # @see #getLeastMaximum(int)
    # @see #getActualMinimum(int)
    # @since 1.2
    def get_actual_maximum(field)
      field_value = get_least_maximum(field)
      end_value = get_maximum(field)
      # if we know that the maximum value is always the same, just return it.
      if ((field_value).equal?(end_value))
        return field_value
      end
      # clone the calendar so we don't mess with the real one, and set it to
      # accept anything for the field values.
      work = self.clone
      work.set_lenient(true)
      # if we're counting weeks, set the day of the week to Sunday.  We know the
      # last week of a month or year will contain the first day of the week.
      if ((field).equal?(WEEK_OF_YEAR) || (field).equal?(WEEK_OF_MONTH))
        work.set(DAY_OF_WEEK, @first_day_of_week)
      end
      # now try each value from getLeastMaximum() to getMaximum() one by one until
      # we get a value that normalizes to another value.  The last value that
      # normalizes to itself is the actual maximum for the current date
      result = field_value
      begin
        work.set(field, field_value)
        if (!(work.get(field)).equal?(field_value))
          break
        else
          result = field_value
          field_value += 1
        end
      end while (field_value <= end_value)
      return result
    end
    
    typesig { [] }
    # Creates and returns a copy of this object.
    # 
    # @return a copy of this object.
    def clone
      begin
        other = super
        other.attr_fields = Array.typed(::Java::Int).new(FIELD_COUNT) { 0 }
        other.attr_is_set = Array.typed(::Java::Boolean).new(FIELD_COUNT) { false }
        other.attr_stamp = Array.typed(::Java::Int).new(FIELD_COUNT) { 0 }
        i = 0
        while i < FIELD_COUNT
          other.attr_fields[i] = @fields[i]
          other.attr_stamp[i] = @stamp[i]
          other.attr_is_set[i] = @is_set[i]
          i += 1
        end
        other.attr_zone = @zone.clone
        return other
      rescue CloneNotSupportedException => e
        # this shouldn't happen, since we are Cloneable
        raise InternalError.new
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:FIELD_NAME) { Array.typed(String).new(["ERA", "YEAR", "MONTH", "WEEK_OF_YEAR", "WEEK_OF_MONTH", "DAY_OF_MONTH", "DAY_OF_YEAR", "DAY_OF_WEEK", "DAY_OF_WEEK_IN_MONTH", "AM_PM", "HOUR", "HOUR_OF_DAY", "MINUTE", "SECOND", "MILLISECOND", "ZONE_OFFSET", "DST_OFFSET"]) }
      const_attr_reader  :FIELD_NAME
      
      typesig { [::Java::Int] }
      # Returns the name of the specified calendar field.
      # 
      # @param field the calendar field
      # @return the calendar field name
      # @exception IndexOutOfBoundsException if <code>field</code> is negative,
      # equal to or greater then <code>FIELD_COUNT</code>.
      def get_field_name(field)
        return FIELD_NAME[field]
      end
    }
    
    typesig { [] }
    # Return a string representation of this calendar. This method
    # is intended to be used only for debugging purposes, and the
    # format of the returned string may vary between implementations.
    # The returned string may be empty but may not be <code>null</code>.
    # 
    # @return  a string representation of this calendar.
    def to_s
      # NOTE: BuddhistCalendar.toString() interprets the string
      # produced by this method so that the Gregorian year number
      # is substituted by its B.E. year value. It relies on
      # "...,YEAR=<year>,..." or "...,YEAR=?,...".
      buffer = StringBuilder.new(800)
      buffer.append(get_class.get_name).append(Character.new(?[.ord))
      append_value(buffer, "time", @is_time_set, @time)
      buffer.append(",areFieldsSet=").append(@are_fields_set)
      buffer.append(",areAllFieldsSet=").append(@are_all_fields_set)
      buffer.append(",lenient=").append(@lenient)
      buffer.append(",zone=").append(@zone)
      append_value(buffer, ",firstDayOfWeek", true, @first_day_of_week)
      append_value(buffer, ",minimalDaysInFirstWeek", true, @minimal_days_in_first_week)
      i = 0
      while i < FIELD_COUNT
        buffer.append(Character.new(?,.ord))
        append_value(buffer, FIELD_NAME[i], is_set(i), @fields[i])
        (i += 1)
      end
      buffer.append(Character.new(?].ord))
      return buffer.to_s
    end
    
    class_module.module_eval {
      typesig { [StringBuilder, String, ::Java::Boolean, ::Java::Long] }
      # =======================privates===============================
      def append_value(sb, item, valid, value)
        sb.append(item).append(Character.new(?=.ord))
        if (valid)
          sb.append(value)
        else
          sb.append(Character.new(??.ord))
        end
      end
    }
    
    typesig { [Locale] }
    # Both firstDayOfWeek and minimalDaysInFirstWeek are locale-dependent.
    # They are used to figure out the week count for a specific date for
    # a given locale. These must be set when a Calendar is constructed.
    # @param desiredLocale the given locale.
    def set_week_count_data(desired_locale)
      # try to get the Locale data from the cache
      data = self.attr_cached_locale_data.get(desired_locale)
      if ((data).nil?)
        # cache miss
        bundle = LocaleData.get_calendar_data(desired_locale)
        data = Array.typed(::Java::Int).new(2) { 0 }
        data[0] = JavaInteger.parse_int(bundle.get_string("firstDayOfWeek"))
        data[1] = JavaInteger.parse_int(bundle.get_string("minimalDaysInFirstWeek"))
        self.attr_cached_locale_data.put(desired_locale, data)
      end
      @first_day_of_week = data[0]
      @minimal_days_in_first_week = data[1]
    end
    
    typesig { [] }
    # Recomputes the time and updates the status fields isTimeSet
    # and areFieldsSet.  Callers should check isTimeSet and only
    # call this method if isTimeSet is false.
    def update_time
      compute_time
      # The areFieldsSet and areAllFieldsSet values are no longer
      # controlled here (as of 1.5).
      @is_time_set = true
    end
    
    typesig { [::Java::Long] }
    def compare_to(t)
      this_time = get_millis_of(self)
      return (this_time > t) ? 1 : ((this_time).equal?(t)) ? 0 : -1
    end
    
    class_module.module_eval {
      typesig { [Calendar] }
      def get_millis_of(calendar)
        if (calendar.attr_is_time_set)
          return calendar.attr_time
        end
        cal = calendar.clone
        cal.set_lenient(true)
        return cal.get_time_in_millis
      end
    }
    
    typesig { [] }
    # Adjusts the stamp[] values before nextStamp overflow. nextStamp
    # is set to the next stamp value upon the return.
    def adjust_stamp
      max_ = MINIMUM_USER_STAMP
      new_stamp = MINIMUM_USER_STAMP
      loop do
        min = JavaInteger::MAX_VALUE
        i = 0
        while i < @stamp.attr_length
          v = @stamp[i]
          if (v >= new_stamp && min > v)
            min = v
          end
          if (max_ < v)
            max_ = v
          end
          i += 1
        end
        if (!(max_).equal?(min) && (min).equal?(JavaInteger::MAX_VALUE))
          break
        end
        i_ = 0
        while i_ < @stamp.attr_length
          if ((@stamp[i_]).equal?(min))
            @stamp[i_] = new_stamp
          end
          i_ += 1
        end
        new_stamp += 1
        if ((min).equal?(max_))
          break
        end
      end
      @next_stamp = new_stamp
    end
    
    typesig { [] }
    # Sets the WEEK_OF_MONTH and WEEK_OF_YEAR fields to new values with the
    # new parameter value if they have been calculated internally.
    def invalidate_week_fields
      if (!(@stamp[WEEK_OF_MONTH]).equal?(COMPUTED) && !(@stamp[WEEK_OF_YEAR]).equal?(COMPUTED))
        return
      end
      # We have to check the new values of these fields after changing
      # firstDayOfWeek and/or minimalDaysInFirstWeek. If the field values
      # have been changed, then set the new values. (4822110)
      cal = clone
      cal.set_lenient(true)
      cal.clear(WEEK_OF_MONTH)
      cal.clear(WEEK_OF_YEAR)
      if ((@stamp[WEEK_OF_MONTH]).equal?(COMPUTED))
        week_of_month = cal.get(WEEK_OF_MONTH)
        if (!(@fields[WEEK_OF_MONTH]).equal?(week_of_month))
          @fields[WEEK_OF_MONTH] = week_of_month
        end
      end
      if ((@stamp[WEEK_OF_YEAR]).equal?(COMPUTED))
        week_of_year = cal.get(WEEK_OF_YEAR)
        if (!(@fields[WEEK_OF_YEAR]).equal?(week_of_year))
          @fields[WEEK_OF_YEAR] = week_of_year
        end
      end
    end
    
    typesig { [ObjectOutputStream] }
    # Save the state of this object to a stream (i.e., serialize it).
    # 
    # Ideally, <code>Calendar</code> would only write out its state data and
    # the current time, and not write any field data out, such as
    # <code>fields[]</code>, <code>isTimeSet</code>, <code>areFieldsSet</code>,
    # and <code>isSet[]</code>.  <code>nextStamp</code> also should not be part
    # of the persistent state. Unfortunately, this didn't happen before JDK 1.1
    # shipped. To be compatible with JDK 1.1, we will always have to write out
    # the field values and state flags.  However, <code>nextStamp</code> can be
    # removed from the serialization stream; this will probably happen in the
    # near future.
    def write_object(stream)
      # Try to compute the time correctly, for the future (stream
      # version 2) in which we don't write out fields[] or isSet[].
      if (!@is_time_set)
        begin
          update_time
        rescue IllegalArgumentException => e
        end
      end
      # If this Calendar has a ZoneInfo, save it and set a
      # SimpleTimeZone equivalent (as a single DST schedule) for
      # backward compatibility.
      saved_zone = nil
      if (@zone.is_a?(ZoneInfo))
        stz = (@zone).get_last_rule_instance
        if ((stz).nil?)
          stz = SimpleTimeZone.new(@zone.get_raw_offset, @zone.get_id)
        end
        saved_zone = @zone
        @zone = stz
      end
      # Write out the 1.1 FCS object.
      stream.default_write_object
      # Write out the ZoneInfo object
      # 4802409: we write out even if it is null, a temporary workaround
      # the real fix for bug 4844924 in corba-iiop
      stream.write_object(saved_zone)
      if (!(saved_zone).nil?)
        @zone = saved_zone
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:CalendarAccessControlContext) { Class.new do
        include_class_members Calendar
        
        class_module.module_eval {
          when_class_loaded do
            perm = class_self::RuntimePermission.new("accessClassInPackage.sun.util.calendar")
            perms = perm.new_permission_collection
            perms.add(perm)
            const_set :INSTANCE, class_self::AccessControlContext.new(Array.typed(self.class::ProtectionDomain).new([class_self::ProtectionDomain.new(nil, perms)]))
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__calendar_access_control_context, :initialize
      end }
    }
    
    typesig { [ObjectInputStream] }
    # Reconstitutes this object from a stream (i.e., deserialize it).
    def read_object(stream)
      input = stream
      input.default_read_object
      @stamp = Array.typed(::Java::Int).new(FIELD_COUNT) { 0 }
      # Starting with version 2 (not implemented yet), we expect that
      # fields[], isSet[], isTimeSet, and areFieldsSet may not be
      # streamed out anymore.  We expect 'time' to be correct.
      if (@serial_version_on_stream >= 2)
        @is_time_set = true
        if ((@fields).nil?)
          @fields = Array.typed(::Java::Int).new(FIELD_COUNT) { 0 }
        end
        if ((@is_set).nil?)
          @is_set = Array.typed(::Java::Boolean).new(FIELD_COUNT) { false }
        end
      else
        if (@serial_version_on_stream >= 0)
          i = 0
          while i < FIELD_COUNT
            @stamp[i] = @is_set[i] ? COMPUTED : UNSET
            (i += 1)
          end
        end
      end
      @serial_version_on_stream = CurrentSerialVersion
      # If there's a ZoneInfo object, use it for zone.
      zi = nil
      begin
        zi = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          local_class_in Calendar
          include_class_members Calendar
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            return input.read_object
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self), CalendarAccessControlContext::INSTANCE)
      rescue PrivilegedActionException => pae
        e = pae.get_exception
        if (!(e.is_a?(OptionalDataException)))
          if (e.is_a?(RuntimeException))
            raise e
          else
            if (e.is_a?(IOException))
              raise e
            else
              if (e.is_a?(ClassNotFoundException))
                raise e
              end
            end
          end
          raise RuntimeException.new(e)
        end
      end
      if (!(zi).nil?)
        @zone = zi
      end
      # If the deserialized object has a SimpleTimeZone, try to
      # replace it with a ZoneInfo equivalent (as of 1.4) in order
      # to be compatible with the SimpleTimeZone-based
      # implementation as much as possible.
      if (@zone.is_a?(SimpleTimeZone))
        id = @zone.get_id
        tz = TimeZone.get_time_zone(id)
        if (!(tz).nil? && tz.has_same_rules(@zone) && (tz.get_id == id))
          @zone = tz
        end
      end
    end
    
    private
    alias_method :initialize__calendar, :initialize
  end
  
end
