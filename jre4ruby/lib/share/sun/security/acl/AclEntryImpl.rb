require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AclEntryImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Acl
      include ::Java::Util
      include ::Java::Io
      include_const ::Java::Security, :Principal
      include ::Java::Security::Acl
    }
  end
  
  # This is a class that describes one entry that associates users
  # or groups with permissions in the ACL.
  # The entry may be used as a way of granting or denying permissions.
  # @author      Satish Dharmaraj
  class AclEntryImpl 
    include_class_members AclEntryImplImports
    include AclEntry
    
    attr_accessor :user
    alias_method :attr_user, :user
    undef_method :user
    alias_method :attr_user=, :user=
    undef_method :user=
    
    attr_accessor :permission_set
    alias_method :attr_permission_set, :permission_set
    undef_method :permission_set
    alias_method :attr_permission_set=, :permission_set=
    undef_method :permission_set=
    
    attr_accessor :negative
    alias_method :attr_negative, :negative
    undef_method :negative
    alias_method :attr_negative=, :negative=
    undef_method :negative=
    
    typesig { [Principal] }
    # Construct an ACL entry that associates a user with permissions
    # in the ACL.
    # @param user The user that is associated with this entry.
    def initialize(user)
      @user = nil
      @permission_set = Vector.new(10, 10)
      @negative = false
      @user = user
    end
    
    typesig { [] }
    # Construct a null ACL entry
    def initialize
      @user = nil
      @permission_set = Vector.new(10, 10)
      @negative = false
    end
    
    typesig { [Principal] }
    # Sets the principal in the entity. If a group or a
    # principal had already been set, a false value is
    # returned, otherwise a true value is returned.
    # @param user The user that is associated with this entry.
    # @return true if the principal is set, false if there is
    # one already.
    def set_principal(user)
      if (!(@user).nil?)
        return false
      end
      @user = user
      return true
    end
    
    typesig { [] }
    # This method sets the ACL to have negative permissions.
    # That is the user or group is denied the permission set
    # specified in the entry.
    def set_negative_permissions
      @negative = true
    end
    
    typesig { [] }
    # Returns true if this is a negative ACL.
    def is_negative
      return @negative
    end
    
    typesig { [Permission] }
    # A principal or a group can be associated with multiple
    # permissions. This method adds a permission to the ACL entry.
    # @param permission The permission to be associated with
    # the principal or the group in the entry.
    # @return true if the permission was added, false if the
    # permission was already part of the permission set.
    def add_permission(permission)
      if (@permission_set.contains(permission))
        return false
      end
      @permission_set.add_element(permission)
      return true
    end
    
    typesig { [Permission] }
    # The method disassociates the permission from the Principal
    # or the Group in this ACL entry.
    # @param permission The permission to be disassociated with
    # the principal or the group in the entry.
    # @return true if the permission is removed, false if the
    # permission is not part of the permission set.
    def remove_permission(permission)
      return @permission_set.remove_element(permission)
    end
    
    typesig { [Permission] }
    # Checks if the passed permission is part of the allowed
    # permission set in this entry.
    # @param permission The permission that has to be part of
    # the permission set in the entry.
    # @return true if the permission passed is part of the
    # permission set in the entry, false otherwise.
    def check_permission(permission)
      return @permission_set.contains(permission)
    end
    
    typesig { [] }
    # return an enumeration of the permissions in this ACL entry.
    def permissions
      return @permission_set.elements
    end
    
    typesig { [] }
    # Return a string representation of  the contents of the ACL entry.
    def to_s
      s = StringBuffer.new
      if (@negative)
        s.append("-")
      else
        s.append("+")
      end
      if (@user.is_a?(Group))
        s.append("Group.")
      else
        s.append("User.")
      end
      s.append(RJava.cast_to_string(@user) + "=")
      e = permissions
      while (e.has_more_elements)
        p = e.next_element
        s.append(p)
        if (e.has_more_elements)
          s.append(",")
        end
      end
      return String.new(s)
    end
    
    typesig { [] }
    # Clones an AclEntry.
    def clone
      synchronized(self) do
        cloned = nil
        cloned = AclEntryImpl.new(@user)
        cloned.attr_permission_set = @permission_set.clone
        cloned.attr_negative = @negative
        return cloned
      end
    end
    
    typesig { [] }
    # Return the Principal associated in this ACL entry.
    # The method returns null if the entry uses a group
    # instead of a principal.
    def get_principal
      return @user
    end
    
    private
    alias_method :initialize__acl_entry_impl, :initialize
  end
  
end
