require "rjava"

# Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module TimeZoneImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Io, :Serializable
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Util::Concurrent, :ConcurrentHashMap
      include_const ::Sun::Security::Action, :GetPropertyAction
      include_const ::Sun::Util, :TimeZoneNameUtility
      include_const ::Sun::Util::Calendar, :ZoneInfo
      include_const ::Sun::Util::Calendar, :ZoneInfoFile
    }
  end
  
  # <code>TimeZone</code> represents a time zone offset, and also figures out daylight
  # savings.
  # 
  # <p>
  # Typically, you get a <code>TimeZone</code> using <code>getDefault</code>
  # which creates a <code>TimeZone</code> based on the time zone where the program
  # is running. For example, for a program running in Japan, <code>getDefault</code>
  # creates a <code>TimeZone</code> object based on Japanese Standard Time.
  # 
  # <p>
  # You can also get a <code>TimeZone</code> using <code>getTimeZone</code>
  # along with a time zone ID. For instance, the time zone ID for the
  # U.S. Pacific Time zone is "America/Los_Angeles". So, you can get a
  # U.S. Pacific Time <code>TimeZone</code> object with:
  # <blockquote><pre>
  # TimeZone tz = TimeZone.getTimeZone("America/Los_Angeles");
  # </pre></blockquote>
  # You can use the <code>getAvailableIDs</code> method to iterate through
  # all the supported time zone IDs. You can then choose a
  # supported ID to get a <code>TimeZone</code>.
  # If the time zone you want is not represented by one of the
  # supported IDs, then a custom time zone ID can be specified to
  # produce a TimeZone. The syntax of a custom time zone ID is:
  # 
  # <blockquote><pre>
  # <a name="CustomID"><i>CustomID:</i></a>
  # <code>GMT</code> <i>Sign</i> <i>Hours</i> <code>:</code> <i>Minutes</i>
  # <code>GMT</code> <i>Sign</i> <i>Hours</i> <i>Minutes</i>
  # <code>GMT</code> <i>Sign</i> <i>Hours</i>
  # <i>Sign:</i> one of
  # <code>+ -</code>
  # <i>Hours:</i>
  # <i>Digit</i>
  # <i>Digit</i> <i>Digit</i>
  # <i>Minutes:</i>
  # <i>Digit</i> <i>Digit</i>
  # <i>Digit:</i> one of
  # <code>0 1 2 3 4 5 6 7 8 9</code>
  # </pre></blockquote>
  # 
  # <i>Hours</i> must be between 0 to 23 and <i>Minutes</i> must be
  # between 00 to 59.  For example, "GMT+10" and "GMT+0010" mean ten
  # hours and ten minutes ahead of GMT, respectively.
  # <p>
  # The format is locale independent and digits must be taken from the
  # Basic Latin block of the Unicode standard. No daylight saving time
  # transition schedule can be specified with a custom time zone ID. If
  # the specified string doesn't match the syntax, <code>"GMT"</code>
  # is used.
  # <p>
  # When creating a <code>TimeZone</code>, the specified custom time
  # zone ID is normalized in the following syntax:
  # <blockquote><pre>
  # <a name="NormalizedCustomID"><i>NormalizedCustomID:</i></a>
  # <code>GMT</code> <i>Sign</i> <i>TwoDigitHours</i> <code>:</code> <i>Minutes</i>
  # <i>Sign:</i> one of
  # <code>+ -</code>
  # <i>TwoDigitHours:</i>
  # <i>Digit</i> <i>Digit</i>
  # <i>Minutes:</i>
  # <i>Digit</i> <i>Digit</i>
  # <i>Digit:</i> one of
  # <code>0 1 2 3 4 5 6 7 8 9</code>
  # </pre></blockquote>
  # For example, TimeZone.getTimeZone("GMT-8").getID() returns "GMT-08:00".
  # 
  # <h4>Three-letter time zone IDs</h4>
  # 
  # For compatibility with JDK 1.1.x, some other three-letter time zone IDs
  # (such as "PST", "CTT", "AST") are also supported. However, <strong>their
  # use is deprecated</strong> because the same abbreviation is often used
  # for multiple time zones (for example, "CST" could be U.S. "Central Standard
  # Time" and "China Standard Time"), and the Java platform can then only
  # recognize one of them.
  # 
  # 
  # @see          Calendar
  # @see          GregorianCalendar
  # @see          SimpleTimeZone
  # @author       Mark Davis, David Goldsmith, Chen-Lieh Huang, Alan Liu
  # @since        JDK1.1
  class TimeZone 
    include_class_members TimeZoneImports
    include Serializable
    include Cloneable
    
    typesig { [] }
    # Sole constructor.  (For invocation by subclass constructors, typically
    # implicit.)
    def initialize
      @id = nil
    end
    
    class_module.module_eval {
      # A style specifier for <code>getDisplayName()</code> indicating
      # a short name, such as "PST."
      # @see #LONG
      # @since 1.2
      const_set_lazy(:SHORT) { 0 }
      const_attr_reader  :SHORT
      
      # A style specifier for <code>getDisplayName()</code> indicating
      # a long name, such as "Pacific Standard Time."
      # @see #SHORT
      # @since 1.2
      const_set_lazy(:LONG) { 1 }
      const_attr_reader  :LONG
      
      # Constants used internally; unit is milliseconds
      const_set_lazy(:ONE_MINUTE) { 60 * 1000 }
      const_attr_reader  :ONE_MINUTE
      
      const_set_lazy(:ONE_HOUR) { 60 * ONE_MINUTE }
      const_attr_reader  :ONE_HOUR
      
      const_set_lazy(:ONE_DAY) { 24 * ONE_HOUR }
      const_attr_reader  :ONE_DAY
      
      # Cache to hold the SimpleDateFormat objects for a Locale.
      
      def cached_locale_data
        defined?(@@cached_locale_data) ? @@cached_locale_data : @@cached_locale_data= Hashtable.new(3)
      end
      alias_method :attr_cached_locale_data, :cached_locale_data
      
      def cached_locale_data=(value)
        @@cached_locale_data = value
      end
      alias_method :attr_cached_locale_data=, :cached_locale_data=
      
      # Proclaim serialization compatibility with JDK 1.1
      const_set_lazy(:SerialVersionUID) { 3581463369166924961 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Gets the time zone offset, for current date, modified in case of
    # daylight savings. This is the offset to add to UTC to get local time.
    # <p>
    # This method returns a historically correct offset if an
    # underlying <code>TimeZone</code> implementation subclass
    # supports historical Daylight Saving Time schedule and GMT
    # offset changes.
    # 
    # @param era the era of the given date.
    # @param year the year in the given date.
    # @param month the month in the given date.
    # Month is 0-based. e.g., 0 for January.
    # @param day the day-in-month of the given date.
    # @param dayOfWeek the day-of-week of the given date.
    # @param milliseconds the milliseconds in day in <em>standard</em>
    # local time.
    # 
    # @return the offset in milliseconds to add to GMT to get local time.
    # 
    # @see Calendar#ZONE_OFFSET
    # @see Calendar#DST_OFFSET
    def get_offset(era, year, month, day, day_of_week, milliseconds)
      raise NotImplementedError
    end
    
    typesig { [::Java::Long] }
    # Returns the offset of this time zone from UTC at the specified
    # date. If Daylight Saving Time is in effect at the specified
    # date, the offset value is adjusted with the amount of daylight
    # saving.
    # <p>
    # This method returns a historically correct offset value if an
    # underlying TimeZone implementation subclass supports historical
    # Daylight Saving Time schedule and GMT offset changes.
    # 
    # @param date the date represented in milliseconds since January 1, 1970 00:00:00 GMT
    # @return the amount of time in milliseconds to add to UTC to get local time.
    # 
    # @see Calendar#ZONE_OFFSET
    # @see Calendar#DST_OFFSET
    # @since 1.4
    def get_offset(date)
      if (in_daylight_time(JavaDate.new(date)))
        return get_raw_offset + get_dstsavings
      end
      return get_raw_offset
    end
    
    typesig { [::Java::Long, Array.typed(::Java::Int)] }
    # Gets the raw GMT offset and the amount of daylight saving of this
    # time zone at the given time.
    # @param date the milliseconds (since January 1, 1970,
    # 00:00:00.000 GMT) at which the time zone offset and daylight
    # saving amount are found
    # @param offset an array of int where the raw GMT offset
    # (offset[0]) and daylight saving amount (offset[1]) are stored,
    # or null if those values are not needed. The method assumes that
    # the length of the given array is two or larger.
    # @return the total amount of the raw GMT offset and daylight
    # saving at the specified date.
    # 
    # @see Calendar#ZONE_OFFSET
    # @see Calendar#DST_OFFSET
    def get_offsets(date, offsets)
      rawoffset = get_raw_offset
      dstoffset = 0
      if (in_daylight_time(JavaDate.new(date)))
        dstoffset = get_dstsavings
      end
      if (!(offsets).nil?)
        offsets[0] = rawoffset
        offsets[1] = dstoffset
      end
      return rawoffset + dstoffset
    end
    
    typesig { [::Java::Int] }
    # Sets the base time zone offset to GMT.
    # This is the offset to add to UTC to get local time.
    # <p>
    # If an underlying <code>TimeZone</code> implementation subclass
    # supports historical GMT offset changes, the specified GMT
    # offset is set as the latest GMT offset and the difference from
    # the known latest GMT offset value is used to adjust all
    # historical GMT offset values.
    # 
    # @param offsetMillis the given base time zone offset to GMT.
    def set_raw_offset(offset_millis)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the amount of time in milliseconds to add to UTC to get
    # standard time in this time zone. Because this value is not
    # affected by daylight saving time, it is called <I>raw
    # offset</I>.
    # <p>
    # If an underlying <code>TimeZone</code> implementation subclass
    # supports historical GMT offset changes, the method returns the
    # raw offset value of the current date. In Honolulu, for example,
    # its raw offset changed from GMT-10:30 to GMT-10:00 in 1947, and
    # this method always returns -36000000 milliseconds (i.e., -10
    # hours).
    # 
    # @return the amount of raw offset time in milliseconds to add to UTC.
    # @see Calendar#ZONE_OFFSET
    def get_raw_offset
      raise NotImplementedError
    end
    
    typesig { [] }
    # Gets the ID of this time zone.
    # @return the ID of this time zone.
    def get_id
      return @id
    end
    
    typesig { [String] }
    # Sets the time zone ID. This does not change any other data in
    # the time zone object.
    # @param ID the new time zone ID.
    def set_id(id)
      if ((id).nil?)
        raise NullPointerException.new
      end
      @id = id
    end
    
    typesig { [] }
    # Returns a name of this time zone suitable for presentation to the user
    # in the default locale.
    # This method returns the long name, not including daylight savings.
    # If the display name is not available for the locale,
    # then this method returns a string in the
    # <a href="#NormalizedCustomID">normalized custom ID format</a>.
    # @return the human-readable name of this time zone in the default locale.
    # @since 1.2
    def get_display_name
      return get_display_name(false, LONG, Locale.get_default)
    end
    
    typesig { [Locale] }
    # Returns a name of this time zone suitable for presentation to the user
    # in the specified locale.
    # This method returns the long name, not including daylight savings.
    # If the display name is not available for the locale,
    # then this method returns a string in the
    # <a href="#NormalizedCustomID">normalized custom ID format</a>.
    # @param locale the locale in which to supply the display name.
    # @return the human-readable name of this time zone in the given locale.
    # @since 1.2
    def get_display_name(locale)
      return get_display_name(false, LONG, locale)
    end
    
    typesig { [::Java::Boolean, ::Java::Int] }
    # Returns a name of this time zone suitable for presentation to the user
    # in the default locale.
    # If the display name is not available for the locale, then this
    # method returns a string in the
    # <a href="#NormalizedCustomID">normalized custom ID format</a>.
    # @param daylight if true, return the daylight savings name.
    # @param style either <code>LONG</code> or <code>SHORT</code>
    # @return the human-readable name of this time zone in the default locale.
    # @since 1.2
    def get_display_name(daylight, style)
      return get_display_name(daylight, style, Locale.get_default)
    end
    
    typesig { [::Java::Boolean, ::Java::Int, Locale] }
    # Returns a name of this time zone suitable for presentation to the user
    # in the specified locale.
    # If the display name is not available for the locale,
    # then this method returns a string in the
    # <a href="#NormalizedCustomID">normalized custom ID format</a>.
    # @param daylight if true, return the daylight savings name.
    # @param style either <code>LONG</code> or <code>SHORT</code>
    # @param locale the locale in which to supply the display name.
    # @return the human-readable name of this time zone in the given locale.
    # @exception IllegalArgumentException style is invalid.
    # @since 1.2
    def get_display_name(daylight, style, locale)
      if (!(style).equal?(SHORT) && !(style).equal?(LONG))
        raise IllegalArgumentException.new("Illegal style: " + RJava.cast_to_string(style))
      end
      id = get_id
      names = get_display_names(id, locale)
      if ((names).nil?)
        if (id.starts_with("GMT"))
          sign = id.char_at(3)
          if ((sign).equal?(Character.new(?+.ord)) || (sign).equal?(Character.new(?-.ord)))
            return id
          end
        end
        offset = get_raw_offset
        if (daylight)
          offset += get_dstsavings
        end
        return ZoneInfoFile.to_custom_id(offset)
      end
      index = daylight ? 3 : 1
      if ((style).equal?(SHORT))
        index += 1
      end
      return names[index]
    end
    
    class_module.module_eval {
      const_set_lazy(:DisplayNames) { Class.new do
        include_class_members TimeZone
        
        class_module.module_eval {
          # Cache for managing display names per timezone per locale
          # The structure is:
          # Map(key=id, value=SoftReference(Map(key=locale, value=displaynames)))
          const_set_lazy(:CACHE) { class_self::ConcurrentHashMap.new }
          const_attr_reader  :CACHE
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__display_names, :initialize
      end }
      
      typesig { [String, Locale] }
      def get_display_names(id, locale)
        display_names = DisplayNames::CACHE
        ref = display_names.get(id)
        if (!(ref).nil?)
          per_locale = ref.get
          if (!(per_locale).nil?)
            names = per_locale.get(locale)
            if (!(names).nil?)
              return names
            end
            names = TimeZoneNameUtility.retrieve_display_names(id, locale)
            if (!(names).nil?)
              per_locale.put(locale, names)
            end
            return names
          end
        end
        names = TimeZoneNameUtility.retrieve_display_names(id, locale)
        if (!(names).nil?)
          per_locale = ConcurrentHashMap.new
          per_locale.put(locale, names)
          ref = SoftReference.new(per_locale)
          display_names.put(id, ref)
        end
        return names
      end
    }
    
    typesig { [] }
    # Returns the amount of time to be added to local standard time
    # to get local wall clock time.
    # <p>
    # The default implementation always returns 3600000 milliseconds
    # (i.e., one hour) if this time zone observes Daylight Saving
    # Time. Otherwise, 0 (zero) is returned.
    # <p>
    # If an underlying TimeZone implementation subclass supports
    # historical Daylight Saving Time changes, this method returns
    # the known latest daylight saving value.
    # 
    # @return the amount of saving time in milliseconds
    # @since 1.4
    def get_dstsavings
      if (use_daylight_time)
        return 3600000
      end
      return 0
    end
    
    typesig { [] }
    # Queries if this time zone uses daylight savings time.
    # <p>
    # If an underlying <code>TimeZone</code> implementation subclass
    # supports historical Daylight Saving Time schedule changes, the
    # method refers to the latest Daylight Saving Time schedule
    # information.
    # 
    # @return true if this time zone uses daylight savings time,
    # false, otherwise.
    def use_daylight_time
      raise NotImplementedError
    end
    
    typesig { [JavaDate] }
    # Queries if the given date is in daylight savings time in
    # this time zone.
    # @param date the given Date.
    # @return true if the given date is in daylight savings time,
    # false, otherwise.
    def in_daylight_time(date)
      raise NotImplementedError
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Gets the <code>TimeZone</code> for the given ID.
      # 
      # @param ID the ID for a <code>TimeZone</code>, either an abbreviation
      # such as "PST", a full name such as "America/Los_Angeles", or a custom
      # ID such as "GMT-8:00". Note that the support of abbreviations is
      # for JDK 1.1.x compatibility only and full names should be used.
      # 
      # @return the specified <code>TimeZone</code>, or the GMT zone if the given ID
      # cannot be understood.
      def get_time_zone(id)
        synchronized(self) do
          return get_time_zone(id, true)
        end
      end
      
      typesig { [String, ::Java::Boolean] }
      def get_time_zone(id, fallback)
        tz = ZoneInfo.get_time_zone(id)
        if ((tz).nil?)
          tz = parse_custom_time_zone(id)
          if ((tz).nil? && fallback)
            tz = ZoneInfo.new(GMT_ID, 0)
          end
        end
        return tz
      end
      
      typesig { [::Java::Int] }
      # Gets the available IDs according to the given time zone offset in milliseconds.
      # 
      # @param rawOffset the given time zone GMT offset in milliseconds.
      # @return an array of IDs, where the time zone for that ID has
      # the specified GMT offset. For example, "America/Phoenix" and "America/Denver"
      # both have GMT-07:00, but differ in daylight savings behavior.
      # @see #getRawOffset()
      def get_available_ids(raw_offset)
        synchronized(self) do
          return ZoneInfo.get_available_ids(raw_offset)
        end
      end
      
      typesig { [] }
      # Gets all the available IDs supported.
      # @return an array of IDs.
      def get_available_ids
        synchronized(self) do
          return ZoneInfo.get_available_ids
        end
      end
      
      JNI.native_method :Java_java_util_TimeZone_getSystemTimeZoneID, [:pointer, :long, :long, :long], :long
      typesig { [String, String] }
      # Gets the platform defined TimeZone ID.
      def get_system_time_zone_id(java_home, country)
        JNI.__send__(:Java_java_util_TimeZone_getSystemTimeZoneID, JNI.env, self.jni_id, java_home.jni_id, country.jni_id)
      end
      
      JNI.native_method :Java_java_util_TimeZone_getSystemGMTOffsetID, [:pointer, :long], :long
      typesig { [] }
      # Gets the custom time zone ID based on the GMT offset of the
      # platform. (e.g., "GMT+08:00")
      def get_system_gmtoffset_id
        JNI.__send__(:Java_java_util_TimeZone_getSystemGMTOffsetID, JNI.env, self.jni_id)
      end
      
      typesig { [] }
      # Gets the default <code>TimeZone</code> for this host.
      # The source of the default <code>TimeZone</code>
      # may vary with implementation.
      # @return a default <code>TimeZone</code>.
      # @see #setDefault
      def get_default
        return get_default_ref.clone
      end
      
      typesig { [] }
      # Returns the reference to the default TimeZone object. This
      # method doesn't create a clone.
      def get_default_ref
        default_zone = DefaultZoneTL.get
        if ((default_zone).nil?)
          default_zone = self.attr_default_time_zone
          if ((default_zone).nil?)
            # Need to initialize the default time zone.
            default_zone = set_default_zone
            raise AssertError if not (!(default_zone).nil?)
          end
        end
        # Don't clone here.
        return default_zone
      end
      
      typesig { [] }
      def set_default_zone
        synchronized(self) do
          tz = nil
          # get the time zone ID from the system properties
          zone_id = AccessController.do_privileged(GetPropertyAction.new("user.timezone"))
          # if the time zone ID is not set (yet), perform the
          # platform to Java time zone ID mapping.
          if ((zone_id).nil? || (zone_id == ""))
            country = AccessController.do_privileged(GetPropertyAction.new("user.country"))
            java_home = AccessController.do_privileged(GetPropertyAction.new("java.home"))
            begin
              zone_id = RJava.cast_to_string(get_system_time_zone_id(java_home, country))
              if ((zone_id).nil?)
                zone_id = GMT_ID
              end
            rescue NullPointerException => e
              zone_id = GMT_ID
            end
          end
          # Get the time zone for zoneID. But not fall back to
          # "GMT" here.
          tz = get_time_zone(zone_id, false)
          if ((tz).nil?)
            # If the given zone ID is unknown in Java, try to
            # get the GMT-offset-based time zone ID,
            # a.k.a. custom time zone ID (e.g., "GMT-08:00").
            gmt_offset_id = get_system_gmtoffset_id
            if (!(gmt_offset_id).nil?)
              zone_id = gmt_offset_id
            end
            tz = get_time_zone(zone_id, true)
          end
          raise AssertError if not (!(tz).nil?)
          id = zone_id
          AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members TimeZone
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              System.set_property("user.timezone", id)
              return nil
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          if (has_permission)
            self.attr_default_time_zone = tz
          else
            DefaultZoneTL.set(tz)
          end
          return tz
        end
      end
      
      typesig { [] }
      def has_permission
        has_permission_ = true
        sm = System.get_security_manager
        if (!(sm).nil?)
          begin
            sm.check_permission(PropertyPermission.new("user.timezone", "write"))
          rescue SecurityException => e
            has_permission_ = false
          end
        end
        return has_permission_
      end
      
      typesig { [TimeZone] }
      # Sets the <code>TimeZone</code> that is
      # returned by the <code>getDefault</code> method.  If <code>zone</code>
      # is null, reset the default to the value it had originally when the
      # VM first started.
      # @param zone the new default time zone
      # @see #getDefault
      def set_default(zone)
        if (has_permission)
          synchronized((TimeZone)) do
            self.attr_default_time_zone = zone
          end
        else
          DefaultZoneTL.set(zone)
        end
      end
    }
    
    typesig { [TimeZone] }
    # Returns true if this zone has the same rule and offset as another zone.
    # That is, if this zone differs only in ID, if at all.  Returns false
    # if the other zone is null.
    # @param other the <code>TimeZone</code> object to be compared with
    # @return true if the other zone is not null and is the same as this one,
    # with the possible exception of the ID
    # @since 1.2
    def has_same_rules(other)
      return !(other).nil? && (get_raw_offset).equal?(other.get_raw_offset) && (use_daylight_time).equal?(other.use_daylight_time)
    end
    
    typesig { [] }
    # Creates a copy of this <code>TimeZone</code>.
    # 
    # @return a clone of this <code>TimeZone</code>
    def clone
      begin
        other = super
        other.attr_id = @id
        return other
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
    end
    
    class_module.module_eval {
      # The null constant as a TimeZone.
      const_set_lazy(:NO_TIMEZONE) { nil }
      const_attr_reader  :NO_TIMEZONE
    }
    
    # =======================privates===============================
    # 
    # The string identifier of this <code>TimeZone</code>.  This is a
    # programmatic identifier used internally to look up <code>TimeZone</code>
    # objects from the system table and also to map them to their localized
    # display names.  <code>ID</code> values are unique in the system
    # table but may not be for dynamically created zones.
    # @serial
    attr_accessor :id
    alias_method :attr_id, :id
    undef_method :id
    alias_method :attr_id=, :id=
    undef_method :id=
    
    class_module.module_eval {
      
      def default_time_zone
        defined?(@@default_time_zone) ? @@default_time_zone : @@default_time_zone= nil
      end
      alias_method :attr_default_time_zone, :default_time_zone
      
      def default_time_zone=(value)
        @@default_time_zone = value
      end
      alias_method :attr_default_time_zone=, :default_time_zone=
      
      const_set_lazy(:DefaultZoneTL) { InheritableThreadLocal.new }
      const_attr_reader  :DefaultZoneTL
      
      const_set_lazy(:GMT_ID) { "GMT" }
      const_attr_reader  :GMT_ID
      
      const_set_lazy(:GMT_ID_LENGTH) { 3 }
      const_attr_reader  :GMT_ID_LENGTH
      
      typesig { [String] }
      # Parses a custom time zone identifier and returns a corresponding zone.
      # This method doesn't support the RFC 822 time zone format. (e.g., +hhmm)
      # 
      # @param id a string of the <a href="#CustomID">custom ID form</a>.
      # @return a newly created TimeZone with the given offset and
      # no daylight saving time, or null if the id cannot be parsed.
      def parse_custom_time_zone(id)
        length = 0
        # Error if the length of id isn't long enough or id doesn't
        # start with "GMT".
        if ((length = id.length) < (GMT_ID_LENGTH + 2) || !(id.index_of(GMT_ID)).equal?(0))
          return nil
        end
        zi = nil
        # First, we try to find it in the cache with the given
        # id. Even the id is not normalized, the returned ZoneInfo
        # should have its normalized id.
        zi = ZoneInfoFile.get_zone_info(id)
        if (!(zi).nil?)
          return zi
        end
        index = GMT_ID_LENGTH
        negative = false
        c = id.char_at(((index += 1) - 1))
        if ((c).equal?(Character.new(?-.ord)))
          negative = true
        else
          if (!(c).equal?(Character.new(?+.ord)))
            return nil
          end
        end
        hours = 0
        num = 0
        count_delim = 0
        len = 0
        while (index < length)
          c = id.char_at(((index += 1) - 1))
          if ((c).equal?(Character.new(?:.ord)))
            if (count_delim > 0)
              return nil
            end
            if (len > 2)
              return nil
            end
            hours = num
            count_delim += 1
            num = 0
            len = 0
            next
          end
          if (c < Character.new(?0.ord) || c > Character.new(?9.ord))
            return nil
          end
          num = num * 10 + (c - Character.new(?0.ord))
          len += 1
        end
        if (!(index).equal?(length))
          return nil
        end
        if ((count_delim).equal?(0))
          if (len <= 2)
            hours = num
            num = 0
          else
            hours = num / 100
            num %= 100
          end
        else
          if (!(len).equal?(2))
            return nil
          end
        end
        if (hours > 23 || num > 59)
          return nil
        end
        gmt_offset = (hours * 60 + num) * 60 * 1000
        if ((gmt_offset).equal?(0))
          zi = ZoneInfoFile.get_zone_info(GMT_ID)
          if (negative)
            zi.set_id("GMT-00:00")
          else
            zi.set_id("GMT+00:00")
          end
        else
          zi = ZoneInfoFile.get_custom_time_zone(id, negative ? -gmt_offset : gmt_offset)
        end
        return zi
      end
    }
    
    private
    alias_method :initialize__time_zone, :initialize
  end
  
end
