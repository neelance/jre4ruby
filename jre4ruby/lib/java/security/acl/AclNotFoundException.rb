require "rjava"

# Copyright 1996-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security::Acl
  module AclNotFoundExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Acl
    }
  end
  
  # This is an exception that is thrown whenever a reference is made to a
  # non-existent ACL (Access Control List).
  # 
  # @author      Satish Dharmaraj
  class AclNotFoundException < AclNotFoundExceptionImports.const_get :Exception
    include_class_members AclNotFoundExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 5684295034092681791 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Constructs an AclNotFoundException.
    def initialize
      super()
    end
    
    private
    alias_method :initialize__acl_not_found_exception, :initialize
  end
  
end
