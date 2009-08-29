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
  module ImmutableGregorianDateImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util::Calendar
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :TimeZone
    }
  end
  
  class ImmutableGregorianDate < ImmutableGregorianDateImports.const_get :BaseCalendar::JavaDate
    include_class_members ImmutableGregorianDateImports
    
    attr_accessor :date
    alias_method :attr_date, :date
    undef_method :date
    alias_method :attr_date=, :date=
    undef_method :date=
    
    typesig { [BaseCalendar::JavaDate] }
    def initialize(date)
      @date = nil
      super()
      if ((date).nil?)
        raise NullPointerException.new
      end
      @date = date
    end
    
    typesig { [] }
    def get_era
      return @date.get_era
    end
    
    typesig { [Era] }
    def set_era(era)
      unsupported
      return self
    end
    
    typesig { [] }
    def get_year
      return @date.get_year
    end
    
    typesig { [::Java::Int] }
    def set_year(year)
      unsupported
      return self
    end
    
    typesig { [::Java::Int] }
    def add_year(n)
      unsupported
      return self
    end
    
    typesig { [] }
    def is_leap_year
      return @date.is_leap_year
    end
    
    typesig { [::Java::Boolean] }
    def set_leap_year(leap_year)
      unsupported
    end
    
    typesig { [] }
    def get_month
      return @date.get_month
    end
    
    typesig { [::Java::Int] }
    def set_month(month)
      unsupported
      return self
    end
    
    typesig { [::Java::Int] }
    def add_month(n)
      unsupported
      return self
    end
    
    typesig { [] }
    def get_day_of_month
      return @date.get_day_of_month
    end
    
    typesig { [::Java::Int] }
    def set_day_of_month(date)
      unsupported
      return self
    end
    
    typesig { [::Java::Int] }
    def add_day_of_month(n)
      unsupported
      return self
    end
    
    typesig { [] }
    def get_day_of_week
      return @date.get_day_of_week
    end
    
    typesig { [] }
    def get_hours
      return @date.get_hours
    end
    
    typesig { [::Java::Int] }
    def set_hours(hours)
      unsupported
      return self
    end
    
    typesig { [::Java::Int] }
    def add_hours(n)
      unsupported
      return self
    end
    
    typesig { [] }
    def get_minutes
      return @date.get_minutes
    end
    
    typesig { [::Java::Int] }
    def set_minutes(minutes)
      unsupported
      return self
    end
    
    typesig { [::Java::Int] }
    def add_minutes(n)
      unsupported
      return self
    end
    
    typesig { [] }
    def get_seconds
      return @date.get_seconds
    end
    
    typesig { [::Java::Int] }
    def set_seconds(seconds)
      unsupported
      return self
    end
    
    typesig { [::Java::Int] }
    def add_seconds(n)
      unsupported
      return self
    end
    
    typesig { [] }
    def get_millis
      return @date.get_millis
    end
    
    typesig { [::Java::Int] }
    def set_millis(millis)
      unsupported
      return self
    end
    
    typesig { [::Java::Int] }
    def add_millis(n)
      unsupported
      return self
    end
    
    typesig { [] }
    def get_time_of_day
      return @date.get_time_of_day
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    def set_date(year, month, day_of_month)
      unsupported
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    def add_date(year, month, day_of_month)
      unsupported
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    def set_time_of_day(hours, minutes, seconds, millis)
      unsupported
      return self
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    def add_time_of_day(hours, minutes, seconds, millis)
      unsupported
      return self
    end
    
    typesig { [::Java::Long] }
    def set_time_of_day(fraction)
      unsupported
    end
    
    typesig { [] }
    def is_normalized
      return @date.is_normalized
    end
    
    typesig { [] }
    def is_standard_time
      return @date.is_standard_time
    end
    
    typesig { [::Java::Boolean] }
    def set_standard_time(standard_time)
      unsupported
    end
    
    typesig { [] }
    def is_daylight_time
      return @date.is_daylight_time
    end
    
    typesig { [Locale] }
    def set_locale(loc)
      unsupported
    end
    
    typesig { [] }
    def get_zone
      return @date.get_zone
    end
    
    typesig { [TimeZone] }
    def set_zone(zoneinfo)
      unsupported
      return self
    end
    
    typesig { [CalendarDate] }
    def is_same_date(date)
      return date.is_same_date(date)
    end
    
    typesig { [Object] }
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(ImmutableGregorianDate)))
        return false
      end
      return (@date == (obj).attr_date)
    end
    
    typesig { [] }
    def hash_code
      return @date.hash_code
    end
    
    typesig { [] }
    def clone
      return super
    end
    
    typesig { [] }
    def to_s
      return @date.to_s
    end
    
    typesig { [::Java::Int] }
    def set_day_of_week(day_of_week)
      unsupported
    end
    
    typesig { [::Java::Boolean] }
    def set_normalized(normalized)
      unsupported
    end
    
    typesig { [] }
    def get_zone_offset
      return @date.get_zone_offset
    end
    
    typesig { [::Java::Int] }
    def set_zone_offset(offset)
      unsupported
    end
    
    typesig { [] }
    def get_daylight_saving
      return @date.get_daylight_saving
    end
    
    typesig { [::Java::Int] }
    def set_daylight_saving(daylight_saving)
      unsupported
    end
    
    typesig { [] }
    def get_normalized_year
      return @date.get_normalized_year
    end
    
    typesig { [::Java::Int] }
    def set_normalized_year(normalized_year)
      unsupported
    end
    
    typesig { [] }
    def unsupported
      raise UnsupportedOperationException.new
    end
    
    private
    alias_method :initialize__immutable_gregorian_date, :initialize
  end
  
end
