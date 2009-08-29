require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module PermissionsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :NoSuchElementException
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Collections
      include_const ::Java::Io, :Serializable
      include_const ::Java::Io, :ObjectStreamField
      include_const ::Java::Io, :ObjectOutputStream
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # This class represents a heterogeneous collection of Permissions. That is,
  # it contains different types of Permission objects, organized into
  # PermissionCollections. For example, if any
  # <code>java.io.FilePermission</code> objects are added to an instance of
  # this class, they are all stored in a single
  # PermissionCollection. It is the PermissionCollection returned by a call to
  # the <code>newPermissionCollection</code> method in the FilePermission class.
  # Similarly, any <code>java.lang.RuntimePermission</code> objects are
  # stored in the PermissionCollection returned by a call to the
  # <code>newPermissionCollection</code> method in the
  # RuntimePermission class. Thus, this class represents a collection of
  # PermissionCollections.
  # 
  # <p>When the <code>add</code> method is called to add a Permission, the
  # Permission is stored in the appropriate PermissionCollection. If no such
  # collection exists yet, the Permission object's class is determined and the
  # <code>newPermissionCollection</code> method is called on that class to create
  # the PermissionCollection and add it to the Permissions object. If
  # <code>newPermissionCollection</code> returns null, then a default
  # PermissionCollection that uses a hashtable will be created and used. Each
  # hashtable entry stores a Permission object as both the key and the value.
  # 
  # <p> Enumerations returned via the <code>elements</code> method are
  # not <em>fail-fast</em>.  Modifications to a collection should not be
  # performed while enumerating over that collection.
  # 
  # @see Permission
  # @see PermissionCollection
  # @see AllPermission
  # 
  # 
  # @author Marianne Mueller
  # @author Roland Schemers
  # 
  # @serial exclude
  class Permissions < PermissionsImports.const_get :PermissionCollection
    include_class_members PermissionsImports
    overload_protected {
      include Serializable
    }
    
    # Key is permissions Class, value is PermissionCollection for that class.
    # Not serialized; see serialization section at end of class.
    attr_accessor :perms_map
    alias_method :attr_perms_map, :perms_map
    undef_method :perms_map
    alias_method :attr_perms_map=, :perms_map=
    undef_method :perms_map=
    
    # optimization. keep track of whether unresolved permissions need to be
    # checked
    attr_accessor :has_unresolved
    alias_method :attr_has_unresolved, :has_unresolved
    undef_method :has_unresolved
    alias_method :attr_has_unresolved=, :has_unresolved=
    undef_method :has_unresolved=
    
    # optimization. keep track of the AllPermission collection
    # - package private for ProtectionDomain optimization
    attr_accessor :all_permission
    alias_method :attr_all_permission, :all_permission
    undef_method :all_permission
    alias_method :attr_all_permission=, :all_permission=
    undef_method :all_permission=
    
    typesig { [] }
    # Creates a new Permissions object containing no PermissionCollections.
    def initialize
      @perms_map = nil
      @has_unresolved = false
      @all_permission = nil
      super()
      @has_unresolved = false
      @perms_map = HashMap.new(11)
      @all_permission = nil
    end
    
    typesig { [Permission] }
    # Adds a permission object to the PermissionCollection for the class the
    # permission belongs to. For example, if <i>permission</i> is a
    # FilePermission, it is added to the FilePermissionCollection stored
    # in this Permissions object.
    # 
    # This method creates
    # a new PermissionCollection object (and adds the permission to it)
    # if an appropriate collection does not yet exist. <p>
    # 
    # @param permission the Permission object to add.
    # 
    # @exception SecurityException if this Permissions object is
    # marked as readonly.
    # 
    # @see PermissionCollection#isReadOnly()
    def add(permission)
      if (is_read_only)
        raise SecurityException.new("attempt to add a Permission to a readonly Permissions object")
      end
      pc = nil
      synchronized((self)) do
        pc = get_permission_collection(permission, true)
        pc.add(permission)
      end
      # No sync; staleness -> optimizations delayed, which is OK
      if (permission.is_a?(AllPermission))
        @all_permission = pc
      end
      if (permission.is_a?(UnresolvedPermission))
        @has_unresolved = true
      end
    end
    
    typesig { [Permission] }
    # Checks to see if this object's PermissionCollection for permissions of
    # the specified permission's class implies the permissions
    # expressed in the <i>permission</i> object. Returns true if the
    # combination of permissions in the appropriate PermissionCollection
    # (e.g., a FilePermissionCollection for a FilePermission) together
    # imply the specified permission.
    # 
    # <p>For example, suppose there is a FilePermissionCollection in this
    # Permissions object, and it contains one FilePermission that specifies
    # "read" access for  all files in all subdirectories of the "/tmp"
    # directory, and another FilePermission that specifies "write" access
    # for all files in the "/tmp/scratch/foo" directory.
    # Then if the <code>implies</code> method
    # is called with a permission specifying both "read" and "write" access
    # to files in the "/tmp/scratch/foo" directory, <code>true</code> is
    # returned.
    # 
    # <p>Additionally, if this PermissionCollection contains the
    # AllPermission, this method will always return true.
    # <p>
    # @param permission the Permission object to check.
    # 
    # @return true if "permission" is implied by the permissions in the
    # PermissionCollection it
    # belongs to, false if not.
    def implies(permission)
      # No sync; staleness -> skip optimization, which is OK
      if (!(@all_permission).nil?)
        return true # AllPermission has already been added
      else
        synchronized((self)) do
          pc = get_permission_collection(permission, false)
          if (!(pc).nil?)
            return pc.implies(permission)
          else
            # none found
            return false
          end
        end
      end
    end
    
    typesig { [] }
    # Returns an enumeration of all the Permission objects in all the
    # PermissionCollections in this Permissions object.
    # 
    # @return an enumeration of all the Permissions.
    def elements
      # go through each Permissions in the hash table
      # and call their elements() function.
      synchronized((self)) do
        return PermissionsEnumerator.new(@perms_map.values.iterator)
      end
    end
    
    typesig { [Permission, ::Java::Boolean] }
    # Gets the PermissionCollection in this Permissions object for
    # permissions whose type is the same as that of <i>p</i>.
    # For example, if <i>p</i> is a FilePermission,
    # the FilePermissionCollection
    # stored in this Permissions object will be returned.
    # 
    # If createEmpty is true,
    # this method creates a new PermissionCollection object for the specified
    # type of permission objects if one does not yet exist.
    # To do so, it first calls the <code>newPermissionCollection</code> method
    # on <i>p</i>.  Subclasses of class Permission
    # override that method if they need to store their permissions in a
    # particular PermissionCollection object in order to provide the
    # correct semantics when the <code>PermissionCollection.implies</code>
    # method is called.
    # If the call returns a PermissionCollection, that collection is stored
    # in this Permissions object. If the call returns null and createEmpty
    # is true, then
    # this method instantiates and stores a default PermissionCollection
    # that uses a hashtable to store its permission objects.
    # 
    # createEmpty is ignored when creating empty PermissionCollection
    # for unresolved permissions because of the overhead of determining the
    # PermissionCollection to use.
    # 
    # createEmpty should be set to false when this method is invoked from
    # implies() because it incurs the additional overhead of creating and
    # adding an empty PermissionCollection that will just return false.
    # It should be set to true when invoked from add().
    def get_permission_collection(p, create_empty)
      c = p.get_class
      pc = @perms_map.get(c)
      if (!@has_unresolved && !create_empty)
        return pc
      else
        if ((pc).nil?)
          # Check for unresolved permissions
          pc = (@has_unresolved ? get_unresolved_permissions(p) : nil)
          # if still null, create a new collection
          if ((pc).nil? && create_empty)
            pc = p.new_permission_collection
            # still no PermissionCollection?
            # We'll give them a PermissionsHash.
            if ((pc).nil?)
              pc = PermissionsHash.new
            end
          end
          if (!(pc).nil?)
            @perms_map.put(c, pc)
          end
        end
      end
      return pc
    end
    
    typesig { [Permission] }
    # Resolves any unresolved permissions of type p.
    # 
    # @param p the type of unresolved permission to resolve
    # 
    # @return PermissionCollection containing the unresolved permissions,
    # or null if there were no unresolved permissions of type p.
    def get_unresolved_permissions(p)
      # Called from within synchronized method so permsMap doesn't need lock
      uc = @perms_map.get(UnresolvedPermission)
      # we have no unresolved permissions if uc is null
      if ((uc).nil?)
        return nil
      end
      unresolved_perms = uc.get_unresolved_permissions(p)
      # we have no unresolved permissions of this type if unresolvedPerms is null
      if ((unresolved_perms).nil?)
        return nil
      end
      certs = nil
      signers = p.get_class.get_signers
      n = 0
      if (!(signers).nil?)
        j = 0
        while j < signers.attr_length
          if (signers[j].is_a?(Java::Security::Cert::Certificate))
            n += 1
          end
          j += 1
        end
        certs = Array.typed(Java::Security::Cert::Certificate).new(n) { nil }
        n = 0
        j_ = 0
        while j_ < signers.attr_length
          if (signers[j_].is_a?(Java::Security::Cert::Certificate))
            certs[((n += 1) - 1)] = signers[j_]
          end
          j_ += 1
        end
      end
      pc = nil
      synchronized((unresolved_perms)) do
        len = unresolved_perms.size
        i = 0
        while i < len
          up = unresolved_perms.get(i)
          perm = up.resolve(p, certs)
          if (!(perm).nil?)
            if ((pc).nil?)
              pc = p.new_permission_collection
              if ((pc).nil?)
                pc = PermissionsHash.new
              end
            end
            pc.add(perm)
          end
          i += 1
        end
      end
      return pc
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 4858622370623524688 }
      const_attr_reader  :SerialVersionUID
      
      # Need to maintain serialization interoperability with earlier releases,
      # which had the serializable field:
      # private Hashtable perms;
      # 
      # @serialField perms java.util.Hashtable
      # A table of the Permission classes and PermissionCollections.
      # @serialField allPermission java.security.PermissionCollection
      const_set_lazy(:SerialPersistentFields) { Array.typed(ObjectStreamField).new([ObjectStreamField.new("perms", Hashtable), ObjectStreamField.new("allPermission", PermissionCollection), ]) }
      const_attr_reader  :SerialPersistentFields
    }
    
    typesig { [ObjectOutputStream] }
    # @serialData Default fields.
    # 
    # 
    # Writes the contents of the permsMap field out as a Hashtable for
    # serialization compatibility with earlier releases. allPermission
    # unchanged.
    def write_object(out)
      # Don't call out.defaultWriteObject()
      # Copy perms into a Hashtable
      perms = Hashtable.new(@perms_map.size * 2) # no sync; estimate
      synchronized((self)) do
        perms.put_all(@perms_map)
      end
      # Write out serializable fields
      pfields = out.put_fields
      pfields.put("allPermission", @all_permission) # no sync; staleness OK
      pfields.put("perms", perms)
      out.write_fields
    end
    
    typesig { [ObjectInputStream] }
    # Reads in a Hashtable of Class/PermissionCollections and saves them in the
    # permsMap field. Reads in allPermission.
    def read_object(in_)
      # Don't call defaultReadObject()
      # Read in serialized fields
      gfields = in_.read_fields
      # Get allPermission
      @all_permission = gfields.get("allPermission", nil)
      # Get permissions
      perms = gfields.get("perms", nil)
      @perms_map = HashMap.new(perms.size * 2)
      @perms_map.put_all(perms)
      # Set hasUnresolved
      uc = @perms_map.get(UnresolvedPermission)
      @has_unresolved = (!(uc).nil? && uc.elements.has_more_elements)
    end
    
    private
    alias_method :initialize__permissions, :initialize
  end
  
  class PermissionsEnumerator 
    include_class_members PermissionsImports
    include Enumeration
    
    # all the perms
    attr_accessor :perms
    alias_method :attr_perms, :perms
    undef_method :perms
    alias_method :attr_perms=, :perms=
    undef_method :perms=
    
    # the current set
    attr_accessor :permset
    alias_method :attr_permset, :permset
    undef_method :permset
    alias_method :attr_permset=, :permset=
    undef_method :permset=
    
    typesig { [Iterator] }
    def initialize(e)
      @perms = nil
      @permset = nil
      @perms = e
      @permset = get_next_enum_with_more
    end
    
    typesig { [] }
    # No need to synchronize; caller should sync on object as required
    def has_more_elements
      # if we enter with permissionimpl null, we know
      # there are no more left.
      if ((@permset).nil?)
        return false
      end
      # try to see if there are any left in the current one
      if (@permset.has_more_elements)
        return true
      end
      # get the next one that has something in it...
      @permset = get_next_enum_with_more
      # if it is null, we are done!
      return (!(@permset).nil?)
    end
    
    typesig { [] }
    # No need to synchronize; caller should sync on object as required
    def next_element
      # hasMoreElements will update permset to the next permset
      # with something in it...
      if (has_more_elements)
        return @permset.next_element
      else
        raise NoSuchElementException.new("PermissionsEnumerator")
      end
    end
    
    typesig { [] }
    def get_next_enum_with_more
      while (@perms.has_next)
        pc = @perms.next_
        next__ = pc.elements
        if (next__.has_more_elements)
          return next__
        end
      end
      return nil
    end
    
    private
    alias_method :initialize__permissions_enumerator, :initialize
  end
  
  # A PermissionsHash stores a homogeneous set of permissions in a hashtable.
  # 
  # @see Permission
  # @see Permissions
  # 
  # 
  # @author Roland Schemers
  # 
  # @serial include
  class PermissionsHash < PermissionsImports.const_get :PermissionCollection
    include_class_members PermissionsImports
    overload_protected {
      include Serializable
    }
    
    # Key and value are (same) permissions objects.
    # Not serialized; see serialization section at end of class.
    attr_accessor :perms_map
    alias_method :attr_perms_map, :perms_map
    undef_method :perms_map
    alias_method :attr_perms_map=, :perms_map=
    undef_method :perms_map=
    
    typesig { [] }
    # Create an empty PermissionsHash object.
    def initialize
      @perms_map = nil
      super()
      @perms_map = HashMap.new(11)
    end
    
    typesig { [Permission] }
    # Adds a permission to the PermissionsHash.
    # 
    # @param permission the Permission object to add.
    def add(permission)
      synchronized((self)) do
        @perms_map.put(permission, permission)
      end
    end
    
    typesig { [Permission] }
    # Check and see if this set of permissions implies the permissions
    # expressed in "permission".
    # 
    # @param permission the Permission object to compare
    # 
    # @return true if "permission" is a proper subset of a permission in
    # the set, false if not.
    def implies(permission)
      # attempt a fast lookup and implies. If that fails
      # then enumerate through all the permissions.
      synchronized((self)) do
        p = @perms_map.get(permission)
        # If permission is found, then p.equals(permission)
        if ((p).nil?)
          @perms_map.values.each do |p_|
            if (p_.implies(permission))
              return true
            end
          end
          return false
        else
          return true
        end
      end
    end
    
    typesig { [] }
    # Returns an enumeration of all the Permission objects in the container.
    # 
    # @return an enumeration of all the Permissions.
    def elements
      # Convert Iterator of Map values into an Enumeration
      synchronized((self)) do
        return Collections.enumeration(@perms_map.values)
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -8491988220802933440 }
      const_attr_reader  :SerialVersionUID
      
      # Need to maintain serialization interoperability with earlier releases,
      # which had the serializable field:
      # private Hashtable perms;
      # 
      # @serialField perms java.util.Hashtable
      # A table of the Permissions (both key and value are same).
      const_set_lazy(:SerialPersistentFields) { Array.typed(ObjectStreamField).new([ObjectStreamField.new("perms", Hashtable), ]) }
      const_attr_reader  :SerialPersistentFields
    }
    
    typesig { [ObjectOutputStream] }
    # @serialData Default fields.
    # 
    # 
    # Writes the contents of the permsMap field out as a Hashtable for
    # serialization compatibility with earlier releases.
    def write_object(out)
      # Don't call out.defaultWriteObject()
      # Copy perms into a Hashtable
      perms = Hashtable.new(@perms_map.size * 2)
      synchronized((self)) do
        perms.put_all(@perms_map)
      end
      # Write out serializable fields
      pfields = out.put_fields
      pfields.put("perms", perms)
      out.write_fields
    end
    
    typesig { [ObjectInputStream] }
    # Reads in a Hashtable of Permission/Permission and saves them in the
    # permsMap field.
    def read_object(in_)
      # Don't call defaultReadObject()
      # Read in serialized fields
      gfields = in_.read_fields
      # Get permissions
      perms = gfields.get("perms", nil)
      @perms_map = HashMap.new(perms.size * 2)
      @perms_map.put_all(perms)
    end
    
    private
    alias_method :initialize__permissions_hash, :initialize
  end
  
end
