require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module LocalGregorianCalendarImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util::Calendar
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :FileInputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Properties
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :TimeZone
    }
  end
  
  # @author Masayoshi Okutsu
  # @since 1.6
  class LocalGregorianCalendar < LocalGregorianCalendarImports.const_get :BaseCalendar
    include_class_members LocalGregorianCalendarImports
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :eras
    alias_method :attr_eras, :eras
    undef_method :eras
    alias_method :attr_eras=, :eras=
    undef_method :eras=
    
    class_module.module_eval {
      const_set_lazy(:JavaDate) { Class.new(BaseCalendar::JavaDate) do
        include_class_members LocalGregorianCalendar
        
        typesig { [] }
        def initialize
          @gregorian_year = 0
          super()
          @gregorian_year = FIELD_UNDEFINED
        end
        
        typesig { [class_self::TimeZone] }
        def initialize(zone)
          @gregorian_year = 0
          super(zone)
          @gregorian_year = FIELD_UNDEFINED
        end
        
        attr_accessor :gregorian_year
        alias_method :attr_gregorian_year, :gregorian_year
        undef_method :gregorian_year
        alias_method :attr_gregorian_year=, :gregorian_year=
        undef_method :gregorian_year=
        
        typesig { [class_self::Era] }
        def set_era(era)
          if (!(get_era).equal?(era))
            super(era)
            @gregorian_year = FIELD_UNDEFINED
          end
          return self
        end
        
        typesig { [::Java::Int] }
        def add_year(local_year)
          super(local_year)
          @gregorian_year += local_year
          return self
        end
        
        typesig { [::Java::Int] }
        def set_year(local_year)
          if (!(get_year).equal?(local_year))
            super(local_year)
            @gregorian_year = FIELD_UNDEFINED
          end
          return self
        end
        
        typesig { [] }
        def get_normalized_year
          return @gregorian_year
        end
        
        typesig { [::Java::Int] }
        def set_normalized_year(normalized_year)
          @gregorian_year = normalized_year
        end
        
        typesig { [class_self::Era] }
        def set_local_era(era)
          BaseCalendar::JavaDate.instance_method(:set_era).bind(self).call(era)
        end
        
        typesig { [::Java::Int] }
        def set_local_year(year)
          BaseCalendar::JavaDate.instance_method(:set_year).bind(self).call(year)
        end
        
        typesig { [] }
        def to_s
          time = super
          time = RJava.cast_to_string(time.substring(time.index_of(Character.new(?T.ord))))
          sb = self.class::StringBuffer.new
          era = get_era
          if (!(era).nil?)
            abbr = era.get_abbreviation
            if (!(abbr).nil?)
              sb.append(abbr)
            end
          end
          sb.append(get_year).append(Character.new(?..ord))
          CalendarUtils.sprintf0d(sb, get_month, 2).append(Character.new(?..ord))
          CalendarUtils.sprintf0d(sb, get_day_of_month, 2)
          sb.append(time)
          return sb.to_s
        end
        
        private
        alias_method :initialize__date, :initialize
      end }
      
      typesig { [String] }
      def get_local_gregorian_calendar(name)
        calendar_props = nil
        begin
          home_dir = AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("java.home"))
          fname = home_dir + RJava.cast_to_string(JavaFile.attr_separator) + "lib" + RJava.cast_to_string(JavaFile.attr_separator) + "calendars.properties"
          calendar_props = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
            extend LocalClass
            include_class_members LocalGregorianCalendar
            include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
            
            typesig { [] }
            define_method :run do
              props = self.class::Properties.new
              props.load(self.class::FileInputStream.new(fname))
              return props
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        rescue PrivilegedActionException => e
          raise RuntimeException.new(e.get_exception)
        end
        # Parse calendar.*.eras
        props = calendar_props.get_property("calendar." + name + ".eras")
        if ((props).nil?)
          return nil
        end
        eras = ArrayList.new
        era_tokens = StringTokenizer.new(props, ";")
        while (era_tokens.has_more_tokens)
          items = era_tokens.next_token.trim
          item_tokens = StringTokenizer.new(items, ",")
          era_name = nil
          local_time = true
          since = 0
          abbr = nil
          while (item_tokens.has_more_tokens)
            item = item_tokens.next_token
            index = item.index_of(Character.new(?=.ord))
            # it must be in the key=value form.
            if ((index).equal?(-1))
              return nil
            end
            key = item.substring(0, index)
            value = item.substring(index + 1)
            if (("name" == key))
              era_name = value
            else
              if (("since" == key))
                if (value.ends_with("u"))
                  local_time = false
                  since = Long.parse_long(value.substring(0, value.length - 1))
                else
                  since = Long.parse_long(value)
                end
              else
                if (("abbr" == key))
                  abbr = value
                else
                  raise RuntimeException.new("Unknown key word: " + key)
                end
              end
            end
          end
          era = Era.new(era_name, abbr, since, local_time)
          eras.add(era)
        end
        era_array = Array.typed(Era).new(eras.size) { nil }
        eras.to_array(era_array)
        return LocalGregorianCalendar.new(name, era_array)
      end
    }
    
    typesig { [String, Array.typed(Era)] }
    def initialize(name, eras)
      @name = nil
      @eras = nil
      super()
      @name = name
      @eras = eras
      set_eras(eras)
    end
    
    typesig { [] }
    def get_name
      return @name
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
      return get_calendar_date(millis, new_calendar_date(zone))
    end
    
    typesig { [::Java::Long, CalendarDate] }
    def get_calendar_date(millis, date)
      ldate = super(millis, date)
      return adjust_year(ldate, millis, ldate.get_zone_offset)
    end
    
    typesig { [JavaDate, ::Java::Long, ::Java::Int] }
    def adjust_year(ldate, millis, zone_offset)
      i = 0
      i = @eras.attr_length - 1
      while i >= 0
        era = @eras[i]
        since = era.get_since(nil)
        if (era.is_local_time)
          since -= zone_offset
        end
        if (millis >= since)
          ldate.set_local_era(era)
          y = ldate.get_normalized_year - era.get_since_date.get_year + 1
          ldate.set_local_year(y)
          break
        end
        (i -= 1)
      end
      if (i < 0)
        ldate.set_local_era(nil)
        ldate.set_local_year(ldate.get_normalized_year)
      end
      ldate.set_normalized(true)
      return ldate
    end
    
    typesig { [] }
    def new_calendar_date
      return JavaDate.new
    end
    
    typesig { [TimeZone] }
    def new_calendar_date(zone)
      return JavaDate.new(zone)
    end
    
    typesig { [CalendarDate] }
    def validate(date)
      ldate = date
      era = ldate.get_era
      if (!(era).nil?)
        if (!validate_era(era))
          return false
        end
        ldate.set_normalized_year(era.get_since_date.get_year + ldate.get_year)
      else
        ldate.set_normalized_year(ldate.get_year)
      end
      return super(ldate)
    end
    
    typesig { [Era] }
    def validate_era(era)
      # Validate the era
      i = 0
      while i < @eras.attr_length
        if ((era).equal?(@eras[i]))
          return true
        end
        i += 1
      end
      return false
    end
    
    typesig { [CalendarDate] }
    def normalize(date)
      if (date.is_normalized)
        return true
      end
      normalize_year(date)
      ldate = date
      # Normalize it as a Gregorian date and get its millisecond value
      super(ldate)
      has_millis = false
      millis = 0
      year = ldate.get_normalized_year
      i = 0
      era = nil
      i = @eras.attr_length - 1
      while i >= 0
        era = @eras[i]
        if (era.is_local_time)
          since_date = era.get_since_date
          since_year = since_date.get_year
          if (year > since_year)
            break
          end
          if ((year).equal?(since_year))
            month = ldate.get_month
            since_month = since_date.get_month
            if (month > since_month)
              break
            end
            if ((month).equal?(since_month))
              day = ldate.get_day_of_month
              since_day = since_date.get_day_of_month
              if (day > since_day)
                break
              end
              if ((day).equal?(since_day))
                time_of_day = ldate.get_time_of_day
                since_time_of_day = since_date.get_time_of_day
                if (time_of_day >= since_time_of_day)
                  break
                end
                (i -= 1)
                break
              end
            end
          end
        else
          if (!has_millis)
            millis = BaseCalendar.instance_method(:get_time).bind(self).call(date)
            has_millis = true
          end
          since = era.get_since(date.get_zone)
          if (millis >= since)
            break
          end
        end
        (i -= 1)
      end
      if (i >= 0)
        ldate.set_local_era(era)
        y = ldate.get_normalized_year - era.get_since_date.get_year + 1
        ldate.set_local_year(y)
      else
        # Set Gregorian year with no era
        ldate.set_era(nil)
        ldate.set_local_year(year)
        ldate.set_normalized_year(year)
      end
      ldate.set_normalized(true)
      return true
    end
    
    typesig { [CalendarDate] }
    def normalize_month(date)
      normalize_year(date)
      super(date)
    end
    
    typesig { [CalendarDate] }
    def normalize_year(date)
      ldate = date
      # Set the supposed-to-be-correct Gregorian year first
      # e.g., Showa 90 becomes 2015 (1926 + 90 - 1).
      era = ldate.get_era
      if ((era).nil? || !validate_era(era))
        ldate.set_normalized_year(ldate.get_year)
      else
        ldate.set_normalized_year(era.get_since_date.get_year + ldate.get_year - 1)
      end
    end
    
    typesig { [::Java::Int] }
    # Returns whether the specified Gregorian year is a leap year.
    # @see #isLeapYear(Era, int)
    def is_leap_year(gregorian_year)
      return CalendarUtils.is_gregorian_leap_year(gregorian_year)
    end
    
    typesig { [Era, ::Java::Int] }
    def is_leap_year(era, year)
      if ((era).nil?)
        return is_leap_year(year)
      end
      gyear = era.get_since_date.get_year + year - 1
      return is_leap_year(gyear)
    end
    
    typesig { [CalendarDate, ::Java::Long] }
    def get_calendar_date_from_fixed_date(date, fixed_date)
      ldate = date
      super(ldate, fixed_date)
      adjust_year(ldate, (fixed_date - EPOCH_OFFSET) * DAY_IN_MILLIS, 0)
    end
    
    private
    alias_method :initialize__local_gregorian_calendar, :initialize
  end
  
end
