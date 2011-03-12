require "rjava"

# Portions Copyright 1999-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Text::Resources
  module FormatData_hi_INImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  # The locale elements for Hindi.
  class FormatData_hi_IN < FormatData_hi_INImports.const_get :ListResourceBundle
    include_class_members FormatData_hi_INImports
    
    typesig { [] }
    # Overrides ListResourceBundle
    def get_contents
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["MonthNames", Array.typed(String).new([("".to_u << 0x091c << "".to_u << 0x0928 << "".to_u << 0x0935 << "".to_u << 0x0930 << "".to_u << 0x0940 << ""), ("".to_u << 0x092b << "".to_u << 0x093c << "".to_u << 0x0930 << "".to_u << 0x0935 << "".to_u << 0x0930 << "".to_u << 0x0940 << ""), ("".to_u << 0x092e << "".to_u << 0x093e << "".to_u << 0x0930 << "".to_u << 0x094d << "".to_u << 0x091a << ""), ("".to_u << 0x0905 << "".to_u << 0x092a << "".to_u << 0x094d << "".to_u << 0x0930 << "".to_u << 0x0948 << "".to_u << 0x0932 << ""), ("".to_u << 0x092e << "".to_u << 0x0908 << ""), ("".to_u << 0x091c << "".to_u << 0x0942 << "".to_u << 0x0928 << ""), ("".to_u << 0x091c << "".to_u << 0x0941 << "".to_u << 0x0932 << "".to_u << 0x093e << "".to_u << 0x0908 << ""), ("".to_u << 0x0905 << "".to_u << 0x0917 << "".to_u << 0x0938 << "".to_u << 0x094d << "".to_u << 0x0924 << ""), ("".to_u << 0x0938 << "".to_u << 0x093f << "".to_u << 0x0924 << "".to_u << 0x0902 << "".to_u << 0x092c << "".to_u << 0x0930 << ""), ("".to_u << 0x0905 << "".to_u << 0x0915 << "".to_u << 0x094d << "".to_u << 0x200d << "".to_u << 0x0924 << "".to_u << 0x0942 << "".to_u << 0x092c << "".to_u << 0x0930 << ""), ("".to_u << 0x0928 << "".to_u << 0x0935 << "".to_u << 0x0902 << "".to_u << 0x092c << "".to_u << 0x0930 << ""), ("".to_u << 0x0926 << "".to_u << 0x093f << "".to_u << 0x0938 << "".to_u << 0x0902 << "".to_u << 0x092c << "".to_u << 0x0930 << ""), ""])]), Array.typed(Object).new(["MonthAbbreviations", Array.typed(String).new([("".to_u << 0x091c << "".to_u << 0x0928 << "".to_u << 0x0935 << "".to_u << 0x0930 << "".to_u << 0x0940 << ""), ("".to_u << 0x092b << "".to_u << 0x093c << "".to_u << 0x0930 << "".to_u << 0x0935 << "".to_u << 0x0930 << "".to_u << 0x0940 << ""), ("".to_u << 0x092e << "".to_u << 0x093e << "".to_u << 0x0930 << "".to_u << 0x094d << "".to_u << 0x091a << ""), ("".to_u << 0x0905 << "".to_u << 0x092a << "".to_u << 0x094d << "".to_u << 0x0930 << "".to_u << 0x0948 << "".to_u << 0x0932 << ""), ("".to_u << 0x092e << "".to_u << 0x0908 << ""), ("".to_u << 0x091c << "".to_u << 0x0942 << "".to_u << 0x0928 << ""), ("".to_u << 0x091c << "".to_u << 0x0941 << "".to_u << 0x0932 << "".to_u << 0x093e << "".to_u << 0x0908 << ""), ("".to_u << 0x0905 << "".to_u << 0x0917 << "".to_u << 0x0938 << "".to_u << 0x094d << "".to_u << 0x0924 << ""), ("".to_u << 0x0938 << "".to_u << 0x093f << "".to_u << 0x0924 << "".to_u << 0x0902 << "".to_u << 0x092c << "".to_u << 0x0930 << ""), ("".to_u << 0x0905 << "".to_u << 0x0915 << "".to_u << 0x094d << "".to_u << 0x200d << "".to_u << 0x0924 << "".to_u << 0x0942 << "".to_u << 0x092c << "".to_u << 0x0930 << ""), ("".to_u << 0x0928 << "".to_u << 0x0935 << "".to_u << 0x0902 << "".to_u << 0x092c << "".to_u << 0x0930 << ""), ("".to_u << 0x0926 << "".to_u << 0x093f << "".to_u << 0x0938 << "".to_u << 0x0902 << "".to_u << 0x092c << "".to_u << 0x0930 << ""), ""])]), Array.typed(Object).new(["DayNames", Array.typed(String).new([("".to_u << 0x0930 << "".to_u << 0x0935 << "".to_u << 0x093f << "".to_u << 0x0935 << "".to_u << 0x093e << "".to_u << 0x0930 << ""), ("".to_u << 0x0938 << "".to_u << 0x094b << "".to_u << 0x092e << "".to_u << 0x0935 << "".to_u << 0x093e << "".to_u << 0x0930 << ""), ("".to_u << 0x092e << "".to_u << 0x0902 << "".to_u << 0x0917 << "".to_u << 0x0932 << "".to_u << 0x0935 << "".to_u << 0x093e << "".to_u << 0x0930 << ""), ("".to_u << 0x092c << "".to_u << 0x0941 << "".to_u << 0x0927 << "".to_u << 0x0935 << "".to_u << 0x093e << "".to_u << 0x0930 << ""), ("".to_u << 0x0917 << "".to_u << 0x0941 << "".to_u << 0x0930 << "".to_u << 0x0941 << "".to_u << 0x0935 << "".to_u << 0x093e << "".to_u << 0x0930 << ""), ("".to_u << 0x0936 << "".to_u << 0x0941 << "".to_u << 0x0915 << "".to_u << 0x094d << "".to_u << 0x0930 << "".to_u << 0x0935 << "".to_u << 0x093e << "".to_u << 0x0930 << ""), ("".to_u << 0x0936 << "".to_u << 0x0928 << "".to_u << 0x093f << "".to_u << 0x0935 << "".to_u << 0x093e << "".to_u << 0x0930 << "")])]), Array.typed(Object).new(["DayAbbreviations", Array.typed(String).new([("".to_u << 0x0930 << "".to_u << 0x0935 << "".to_u << 0x093f << ""), ("".to_u << 0x0938 << "".to_u << 0x094b << "".to_u << 0x092e << ""), ("".to_u << 0x092e << "".to_u << 0x0902 << "".to_u << 0x0917 << "".to_u << 0x0932 << ""), ("".to_u << 0x092c << "".to_u << 0x0941 << "".to_u << 0x0927 << ""), ("".to_u << 0x0917 << "".to_u << 0x0941 << "".to_u << 0x0930 << "".to_u << 0x0941 << ""), ("".to_u << 0x0936 << "".to_u << 0x0941 << "".to_u << 0x0915 << "".to_u << 0x094d << "".to_u << 0x0930 << ""), ("".to_u << 0x0936 << "".to_u << 0x0928 << "".to_u << 0x093f << "")])]), Array.typed(Object).new(["AmPmMarkers", Array.typed(String).new([("".to_u << 0x092a << "".to_u << 0x0942 << "".to_u << 0x0930 << "".to_u << 0x094d << "".to_u << 0x0935 << "".to_u << 0x093e << "".to_u << 0x0939 << "".to_u << 0x094d << "".to_u << 0x0928 << ""), ("".to_u << 0x0905 << "".to_u << 0x092a << "".to_u << 0x0930 << "".to_u << 0x093e << "".to_u << 0x0939 << "".to_u << 0x094d << "".to_u << 0x0928 << "")])]), Array.typed(Object).new(["Eras", Array.typed(String).new([("".to_u << 0x0908 << "".to_u << 0x0938 << "".to_u << 0x093e << "".to_u << 0x092a << "".to_u << 0x0942 << "".to_u << 0x0930 << "".to_u << 0x094d << "".to_u << 0x0935 << ""), ("".to_u << 0x0938 << "".to_u << 0x0928 << "")])]), Array.typed(Object).new(["NumberElements", Array.typed(String).new([".", ",", ";", "%", ("".to_u << 0x0966 << ""), "#", "-", "E", ("".to_u << 0x2030 << ""), ("".to_u << 0x221e << ""), ("".to_u << 0xfffd << "")])]), Array.typed(Object).new(["DateTimePatterns", Array.typed(String).new(["h:mm:ss a z", "h:mm:ss a z", "h:mm:ss a", "h:mm a", "EEEE, d MMMM, yyyy", "d MMMM, yyyy", "d MMM, yyyy", "d/M/yy", "{1} {0}"])]), Array.typed(Object).new(["DateTimePatternChars", "GyMdkHmsSEDFwWahKzZ"])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__format_data_hi_in, :initialize
  end
  
end
