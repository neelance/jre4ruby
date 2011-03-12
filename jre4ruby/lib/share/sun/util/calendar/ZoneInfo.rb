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
  module ZoneInfoImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util::Calendar
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaDate
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :SimpleTimeZone
      include_const ::Java::Util, :TimeZone
    }
  end
  
  # <code>ZoneInfo</code> is an implementation subclass of {@link
  # java.util.TimeZone TimeZone} that represents GMT offsets and
  # daylight saving time transitions of a time zone.
  # <p>
  # The daylight saving time transitions are described in the {@link
  # #transitions transitions} table consisting of a chronological
  # sequence of transitions of GMT offset and/or daylight saving time
  # changes. Since all transitions are represented in UTC, in theory,
  # <code>ZoneInfo</code> can be used with any calendar systems except
  # for the {@link #getOffset(int,int,int,int,int,int) getOffset}
  # method that takes Gregorian calendar date fields.
  # <p>
  # This table covers transitions from 1900 until 2037 (as of version
  # 1.4), Before 1900, it assumes that there was no daylight saving
  # time and the <code>getOffset</code> methods always return the
  # {@link #getRawOffset} value. No Local Mean Time is supported. If a
  # specified date is beyond the transition table and this time zone is
  # supposed to observe daylight saving time in 2037, it delegates
  # operations to a {@link java.util.SimpleTimeZone SimpleTimeZone}
  # object created using the daylight saving time schedule as of 2037.
  # <p>
  # The date items, transitions, GMT offset(s), etc. are read from a database
  # file. See {@link ZoneInfoFile} for details.
  # @see java.util.SimpleTimeZone
  # @since 1.4
  class ZoneInfo < ZoneInfoImports.const_get :TimeZone
    include_class_members ZoneInfoImports
    
    class_module.module_eval {
      const_set_lazy(:UTC_TIME) { 0 }
      const_attr_reader  :UTC_TIME
      
      const_set_lazy(:STANDARD_TIME) { 1 }
      const_attr_reader  :STANDARD_TIME
      
      const_set_lazy(:WALL_TIME) { 2 }
      const_attr_reader  :WALL_TIME
      
      const_set_lazy(:OFFSET_MASK) { 0xf }
      const_attr_reader  :OFFSET_MASK
      
      const_set_lazy(:DST_MASK) { 0xf0 }
      const_attr_reader  :DST_MASK
      
      const_set_lazy(:DST_NSHIFT) { 4 }
      const_attr_reader  :DST_NSHIFT
      
      # this bit field is reserved for abbreviation support
      const_set_lazy(:ABBR_MASK) { 0xf00 }
      const_attr_reader  :ABBR_MASK
      
      const_set_lazy(:TRANSITION_NSHIFT) { 12 }
      const_attr_reader  :TRANSITION_NSHIFT
      
      const_set_lazy(:Gcal) { CalendarSystem.get_gregorian_calendar }
      const_attr_reader  :Gcal
    }
    
    # The raw GMT offset in milliseconds between this zone and GMT.
    # Negative offsets are to the west of Greenwich.  To obtain local
    # <em>standard</em> time, add the offset to GMT time.
    # @serial
    attr_accessor :raw_offset
    alias_method :attr_raw_offset, :raw_offset
    undef_method :raw_offset
    alias_method :attr_raw_offset=, :raw_offset=
    undef_method :raw_offset=
    
    # Difference in milliseconds from the original GMT offset in case
    # the raw offset value has been modified by calling {@link
    # #setRawOffset}. The initial value is 0.
    # @serial
    attr_accessor :raw_offset_diff
    alias_method :attr_raw_offset_diff, :raw_offset_diff
    undef_method :raw_offset_diff
    alias_method :attr_raw_offset_diff=, :raw_offset_diff=
    undef_method :raw_offset_diff=
    
    # A CRC32 value of all pairs of transition time (in milliseconds
    # in <code>long</code>) in local time and its GMT offset (in
    # seconds in <code>int</code>) in the chronological order. Byte
    # values of each <code>long</code> and <code>int</code> are taken
    # in the big endian order (i.e., MSB to LSB).
    # @serial
    attr_accessor :checksum
    alias_method :attr_checksum, :checksum
    undef_method :checksum
    alias_method :attr_checksum=, :checksum=
    undef_method :checksum=
    
    # The amount of time in milliseconds saved during daylight saving
    # time. If <code>useDaylight</code> is false, this value is 0.
    # @serial
    attr_accessor :dst_savings
    alias_method :attr_dst_savings, :dst_savings
    undef_method :dst_savings
    alias_method :attr_dst_savings=, :dst_savings=
    undef_method :dst_savings=
    
    # This array describes transitions of GMT offsets of this time
    # zone, including both raw offset changes and daylight saving
    # time changes.
    # A long integer consists of four bit fields.
    # <ul>
    # <li>The most significant 52-bit field represents transition
    # time in milliseconds from Gregorian January 1 1970, 00:00:00
    # GMT.</li>
    # <li>The next 4-bit field is reserved and must be 0.</li>
    # <li>The next 4-bit field is an index value to {@link #offsets
    # offsets[]} for the amount of daylight saving at the
    # transition. If this value is zero, it means that no daylight
    # saving, not the index value zero.</li>
    # <li>The least significant 4-bit field is an index value to
    # {@link #offsets offsets[]} for <em>total</em> GMT offset at the
    # transition.</li>
    # </ul>
    # If this time zone doesn't observe daylight saving time and has
    # never changed any GMT offsets in the past, this value is null.
    # @serial
    attr_accessor :transitions
    alias_method :attr_transitions, :transitions
    undef_method :transitions
    alias_method :attr_transitions=, :transitions=
    undef_method :transitions=
    
    # This array holds all unique offset values in
    # milliseconds. Index values to this array are stored in the
    # transitions array elements.
    # @serial
    attr_accessor :offsets
    alias_method :attr_offsets, :offsets
    undef_method :offsets
    alias_method :attr_offsets=, :offsets=
    undef_method :offsets=
    
    # SimpleTimeZone parameter values. It has to have either 8 for
    # {@link java.util.SimpleTimeZone#SimpleTimeZone(int, String,
    # int, int , int , int , int , int , int , int , int) the
    # 11-argument SimpleTimeZone constructor} or 10 for {@link
    # java.util.SimpleTimeZone#SimpleTimeZone(int, String, int, int,
    # int , int , int , int , int , int , int, int, int) the
    # 13-argument SimpleTimeZone constructor} parameters.
    # @serial
    attr_accessor :simple_time_zone_params
    alias_method :attr_simple_time_zone_params, :simple_time_zone_params
    undef_method :simple_time_zone_params
    alias_method :attr_simple_time_zone_params=, :simple_time_zone_params=
    undef_method :simple_time_zone_params=
    
    # True if the raw GMT offset value would change after the time
    # zone data has been generated; false, otherwise. The default
    # value is false.
    # @serial
    attr_accessor :will_gmtoffset_change
    alias_method :attr_will_gmtoffset_change, :will_gmtoffset_change
    undef_method :will_gmtoffset_change
    alias_method :attr_will_gmtoffset_change=, :will_gmtoffset_change=
    undef_method :will_gmtoffset_change=
    
    # True if the object has been modified after its instantiation.
    attr_accessor :dirty
    alias_method :attr_dirty, :dirty
    undef_method :dirty
    alias_method :attr_dirty=, :dirty=
    undef_method :dirty=
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 2653134537216586139 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # A constructor.
    def initialize
      @raw_offset = 0
      @raw_offset_diff = 0
      @checksum = 0
      @dst_savings = 0
      @transitions = nil
      @offsets = nil
      @simple_time_zone_params = nil
      @will_gmtoffset_change = false
      @dirty = false
      @last_rule = nil
      super()
      @raw_offset_diff = 0
      @will_gmtoffset_change = false
      @dirty = false
    end
    
    typesig { [String, ::Java::Int] }
    # A Constructor for CustomID.
    def initialize(id, raw_offset)
      initialize__zone_info(id, raw_offset, 0, 0, nil, nil, nil, false)
    end
    
    typesig { [String, ::Java::Int, ::Java::Int, ::Java::Int, Array.typed(::Java::Long), Array.typed(::Java::Int), Array.typed(::Java::Int), ::Java::Boolean] }
    # Constructs a ZoneInfo instance.
    # 
    # @param ID time zone name
    # @param rawOffset GMT offset in milliseconds
    # @param dstSavings daylight saving value in milliseconds or 0
    # (zero) if this time zone doesn't observe Daylight Saving Time.
    # @param checksum CRC32 value with all transitions table entry
    # values
    # @param transitions transition table
    # @param offsets offset value table
    # @param simpleTimeZoneParams parameter values for constructing
    # SimpleTimeZone
    # @param willGMTOffsetChange the value of willGMTOffsetChange
    def initialize(id, raw_offset, dst_savings, checksum, transitions, offsets, simple_time_zone_params, will_gmtoffset_change)
      @raw_offset = 0
      @raw_offset_diff = 0
      @checksum = 0
      @dst_savings = 0
      @transitions = nil
      @offsets = nil
      @simple_time_zone_params = nil
      @will_gmtoffset_change = false
      @dirty = false
      @last_rule = nil
      super()
      @raw_offset_diff = 0
      @will_gmtoffset_change = false
      @dirty = false
      set_id(id)
      @raw_offset = raw_offset
      @dst_savings = dst_savings
      @checksum = checksum
      @transitions = transitions
      @offsets = offsets
      @simple_time_zone_params = simple_time_zone_params
      @will_gmtoffset_change = will_gmtoffset_change
    end
    
    typesig { [::Java::Long] }
    # Returns the difference in milliseconds between local time and UTC
    # of given time, taking into account both the raw offset and the
    # effect of daylight savings.
    # 
    # @param date the milliseconds in UTC
    # @return the milliseconds to add to UTC to get local wall time
    def get_offset(date)
      return get_offsets(date, nil, UTC_TIME)
    end
    
    typesig { [::Java::Long, Array.typed(::Java::Int)] }
    def get_offsets(utc, offsets)
      return get_offsets(utc, offsets, UTC_TIME)
    end
    
    typesig { [::Java::Long, Array.typed(::Java::Int)] }
    def get_offsets_by_standard(standard, offsets)
      return get_offsets(standard, offsets, STANDARD_TIME)
    end
    
    typesig { [::Java::Long, Array.typed(::Java::Int)] }
    def get_offsets_by_wall(wall, offsets)
      return get_offsets(wall, offsets, WALL_TIME)
    end
    
    typesig { [::Java::Long, Array.typed(::Java::Int), ::Java::Int] }
    def get_offsets(date, offsets, type)
      # if dst is never observed, there is no transition.
      if ((@transitions).nil?)
        offset = get_last_raw_offset
        if (!(offsets).nil?)
          offsets[0] = offset
          offsets[1] = 0
        end
        return offset
      end
      date -= @raw_offset_diff
      index = get_transition_index(date, type)
      # prior to the transition table, returns the raw offset.
      # should support LMT.
      if (index < 0)
        offset = get_last_raw_offset
        if (!(offsets).nil?)
          offsets[0] = offset
          offsets[1] = 0
        end
        return offset
      end
      if (index < @transitions.attr_length)
        val = @transitions[index]
        offset = @offsets[((val & OFFSET_MASK)).to_int] + @raw_offset_diff
        if (!(offsets).nil?)
          dst = (((val >> DST_NSHIFT) & 0xf)).to_int
          save = ((dst).equal?(0)) ? 0 : @offsets[dst]
          offsets[0] = offset - save
          offsets[1] = save
        end
        return offset
      end
      # beyond the transitions, delegate to SimpleTimeZone if there
      # is a rule; otherwise, return rawOffset.
      tz = get_last_rule
      if (!(tz).nil?)
        rawoffset = tz.get_raw_offset
        msec = date
        if (!(type).equal?(UTC_TIME))
          msec -= @raw_offset
        end
        dstoffset = tz.in_daylight_time(JavaDate.new(msec)) ? tz.get_dstsavings : 0
        if (!(offsets).nil?)
          offsets[0] = rawoffset
          offsets[1] = dstoffset
        end
        return rawoffset + dstoffset
      end
      offset = get_last_raw_offset
      if (!(offsets).nil?)
        offsets[0] = offset
        offsets[1] = 0
      end
      return offset
    end
    
    typesig { [::Java::Long, ::Java::Int] }
    def get_transition_index(date, type)
      low = 0
      high = @transitions.attr_length - 1
      while (low <= high)
        mid = (low + high) / 2
        val = @transitions[mid]
        mid_val = val >> TRANSITION_NSHIFT # sign extended
        if (!(type).equal?(UTC_TIME))
          mid_val += @offsets[((val & OFFSET_MASK)).to_int] # wall time
        end
        if ((type).equal?(STANDARD_TIME))
          dst_index = (((val >> DST_NSHIFT) & 0xf)).to_int
          if (!(dst_index).equal?(0))
            mid_val -= @offsets[dst_index] # make it standard time
          end
        end
        if (mid_val < date)
          low = mid + 1
        else
          if (mid_val > date)
            high = mid - 1
          else
            return mid
          end
        end
      end
      # if beyond the transitions, returns that index.
      if (low >= @transitions.attr_length)
        return low
      end
      return low - 1
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Returns the difference in milliseconds between local time and
    # UTC, taking into account both the raw offset and the effect of
    # daylight savings, for the specified date and time.  This method
    # assumes that the start and end month are distinct.  This method
    # assumes a Gregorian calendar for calculations.
    # <p>
    # <em>Note: In general, clients should use
    # {@link Calendar#ZONE_OFFSET Calendar.get(ZONE_OFFSET)} +
    # {@link Calendar#DST_OFFSET Calendar.get(DST_OFFSET)}
    # instead of calling this method.</em>
    # 
    # @param era       The era of the given date. The value must be either
    #                  GregorianCalendar.AD or GregorianCalendar.BC.
    # @param year      The year in the given date.
    # @param month     The month in the given date. Month is 0-based. e.g.,
    #                  0 for January.
    # @param day       The day-in-month of the given date.
    # @param dayOfWeek The day-of-week of the given date.
    # @param millis    The milliseconds in day in <em>standard</em> local time.
    # @return The milliseconds to add to UTC to get local time.
    def get_offset(era, year, month, day, day_of_week, milliseconds)
      if (milliseconds < 0 || milliseconds >= AbstractCalendar::DAY_IN_MILLIS)
        raise IllegalArgumentException.new
      end
      if ((era).equal?(Java::Util::GregorianCalendar::BC))
        # BC
        year = 1 - year
      else
        if (!(era).equal?(Java::Util::GregorianCalendar::AD))
          raise IllegalArgumentException.new
        end
      end
      date = Gcal.new_calendar_date(nil)
      date.set_date(year, month + 1, day)
      if ((Gcal.validate(date)).equal?(false))
        raise IllegalArgumentException.new
      end
      # bug-for-bug compatible argument checking
      if (day_of_week < Java::Util::GregorianCalendar::SUNDAY || day_of_week > Java::Util::GregorianCalendar::SATURDAY)
        raise IllegalArgumentException.new
      end
      if ((@transitions).nil?)
        return get_last_raw_offset
      end
      date_in_millis = Gcal.get_time(date) + milliseconds
      date_in_millis -= @raw_offset # make it UTC
      return get_offsets(date_in_millis, nil, UTC_TIME)
    end
    
    typesig { [::Java::Int] }
    # Sets the base time zone offset from GMT. This operation
    # modifies all the transitions of this ZoneInfo object, including
    # historical ones, if applicable.
    # 
    # @param offsetMillis the base time zone offset to GMT.
    # @see getRawOffset
    def set_raw_offset(offset_millis)
      synchronized(self) do
        if ((offset_millis).equal?(@raw_offset + @raw_offset_diff))
          return
        end
        @raw_offset_diff = offset_millis - @raw_offset
        if (!(@last_rule).nil?)
          @last_rule.set_raw_offset(offset_millis)
        end
        @dirty = true
      end
    end
    
    typesig { [] }
    # Returns the GMT offset of the current date. This GMT offset
    # value is not modified during Daylight Saving Time.
    # 
    # @return the GMT offset value in milliseconds to add to UTC time
    # to get local standard time
    def get_raw_offset
      if (!@will_gmtoffset_change)
        return @raw_offset + @raw_offset_diff
      end
      offsets = Array.typed(::Java::Int).new(2) { 0 }
      get_offsets(System.current_time_millis, offsets, UTC_TIME)
      return offsets[0]
    end
    
    typesig { [] }
    def is_dirty
      return @dirty
    end
    
    typesig { [] }
    def get_last_raw_offset
      return @raw_offset + @raw_offset_diff
    end
    
    typesig { [] }
    # Queries if this time zone uses Daylight Saving Time in the last known rule.
    def use_daylight_time
      return (!(@simple_time_zone_params).nil?)
    end
    
    typesig { [JavaDate] }
    # Queries if the specified date is in Daylight Saving Time.
    def in_daylight_time(date)
      if ((date).nil?)
        raise NullPointerException.new
      end
      if ((@transitions).nil?)
        return false
      end
      utc = date.get_time - @raw_offset_diff
      index = get_transition_index(utc, UTC_TIME)
      # before transitions in the transition table
      if (index < 0)
        return false
      end
      # the time is in the table range.
      if (index < @transitions.attr_length)
        return !((@transitions[index] & DST_MASK)).equal?(0)
      end
      # beyond the transition table
      tz = get_last_rule
      if (!(tz).nil?)
        return tz.in_daylight_time(date)
      end
      return false
    end
    
    typesig { [] }
    # Returns the amount of time in milliseconds that the clock is advanced
    # during daylight saving time is in effect in its last daylight saving time rule.
    # 
    # @return the number of milliseconds the time is advanced with respect to
    # standard time when daylight saving time is in effect.
    def get_dstsavings
      return @dst_savings
    end
    
    typesig { [] }
    #    /**
    #     * @return the last year in the transition table or -1 if this
    #     * time zone doesn't observe any daylight saving time.
    #     */
    #    public int getMaxTransitionYear() {
    #      if (transitions == null) {
    #          return -1;
    #      }
    #      long val = transitions[transitions.length - 1];
    #      int offset = this.offsets[(int)(val & OFFSET_MASK)] + rawOffsetDiff;
    #      val = (val >> TRANSITION_NSHIFT) + offset;
    #      CalendarDate lastDate = Gregorian.getCalendarDate(val);
    #      return lastDate.getYear();
    #    }
    # Returns a string representation of this time zone.
    # @return the string
    def to_s
      return RJava.cast_to_string(get_class.get_name) + "[id=\"" + RJava.cast_to_string(get_id) + "\"" + ",offset=" + RJava.cast_to_string(get_last_raw_offset) + ",dstSavings=" + RJava.cast_to_string(@dst_savings) + ",useDaylight=" + RJava.cast_to_string(use_daylight_time) + ",transitions=" + RJava.cast_to_string(((!(@transitions).nil?) ? @transitions.attr_length : 0)) + ",lastRule=" + RJava.cast_to_string(((@last_rule).nil? ? get_last_rule_instance : @last_rule)) + "]"
    end
    
    class_module.module_eval {
      typesig { [] }
      # Gets all available IDs supported in the Java run-time.
      # 
      # @return an array of time zone IDs.
      def get_available_ids
        id_list = ZoneInfoFile.get_zone_ids
        excluded = ZoneInfoFile.get_excluded_zones
        if (!(excluded).nil?)
          # List all zones from the idList and excluded lists
          list = ArrayList.new(id_list.size + excluded.size)
          list.add_all(id_list)
          list.add_all(excluded)
          id_list = list
        end
        ids = Array.typed(String).new(id_list.size) { nil }
        return id_list.to_array(ids)
      end
      
      typesig { [::Java::Int] }
      # Gets all available IDs that have the same value as the
      # specified raw GMT offset.
      # 
      # @param rawOffset the GMT offset in milliseconds. This
      # value should not include any daylight saving time.
      # 
      # @return an array of time zone IDs.
      def get_available_ids(raw_offset)
        result = nil
        matched = ArrayList.new
        ids = ZoneInfoFile.get_zone_ids
        raw_offsets = ZoneInfoFile.get_raw_offsets
        catch(:break_loop) do
          index = 0
          while index < raw_offsets.attr_length
            if ((raw_offsets[index]).equal?(raw_offset))
              indices = ZoneInfoFile.get_raw_offset_indices
              i = 0
              while i < indices.attr_length
                if ((indices[i]).equal?(index))
                  matched.add(ids.get(((i += 1) - 1)))
                  while (i < indices.attr_length && (indices[i]).equal?(index))
                    matched.add(ids.get(((i += 1) - 1)))
                  end
                  throw :break_loop, :thrown
                end
                i += 1
              end
            end
            index += 1
          end
        end
        # We need to add any zones from the excluded zone list that
        # currently have the same GMT offset as the specified
        # rawOffset. The zones returned by this method may not be
        # correct as of return to the caller if any GMT offset
        # transition is happening during this GMT offset checking...
        excluded = ZoneInfoFile.get_excluded_zones
        if (!(excluded).nil?)
          excluded.each do |id|
            zi = get_time_zone(id)
            if (!(zi).nil? && (zi.get_raw_offset).equal?(raw_offset))
              matched.add(id)
            end
          end
        end
        result = Array.typed(String).new(matched.size) { nil }
        matched.to_array(result)
        return result
      end
      
      typesig { [String] }
      # Gets the ZoneInfo for the given ID.
      # 
      # @param ID the ID for a ZoneInfo. See TimeZone for detail.
      # 
      # @return the specified ZoneInfo object, or null if there is no
      # time zone of the ID.
      def get_time_zone(id)
        zi = nil
        zi = ZoneInfoFile.get_zone_info(id)
        if ((zi).nil?)
          # if we can't create an object for the ID, try aliases.
          begin
            map = get_alias_table
            alias_ = id
            while (!((alias_ = RJava.cast_to_string(map.get(alias_)))).nil?)
              zi = ZoneInfoFile.get_zone_info(alias_)
              if (!(zi).nil?)
                zi.set_id(id)
                zi = ZoneInfoFile.add_to_cache(id, zi)
                zi = zi.clone
                break
              end
            end
          rescue JavaException => e
            # ignore exceptions
          end
        end
        return zi
      end
    }
    
    attr_accessor :last_rule
    alias_method :attr_last_rule, :last_rule
    undef_method :last_rule
    alias_method :attr_last_rule=, :last_rule=
    undef_method :last_rule=
    
    typesig { [] }
    # Returns a SimpleTimeZone object representing the last GMT
    # offset and DST schedule or null if this time zone doesn't
    # observe DST.
    def get_last_rule
      synchronized(self) do
        if ((@last_rule).nil?)
          @last_rule = get_last_rule_instance
        end
        return @last_rule
      end
    end
    
    typesig { [] }
    # Returns a SimpleTimeZone object that represents the last
    # known daylight saving time rules.
    # 
    # @return a SimpleTimeZone object or null if this time zone
    # doesn't observe DST.
    def get_last_rule_instance
      if ((@simple_time_zone_params).nil?)
        return nil
      end
      if ((@simple_time_zone_params.attr_length).equal?(10))
        return SimpleTimeZone.new(get_last_raw_offset, get_id, @simple_time_zone_params[0], @simple_time_zone_params[1], @simple_time_zone_params[2], @simple_time_zone_params[3], @simple_time_zone_params[4], @simple_time_zone_params[5], @simple_time_zone_params[6], @simple_time_zone_params[7], @simple_time_zone_params[8], @simple_time_zone_params[9], @dst_savings)
      end
      return SimpleTimeZone.new(get_last_raw_offset, get_id, @simple_time_zone_params[0], @simple_time_zone_params[1], @simple_time_zone_params[2], @simple_time_zone_params[3], @simple_time_zone_params[4], @simple_time_zone_params[5], @simple_time_zone_params[6], @simple_time_zone_params[7], @dst_savings)
    end
    
    typesig { [] }
    # Returns a copy of this <code>ZoneInfo</code>.
    def clone
      zi = super
      zi.attr_last_rule = nil
      return zi
    end
    
    typesig { [] }
    # Returns a hash code value calculated from the GMT offset and
    # transitions.
    # @return a hash code of this time zone
    def hash_code
      return get_last_raw_offset ^ @checksum
    end
    
    typesig { [Object] }
    # Compares the equity of two ZoneInfo objects.
    # 
    # @param obj the object to be compared with
    # @return true if given object is same as this ZoneInfo object,
    # false otherwise.
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(ZoneInfo)))
        return false
      end
      that = obj
      return ((get_id == that.get_id) && ((get_last_raw_offset).equal?(that.get_last_raw_offset)) && ((@checksum).equal?(that.attr_checksum)))
    end
    
    typesig { [TimeZone] }
    # Returns true if this zone has the same raw GMT offset value and
    # transition table as another zone info. If the specified
    # TimeZone object is not a ZoneInfo instance, this method returns
    # true if the specified TimeZone object has the same raw GMT
    # offset value with no daylight saving time.
    # 
    # @param other the ZoneInfo object to be compared with
    # @return true if the given <code>TimeZone</code> has the same
    # GMT offset and transition information; false, otherwise.
    def has_same_rules(other)
      if ((self).equal?(other))
        return true
      end
      if ((other).nil?)
        return false
      end
      if (!(other.is_a?(ZoneInfo)))
        if (!(get_raw_offset).equal?(other.get_raw_offset))
          return false
        end
        # if both have the same raw offset and neither observes
        # DST, they have the same rule.
        if (((@transitions).nil?) && ((use_daylight_time).equal?(false)) && ((other.use_daylight_time).equal?(false)))
          return true
        end
        return false
      end
      if (!(get_last_raw_offset).equal?((other).get_last_raw_offset))
        return false
      end
      return ((@checksum).equal?((other).attr_checksum))
    end
    
    class_module.module_eval {
      
      def alias_table
        defined?(@@alias_table) ? @@alias_table : @@alias_table= nil
      end
      alias_method :attr_alias_table, :alias_table
      
      def alias_table=(value)
        @@alias_table = value
      end
      alias_method :attr_alias_table=, :alias_table=
      
      typesig { [] }
      # Returns a Map from alias time zone IDs to their standard
      # time zone IDs.
      # 
      # @return the Map that holds the mappings from alias time zone IDs
      #    to their standard time zone IDs, or null if
      #    <code>ZoneInfoMappings</code> file is not available.
      def get_alias_table
        synchronized(self) do
          aliases = nil
          cache = self.attr_alias_table
          if (!(cache).nil?)
            aliases = cache.get
            if (!(aliases).nil?)
              return aliases
            end
          end
          aliases = ZoneInfoFile.get_zone_aliases
          if (!(aliases).nil?)
            self.attr_alias_table = SoftReference.new(aliases)
          end
          return aliases
        end
      end
    }
    
    typesig { [ObjectInputStream] }
    def read_object(stream)
      stream.default_read_object
      # We don't know how this object from 1.4.x or earlier has
      # been mutated. So it should always be marked as `dirty'.
      @dirty = true
    end
    
    private
    alias_method :initialize__zone_info, :initialize
  end
  
end
