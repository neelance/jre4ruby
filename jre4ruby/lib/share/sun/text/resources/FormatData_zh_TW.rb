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
  module FormatData_zh_TWImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class FormatData_zh_TW < FormatData_zh_TWImports.const_get :ListResourceBundle
    include_class_members FormatData_zh_TWImports
    
    typesig { [] }
    # Overrides ListResourceBundle
    def get_contents
      # era strings
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
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["Eras", Array.typed(String).new([("".to_u << 0x897f << "".to_u << 0x5143 << "".to_u << 0x524d << ""), ("".to_u << 0x897f << "".to_u << 0x5143 << "")])]), Array.typed(Object).new(["NumberPatterns", Array.typed(String).new(["#,##0.###;-#,##0.###", ("".to_u << 0x00A4 << "#,##0.00;-".to_u << 0x00A4 << "#,##0.00"), "#,##0%"])]), Array.typed(Object).new(["DateTimePatterns", Array.typed(String).new([("ahh'".to_u << 0x6642 << "'mm'".to_u << 0x5206 << "'ss'".to_u << 0x79d2 << "' z"), ("ahh'".to_u << 0x6642 << "'mm'".to_u << 0x5206 << "'ss'".to_u << 0x79d2 << "'"), "a hh:mm:ss", "a h:mm", ("yyyy'".to_u << 0x5e74 << "'M'".to_u << 0x6708 << "'d'".to_u << 0x65e5 << "' EEEE"), ("yyyy'".to_u << 0x5e74 << "'M'".to_u << 0x6708 << "'d'".to_u << 0x65e5 << "'"), "yyyy/M/d", "yyyy/M/d", "{1} {0}"])]), Array.typed(Object).new(["DateTimePatternChars", "GyMdkHmsSEDFwWahKzZ"]), ])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__format_data_zh_tw, :initialize
  end
  
end
