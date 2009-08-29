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
  module GroupImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Acl
      include ::Java::Util
      include ::Java::Security
      include ::Java::Security::Acl
    }
  end
  
  # This class implements a group of principals.
  # @author      Satish Dharmaraj
  class GroupImpl 
    include_class_members GroupImplImports
    include Group
    
    attr_accessor :group_members
    alias_method :attr_group_members, :group_members
    undef_method :group_members
    alias_method :attr_group_members=, :group_members=
    undef_method :group_members=
    
    attr_accessor :group
    alias_method :attr_group, :group
    undef_method :group
    alias_method :attr_group=, :group=
    undef_method :group=
    
    typesig { [String] }
    # Constructs a Group object with no members.
    # @param groupName the name of the group
    def initialize(group_name)
      @group_members = Vector.new(50, 100)
      @group = nil
      @group = group_name
    end
    
    typesig { [Principal] }
    # adds the specified member to the group.
    # @param user The principal to add to the group.
    # @return true if the member was added - false if the
    # member could not be added.
    def add_member(user)
      if (@group_members.contains(user))
        return false
      end
      # do not allow groups to be added to itself.
      if ((@group == user.to_s))
        raise IllegalArgumentException.new
      end
      @group_members.add_element(user)
      return true
    end
    
    typesig { [Principal] }
    # removes the specified member from the group.
    # @param user The principal to remove from the group.
    # @param true if the principal was removed false if
    # the principal was not a member
    def remove_member(user)
      return @group_members.remove_element(user)
    end
    
    typesig { [] }
    # returns the enumeration of the members in the group.
    def members
      return @group_members.elements
    end
    
    typesig { [Object] }
    # This function returns true if the group passed matches
    # the group represented in this interface.
    # @param another The group to compare this group to.
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if ((obj.is_a?(Group)).equal?(false))
        return false
      end
      another = obj
      return (@group == another.to_s)
    end
    
    typesig { [Group] }
    # equals(Group) for compatibility
    def ==(another)
      return self.==(another)
    end
    
    typesig { [] }
    # Prints a stringified version of the group.
    def to_s
      return @group
    end
    
    typesig { [] }
    # return a hashcode for the principal.
    def hash_code
      return @group.hash_code
    end
    
    typesig { [Principal] }
    # returns true if the passed principal is a member of the group.
    # @param member The principal whose membership must be checked for.
    # @return true if the principal is a member of this group,
    # false otherwise
    def is_member(member)
      # if the member is part of the group (common case), return true.
      # if not, recursively search depth first in the group looking for the
      # principal.
      if (@group_members.contains(member))
        return true
      else
        already_seen = Vector.new(10)
        return is_member_recurse(member, already_seen)
      end
    end
    
    typesig { [] }
    # return the name of the principal.
    def get_name
      return @group
    end
    
    typesig { [Principal, Vector] }
    # This function is the recursive search of groups for this
    # implementation of the Group. The search proceeds building up
    # a vector of already seen groups. Only new groups are considered,
    # thereby avoiding loops.
    def is_member_recurse(member, already_seen)
      e = members
      while (e.has_more_elements)
        mem = false
        p = e.next_element
        # if the member is in this collection, return true
        if ((p == member))
          return true
        else
          if (p.is_a?(GroupImpl))
            # if not recurse if the group has not been checked already.
            # Can call method in this package only if the object is an
            # instance of this class. Otherwise call the method defined
            # in the interface. (This can lead to a loop if a mixture of
            # implementations form a loop, but we live with this improbable
            # case rather than clutter the interface by forcing the
            # implementation of this method.)
            g = p
            already_seen.add_element(self)
            if (!already_seen.contains(g))
              mem = g.is_member_recurse(member, already_seen)
            end
          else
            if (p.is_a?(Group))
              g = p
              if (!already_seen.contains(g))
                mem = g.is_member(member)
              end
            end
          end
        end
        if (mem)
          return mem
        end
      end
      return false
    end
    
    private
    alias_method :initialize__group_impl, :initialize
  end
  
end
