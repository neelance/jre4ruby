require "rjava"

# Portions Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Util::Resources
  module LocaleDataImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util::Resources
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util, :StringTokenizer
      include_const ::Sun::Util, :LocaleDataMetaInfo
    }
  end
  
  # Provides information about and access to resource bundles in the
  # sun.text.resources and sun.util.resources package.
  # 
  # @author Asmus Freytag
  # @author Mark Davis
  class LocaleData 
    include_class_members LocaleDataImports
    
    class_module.module_eval {
      const_set_lazy(:LocaleDataJarName) { "localedata.jar" }
      const_attr_reader  :LocaleDataJarName
      
      # Lazy load available locales.
      const_set_lazy(:AvailableLocales) { Class.new do
        include_class_members LocaleData
        
        class_module.module_eval {
          const_set_lazy(:LocaleList) { create_locale_list }
          const_attr_reader  :LocaleList
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__available_locales, :initialize
      end }
      
      typesig { [] }
      # Returns a list of the installed locales. Currently, this simply returns
      # the list of locales for which a sun.text.resources.FormatData bundle
      # exists. This bundle family happens to be the one with the broadest
      # locale coverage in the JRE.
      def get_available_locales
        return AvailableLocales.attr_locale_list.clone
      end
      
      typesig { [Locale] }
      # Gets a calendar data resource bundle, using privileges
      # to allow accessing a sun.* package.
      def get_calendar_data(locale)
        return get_bundle("sun.util.resources.CalendarData", locale)
      end
      
      typesig { [Locale] }
      # Gets a currency names resource bundle, using privileges
      # to allow accessing a sun.* package.
      def get_currency_names(locale)
        return get_bundle("sun.util.resources.CurrencyNames", locale)
      end
      
      typesig { [Locale] }
      # Gets a locale names resource bundle, using privileges
      # to allow accessing a sun.* package.
      def get_locale_names(locale)
        return get_bundle("sun.util.resources.LocaleNames", locale)
      end
      
      typesig { [Locale] }
      # Gets a time zone names resource bundle, using privileges
      # to allow accessing a sun.* package.
      def get_time_zone_names(locale)
        return get_bundle("sun.util.resources.TimeZoneNames", locale)
      end
      
      typesig { [Locale] }
      # Gets a collation data resource bundle, using privileges
      # to allow accessing a sun.* package.
      def get_collation_data(locale)
        return get_bundle("sun.text.resources.CollationData", locale)
      end
      
      typesig { [Locale] }
      # Gets a date format data resource bundle, using privileges
      # to allow accessing a sun.* package.
      def get_date_format_data(locale)
        return get_bundle("sun.text.resources.FormatData", locale)
      end
      
      typesig { [Locale] }
      # Gets a number format data resource bundle, using privileges
      # to allow accessing a sun.* package.
      def get_number_format_data(locale)
        return get_bundle("sun.text.resources.FormatData", locale)
      end
      
      typesig { [String, Locale] }
      def get_bundle(base_name, locale)
        return AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          local_class_in LocaleData
          include_class_members LocaleData
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return ResourceBundle.get_bundle(base_name, locale, LocaleDataResourceBundleControl.get_rbcontrol_instance)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      const_set_lazy(:LocaleDataResourceBundleControl) { Class.new(ResourceBundle::Control) do
        include_class_members LocaleData
        
        class_module.module_eval {
          # Singlton instance of ResourceBundle.Control.
          
          def rb_control_instance
            defined?(@@rb_control_instance) ? @@rb_control_instance : @@rb_control_instance= class_self::LocaleDataResourceBundleControl.new
          end
          alias_method :attr_rb_control_instance, :rb_control_instance
          
          def rb_control_instance=(value)
            @@rb_control_instance = value
          end
          alias_method :attr_rb_control_instance=, :rb_control_instance=
          
          typesig { [] }
          def get_rbcontrol_instance
            return self.attr_rb_control_instance
          end
        }
        
        typesig { [String, class_self::Locale] }
        # This method overrides the default implementation to search
        # from a prebaked locale string list to determin the candidate
        # locale list.
        # 
        # @param baseName the resource bundle base name.
        # locale   the requested locale for the resource bundle.
        # @returns a list of candidate locales to search from.
        # @exception NullPointerException if baseName or locale is null.
        def get_candidate_locales(base_name, locale)
          candidates = super(base_name, locale)
          # Get the locale string list from LocaleDataMetaInfo class.
          locale_string = LocaleDataMetaInfo.get_supported_locale_string(base_name)
          if ((locale_string.length).equal?(0))
            return candidates
          end
          l = candidates.iterator
          while l.has_next
            lstr = l.next_.to_s
            # Every locale string in the locale string list returned from
            # the above getSupportedLocaleString is enclosed
            # within two white spaces so that we could check some locale
            # such as "en".
            if (!(lstr.length).equal?(0) && (locale_string.index_of(" " + lstr + " ")).equal?(-1))
              l.remove
            end
          end
          return candidates
        end
        
        typesig { [String, class_self::Locale] }
        # Overrides "getFallbackLocale" to return null so
        # that the fallback locale will be null.
        # @param baseName the resource bundle base name.
        # locale   the requested locale for the resource bundle.
        # @return null for the fallback locale.
        # @exception NullPointerException if baseName or locale is null.
        def get_fallback_locale(base_name, locale)
          if ((base_name).nil? || (locale).nil?)
            raise self.class::NullPointerException.new
          end
          return nil
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__locale_data_resource_bundle_control, :initialize
      end }
      
      typesig { [] }
      # Returns true if the non European resources jar file exists in jre
      # extension directory.
      # @returns true if the jar file is there. Otherwise, returns false.
      def is_non_euro_lang_supported
        sep = JavaFile.attr_separator
        locale_data_jar = RJava.cast_to_string(Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("java.home"))) + sep + "lib" + sep + "ext" + sep + LocaleDataJarName
        # Peek at the installed extension directory to see if
        # localedata.jar is installed or not.
        f = JavaFile.new(locale_data_jar)
        is_non_euro_res_jar_exist = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          local_class_in LocaleData
          include_class_members LocaleData
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return Boolean.value_of(f.exists)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)).boolean_value
        return is_non_euro_res_jar_exist
      end
      
      typesig { [] }
      # This method gets the locale string list from LocaleDataMetaInfo class and
      # then contructs the Locale array based on the locale string returned above.
      # @returns the Locale array for the supported locale of JRE.
      def create_locale_list
        supported_locale_string = LocaleDataMetaInfo.get_supported_locale_string("sun.text.resources.FormatData")
        if ((supported_locale_string.length).equal?(0))
          return nil
        end
        # Look for "|" and construct a new locale string list.
        bar_index = supported_locale_string.index_of("|")
        locale_string_tokenizer = nil
        if (is_non_euro_lang_supported)
          locale_string_tokenizer = StringTokenizer.new(supported_locale_string.substring(0, bar_index) + supported_locale_string.substring(bar_index + 1))
        else
          locale_string_tokenizer = StringTokenizer.new(supported_locale_string.substring(0, bar_index))
        end
        locales = Array.typed(Locale).new(locale_string_tokenizer.count_tokens) { nil }
        i = 0
        while i < locales.attr_length
          current_token = locale_string_tokenizer.next_token
          p2 = 0
          p1 = current_token.index_of(Character.new(?_.ord))
          language = ""
          country = ""
          variant = ""
          if ((p1).equal?(-1))
            language = current_token
          else
            language = RJava.cast_to_string(current_token.substring(0, p1))
            p2 = current_token.index_of(Character.new(?_.ord), p1 + 1)
            if ((p2).equal?(-1))
              country = RJava.cast_to_string(current_token.substring(p1 + 1))
            else
              country = RJava.cast_to_string(current_token.substring(p1 + 1, p2))
              if (p2 < current_token.length)
                variant = RJava.cast_to_string(current_token.substring(p2 + 1))
              end
            end
          end
          locales[i] = Locale.new(language, country, variant)
          i += 1
        end
        return locales
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__locale_data, :initialize
  end
  
end
