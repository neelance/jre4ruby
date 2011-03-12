require "rjava"

# Portions Copyright 1999-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# Copyright (c) 1998 International Business Machines.
# All Rights Reserved.
module Sun::Util::Resources
  module TimeZoneNames_hiImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util::Resources
    }
  end
  
  class TimeZoneNames_hi < TimeZoneNames_hiImports.const_get :TimeZoneNamesBundle
    include_class_members TimeZoneNames_hiImports
    
    typesig { [] }
    def get_contents
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["Asia/Calcutta", Array.typed(String).new([("".to_u << 0x092d << "".to_u << 0x093e << "".to_u << 0x0930 << "".to_u << 0x0924 << "".to_u << 0x0940 << "".to_u << 0x092f << " ".to_u << 0x0938 << "".to_u << 0x092e << "".to_u << 0x092f << ""), "IST", ("".to_u << 0x092d << "".to_u << 0x093e << "".to_u << 0x0930 << "".to_u << 0x0924 << "".to_u << 0x0940 << "".to_u << 0x092f << " ".to_u << 0x0938 << "".to_u << 0x092e << "".to_u << 0x092f << ""), "IST"])])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__time_zone_names_hi, :initialize
  end
  
end
