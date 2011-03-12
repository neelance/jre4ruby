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
module Java::Util::Spi
  module LocaleNameProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Spi
      include_const ::Java::Util, :Locale
    }
  end
  
  # An abstract class for service providers that
  # provide localized names for the
  # {@link java.util.Locale Locale} class.
  # 
  # @since        1.6
  class LocaleNameProvider < LocaleNameProviderImports.const_get :LocaleServiceProvider
    include_class_members LocaleNameProviderImports
    
    typesig { [] }
    # Sole constructor.  (For invocation by subclass constructors, typically
    # implicit.)
    def initialize
      super()
    end
    
    typesig { [String, Locale] }
    # Returns a localized name for the given ISO 639 language code and the
    # given locale that is appropriate for display to the user.
    # For example, if <code>languageCode</code> is "fr" and <code>locale</code>
    # is en_US, getDisplayLanguage() will return "French"; if <code>languageCode</code>
    # is "en" and <code>locale</code> is fr_FR, getDisplayLanguage() will return "anglais".
    # If the name returned cannot be localized according to <code>locale</code>,
    # (say, the provider does not have a Japanese name for Croatian),
    # this method returns null.
    # @param languageCode the ISO 639 language code string in the form of two
    #     lower-case letters between 'a' (U+0061) and 'z' (U+007A)
    # @param locale the desired locale
    # @return the name of the given language code for the specified locale, or null if it's not
    #     available.
    # @exception NullPointerException if <code>languageCode</code> or <code>locale</code> is null
    # @exception IllegalArgumentException if <code>languageCode</code> is not in the form of
    #     two lower-case letters, or <code>locale</code> isn't
    #     one of the locales returned from
    #     {@link java.util.spi.LocaleServiceProvider#getAvailableLocales()
    #     getAvailableLocales()}.
    # @see java.util.Locale#getDisplayLanguage(java.util.Locale)
    def get_display_language(language_code, locale)
      raise NotImplementedError
    end
    
    typesig { [String, Locale] }
    # Returns a localized name for the given ISO 3166 country code and the
    # given locale that is appropriate for display to the user.
    # For example, if <code>countryCode</code> is "FR" and <code>locale</code>
    # is en_US, getDisplayCountry() will return "France"; if <code>countryCode</code>
    # is "US" and <code>locale</code> is fr_FR, getDisplayCountry() will return "Etats-Unis".
    # If the name returned cannot be localized according to <code>locale</code>,
    # (say, the provider does not have a Japanese name for Croatia),
    # this method returns null.
    # @param countryCode the ISO 3166 country code string in the form of two
    #     upper-case letters between 'A' (U+0041) and 'Z' (U+005A)
    # @param locale the desired locale
    # @return the name of the given country code for the specified locale, or null if it's not
    #     available.
    # @exception NullPointerException if <code>countryCode</code> or <code>locale</code> is null
    # @exception IllegalArgumentException if <code>countryCode</code> is not in the form of
    #     two upper-case letters, or <code>locale</code> isn't
    #     one of the locales returned from
    #     {@link java.util.spi.LocaleServiceProvider#getAvailableLocales()
    #     getAvailableLocales()}.
    # @see java.util.Locale#getDisplayCountry(java.util.Locale)
    def get_display_country(country_code, locale)
      raise NotImplementedError
    end
    
    typesig { [String, Locale] }
    # Returns a localized name for the given variant code and the given locale that
    # is appropriate for display to the user.
    # If the name returned cannot be localized according to <code>locale</code>,
    # this method returns null.
    # @param variant the variant string
    # @param locale the desired locale
    # @return the name of the given variant string for the specified locale, or null if it's not
    #     available.
    # @exception NullPointerException if <code>variant</code> or <code>locale</code> is null
    # @exception IllegalArgumentException if <code>locale</code> isn't
    #     one of the locales returned from
    #     {@link java.util.spi.LocaleServiceProvider#getAvailableLocales()
    #     getAvailableLocales()}.
    # @see java.util.Locale#getDisplayVariant(java.util.Locale)
    def get_display_variant(variant, locale)
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__locale_name_provider, :initialize
  end
  
end
