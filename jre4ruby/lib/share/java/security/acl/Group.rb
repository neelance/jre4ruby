require "rjava"

# Copyright 1996-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module GroupImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Acl
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Security, :Principal
    }
  end
  
  # This interface is used to represent a group of principals. (A principal
  # represents an entity such as an individual user or a company). <p>
  # 
  # Note that Group extends Principal. Thus, either a Principal or a Group can
  # be passed as an argument to methods containing a Principal parameter. For
  # example, you can add either a Principal or a Group to a Group object by
  # calling the object's <code>addMember</code> method, passing it the
  # Principal or Group.
  # 
  # @author      Satish Dharmaraj
  module Group
    include_class_members GroupImports
    include Principal
    
    typesig { [Principal] }
    # Adds the specified member to the group.
    # 
    # @param user the principal to add to this group.
    # 
    # @return true if the member was successfully added,
    # false if the principal was already a member.
    def add_member(user)
      raise NotImplementedError
    end
    
    typesig { [Principal] }
    # Removes the specified member from the group.
    # 
    # @param user the principal to remove from this group.
    # 
    # @return true if the principal was removed, or
    # false if the principal was not a member.
    def remove_member(user)
      raise NotImplementedError
    end
    
    typesig { [Principal] }
    # Returns true if the passed principal is a member of the group.
    # This method does a recursive search, so if a principal belongs to a
    # group which is a member of this group, true is returned.
    # 
    # @param member the principal whose membership is to be checked.
    # 
    # @return true if the principal is a member of this group,
    # false otherwise.
    def is_member(member)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns an enumeration of the members in the group.
    # The returned objects can be instances of either Principal
    # or Group (which is a subclass of Principal).
    # 
    # @return an enumeration of the group members.
    def members
      raise NotImplementedError
    end
  end
  
end
