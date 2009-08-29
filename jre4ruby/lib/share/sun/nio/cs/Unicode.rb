require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Cs
  module UnicodeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include_const ::Java::Nio::Charset, :Charset
    }
  end
  
  class Unicode < UnicodeImports.const_get :Charset
    include_class_members UnicodeImports
    overload_protected {
      include HistoricallyNamedCharset
    }
    
    typesig { [String, Array.typed(String)] }
    def initialize(name, aliases)
      super(name, aliases)
    end
    
    typesig { [Charset] }
    def contains(cs)
      return ((cs.is_a?(US_ASCII)) || (cs.is_a?(ISO_8859_1)) || (cs.is_a?(ISO_8859_15)) || (cs.is_a?(MS1252)) || (cs.is_a?(UTF_8)) || (cs.is_a?(UTF_16)) || (cs.is_a?(UTF_16BE)) || (cs.is_a?(UTF_16LE)) || (cs.is_a?(UTF_16LE_BOM)) || ((cs.name == "GBK")) || ((cs.name == "GB18030")) || ((cs.name == "ISO-8859-2")) || ((cs.name == "ISO-8859-3")) || ((cs.name == "ISO-8859-4")) || ((cs.name == "ISO-8859-5")) || ((cs.name == "ISO-8859-6")) || ((cs.name == "ISO-8859-7")) || ((cs.name == "ISO-8859-8")) || ((cs.name == "ISO-8859-9")) || ((cs.name == "ISO-8859-13")) || ((cs.name == "JIS_X0201")) || ((cs.name == "x-JIS0208")) || ((cs.name == "JIS_X0212-1990")) || ((cs.name == "GB2312")) || ((cs.name == "EUC-KR")) || ((cs.name == "x-EUC-TW")) || ((cs.name == "EUC-JP")) || ((cs.name == "x-euc-jp-linux")) || ((cs.name == "KOI8-R")) || ((cs.name == "TIS-620")) || ((cs.name == "x-ISCII91")) || ((cs.name == "windows-1251")) || ((cs.name == "windows-1253")) || ((cs.name == "windows-1254")) || ((cs.name == "windows-1255")) || ((cs.name == "windows-1256")) || ((cs.name == "windows-1257")) || ((cs.name == "windows-1258")) || ((cs.name == "windows-932")) || ((cs.name == "x-mswin-936")) || ((cs.name == "x-windows-949")) || ((cs.name == "x-windows-950")) || ((cs.name == "windows-31j")) || ((cs.name == "Big5")) || ((cs.name == "Big5-HKSCS")) || ((cs.name == "x-MS950-HKSCS")) || ((cs.name == "ISO-2022-JP")) || ((cs.name == "ISO-2022-KR")) || ((cs.name == "x-ISO-2022-CN-CNS")) || ((cs.name == "x-ISO-2022-CN-GB")) || ((cs.name == "Big5-HKSCS")) || ((cs.name == "x-Johab")) || ((cs.name == "Shift_JIS")))
    end
    
    private
    alias_method :initialize__unicode, :initialize
  end
  
end
