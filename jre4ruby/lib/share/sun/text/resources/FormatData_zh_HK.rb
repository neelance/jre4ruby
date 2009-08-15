require "rjava"

# Portions Copyright 1998-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module FormatData_zh_HKImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :ResourceBundle
      include_const ::Sun::Util::Resources, :LocaleData
    }
  end
  
  class FormatData_zh_HK < FormatData_zh_HKImports.const_get :ListResourceBundle
    include_class_members FormatData_zh_HKImports
    
    typesig { [] }
    # reparent to zh_TW for traditional Chinese names
    def initialize
      super()
      bundle = LocaleData.get_date_format_data(Locale::TAIWAN)
      set_parent(bundle)
    end
    
    typesig { [] }
    # Overrides ListResourceBundle
    def get_contents
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
      # abb Sunday
      # abb Monday
      # abb Tuesday
      # abb Wednesday
      # abb Thursday
      # abb Friday
      # abb Saturday
      # decimal pattern
      # currency pattern
      # percent pattern
      # full time pattern
      # long time pattern
      # medium time pattern
      # short time pattern
      # full date pattern
      # long date pattern
      # medium date pattern
      # short date pattern
      # date-time pattern
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["MonthAbbreviations", Array.typed(String).new([("1".to_u << 0x6708 << ""), ("2".to_u << 0x6708 << ""), ("3".to_u << 0x6708 << ""), ("4".to_u << 0x6708 << ""), ("5".to_u << 0x6708 << ""), ("6".to_u << 0x6708 << ""), ("7".to_u << 0x6708 << ""), ("8".to_u << 0x6708 << ""), ("9".to_u << 0x6708 << ""), ("10".to_u << 0x6708 << ""), ("11".to_u << 0x6708 << ""), ("12".to_u << 0x6708 << ""), ""])]), Array.typed(Object).new(["DayAbbreviations", Array.typed(String).new([("".to_u << 0x65e5 << ""), ("".to_u << 0x4e00 << ""), ("".to_u << 0x4e8c << ""), ("".to_u << 0x4e09 << ""), ("".to_u << 0x56db << ""), ("".to_u << 0x4e94 << ""), ("".to_u << 0x516d << "")])]), Array.typed(Object).new(["NumberPatterns", Array.typed(String).new(["#,##0.###;-#,##0.###", ("".to_u << 0x00A4 << "#,##0.00;(".to_u << 0x00A4 << "#,##0.00)"), "#,##0%"])]), Array.typed(Object).new(["DateTimePatterns", Array.typed(String).new([("ahh'".to_u << 0x6642 << "'mm'".to_u << 0x5206 << "'ss'".to_u << 0x79d2 << "' z"), ("ahh'".to_u << 0x6642 << "'mm'".to_u << 0x5206 << "'ss'".to_u << 0x79d2 << "'"), "ahh:mm:ss", "ah:mm", ("yyyy'".to_u << 0x5e74 << "'MM'".to_u << 0x6708 << "'dd'".to_u << 0x65e5 << "' EEEE"), ("yyyy'".to_u << 0x5e74 << "'MM'".to_u << 0x6708 << "'dd'".to_u << 0x65e5 << "' EEEE"), ("yyyy'".to_u << 0x5e74 << "'M'".to_u << 0x6708 << "'d'".to_u << 0x65e5 << "'"), ("yy'".to_u << 0x5e74 << "'M'".to_u << 0x6708 << "'d'".to_u << 0x65e5 << "'"), "{1} {0}"])]), Array.typed(Object).new(["DateTimePatternChars", "GanjkHmsSEDFwWxhKzZ"]), ])
    end
    
    private
    alias_method :initialize__format_data_zh_hk, :initialize
  end
  
end
