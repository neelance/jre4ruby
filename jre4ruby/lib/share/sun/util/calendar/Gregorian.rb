require "rjava"

# Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module GregorianImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util::Calendar
      include_const ::Java::Util, :TimeZone
    }
  end
  
  # Gregorian calendar implementation.
  # 
  # @author Masayoshi Okutsu
  # @since 1.5
  class Gregorian < GregorianImports.const_get :BaseCalendar
    include_class_members GregorianImports
    
    class_module.module_eval {
      const_set_lazy(:Date) { Class.new(BaseCalendar::Date) do
        include_class_members Gregorian
        
        typesig { [] }
        def initialize
          super()
        end
        
        typesig { [class_self::TimeZone] }
        def initialize(zone)
          super(zone)
        end
        
        typesig { [] }
        def get_normalized_year
          return get_year
        end
        
        typesig { [::Java::Int] }
        def set_normalized_year(normalized_year)
          set_year(normalized_year)
        end
        
        private
        alias_method :initialize__date, :initialize
      end }
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    typesig { [] }
    def get_name
      return "gregorian"
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
      return Date.new
    end
    
    typesig { [TimeZone] }
    def new_calendar_date(zone)
      return Date.new(zone)
    end
    
    private
    alias_method :initialize__gregorian, :initialize
  end
  
end
