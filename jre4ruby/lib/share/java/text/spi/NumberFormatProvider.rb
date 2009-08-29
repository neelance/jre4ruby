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
module Java::Text::Spi
  module NumberFormatProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text::Spi
      include_const ::Java::Text, :NumberFormat
      include_const ::Java::Util, :Locale
      include_const ::Java::Util::Spi, :LocaleServiceProvider
    }
  end
  
  # An abstract class for service providers that
  # provide concrete implementations of the
  # {@link java.text.NumberFormat NumberFormat} class.
  # 
  # @since        1.6
  class NumberFormatProvider < NumberFormatProviderImports.const_get :LocaleServiceProvider
    include_class_members NumberFormatProviderImports
    
    typesig { [] }
    # Sole constructor.  (For invocation by subclass constructors, typically
    # implicit.)
    def initialize
      super()
    end
    
    typesig { [Locale] }
    # Returns a new <code>NumberFormat</code> instance which formats
    # monetary values for the specified locale.
    # 
    # @param locale the desired locale.
    # @exception NullPointerException if <code>locale</code> is null
    # @exception IllegalArgumentException if <code>locale</code> isn't
    # one of the locales returned from
    # {@link java.util.spi.LocaleServiceProvider#getAvailableLocales()
    # getAvailableLocales()}.
    # @return a currency formatter
    # @see java.text.NumberFormat#getCurrencyInstance(java.util.Locale)
    def get_currency_instance(locale)
      raise NotImplementedError
    end
    
    typesig { [Locale] }
    # Returns a new <code>NumberFormat</code> instance which formats
    # integer values for the specified locale.
    # The returned number format is configured to
    # round floating point numbers to the nearest integer using
    # half-even rounding (see {@link java.math.RoundingMode#HALF_EVEN HALF_EVEN})
    # for formatting, and to parse only the integer part of
    # an input string (see {@link
    # java.text.NumberFormat#isParseIntegerOnly isParseIntegerOnly}).
    # 
    # @param locale the desired locale
    # @exception NullPointerException if <code>locale</code> is null
    # @exception IllegalArgumentException if <code>locale</code> isn't
    # one of the locales returned from
    # {@link java.util.spi.LocaleServiceProvider#getAvailableLocales()
    # getAvailableLocales()}.
    # @return a number format for integer values
    # @see java.text.NumberFormat#getIntegerInstance(java.util.Locale)
    def get_integer_instance(locale)
      raise NotImplementedError
    end
    
    typesig { [Locale] }
    # Returns a new general-purpose <code>NumberFormat</code> instance for
    # the specified locale.
    # 
    # @param locale the desired locale
    # @exception NullPointerException if <code>locale</code> is null
    # @exception IllegalArgumentException if <code>locale</code> isn't
    # one of the locales returned from
    # {@link java.util.spi.LocaleServiceProvider#getAvailableLocales()
    # getAvailableLocales()}.
    # @return a general-purpose number formatter
    # @see java.text.NumberFormat#getNumberInstance(java.util.Locale)
    def get_number_instance(locale)
      raise NotImplementedError
    end
    
    typesig { [Locale] }
    # Returns a new <code>NumberFormat</code> instance which formats
    # percentage values for the specified locale.
    # 
    # @param locale the desired locale
    # @exception NullPointerException if <code>locale</code> is null
    # @exception IllegalArgumentException if <code>locale</code> isn't
    # one of the locales returned from
    # {@link java.util.spi.LocaleServiceProvider#getAvailableLocales()
    # getAvailableLocales()}.
    # @return a percent formatter
    # @see java.text.NumberFormat#getPercentInstance(java.util.Locale)
    def get_percent_instance(locale)
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__number_format_provider, :initialize
  end
  
end
