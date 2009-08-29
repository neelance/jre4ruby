require "rjava"

# Copyright 1996 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PermissionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Acl
    }
  end
  
  # This interface represents a permission, such as that used to grant
  # a particular type of access to a resource.
  # 
  # @author Satish Dharmaraj
  module Permission
    include_class_members PermissionImports
    
    typesig { [Object] }
    # Returns true if the object passed matches the permission represented
    # in this interface.
    # 
    # @param another the Permission object to compare with.
    # 
    # @return true if the Permission objects are equal, false otherwise
    def ==(another)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Prints a string representation of this permission.
    # 
    # @return the string representation of the permission.
    def to_s
      raise NotImplementedError
    end
  end
  
end
