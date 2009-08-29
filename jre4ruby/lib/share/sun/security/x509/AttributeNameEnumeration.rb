require "rjava"

# Copyright 1997-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::X509
  module AttributeNameEnumerationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :Enumeration
    }
  end
  
  # <p>This class provides the Enumeration implementation used
  # by all the X509 certificate attributes to return the attribute
  # names contained within them.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class AttributeNameEnumeration < AttributeNameEnumerationImports.const_get :Vector
    include_class_members AttributeNameEnumerationImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -6067440240757099134 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # The default constructor for this class.
    def initialize
      super(4, 2)
    end
    
    private
    alias_method :initialize__attribute_name_enumeration, :initialize
  end
  
end
