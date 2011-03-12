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
  module FormatData_jaImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class FormatData_ja < FormatData_jaImports.const_get :ListResourceBundle
    include_class_members FormatData_jaImports
    
    typesig { [] }
    # Overrides ListResourceBundle
    def get_contents
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["MonthNames", Array.typed(String).new([("1".to_u << 0x6708 << ""), ("2".to_u << 0x6708 << ""), ("3".to_u << 0x6708 << ""), ("4".to_u << 0x6708 << ""), ("5".to_u << 0x6708 << ""), ("6".to_u << 0x6708 << ""), ("7".to_u << 0x6708 << ""), ("8".to_u << 0x6708 << ""), ("9".to_u << 0x6708 << ""), ("10".to_u << 0x6708 << ""), ("11".to_u << 0x6708 << ""), ("12".to_u << 0x6708 << ""), ""])]), Array.typed(Object).new(["MonthAbbreviations", Array.typed(String).new(["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", ""])]), Array.typed(Object).new(["DayNames", Array.typed(String).new([("".to_u << 0x65e5 << "".to_u << 0x66dc << "".to_u << 0x65e5 << ""), ("".to_u << 0x6708 << "".to_u << 0x66dc << "".to_u << 0x65e5 << ""), ("".to_u << 0x706b << "".to_u << 0x66dc << "".to_u << 0x65e5 << ""), ("".to_u << 0x6c34 << "".to_u << 0x66dc << "".to_u << 0x65e5 << ""), ("".to_u << 0x6728 << "".to_u << 0x66dc << "".to_u << 0x65e5 << ""), ("".to_u << 0x91d1 << "".to_u << 0x66dc << "".to_u << 0x65e5 << ""), ("".to_u << 0x571f << "".to_u << 0x66dc << "".to_u << 0x65e5 << "")])]), Array.typed(Object).new(["DayAbbreviations", Array.typed(String).new([("".to_u << 0x65e5 << ""), ("".to_u << 0x6708 << ""), ("".to_u << 0x706b << ""), ("".to_u << 0x6c34 << ""), ("".to_u << 0x6728 << ""), ("".to_u << 0x91d1 << ""), ("".to_u << 0x571f << "")])]), Array.typed(Object).new(["AmPmMarkers", Array.typed(String).new([("".to_u << 0x5348 << "".to_u << 0x524d << ""), ("".to_u << 0x5348 << "".to_u << 0x5f8c << "")])]), Array.typed(Object).new(["Eras", Array.typed(String).new([("".to_u << 0x7d00 << "".to_u << 0x5143 << "".to_u << 0x524d << ""), ("".to_u << 0x897f << "".to_u << 0x66a6 << "")])]), Array.typed(Object).new(["sun.util.BuddhistCalendar.Eras", Array.typed(String).new([("".to_u << 0x7d00 << "".to_u << 0x5143 << "".to_u << 0x524d << ""), ("".to_u << 0x4ecf << "".to_u << 0x66a6 << "")])]), Array.typed(Object).new(["java.util.JapaneseImperialCalendar.Eras", Array.typed(String).new([("".to_u << 0x897f << "".to_u << 0x66a6 << ""), ("".to_u << 0x660e << "".to_u << 0x6cbb << ""), ("".to_u << 0x5927 << "".to_u << 0x6b63 << ""), ("".to_u << 0x662d << "".to_u << 0x548c << ""), ("".to_u << 0x5e73 << "".to_u << 0x6210 << "")])]), Array.typed(Object).new(["java.util.JapaneseImperialCalendar.FirstYear", Array.typed(String).new([("".to_u << 0x5143 << "")])]), Array.typed(Object).new(["NumberElements", Array.typed(String).new([".", ",", ";", "%", "0", "#", "-", "E", ("".to_u << 0x2030 << ""), ("".to_u << 0x221e << ""), ("".to_u << 0xfffd << "")])]), Array.typed(Object).new(["DateTimePatterns", Array.typed(String).new([("H'".to_u << 0x6642 << "'mm'".to_u << 0x5206 << "'ss'".to_u << 0x79d2 << "' z"), "H:mm:ss z", "H:mm:ss", "H:mm", ("yyyy'".to_u << 0x5e74 << "'M'".to_u << 0x6708 << "'d'".to_u << 0x65e5 << "'"), "yyyy/MM/dd", "yyyy/MM/dd", "yy/MM/dd", "{1} {0}"])]), Array.typed(Object).new(["java.util.JapaneseImperialCalendar.DateTimePatterns", Array.typed(String).new([("H'".to_u << 0x6642 << "'mm'".to_u << 0x5206 << "'ss'".to_u << 0x79d2 << "' z"), "H:mm:ss z", "H:mm:ss", "H:mm", ("GGGGyyyy'".to_u << 0x5e74 << "'M'".to_u << 0x6708 << "'d'".to_u << 0x65e5 << "'"), "Gy.MM.dd", "Gy.MM.dd", "Gy.MM.dd", "{1} {0}"])]), Array.typed(Object).new(["DateTimePatternChars", "GyMdkHmsSEDFwWahKzZ"])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__format_data_ja, :initialize
  end
  
end
