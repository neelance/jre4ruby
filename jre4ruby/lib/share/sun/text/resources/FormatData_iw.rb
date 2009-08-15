require "rjava"

# Portions Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module FormatData_iwImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class FormatData_iw < FormatData_iwImports.const_get :ListResourceBundle
    include_class_members FormatData_iwImports
    
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
      # full time pattern
      # long time pattern
      # medium time pattern
      # short time pattern
      # full date pattern
      # long date pattern
      # medium date pattern
      # short date pattern
      # date-time pattern
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["MonthNames", Array.typed(String).new([("".to_u << 0x05d9 << "".to_u << 0x05e0 << "".to_u << 0x05d5 << "".to_u << 0x05d0 << "".to_u << 0x05e8 << ""), ("".to_u << 0x05e4 << "".to_u << 0x05d1 << "".to_u << 0x05e8 << "".to_u << 0x05d5 << "".to_u << 0x05d0 << "".to_u << 0x05e8 << ""), ("".to_u << 0x05de << "".to_u << 0x05e8 << "".to_u << 0x05e5 << ""), ("".to_u << 0x05d0 << "".to_u << 0x05e4 << "".to_u << 0x05e8 << "".to_u << 0x05d9 << "".to_u << 0x05dc << ""), ("".to_u << 0x05de << "".to_u << 0x05d0 << "".to_u << 0x05d9 << ""), ("".to_u << 0x05d9 << "".to_u << 0x05d5 << "".to_u << 0x05e0 << "".to_u << 0x05d9 << ""), ("".to_u << 0x05d9 << "".to_u << 0x05d5 << "".to_u << 0x05dc << "".to_u << 0x05d9 << ""), ("".to_u << 0x05d0 << "".to_u << 0x05d5 << "".to_u << 0x05d2 << "".to_u << 0x05d5 << "".to_u << 0x05e1 << "".to_u << 0x05d8 << ""), ("".to_u << 0x05e1 << "".to_u << 0x05e4 << "".to_u << 0x05d8 << "".to_u << 0x05de << "".to_u << 0x05d1 << "".to_u << 0x05e8 << ""), ("".to_u << 0x05d0 << "".to_u << 0x05d5 << "".to_u << 0x05e7 << "".to_u << 0x05d8 << "".to_u << 0x05d5 << "".to_u << 0x05d1 << "".to_u << 0x05e8 << ""), ("".to_u << 0x05e0 << "".to_u << 0x05d5 << "".to_u << 0x05d1 << "".to_u << 0x05de << "".to_u << 0x05d1 << "".to_u << 0x05e8 << ""), ("".to_u << 0x05d3 << "".to_u << 0x05e6 << "".to_u << 0x05de << "".to_u << 0x05d1 << "".to_u << 0x05e8 << ""), ""])]), Array.typed(Object).new(["MonthAbbreviations", Array.typed(String).new([("".to_u << 0x05d9 << "".to_u << 0x05e0 << "".to_u << 0x05d5 << ""), ("".to_u << 0x05e4 << "".to_u << 0x05d1 << "".to_u << 0x05e8 << ""), ("".to_u << 0x05de << "".to_u << 0x05e8 << "".to_u << 0x05e5 << ""), ("".to_u << 0x05d0 << "".to_u << 0x05e4 << "".to_u << 0x05e8 << ""), ("".to_u << 0x05de << "".to_u << 0x05d0 << "".to_u << 0x05d9 << ""), ("".to_u << 0x05d9 << "".to_u << 0x05d5 << "".to_u << 0x05e0 << ""), ("".to_u << 0x05d9 << "".to_u << 0x05d5 << "".to_u << 0x05dc << ""), ("".to_u << 0x05d0 << "".to_u << 0x05d5 << "".to_u << 0x05d2 << ""), ("".to_u << 0x05e1 << "".to_u << 0x05e4 << "".to_u << 0x05d8 << ""), ("".to_u << 0x05d0 << "".to_u << 0x05d5 << "".to_u << 0x05e7 << ""), ("".to_u << 0x05e0 << "".to_u << 0x05d5 << "".to_u << 0x05d1 << ""), ("".to_u << 0x05d3 << "".to_u << 0x05e6 << "".to_u << 0x05de << ""), ""])]), Array.typed(Object).new(["DayNames", Array.typed(String).new([("".to_u << 0x05d9 << "".to_u << 0x05d5 << "".to_u << 0x05dd << " ".to_u << 0x05e8 << "".to_u << 0x05d0 << "".to_u << 0x05e9 << "".to_u << 0x05d5 << "".to_u << 0x05df << ""), ("".to_u << 0x05d9 << "".to_u << 0x05d5 << "".to_u << 0x05dd << " ".to_u << 0x05e9 << "".to_u << 0x05e0 << "".to_u << 0x05d9 << ""), ("".to_u << 0x05d9 << "".to_u << 0x05d5 << "".to_u << 0x05dd << " ".to_u << 0x05e9 << "".to_u << 0x05dc << "".to_u << 0x05d9 << "".to_u << 0x05e9 << "".to_u << 0x05d9 << ""), ("".to_u << 0x05d9 << "".to_u << 0x05d5 << "".to_u << 0x05dd << " ".to_u << 0x05e8 << "".to_u << 0x05d1 << "".to_u << 0x05d9 << "".to_u << 0x05e2 << "".to_u << 0x05d9 << ""), ("".to_u << 0x05d9 << "".to_u << 0x05d5 << "".to_u << 0x05dd << " ".to_u << 0x05d7 << "".to_u << 0x05de << "".to_u << 0x05d9 << "".to_u << 0x05e9 << "".to_u << 0x05d9 << ""), ("".to_u << 0x05d9 << "".to_u << 0x05d5 << "".to_u << 0x05dd << " ".to_u << 0x05e9 << "".to_u << 0x05d9 << "".to_u << 0x05e9 << "".to_u << 0x05d9 << ""), ("".to_u << 0x05e9 << "".to_u << 0x05d1 << "".to_u << 0x05ea << "")])]), Array.typed(Object).new(["DayAbbreviations", Array.typed(String).new([("".to_u << 0x05d0 << ""), ("".to_u << 0x05d1 << ""), ("".to_u << 0x05d2 << ""), ("".to_u << 0x05d3 << ""), ("".to_u << 0x05d4 << ""), ("".to_u << 0x05d5 << ""), ("".to_u << 0x05e9 << "")])]), Array.typed(Object).new(["Eras", Array.typed(String).new([("".to_u << 0x05dc << "".to_u << 0x05e1 << "".to_u << 0x05d4 << "\"".to_u << 0x05e0 << ""), ("".to_u << 0x05dc << "".to_u << 0x05e4 << "".to_u << 0x05e1 << "".to_u << 0x05d4 << "\"".to_u << 0x05e0 << "")])]), Array.typed(Object).new(["DateTimePatterns", Array.typed(String).new(["HH:mm:ss z", "HH:mm:ss z", "HH:mm:ss", "HH:mm", "EEEE d MMMM yyyy", "d MMMM yyyy", "dd/MM/yyyy", "dd/MM/yy", "{0} {1}"])]), Array.typed(Object).new(["DateTimePatternChars", "GanjkHmsSEDFwWxhKzZ"]), ])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__format_data_iw, :initialize
  end
  
end
