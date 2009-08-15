require "rjava"

# Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module EraImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util::Calendar
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :TimeZone
    }
  end
  
  # The class <code>Era</code> represents a calendar era that defines a
  # period of time in which the same year numbering is used. For
  # example, Gregorian year 2004 is <I>Heisei</I> 16 in the Japanese
  # calendar system. An era starts at any point of time (Gregorian) that is
  # represented by <code>CalendarDate</code>.
  # 
  # <p><code>Era</code>s that are applicable to a particular calendar
  # system can be obtained by calling {@link CalendarSystem#getEras}
  # one of which can be used to specify a date in
  # <code>CalendarDate</code>.
  # 
  # <p>The following era names are defined in this release.
  # <!-- TODO: use HTML table -->
  # <pre><tt>
  # Calendar system         Era name         Since (in Gregorian)
  # -----------------------------------------------------------------------
  # Japanese calendar       Meiji            1868-01-01 midnight local time
  # Taisho           1912-07-30 midnight local time
  # Showa            1926-12-26 midnight local time
  # Heisei           1989-01-08 midnight local time
  # Julian calendar         BeforeCommonEra  -292275055-05-16T16:47:04.192Z
  # CommonEra        0000-12-30 midnight local time
  # Taiwanese calendar      MinGuo           1911-01-01 midnight local time
  # Thai Buddhist calendar  BuddhistEra      -543-01-01 midnight local time
  # -----------------------------------------------------------------------
  # </tt></pre>
  # 
  # @author Masayoshi Okutsu
  # @since 1.5
  class Era 
    include_class_members EraImports
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :abbr
    alias_method :attr_abbr, :abbr
    undef_method :abbr
    alias_method :attr_abbr=, :abbr=
    undef_method :abbr=
    
    attr_accessor :since
    alias_method :attr_since, :since
    undef_method :since
    alias_method :attr_since=, :since=
    undef_method :since=
    
    attr_accessor :since_date
    alias_method :attr_since_date, :since_date
    undef_method :since_date
    alias_method :attr_since_date=, :since_date=
    undef_method :since_date=
    
    attr_accessor :local_time
    alias_method :attr_local_time, :local_time
    undef_method :local_time
    alias_method :attr_local_time=, :local_time=
    undef_method :local_time=
    
    typesig { [String, String, ::Java::Long, ::Java::Boolean] }
    # Constructs an <code>Era</code> instance.
    # 
    # @param name the era name (e.g., "BeforeCommonEra" for the Julian calendar system)
    # @param abbr the abbreviation of the era name (e.g., "B.C.E." for "BeforeCommonEra")
    # @param since the time (millisecond offset from January 1, 1970
    # (Gregorian) UTC or local time) when the era starts, inclusive.
    # @param localTime <code>true</code> if <code>since</code>
    # specifies a local time; <code>false</code> if
    # <code>since</code> specifies UTC
    def initialize(name, abbr, since, local_time)
      @name = nil
      @abbr = nil
      @since = 0
      @since_date = nil
      @local_time = false
      @hash = 0
      @name = name
      @abbr = abbr
      @since = since
      @local_time = local_time
      gcal = CalendarSystem.get_gregorian_calendar
      d = gcal.new_calendar_date(nil)
      gcal.get_calendar_date(since, d)
      @since_date = ImmutableGregorianDate.new(d)
    end
    
    typesig { [] }
    def get_name
      return @name
    end
    
    typesig { [Locale] }
    def get_display_name(locale)
      return @name
    end
    
    typesig { [] }
    def get_abbreviation
      return @abbr
    end
    
    typesig { [Locale] }
    def get_diaplay_abbreviation(locale)
      return @abbr
    end
    
    typesig { [TimeZone] }
    def get_since(zone)
      if ((zone).nil? || !@local_time)
        return @since
      end
      offset = zone.get_offset(@since)
      return @since - offset
    end
    
    typesig { [] }
    def get_since_date
      return @since_date
    end
    
    typesig { [] }
    def is_local_time
      return @local_time
    end
    
    typesig { [Object] }
    def ==(o)
      if (!(o.is_a?(Era)))
        return false
      end
      that = o
      return (@name == that.attr_name) && (@abbr == that.attr_abbr) && (@since).equal?(that.attr_since) && (@local_time).equal?(that.attr_local_time)
    end
    
    attr_accessor :hash
    alias_method :attr_hash, :hash
    undef_method :hash
    alias_method :attr_hash=, :hash=
    undef_method :hash=
    
    typesig { [] }
    def hash_code
      if ((@hash).equal?(0))
        @hash = @name.hash_code ^ @abbr.hash_code ^ RJava.cast_to_int(@since) ^ RJava.cast_to_int((@since >> 32)) ^ (@local_time ? 1 : 0)
      end
      return @hash
    end
    
    typesig { [] }
    def to_s
      sb = StringBuilder.new
      sb.append(Character.new(?[.ord))
      sb.append(get_name).append(" (")
      sb.append(get_abbreviation).append(Character.new(?).ord))
      sb.append(" since ").append(get_since_date)
      if (@local_time)
        sb.set_length(sb.length - 1) # remove 'Z'
        sb.append(" local time")
      end
      sb.append(Character.new(?].ord))
      return sb.to_s
    end
    
    private
    alias_method :initialize__era, :initialize
  end
  
end
