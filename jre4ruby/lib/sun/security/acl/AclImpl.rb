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
  module AclImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Acl
      include ::Java::Io
      include ::Java::Util
      include_const ::Java::Security, :Principal
      include ::Java::Security::Acl
    }
  end
  
  # An Access Control List (ACL) is encapsulated by this class.
  # @author      Satish Dharmaraj
  class AclImpl < AclImplImports.const_get :OwnerImpl
    include_class_members AclImplImports
    include Acl
    
    # Maintain four tables. one each for positive and negative
    # ACLs. One each depending on whether the entity is a group
    # or principal.
    attr_accessor :allowed_users_table
    alias_method :attr_allowed_users_table, :allowed_users_table
    undef_method :allowed_users_table
    alias_method :attr_allowed_users_table=, :allowed_users_table=
    undef_method :allowed_users_table=
    
    attr_accessor :allowed_groups_table
    alias_method :attr_allowed_groups_table, :allowed_groups_table
    undef_method :allowed_groups_table
    alias_method :attr_allowed_groups_table=, :allowed_groups_table=
    undef_method :allowed_groups_table=
    
    attr_accessor :denied_users_table
    alias_method :attr_denied_users_table, :denied_users_table
    undef_method :denied_users_table
    alias_method :attr_denied_users_table=, :denied_users_table=
    undef_method :denied_users_table=
    
    attr_accessor :denied_groups_table
    alias_method :attr_denied_groups_table, :denied_groups_table
    undef_method :denied_groups_table
    alias_method :attr_denied_groups_table=, :denied_groups_table=
    undef_method :denied_groups_table=
    
    attr_accessor :acl_name
    alias_method :attr_acl_name, :acl_name
    undef_method :acl_name
    alias_method :attr_acl_name=, :acl_name=
    undef_method :acl_name=
    
    attr_accessor :zero_set
    alias_method :attr_zero_set, :zero_set
    undef_method :zero_set
    alias_method :attr_zero_set=, :zero_set=
    undef_method :zero_set=
    
    typesig { [Principal, String] }
    # Constructor for creating an empty ACL.
    def initialize(owner, name)
      @allowed_users_table = nil
      @allowed_groups_table = nil
      @denied_users_table = nil
      @denied_groups_table = nil
      @acl_name = nil
      @zero_set = nil
      super(owner)
      @allowed_users_table = Hashtable.new(23)
      @allowed_groups_table = Hashtable.new(23)
      @denied_users_table = Hashtable.new(23)
      @denied_groups_table = Hashtable.new(23)
      @acl_name = nil
      @zero_set = Vector.new(1, 1)
      begin
        set_name(owner, name)
      rescue Exception => e
      end
    end
    
    typesig { [Principal, String] }
    # Sets the name of the ACL.
    # @param caller the principal who is invoking this method.
    # @param name the name of the ACL.
    # @exception NotOwnerException if the caller principal is
    # not on the owners list of the Acl.
    def set_name(caller, name)
      if (!is_owner(caller))
        raise NotOwnerException.new
      end
      @acl_name = name
    end
    
    typesig { [] }
    # Returns the name of the ACL.
    # @return the name of the ACL.
    def get_name
      return @acl_name
    end
    
    typesig { [Principal, AclEntry] }
    # Adds an ACL entry to this ACL. An entry associates a
    # group or a principal with a set of permissions. Each
    # user or group can have one positive ACL entry and one
    # negative ACL entry. If there is one of the type (negative
    # or positive) already in the table, a false value is returned.
    # The caller principal must be a part of the owners list of
    # the ACL in order to invoke this method.
    # @param caller the principal who is invoking this method.
    # @param entry the ACL entry that must be added to the ACL.
    # @return true on success, false if the entry is already present.
    # @exception NotOwnerException if the caller principal
    # is not on the owners list of the Acl.
    def add_entry(caller, entry)
      synchronized(self) do
        if (!is_owner(caller))
          raise NotOwnerException.new
        end
        acl_table = find_table(entry)
        key = entry.get_principal
        if (!(acl_table.get(key)).nil?)
          return false
        end
        acl_table.put(key, entry)
        return true
      end
    end
    
    typesig { [Principal, AclEntry] }
    # Removes an ACL entry from this ACL.
    # The caller principal must be a part of the owners list of the ACL
    # in order to invoke this method.
    # @param caller the principal who is invoking this method.
    # @param entry the ACL entry that must be removed from the ACL.
    # @return true on success, false if the entry is not part of the ACL.
    # @exception NotOwnerException if the caller principal is not
    # the owners list of the Acl.
    def remove_entry(caller, entry)
      synchronized(self) do
        if (!is_owner(caller))
          raise NotOwnerException.new
        end
        acl_table = find_table(entry)
        key = entry.get_principal
        o = acl_table.remove(key)
        return (!(o).nil?)
      end
    end
    
    typesig { [Principal] }
    # This method returns the set of allowed permissions for the
    # specified principal. This set of allowed permissions is calculated
    # as follows:
    # 
    # If there is no entry for a group or a principal an empty permission
    # set is assumed.
    # 
    # The group positive permission set is the union of all
    # the positive permissions of each group that the individual belongs to.
    # The group negative permission set is the union of all
    # the negative permissions of each group that the individual belongs to.
    # If there is a specific permission that occurs in both
    # the postive permission set and the negative permission set,
    # it is removed from both. The group positive and negatoive permission
    # sets are calculated.
    # 
    # The individial positive permission set and the individual negative
    # permission set is then calculated. Again abscence of an entry means
    # the empty set.
    # 
    # The set of permissions granted to the principal is then calculated using
    # the simple rule: Individual permissions always override the Group permissions.
    # Specifically, individual negative permission set (specific
    # denial of permissions) overrides the group positive permission set.
    # And the individual positive permission set override the group negative
    # permission set.
    # 
    # @param user the principal for which the ACL entry is returned.
    # @return The resulting permission set that the principal is allowed.
    def get_permissions(user)
      synchronized(self) do
        individual_positive = nil
        individual_negative = nil
        group_positive = nil
        group_negative = nil
        # canonicalize the sets. That is remove common permissions from
        # positive and negative sets.
        group_positive = subtract(get_group_positive(user), get_group_negative(user))
        group_negative = subtract(get_group_negative(user), get_group_positive(user))
        individual_positive = subtract(get_individual_positive(user), get_individual_negative(user))
        individual_negative = subtract(get_individual_negative(user), get_individual_positive(user))
        # net positive permissions is individual positive permissions
        # plus (group positive - individual negative).
        temp1 = subtract(group_positive, individual_negative)
        net_positive = union(individual_positive, temp1)
        # recalculate the enumeration since we lost it in performing the
        # subtraction
        individual_positive = subtract(get_individual_positive(user), get_individual_negative(user))
        individual_negative = subtract(get_individual_negative(user), get_individual_positive(user))
        # net negative permissions is individual negative permissions
        # plus (group negative - individual positive).
        temp1 = subtract(group_negative, individual_positive)
        net_negative = union(individual_negative, temp1)
        return subtract(net_positive, net_negative)
      end
    end
    
    typesig { [Principal, Permission] }
    # This method checks whether or not the specified principal
    # has the required permission. If permission is denied
    # permission false is returned, a true value is returned otherwise.
    # This method does not authenticate the principal. It presumes that
    # the principal is a valid authenticated principal.
    # @param principal the name of the authenticated principal
    # @param permission the permission that the principal must have.
    # @return true of the principal has the permission desired, false
    # otherwise.
    def check_permission(principal, permission)
      perm_set = get_permissions(principal)
      while (perm_set.has_more_elements)
        p = perm_set.next_element
        if ((p == permission))
          return true
        end
      end
      return false
    end
    
    typesig { [] }
    # returns an enumeration of the entries in this ACL.
    def entries
      synchronized(self) do
        return AclEnumerator.new(self, @allowed_users_table, @allowed_groups_table, @denied_users_table, @denied_groups_table)
      end
    end
    
    typesig { [] }
    # return a stringified version of the
    # ACL.
    def to_s
      sb = StringBuffer.new
      entries_ = entries
      while (entries_.has_more_elements)
        entry = entries_.next_element
        sb.append(entry.to_s.trim)
        sb.append("\n")
      end
      return sb.to_s
    end
    
    typesig { [AclEntry] }
    # Find the table that this entry belongs to. There are 4
    # tables that are maintained. One each for postive and
    # negative ACLs and one each for groups and users.
    # This method figures out which
    # table is the one that this AclEntry belongs to.
    def find_table(entry)
      acl_table = nil
      p = entry.get_principal
      if (p.is_a?(Group))
        if (entry.is_negative)
          acl_table = @denied_groups_table
        else
          acl_table = @allowed_groups_table
        end
      else
        if (entry.is_negative)
          acl_table = @denied_users_table
        else
          acl_table = @allowed_users_table
        end
      end
      return acl_table
    end
    
    class_module.module_eval {
      typesig { [Enumeration, Enumeration] }
      # returns the set e1 U e2.
      def union(e1, e2)
        v = Vector.new(20, 20)
        while (e1.has_more_elements)
          v.add_element(e1.next_element)
        end
        while (e2.has_more_elements)
          o = e2.next_element
          if (!v.contains(o))
            v.add_element(o)
          end
        end
        return v.elements
      end
    }
    
    typesig { [Enumeration, Enumeration] }
    # returns the set e1 - e2.
    def subtract(e1, e2)
      v = Vector.new(20, 20)
      while (e1.has_more_elements)
        v.add_element(e1.next_element)
      end
      while (e2.has_more_elements)
        o = e2.next_element
        if (v.contains(o))
          v.remove_element(o)
        end
      end
      return v.elements
    end
    
    typesig { [Principal] }
    def get_group_positive(user)
      group_positive = @zero_set.elements
      e = @allowed_groups_table.keys
      while (e.has_more_elements)
        g = e.next_element
        if (g.is_member(user))
          ae = @allowed_groups_table.get(g)
          group_positive = union(ae.permissions, group_positive)
        end
      end
      return group_positive
    end
    
    typesig { [Principal] }
    def get_group_negative(user)
      group_negative = @zero_set.elements
      e = @denied_groups_table.keys
      while (e.has_more_elements)
        g = e.next_element
        if (g.is_member(user))
          ae = @denied_groups_table.get(g)
          group_negative = union(ae.permissions, group_negative)
        end
      end
      return group_negative
    end
    
    typesig { [Principal] }
    def get_individual_positive(user)
      individual_positive = @zero_set.elements
      ae = @allowed_users_table.get(user)
      if (!(ae).nil?)
        individual_positive = ae.permissions
      end
      return individual_positive
    end
    
    typesig { [Principal] }
    def get_individual_negative(user)
      individual_negative = @zero_set.elements
      ae = @denied_users_table.get(user)
      if (!(ae).nil?)
        individual_negative = ae.permissions
      end
      return individual_negative
    end
    
    private
    alias_method :initialize__acl_impl, :initialize
  end
  
  class AclEnumerator 
    include_class_members AclImplImports
    include Enumeration
    
    attr_accessor :acl
    alias_method :attr_acl, :acl
    undef_method :acl
    alias_method :attr_acl=, :acl=
    undef_method :acl=
    
    attr_accessor :u1
    alias_method :attr_u1, :u1
    undef_method :u1
    alias_method :attr_u1=, :u1=
    undef_method :u1=
    
    attr_accessor :u2
    alias_method :attr_u2, :u2
    undef_method :u2
    alias_method :attr_u2=, :u2=
    undef_method :u2=
    
    attr_accessor :g1
    alias_method :attr_g1, :g1
    undef_method :g1
    alias_method :attr_g1=, :g1=
    undef_method :g1=
    
    attr_accessor :g2
    alias_method :attr_g2, :g2
    undef_method :g2
    alias_method :attr_g2=, :g2=
    undef_method :g2=
    
    typesig { [Acl, Hashtable, Hashtable, Hashtable, Hashtable] }
    def initialize(acl, u1, g1, u2, g2)
      @acl = nil
      @u1 = nil
      @u2 = nil
      @g1 = nil
      @g2 = nil
      @acl = acl
      @u1 = u1.elements
      @u2 = u2.elements
      @g1 = g1.elements
      @g2 = g2.elements
    end
    
    typesig { [] }
    def has_more_elements
      return (@u1.has_more_elements || @u2.has_more_elements || @g1.has_more_elements || @g2.has_more_elements)
    end
    
    typesig { [] }
    def next_element
      o = nil
      synchronized((@acl)) do
        if (@u1.has_more_elements)
          return @u1.next_element
        end
        if (@u2.has_more_elements)
          return @u2.next_element
        end
        if (@g1.has_more_elements)
          return @g1.next_element
        end
        if (@g2.has_more_elements)
          return @g2.next_element
        end
      end
      raise NoSuchElementException.new("Acl Enumerator")
    end
    
    private
    alias_method :initialize__acl_enumerator, :initialize
  end
  
end
