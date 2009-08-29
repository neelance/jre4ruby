require "rjava"

# Copyright 1994-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DateImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Text, :DateFormat
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ObjectOutputStream
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Sun::Util::Calendar, :BaseCalendar
      include_const ::Sun::Util::Calendar, :CalendarDate
      include_const ::Sun::Util::Calendar, :CalendarSystem
      include_const ::Sun::Util::Calendar, :CalendarUtils
      include_const ::Sun::Util::Calendar, :Era
      include_const ::Sun::Util::Calendar, :Gregorian
      include_const ::Sun::Util::Calendar, :ZoneInfo
    }
  end
  
  # The class <code>Date</code> represents a specific instant
  # in time, with millisecond precision.
  # <p>
  # Prior to JDK&nbsp;1.1, the class <code>Date</code> had two additional
  # functions.  It allowed the interpretation of dates as year, month, day, hour,
  # minute, and second values.  It also allowed the formatting and parsing
  # of date strings.  Unfortunately, the API for these functions was not
  # amenable to internationalization.  As of JDK&nbsp;1.1, the
  # <code>Calendar</code> class should be used to convert between dates and time
  # fields and the <code>DateFormat</code> class should be used to format and
  # parse date strings.
  # The corresponding methods in <code>Date</code> are deprecated.
  # <p>
  # Although the <code>Date</code> class is intended to reflect
  # coordinated universal time (UTC), it may not do so exactly,
  # depending on the host environment of the Java Virtual Machine.
  # Nearly all modern operating systems assume that 1&nbsp;day&nbsp;=
  # 24&nbsp;&times;&nbsp;60&nbsp;&times;&nbsp;60&nbsp;= 86400 seconds
  # in all cases. In UTC, however, about once every year or two there
  # is an extra second, called a "leap second." The leap
  # second is always added as the last second of the day, and always
  # on December 31 or June 30. For example, the last minute of the
  # year 1995 was 61 seconds long, thanks to an added leap second.
  # Most computer clocks are not accurate enough to be able to reflect
  # the leap-second distinction.
  # <p>
  # Some computer standards are defined in terms of Greenwich mean
  # time (GMT), which is equivalent to universal time (UT).  GMT is
  # the "civil" name for the standard; UT is the
  # "scientific" name for the same standard. The
  # distinction between UTC and UT is that UTC is based on an atomic
  # clock and UT is based on astronomical observations, which for all
  # practical purposes is an invisibly fine hair to split. Because the
  # earth's rotation is not uniform (it slows down and speeds up
  # in complicated ways), UT does not always flow uniformly. Leap
  # seconds are introduced as needed into UTC so as to keep UTC within
  # 0.9 seconds of UT1, which is a version of UT with certain
  # corrections applied. There are other time and date systems as
  # well; for example, the time scale used by the satellite-based
  # global positioning system (GPS) is synchronized to UTC but is
  # <i>not</i> adjusted for leap seconds. An interesting source of
  # further information is the U.S. Naval Observatory, particularly
  # the Directorate of Time at:
  # <blockquote><pre>
  # <a href=http://tycho.usno.navy.mil>http://tycho.usno.navy.mil</a>
  # </pre></blockquote>
  # <p>
  # and their definitions of "Systems of Time" at:
  # <blockquote><pre>
  # <a href=http://tycho.usno.navy.mil/systime.html>http://tycho.usno.navy.mil/systime.html</a>
  # </pre></blockquote>
  # <p>
  # In all methods of class <code>Date</code> that accept or return
  # year, month, date, hours, minutes, and seconds values, the
  # following representations are used:
  # <ul>
  # <li>A year <i>y</i> is represented by the integer
  # <i>y</i>&nbsp;<code>-&nbsp;1900</code>.
  # <li>A month is represented by an integer from 0 to 11; 0 is January,
  # 1 is February, and so forth; thus 11 is December.
  # <li>A date (day of month) is represented by an integer from 1 to 31
  # in the usual manner.
  # <li>An hour is represented by an integer from 0 to 23. Thus, the hour
  # from midnight to 1 a.m. is hour 0, and the hour from noon to 1
  # p.m. is hour 12.
  # <li>A minute is represented by an integer from 0 to 59 in the usual manner.
  # <li>A second is represented by an integer from 0 to 61; the values 60 and
  # 61 occur only for leap seconds and even then only in Java
  # implementations that actually track leap seconds correctly. Because
  # of the manner in which leap seconds are currently introduced, it is
  # extremely unlikely that two leap seconds will occur in the same
  # minute, but this specification follows the date and time conventions
  # for ISO C.
  # </ul>
  # <p>
  # In all cases, arguments given to methods for these purposes need
  # not fall within the indicated ranges; for example, a date may be
  # specified as January 32 and is interpreted as meaning February 1.
  # 
  # @author  James Gosling
  # @author  Arthur van Hoff
  # @author  Alan Liu
  # @see     java.text.DateFormat
  # @see     java.util.Calendar
  # @see     java.util.TimeZone
  # @since   JDK1.0
  class JavaDate 
    include_class_members DateImports
    include Java::Io::Serializable
    include Cloneable
    include JavaComparable
    
    class_module.module_eval {
      const_set_lazy(:Gcal) { CalendarSystem.get_gregorian_calendar }
      const_attr_reader  :Gcal
      
      
      def jcal
        defined?(@@jcal) ? @@jcal : @@jcal= nil
      end
      alias_method :attr_jcal, :jcal
      
      def jcal=(value)
        @@jcal = value
      end
      alias_method :attr_jcal=, :jcal=
    }
    
    attr_accessor :fast_time
    alias_method :attr_fast_time, :fast_time
    undef_method :fast_time
    alias_method :attr_fast_time=, :fast_time=
    undef_method :fast_time=
    
    # If cdate is null, then fastTime indicates the time in millis.
    # If cdate.isNormalized() is true, then fastTime and cdate are in
    # synch. Otherwise, fastTime is ignored, and cdate indicates the
    # time.
    attr_accessor :cdate
    alias_method :attr_cdate, :cdate
    undef_method :cdate
    alias_method :attr_cdate=, :cdate=
    undef_method :cdate=
    
    class_module.module_eval {
      # Initialized just before the value is used. See parse().
      
      def default_century_start
        defined?(@@default_century_start) ? @@default_century_start : @@default_century_start= 0
      end
      alias_method :attr_default_century_start, :default_century_start
      
      def default_century_start=(value)
        @@default_century_start = value
      end
      alias_method :attr_default_century_start=, :default_century_start=
      
      # use serialVersionUID from modified java.util.Date for
      # interoperability with JDK1.1. The Date was modified to write
      # and read only the UTC time.
      const_set_lazy(:SerialVersionUID) { 7523967970034938905 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Allocates a <code>Date</code> object and initializes it so that
    # it represents the time at which it was allocated, measured to the
    # nearest millisecond.
    # 
    # @see     java.lang.System#currentTimeMillis()
    def initialize
      initialize__date(System.current_time_millis)
    end
    
    typesig { [::Java::Long] }
    # Allocates a <code>Date</code> object and initializes it to
    # represent the specified number of milliseconds since the
    # standard base time known as "the epoch", namely January 1,
    # 1970, 00:00:00 GMT.
    # 
    # @param   date   the milliseconds since January 1, 1970, 00:00:00 GMT.
    # @see     java.lang.System#currentTimeMillis()
    def initialize(date)
      @fast_time = 0
      @cdate = nil
      @fast_time = date
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # Allocates a <code>Date</code> object and initializes it so that
    # it represents midnight, local time, at the beginning of the day
    # specified by the <code>year</code>, <code>month</code>, and
    # <code>date</code> arguments.
    # 
    # @param   year    the year minus 1900.
    # @param   month   the month between 0-11.
    # @param   date    the day of the month between 1-31.
    # @see     java.util.Calendar
    # @deprecated As of JDK version 1.1,
    # replaced by <code>Calendar.set(year + 1900, month, date)</code>
    # or <code>GregorianCalendar(year + 1900, month, date)</code>.
    def initialize(year, month, date)
      initialize__date(year, month, date, 0, 0, 0)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Allocates a <code>Date</code> object and initializes it so that
    # it represents the instant at the start of the minute specified by
    # the <code>year</code>, <code>month</code>, <code>date</code>,
    # <code>hrs</code>, and <code>min</code> arguments, in the local
    # time zone.
    # 
    # @param   year    the year minus 1900.
    # @param   month   the month between 0-11.
    # @param   date    the day of the month between 1-31.
    # @param   hrs     the hours between 0-23.
    # @param   min     the minutes between 0-59.
    # @see     java.util.Calendar
    # @deprecated As of JDK version 1.1,
    # replaced by <code>Calendar.set(year + 1900, month, date,
    # hrs, min)</code> or <code>GregorianCalendar(year + 1900,
    # month, date, hrs, min)</code>.
    def initialize(year, month, date, hrs, min)
      initialize__date(year, month, date, hrs, min, 0)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Allocates a <code>Date</code> object and initializes it so that
    # it represents the instant at the start of the second specified
    # by the <code>year</code>, <code>month</code>, <code>date</code>,
    # <code>hrs</code>, <code>min</code>, and <code>sec</code> arguments,
    # in the local time zone.
    # 
    # @param   year    the year minus 1900.
    # @param   month   the month between 0-11.
    # @param   date    the day of the month between 1-31.
    # @param   hrs     the hours between 0-23.
    # @param   min     the minutes between 0-59.
    # @param   sec     the seconds between 0-59.
    # @see     java.util.Calendar
    # @deprecated As of JDK version 1.1,
    # replaced by <code>Calendar.set(year + 1900, month, date,
    # hrs, min, sec)</code> or <code>GregorianCalendar(year + 1900,
    # month, date, hrs, min, sec)</code>.
    def initialize(year, month, date, hrs, min, sec)
      @fast_time = 0
      @cdate = nil
      y = year + 1900
      # month is 0-based. So we have to normalize month to support Long.MAX_VALUE.
      if (month >= 12)
        y += month / 12
        month %= 12
      else
        if (month < 0)
          y += CalendarUtils.floor_divide(month, 12)
          month = CalendarUtils.mod(month, 12)
        end
      end
      cal = get_calendar_system(y)
      @cdate = cal.new_calendar_date(TimeZone.get_default_ref)
      @cdate.set_normalized_date(y, month + 1, date).set_time_of_day(hrs, min, sec, 0)
      get_time_impl
      @cdate = nil
    end
    
    typesig { [String] }
    # Allocates a <code>Date</code> object and initializes it so that
    # it represents the date and time indicated by the string
    # <code>s</code>, which is interpreted as if by the
    # {@link Date#parse} method.
    # 
    # @param   s   a string representation of the date.
    # @see     java.text.DateFormat
    # @see     java.util.Date#parse(java.lang.String)
    # @deprecated As of JDK version 1.1,
    # replaced by <code>DateFormat.parse(String s)</code>.
    def initialize(s)
      initialize__date(parse(s))
    end
    
    typesig { [] }
    # Return a copy of this object.
    def clone
      d = nil
      begin
        d = super
        if (!(@cdate).nil?)
          d.attr_cdate = @cdate.clone
        end
      rescue CloneNotSupportedException => e
      end # Won't happen
      return d
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
      # Determines the date and time based on the arguments. The
      # arguments are interpreted as a year, month, day of the month,
      # hour of the day, minute within the hour, and second within the
      # minute, exactly as for the <tt>Date</tt> constructor with six
      # arguments, except that the arguments are interpreted relative
      # to UTC rather than to the local time zone. The time indicated is
      # returned represented as the distance, measured in milliseconds,
      # of that time from the epoch (00:00:00 GMT on January 1, 1970).
      # 
      # @param   year    the year minus 1900.
      # @param   month   the month between 0-11.
      # @param   date    the day of the month between 1-31.
      # @param   hrs     the hours between 0-23.
      # @param   min     the minutes between 0-59.
      # @param   sec     the seconds between 0-59.
      # @return  the number of milliseconds since January 1, 1970, 00:00:00 GMT for
      # the date and time specified by the arguments.
      # @see     java.util.Calendar
      # @deprecated As of JDK version 1.1,
      # replaced by <code>Calendar.set(year + 1900, month, date,
      # hrs, min, sec)</code> or <code>GregorianCalendar(year + 1900,
      # month, date, hrs, min, sec)</code>, using a UTC
      # <code>TimeZone</code>, followed by <code>Calendar.getTime().getTime()</code>.
      def _utc(year, month, date, hrs, min, sec)
        y = year + 1900
        # month is 0-based. So we have to normalize month to support Long.MAX_VALUE.
        if (month >= 12)
          y += month / 12
          month %= 12
        else
          if (month < 0)
            y += CalendarUtils.floor_divide(month, 12)
            month = CalendarUtils.mod(month, 12)
          end
        end
        m = month + 1
        cal = get_calendar_system(y)
        udate = cal.new_calendar_date(nil)
        udate.set_normalized_date(y, m, date).set_time_of_day(hrs, min, sec, 0)
        # Use a Date instance to perform normalization. Its fastTime
        # is the UTC value after the normalization.
        d = JavaDate.new(0)
        d.normalize(udate)
        return d.attr_fast_time
      end
      
      typesig { [String] }
      # Attempts to interpret the string <tt>s</tt> as a representation
      # of a date and time. If the attempt is successful, the time
      # indicated is returned represented as the distance, measured in
      # milliseconds, of that time from the epoch (00:00:00 GMT on
      # January 1, 1970). If the attempt fails, an
      # <tt>IllegalArgumentException</tt> is thrown.
      # <p>
      # It accepts many syntaxes; in particular, it recognizes the IETF
      # standard date syntax: "Sat, 12 Aug 1995 13:30:00 GMT". It also
      # understands the continental U.S. time-zone abbreviations, but for
      # general use, a time-zone offset should be used: "Sat, 12 Aug 1995
      # 13:30:00 GMT+0430" (4 hours, 30 minutes west of the Greenwich
      # meridian). If no time zone is specified, the local time zone is
      # assumed. GMT and UTC are considered equivalent.
      # <p>
      # The string <tt>s</tt> is processed from left to right, looking for
      # data of interest. Any material in <tt>s</tt> that is within the
      # ASCII parenthesis characters <tt>(</tt> and <tt>)</tt> is ignored.
      # Parentheses may be nested. Otherwise, the only characters permitted
      # within <tt>s</tt> are these ASCII characters:
      # <blockquote><pre>
      # abcdefghijklmnopqrstuvwxyz
      # ABCDEFGHIJKLMNOPQRSTUVWXYZ
      # 0123456789,+-:/</pre></blockquote>
      # and whitespace characters.<p>
      # A consecutive sequence of decimal digits is treated as a decimal
      # number:<ul>
      # <li>If a number is preceded by <tt>+</tt> or <tt>-</tt> and a year
      # has already been recognized, then the number is a time-zone
      # offset. If the number is less than 24, it is an offset measured
      # in hours. Otherwise, it is regarded as an offset in minutes,
      # expressed in 24-hour time format without punctuation. A
      # preceding <tt>-</tt> means a westward offset. Time zone offsets
      # are always relative to UTC (Greenwich). Thus, for example,
      # <tt>-5</tt> occurring in the string would mean "five hours west
      # of Greenwich" and <tt>+0430</tt> would mean "four hours and
      # thirty minutes east of Greenwich." It is permitted for the
      # string to specify <tt>GMT</tt>, <tt>UT</tt>, or <tt>UTC</tt>
      # redundantly-for example, <tt>GMT-5</tt> or <tt>utc+0430</tt>.
      # <li>The number is regarded as a year number if one of the
      # following conditions is true:
      # <ul>
      # <li>The number is equal to or greater than 70 and followed by a
      # space, comma, slash, or end of string
      # <li>The number is less than 70, and both a month and a day of
      # the month have already been recognized</li>
      # </ul>
      # If the recognized year number is less than 100, it is
      # interpreted as an abbreviated year relative to a century of
      # which dates are within 80 years before and 19 years after
      # the time when the Date class is initialized.
      # After adjusting the year number, 1900 is subtracted from
      # it. For example, if the current year is 1999 then years in
      # the range 19 to 99 are assumed to mean 1919 to 1999, while
      # years from 0 to 18 are assumed to mean 2000 to 2018.  Note
      # that this is slightly different from the interpretation of
      # years less than 100 that is used in {@link java.text.SimpleDateFormat}.
      # <li>If the number is followed by a colon, it is regarded as an hour,
      # unless an hour has already been recognized, in which case it is
      # regarded as a minute.
      # <li>If the number is followed by a slash, it is regarded as a month
      # (it is decreased by 1 to produce a number in the range <tt>0</tt>
      # to <tt>11</tt>), unless a month has already been recognized, in
      # which case it is regarded as a day of the month.
      # <li>If the number is followed by whitespace, a comma, a hyphen, or
      # end of string, then if an hour has been recognized but not a
      # minute, it is regarded as a minute; otherwise, if a minute has
      # been recognized but not a second, it is regarded as a second;
      # otherwise, it is regarded as a day of the month. </ul><p>
      # A consecutive sequence of letters is regarded as a word and treated
      # as follows:<ul>
      # <li>A word that matches <tt>AM</tt>, ignoring case, is ignored (but
      # the parse fails if an hour has not been recognized or is less
      # than <tt>1</tt> or greater than <tt>12</tt>).
      # <li>A word that matches <tt>PM</tt>, ignoring case, adds <tt>12</tt>
      # to the hour (but the parse fails if an hour has not been
      # recognized or is less than <tt>1</tt> or greater than <tt>12</tt>).
      # <li>Any word that matches any prefix of <tt>SUNDAY, MONDAY, TUESDAY,
      # WEDNESDAY, THURSDAY, FRIDAY</tt>, or <tt>SATURDAY</tt>, ignoring
      # case, is ignored. For example, <tt>sat, Friday, TUE</tt>, and
      # <tt>Thurs</tt> are ignored.
      # <li>Otherwise, any word that matches any prefix of <tt>JANUARY,
      # FEBRUARY, MARCH, APRIL, MAY, JUNE, JULY, AUGUST, SEPTEMBER,
      # OCTOBER, NOVEMBER</tt>, or <tt>DECEMBER</tt>, ignoring case, and
      # considering them in the order given here, is recognized as
      # specifying a month and is converted to a number (<tt>0</tt> to
      # <tt>11</tt>). For example, <tt>aug, Sept, april</tt>, and
      # <tt>NOV</tt> are recognized as months. So is <tt>Ma</tt>, which
      # is recognized as <tt>MARCH</tt>, not <tt>MAY</tt>.
      # <li>Any word that matches <tt>GMT, UT</tt>, or <tt>UTC</tt>, ignoring
      # case, is treated as referring to UTC.
      # <li>Any word that matches <tt>EST, CST, MST</tt>, or <tt>PST</tt>,
      # ignoring case, is recognized as referring to the time zone in
      # North America that is five, six, seven, or eight hours west of
      # Greenwich, respectively. Any word that matches <tt>EDT, CDT,
      # MDT</tt>, or <tt>PDT</tt>, ignoring case, is recognized as
      # referring to the same time zone, respectively, during daylight
      # saving time.</ul><p>
      # Once the entire string s has been scanned, it is converted to a time
      # result in one of two ways. If a time zone or time-zone offset has been
      # recognized, then the year, month, day of month, hour, minute, and
      # second are interpreted in UTC and then the time-zone offset is
      # applied. Otherwise, the year, month, day of month, hour, minute, and
      # second are interpreted in the local time zone.
      # 
      # @param   s   a string to be parsed as a date.
      # @return  the number of milliseconds since January 1, 1970, 00:00:00 GMT
      # represented by the string argument.
      # @see     java.text.DateFormat
      # @deprecated As of JDK version 1.1,
      # replaced by <code>DateFormat.parse(String s)</code>.
      def parse(s)
        year = JavaInteger::MIN_VALUE
        mon = -1
        mday = -1
        hour = -1
        min = -1
        sec = -1
        millis = -1
        c = -1
        i = 0
        n = -1
        wst = -1
        tzoffset = -1
        prevc = 0
        catch(:break_syntax) do
          if ((s).nil?)
            throw :break_syntax, :thrown
          end
          limit = s.length
          while (i < limit)
            c = s.char_at(i)
            i += 1
            if (c <= Character.new(?\s.ord) || (c).equal?(Character.new(?,.ord)))
              next
            end
            if ((c).equal?(Character.new(?(.ord)))
              # skip comments
              depth = 1
              while (i < limit)
                c = s.char_at(i)
                i += 1
                if ((c).equal?(Character.new(?(.ord)))
                  depth += 1
                else
                  if ((c).equal?(Character.new(?).ord)))
                    if ((depth -= 1) <= 0)
                      break
                    end
                  end
                end
              end
              next
            end
            if (Character.new(?0.ord) <= c && c <= Character.new(?9.ord))
              n = c - Character.new(?0.ord)
              while (i < limit && Character.new(?0.ord) <= (c = s.char_at(i)) && c <= Character.new(?9.ord))
                n = n * 10 + c - Character.new(?0.ord)
                i += 1
              end
              if ((prevc).equal?(Character.new(?+.ord)) || (prevc).equal?(Character.new(?-.ord)) && !(year).equal?(JavaInteger::MIN_VALUE))
                # timezone offset
                if (n < 24)
                  n = n * 60
                   # EG. "GMT-3"
                else
                  n = n % 100 + n / 100 * 60
                end # eg "GMT-0430"
                if ((prevc).equal?(Character.new(?+.ord)))
                  # plus means east of GMT
                  n = -n
                end
                if (!(tzoffset).equal?(0) && !(tzoffset).equal?(-1))
                  throw :break_syntax, :thrown
                end
                tzoffset = n
              else
                if (n >= 70)
                  if (!(year).equal?(JavaInteger::MIN_VALUE))
                    throw :break_syntax, :thrown
                  else
                    if (c <= Character.new(?\s.ord) || (c).equal?(Character.new(?,.ord)) || (c).equal?(Character.new(?/.ord)) || i >= limit)
                      # year = n < 1900 ? n : n - 1900;
                      year = n
                    else
                      throw :break_syntax, :thrown
                    end
                  end
                else
                  if ((c).equal?(Character.new(?:.ord)))
                    if (hour < 0)
                      hour = n
                    else
                      if (min < 0)
                        min = n
                      else
                        throw :break_syntax, :thrown
                      end
                    end
                  else
                    if ((c).equal?(Character.new(?/.ord)))
                      if (mon < 0)
                        mon = (n - 1)
                      else
                        if (mday < 0)
                          mday = n
                        else
                          throw :break_syntax, :thrown
                        end
                      end
                    else
                      if (i < limit && !(c).equal?(Character.new(?,.ord)) && c > Character.new(?\s.ord) && !(c).equal?(Character.new(?-.ord)))
                        throw :break_syntax, :thrown
                      else
                        if (hour >= 0 && min < 0)
                          min = n
                        else
                          if (min >= 0 && sec < 0)
                            sec = n
                          else
                            if (mday < 0)
                              mday = n
                            # Handle two-digit years < 70 (70-99 handled above).
                            else
                              if ((year).equal?(JavaInteger::MIN_VALUE) && mon >= 0 && mday >= 0)
                                year = n
                              else
                                throw :break_syntax, :thrown
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
              prevc = 0
            else
              if ((c).equal?(Character.new(?/.ord)) || (c).equal?(Character.new(?:.ord)) || (c).equal?(Character.new(?+.ord)) || (c).equal?(Character.new(?-.ord)))
                prevc = c
              else
                st = i - 1
                while (i < limit)
                  c = s.char_at(i)
                  if (!(Character.new(?A.ord) <= c && c <= Character.new(?Z.ord) || Character.new(?a.ord) <= c && c <= Character.new(?z.ord)))
                    break
                  end
                  i += 1
                end
                if (i <= st + 1)
                  throw :break_syntax, :thrown
                end
                k = 0
                k = Wtb.attr_length
                while (k -= 1) >= 0
                  if (Wtb[k].region_matches(true, 0, s, st, i - st))
                    action = Ttb[k]
                    if (!(action).equal?(0))
                      if ((action).equal?(1))
                        # pm
                        if (hour > 12 || hour < 1)
                          throw :break_syntax, :thrown
                        else
                          if (hour < 12)
                            hour += 12
                          end
                        end
                      else
                        if ((action).equal?(14))
                          # am
                          if (hour > 12 || hour < 1)
                            throw :break_syntax, :thrown
                          else
                            if ((hour).equal?(12))
                              hour = 0
                            end
                          end
                        else
                          if (action <= 13)
                            # month!
                            if (mon < 0)
                              mon = (action - 2)
                            else
                              throw :break_syntax, :thrown
                            end
                          else
                            tzoffset = action - 10000
                          end
                        end
                      end
                    end
                    break
                  end
                end
                if (k < 0)
                  throw :break_syntax, :thrown
                end
                prevc = 0
              end
            end
          end
          if ((year).equal?(JavaInteger::MIN_VALUE) || mon < 0 || mday < 0)
            throw :break_syntax, :thrown
          end
          # Parse 2-digit years within the correct default century.
          if (year < 100)
            synchronized((JavaDate)) do
              if ((self.attr_default_century_start).equal?(0))
                self.attr_default_century_start = Gcal.get_calendar_date.get_year - 80
              end
            end
            year += (self.attr_default_century_start / 100) * 100
            if (year < self.attr_default_century_start)
              year += 100
            end
          end
          if (sec < 0)
            sec = 0
          end
          if (min < 0)
            min = 0
          end
          if (hour < 0)
            hour = 0
          end
          cal = get_calendar_system(year)
          if ((tzoffset).equal?(-1))
            # no time zone specified, have to use local
            ldate = cal.new_calendar_date(TimeZone.get_default_ref)
            ldate.set_date(year, mon + 1, mday)
            ldate.set_time_of_day(hour, min, sec, 0)
            return cal.get_time(ldate)
          end
          udate = cal.new_calendar_date(nil) # no time zone
          udate.set_date(year, mon + 1, mday)
          udate.set_time_of_day(hour, min, sec, 0)
          return cal.get_time(udate) + tzoffset * (60 * 1000)
        end
        # syntax error
        raise IllegalArgumentException.new
      end
      
      const_set_lazy(:Wtb) { Array.typed(String).new(["am", "pm", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday", "january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december", "gmt", "ut", "utc", "est", "edt", "cst", "cdt", "mst", "mdt", "pst", "pdt"]) }
      const_attr_reader  :Wtb
      
      # GMT/UT/UTC
      # EST/EDT
      # CST/CDT
      # MST/MDT
      # PST/PDT
      const_set_lazy(:Ttb) { Array.typed(::Java::Int).new([14, 1, 0, 0, 0, 0, 0, 0, 0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 10000 + 0, 10000 + 0, 10000 + 0, 10000 + 5 * 60, 10000 + 4 * 60, 10000 + 6 * 60, 10000 + 5 * 60, 10000 + 7 * 60, 10000 + 6 * 60, 10000 + 8 * 60, 10000 + 7 * 60]) }
      const_attr_reader  :Ttb
    }
    
    typesig { [] }
    # Returns a value that is the result of subtracting 1900 from the
    # year that contains or begins with the instant in time represented
    # by this <code>Date</code> object, as interpreted in the local
    # time zone.
    # 
    # @return  the year represented by this date, minus 1900.
    # @see     java.util.Calendar
    # @deprecated As of JDK version 1.1,
    # replaced by <code>Calendar.get(Calendar.YEAR) - 1900</code>.
    def get_year
      return normalize.get_year - 1900
    end
    
    typesig { [::Java::Int] }
    # Sets the year of this <tt>Date</tt> object to be the specified
    # value plus 1900. This <code>Date</code> object is modified so
    # that it represents a point in time within the specified year,
    # with the month, date, hour, minute, and second the same as
    # before, as interpreted in the local time zone. (Of course, if
    # the date was February 29, for example, and the year is set to a
    # non-leap year, then the new date will be treated as if it were
    # on March 1.)
    # 
    # @param   year    the year value.
    # @see     java.util.Calendar
    # @deprecated As of JDK version 1.1,
    # replaced by <code>Calendar.set(Calendar.YEAR, year + 1900)</code>.
    def set_year(year)
      get_calendar_date.set_normalized_year(year + 1900)
    end
    
    typesig { [] }
    # Returns a number representing the month that contains or begins
    # with the instant in time represented by this <tt>Date</tt> object.
    # The value returned is between <code>0</code> and <code>11</code>,
    # with the value <code>0</code> representing January.
    # 
    # @return  the month represented by this date.
    # @see     java.util.Calendar
    # @deprecated As of JDK version 1.1,
    # replaced by <code>Calendar.get(Calendar.MONTH)</code>.
    def get_month
      return normalize.get_month - 1 # adjust 1-based to 0-based
    end
    
    typesig { [::Java::Int] }
    # Sets the month of this date to the specified value. This
    # <tt>Date</tt> object is modified so that it represents a point
    # in time within the specified month, with the year, date, hour,
    # minute, and second the same as before, as interpreted in the
    # local time zone. If the date was October 31, for example, and
    # the month is set to June, then the new date will be treated as
    # if it were on July 1, because June has only 30 days.
    # 
    # @param   month   the month value between 0-11.
    # @see     java.util.Calendar
    # @deprecated As of JDK version 1.1,
    # replaced by <code>Calendar.set(Calendar.MONTH, int month)</code>.
    def set_month(month)
      y = 0
      if (month >= 12)
        y = month / 12
        month %= 12
      else
        if (month < 0)
          y = CalendarUtils.floor_divide(month, 12)
          month = CalendarUtils.mod(month, 12)
        end
      end
      d = get_calendar_date
      if (!(y).equal?(0))
        d.set_normalized_year(d.get_normalized_year + y)
      end
      d.set_month(month + 1) # adjust 0-based to 1-based month numbering
    end
    
    typesig { [] }
    # Returns the day of the month represented by this <tt>Date</tt> object.
    # The value returned is between <code>1</code> and <code>31</code>
    # representing the day of the month that contains or begins with the
    # instant in time represented by this <tt>Date</tt> object, as
    # interpreted in the local time zone.
    # 
    # @return  the day of the month represented by this date.
    # @see     java.util.Calendar
    # @deprecated As of JDK version 1.1,
    # replaced by <code>Calendar.get(Calendar.DAY_OF_MONTH)</code>.
    # @deprecated
    def get_date
      return normalize.get_day_of_month
    end
    
    typesig { [::Java::Int] }
    # Sets the day of the month of this <tt>Date</tt> object to the
    # specified value. This <tt>Date</tt> object is modified so that
    # it represents a point in time within the specified day of the
    # month, with the year, month, hour, minute, and second the same
    # as before, as interpreted in the local time zone. If the date
    # was April 30, for example, and the date is set to 31, then it
    # will be treated as if it were on May 1, because April has only
    # 30 days.
    # 
    # @param   date   the day of the month value between 1-31.
    # @see     java.util.Calendar
    # @deprecated As of JDK version 1.1,
    # replaced by <code>Calendar.set(Calendar.DAY_OF_MONTH, int date)</code>.
    def set_date(date)
      get_calendar_date.set_day_of_month(date)
    end
    
    typesig { [] }
    # Returns the day of the week represented by this date. The
    # returned value (<tt>0</tt> = Sunday, <tt>1</tt> = Monday,
    # <tt>2</tt> = Tuesday, <tt>3</tt> = Wednesday, <tt>4</tt> =
    # Thursday, <tt>5</tt> = Friday, <tt>6</tt> = Saturday)
    # represents the day of the week that contains or begins with
    # the instant in time represented by this <tt>Date</tt> object,
    # as interpreted in the local time zone.
    # 
    # @return  the day of the week represented by this date.
    # @see     java.util.Calendar
    # @deprecated As of JDK version 1.1,
    # replaced by <code>Calendar.get(Calendar.DAY_OF_WEEK)</code>.
    def get_day
      return normalize.get_day_of_week - Gcal.attr_sunday
    end
    
    typesig { [] }
    # Returns the hour represented by this <tt>Date</tt> object. The
    # returned value is a number (<tt>0</tt> through <tt>23</tt>)
    # representing the hour within the day that contains or begins
    # with the instant in time represented by this <tt>Date</tt>
    # object, as interpreted in the local time zone.
    # 
    # @return  the hour represented by this date.
    # @see     java.util.Calendar
    # @deprecated As of JDK version 1.1,
    # replaced by <code>Calendar.get(Calendar.HOUR_OF_DAY)</code>.
    def get_hours
      return normalize.get_hours
    end
    
    typesig { [::Java::Int] }
    # Sets the hour of this <tt>Date</tt> object to the specified value.
    # This <tt>Date</tt> object is modified so that it represents a point
    # in time within the specified hour of the day, with the year, month,
    # date, minute, and second the same as before, as interpreted in the
    # local time zone.
    # 
    # @param   hours   the hour value.
    # @see     java.util.Calendar
    # @deprecated As of JDK version 1.1,
    # replaced by <code>Calendar.set(Calendar.HOUR_OF_DAY, int hours)</code>.
    def set_hours(hours)
      get_calendar_date.set_hours(hours)
    end
    
    typesig { [] }
    # Returns the number of minutes past the hour represented by this date,
    # as interpreted in the local time zone.
    # The value returned is between <code>0</code> and <code>59</code>.
    # 
    # @return  the number of minutes past the hour represented by this date.
    # @see     java.util.Calendar
    # @deprecated As of JDK version 1.1,
    # replaced by <code>Calendar.get(Calendar.MINUTE)</code>.
    def get_minutes
      return normalize.get_minutes
    end
    
    typesig { [::Java::Int] }
    # Sets the minutes of this <tt>Date</tt> object to the specified value.
    # This <tt>Date</tt> object is modified so that it represents a point
    # in time within the specified minute of the hour, with the year, month,
    # date, hour, and second the same as before, as interpreted in the
    # local time zone.
    # 
    # @param   minutes   the value of the minutes.
    # @see     java.util.Calendar
    # @deprecated As of JDK version 1.1,
    # replaced by <code>Calendar.set(Calendar.MINUTE, int minutes)</code>.
    def set_minutes(minutes)
      get_calendar_date.set_minutes(minutes)
    end
    
    typesig { [] }
    # Returns the number of seconds past the minute represented by this date.
    # The value returned is between <code>0</code> and <code>61</code>. The
    # values <code>60</code> and <code>61</code> can only occur on those
    # Java Virtual Machines that take leap seconds into account.
    # 
    # @return  the number of seconds past the minute represented by this date.
    # @see     java.util.Calendar
    # @deprecated As of JDK version 1.1,
    # replaced by <code>Calendar.get(Calendar.SECOND)</code>.
    def get_seconds
      return normalize.get_seconds
    end
    
    typesig { [::Java::Int] }
    # Sets the seconds of this <tt>Date</tt> to the specified value.
    # This <tt>Date</tt> object is modified so that it represents a
    # point in time within the specified second of the minute, with
    # the year, month, date, hour, and minute the same as before, as
    # interpreted in the local time zone.
    # 
    # @param   seconds   the seconds value.
    # @see     java.util.Calendar
    # @deprecated As of JDK version 1.1,
    # replaced by <code>Calendar.set(Calendar.SECOND, int seconds)</code>.
    def set_seconds(seconds)
      get_calendar_date.set_seconds(seconds)
    end
    
    typesig { [] }
    # Returns the number of milliseconds since January 1, 1970, 00:00:00 GMT
    # represented by this <tt>Date</tt> object.
    # 
    # @return  the number of milliseconds since January 1, 1970, 00:00:00 GMT
    # represented by this date.
    def get_time
      return get_time_impl
    end
    
    typesig { [] }
    def get_time_impl
      if (!(@cdate).nil? && !@cdate.is_normalized)
        normalize
      end
      return @fast_time
    end
    
    typesig { [::Java::Long] }
    # Sets this <code>Date</code> object to represent a point in time that is
    # <code>time</code> milliseconds after January 1, 1970 00:00:00 GMT.
    # 
    # @param   time   the number of milliseconds.
    def set_time(time)
      @fast_time = time
      @cdate = nil
    end
    
    typesig { [JavaDate] }
    # Tests if this date is before the specified date.
    # 
    # @param   when   a date.
    # @return  <code>true</code> if and only if the instant of time
    # represented by this <tt>Date</tt> object is strictly
    # earlier than the instant represented by <tt>when</tt>;
    # <code>false</code> otherwise.
    # @exception NullPointerException if <code>when</code> is null.
    def before(when_)
      return get_millis_of(self) < get_millis_of(when_)
    end
    
    typesig { [JavaDate] }
    # Tests if this date is after the specified date.
    # 
    # @param   when   a date.
    # @return  <code>true</code> if and only if the instant represented
    # by this <tt>Date</tt> object is strictly later than the
    # instant represented by <tt>when</tt>;
    # <code>false</code> otherwise.
    # @exception NullPointerException if <code>when</code> is null.
    def after(when_)
      return get_millis_of(self) > get_millis_of(when_)
    end
    
    typesig { [Object] }
    # Compares two dates for equality.
    # The result is <code>true</code> if and only if the argument is
    # not <code>null</code> and is a <code>Date</code> object that
    # represents the same point in time, to the millisecond, as this object.
    # <p>
    # Thus, two <code>Date</code> objects are equal if and only if the
    # <code>getTime</code> method returns the same <code>long</code>
    # value for both.
    # 
    # @param   obj   the object to compare with.
    # @return  <code>true</code> if the objects are the same;
    # <code>false</code> otherwise.
    # @see     java.util.Date#getTime()
    def ==(obj)
      return obj.is_a?(JavaDate) && (get_time).equal?((obj).get_time)
    end
    
    class_module.module_eval {
      typesig { [JavaDate] }
      # Returns the millisecond value of this <code>Date</code> object
      # without affecting its internal state.
      def get_millis_of(date)
        if ((date.attr_cdate).nil?)
          return date.attr_fast_time
        end
        d = date.attr_cdate.clone
        return Gcal.get_time(d)
      end
    }
    
    typesig { [JavaDate] }
    # Compares two Dates for ordering.
    # 
    # @param   anotherDate   the <code>Date</code> to be compared.
    # @return  the value <code>0</code> if the argument Date is equal to
    # this Date; a value less than <code>0</code> if this Date
    # is before the Date argument; and a value greater than
    # <code>0</code> if this Date is after the Date argument.
    # @since   1.2
    # @exception NullPointerException if <code>anotherDate</code> is null.
    def compare_to(another_date)
      this_time = get_millis_of(self)
      another_time = get_millis_of(another_date)
      return (this_time < another_time ? -1 : ((this_time).equal?(another_time) ? 0 : 1))
    end
    
    typesig { [] }
    # Returns a hash code value for this object. The result is the
    # exclusive OR of the two halves of the primitive <tt>long</tt>
    # value returned by the {@link Date#getTime}
    # method. That is, the hash code is the value of the expression:
    # <blockquote><pre>
    # (int)(this.getTime()^(this.getTime() >>> 32))</pre></blockquote>
    # 
    # @return  a hash code value for this object.
    def hash_code
      ht = self.get_time
      return RJava.cast_to_int(ht) ^ RJava.cast_to_int((ht >> 32))
    end
    
    typesig { [] }
    # Converts this <code>Date</code> object to a <code>String</code>
    # of the form:
    # <blockquote><pre>
    # dow mon dd hh:mm:ss zzz yyyy</pre></blockquote>
    # where:<ul>
    # <li><tt>dow</tt> is the day of the week (<tt>Sun, Mon, Tue, Wed,
    # Thu, Fri, Sat</tt>).
    # <li><tt>mon</tt> is the month (<tt>Jan, Feb, Mar, Apr, May, Jun,
    # Jul, Aug, Sep, Oct, Nov, Dec</tt>).
    # <li><tt>dd</tt> is the day of the month (<tt>01</tt> through
    # <tt>31</tt>), as two decimal digits.
    # <li><tt>hh</tt> is the hour of the day (<tt>00</tt> through
    # <tt>23</tt>), as two decimal digits.
    # <li><tt>mm</tt> is the minute within the hour (<tt>00</tt> through
    # <tt>59</tt>), as two decimal digits.
    # <li><tt>ss</tt> is the second within the minute (<tt>00</tt> through
    # <tt>61</tt>, as two decimal digits.
    # <li><tt>zzz</tt> is the time zone (and may reflect daylight saving
    # time). Standard time zone abbreviations include those
    # recognized by the method <tt>parse</tt>. If time zone
    # information is not available, then <tt>zzz</tt> is empty -
    # that is, it consists of no characters at all.
    # <li><tt>yyyy</tt> is the year, as four decimal digits.
    # </ul>
    # 
    # @return  a string representation of this date.
    # @see     java.util.Date#toLocaleString()
    # @see     java.util.Date#toGMTString()
    def to_s
      # "EEE MMM dd HH:mm:ss zzz yyyy";
      date = normalize
      sb = StringBuilder.new(28)
      index = date.get_day_of_week
      if ((index).equal?(Gcal.attr_sunday))
        index = 8
      end
      convert_to_abbr(sb, Wtb[index]).append(Character.new(?\s.ord)) # EEE
      convert_to_abbr(sb, Wtb[date.get_month - 1 + 2 + 7]).append(Character.new(?\s.ord)) # MMM
      CalendarUtils.sprintf0d(sb, date.get_day_of_month, 2).append(Character.new(?\s.ord)) # dd
      CalendarUtils.sprintf0d(sb, date.get_hours, 2).append(Character.new(?:.ord)) # HH
      CalendarUtils.sprintf0d(sb, date.get_minutes, 2).append(Character.new(?:.ord)) # mm
      CalendarUtils.sprintf0d(sb, date.get_seconds, 2).append(Character.new(?\s.ord)) # ss
      zi = date.get_zone
      if (!(zi).nil?)
        sb.append(zi.get_display_name(date.is_daylight_time, zi.attr_short, Locale::US)) # zzz
      else
        sb.append("GMT")
      end
      sb.append(Character.new(?\s.ord)).append(date.get_year) # yyyy
      return sb.to_s
    end
    
    class_module.module_eval {
      typesig { [StringBuilder, String] }
      # Converts the given name to its 3-letter abbreviation (e.g.,
      # "monday" -> "Mon") and stored the abbreviation in the given
      # <code>StringBuilder</code>.
      def convert_to_abbr(sb, name)
        sb.append(Character.to_upper_case(name.char_at(0)))
        sb.append(name.char_at(1)).append(name.char_at(2))
        return sb
      end
    }
    
    typesig { [] }
    # Creates a string representation of this <tt>Date</tt> object in an
    # implementation-dependent form. The intent is that the form should
    # be familiar to the user of the Java application, wherever it may
    # happen to be running. The intent is comparable to that of the
    # "<code>%c</code>" format supported by the <code>strftime()</code>
    # function of ISO&nbsp;C.
    # 
    # @return  a string representation of this date, using the locale
    # conventions.
    # @see     java.text.DateFormat
    # @see     java.util.Date#toString()
    # @see     java.util.Date#toGMTString()
    # @deprecated As of JDK version 1.1,
    # replaced by <code>DateFormat.format(Date date)</code>.
    def to_locale_string
      formatter = DateFormat.get_date_time_instance
      return formatter.format(self)
    end
    
    typesig { [] }
    # Creates a string representation of this <tt>Date</tt> object of
    # the form:
    # <blockquote<pre>
    # d mon yyyy hh:mm:ss GMT</pre></blockquote>
    # where:<ul>
    # <li><i>d</i> is the day of the month (<tt>1</tt> through <tt>31</tt>),
    # as one or two decimal digits.
    # <li><i>mon</i> is the month (<tt>Jan, Feb, Mar, Apr, May, Jun, Jul,
    # Aug, Sep, Oct, Nov, Dec</tt>).
    # <li><i>yyyy</i> is the year, as four decimal digits.
    # <li><i>hh</i> is the hour of the day (<tt>00</tt> through <tt>23</tt>),
    # as two decimal digits.
    # <li><i>mm</i> is the minute within the hour (<tt>00</tt> through
    # <tt>59</tt>), as two decimal digits.
    # <li><i>ss</i> is the second within the minute (<tt>00</tt> through
    # <tt>61</tt>), as two decimal digits.
    # <li><i>GMT</i> is exactly the ASCII letters "<tt>GMT</tt>" to indicate
    # Greenwich Mean Time.
    # </ul><p>
    # The result does not depend on the local time zone.
    # 
    # @return  a string representation of this date, using the Internet GMT
    # conventions.
    # @see     java.text.DateFormat
    # @see     java.util.Date#toString()
    # @see     java.util.Date#toLocaleString()
    # @deprecated As of JDK version 1.1,
    # replaced by <code>DateFormat.format(Date date)</code>, using a
    # GMT <code>TimeZone</code>.
    def to_gmtstring
      # d MMM yyyy HH:mm:ss 'GMT'
      t = get_time
      cal = get_calendar_system(t)
      date = cal.get_calendar_date(get_time, nil)
      sb = StringBuilder.new(32)
      CalendarUtils.sprintf0d(sb, date.get_day_of_month, 1).append(Character.new(?\s.ord)) # d
      convert_to_abbr(sb, Wtb[date.get_month - 1 + 2 + 7]).append(Character.new(?\s.ord)) # MMM
      sb.append(date.get_year).append(Character.new(?\s.ord)) # yyyy
      CalendarUtils.sprintf0d(sb, date.get_hours, 2).append(Character.new(?:.ord)) # HH
      CalendarUtils.sprintf0d(sb, date.get_minutes, 2).append(Character.new(?:.ord)) # mm
      CalendarUtils.sprintf0d(sb, date.get_seconds, 2) # ss
      sb.append(" GMT") # ' GMT'
      return sb.to_s
    end
    
    typesig { [] }
    # Returns the offset, measured in minutes, for the local time zone
    # relative to UTC that is appropriate for the time represented by
    # this <code>Date</code> object.
    # <p>
    # For example, in Massachusetts, five time zones west of Greenwich:
    # <blockquote><pre>
    # new Date(96, 1, 14).getTimezoneOffset() returns 300</pre></blockquote>
    # because on February 14, 1996, standard time (Eastern Standard Time)
    # is in use, which is offset five hours from UTC; but:
    # <blockquote><pre>
    # new Date(96, 5, 1).getTimezoneOffset() returns 240</pre></blockquote>
    # because on June 1, 1996, daylight saving time (Eastern Daylight Time)
    # is in use, which is offset only four hours from UTC.<p>
    # This method produces the same result as if it computed:
    # <blockquote><pre>
    # (this.getTime() - UTC(this.getYear(),
    # this.getMonth(),
    # this.getDate(),
    # this.getHours(),
    # this.getMinutes(),
    # this.getSeconds())) / (60 * 1000)
    # </pre></blockquote>
    # 
    # @return  the time-zone offset, in minutes, for the current time zone.
    # @see     java.util.Calendar#ZONE_OFFSET
    # @see     java.util.Calendar#DST_OFFSET
    # @see     java.util.TimeZone#getDefault
    # @deprecated As of JDK version 1.1,
    # replaced by <code>-(Calendar.get(Calendar.ZONE_OFFSET) +
    # Calendar.get(Calendar.DST_OFFSET)) / (60 * 1000)</code>.
    def get_timezone_offset
      zone_offset = 0
      if ((@cdate).nil?)
        tz = TimeZone.get_default_ref
        if (tz.is_a?(ZoneInfo))
          zone_offset = (tz).get_offsets(@fast_time, nil)
        else
          zone_offset = tz.get_offset(@fast_time)
        end
      else
        normalize
        zone_offset = @cdate.get_zone_offset
      end
      return -zone_offset / 60000 # convert to minutes
    end
    
    typesig { [] }
    def get_calendar_date
      if ((@cdate).nil?)
        cal = get_calendar_system(@fast_time)
        @cdate = cal.get_calendar_date(@fast_time, TimeZone.get_default_ref)
      end
      return @cdate
    end
    
    typesig { [] }
    def normalize
      if ((@cdate).nil?)
        cal = get_calendar_system(@fast_time)
        @cdate = cal.get_calendar_date(@fast_time, TimeZone.get_default_ref)
        return @cdate
      end
      # Normalize cdate with the TimeZone in cdate first. This is
      # required for the compatible behavior.
      if (!@cdate.is_normalized)
        @cdate = normalize(@cdate)
      end
      # If the default TimeZone has changed, then recalculate the
      # fields with the new TimeZone.
      tz = TimeZone.get_default_ref
      if (!(tz).equal?(@cdate.get_zone))
        @cdate.set_zone(tz)
        cal = get_calendar_system(@cdate)
        cal.get_calendar_date(@fast_time, @cdate)
      end
      return @cdate
    end
    
    typesig { [BaseCalendar::JavaDate] }
    # fastTime and the returned data are in sync upon return.
    def normalize(date)
      y = date.get_normalized_year
      m = date.get_month
      d = date.get_day_of_month
      hh = date.get_hours
      mm = date.get_minutes
      ss = date.get_seconds
      ms = date.get_millis
      tz = date.get_zone
      # If the specified year can't be handled using a long value
      # in milliseconds, GregorianCalendar is used for full
      # compatibility with underflow and overflow. This is required
      # by some JCK tests. The limits are based max year values -
      # years that can be represented by max values of d, hh, mm,
      # ss and ms. Also, let GregorianCalendar handle the default
      # cutover year so that we don't need to worry about the
      # transition here.
      if ((y).equal?(1582) || y > 280000000 || y < -280000000)
        if ((tz).nil?)
          tz = TimeZone.get_time_zone("GMT")
        end
        gc = GregorianCalendar.new(tz)
        gc.clear
        gc.set(gc.attr_millisecond, ms)
        gc.set(y, m - 1, d, hh, mm, ss)
        @fast_time = gc.get_time_in_millis
        cal = get_calendar_system(@fast_time)
        date = cal.get_calendar_date(@fast_time, tz)
        return date
      end
      cal = get_calendar_system(y)
      if (!(cal).equal?(get_calendar_system(date)))
        date = cal.new_calendar_date(tz)
        date.set_normalized_date(y, m, d).set_time_of_day(hh, mm, ss, ms)
      end
      # Perform the GregorianCalendar-style normalization.
      @fast_time = cal.get_time(date)
      # In case the normalized date requires the other calendar
      # system, we need to recalculate it using the other one.
      ncal = get_calendar_system(@fast_time)
      if (!(ncal).equal?(cal))
        date = ncal.new_calendar_date(tz)
        date.set_normalized_date(y, m, d).set_time_of_day(hh, mm, ss, ms)
        @fast_time = ncal.get_time(date)
      end
      return date
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Returns the Gregorian or Julian calendar system to use with the
      # given date. Use Gregorian from October 15, 1582.
      # 
      # @param year normalized calendar year (not -1900)
      # @return the CalendarSystem to use for the specified date
      def get_calendar_system(year)
        if (year >= 1582)
          return Gcal
        end
        return get_julian_calendar
      end
      
      typesig { [::Java::Long] }
      def get_calendar_system(utc)
        # Quickly check if the time stamp given by `utc' is the Epoch
        # or later. If it's before 1970, we convert the cutover to
        # local time to compare.
        if (utc >= 0 || utc >= GregorianCalendar::DEFAULT_GREGORIAN_CUTOVER - TimeZone.get_default_ref.get_offset(utc))
          return Gcal
        end
        return get_julian_calendar
      end
      
      typesig { [BaseCalendar::JavaDate] }
      def get_calendar_system(cdate)
        if ((self.attr_jcal).nil?)
          return Gcal
        end
        if (!(cdate.get_era).nil?)
          return self.attr_jcal
        end
        return Gcal
      end
      
      typesig { [] }
      def get_julian_calendar
        synchronized(self) do
          if ((self.attr_jcal).nil?)
            self.attr_jcal = CalendarSystem.for_name("julian")
          end
          return self.attr_jcal
        end
      end
    }
    
    typesig { [ObjectOutputStream] }
    # Save the state of this object to a stream (i.e., serialize it).
    # 
    # @serialData The value returned by <code>getTime()</code>
    # is emitted (long).  This represents the offset from
    # January 1, 1970, 00:00:00 GMT in milliseconds.
    def write_object(s)
      s.write_long(get_time_impl)
    end
    
    typesig { [ObjectInputStream] }
    # Reconstitute this object from a stream (i.e., deserialize it).
    def read_object(s)
      @fast_time = s.read_long
    end
    
    private
    alias_method :initialize__date, :initialize
  end
  
end
