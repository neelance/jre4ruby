require "rjava"

# Portions Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 1996-2003 - All Rights Reserved                     *
#                                                                             *
# The original version of this source code and documentation is copyrighted   *
# and owned by IBM, These materials are provided under terms of a License     *
# Agreement between IBM and Sun. This technology is protected by multiple     *
# US and International patents. This notice and attribution to IBM may not    *
# to removed.                                                                 *
# *****************************************************************************
# 
# This locale data is based on the ICU's Vietnamese locale data (rev. 1.38)
# found at:
# 
# http://oss.software.ibm.com/cvs/icu/icu/source/data/locales/vi.txt?rev=1.38
module Sun::Text::Resources
  module FormatData_viImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class FormatData_vi < FormatData_viImports.const_get :ListResourceBundle
    include_class_members FormatData_viImports
    
    typesig { [] }
    # Overrides ListResourceBundle
    def get_contents
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["MonthNames", Array.typed(String).new([("th".to_u << 0x00e1 << "ng m".to_u << 0x1ed9 << "t"), ("th".to_u << 0x00e1 << "ng hai"), ("th".to_u << 0x00e1 << "ng ba"), ("th".to_u << 0x00e1 << "ng t".to_u << 0x01b0 << ""), ("th".to_u << 0x00e1 << "ng n".to_u << 0x0103 << "m"), ("th".to_u << 0x00e1 << "ng s".to_u << 0x00e1 << "u"), ("th".to_u << 0x00e1 << "ng b".to_u << 0x1ea3 << "y"), ("th".to_u << 0x00e1 << "ng t".to_u << 0x00e1 << "m"), ("th".to_u << 0x00e1 << "ng ch".to_u << 0x00ed << "n"), ("th".to_u << 0x00e1 << "ng m".to_u << 0x01b0 << "".to_u << 0x1edd << "i"), ("th".to_u << 0x00e1 << "ng m".to_u << 0x01b0 << "".to_u << 0x1edd << "i m".to_u << 0x1ed9 << "t"), ("th".to_u << 0x00e1 << "ng m".to_u << 0x01b0 << "".to_u << 0x1edd << "i hai"), ""])]), Array.typed(Object).new(["MonthAbbreviations", Array.typed(String).new(["thg 1", "thg 2", "thg 3", "thg 4", "thg 5", "thg 6", "thg 7", "thg 8", "thg 9", "thg 10", "thg 11", "thg 12", ""])]), Array.typed(Object).new(["DayNames", Array.typed(String).new([("Ch".to_u << 0x1ee7 << " nh".to_u << 0x1ead << "t"), ("Th".to_u << 0x1ee9 << " hai"), ("Th".to_u << 0x1ee9 << " ba"), ("Th".to_u << 0x1ee9 << " t".to_u << 0x01b0 << ""), ("Th".to_u << 0x1ee9 << " n".to_u << 0x0103 << "m"), ("Th".to_u << 0x1ee9 << " s".to_u << 0x00e1 << "u"), ("Th".to_u << 0x1ee9 << " b".to_u << 0x1ea3 << "y")])]), Array.typed(Object).new(["DayAbbreviations", Array.typed(String).new(["CN", "Th 2", "Th 3", "Th 4", "Th 5", "Th 6", "Th 7"])]), Array.typed(Object).new(["AmPmMarkers", Array.typed(String).new(["SA", "CH"])]), Array.typed(Object).new(["Eras", Array.typed(String).new(["tr. CN", "sau CN"])]), Array.typed(Object).new(["NumberElements", Array.typed(String).new([",", ".", ";", "%", "0", "#", "-", "E", ("".to_u << 0x2030 << ""), ("".to_u << 0x221e << ""), ("".to_u << 0xfffd << "")])]), Array.typed(Object).new(["DateTimePatterns", Array.typed(String).new(["HH:mm:ss z", "HH:mm:ss z", "HH:mm:ss", "HH:mm", ("EEEE, 'ng".to_u << 0x00E0 << "y' dd MMMM 'n".to_u << 0x0103 << "m' yyyy"), ("'Ng".to_u << 0x00E0 << "y' dd 'th".to_u << 0x00E1 << "ng' M 'n".to_u << 0x0103 << "m' yyyy"), "dd-MM-yyyy", "dd/MM/yyyy", "{0} {1}"])])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__format_data_vi, :initialize
  end
  
end
