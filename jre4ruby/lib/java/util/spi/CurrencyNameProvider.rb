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
  module CurrencyNameProviderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Spi
      include_const ::Java::Util, :Currency
      include_const ::Java::Util, :Locale
    }
  end
  
  # An abstract class for service providers that
  # provide localized currency symbols and display names for the
  # {@link java.util.Currency Currency} class.
  # Note that currency symbols are considered names when determining
  # behaviors described in the
  # {@link java.util.spi.LocaleServiceProvider LocaleServiceProvider}
  # specification.
  # 
  # @since        1.6
  class CurrencyNameProvider < CurrencyNameProviderImports.const_get :LocaleServiceProvider
    include_class_members CurrencyNameProviderImports
    
    typesig { [] }
    # Sole constructor.  (For invocation by subclass constructors, typically
    # implicit.)
    def initialize
      super()
    end
    
    typesig { [String, Locale] }
    # Gets the symbol of the given currency code for the specified locale.
    # For example, for "USD" (US Dollar), the symbol is "$" if the specified
    # locale is the US, while for other locales it may be "US$". If no
    # symbol can be determined, null should be returned.
    # 
    # @param currencyCode the ISO 4217 currency code, which
    # consists of three upper-case letters between 'A' (U+0041) and
    # 'Z' (U+005A)
    # @param locale the desired locale
    # @return the symbol of the given currency code for the specified locale, or null if
    # the symbol is not available for the locale
    # @exception NullPointerException if <code>currencyCode</code> or
    # <code>locale</code> is null
    # @exception IllegalArgumentException if <code>currencyCode</code> is not in
    # the form of three upper-case letters, or <code>locale</code> isn't
    # one of the locales returned from
    # {@link java.util.spi.LocaleServiceProvider#getAvailableLocales()
    # getAvailableLocales()}.
    # @see java.util.Currency#getSymbol(java.util.Locale)
    def get_symbol(currency_code, locale)
      raise NotImplementedError
    end
    
    typesig { [String, Locale] }
    # Returns a name for the currency that is appropriate for display to the
    # user.  The default implementation returns null.
    # 
    # @param currencyCode the ISO 4217 currency code, which
    # consists of three upper-case letters between 'A' (U+0041) and
    # 'Z' (U+005A)
    # @param locale the desired locale
    # @return the name for the currency that is appropriate for display to the
    # user, or null if the name is not available for the locale
    # @exception IllegalArgumentException if <code>currencyCode</code> is not in
    # the form of three upper-case letters, or <code>locale</code> isn't
    # one of the locales returned from
    # {@link java.util.spi.LocaleServiceProvider#getAvailableLocales()
    # getAvailableLocales()}.
    # @exception NullPointerException if <code>currencyCode</code> or
    # <code>locale</code> is <code>null</code>
    # @since 1.7
    def get_display_name(currency_code, locale)
      if ((currency_code).nil? || (locale).nil?)
        raise NullPointerException.new
      end
      return nil
    end
    
    private
    alias_method :initialize__currency_name_provider, :initialize
  end
  
end
