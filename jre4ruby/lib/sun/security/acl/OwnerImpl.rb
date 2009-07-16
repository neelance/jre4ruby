require "rjava"

# 
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
  module OwnerImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Acl
      include ::Java::Util
      include ::Java::Security
      include ::Java::Security::Acl
    }
  end
  
  # 
  # Class implementing the Owner interface. The
  # initial owner principal is configured as
  # part of the constructor.
  # @author      Satish Dharmaraj
  class OwnerImpl 
    include_class_members OwnerImplImports
    include Owner
    
    attr_accessor :owner_group
    alias_method :attr_owner_group, :owner_group
    undef_method :owner_group
    alias_method :attr_owner_group=, :owner_group=
    undef_method :owner_group=
    
    typesig { [Principal] }
    def initialize(owner)
      @owner_group = nil
      @owner_group = GroupImpl.new("AclOwners")
      @owner_group.add_member(owner)
    end
    
    typesig { [Principal, Principal] }
    # 
    # Adds an owner. Owners can modify ACL contents and can disassociate
    # ACLs from the objects they protect in the AclConfig interface.
    # The caller principal must be a part of the owners list of the ACL in
    # order to invoke this method. The initial owner is configured
    # at ACL construction time.
    # @param caller the principal who is invoking this method.
    # @param owner The owner that should be added to the owners list.
    # @return true if success, false if already an owner.
    # @exception NotOwnerException if the caller principal is not on
    # the owners list of the Acl.
    def add_owner(caller, owner)
      synchronized(self) do
        if (!is_owner(caller))
          raise NotOwnerException.new
        end
        @owner_group.add_member(owner)
        return false
      end
    end
    
    typesig { [Principal, Principal] }
    # 
    # Delete owner. If this is the last owner in the ACL, an exception is
    # raised.
    # The caller principal must be a part of the owners list of the ACL in
    # order to invoke this method.
    # @param caller the principal who is invoking this method.
    # @param owner The owner to be removed from the owners list.
    # @return true if the owner is removed, false if the owner is not part
    # of the owners list.
    # @exception NotOwnerException if the caller principal is not on
    # the owners list of the Acl.
    # @exception LastOwnerException if there is only one owner left in the group, then
    # deleteOwner would leave the ACL owner-less. This exception is raised in such a case.
    def delete_owner(caller, owner)
      synchronized(self) do
        if (!is_owner(caller))
          raise NotOwnerException.new
        end
        e = @owner_group.members
        # 
        # check if there is atleast 2 members left.
        o = e.next_element
        if (e.has_more_elements)
          return @owner_group.remove_member(owner)
        else
          raise LastOwnerException.new
        end
      end
    end
    
    typesig { [Principal] }
    # 
    # returns if the given principal belongs to the owner list.
    # @param owner The owner to check if part of the owners list
    # @return true if the passed principal is in the owner list, false if not.
    def is_owner(owner)
      synchronized(self) do
        return @owner_group.is_member(owner)
      end
    end
    
    private
    alias_method :initialize__owner_impl, :initialize
  end
  
end
