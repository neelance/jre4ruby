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
  module FormatData_huImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class FormatData_hu < FormatData_huImports.const_get :ListResourceBundle
    include_class_members FormatData_huImports
    
    typesig { [] }
    # Overrides ListResourceBundle
    def get_contents
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["MonthNames", Array.typed(String).new([("janu".to_u << 0x00e1 << "r"), ("febru".to_u << 0x00e1 << "r"), ("m".to_u << 0x00e1 << "rcius"), ("".to_u << 0x00e1 << "prilis"), ("m".to_u << 0x00e1 << "jus"), ("j".to_u << 0x00fa << "nius"), ("j".to_u << 0x00fa << "lius"), "augusztus", "szeptember", ("okt".to_u << 0x00f3 << "ber"), "november", "december", ""])]), Array.typed(Object).new(["MonthAbbreviations", Array.typed(String).new(["jan.", "febr.", ("m".to_u << 0x00e1 << "rc."), ("".to_u << 0x00e1 << "pr."), ("m".to_u << 0x00e1 << "j."), ("j".to_u << 0x00fa << "n."), ("j".to_u << 0x00fa << "l."), "aug.", "szept.", "okt.", "nov.", "dec.", ""])]), Array.typed(Object).new(["DayNames", Array.typed(String).new([("vas".to_u << 0x00e1 << "rnap"), ("h".to_u << 0x00e9 << "tf".to_u << 0x0151 << ""), "kedd", "szerda", ("cs".to_u << 0x00fc << "t".to_u << 0x00f6 << "rt".to_u << 0x00f6 << "k"), ("p".to_u << 0x00e9 << "ntek"), "szombat"])]), Array.typed(Object).new(["DayAbbreviations", Array.typed(String).new(["V", "H", "K", "Sze", "Cs", "P", "Szo"])]), Array.typed(Object).new(["AmPmMarkers", Array.typed(String).new(["DE", "DU"])]), Array.typed(Object).new(["Eras", Array.typed(String).new(["i.e.", "i.u."])]), Array.typed(Object).new(["NumberElements", Array.typed(String).new([",", ("".to_u << 0x00a0 << ""), ";", "%", "0", "#", "-", "E", ("".to_u << 0x2030 << ""), ("".to_u << 0x221e << ""), ("".to_u << 0xfffd << "")])]), Array.typed(Object).new(["DateTimePatterns", Array.typed(String).new(["H:mm:ss z", "H:mm:ss z", "H:mm:ss", "H:mm", "yyyy. MMMM d.", "yyyy. MMMM d.", "yyyy.MM.dd.", "yyyy.MM.dd.", "{1} {0}"])]), Array.typed(Object).new(["DateTimePatternChars", "GanjkHmsSEDFwWxhKzZ"])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__format_data_hu, :initialize
  end
  
end
