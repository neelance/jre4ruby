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
  module TimeZoneNameProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Spi
      include_const ::Java::Util, :Locale
    }
  end
  
  # An abstract class for service providers that
  # provide localized time zone names for the
  # {@link java.util.TimeZone TimeZone} class.
  # The localized time zone names available from the implementations of
  # this class are also the source for the
  # {@link java.text.DateFormatSymbols#getZoneStrings()
  # DateFormatSymbols.getZoneStrings()} method.
  # 
  # @since        1.6
  class TimeZoneNameProvider < TimeZoneNameProviderImports.const_get :LocaleServiceProvider
    include_class_members TimeZoneNameProviderImports
    
    typesig { [] }
    # Sole constructor.  (For invocation by subclass constructors, typically
    # implicit.)
    def initialize
      super()
    end
    
    typesig { [String, ::Java::Boolean, ::Java::Int, Locale] }
    # Returns a name for the given time zone ID that's suitable for
    # presentation to the user in the specified locale. The given time
    # zone ID is "GMT" or one of the names defined using "Zone" entries
    # in the "tz database", a public domain time zone database at
    # <a href="ftp://elsie.nci.nih.gov/pub/">ftp://elsie.nci.nih.gov/pub/</a>.
    # The data of this database is contained in a file whose name starts with
    # "tzdata", and the specification of the data format is part of the zic.8
    # man page, which is contained in a file whose name starts with "tzcode".
    # <p>
    # If <code>daylight</code> is true, the method should return a name
    # appropriate for daylight saving time even if the specified time zone
    # has not observed daylight saving time in the past.
    # 
    # @param ID a time zone ID string
    # @param daylight if true, return the daylight saving name.
    # @param style either {@link java.util.TimeZone#LONG TimeZone.LONG} or
    #    {@link java.util.TimeZone#SHORT TimeZone.SHORT}
    # @param locale the desired locale
    # @return the human-readable name of the given time zone in the
    #     given locale, or null if it's not available.
    # @exception IllegalArgumentException if <code>style</code> is invalid,
    #     or <code>locale</code> isn't one of the locales returned from
    #     {@link java.util.spi.LocaleServiceProvider#getAvailableLocales()
    #     getAvailableLocales()}.
    # @exception NullPointerException if <code>ID</code> or <code>locale</code>
    #     is null
    # @see java.util.TimeZone#getDisplayName(boolean, int, java.util.Locale)
    def get_display_name(id, daylight, style, locale)
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__time_zone_name_provider, :initialize
  end
  
end
