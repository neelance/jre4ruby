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
  module FormatData_trImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class FormatData_tr < FormatData_trImports.const_get :ListResourceBundle
    include_class_members FormatData_trImports
    
    typesig { [] }
    # Overrides ListResourceBundle
    def get_contents
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["MonthNames", Array.typed(String).new(["Ocak", ("".to_u << 0x015e << "ubat"), "Mart", "Nisan", ("May".to_u << 0x0131 << "s"), "Haziran", "Temmuz", ("A".to_u << 0x011f << "ustos"), ("Eyl".to_u << 0x00fc << "l"), "Ekim", ("Kas".to_u << 0x0131 << "m"), ("Aral".to_u << 0x0131 << "k"), ""])]), Array.typed(Object).new(["MonthAbbreviations", Array.typed(String).new(["Oca", ("".to_u << 0x015e << "ub"), "Mar", "Nis", "May", "Haz", "Tem", ("A".to_u << 0x011f << "u"), "Eyl", "Eki", "Kas", "Ara", ""])]), Array.typed(Object).new(["DayNames", Array.typed(String).new(["Pazar", "Pazartesi", ("Sal".to_u << 0x0131 << ""), ("".to_u << 0x00c7 << "ar".to_u << 0x015f << "amba"), ("Per".to_u << 0x015f << "embe"), "Cuma", "Cumartesi"])]), Array.typed(Object).new(["DayAbbreviations", Array.typed(String).new(["Paz", "Pzt", "Sal", ("".to_u << 0x00c7 << "ar"), "Per", "Cum", "Cmt"])]), Array.typed(Object).new(["NumberPatterns", Array.typed(String).new(["#,##0.###;-#,##0.###", ("#,##0.00 ".to_u << 0x00a4 << ";-#,##0.00 ".to_u << 0x00a4 << ""), "% #,##0"])]), Array.typed(Object).new(["NumberElements", Array.typed(String).new([",", ".", ";", "%", "0", "#", "-", "E", ("".to_u << 0x2030 << ""), ("".to_u << 0x221e << ""), ("".to_u << 0xfffd << "")])]), Array.typed(Object).new(["DateTimePatterns", Array.typed(String).new(["HH:mm:ss z", "HH:mm:ss z", "HH:mm:ss", "HH:mm", "dd MMMM yyyy EEEE", "dd MMMM yyyy EEEE", "dd.MMM.yyyy", "dd.MM.yyyy", "{1} {0}"])]), Array.typed(Object).new(["DateTimePatternChars", "GanjkHmsSEDFwWxhKzZ"])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__format_data_tr, :initialize
  end
  
end
