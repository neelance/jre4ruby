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
  module FormatData_zhImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class FormatData_zh < FormatData_zhImports.const_get :ListResourceBundle
    include_class_members FormatData_zhImports
    
    typesig { [] }
    # Overrides ListResourceBundle
    def get_contents
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["MonthNames", Array.typed(String).new([("".to_u << 0x4e00 << "".to_u << 0x6708 << ""), ("".to_u << 0x4e8c << "".to_u << 0x6708 << ""), ("".to_u << 0x4e09 << "".to_u << 0x6708 << ""), ("".to_u << 0x56db << "".to_u << 0x6708 << ""), ("".to_u << 0x4e94 << "".to_u << 0x6708 << ""), ("".to_u << 0x516d << "".to_u << 0x6708 << ""), ("".to_u << 0x4e03 << "".to_u << 0x6708 << ""), ("".to_u << 0x516b << "".to_u << 0x6708 << ""), ("".to_u << 0x4e5d << "".to_u << 0x6708 << ""), ("".to_u << 0x5341 << "".to_u << 0x6708 << ""), ("".to_u << 0x5341 << "".to_u << 0x4e00 << "".to_u << 0x6708 << ""), ("".to_u << 0x5341 << "".to_u << 0x4e8c << "".to_u << 0x6708 << ""), ""])]), Array.typed(Object).new(["MonthAbbreviations", Array.typed(String).new([("".to_u << 0x4e00 << "".to_u << 0x6708 << ""), ("".to_u << 0x4e8c << "".to_u << 0x6708 << ""), ("".to_u << 0x4e09 << "".to_u << 0x6708 << ""), ("".to_u << 0x56db << "".to_u << 0x6708 << ""), ("".to_u << 0x4e94 << "".to_u << 0x6708 << ""), ("".to_u << 0x516d << "".to_u << 0x6708 << ""), ("".to_u << 0x4e03 << "".to_u << 0x6708 << ""), ("".to_u << 0x516b << "".to_u << 0x6708 << ""), ("".to_u << 0x4e5d << "".to_u << 0x6708 << ""), ("".to_u << 0x5341 << "".to_u << 0x6708 << ""), ("".to_u << 0x5341 << "".to_u << 0x4e00 << "".to_u << 0x6708 << ""), ("".to_u << 0x5341 << "".to_u << 0x4e8c << "".to_u << 0x6708 << ""), ""])]), Array.typed(Object).new(["DayNames", Array.typed(String).new([("".to_u << 0x661f << "".to_u << 0x671f << "".to_u << 0x65e5 << ""), ("".to_u << 0x661f << "".to_u << 0x671f << "".to_u << 0x4e00 << ""), ("".to_u << 0x661f << "".to_u << 0x671f << "".to_u << 0x4e8c << ""), ("".to_u << 0x661f << "".to_u << 0x671f << "".to_u << 0x4e09 << ""), ("".to_u << 0x661f << "".to_u << 0x671f << "".to_u << 0x56db << ""), ("".to_u << 0x661f << "".to_u << 0x671f << "".to_u << 0x4e94 << ""), ("".to_u << 0x661f << "".to_u << 0x671f << "".to_u << 0x516d << "")])]), Array.typed(Object).new(["DayAbbreviations", Array.typed(String).new([("".to_u << 0x661f << "".to_u << 0x671f << "".to_u << 0x65e5 << ""), ("".to_u << 0x661f << "".to_u << 0x671f << "".to_u << 0x4e00 << ""), ("".to_u << 0x661f << "".to_u << 0x671f << "".to_u << 0x4e8c << ""), ("".to_u << 0x661f << "".to_u << 0x671f << "".to_u << 0x4e09 << ""), ("".to_u << 0x661f << "".to_u << 0x671f << "".to_u << 0x56db << ""), ("".to_u << 0x661f << "".to_u << 0x671f << "".to_u << 0x4e94 << ""), ("".to_u << 0x661f << "".to_u << 0x671f << "".to_u << 0x516d << "")])]), Array.typed(Object).new(["AmPmMarkers", Array.typed(String).new([("".to_u << 0x4e0a << "".to_u << 0x5348 << ""), ("".to_u << 0x4e0b << "".to_u << 0x5348 << "")])]), Array.typed(Object).new(["Eras", Array.typed(String).new([("".to_u << 0x516c << "".to_u << 0x5143 << "".to_u << 0x524d << ""), ("".to_u << 0x516c << "".to_u << 0x5143 << "")])]), Array.typed(Object).new(["DateTimePatterns", Array.typed(String).new([("ahh'".to_u << 0x65f6 << "'mm'".to_u << 0x5206 << "'ss'".to_u << 0x79d2 << "' z"), ("ahh'".to_u << 0x65f6 << "'mm'".to_u << 0x5206 << "'ss'".to_u << 0x79d2 << "'"), "H:mm:ss", "ah:mm", ("yyyy'".to_u << 0x5e74 << "'M'".to_u << 0x6708 << "'d'".to_u << 0x65e5 << "' EEEE"), ("yyyy'".to_u << 0x5e74 << "'M'".to_u << 0x6708 << "'d'".to_u << 0x65e5 << "'"), "yyyy-M-d", "yy-M-d", "{1} {0}"])])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__format_data_zh, :initialize
  end
  
end
