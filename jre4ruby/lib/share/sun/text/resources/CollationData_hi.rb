require "rjava"

# Portions Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CollationData_hiImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class CollationData_hi < CollationData_hiImports.const_get :ListResourceBundle
    include_class_members CollationData_hiImports
    
    typesig { [] }
    def get_contents
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["Rule", "" + ("< ".to_u << 0x0901 << " < ".to_u << 0x0902 << " < ".to_u << 0x0903 << " < ".to_u << 0x0905 << "") + ("< ".to_u << 0x0906 << " < ".to_u << 0x0907 << " < ".to_u << 0x0908 << " < ".to_u << 0x0909 << "") + ("< ".to_u << 0x090a << " < ".to_u << 0x090b << " < ".to_u << 0x0960 << " < ".to_u << 0x090e << "") + ("< ".to_u << 0x090f << " < ".to_u << 0x090c << " < ".to_u << 0x0961 << " < ".to_u << 0x0910 << "") + ("< ".to_u << 0x090d << " < ".to_u << 0x0912 << " < ".to_u << 0x0913 << " < ".to_u << 0x0914 << "") + ("< ".to_u << 0x0911 << " < ".to_u << 0x0915 << " < ".to_u << 0x0958 << " < ".to_u << 0x0916 << "") + ("< ".to_u << 0x0959 << " < ".to_u << 0x0917 << " < ".to_u << 0x095a << " < ".to_u << 0x0918 << "") + ("< ".to_u << 0x0919 << " < ".to_u << 0x091a << " < ".to_u << 0x091b << " < ".to_u << 0x091c << "") + ("< ".to_u << 0x095b << " < ".to_u << 0x091d << " < ".to_u << 0x091e << " < ".to_u << 0x091f << "") + ("< ".to_u << 0x0920 << " < ".to_u << 0x0921 << " < ".to_u << 0x095c << " < ".to_u << 0x0922 << "") + ("< ".to_u << 0x095d << " < ".to_u << 0x0923 << " < ".to_u << 0x0924 << " < ".to_u << 0x0925 << "") + ("< ".to_u << 0x0926 << " < ".to_u << 0x0927 << " < ".to_u << 0x0928 << " < ".to_u << 0x0929 << "") + ("< ".to_u << 0x092a << " < ".to_u << 0x092b << " < ".to_u << 0x095e << " < ".to_u << 0x092c << "") + ("< ".to_u << 0x092d << " < ".to_u << 0x092e << " < ".to_u << 0x092f << " < ".to_u << 0x095f << "") + ("< ".to_u << 0x0930 << " < ".to_u << 0x0931 << " < ".to_u << 0x0932 << " < ".to_u << 0x0933 << "") + ("< ".to_u << 0x0934 << " < ".to_u << 0x0935 << " < ".to_u << 0x0936 << " < ".to_u << 0x0937 << "") + ("< ".to_u << 0x0938 << " < ".to_u << 0x0939 << " < ".to_u << 0x093e << " < ".to_u << 0x093f << "") + ("< ".to_u << 0x0940 << " < ".to_u << 0x0941 << " < ".to_u << 0x0942 << " < ".to_u << 0x0943 << "") + ("< ".to_u << 0x0944 << " < ".to_u << 0x0946 << " < ".to_u << 0x0947 << " < ".to_u << 0x0948 << "") + ("< ".to_u << 0x0945 << " < ".to_u << 0x094a << " < ".to_u << 0x094b << " < ".to_u << 0x094c << "") + ("< ".to_u << 0x0949 << " < ".to_u << 0x094d << " < ".to_u << 0x093c << " < ".to_u << 0x093d << "") + ("< ".to_u << 0x0950 << " < ".to_u << 0x0951 << " < ".to_u << 0x0952 << " < ".to_u << 0x0953 << "") + ("< ".to_u << 0x0954 << " < ".to_u << 0x0962 << " < ".to_u << 0x0963 << " < ".to_u << 0x0964 << "") + ("< ".to_u << 0x0965 << " < ".to_u << 0x0966 << " < ".to_u << 0x0967 << " < ".to_u << 0x0968 << "") + ("< ".to_u << 0x0969 << " < ".to_u << 0x096a << " < ".to_u << 0x096b << " < ".to_u << 0x096c << "") + ("< ".to_u << 0x096d << " < ".to_u << 0x096e << " < ".to_u << 0x096f << " < ".to_u << 0x0970 << "")])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__collation_data_hi, :initialize
  end
  
end
