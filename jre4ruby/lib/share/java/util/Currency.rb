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
module Java::Util
  module CurrencyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Io, :BufferedInputStream
      include_const ::Java::Io, :DataInputStream
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :FileInputStream
      include_const ::Java::Io, :FileReader
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :Serializable
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Util::Logging, :Level
      include_const ::Java::Util::Logging, :Logger
      include_const ::Java::Util::Regex, :Pattern
      include_const ::Java::Util::Regex, :Matcher
      include_const ::Java::Util::Spi, :CurrencyNameProvider
      include_const ::Java::Util::Spi, :LocaleServiceProvider
      include_const ::Sun::Util, :LocaleServiceProviderPool
      include_const ::Sun::Util::Resources, :LocaleData
      include_const ::Sun::Util::Resources, :OpenListResourceBundle
    }
  end
  
  # Represents a currency. Currencies are identified by their ISO 4217 currency
  # codes. Visit the <a href="http://www.bsi-global.com/">
  # BSi web site</a> for more information, including a table of
  # currency codes.
  # <p>
  # The class is designed so that there's never more than one
  # <code>Currency</code> instance for any given currency. Therefore, there's
  # no public constructor. You obtain a <code>Currency</code> instance using
  # the <code>getInstance</code> methods.
  # 
  # @since 1.4
  class Currency 
    include_class_members CurrencyImports
    include Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -158308464356906721 }
      const_attr_reader  :SerialVersionUID
    }
    
    # ISO 4217 currency code for this currency.
    # 
    # @serial
    attr_accessor :currency_code
    alias_method :attr_currency_code, :currency_code
    undef_method :currency_code
    alias_method :attr_currency_code=, :currency_code=
    undef_method :currency_code=
    
    # Default fraction digits for this currency.
    # Set from currency data tables.
    attr_accessor :default_fraction_digits
    alias_method :attr_default_fraction_digits, :default_fraction_digits
    undef_method :default_fraction_digits
    alias_method :attr_default_fraction_digits=, :default_fraction_digits=
    undef_method :default_fraction_digits=
    
    # ISO 4217 numeric code for this currency.
    # Set from currency data tables.
    attr_accessor :numeric_code
    alias_method :attr_numeric_code, :numeric_code
    undef_method :numeric_code
    alias_method :attr_numeric_code=, :numeric_code=
    undef_method :numeric_code=
    
    class_module.module_eval {
      # class data: instance map
      
      def instances
        defined?(@@instances) ? @@instances : @@instances= HashMap.new(7)
      end
      alias_method :attr_instances, :instances
      
      def instances=(value)
        @@instances = value
      end
      alias_method :attr_instances=, :instances=
      
      
      def available
        defined?(@@available) ? @@available : @@available= nil
      end
      alias_method :attr_available, :available
      
      def available=(value)
        @@available = value
      end
      alias_method :attr_available=, :available=
      
      # Class data: currency data obtained from currency.data file.
      # Purpose:
      # - determine valid country codes
      # - determine valid currency codes
      # - map country codes to currency codes
      # - obtain default fraction digits for currency codes
      # 
      # sc = special case; dfd = default fraction digits
      # Simple countries are those where the country code is a prefix of the
      # currency code, and there are no known plans to change the currency.
      # 
      # table formats:
      # - mainTable:
      # - maps country code to 32-bit int
      # - 26*26 entries, corresponding to [A-Z]*[A-Z]
      # - \u007F -> not valid country
      # - bits 18-31: unused
      # - bits 8-17: numeric code (0 to 1023)
      # - bit 7: 1 - special case, bits 0-4 indicate which one
      # 0 - simple country, bits 0-4 indicate final char of currency code
      # - bits 5-6: fraction digits for simple countries, 0 for special cases
      # - bits 0-4: final char for currency code for simple country, or ID of special case
      # - special case IDs:
      # - 0: country has no currency
      # - other: index into sc* arrays + 1
      # - scCutOverTimes: cut-over time in millis as returned by
      # System.currentTimeMillis for special case countries that are changing
      # currencies; Long.MAX_VALUE for countries that are not changing currencies
      # - scOldCurrencies: old currencies for special case countries
      # - scNewCurrencies: new currencies for special case countries that are
      # changing currencies; null for others
      # - scOldCurrenciesDFD: default fraction digits for old currencies
      # - scNewCurrenciesDFD: default fraction digits for new currencies, 0 for
      # countries that are not changing currencies
      # - otherCurrencies: concatenation of all currency codes that are not the
      # main currency of a simple country, separated by "-"
      # - otherCurrenciesDFD: decimal format digits for currencies in otherCurrencies, same order
      
      def format_version
        defined?(@@format_version) ? @@format_version : @@format_version= 0
      end
      alias_method :attr_format_version, :format_version
      
      def format_version=(value)
        @@format_version = value
      end
      alias_method :attr_format_version=, :format_version=
      
      
      def data_version
        defined?(@@data_version) ? @@data_version : @@data_version= 0
      end
      alias_method :attr_data_version, :data_version
      
      def data_version=(value)
        @@data_version = value
      end
      alias_method :attr_data_version=, :data_version=
      
      
      def main_table
        defined?(@@main_table) ? @@main_table : @@main_table= nil
      end
      alias_method :attr_main_table, :main_table
      
      def main_table=(value)
        @@main_table = value
      end
      alias_method :attr_main_table=, :main_table=
      
      
      def sc_cut_over_times
        defined?(@@sc_cut_over_times) ? @@sc_cut_over_times : @@sc_cut_over_times= nil
      end
      alias_method :attr_sc_cut_over_times, :sc_cut_over_times
      
      def sc_cut_over_times=(value)
        @@sc_cut_over_times = value
      end
      alias_method :attr_sc_cut_over_times=, :sc_cut_over_times=
      
      
      def sc_old_currencies
        defined?(@@sc_old_currencies) ? @@sc_old_currencies : @@sc_old_currencies= nil
      end
      alias_method :attr_sc_old_currencies, :sc_old_currencies
      
      def sc_old_currencies=(value)
        @@sc_old_currencies = value
      end
      alias_method :attr_sc_old_currencies=, :sc_old_currencies=
      
      
      def sc_new_currencies
        defined?(@@sc_new_currencies) ? @@sc_new_currencies : @@sc_new_currencies= nil
      end
      alias_method :attr_sc_new_currencies, :sc_new_currencies
      
      def sc_new_currencies=(value)
        @@sc_new_currencies = value
      end
      alias_method :attr_sc_new_currencies=, :sc_new_currencies=
      
      
      def sc_old_currencies_dfd
        defined?(@@sc_old_currencies_dfd) ? @@sc_old_currencies_dfd : @@sc_old_currencies_dfd= nil
      end
      alias_method :attr_sc_old_currencies_dfd, :sc_old_currencies_dfd
      
      def sc_old_currencies_dfd=(value)
        @@sc_old_currencies_dfd = value
      end
      alias_method :attr_sc_old_currencies_dfd=, :sc_old_currencies_dfd=
      
      
      def sc_new_currencies_dfd
        defined?(@@sc_new_currencies_dfd) ? @@sc_new_currencies_dfd : @@sc_new_currencies_dfd= nil
      end
      alias_method :attr_sc_new_currencies_dfd, :sc_new_currencies_dfd
      
      def sc_new_currencies_dfd=(value)
        @@sc_new_currencies_dfd = value
      end
      alias_method :attr_sc_new_currencies_dfd=, :sc_new_currencies_dfd=
      
      
      def sc_old_currencies_numeric_code
        defined?(@@sc_old_currencies_numeric_code) ? @@sc_old_currencies_numeric_code : @@sc_old_currencies_numeric_code= nil
      end
      alias_method :attr_sc_old_currencies_numeric_code, :sc_old_currencies_numeric_code
      
      def sc_old_currencies_numeric_code=(value)
        @@sc_old_currencies_numeric_code = value
      end
      alias_method :attr_sc_old_currencies_numeric_code=, :sc_old_currencies_numeric_code=
      
      
      def sc_new_currencies_numeric_code
        defined?(@@sc_new_currencies_numeric_code) ? @@sc_new_currencies_numeric_code : @@sc_new_currencies_numeric_code= nil
      end
      alias_method :attr_sc_new_currencies_numeric_code, :sc_new_currencies_numeric_code
      
      def sc_new_currencies_numeric_code=(value)
        @@sc_new_currencies_numeric_code = value
      end
      alias_method :attr_sc_new_currencies_numeric_code=, :sc_new_currencies_numeric_code=
      
      
      def other_currencies
        defined?(@@other_currencies) ? @@other_currencies : @@other_currencies= nil
      end
      alias_method :attr_other_currencies, :other_currencies
      
      def other_currencies=(value)
        @@other_currencies = value
      end
      alias_method :attr_other_currencies=, :other_currencies=
      
      
      def other_currencies_dfd
        defined?(@@other_currencies_dfd) ? @@other_currencies_dfd : @@other_currencies_dfd= nil
      end
      alias_method :attr_other_currencies_dfd, :other_currencies_dfd
      
      def other_currencies_dfd=(value)
        @@other_currencies_dfd = value
      end
      alias_method :attr_other_currencies_dfd=, :other_currencies_dfd=
      
      
      def other_currencies_numeric_code
        defined?(@@other_currencies_numeric_code) ? @@other_currencies_numeric_code : @@other_currencies_numeric_code= nil
      end
      alias_method :attr_other_currencies_numeric_code, :other_currencies_numeric_code
      
      def other_currencies_numeric_code=(value)
        @@other_currencies_numeric_code = value
      end
      alias_method :attr_other_currencies_numeric_code=, :other_currencies_numeric_code=
      
      # handy constants - must match definitions in GenerateCurrencyData
      # magic number
      const_set_lazy(:MAGIC_NUMBER) { 0x43757244 }
      const_attr_reader  :MAGIC_NUMBER
      
      # number of characters from A to Z
      const_set_lazy(:A_TO_Z) { (Character.new(?Z.ord) - Character.new(?A.ord)) + 1 }
      const_attr_reader  :A_TO_Z
      
      # entry for invalid country codes
      const_set_lazy(:INVALID_COUNTRY_ENTRY) { 0x7f }
      const_attr_reader  :INVALID_COUNTRY_ENTRY
      
      # entry for countries without currency
      const_set_lazy(:COUNTRY_WITHOUT_CURRENCY_ENTRY) { 0x80 }
      const_attr_reader  :COUNTRY_WITHOUT_CURRENCY_ENTRY
      
      # mask for simple case country entries
      const_set_lazy(:SIMPLE_CASE_COUNTRY_MASK) { 0x0 }
      const_attr_reader  :SIMPLE_CASE_COUNTRY_MASK
      
      # mask for simple case country entry final character
      const_set_lazy(:SIMPLE_CASE_COUNTRY_FINAL_CHAR_MASK) { 0x1f }
      const_attr_reader  :SIMPLE_CASE_COUNTRY_FINAL_CHAR_MASK
      
      # mask for simple case country entry default currency digits
      const_set_lazy(:SIMPLE_CASE_COUNTRY_DEFAULT_DIGITS_MASK) { 0x60 }
      const_attr_reader  :SIMPLE_CASE_COUNTRY_DEFAULT_DIGITS_MASK
      
      # shift count for simple case country entry default currency digits
      const_set_lazy(:SIMPLE_CASE_COUNTRY_DEFAULT_DIGITS_SHIFT) { 5 }
      const_attr_reader  :SIMPLE_CASE_COUNTRY_DEFAULT_DIGITS_SHIFT
      
      # mask for special case country entries
      const_set_lazy(:SPECIAL_CASE_COUNTRY_MASK) { 0x80 }
      const_attr_reader  :SPECIAL_CASE_COUNTRY_MASK
      
      # mask for special case country index
      const_set_lazy(:SPECIAL_CASE_COUNTRY_INDEX_MASK) { 0x1f }
      const_attr_reader  :SPECIAL_CASE_COUNTRY_INDEX_MASK
      
      # delta from entry index component in main table to index into special case tables
      const_set_lazy(:SPECIAL_CASE_COUNTRY_INDEX_DELTA) { 1 }
      const_attr_reader  :SPECIAL_CASE_COUNTRY_INDEX_DELTA
      
      # mask for distinguishing simple and special case countries
      const_set_lazy(:COUNTRY_TYPE_MASK) { SIMPLE_CASE_COUNTRY_MASK | SPECIAL_CASE_COUNTRY_MASK }
      const_attr_reader  :COUNTRY_TYPE_MASK
      
      # mask for the numeric code of the currency
      const_set_lazy(:NUMERIC_CODE_MASK) { 0x3ff00 }
      const_attr_reader  :NUMERIC_CODE_MASK
      
      # shift count for the numeric code of the currency
      const_set_lazy(:NUMERIC_CODE_SHIFT) { 8 }
      const_attr_reader  :NUMERIC_CODE_SHIFT
      
      # Currency data format version
      const_set_lazy(:VALID_FORMAT_VERSION) { 1 }
      const_attr_reader  :VALID_FORMAT_VERSION
      
      when_class_loaded do
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members Currency
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            home_dir = System.get_property("java.home")
            begin
              data_file = home_dir + RJava.cast_to_string(JavaFile.attr_separator) + "lib" + RJava.cast_to_string(JavaFile.attr_separator) + "currency.data"
              dis = self.class::DataInputStream.new(self.class::BufferedInputStream.new(self.class::FileInputStream.new(data_file)))
              if (!(dis.read_int).equal?(MAGIC_NUMBER))
                raise self.class::InternalError.new("Currency data is possibly corrupted")
              end
              self.attr_format_version = dis.read_int
              if (!(self.attr_format_version).equal?(VALID_FORMAT_VERSION))
                raise self.class::InternalError.new("Currency data format is incorrect")
              end
              self.attr_data_version = dis.read_int
              self.attr_main_table = read_int_array(dis, A_TO_Z * A_TO_Z)
              sc_count = dis.read_int
              self.attr_sc_cut_over_times = read_long_array(dis, sc_count)
              self.attr_sc_old_currencies = read_string_array(dis, sc_count)
              self.attr_sc_new_currencies = read_string_array(dis, sc_count)
              self.attr_sc_old_currencies_dfd = read_int_array(dis, sc_count)
              self.attr_sc_new_currencies_dfd = read_int_array(dis, sc_count)
              self.attr_sc_old_currencies_numeric_code = read_int_array(dis, sc_count)
              self.attr_sc_new_currencies_numeric_code = read_int_array(dis, sc_count)
              oc_count = dis.read_int
              self.attr_other_currencies = RJava.cast_to_string(dis.read_utf)
              self.attr_other_currencies_dfd = read_int_array(dis, oc_count)
              self.attr_other_currencies_numeric_code = read_int_array(dis, oc_count)
              dis.close
            rescue self.class::IOException => e
              ie = self.class::InternalError.new
              ie.init_cause(e)
              raise ie
            end
            if (false)
              # look for the properties file for overrides
              begin
                prop_file = self.class::JavaFile.new(home_dir + RJava.cast_to_string(JavaFile.attr_separator) + "lib" + RJava.cast_to_string(JavaFile.attr_separator) + "currency.properties")
                if (prop_file.exists)
                  props = self.class::Properties.new
                  props.load(self.class::FileReader.new(prop_file))
                  keys = props.string_property_names
                  properties_pattern = Pattern.compile("([A-Z]{3})\\s*,\\s*(\\d{3})\\s*,\\s*([0-3])")
                  keys.each do |key|
                    replace_currency_data(properties_pattern, key.to_upper_case(Locale::ROOT), props.get_property(key).to_upper_case(Locale::ROOT))
                  end
                end
              rescue self.class::IOException => e
                log(Level::INFO, "currency.properties is ignored because of an IOException", e)
              end
            end
            return nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      # Constants for retrieving localized names from the name providers.
      const_set_lazy(:SYMBOL) { 0 }
      const_attr_reader  :SYMBOL
      
      const_set_lazy(:DISPLAYNAME) { 1 }
      const_attr_reader  :DISPLAYNAME
    }
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # Constructs a <code>Currency</code> instance. The constructor is private
    # so that we can insure that there's never more than one instance for a
    # given currency.
    def initialize(currency_code, default_fraction_digits, numeric_code)
      @currency_code = nil
      @default_fraction_digits = 0
      @numeric_code = 0
      @currency_code = currency_code
      @default_fraction_digits = default_fraction_digits
      @numeric_code = numeric_code
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Returns the <code>Currency</code> instance for the given currency code.
      # 
      # @param currencyCode the ISO 4217 code of the currency
      # @return the <code>Currency</code> instance for the given currency code
      # @exception NullPointerException if <code>currencyCode</code> is null
      # @exception IllegalArgumentException if <code>currencyCode</code> is not
      # a supported ISO 4217 code.
      def get_instance(currency_code)
        return get_instance(currency_code, JavaInteger::MIN_VALUE, 0)
      end
      
      typesig { [String, ::Java::Int, ::Java::Int] }
      def get_instance(currency_code, default_fraction_digits, numeric_code)
        synchronized((self.attr_instances)) do
          # Try to look up the currency code in the instances table.
          # This does the null pointer check as a side effect.
          # Also, if there already is an entry, the currencyCode must be valid.
          instance = self.attr_instances.get(currency_code)
          if (!(instance).nil?)
            return instance
          end
          if ((default_fraction_digits).equal?(JavaInteger::MIN_VALUE))
            # Currency code not internally generated, need to verify first
            # A currency code must have 3 characters and exist in the main table
            # or in the list of other currencies.
            if (!(currency_code.length).equal?(3))
              raise IllegalArgumentException.new
            end
            char1 = currency_code.char_at(0)
            char2 = currency_code.char_at(1)
            table_entry = get_main_table_entry(char1, char2)
            if (((table_entry & COUNTRY_TYPE_MASK)).equal?(SIMPLE_CASE_COUNTRY_MASK) && !(table_entry).equal?(INVALID_COUNTRY_ENTRY) && (currency_code.char_at(2) - Character.new(?A.ord)).equal?((table_entry & SIMPLE_CASE_COUNTRY_FINAL_CHAR_MASK)))
              default_fraction_digits = (table_entry & SIMPLE_CASE_COUNTRY_DEFAULT_DIGITS_MASK) >> SIMPLE_CASE_COUNTRY_DEFAULT_DIGITS_SHIFT
              numeric_code = (table_entry & NUMERIC_CODE_MASK) >> NUMERIC_CODE_SHIFT
            else
              # Check for '-' separately so we don't get false hits in the table.
              if ((currency_code.char_at(2)).equal?(Character.new(?-.ord)))
                raise IllegalArgumentException.new
              end
              index = self.attr_other_currencies.index_of(currency_code)
              if ((index).equal?(-1))
                raise IllegalArgumentException.new
              end
              default_fraction_digits = self.attr_other_currencies_dfd[index / 4]
              numeric_code = self.attr_other_currencies_numeric_code[index / 4]
            end
          end
          instance = Currency.new(currency_code, default_fraction_digits, numeric_code)
          self.attr_instances.put(currency_code, instance)
          return instance
        end
      end
      
      typesig { [Locale] }
      # Returns the <code>Currency</code> instance for the country of the
      # given locale. The language and variant components of the locale
      # are ignored. The result may vary over time, as countries change their
      # currencies. For example, for the original member countries of the
      # European Monetary Union, the method returns the old national currencies
      # until December 31, 2001, and the Euro from January 1, 2002, local time
      # of the respective countries.
      # <p>
      # The method returns <code>null</code> for territories that don't
      # have a currency, such as Antarctica.
      # 
      # @param locale the locale for whose country a <code>Currency</code>
      # instance is needed
      # @return the <code>Currency</code> instance for the country of the given
      # locale, or null
      # @exception NullPointerException if <code>locale</code> or its country
      # code is null
      # @exception IllegalArgumentException if the country of the given locale
      # is not a supported ISO 3166 country code.
      def get_instance(locale)
        country = locale.get_country
        if ((country).nil?)
          raise NullPointerException.new
        end
        if (!(country.length).equal?(2))
          raise IllegalArgumentException.new
        end
        char1 = country.char_at(0)
        char2 = country.char_at(1)
        table_entry = get_main_table_entry(char1, char2)
        if (((table_entry & COUNTRY_TYPE_MASK)).equal?(SIMPLE_CASE_COUNTRY_MASK) && !(table_entry).equal?(INVALID_COUNTRY_ENTRY))
          final_char = RJava.cast_to_char(((table_entry & SIMPLE_CASE_COUNTRY_FINAL_CHAR_MASK) + Character.new(?A.ord)))
          default_fraction_digits = (table_entry & SIMPLE_CASE_COUNTRY_DEFAULT_DIGITS_MASK) >> SIMPLE_CASE_COUNTRY_DEFAULT_DIGITS_SHIFT
          numeric_code = (table_entry & NUMERIC_CODE_MASK) >> NUMERIC_CODE_SHIFT
          sb = StringBuffer.new(country)
          sb.append(final_char)
          return get_instance(sb.to_s, default_fraction_digits, numeric_code)
        else
          # special cases
          if ((table_entry).equal?(INVALID_COUNTRY_ENTRY))
            raise IllegalArgumentException.new
          end
          if ((table_entry).equal?(COUNTRY_WITHOUT_CURRENCY_ENTRY))
            return nil
          else
            index = (table_entry & SPECIAL_CASE_COUNTRY_INDEX_MASK) - SPECIAL_CASE_COUNTRY_INDEX_DELTA
            if ((self.attr_sc_cut_over_times[index]).equal?(Long::MAX_VALUE) || System.current_time_millis < self.attr_sc_cut_over_times[index])
              return get_instance(self.attr_sc_old_currencies[index], self.attr_sc_old_currencies_dfd[index], self.attr_sc_old_currencies_numeric_code[index])
            else
              return get_instance(self.attr_sc_new_currencies[index], self.attr_sc_new_currencies_dfd[index], self.attr_sc_new_currencies_numeric_code[index])
            end
          end
        end
      end
      
      typesig { [] }
      # Gets the set of available currencies.  The returned set of currencies
      # contains all of the available currencies, which may include currencies
      # that represent obsolete ISO 4217 codes.  The set can be modified
      # without affecting the available currencies in the runtime.
      # 
      # @return the set of available currencies.  If there is no currency
      # available in the runtime, the returned set is empty.
      # @since 1.7
      def get_available_currencies
        synchronized((Currency)) do
          if ((self.attr_available).nil?)
            self.attr_available = HashSet.new(256)
            # Add simple currencies first
            c1 = Character.new(?A.ord)
            while c1 <= Character.new(?Z.ord)
              c2 = Character.new(?A.ord)
              while c2 <= Character.new(?Z.ord)
                table_entry = get_main_table_entry(c1, c2)
                if (((table_entry & COUNTRY_TYPE_MASK)).equal?(SIMPLE_CASE_COUNTRY_MASK) && !(table_entry).equal?(INVALID_COUNTRY_ENTRY))
                  final_char = RJava.cast_to_char(((table_entry & SIMPLE_CASE_COUNTRY_FINAL_CHAR_MASK) + Character.new(?A.ord)))
                  default_fraction_digits = (table_entry & SIMPLE_CASE_COUNTRY_DEFAULT_DIGITS_MASK) >> SIMPLE_CASE_COUNTRY_DEFAULT_DIGITS_SHIFT
                  numeric_code = (table_entry & NUMERIC_CODE_MASK) >> NUMERIC_CODE_SHIFT
                  sb = StringBuilder.new
                  sb.append(c1)
                  sb.append(c2)
                  sb.append(final_char)
                  self.attr_available.add(get_instance(sb.to_s, default_fraction_digits, numeric_code))
                end
                c2 += 1
              end
              c1 += 1
            end
            # Now add other currencies
            st = StringTokenizer.new(self.attr_other_currencies, "-")
            while (st.has_more_elements)
              self.attr_available.add(get_instance(st.next_element))
            end
          end
        end
        return self.attr_available.clone
      end
    }
    
    typesig { [] }
    # Gets the ISO 4217 currency code of this currency.
    # 
    # @return the ISO 4217 currency code of this currency.
    def get_currency_code
      return @currency_code
    end
    
    typesig { [] }
    # Gets the symbol of this currency for the default locale.
    # For example, for the US Dollar, the symbol is "$" if the default
    # locale is the US, while for other locales it may be "US$". If no
    # symbol can be determined, the ISO 4217 currency code is returned.
    # 
    # @return the symbol of this currency for the default locale
    def get_symbol
      return get_symbol(Locale.get_default)
    end
    
    typesig { [Locale] }
    # Gets the symbol of this currency for the specified locale.
    # For example, for the US Dollar, the symbol is "$" if the specified
    # locale is the US, while for other locales it may be "US$". If no
    # symbol can be determined, the ISO 4217 currency code is returned.
    # 
    # @param locale the locale for which a display name for this currency is
    # needed
    # @return the symbol of this currency for the specified locale
    # @exception NullPointerException if <code>locale</code> is null
    def get_symbol(locale)
      begin
        # Check whether a provider can provide an implementation that's closer
        # to the requested locale than what the Java runtime itself can provide.
        pool = LocaleServiceProviderPool.get_pool(CurrencyNameProvider)
        if (pool.has_providers)
          # Assuming that all the country locales include necessary currency
          # symbols in the Java runtime's resources,  so there is no need to
          # examine whether Java runtime's currency resource bundle is missing
          # names.  Therefore, no resource bundle is provided for calling this
          # method.
          symbol = pool.get_localized_object(CurrencyNameGetter::INSTANCE, locale, nil, @currency_code, SYMBOL)
          if (!(symbol).nil?)
            return symbol
          end
        end
        bundle = LocaleData.get_currency_names(locale)
        return bundle.get_string(@currency_code)
      rescue MissingResourceException => e
        # use currency code as symbol of last resort
        return @currency_code
      end
    end
    
    typesig { [] }
    # Gets the default number of fraction digits used with this currency.
    # For example, the default number of fraction digits for the Euro is 2,
    # while for the Japanese Yen it's 0.
    # In the case of pseudo-currencies, such as IMF Special Drawing Rights,
    # -1 is returned.
    # 
    # @return the default number of fraction digits used with this currency
    def get_default_fraction_digits
      return @default_fraction_digits
    end
    
    typesig { [] }
    # Returns the ISO 4217 numeric code of this currency.
    # 
    # @return the ISO 4217 numeric code of this currency
    # @since 1.7
    def get_numeric_code
      return @numeric_code
    end
    
    typesig { [] }
    # Gets the name that is suitable for displaying this currency for
    # the default locale.  If there is no suitable display name found
    # for the default locale, the ISO 4217 currency code is returned.
    # 
    # @return the display name of this currency for the default locale
    # @since 1.7
    def get_display_name
      return get_display_name(Locale.get_default)
    end
    
    typesig { [Locale] }
    # Gets the name that is suitable for displaying this currency for
    # the specified locale.  If there is no suitable display name found
    # for the specified locale, the ISO 4217 currency code is returned.
    # 
    # @param locale the locale for which a display name for this currency is
    # needed
    # @return the display name of this currency for the specified locale
    # @exception NullPointerException if <code>locale</code> is null
    # @since 1.7
    def get_display_name(locale)
      begin
        bundle = LocaleData.get_currency_names(locale)
        result = nil
        bundle_key = @currency_code.to_lower_case(Locale::ROOT)
        # Check whether a provider can provide an implementation that's closer
        # to the requested locale than what the Java runtime itself can provide.
        pool = LocaleServiceProviderPool.get_pool(CurrencyNameProvider)
        if (pool.has_providers)
          result = RJava.cast_to_string(pool.get_localized_object(CurrencyNameGetter::INSTANCE, locale, bundle_key, bundle, @currency_code, DISPLAYNAME))
        end
        if ((result).nil?)
          result = RJava.cast_to_string(bundle.get_string(bundle_key))
        end
        if (!(result).nil?)
          return result
        end
      rescue MissingResourceException => e
        # fall through
      end
      # use currency code as symbol of last resort
      return @currency_code
    end
    
    typesig { [] }
    # Returns the ISO 4217 currency code of this currency.
    # 
    # @return the ISO 4217 currency code of this currency
    def to_s
      return @currency_code
    end
    
    typesig { [] }
    # Resolves instances being deserialized to a single instance per currency.
    def read_resolve
      return get_instance(@currency_code)
    end
    
    class_module.module_eval {
      typesig { [::Java::Char, ::Java::Char] }
      # Gets the main table entry for the country whose country code consists
      # of char1 and char2.
      def get_main_table_entry(char1, char2)
        if (char1 < Character.new(?A.ord) || char1 > Character.new(?Z.ord) || char2 < Character.new(?A.ord) || char2 > Character.new(?Z.ord))
          raise IllegalArgumentException.new
        end
        return self.attr_main_table[(char1 - Character.new(?A.ord)) * A_TO_Z + (char2 - Character.new(?A.ord))]
      end
      
      typesig { [::Java::Char, ::Java::Char, ::Java::Int] }
      # Sets the main table entry for the country whose country code consists
      # of char1 and char2.
      def set_main_table_entry(char1, char2, entry)
        if (char1 < Character.new(?A.ord) || char1 > Character.new(?Z.ord) || char2 < Character.new(?A.ord) || char2 > Character.new(?Z.ord))
          raise IllegalArgumentException.new
        end
        self.attr_main_table[(char1 - Character.new(?A.ord)) * A_TO_Z + (char2 - Character.new(?A.ord))] = entry
      end
      
      # Obtains a localized currency names from a CurrencyNameProvider
      # implementation.
      const_set_lazy(:CurrencyNameGetter) { Class.new do
        include_class_members Currency
        include LocaleServiceProviderPool::LocalizedObjectGetter
        
        class_module.module_eval {
          const_set_lazy(:INSTANCE) { class_self::CurrencyNameGetter.new }
          const_attr_reader  :INSTANCE
        }
        
        typesig { [class_self::CurrencyNameProvider, class_self::Locale, String, Vararg.new(Object)] }
        def get_object(currency_name_provider, locale, key, *params)
          raise AssertError if not ((params.attr_length).equal?(1))
          type = params[0]
          case (type)
          # case DISPLAYNAME:
          # return currencyNameProvider.getDisplayName(key, locale);
          when SYMBOL
            return currency_name_provider.get_symbol(key, locale)
          else
            raise AssertError if not (false)
          end # shouldn't happen
          return nil
        end
        
        typesig { [class_self::CurrencyNameProvider, class_self::Locale, String, Array.typed(Object)] }
        def get_object(currency_name_provider, locale, key, params)
          get_object(currency_name_provider, locale, key, *params)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__currency_name_getter, :initialize
      end }
      
      typesig { [DataInputStream, ::Java::Int] }
      def read_int_array(dis, count)
        ret = Array.typed(::Java::Int).new(count) { 0 }
        i = 0
        while i < count
          ret[i] = dis.read_int
          i += 1
        end
        return ret
      end
      
      typesig { [DataInputStream, ::Java::Int] }
      def read_long_array(dis, count)
        ret = Array.typed(::Java::Long).new(count) { 0 }
        i = 0
        while i < count
          ret[i] = dis.read_long
          i += 1
        end
        return ret
      end
      
      typesig { [DataInputStream, ::Java::Int] }
      def read_string_array(dis, count)
        ret = Array.typed(String).new(count) { nil }
        i = 0
        while i < count
          ret[i] = dis.read_utf
          i += 1
        end
        return ret
      end
      
      typesig { [Pattern, String, String] }
      # Replaces currency data found in the currencydata.properties file
      # 
      # @param pattern regex pattern for the properties
      # @param ctry country code
      # @param data currency data.  This is a comma separated string that
      # consists of "three-letter alphabet code", "three-digit numeric code",
      # and "one-digit (0,1,2, or 3) default fraction digit".
      # For example, "JPZ,392,0".
      # @throws
      def replace_currency_data(pattern, ctry, curdata)
        if (!(ctry.length).equal?(2))
          # ignore invalid country code
          message = StringBuilder.new.append("The entry in currency.properties for ").append(ctry).append(" is ignored because of the invalid country code.").to_s
          log(Level::INFO, message, nil)
          return
        end
        m = pattern.matcher(curdata)
        if (!m.find)
          # format is not recognized.  ignore the data
          message = StringBuilder.new.append("The entry in currency.properties for ").append(ctry).append(" is ignored because the value format is not recognized.").to_s
          log(Level::INFO, message, nil)
          return
        end
        code = m.group(1)
        numeric = JavaInteger.parse_int(m.group(2))
        fraction = JavaInteger.parse_int(m.group(3))
        entry = numeric << NUMERIC_CODE_SHIFT
        index = 0
        index = 0
        while index < self.attr_sc_old_currencies.attr_length
          if ((self.attr_sc_old_currencies[index] == code))
            break
          end
          index += 1
        end
        if ((index).equal?(self.attr_sc_old_currencies.attr_length))
          # simple case
          entry |= (fraction << SIMPLE_CASE_COUNTRY_DEFAULT_DIGITS_SHIFT) | (code.char_at(2) - Character.new(?A.ord))
        else
          # special case
          entry |= SPECIAL_CASE_COUNTRY_MASK | (index + SPECIAL_CASE_COUNTRY_INDEX_DELTA)
        end
        set_main_table_entry(ctry.char_at(0), ctry.char_at(1), entry)
      end
      
      typesig { [Level, String, JavaThrowable] }
      def log(level, message, t)
        logger = Logger.get_logger("java.util.Currency")
        if (logger.is_loggable(level))
          if (!(t).nil?)
            logger.log(level, message, t)
          else
            logger.log(level, message)
          end
        end
      end
    }
    
    private
    alias_method :initialize__currency, :initialize
  end
  
end
