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
module Sun::Text::Resources
  module FormatData_koImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class FormatData_ko < FormatData_koImports.const_get :ListResourceBundle
    include_class_members FormatData_koImports
    
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
      # full time pattern
      # long time pattern
      # medium time pattern
      # short time pattern
      # full date pattern
      # long date pattern
      # medium date pattern
      # short date pattern
      # date-time pattern
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["MonthNames", Array.typed(String).new([("1".to_u << 0xc6d4 << ""), ("2".to_u << 0xc6d4 << ""), ("3".to_u << 0xc6d4 << ""), ("4".to_u << 0xc6d4 << ""), ("5".to_u << 0xc6d4 << ""), ("6".to_u << 0xc6d4 << ""), ("7".to_u << 0xc6d4 << ""), ("8".to_u << 0xc6d4 << ""), ("9".to_u << 0xc6d4 << ""), ("10".to_u << 0xc6d4 << ""), ("11".to_u << 0xc6d4 << ""), ("12".to_u << 0xc6d4 << ""), ""])]), Array.typed(Object).new(["MonthAbbreviations", Array.typed(String).new([("1".to_u << 0xc6d4 << ""), ("2".to_u << 0xc6d4 << ""), ("3".to_u << 0xc6d4 << ""), ("4".to_u << 0xc6d4 << ""), ("5".to_u << 0xc6d4 << ""), ("6".to_u << 0xc6d4 << ""), ("7".to_u << 0xc6d4 << ""), ("8".to_u << 0xc6d4 << ""), ("9".to_u << 0xc6d4 << ""), ("10".to_u << 0xc6d4 << ""), ("11".to_u << 0xc6d4 << ""), ("12".to_u << 0xc6d4 << ""), ""])]), Array.typed(Object).new(["DayNames", Array.typed(String).new([("".to_u << 0xc77c << "".to_u << 0xc694 << "".to_u << 0xc77c << ""), ("".to_u << 0xc6d4 << "".to_u << 0xc694 << "".to_u << 0xc77c << ""), ("".to_u << 0xd654 << "".to_u << 0xc694 << "".to_u << 0xc77c << ""), ("".to_u << 0xc218 << "".to_u << 0xc694 << "".to_u << 0xc77c << ""), ("".to_u << 0xbaa9 << "".to_u << 0xc694 << "".to_u << 0xc77c << ""), ("".to_u << 0xae08 << "".to_u << 0xc694 << "".to_u << 0xc77c << ""), ("".to_u << 0xd1a0 << "".to_u << 0xc694 << "".to_u << 0xc77c << "")])]), Array.typed(Object).new(["DayAbbreviations", Array.typed(String).new([("".to_u << 0xc77c << ""), ("".to_u << 0xc6d4 << ""), ("".to_u << 0xd654 << ""), ("".to_u << 0xc218 << ""), ("".to_u << 0xbaa9 << ""), ("".to_u << 0xae08 << ""), ("".to_u << 0xd1a0 << "")])]), Array.typed(Object).new(["AmPmMarkers", Array.typed(String).new([("".to_u << 0xc624 << "".to_u << 0xc804 << ""), ("".to_u << 0xc624 << "".to_u << 0xd6c4 << "")])]), Array.typed(Object).new(["DateTimePatterns", Array.typed(String).new([("a h'".to_u << 0xc2dc << "' mm'".to_u << 0xbd84 << "' ss'".to_u << 0xcd08 << "' z"), ("a h'".to_u << 0xc2dc << "' mm'".to_u << 0xbd84 << "' ss'".to_u << 0xcd08 << "'"), "a h:mm:ss", "a h:mm", ("yyyy'".to_u << 0xb144 << "' M'".to_u << 0xc6d4 << "' d'".to_u << 0xc77c << "' EEEE"), ("yyyy'".to_u << 0xb144 << "' M'".to_u << 0xc6d4 << "' d'".to_u << 0xc77c << "' '('EE')'"), "yyyy. M. d", "yy. M. d", "{1} {0}"])]), Array.typed(Object).new(["DateTimePatternChars", "GyMdkHmsSEDFwWahKzZ"]), ])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__format_data_ko, :initialize
  end
  
end
