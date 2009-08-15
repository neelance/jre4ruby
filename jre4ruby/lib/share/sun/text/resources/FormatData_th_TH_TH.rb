require "rjava"

# Copyright 2002-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Text::Resources
  module FormatData_th_TH_THImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  # This class implements the th_TH_TH requirement that native Thai
  # digits be used in the corresponding locale.
  # 
  # @author John O'Conner
  # @since 1.4.1
  class FormatData_th_TH_TH < FormatData_th_TH_THImports.const_get :ListResourceBundle
    include_class_members FormatData_th_TH_THImports
    
    typesig { [] }
    # Overrides ListResourceBundle
    def get_contents
      # decimal separator
      # group (thousands) separator
      # list separator
      # percent sign
      # native 0 digit
      # pattern digit
      # minus sign
      # exponential
      # per mille
      # infinity
      # NaN
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["NumberElements", Array.typed(String).new([".", ",", ";", "%", ("".to_u << 0x0E50 << ""), "#", "-", "E", ("".to_u << 0x2030 << ""), ("".to_u << 0x221e << ""), ("".to_u << 0xfffd << "")])]), ])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__format_data_th_th_th, :initialize
  end
  
end
