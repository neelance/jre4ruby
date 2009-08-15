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
# (C) Copyright IBM Corp. 1996 - 1999 - All Rights Reserved
# 
# The original version of this source code and documentation
# is copyrighted and owned by Taligent, Inc., a wholly-owned
# subsidiary of IBM. These materials are provided under terms
# of a License Agreement between Taligent and Sun. This technology
# is protected by multiple US and International patents.
# 
# This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Sun::Text::Resources
  module FormatDataImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class FormatData < FormatDataImports.const_get :ListResourceBundle
    include_class_members FormatDataImports
    
    typesig { [] }
    # Overrides ListResourceBundle
    def get_contents
      # january
      # february
      # march
      # april
      # may
      # june
      # july
      # august
      # september
      # october
      # november
      # december
      # month 13 if applicable
      # abb january
      # abb february
      # abb march
      # abb april
      # abb may
      # abb june
      # abb july
      # abb august
      # abb september
      # abb october
      # abb november
      # abb december
      # abb month 13 if applicable
      # Sunday
      # Monday
      # Tuesday
      # Wednesday
      # Thursday
      # Friday
      # Saturday
      # abb Sunday
      # abb Monday
      # abb Tuesday
      # abb Wednesday
      # abb Thursday
      # abb Friday
      # abb Saturday
      # am marker
      # pm marker
      # era strings for GregorianCalendar
      # Thai Buddhist calendar era strings
      # BC
      # Buddhist Era
      # Thai Buddhist calendar era strings
      # BC
      # Buddhist Era
      # Japanese imperial calendar era strings
      # Japanese imperial calendar era abbreviations
      # Japanese imperial calendar year name
      # empty in English
      # decimal pattern
      # currency pattern
      # percent pattern
      # decimal separator
      # group (thousands) separator
      # list separator
      # percent sign
      # native 0 digit
      # pattern digit
      # minus sign
      # exponential
      # per mille
      # infinity
      # NaN
      # full time pattern
      # long time pattern
      # medium time pattern
      # short time pattern
      # full date pattern
      # long date pattern
      # medium date pattern
      # short date pattern
      # date-time pattern
      # full time pattern
      # long time pattern
      # medium time pattern
      # short time pattern
      # full date pattern
      # long date pattern
      # medium date pattern
      # short date pattern
      # date-time pattern
      # full time pattern
      # long time pattern
      # medium time pattern
      # short time pattern
      # full date pattern
      # long date pattern
      # medium date pattern
      # short date pattern
      # date-time pattern
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["MonthNames", Array.typed(String).new(["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December", ""])]), Array.typed(Object).new(["MonthAbbreviations", Array.typed(String).new(["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", ""])]), Array.typed(Object).new(["DayNames", Array.typed(String).new(["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"])]), Array.typed(Object).new(["DayAbbreviations", Array.typed(String).new(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"])]), Array.typed(Object).new(["AmPmMarkers", Array.typed(String).new(["AM", "PM"])]), Array.typed(Object).new(["Eras", Array.typed(String).new(["BC", "AD"])]), Array.typed(Object).new(["sun.util.BuddhistCalendar.Eras", Array.typed(String).new(["BC", "B.E."])]), Array.typed(Object).new(["sun.util.BuddhistCalendar.short.Eras", Array.typed(String).new(["BC", "B.E."])]), Array.typed(Object).new(["java.util.JapaneseImperialCalendar.Eras", Array.typed(String).new(["", "Meiji", "Taisho", "Showa", "Heisei", ])]), Array.typed(Object).new(["java.util.JapaneseImperialCalendar.short.Eras", Array.typed(String).new(["", "M", "T", "S", "H", ])]), Array.typed(Object).new(["java.util.JapaneseImperialCalendar.FirstYear", Array.typed(String).new([])]), Array.typed(Object).new(["NumberPatterns", Array.typed(String).new(["#,##0.###;-#,##0.###", ("".to_u << 0x00a4 << " #,##0.00;-".to_u << 0x00a4 << " #,##0.00"), "#,##0%"])]), Array.typed(Object).new(["NumberElements", Array.typed(String).new([".", ",", ";", "%", "0", "#", "-", "E", ("".to_u << 0x2030 << ""), ("".to_u << 0x221e << ""), ("".to_u << 0xfffd << "")])]), Array.typed(Object).new(["DateTimePatterns", Array.typed(String).new(["h:mm:ss a z", "h:mm:ss a z", "h:mm:ss a", "h:mm a", "EEEE, MMMM d, yyyy", "MMMM d, yyyy", "MMM d, yyyy", "M/d/yy", "{1} {0}"])]), Array.typed(Object).new(["sun.util.BuddhistCalendar.DateTimePatterns", Array.typed(String).new(["H:mm:ss z", "H:mm:ss z", "H:mm:ss", "H:mm", "EEEE d MMMM G yyyy", "d MMMM yyyy", "d MMM yyyy", "d/M/yyyy", "{1}, {0}"])]), Array.typed(Object).new(["java.util.JapaneseImperialCalendar.DateTimePatterns", Array.typed(String).new(["h:mm:ss a z", "h:mm:ss a z", "h:mm:ss a", "h:mm a", "GGGG yyyy MMMM d (EEEE)", "GGGG yyyy MMMM d", "GGGG yyyy MMM d", "Gy.MM.dd", "{1} {0}"])]), Array.typed(Object).new(["DateTimePatternChars", "GyMdkHmsSEDFwWahKzZ"]), ])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__format_data, :initialize
  end
  
end
