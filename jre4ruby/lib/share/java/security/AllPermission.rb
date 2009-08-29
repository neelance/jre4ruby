require "rjava"

# Copyright 1998-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security
  module AllPermissionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Security
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :StringTokenizer
      include_const ::Sun::Security::Util, :SecurityConstants
    }
  end
  
  # The AllPermission is a permission that implies all other permissions.
  # <p>
  # <b>Note:</b> Granting AllPermission should be done with extreme care,
  # as it implies all other permissions. Thus, it grants code the ability
  # to run with security
  # disabled.  Extreme caution should be taken before granting such
  # a permission to code.  This permission should be used only during testing,
  # or in extremely rare cases where an application or applet is
  # completely trusted and adding the necessary permissions to the policy
  # is prohibitively cumbersome.
  # 
  # @see java.security.Permission
  # @see java.security.AccessController
  # @see java.security.Permissions
  # @see java.security.PermissionCollection
  # @see java.lang.SecurityManager
  # 
  # 
  # @author Roland Schemers
  # 
  # @serial exclude
  class AllPermission < AllPermissionImports.const_get :Permission
    include_class_members AllPermissionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -2916474571451318075 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Creates a new AllPermission object.
    def initialize
      super("<all permissions>")
    end
    
    typesig { [String, String] }
    # Creates a new AllPermission object. This
    # constructor exists for use by the <code>Policy</code> object
    # to instantiate new Permission objects.
    # 
    # @param name ignored
    # @param actions ignored.
    def initialize(name, actions)
      initialize__all_permission()
    end
    
    typesig { [Permission] }
    # Checks if the specified permission is "implied" by
    # this object. This method always returns true.
    # 
    # @param p the permission to check against.
    # 
    # @return return
    def implies(p)
      return true
    end
    
    typesig { [Object] }
    # Checks two AllPermission objects for equality. Two AllPermission
    # objects are always equal.
    # 
    # @param obj the object we are testing for equality with this object.
    # @return true if <i>obj</i> is an AllPermission, false otherwise.
    def ==(obj)
      return (obj.is_a?(AllPermission))
    end
    
    typesig { [] }
    # Returns the hash code value for this object.
    # 
    # @return a hash code value for this object.
    def hash_code
      return 1
    end
    
    typesig { [] }
    # Returns the canonical string representation of the actions.
    # 
    # @return the actions.
    def get_actions
      return "<all actions>"
    end
    
    typesig { [] }
    # Returns a new PermissionCollection object for storing AllPermission
    # objects.
    # <p>
    # 
    # @return a new PermissionCollection object suitable for
    # storing AllPermissions.
    def new_permission_collection
      return AllPermissionCollection.new
    end
    
    private
    alias_method :initialize__all_permission, :initialize
  end
  
  # A AllPermissionCollection stores a collection
  # of AllPermission permissions. AllPermission objects
  # must be stored in a manner that allows them to be inserted in any
  # order, but enable the implies function to evaluate the implies
  # method in an efficient (and consistent) manner.
  # 
  # @see java.security.Permission
  # @see java.security.Permissions
  # 
  # 
  # @author Roland Schemers
  # 
  # @serial include
  class AllPermissionCollection < AllPermissionImports.const_get :PermissionCollection
    include_class_members AllPermissionImports
    overload_protected {
      include Java::Io::Serializable
    }
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.2.2 for interoperability
      const_set_lazy(:SerialVersionUID) { -4023755556366636806 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :all_allowed
    alias_method :attr_all_allowed, :all_allowed
    undef_method :all_allowed
    alias_method :attr_all_allowed=, :all_allowed=
    undef_method :all_allowed=
    
    typesig { [] }
    # true if any all permissions have been added
    # 
    # Create an empty AllPermissions object.
    def initialize
      @all_allowed = false
      super()
      @all_allowed = false
    end
    
    typesig { [Permission] }
    # Adds a permission to the AllPermissions. The key for the hash is
    # permission.path.
    # 
    # @param permission the Permission object to add.
    # 
    # @exception IllegalArgumentException - if the permission is not a
    # AllPermission
    # 
    # @exception SecurityException - if this AllPermissionCollection object
    # has been marked readonly
    def add(permission)
      if (!(permission.is_a?(AllPermission)))
        raise IllegalArgumentException.new("invalid permission: " + RJava.cast_to_string(permission))
      end
      if (is_read_only)
        raise SecurityException.new("attempt to add a Permission to a readonly PermissionCollection")
      end
      @all_allowed = true # No sync; staleness OK
    end
    
    typesig { [Permission] }
    # Check and see if this set of permissions implies the permissions
    # expressed in "permission".
    # 
    # @param p the Permission object to compare
    # 
    # @return always returns true.
    def implies(permission)
      return @all_allowed # No sync; staleness OK
    end
    
    typesig { [] }
    # Returns an enumeration of all the AllPermission objects in the
    # container.
    # 
    # @return an enumeration of all the AllPermission objects.
    def elements
      return Class.new(Enumeration.class == Class ? Enumeration : Object) do
        extend LocalClass
        include_class_members AllPermissionCollection
        include Enumeration if Enumeration.class == Module
        
        attr_accessor :has_more
        alias_method :attr_has_more, :has_more
        undef_method :has_more
        alias_method :attr_has_more=, :has_more=
        undef_method :has_more=
        
        typesig { [] }
        define_method :has_more_elements do
          return @has_more
        end
        
        typesig { [] }
        define_method :next_element do
          @has_more = false
          return SecurityConstants::ALL_PERMISSION
        end
        
        typesig { [] }
        define_method :initialize do
          @has_more = false
          super()
          @has_more = self.attr_all_allowed
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    private
    alias_method :initialize__all_permission_collection, :initialize
  end
  
end
