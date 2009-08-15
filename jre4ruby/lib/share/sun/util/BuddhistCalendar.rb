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
module Sun::Util
  module BuddhistCalendarImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util
      include_const ::Java::Util, :Calendar
      include_const ::Java::Util, :GregorianCalendar
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util, :TimeZone
      include_const ::Sun::Util::Resources, :LocaleData
    }
  end
  
  class BuddhistCalendar < BuddhistCalendarImports.const_get :GregorianCalendar
    include_class_members BuddhistCalendarImports
    
    class_module.module_eval {
      # ////////////////
      # Class Variables
      # ////////////////
      const_set_lazy(:SerialVersionUID) { -8527488697350388578 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:BuddhistOffset) { 543 }
      const_attr_reader  :BuddhistOffset
    }
    
    typesig { [] }
    # /////////////
    # Constructors
    # /////////////
    # 
    # Constructs a default BuddhistCalendar using the current time
    # in the default time zone with the default locale.
    def initialize
      @year_offset = 0
      super()
      @year_offset = BuddhistOffset
    end
    
    typesig { [TimeZone] }
    # Constructs a BuddhistCalendar based on the current time
    # in the given time zone with the default locale.
    # @param zone the given time zone.
    def initialize(zone)
      @year_offset = 0
      super(zone)
      @year_offset = BuddhistOffset
    end
    
    typesig { [Locale] }
    # Constructs a BuddhistCalendar based on the current time
    # in the default time zone with the given locale.
    # @param aLocale the given locale.
    def initialize(a_locale)
      @year_offset = 0
      super(a_locale)
      @year_offset = BuddhistOffset
    end
    
    typesig { [TimeZone, Locale] }
    # Constructs a BuddhistCalendar based on the current time
    # in the given time zone with the given locale.
    # @param zone the given time zone.
    # @param aLocale the given locale.
    def initialize(zone, a_locale)
      @year_offset = 0
      super(zone, a_locale)
      @year_offset = BuddhistOffset
    end
    
    typesig { [Object] }
    # ///////////////
    # Public methods
    # ///////////////
    # 
    # Compares this BuddhistCalendar to an object reference.
    # @param obj the object reference with which to compare
    # @return true if this object is equal to <code>obj</code>; false otherwise
    def ==(obj)
      return obj.is_a?(BuddhistCalendar) && super(obj)
    end
    
    typesig { [] }
    # Override hashCode.
    # Generates the hash code for the BuddhistCalendar object
    def hash_code
      return super ^ BuddhistOffset
    end
    
    typesig { [::Java::Int] }
    # Gets the value for a given time field.
    # @param field the given time field.
    # @return the value for the given time field.
    def get(field)
      if ((field).equal?(YEAR))
        return super(field) + @year_offset
      end
      return super(field)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the time field with the given value.
    # @param field the given time field.
    # @param value the value to be set for the given time field.
    def set(field, value)
      if ((field).equal?(YEAR))
        super(field, value - @year_offset)
      else
        super(field, value)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Adds the specified (signed) amount of time to the given time field.
    # @param field the time field.
    # @param amount the amount of date or time to be added to the field.
    def add(field, amount)
      saved_year_offset = @year_offset
      @year_offset = 0
      begin
        super(field, amount)
      ensure
        @year_offset = saved_year_offset
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Add to field a signed amount without changing larger fields.
    # A negative roll amount means to subtract from field without changing
    # larger fields.
    # @param field the time field.
    # @param amount the signed amount to add to <code>field</code>.
    def roll(field, amount)
      saved_year_offset = @year_offset
      @year_offset = 0
      begin
        super(field, amount)
      ensure
        @year_offset = saved_year_offset
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, Locale] }
    def get_display_name(field, style, locale)
      if (!(field).equal?(ERA))
        return super(field, style, locale)
      end
      # Handle Thai BuddhistCalendar specific era names
      if (field < 0 || field >= self.attr_fields.attr_length || style < SHORT || style > LONG)
        raise IllegalArgumentException.new
      end
      if ((locale).nil?)
        raise NullPointerException.new
      end
      rb = LocaleData.get_date_format_data(locale)
      eras = rb.get_string_array(get_key(style))
      return eras[get(field)]
    end
    
    typesig { [::Java::Int, ::Java::Int, Locale] }
    def get_display_names(field, style, locale)
      if (!(field).equal?(ERA))
        return super(field, style, locale)
      end
      # Handle Thai BuddhistCalendar specific era names
      if (field < 0 || field >= self.attr_fields.attr_length || style < ALL_STYLES || style > LONG)
        raise IllegalArgumentException.new
      end
      if ((locale).nil?)
        raise NullPointerException.new
      end
      # ALL_STYLES
      if ((style).equal?(ALL_STYLES))
        short_names = get_display_names_impl(field, SHORT, locale)
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
      eras = rb.get_string_array(get_key(style))
      map = HashMap.new(4)
      i = 0
      while i < eras.attr_length
        map.put(eras[i], i)
        i += 1
      end
      return map
    end
    
    typesig { [::Java::Int] }
    def get_key(style)
      key = StringBuilder.new
      key.append(BuddhistCalendar.get_name)
      if ((style).equal?(SHORT))
        key.append(".short")
      end
      key.append(".Eras")
      return key.to_s
    end
    
    typesig { [::Java::Int] }
    # Returns the maximum value that this field could have, given the
    # current date.  For example, with the date "Feb 3, 2540" and the
    # <code>DAY_OF_MONTH</code> field, the actual maximum is 28; for
    # "Feb 3, 2539" it is 29.
    # 
    # @param field the field to determine the maximum of
    # @return the maximum of the given field for the current date of this Calendar
    def get_actual_maximum(field)
      saved_year_offset = @year_offset
      @year_offset = 0
      begin
        return super(field)
      ensure
        @year_offset = saved_year_offset
      end
    end
    
    typesig { [] }
    def to_s
      # The super class produces a String with the Gregorian year
      # value (or '?')
      s = super
      # If the YEAR field is UNSET, then return the Gregorian string.
      if (!is_set(YEAR))
        return s
      end
      year_field = "YEAR="
      p = s.index_of(year_field)
      # If the string doesn't include the year value for some
      # reason, then return the Gregorian string.
      if ((p).equal?(-1))
        return s
      end
      p += year_field.length
      sb = StringBuilder.new(s.substring(0, p))
      # Skip the year number
      while (Character.is_digit(s.char_at(((p += 1) - 1))))
      end
      year = internal_get(YEAR) + BuddhistOffset
      sb.append(year).append(s.substring(p - 1))
      return sb.to_s
    end
    
    attr_accessor :year_offset
    alias_method :attr_year_offset, :year_offset
    undef_method :year_offset
    alias_method :attr_year_offset=, :year_offset=
    undef_method :year_offset=
    
    private
    alias_method :initialize__buddhist_calendar, :initialize
  end
  
end
