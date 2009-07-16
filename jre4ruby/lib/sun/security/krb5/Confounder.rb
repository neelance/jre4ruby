require "rjava"

# 
# Portions Copyright 2001-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5
  module ConfounderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include_const ::Java::Security, :SecureRandom
    }
  end
  
  class Confounder 
    include_class_members ConfounderImports
    
    class_module.module_eval {
      
      def srand
        defined?(@@srand) ? @@srand : @@srand= SecureRandom.new
      end
      alias_method :attr_srand, :srand
      
      def srand=(value)
        @@srand = value
      end
      alias_method :attr_srand=, :srand=
    }
    
    typesig { [] }
    def initialize
      # not instantiable
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      def bytes(size)
        data = Array.typed(::Java::Byte).new(size) { 0 }
        self.attr_srand.next_bytes(data)
        return data
      end
      
      typesig { [] }
      def int_value
        return self.attr_srand.next_int
      end
      
      typesig { [] }
      def long_value
        return self.attr_srand.next_long
      end
    }
    
    private
    alias_method :initialize__confounder, :initialize
  end
  
end
