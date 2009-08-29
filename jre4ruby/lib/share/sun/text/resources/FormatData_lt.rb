require "rjava"

# Portions Copyright 1997-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Text::Resources
  module FormatData_ltImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class FormatData_lt < FormatData_ltImports.const_get :ListResourceBundle
    include_class_members FormatData_ltImports
    
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
      # era strings
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
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["MonthNames", Array.typed(String).new(["Sausio", "Vasario", "Kovo", ("Baland".to_u << 0x017e << "io"), ("Gegu".to_u << 0x017e << "".to_u << 0x0117 << "s"), ("Bir".to_u << 0x017e << "elio"), "Liepos", ("Rugpj".to_u << 0x016b << "".to_u << 0x010d << "io"), ("Rugs".to_u << 0x0117 << "jo"), "Spalio", ("Lapkri".to_u << 0x010d << "io"), ("Gruod".to_u << 0x017e << "io"), ""])]), Array.typed(Object).new(["MonthAbbreviations", Array.typed(String).new(["Sau", "Vas", "Kov", "Bal", "Geg", "Bir", "Lie", "Rgp", "Rgs", "Spa", "Lap", "Grd", ""])]), Array.typed(Object).new(["DayNames", Array.typed(String).new(["Sekmadienis", "Pirmadienis", "Antradienis", ("Tre".to_u << 0x010d << "iadienis"), "Ketvirtadienis", "Penktadienis", ("".to_u << 0x0160 << "e".to_u << 0x0161 << "tadienis")])]), Array.typed(Object).new(["DayAbbreviations", Array.typed(String).new(["Sk", "Pr", "An", "Tr", "Kt", "Pn", ("".to_u << 0x0160 << "t")])]), Array.typed(Object).new(["Eras", Array.typed(String).new(["pr.Kr.", "po.Kr."])]), Array.typed(Object).new(["NumberElements", Array.typed(String).new([",", ("".to_u << 0x00a0 << ""), ";", "%", "0", "#", "-", "E", ("".to_u << 0x2030 << ""), ("".to_u << 0x221e << ""), ("".to_u << 0xfffd << "")])]), Array.typed(Object).new(["DateTimePatterns", Array.typed(String).new(["HH.mm.ss z", "HH.mm.ss z", "HH.mm.ss", "HH.mm", "EEEE, yyyy, MMMM d", "EEEE, yyyy, MMMM d", "yyyy-MM-dd", "yy.M.d", "{1} {0}"])]), Array.typed(Object).new(["DateTimePatternChars", "GanjkHmsSEDFwWxhKzZ"]), ])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__format_data_lt, :initialize
  end
  
end
