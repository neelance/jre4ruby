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
# (C) Copyright Taligent, Inc. 1996 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - All Rights Reserved
# 
#   The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
#   Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module DateFormatSymbolsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ObjectOutputStream
      include_const ::Java::Io, :Serializable
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Java::Text::Spi, :DateFormatSymbolsProvider
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util, :TimeZone
      include_const ::Java::Util::Spi, :LocaleServiceProvider
      include_const ::Sun::Util, :LocaleServiceProviderPool
      include_const ::Sun::Util, :TimeZoneNameUtility
      include_const ::Sun::Util::Calendar, :ZoneInfo
      include_const ::Sun::Util::Resources, :LocaleData
    }
  end
  
  # <code>DateFormatSymbols</code> is a public class for encapsulating
  # localizable date-time formatting data, such as the names of the
  # months, the names of the days of the week, and the time zone data.
  # <code>DateFormat</code> and <code>SimpleDateFormat</code> both use
  # <code>DateFormatSymbols</code> to encapsulate this information.
  # 
  # <p>
  # Typically you shouldn't use <code>DateFormatSymbols</code> directly.
  # Rather, you are encouraged to create a date-time formatter with the
  # <code>DateFormat</code> class's factory methods: <code>getTimeInstance</code>,
  # <code>getDateInstance</code>, or <code>getDateTimeInstance</code>.
  # These methods automatically create a <code>DateFormatSymbols</code> for
  # the formatter so that you don't have to. After the
  # formatter is created, you may modify its format pattern using the
  # <code>setPattern</code> method. For more information about
  # creating formatters using <code>DateFormat</code>'s factory methods,
  # see {@link DateFormat}.
  # 
  # <p>
  # If you decide to create a date-time formatter with a specific
  # format pattern for a specific locale, you can do so with:
  # <blockquote>
  # <pre>
  # new SimpleDateFormat(aPattern, DateFormatSymbols.getInstance(aLocale)).
  # </pre>
  # </blockquote>
  # 
  # <p>
  # <code>DateFormatSymbols</code> objects are cloneable. When you obtain
  # a <code>DateFormatSymbols</code> object, feel free to modify the
  # date-time formatting data. For instance, you can replace the localized
  # date-time format pattern characters with the ones that you feel easy
  # to remember. Or you can change the representative cities
  # to your favorite ones.
  # 
  # <p>
  # New <code>DateFormatSymbols</code> subclasses may be added to support
  # <code>SimpleDateFormat</code> for date-time formatting for additional locales.
  # 
  # @see          DateFormat
  # @see          SimpleDateFormat
  # @see          java.util.SimpleTimeZone
  # @author       Chen-Lieh Huang
  class DateFormatSymbols 
    include_class_members DateFormatSymbolsImports
    include Serializable
    include Cloneable
    
    typesig { [] }
    # Construct a DateFormatSymbols object by loading format data from
    # resources for the default locale. This constructor can only
    # construct instances for the locales supported by the Java
    # runtime environment, not for those supported by installed
    # {@link java.text.spi.DateFormatSymbolsProvider DateFormatSymbolsProvider}
    # implementations. For full locale coverage, use the
    # {@link #getInstance(Locale) getInstance} method.
    # 
    # @see #getInstance()
    # @exception  java.util.MissingResourceException
    #             if the resources for the default locale cannot be
    #             found or cannot be loaded.
    def initialize
      @eras = nil
      @months = nil
      @short_months = nil
      @weekdays = nil
      @short_weekdays = nil
      @ampms = nil
      @zone_strings = nil
      @is_zone_strings_set = false
      @local_pattern_chars = nil
      @locale = nil
      initialize_data(Locale.get_default)
    end
    
    typesig { [Locale] }
    # Construct a DateFormatSymbols object by loading format data from
    # resources for the given locale. This constructor can only
    # construct instances for the locales supported by the Java
    # runtime environment, not for those supported by installed
    # {@link java.text.spi.DateFormatSymbolsProvider DateFormatSymbolsProvider}
    # implementations. For full locale coverage, use the
    # {@link #getInstance(Locale) getInstance} method.
    # 
    # @see #getInstance(Locale)
    # @exception  java.util.MissingResourceException
    #             if the resources for the specified locale cannot be
    #             found or cannot be loaded.
    def initialize(locale)
      @eras = nil
      @months = nil
      @short_months = nil
      @weekdays = nil
      @short_weekdays = nil
      @ampms = nil
      @zone_strings = nil
      @is_zone_strings_set = false
      @local_pattern_chars = nil
      @locale = nil
      initialize_data(locale)
    end
    
    # Era strings. For example: "AD" and "BC".  An array of 2 strings,
    # indexed by <code>Calendar.BC</code> and <code>Calendar.AD</code>.
    # @serial
    attr_accessor :eras
    alias_method :attr_eras, :eras
    undef_method :eras
    alias_method :attr_eras=, :eras=
    undef_method :eras=
    
    # Month strings. For example: "January", "February", etc.  An array
    # of 13 strings (some calendars have 13 months), indexed by
    # <code>Calendar.JANUARY</code>, <code>Calendar.FEBRUARY</code>, etc.
    # @serial
    attr_accessor :months
    alias_method :attr_months, :months
    undef_method :months
    alias_method :attr_months=, :months=
    undef_method :months=
    
    # Short month strings. For example: "Jan", "Feb", etc.  An array of
    # 13 strings (some calendars have 13 months), indexed by
    # <code>Calendar.JANUARY</code>, <code>Calendar.FEBRUARY</code>, etc.
    # 
    # @serial
    attr_accessor :short_months
    alias_method :attr_short_months, :short_months
    undef_method :short_months
    alias_method :attr_short_months=, :short_months=
    undef_method :short_months=
    
    # Weekday strings. For example: "Sunday", "Monday", etc.  An array
    # of 8 strings, indexed by <code>Calendar.SUNDAY</code>,
    # <code>Calendar.MONDAY</code>, etc.
    # The element <code>weekdays[0]</code> is ignored.
    # @serial
    attr_accessor :weekdays
    alias_method :attr_weekdays, :weekdays
    undef_method :weekdays
    alias_method :attr_weekdays=, :weekdays=
    undef_method :weekdays=
    
    # Short weekday strings. For example: "Sun", "Mon", etc.  An array
    # of 8 strings, indexed by <code>Calendar.SUNDAY</code>,
    # <code>Calendar.MONDAY</code>, etc.
    # The element <code>shortWeekdays[0]</code> is ignored.
    # @serial
    attr_accessor :short_weekdays
    alias_method :attr_short_weekdays, :short_weekdays
    undef_method :short_weekdays
    alias_method :attr_short_weekdays=, :short_weekdays=
    undef_method :short_weekdays=
    
    # AM and PM strings. For example: "AM" and "PM".  An array of
    # 2 strings, indexed by <code>Calendar.AM</code> and
    # <code>Calendar.PM</code>.
    # @serial
    attr_accessor :ampms
    alias_method :attr_ampms, :ampms
    undef_method :ampms
    alias_method :attr_ampms=, :ampms=
    undef_method :ampms=
    
    # Localized names of time zones in this locale.  This is a
    # two-dimensional array of strings of size <em>n</em> by <em>m</em>,
    # where <em>m</em> is at least 5.  Each of the <em>n</em> rows is an
    # entry containing the localized names for a single <code>TimeZone</code>.
    # Each such row contains (with <code>i</code> ranging from
    # 0..<em>n</em>-1):
    # <ul>
    # <li><code>zoneStrings[i][0]</code> - time zone ID</li>
    # <li><code>zoneStrings[i][1]</code> - long name of zone in standard
    # time</li>
    # <li><code>zoneStrings[i][2]</code> - short name of zone in
    # standard time</li>
    # <li><code>zoneStrings[i][3]</code> - long name of zone in daylight
    # saving time</li>
    # <li><code>zoneStrings[i][4]</code> - short name of zone in daylight
    # saving time</li>
    # </ul>
    # The zone ID is <em>not</em> localized; it's one of the valid IDs of
    # the {@link java.util.TimeZone TimeZone} class that are not
    # <a href="../java/util/TimeZone.html#CustomID">custom IDs</a>.
    # All other entries are localized names.
    # @see java.util.TimeZone
    # @serial
    attr_accessor :zone_strings
    alias_method :attr_zone_strings, :zone_strings
    undef_method :zone_strings
    alias_method :attr_zone_strings=, :zone_strings=
    undef_method :zone_strings=
    
    # Indicates that zoneStrings is set externally with setZoneStrings() method.
    attr_accessor :is_zone_strings_set
    alias_method :attr_is_zone_strings_set, :is_zone_strings_set
    undef_method :is_zone_strings_set
    alias_method :attr_is_zone_strings_set=, :is_zone_strings_set=
    undef_method :is_zone_strings_set=
    
    class_module.module_eval {
      # Unlocalized date-time pattern characters. For example: 'y', 'd', etc.
      # All locales use the same these unlocalized pattern characters.
      const_set_lazy(:PatternChars) { "GyMdkHmsSEDFwWahKzZ" }
      const_attr_reader  :PatternChars
    }
    
    # Localized date-time pattern characters. For example, a locale may
    # wish to use 'u' rather than 'y' to represent years in its date format
    # pattern strings.
    # This string must be exactly 18 characters long, with the index of
    # the characters described by <code>DateFormat.ERA_FIELD</code>,
    # <code>DateFormat.YEAR_FIELD</code>, etc.  Thus, if the string were
    # "Xz...", then localized patterns would use 'X' for era and 'z' for year.
    # @serial
    attr_accessor :local_pattern_chars
    alias_method :attr_local_pattern_chars, :local_pattern_chars
    undef_method :local_pattern_chars
    alias_method :attr_local_pattern_chars=, :local_pattern_chars=
    undef_method :local_pattern_chars=
    
    # The locale which is used for initializing this DateFormatSymbols object.
    # 
    # @since 1.6
    # @serial
    attr_accessor :locale
    alias_method :attr_locale, :locale
    undef_method :locale
    alias_method :attr_locale=, :locale=
    undef_method :locale=
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.1.4 for interoperability
      const_set_lazy(:SerialVersionUID) { -5987973545549424702 }
      const_attr_reader  :SerialVersionUID
      
      typesig { [] }
      # Returns an array of all locales for which the
      # <code>getInstance</code> methods of this class can return
      # localized instances.
      # The returned array represents the union of locales supported by the
      # Java runtime and by installed
      # {@link java.text.spi.DateFormatSymbolsProvider DateFormatSymbolsProvider}
      # implementations.  It must contain at least a <code>Locale</code>
      # instance equal to {@link java.util.Locale#US Locale.US}.
      # 
      # @return An array of locales for which localized
      #         <code>DateFormatSymbols</code> instances are available.
      # @since 1.6
      def get_available_locales
        pool = LocaleServiceProviderPool.get_pool(DateFormatSymbolsProvider)
        return pool.get_available_locales
      end
      
      typesig { [] }
      # Gets the <code>DateFormatSymbols</code> instance for the default
      # locale.  This method provides access to <code>DateFormatSymbols</code>
      # instances for locales supported by the Java runtime itself as well
      # as for those supported by installed
      # {@link java.text.spi.DateFormatSymbolsProvider DateFormatSymbolsProvider}
      # implementations.
      # @return a <code>DateFormatSymbols</code> instance.
      # @since 1.6
      def get_instance
        return get_instance(Locale.get_default)
      end
      
      typesig { [Locale] }
      # Gets the <code>DateFormatSymbols</code> instance for the specified
      # locale.  This method provides access to <code>DateFormatSymbols</code>
      # instances for locales supported by the Java runtime itself as well
      # as for those supported by installed
      # {@link java.text.spi.DateFormatSymbolsProvider DateFormatSymbolsProvider}
      # implementations.
      # @param locale the given locale.
      # @return a <code>DateFormatSymbols</code> instance.
      # @exception NullPointerException if <code>locale</code> is null
      # @since 1.6
      def get_instance(locale)
        # Check whether a provider can provide an implementation that's closer
        # to the requested locale than what the Java runtime itself can provide.
        pool = LocaleServiceProviderPool.get_pool(DateFormatSymbolsProvider)
        if (pool.has_providers)
          providers_instance = pool.get_localized_object(DateFormatSymbolsGetter::INSTANCE, locale)
          if (!(providers_instance).nil?)
            return providers_instance
          end
        end
        return DateFormatSymbols.new(locale)
      end
    }
    
    typesig { [] }
    # Gets era strings. For example: "AD" and "BC".
    # @return the era strings.
    def get_eras
      return duplicate(@eras)
    end
    
    typesig { [Array.typed(String)] }
    # Sets era strings. For example: "AD" and "BC".
    # @param newEras the new era strings.
    def set_eras(new_eras)
      @eras = duplicate(new_eras)
    end
    
    typesig { [] }
    # Gets month strings. For example: "January", "February", etc.
    # @return the month strings.
    def get_months
      return duplicate(@months)
    end
    
    typesig { [Array.typed(String)] }
    # Sets month strings. For example: "January", "February", etc.
    # @param newMonths the new month strings.
    def set_months(new_months)
      @months = duplicate(new_months)
    end
    
    typesig { [] }
    # Gets short month strings. For example: "Jan", "Feb", etc.
    # @return the short month strings.
    def get_short_months
      return duplicate(@short_months)
    end
    
    typesig { [Array.typed(String)] }
    # Sets short month strings. For example: "Jan", "Feb", etc.
    # @param newShortMonths the new short month strings.
    def set_short_months(new_short_months)
      @short_months = duplicate(new_short_months)
    end
    
    typesig { [] }
    # Gets weekday strings. For example: "Sunday", "Monday", etc.
    # @return the weekday strings. Use <code>Calendar.SUNDAY</code>,
    # <code>Calendar.MONDAY</code>, etc. to index the result array.
    def get_weekdays
      return duplicate(@weekdays)
    end
    
    typesig { [Array.typed(String)] }
    # Sets weekday strings. For example: "Sunday", "Monday", etc.
    # @param newWeekdays the new weekday strings. The array should
    # be indexed by <code>Calendar.SUNDAY</code>,
    # <code>Calendar.MONDAY</code>, etc.
    def set_weekdays(new_weekdays)
      @weekdays = duplicate(new_weekdays)
    end
    
    typesig { [] }
    # Gets short weekday strings. For example: "Sun", "Mon", etc.
    # @return the short weekday strings. Use <code>Calendar.SUNDAY</code>,
    # <code>Calendar.MONDAY</code>, etc. to index the result array.
    def get_short_weekdays
      return duplicate(@short_weekdays)
    end
    
    typesig { [Array.typed(String)] }
    # Sets short weekday strings. For example: "Sun", "Mon", etc.
    # @param newShortWeekdays the new short weekday strings. The array should
    # be indexed by <code>Calendar.SUNDAY</code>,
    # <code>Calendar.MONDAY</code>, etc.
    def set_short_weekdays(new_short_weekdays)
      @short_weekdays = duplicate(new_short_weekdays)
    end
    
    typesig { [] }
    # Gets ampm strings. For example: "AM" and "PM".
    # @return the ampm strings.
    def get_am_pm_strings
      return duplicate(@ampms)
    end
    
    typesig { [Array.typed(String)] }
    # Sets ampm strings. For example: "AM" and "PM".
    # @param newAmpms the new ampm strings.
    def set_am_pm_strings(new_ampms)
      @ampms = duplicate(new_ampms)
    end
    
    typesig { [] }
    # Gets time zone strings.  Use of this method is discouraged; use
    # {@link java.util.TimeZone#getDisplayName() TimeZone.getDisplayName()}
    # instead.
    # <p>
    # The value returned is a
    # two-dimensional array of strings of size <em>n</em> by <em>m</em>,
    # where <em>m</em> is at least 5.  Each of the <em>n</em> rows is an
    # entry containing the localized names for a single <code>TimeZone</code>.
    # Each such row contains (with <code>i</code> ranging from
    # 0..<em>n</em>-1):
    # <ul>
    # <li><code>zoneStrings[i][0]</code> - time zone ID</li>
    # <li><code>zoneStrings[i][1]</code> - long name of zone in standard
    # time</li>
    # <li><code>zoneStrings[i][2]</code> - short name of zone in
    # standard time</li>
    # <li><code>zoneStrings[i][3]</code> - long name of zone in daylight
    # saving time</li>
    # <li><code>zoneStrings[i][4]</code> - short name of zone in daylight
    # saving time</li>
    # </ul>
    # The zone ID is <em>not</em> localized; it's one of the valid IDs of
    # the {@link java.util.TimeZone TimeZone} class that are not
    # <a href="../util/TimeZone.html#CustomID">custom IDs</a>.
    # All other entries are localized names.  If a zone does not implement
    # daylight saving time, the daylight saving time names should not be used.
    # <p>
    # If {@link #setZoneStrings(String[][]) setZoneStrings} has been called
    # on this <code>DateFormatSymbols</code> instance, then the strings
    # provided by that call are returned. Otherwise, the returned array
    # contains names provided by the Java runtime and by installed
    # {@link java.util.spi.TimeZoneNameProvider TimeZoneNameProvider}
    # implementations.
    # 
    # @return the time zone strings.
    # @see #setZoneStrings(String[][])
    def get_zone_strings
      return get_zone_strings_impl(true)
    end
    
    typesig { [Array.typed(Array.typed(String))] }
    # Sets time zone strings.  The argument must be a
    # two-dimensional array of strings of size <em>n</em> by <em>m</em>,
    # where <em>m</em> is at least 5.  Each of the <em>n</em> rows is an
    # entry containing the localized names for a single <code>TimeZone</code>.
    # Each such row contains (with <code>i</code> ranging from
    # 0..<em>n</em>-1):
    # <ul>
    # <li><code>zoneStrings[i][0]</code> - time zone ID</li>
    # <li><code>zoneStrings[i][1]</code> - long name of zone in standard
    # time</li>
    # <li><code>zoneStrings[i][2]</code> - short name of zone in
    # standard time</li>
    # <li><code>zoneStrings[i][3]</code> - long name of zone in daylight
    # saving time</li>
    # <li><code>zoneStrings[i][4]</code> - short name of zone in daylight
    # saving time</li>
    # </ul>
    # The zone ID is <em>not</em> localized; it's one of the valid IDs of
    # the {@link java.util.TimeZone TimeZone} class that are not
    # <a href="../util/TimeZone.html#CustomID">custom IDs</a>.
    # All other entries are localized names.
    # 
    # @param newZoneStrings the new time zone strings.
    # @exception IllegalArgumentException if the length of any row in
    #    <code>newZoneStrings</code> is less than 5
    # @exception NullPointerException if <code>newZoneStrings</code> is null
    # @see #getZoneStrings()
    def set_zone_strings(new_zone_strings)
      a_copy = Array.typed(Array.typed(String)).new(new_zone_strings.attr_length) { nil }
      i = 0
      while i < new_zone_strings.attr_length
        if (new_zone_strings[i].attr_length < 5)
          raise IllegalArgumentException.new
        end
        a_copy[i] = duplicate(new_zone_strings[i])
        (i += 1)
      end
      @zone_strings = a_copy
      @is_zone_strings_set = true
    end
    
    typesig { [] }
    # Gets localized date-time pattern characters. For example: 'u', 't', etc.
    # @return the localized date-time pattern characters.
    def get_local_pattern_chars
      return String.new(@local_pattern_chars)
    end
    
    typesig { [String] }
    # Sets localized date-time pattern characters. For example: 'u', 't', etc.
    # @param newLocalPatternChars the new localized date-time
    # pattern characters.
    def set_local_pattern_chars(new_local_pattern_chars)
      @local_pattern_chars = RJava.cast_to_string(String.new(new_local_pattern_chars))
    end
    
    typesig { [] }
    # Overrides Cloneable
    def clone
      begin
        other = super
        copy_members(self, other)
        return other
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
    end
    
    typesig { [] }
    # Override hashCode.
    # Generates a hash code for the DateFormatSymbols object.
    def hash_code
      hashcode = 0
      zone_strings = get_zone_strings_wrapper
      index = 0
      while index < zone_strings[0].attr_length
        hashcode ^= zone_strings[0][index].hash_code
        (index += 1)
      end
      return hashcode
    end
    
    typesig { [Object] }
    # Override equals
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if ((obj).nil? || !(get_class).equal?(obj.get_class))
        return false
      end
      that = obj
      return (Arrays.==(@eras, that.attr_eras) && Arrays.==(@months, that.attr_months) && Arrays.==(@short_months, that.attr_short_months) && Arrays.==(@weekdays, that.attr_weekdays) && Arrays.==(@short_weekdays, that.attr_short_weekdays) && Arrays.==(@ampms, that.attr_ampms) && Arrays.deep_equals(get_zone_strings_wrapper, that.get_zone_strings_wrapper) && ((!(@local_pattern_chars).nil? && (@local_pattern_chars == that.attr_local_pattern_chars)) || ((@local_pattern_chars).nil? && (that.attr_local_pattern_chars).nil?)))
    end
    
    class_module.module_eval {
      # =======================privates===============================
      # Useful constant for defining time zone offsets.
      const_set_lazy(:MillisPerHour) { 60 * 60 * 1000 }
      const_attr_reader  :MillisPerHour
      
      # Cache to hold the FormatData and TimeZoneNames ResourceBundles
      # of a Locale.
      
      def cached_locale_data
        defined?(@@cached_locale_data) ? @@cached_locale_data : @@cached_locale_data= Hashtable.new(3)
      end
      alias_method :attr_cached_locale_data, :cached_locale_data
      
      def cached_locale_data=(value)
        @@cached_locale_data = value
      end
      alias_method :attr_cached_locale_data=, :cached_locale_data=
      
      typesig { [Locale] }
      # Look up resource data for the desiredLocale in the cache; update the
      # cache if necessary.
      def cache_lookup(desired_locale)
        rb = nil
        data = self.attr_cached_locale_data.get(desired_locale)
        if ((data).nil?)
          rb = LocaleData.get_date_format_data(desired_locale)
          data = SoftReference.new(rb)
          self.attr_cached_locale_data.put(desired_locale, data)
        else
          if (((rb = data.get)).nil?)
            rb = LocaleData.get_date_format_data(desired_locale)
            data = SoftReference.new(rb)
          end
        end
        return rb
      end
    }
    
    typesig { [Locale] }
    def initialize_data(desired_locale)
      i = 0
      resource = cache_lookup(desired_locale)
      # FIXME: cache only ResourceBundle. Hence every time, will do
      # getObject(). This won't be necessary if the Resource itself
      # is cached.
      @eras = resource.get_object("Eras")
      @months = resource.get_string_array("MonthNames")
      @short_months = resource.get_string_array("MonthAbbreviations")
      l_weekdays = resource.get_string_array("DayNames")
      @weekdays = Array.typed(String).new(8) { nil }
      @weekdays[0] = "" # 1-based
      i = 0
      while i < l_weekdays.attr_length
        @weekdays[i + 1] = l_weekdays[i]
        i += 1
      end
      s_weekdays = resource.get_string_array("DayAbbreviations")
      @short_weekdays = Array.typed(String).new(8) { nil }
      @short_weekdays[0] = "" # 1-based
      i = 0
      while i < s_weekdays.attr_length
        @short_weekdays[i + 1] = s_weekdays[i]
        i += 1
      end
      @ampms = resource.get_string_array("AmPmMarkers")
      @local_pattern_chars = RJava.cast_to_string(resource.get_string("DateTimePatternChars"))
      @locale = desired_locale
    end
    
    typesig { [String] }
    # Package private: used by SimpleDateFormat
    # Gets the index for the given time zone ID to obtain the time zone
    # strings for formatting. The time zone ID is just for programmatic
    # lookup. NOT LOCALIZED!!!
    # @param ID the given time zone ID.
    # @return the index of the given time zone ID.  Returns -1 if
    # the given time zone ID can't be located in the DateFormatSymbols object.
    # @see java.util.SimpleTimeZone
    def get_zone_index(id)
      zone_strings = get_zone_strings_wrapper
      index = 0
      while index < zone_strings.attr_length
        if (id.equals_ignore_case(zone_strings[index][0]))
          return index
        end
        index += 1
      end
      return -1
    end
    
    typesig { [] }
    # Wrapper method to the getZoneStrings(), which is called from inside
    # the java.text package and not to mutate the returned arrays, so that
    # it does not need to create a defensive copy.
    def get_zone_strings_wrapper
      if (is_subclass_object)
        return get_zone_strings
      else
        return get_zone_strings_impl(false)
      end
    end
    
    typesig { [::Java::Boolean] }
    def get_zone_strings_impl(needs_copy)
      if ((@zone_strings).nil?)
        @zone_strings = TimeZoneNameUtility.get_zone_strings(@locale)
      end
      if (needs_copy)
        a_copy = Array.typed(Array.typed(String)).new(@zone_strings.attr_length) { nil }
        i = 0
        while i < @zone_strings.attr_length
          a_copy[i] = duplicate(@zone_strings[i])
          (i += 1)
        end
        return a_copy
      else
        return @zone_strings
      end
    end
    
    typesig { [] }
    def is_subclass_object
      return !(get_class.get_name == "java.text.DateFormatSymbols")
    end
    
    typesig { [Array.typed(String)] }
    # Clones an array of Strings.
    # @param srcArray the source array to be cloned.
    # @param count the number of elements in the given source array.
    # @return a cloned array.
    def duplicate(src_array)
      dst_array = Array.typed(String).new(src_array.attr_length) { nil }
      System.arraycopy(src_array, 0, dst_array, 0, src_array.attr_length)
      return dst_array
    end
    
    typesig { [DateFormatSymbols, DateFormatSymbols] }
    # Clones all the data members from the source DateFormatSymbols to
    # the target DateFormatSymbols. This is only for subclasses.
    # @param src the source DateFormatSymbols.
    # @param dst the target DateFormatSymbols.
    def copy_members(src, dst)
      dst.attr_eras = duplicate(src.attr_eras)
      dst.attr_months = duplicate(src.attr_months)
      dst.attr_short_months = duplicate(src.attr_short_months)
      dst.attr_weekdays = duplicate(src.attr_weekdays)
      dst.attr_short_weekdays = duplicate(src.attr_short_weekdays)
      dst.attr_ampms = duplicate(src.attr_ampms)
      if (!(src.attr_zone_strings).nil?)
        if ((dst.attr_zone_strings).nil?)
          dst.attr_zone_strings = Array.typed(Array.typed(String)).new(src.attr_zone_strings.attr_length) { nil }
        end
        i = 0
        while i < dst.attr_zone_strings.attr_length
          dst.attr_zone_strings[i] = duplicate(src.attr_zone_strings[i])
          (i += 1)
        end
      else
        dst.attr_zone_strings = nil
      end
      dst.attr_local_pattern_chars = String.new(src.attr_local_pattern_chars)
    end
    
    typesig { [Array.typed(String), Array.typed(String)] }
    # Compares the equality of the two arrays of String.
    # @param current this String array.
    # @param other that String array.
    def ==(current, other)
      count = current.attr_length
      i = 0
      while i < count
        if (!(current[i] == other[i]))
          return false
        end
        (i += 1)
      end
      return true
    end
    
    typesig { [ObjectOutputStream] }
    # Write out the default serializable data, after ensuring the
    # <code>zoneStrings</code> field is initialized in order to make
    # sure the backward compatibility.
    # 
    # @since 1.6
    def write_object(stream)
      if ((@zone_strings).nil?)
        @zone_strings = TimeZoneNameUtility.get_zone_strings(@locale)
      end
      stream.default_write_object
    end
    
    class_module.module_eval {
      # Obtains a DateFormatSymbols instance from a DateFormatSymbolsProvider
      # implementation.
      const_set_lazy(:DateFormatSymbolsGetter) { Class.new do
        include_class_members DateFormatSymbols
        include LocaleServiceProviderPool::LocalizedObjectGetter
        
        class_module.module_eval {
          const_set_lazy(:INSTANCE) { class_self::DateFormatSymbolsGetter.new }
          const_attr_reader  :INSTANCE
        }
        
        typesig { [class_self::DateFormatSymbolsProvider, class_self::Locale, String, Vararg.new(Object)] }
        def get_object(date_format_symbols_provider, locale, key, *params)
          raise AssertError if not ((params.attr_length).equal?(0))
          return date_format_symbols_provider.get_instance(locale)
        end
        
        typesig { [class_self::DateFormatSymbolsProvider, class_self::Locale, String, Array.typed(Object)] }
        def get_object(date_format_symbols_provider, locale, key, params)
          get_object(date_format_symbols_provider, locale, key, *params)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__date_format_symbols_getter, :initialize
      end }
    }
    
    private
    alias_method :initialize__date_format_symbols, :initialize
  end
  
end
