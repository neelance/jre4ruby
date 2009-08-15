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
# 
# 
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - 1998 - All Rights Reserved
# 
# The original version of this source code and documentation
# is copyrighted and owned by Taligent, Inc., a wholly-owned
# subsidiary of IBM. These materials are provided under terms
# of a License Agreement between Taligent and Sun. This technology
# is protected by multiple US and International patents.
# 
# This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Util
  module LocaleImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include ::Java::Io
      include_const ::Java::Security, :AccessController
      include_const ::Java::Text, :MessageFormat
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util::Concurrent, :ConcurrentHashMap
      include_const ::Java::Util::Spi, :LocaleNameProvider
      include_const ::Java::Util::Spi, :LocaleServiceProvider
      include_const ::Sun::Security::Action, :GetPropertyAction
      include_const ::Sun::Util, :LocaleServiceProviderPool
      include_const ::Sun::Util::Resources, :LocaleData
      include_const ::Sun::Util::Resources, :OpenListResourceBundle
    }
  end
  
  # A <code>Locale</code> object represents a specific geographical, political,
  # or cultural region. An operation that requires a <code>Locale</code> to perform
  # its task is called <em>locale-sensitive</em> and uses the <code>Locale</code>
  # to tailor information for the user. For example, displaying a number
  # is a locale-sensitive operation--the number should be formatted
  # according to the customs/conventions of the user's native country,
  # region, or culture.
  # 
  # <P>
  # Create a <code>Locale</code> object using the constructors in this class:
  # <blockquote>
  # <pre>
  # Locale(String language)
  # Locale(String language, String country)
  # Locale(String language, String country, String variant)
  # </pre>
  # </blockquote>
  # The language argument is a valid <STRONG>ISO Language Code.</STRONG>
  # These codes are the lower-case, two-letter codes as defined by ISO-639.
  # You can find a full list of these codes at a number of sites, such as:
  # <BR><a href ="http://www.loc.gov/standards/iso639-2/php/English_list.php">
  # <code>http://www.loc.gov/standards/iso639-2/php/English_list.php</code></a>
  # 
  # <P>
  # The country argument is a valid <STRONG>ISO Country Code.</STRONG> These
  # codes are the upper-case, two-letter codes as defined by ISO-3166.
  # You can find a full list of these codes at a number of sites, such as:
  # <BR><a href="http://www.iso.ch/iso/en/prods-services/iso3166ma/02iso-3166-code-lists/list-en1.html">
  # <code>http://www.iso.ch/iso/en/prods-services/iso3166ma/02iso-3166-code-lists/list-en1.html</code></a>
  # 
  # <P>
  # The variant argument is a vendor or browser-specific code.
  # For example, use WIN for Windows, MAC for Macintosh, and POSIX for POSIX.
  # Where there are two variants, separate them with an underscore, and
  # put the most important one first. For example, a Traditional Spanish collation
  # might construct a locale with parameters for language, country and variant as:
  # "es", "ES", "Traditional_WIN".
  # 
  # <P>
  # Because a <code>Locale</code> object is just an identifier for a region,
  # no validity check is performed when you construct a <code>Locale</code>.
  # If you want to see whether particular resources are available for the
  # <code>Locale</code> you construct, you must query those resources. For
  # example, ask the <code>NumberFormat</code> for the locales it supports
  # using its <code>getAvailableLocales</code> method.
  # <BR><STRONG>Note:</STRONG> When you ask for a resource for a particular
  # locale, you get back the best available match, not necessarily
  # precisely what you asked for. For more information, look at
  # {@link ResourceBundle}.
  # 
  # <P>
  # The <code>Locale</code> class provides a number of convenient constants
  # that you can use to create <code>Locale</code> objects for commonly used
  # locales. For example, the following creates a <code>Locale</code> object
  # for the United States:
  # <blockquote>
  # <pre>
  # Locale.US
  # </pre>
  # </blockquote>
  # 
  # <P>
  # Once you've created a <code>Locale</code> you can query it for information about
  # itself. Use <code>getCountry</code> to get the ISO Country Code and
  # <code>getLanguage</code> to get the ISO Language Code. You can
  # use <code>getDisplayCountry</code> to get the
  # name of the country suitable for displaying to the user. Similarly,
  # you can use <code>getDisplayLanguage</code> to get the name of
  # the language suitable for displaying to the user. Interestingly,
  # the <code>getDisplayXXX</code> methods are themselves locale-sensitive
  # and have two versions: one that uses the default locale and one
  # that uses the locale specified as an argument.
  # 
  # <P>
  # The Java Platform provides a number of classes that perform locale-sensitive
  # operations. For example, the <code>NumberFormat</code> class formats
  # numbers, currency, or percentages in a locale-sensitive manner. Classes
  # such as <code>NumberFormat</code> have a number of convenience methods
  # for creating a default object of that type. For example, the
  # <code>NumberFormat</code> class provides these three convenience methods
  # for creating a default <code>NumberFormat</code> object:
  # <blockquote>
  # <pre>
  # NumberFormat.getInstance()
  # NumberFormat.getCurrencyInstance()
  # NumberFormat.getPercentInstance()
  # </pre>
  # </blockquote>
  # These methods have two variants; one with an explicit locale
  # and one without; the latter using the default locale.
  # <blockquote>
  # <pre>
  # NumberFormat.getInstance(myLocale)
  # NumberFormat.getCurrencyInstance(myLocale)
  # NumberFormat.getPercentInstance(myLocale)
  # </pre>
  # </blockquote>
  # A <code>Locale</code> is the mechanism for identifying the kind of object
  # (<code>NumberFormat</code>) that you would like to get. The locale is
  # <STRONG>just</STRONG> a mechanism for identifying objects,
  # <STRONG>not</STRONG> a container for the objects themselves.
  # 
  # @see         ResourceBundle
  # @see         java.text.Format
  # @see         java.text.NumberFormat
  # @see         java.text.Collator
  # @author      Mark Davis
  # @since       1.1
  class Locale 
    include_class_members LocaleImports
    include Cloneable
    include Serializable
    
    class_module.module_eval {
      # cache to store singleton Locales
      const_set_lazy(:Cache) { ConcurrentHashMap.new(32) }
      const_attr_reader  :Cache
      
      # Useful constant for language.
      const_set_lazy(:ENGLISH) { create_singleton("en__", "en", "") }
      const_attr_reader  :ENGLISH
      
      # Useful constant for language.
      const_set_lazy(:FRENCH) { create_singleton("fr__", "fr", "") }
      const_attr_reader  :FRENCH
      
      # Useful constant for language.
      const_set_lazy(:GERMAN) { create_singleton("de__", "de", "") }
      const_attr_reader  :GERMAN
      
      # Useful constant for language.
      const_set_lazy(:ITALIAN) { create_singleton("it__", "it", "") }
      const_attr_reader  :ITALIAN
      
      # Useful constant for language.
      const_set_lazy(:JAPANESE) { create_singleton("ja__", "ja", "") }
      const_attr_reader  :JAPANESE
      
      # Useful constant for language.
      const_set_lazy(:KOREAN) { create_singleton("ko__", "ko", "") }
      const_attr_reader  :KOREAN
      
      # Useful constant for language.
      const_set_lazy(:CHINESE) { create_singleton("zh__", "zh", "") }
      const_attr_reader  :CHINESE
      
      # Useful constant for language.
      const_set_lazy(:SIMPLIFIED_CHINESE) { create_singleton("zh_CN_", "zh", "CN") }
      const_attr_reader  :SIMPLIFIED_CHINESE
      
      # Useful constant for language.
      const_set_lazy(:TRADITIONAL_CHINESE) { create_singleton("zh_TW_", "zh", "TW") }
      const_attr_reader  :TRADITIONAL_CHINESE
      
      # Useful constant for country.
      const_set_lazy(:FRANCE) { create_singleton("fr_FR_", "fr", "FR") }
      const_attr_reader  :FRANCE
      
      # Useful constant for country.
      const_set_lazy(:GERMANY) { create_singleton("de_DE_", "de", "DE") }
      const_attr_reader  :GERMANY
      
      # Useful constant for country.
      const_set_lazy(:ITALY) { create_singleton("it_IT_", "it", "IT") }
      const_attr_reader  :ITALY
      
      # Useful constant for country.
      const_set_lazy(:JAPAN) { create_singleton("ja_JP_", "ja", "JP") }
      const_attr_reader  :JAPAN
      
      # Useful constant for country.
      const_set_lazy(:KOREA) { create_singleton("ko_KR_", "ko", "KR") }
      const_attr_reader  :KOREA
      
      # Useful constant for country.
      const_set_lazy(:CHINA) { SIMPLIFIED_CHINESE }
      const_attr_reader  :CHINA
      
      # Useful constant for country.
      const_set_lazy(:PRC) { SIMPLIFIED_CHINESE }
      const_attr_reader  :PRC
      
      # Useful constant for country.
      const_set_lazy(:TAIWAN) { TRADITIONAL_CHINESE }
      const_attr_reader  :TAIWAN
      
      # Useful constant for country.
      const_set_lazy(:UK) { create_singleton("en_GB_", "en", "GB") }
      const_attr_reader  :UK
      
      # Useful constant for country.
      const_set_lazy(:US) { create_singleton("en_US_", "en", "US") }
      const_attr_reader  :US
      
      # Useful constant for country.
      const_set_lazy(:CANADA) { create_singleton("en_CA_", "en", "CA") }
      const_attr_reader  :CANADA
      
      # Useful constant for country.
      const_set_lazy(:CANADA_FRENCH) { create_singleton("fr_CA_", "fr", "CA") }
      const_attr_reader  :CANADA_FRENCH
      
      # Useful constant for the root locale.  The root locale is the locale whose
      # language, country, and variant are empty ("") strings.  This is regarded
      # as the base locale of all locales, and is used as the language/country
      # neutral locale for the locale sensitive operations.
      # 
      # @since 1.6
      const_set_lazy(:ROOT) { create_singleton("__", "", "") }
      const_attr_reader  :ROOT
      
      # serialization ID
      const_set_lazy(:SerialVersionUID) { 9149081749638150636 }
      const_attr_reader  :SerialVersionUID
      
      # Display types for retrieving localized names from the name providers.
      const_set_lazy(:DISPLAY_LANGUAGE) { 0 }
      const_attr_reader  :DISPLAY_LANGUAGE
      
      const_set_lazy(:DISPLAY_COUNTRY) { 1 }
      const_attr_reader  :DISPLAY_COUNTRY
      
      const_set_lazy(:DISPLAY_VARIANT) { 2 }
      const_attr_reader  :DISPLAY_VARIANT
    }
    
    typesig { [String, String, String] }
    # Construct a locale from language, country, variant.
    # NOTE:  ISO 639 is not a stable standard; some of the language codes it defines
    # (specifically iw, ji, and in) have changed.  This constructor accepts both the
    # old codes (iw, ji, and in) and the new codes (he, yi, and id), but all other
    # API on Locale will return only the OLD codes.
    # @param language lowercase two-letter ISO-639 code.
    # @param country uppercase two-letter ISO-3166 code.
    # @param variant vendor and browser specific code. See class description.
    # @exception NullPointerException thrown if any argument is null.
    def initialize(language, country, variant)
      @language = nil
      @country = nil
      @variant = nil
      @hashcode = -1
      @hash_code_value = 0
      @language = convert_old_isocodes(language)
      @country = to_upper_case(country).intern
      @variant = variant.intern
    end
    
    typesig { [String, String] }
    # Construct a locale from language, country.
    # NOTE:  ISO 639 is not a stable standard; some of the language codes it defines
    # (specifically iw, ji, and in) have changed.  This constructor accepts both the
    # old codes (iw, ji, and in) and the new codes (he, yi, and id), but all other
    # API on Locale will return only the OLD codes.
    # @param language lowercase two-letter ISO-639 code.
    # @param country uppercase two-letter ISO-3166 code.
    # @exception NullPointerException thrown if either argument is null.
    def initialize(language, country)
      initialize__locale(language, country, "")
    end
    
    typesig { [String] }
    # Construct a locale from a language code.
    # NOTE:  ISO 639 is not a stable standard; some of the language codes it defines
    # (specifically iw, ji, and in) have changed.  This constructor accepts both the
    # old codes (iw, ji, and in) and the new codes (he, yi, and id), but all other
    # API on Locale will return only the OLD codes.
    # @param language lowercase two-letter ISO-639 code.
    # @exception NullPointerException thrown if argument is null.
    # @since 1.4
    def initialize(language)
      initialize__locale(language, "", "")
    end
    
    typesig { [String, String, ::Java::Boolean] }
    # Constructs a <code>Locale</code> using <code>language</code>
    # and <code>country</code>.  This constructor assumes that
    # <code>language</code> and <code>contry</code> are interned and
    # it is invoked by createSingleton only. (flag is just for
    # avoiding the conflict with the public constructors.
    def initialize(language, country, flag)
      @language = nil
      @country = nil
      @variant = nil
      @hashcode = -1
      @hash_code_value = 0
      @language = language
      @country = country
      @variant = ""
    end
    
    class_module.module_eval {
      typesig { [String, String, String] }
      # Creates a <code>Locale</code> instance with the given
      # <code>language</code> and <code>counry</code> and puts the
      # instance under the given <code>key</code> in the cache. This
      # method must be called only when initializing the Locale
      # constants.
      def create_singleton(key, language, country)
        locale = Locale.new(language, country, false)
        Cache.put(key, locale)
        return locale
      end
      
      typesig { [String, String, String] }
      # Returns a <code>Locale</code> constructed from the given
      # <code>language</code>, <code>country</code> and
      # <code>variant</code>. If the same <code>Locale</code> instance
      # is available in the cache, then that instance is
      # returned. Otherwise, a new <code>Locale</code> instance is
      # created and cached.
      # 
      # @param language lowercase two-letter ISO-639 code.
      # @param country uppercase two-letter ISO-3166 code.
      # @param variant vendor and browser specific code. See class description.
      # @return the <code>Locale</code> instance requested
      # @exception NullPointerException if any argument is null.
      def get_instance(language, country, variant)
        if ((language).nil? || (country).nil? || (variant).nil?)
          raise NullPointerException.new
        end
        sb = StringBuilder.new
        sb.append(language).append(Character.new(?_.ord)).append(country).append(Character.new(?_.ord)).append(variant)
        key = sb.to_s
        locale = Cache.get(key)
        if ((locale).nil?)
          locale = Locale.new(language, country, variant)
          l = Cache.put_if_absent(key, locale)
          if (!(l).nil?)
            locale = l
          end
        end
        return locale
      end
      
      typesig { [] }
      # Gets the current value of the default locale for this instance
      # of the Java Virtual Machine.
      # <p>
      # The Java Virtual Machine sets the default locale during startup
      # based on the host environment. It is used by many locale-sensitive
      # methods if no locale is explicitly specified.
      # It can be changed using the
      # {@link #setDefault(java.util.Locale) setDefault} method.
      # 
      # @return the default locale for this instance of the Java Virtual Machine
      def get_default
        # do not synchronize this method - see 4071298
        # it's OK if more than one default locale happens to be created
        if ((self.attr_default_locale).nil?)
          language = nil
          region = nil
          country = nil
          variant = nil
          language = RJava.cast_to_string(AccessController.do_privileged(GetPropertyAction.new("user.language", "en")))
          # for compatibility, check for old user.region property
          region = RJava.cast_to_string(AccessController.do_privileged(GetPropertyAction.new("user.region")))
          if (!(region).nil?)
            # region can be of form country, country_variant, or _variant
            i = region.index_of(Character.new(?_.ord))
            if (i >= 0)
              country = RJava.cast_to_string(region.substring(0, i))
              variant = RJava.cast_to_string(region.substring(i + 1))
            else
              country = region
              variant = ""
            end
          else
            country = RJava.cast_to_string(AccessController.do_privileged(GetPropertyAction.new("user.country", "")))
            variant = RJava.cast_to_string(AccessController.do_privileged(GetPropertyAction.new("user.variant", "")))
          end
          self.attr_default_locale = get_instance(language, country, variant)
        end
        return self.attr_default_locale
      end
      
      typesig { [Locale] }
      # Sets the default locale for this instance of the Java Virtual Machine.
      # This does not affect the host locale.
      # <p>
      # If there is a security manager, its <code>checkPermission</code>
      # method is called with a <code>PropertyPermission("user.language", "write")</code>
      # permission before the default locale is changed.
      # <p>
      # The Java Virtual Machine sets the default locale during startup
      # based on the host environment. It is used by many locale-sensitive
      # methods if no locale is explicitly specified.
      # <p>
      # Since changing the default locale may affect many different areas
      # of functionality, this method should only be used if the caller
      # is prepared to reinitialize locale-sensitive code running
      # within the same Java Virtual Machine.
      # 
      # @throws SecurityException
      # if a security manager exists and its
      # <code>checkPermission</code> method doesn't allow the operation.
      # @throws NullPointerException if <code>newLocale</code> is null
      # @param newLocale the new default locale
      # @see SecurityManager#checkPermission
      # @see java.util.PropertyPermission
      def set_default(new_locale)
        synchronized(self) do
          if ((new_locale).nil?)
            raise NullPointerException.new("Can't set default locale to NULL")
          end
          sm = System.get_security_manager
          if (!(sm).nil?)
            sm.check_permission(PropertyPermission.new("user.language", "write"))
          end
          self.attr_default_locale = new_locale
        end
      end
      
      typesig { [] }
      # Returns an array of all installed locales.
      # The returned array represents the union of locales supported
      # by the Java runtime environment and by installed
      # {@link java.util.spi.LocaleServiceProvider LocaleServiceProvider}
      # implementations.  It must contain at least a <code>Locale</code>
      # instance equal to {@link java.util.Locale#US Locale.US}.
      # 
      # @return An array of installed locales.
      def get_available_locales
        return LocaleServiceProviderPool.get_all_available_locales
      end
      
      typesig { [] }
      # Returns a list of all 2-letter country codes defined in ISO 3166.
      # Can be used to create Locales.
      def get_isocountries
        if ((self.attr_iso_countries).nil?)
          self.attr_iso_countries = get_iso2table(LocaleISOData.attr_iso_country_table)
        end
        result = Array.typed(String).new(self.attr_iso_countries.attr_length) { nil }
        System.arraycopy(self.attr_iso_countries, 0, result, 0, self.attr_iso_countries.attr_length)
        return result
      end
      
      typesig { [] }
      # Returns a list of all 2-letter language codes defined in ISO 639.
      # Can be used to create Locales.
      # [NOTE:  ISO 639 is not a stable standard-- some languages' codes have changed.
      # The list this function returns includes both the new and the old codes for the
      # languages whose codes have changed.]
      def get_isolanguages
        if ((self.attr_iso_languages).nil?)
          self.attr_iso_languages = get_iso2table(LocaleISOData.attr_iso_language_table)
        end
        result = Array.typed(String).new(self.attr_iso_languages.attr_length) { nil }
        System.arraycopy(self.attr_iso_languages, 0, result, 0, self.attr_iso_languages.attr_length)
        return result
      end
      
      typesig { [String] }
      def get_iso2table(table)
        len = table.length / 5
        iso_table = Array.typed(String).new(len) { nil }
        i = 0
        j = 0
        while i < len
          iso_table[i] = table.substring(j, j + 2)
          i += 1
          j += 5
        end
        return iso_table
      end
    }
    
    typesig { [] }
    # Returns the language code for this locale, which will either be the empty string
    # or a lowercase ISO 639 code.
    # <p>NOTE:  ISO 639 is not a stable standard-- some languages' codes have changed.
    # Locale's constructor recognizes both the new and the old codes for the languages
    # whose codes have changed, but this function always returns the old code.  If you
    # want to check for a specific language whose code has changed, don't do <pre>
    # if (locale.getLanguage().equals("he"))
    # ...
    # </pre>Instead, do<pre>
    # if (locale.getLanguage().equals(new Locale("he", "", "").getLanguage()))
    # ...</pre>
    # @see #getDisplayLanguage
    def get_language
      return @language
    end
    
    typesig { [] }
    # Returns the country/region code for this locale, which will
    # either be the empty string or an uppercase ISO 3166 2-letter code.
    # @see #getDisplayCountry
    def get_country
      return @country
    end
    
    typesig { [] }
    # Returns the variant code for this locale.
    # @see #getDisplayVariant
    def get_variant
      return @variant
    end
    
    typesig { [] }
    # Getter for the programmatic name of the entire locale,
    # with the language, country and variant separated by underbars.
    # Language is always lower case, and country is always upper case.
    # If the language is missing, the string will begin with an underbar.
    # If both the language and country fields are missing, this function
    # will return the empty string, even if the variant field is filled in
    # (you can't have a locale with just a variant-- the variant must accompany
    # a valid language or country code).
    # Examples: "en", "de_DE", "_GB", "en_US_WIN", "de__POSIX", "fr__MAC"
    # @see #getDisplayName
    def to_s
      l = !(@language.length).equal?(0)
      c = !(@country.length).equal?(0)
      v = !(@variant.length).equal?(0)
      result = StringBuilder.new(@language)
      if (c || (l && v))
        result.append(Character.new(?_.ord)).append(@country) # This may just append '_'
      end
      if (v && (l || c))
        result.append(Character.new(?_.ord)).append(@variant)
      end
      return result.to_s
    end
    
    typesig { [] }
    # Returns a three-letter abbreviation for this locale's language.  If the locale
    # doesn't specify a language, this will be the empty string.  Otherwise, this will
    # be a lowercase ISO 639-2/T language code.
    # The ISO 639-2 language codes can be found on-line at
    # <a href="http://www.loc.gov/standards/iso639-2/englangn.html">
    # <code>http://www.loc.gov/standards/iso639-2/englangn.html</code>.</a>
    # @exception MissingResourceException Throws MissingResourceException if the
    # three-letter language abbreviation is not available for this locale.
    def get_iso3language
      language3 = get_iso3code(@language, LocaleISOData.attr_iso_language_table)
      if ((language3).nil?)
        raise MissingResourceException.new("Couldn't find 3-letter language code for " + @language, "FormatData_" + RJava.cast_to_string(to_s), "ShortLanguage")
      end
      return language3
    end
    
    typesig { [] }
    # Returns a three-letter abbreviation for this locale's country.  If the locale
    # doesn't specify a country, this will be the empty string.  Otherwise, this will
    # be an uppercase ISO 3166 3-letter country code.
    # The ISO 3166-2 country codes can be found on-line at
    # <a href="http://www.davros.org/misc/iso3166.txt">
    # <code>http://www.davros.org/misc/iso3166.txt</code>.</a>
    # @exception MissingResourceException Throws MissingResourceException if the
    # three-letter country abbreviation is not available for this locale.
    def get_iso3country
      country3 = get_iso3code(@country, LocaleISOData.attr_iso_country_table)
      if ((country3).nil?)
        raise MissingResourceException.new("Couldn't find 3-letter country code for " + @country, "FormatData_" + RJava.cast_to_string(to_s), "ShortCountry")
      end
      return country3
    end
    
    class_module.module_eval {
      typesig { [String, String] }
      def get_iso3code(iso2code, table)
        code_length = iso2code.length
        if ((code_length).equal?(0))
          return ""
        end
        table_length = table.length
        index = table_length
        if ((code_length).equal?(2))
          c1 = iso2code.char_at(0)
          c2 = iso2code.char_at(1)
          index = 0
          while index < table_length
            if ((table.char_at(index)).equal?(c1) && (table.char_at(index + 1)).equal?(c2))
              break
            end
            index += 5
          end
        end
        return index < table_length ? table.substring(index + 2, index + 5) : nil
      end
    }
    
    typesig { [] }
    # Returns a name for the locale's language that is appropriate for display to the
    # user.
    # If possible, the name returned will be localized for the default locale.
    # For example, if the locale is fr_FR and the default locale
    # is en_US, getDisplayLanguage() will return "French"; if the locale is en_US and
    # the default locale is fr_FR, getDisplayLanguage() will return "anglais".
    # If the name returned cannot be localized for the default locale,
    # (say, we don't have a Japanese name for Croatian),
    # this function falls back on the English name, and uses the ISO code as a last-resort
    # value.  If the locale doesn't specify a language, this function returns the empty string.
    def get_display_language
      return get_display_language(get_default)
    end
    
    typesig { [Locale] }
    # Returns a name for the locale's language that is appropriate for display to the
    # user.
    # If possible, the name returned will be localized according to inLocale.
    # For example, if the locale is fr_FR and inLocale
    # is en_US, getDisplayLanguage() will return "French"; if the locale is en_US and
    # inLocale is fr_FR, getDisplayLanguage() will return "anglais".
    # If the name returned cannot be localized according to inLocale,
    # (say, we don't have a Japanese name for Croatian),
    # this function falls back on the English name, and finally
    # on the ISO code as a last-resort value.  If the locale doesn't specify a language,
    # this function returns the empty string.
    # 
    # @exception NullPointerException if <code>inLocale</code> is <code>null</code>
    def get_display_language(in_locale)
      return get_display_string(@language, in_locale, DISPLAY_LANGUAGE)
    end
    
    typesig { [] }
    # Returns a name for the locale's country that is appropriate for display to the
    # user.
    # If possible, the name returned will be localized for the default locale.
    # For example, if the locale is fr_FR and the default locale
    # is en_US, getDisplayCountry() will return "France"; if the locale is en_US and
    # the default locale is fr_FR, getDisplayCountry() will return "Etats-Unis".
    # If the name returned cannot be localized for the default locale,
    # (say, we don't have a Japanese name for Croatia),
    # this function falls back on the English name, and uses the ISO code as a last-resort
    # value.  If the locale doesn't specify a country, this function returns the empty string.
    def get_display_country
      return get_display_country(get_default)
    end
    
    typesig { [Locale] }
    # Returns a name for the locale's country that is appropriate for display to the
    # user.
    # If possible, the name returned will be localized according to inLocale.
    # For example, if the locale is fr_FR and inLocale
    # is en_US, getDisplayCountry() will return "France"; if the locale is en_US and
    # inLocale is fr_FR, getDisplayCountry() will return "Etats-Unis".
    # If the name returned cannot be localized according to inLocale.
    # (say, we don't have a Japanese name for Croatia),
    # this function falls back on the English name, and finally
    # on the ISO code as a last-resort value.  If the locale doesn't specify a country,
    # this function returns the empty string.
    # 
    # @exception NullPointerException if <code>inLocale</code> is <code>null</code>
    def get_display_country(in_locale)
      return get_display_string(@country, in_locale, DISPLAY_COUNTRY)
    end
    
    typesig { [String, Locale, ::Java::Int] }
    def get_display_string(code, in_locale, type)
      if ((code.length).equal?(0))
        return ""
      end
      if ((in_locale).nil?)
        raise NullPointerException.new
      end
      begin
        bundle = LocaleData.get_locale_names(in_locale)
        key = ((type).equal?(DISPLAY_VARIANT) ? "%%" + code : code)
        result = nil
        # Check whether a provider can provide an implementation that's closer
        # to the requested locale than what the Java runtime itself can provide.
        pool = LocaleServiceProviderPool.get_pool(LocaleNameProvider)
        if (pool.has_providers)
          result = RJava.cast_to_string(pool.get_localized_object(LocaleNameGetter::INSTANCE, in_locale, bundle, key, type, code))
        end
        if ((result).nil?)
          result = RJava.cast_to_string(bundle.get_string(key))
        end
        if (!(result).nil?)
          return result
        end
      rescue JavaException => e
        # just fall through
      end
      return code
    end
    
    typesig { [] }
    # Returns a name for the locale's variant code that is appropriate for display to the
    # user.  If possible, the name will be localized for the default locale.  If the locale
    # doesn't specify a variant code, this function returns the empty string.
    def get_display_variant
      return get_display_variant(get_default)
    end
    
    typesig { [Locale] }
    # Returns a name for the locale's variant code that is appropriate for display to the
    # user.  If possible, the name will be localized for inLocale.  If the locale
    # doesn't specify a variant code, this function returns the empty string.
    # 
    # @exception NullPointerException if <code>inLocale</code> is <code>null</code>
    def get_display_variant(in_locale)
      if ((@variant.length).equal?(0))
        return ""
      end
      bundle = LocaleData.get_locale_names(in_locale)
      names = get_display_variant_array(bundle, in_locale)
      # Get the localized patterns for formatting a list, and use
      # them to format the list.
      list_pattern = nil
      list_composition_pattern = nil
      begin
        list_pattern = RJava.cast_to_string(bundle.get_string("ListPattern"))
        list_composition_pattern = RJava.cast_to_string(bundle.get_string("ListCompositionPattern"))
      rescue MissingResourceException => e
      end
      return format_list(names, list_pattern, list_composition_pattern)
    end
    
    typesig { [] }
    # Returns a name for the locale that is appropriate for display to the
    # user.  This will be the values returned by getDisplayLanguage(), getDisplayCountry(),
    # and getDisplayVariant() assembled into a single string.  The display name will have
    # one of the following forms:<p><blockquote>
    # language (country, variant)<p>
    # language (country)<p>
    # language (variant)<p>
    # country (variant)<p>
    # language<p>
    # country<p>
    # variant<p></blockquote>
    # depending on which fields are specified in the locale.  If the language, country,
    # and variant fields are all empty, this function returns the empty string.
    def get_display_name
      return get_display_name(get_default)
    end
    
    typesig { [Locale] }
    # Returns a name for the locale that is appropriate for display to the
    # user.  This will be the values returned by getDisplayLanguage(), getDisplayCountry(),
    # and getDisplayVariant() assembled into a single string.  The display name will have
    # one of the following forms:<p><blockquote>
    # language (country, variant)<p>
    # language (country)<p>
    # language (variant)<p>
    # country (variant)<p>
    # language<p>
    # country<p>
    # variant<p></blockquote>
    # depending on which fields are specified in the locale.  If the language, country,
    # and variant fields are all empty, this function returns the empty string.
    # 
    # @exception NullPointerException if <code>inLocale</code> is <code>null</code>
    def get_display_name(in_locale)
      bundle = LocaleData.get_locale_names(in_locale)
      language_name = get_display_language(in_locale)
      country_name = get_display_country(in_locale)
      variant_names = get_display_variant_array(bundle, in_locale)
      # Get the localized patterns for formatting a display name.
      display_name_pattern = nil
      list_pattern = nil
      list_composition_pattern = nil
      begin
        display_name_pattern = RJava.cast_to_string(bundle.get_string("DisplayNamePattern"))
        list_pattern = RJava.cast_to_string(bundle.get_string("ListPattern"))
        list_composition_pattern = RJava.cast_to_string(bundle.get_string("ListCompositionPattern"))
      rescue MissingResourceException => e
      end
      # The display name consists of a main name, followed by qualifiers.
      # Typically, the format is "MainName (Qualifier, Qualifier)" but this
      # depends on what pattern is stored in the display locale.
      main_name = nil
      qualifier_names = nil
      # The main name is the language, or if there is no language, the country.
      # If there is neither language nor country (an anomalous situation) then
      # the display name is simply the variant's display name.
      if (!(language_name.length).equal?(0))
        main_name = language_name
        if (!(country_name.length).equal?(0))
          qualifier_names = Array.typed(String).new(variant_names.attr_length + 1) { nil }
          System.arraycopy(variant_names, 0, qualifier_names, 1, variant_names.attr_length)
          qualifier_names[0] = country_name
        else
          qualifier_names = variant_names
        end
      else
        if (!(country_name.length).equal?(0))
          main_name = country_name
          qualifier_names = variant_names
        else
          return format_list(variant_names, list_pattern, list_composition_pattern)
        end
      end
      # Create an array whose first element is the number of remaining
      # elements.  This serves as a selector into a ChoiceFormat pattern from
      # the resource.  The second and third elements are the main name and
      # the qualifier; if there are no qualifiers, the third element is
      # unused by the format pattern.
      # We could also just call formatList() and have it handle the empty
      # list case, but this is more efficient, and we want it to be
      # efficient since all the language-only locales will not have any
      # qualifiers.
      display_names = Array.typed(Object).new([!(qualifier_names.attr_length).equal?(0) ? 2 : 1, main_name, !(qualifier_names.attr_length).equal?(0) ? format_list(qualifier_names, list_pattern, list_composition_pattern) : nil])
      if (!(display_name_pattern).nil?)
        return MessageFormat.new(display_name_pattern).format(display_names)
      else
        # If we cannot get the message format pattern, then we use a simple
        # hard-coded pattern.  This should not occur in practice unless the
        # installation is missing some core files (FormatData etc.).
        result = StringBuilder.new
        result.append(display_names[1])
        if (display_names.attr_length > 2)
          result.append(" (")
          result.append(display_names[2])
          result.append(Character.new(?).ord))
        end
        return result.to_s
      end
    end
    
    typesig { [] }
    # Overrides Cloneable
    def clone
      begin
        that = super
        return that
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
    end
    
    typesig { [] }
    # Override hashCode.
    # Since Locales are often used in hashtables, caches the value
    # for speed.
    def hash_code
      hc = @hash_code_value
      if ((hc).equal?(0))
        hc = (@language.hash_code << 8) ^ @country.hash_code ^ (@variant.hash_code << 4)
        @hash_code_value = hc
      end
      return hc
    end
    
    typesig { [Object] }
    # Overrides
    # 
    # Returns true if this Locale is equal to another object.  A Locale is
    # deemed equal to another Locale with identical language, country,
    # and variant, and unequal to all other objects.
    # 
    # @return true if this Locale is equal to the specified object.
    def ==(obj)
      if ((self).equal?(obj))
        # quick check
        return true
      end
      if (!(obj.is_a?(Locale)))
        return false
      end
      other = obj
      return (@language).equal?(other.attr_language) && (@country).equal?(other.attr_country) && (@variant).equal?(other.attr_variant)
    end
    
    # ================= privates =====================================
    # XXX instance and class variables. For now keep these separate, since it is
    # faster to match. Later, make into single string.
    # 
    # @serial
    # @see #getLanguage
    attr_accessor :language
    alias_method :attr_language, :language
    undef_method :language
    alias_method :attr_language=, :language=
    undef_method :language=
    
    # @serial
    # @see #getCountry
    attr_accessor :country
    alias_method :attr_country, :country
    undef_method :country
    alias_method :attr_country=, :country=
    undef_method :country=
    
    # @serial
    # @see #getVariant
    attr_accessor :variant
    alias_method :attr_variant, :variant
    undef_method :variant
    alias_method :attr_variant=, :variant=
    undef_method :variant=
    
    # Placeholder for the object's hash code.  Always -1.
    # @serial
    attr_accessor :hashcode
    alias_method :attr_hashcode, :hashcode
    undef_method :hashcode
    alias_method :attr_hashcode=, :hashcode=
    undef_method :hashcode=
    
    # lazy evaluate
    # 
    # Calculated hashcode to fix 4518797.
    attr_accessor :hash_code_value
    alias_method :attr_hash_code_value, :hash_code_value
    undef_method :hash_code_value
    alias_method :attr_hash_code_value=, :hash_code_value=
    undef_method :hash_code_value=
    
    class_module.module_eval {
      
      def default_locale
        defined?(@@default_locale) ? @@default_locale : @@default_locale= nil
      end
      alias_method :attr_default_locale, :default_locale
      
      def default_locale=(value)
        @@default_locale = value
      end
      alias_method :attr_default_locale=, :default_locale=
    }
    
    typesig { [OpenListResourceBundle, Locale] }
    # Return an array of the display names of the variant.
    # @param bundle the ResourceBundle to use to get the display names
    # @return an array of display names, possible of zero length.
    def get_display_variant_array(bundle, in_locale)
      # Split the variant name into tokens separated by '_'.
      tokenizer = StringTokenizer.new(@variant, "_")
      names = Array.typed(String).new(tokenizer.count_tokens) { nil }
      # For each variant token, lookup the display name.  If
      # not found, use the variant name itself.
      i = 0
      while i < names.attr_length
        names[i] = get_display_string(tokenizer.next_token, in_locale, DISPLAY_VARIANT)
        (i += 1)
      end
      return names
    end
    
    class_module.module_eval {
      typesig { [Array.typed(String), String, String] }
      # Format a list using given pattern strings.
      # If either of the patterns is null, then a the list is
      # formatted by concatenation with the delimiter ','.
      # @param stringList the list of strings to be formatted.
      # @param listPattern should create a MessageFormat taking 0-3 arguments
      # and formatting them into a list.
      # @param listCompositionPattern should take 2 arguments
      # and is used by composeList.
      # @return a string representing the list.
      def format_list(string_list, list_pattern, list_composition_pattern)
        # If we have no list patterns, compose the list in a simple,
        # non-localized way.
        if ((list_pattern).nil? || (list_composition_pattern).nil?)
          result = StringBuffer.new
          i = 0
          while i < string_list.attr_length
            if (i > 0)
              result.append(Character.new(?,.ord))
            end
            result.append(string_list[i])
            (i += 1)
          end
          return result.to_s
        end
        # Compose the list down to three elements if necessary
        if (string_list.attr_length > 3)
          format = MessageFormat.new(list_composition_pattern)
          string_list = compose_list(format, string_list)
        end
        # Rebuild the argument list with the list length as the first element
        args = Array.typed(Object).new(string_list.attr_length + 1) { nil }
        System.arraycopy(string_list, 0, args, 1, string_list.attr_length)
        args[0] = string_list.attr_length
        # Format it using the pattern in the resource
        format = MessageFormat.new(list_pattern)
        return format.format(args)
      end
      
      typesig { [MessageFormat, Array.typed(String)] }
      # Given a list of strings, return a list shortened to three elements.
      # Shorten it by applying the given format to the first two elements
      # recursively.
      # @param format a format which takes two arguments
      # @param list a list of strings
      # @return if the list is three elements or shorter, the same list;
      # otherwise, a new list of three elements.
      def compose_list(format_, list)
        if (list.attr_length <= 3)
          return list
        end
        # Use the given format to compose the first two elements into one
        list_items = Array.typed(String).new([list[0], list[1]])
        new_item = format_.format(list_items)
        # Form a new list one element shorter
        new_list = Array.typed(String).new(list.attr_length - 1) { nil }
        System.arraycopy(list, 2, new_list, 1, new_list.attr_length - 1)
        new_list[0] = new_item
        # Recurse
        return compose_list(format_, new_list)
      end
    }
    
    typesig { [] }
    # Replace the deserialized Locale object with a newly
    # created object. Newer language codes are replaced with older ISO
    # codes. The country and variant codes are replaced with internalized
    # String copies.
    def read_resolve
      return get_instance(@language, @country, @variant)
    end
    
    class_module.module_eval {
      
      def iso_languages
        defined?(@@iso_languages) ? @@iso_languages : @@iso_languages= nil
      end
      alias_method :attr_iso_languages, :iso_languages
      
      def iso_languages=(value)
        @@iso_languages = value
      end
      alias_method :attr_iso_languages=, :iso_languages=
      
      
      def iso_countries
        defined?(@@iso_countries) ? @@iso_countries : @@iso_countries= nil
      end
      alias_method :attr_iso_countries, :iso_countries
      
      def iso_countries=(value)
        @@iso_countries = value
      end
      alias_method :attr_iso_countries=, :iso_countries=
    }
    
    typesig { [String] }
    # Locale needs its own, locale insensitive version of toLowerCase to
    # avoid circularity problems between Locale and String.
    # The most straightforward algorithm is used. Look at optimizations later.
    def to_lower_case(str)
      buf = CharArray.new(str.length)
      i = 0
      while i < buf.attr_length
        buf[i] = Character.to_lower_case(str.char_at(i))
        i += 1
      end
      return String.new(buf)
    end
    
    typesig { [String] }
    # Locale needs its own, locale insensitive version of toUpperCase to
    # avoid circularity problems between Locale and String.
    # The most straightforward algorithm is used. Look at optimizations later.
    def to_upper_case(str)
      buf = CharArray.new(str.length)
      i = 0
      while i < buf.attr_length
        buf[i] = Character.to_upper_case(str.char_at(i))
        i += 1
      end
      return String.new(buf)
    end
    
    typesig { [String] }
    def convert_old_isocodes(language)
      # we accept both the old and the new ISO codes for the languages whose ISO
      # codes have changed, but we always store the OLD code, for backward compatibility
      language = RJava.cast_to_string(to_lower_case(language).intern)
      if ((language).equal?("he"))
        return "iw"
      else
        if ((language).equal?("yi"))
          return "ji"
        else
          if ((language).equal?("id"))
            return "in"
          else
            return language
          end
        end
      end
    end
    
    class_module.module_eval {
      # Obtains a localized locale names from a LocaleNameProvider
      # implementation.
      const_set_lazy(:LocaleNameGetter) { Class.new do
        include_class_members Locale
        include LocaleServiceProviderPool::LocalizedObjectGetter
        
        class_module.module_eval {
          const_set_lazy(:INSTANCE) { LocaleNameGetter.new }
          const_attr_reader  :INSTANCE
        }
        
        typesig { [LocaleNameProvider, Locale, String, Object] }
        def get_object(locale_name_provider, locale, key, *params)
          raise AssertError if not ((params.attr_length).equal?(2))
          type = params[0]
          code = params[1]
          case (type)
          when DISPLAY_LANGUAGE
            return locale_name_provider.get_display_language(code, locale)
          when DISPLAY_COUNTRY
            return locale_name_provider.get_display_country(code, locale)
          when DISPLAY_VARIANT
            return locale_name_provider.get_display_variant(code, locale)
          else
            raise AssertError if not (false)
          end # shouldn't happen
          return nil
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__locale_name_getter, :initialize
      end }
    }
    
    private
    alias_method :initialize__locale, :initialize
  end
  
end
