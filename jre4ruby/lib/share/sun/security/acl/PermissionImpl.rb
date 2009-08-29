require "rjava"

# Copyright 1996-1999 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Acl
  module PermissionImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Acl
      include_const ::Java::Security, :Principal
      include ::Java::Security::Acl
    }
  end
  
  # The PermissionImpl class implements the permission
  # interface for permissions that are strings.
  # @author Satish Dharmaraj
  class PermissionImpl 
    include_class_members PermissionImplImports
    include Permission
    
    attr_accessor :permission
    alias_method :attr_permission, :permission
    undef_method :permission
    alias_method :attr_permission=, :permission=
    undef_method :permission=
    
    typesig { [String] }
    # Construct a permission object using a string.
    # @param permission the stringified version of the permission.
    def initialize(permission)
      @permission = nil
      @permission = permission
    end
    
    typesig { [Object] }
    # This function returns true if the object passed matches the permission
    # represented in this interface.
    # @param another The Permission object to compare with.
    # @return true if the Permission objects are equal, false otherwise
    def ==(another)
      if (another.is_a?(Permission))
        p = another
        return (@permission == p.to_s)
      else
        return false
      end
    end
    
    typesig { [] }
    # Prints a stringified version of the permission.
    # @return the string representation of the Permission.
    def to_s
      return @permission
    end
    
    typesig { [] }
    # Returns a hashcode for this PermissionImpl.
    # 
    # @return a hashcode for this PermissionImpl.
    def hash_code
      return to_s.hash_code
    end
    
    private
    alias_method :initialize__permission_impl, :initialize
  end
  
end
