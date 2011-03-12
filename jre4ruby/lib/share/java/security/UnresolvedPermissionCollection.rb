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
  module UnresolvedPermissionCollectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Util
      include_const ::Java::Io, :ObjectStreamField
      include_const ::Java::Io, :ObjectOutputStream
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # A UnresolvedPermissionCollection stores a collection
  # of UnresolvedPermission permissions.
  # 
  # @see java.security.Permission
  # @see java.security.Permissions
  # @see java.security.UnresolvedPermission
  # 
  # 
  # @author Roland Schemers
  # 
  # @serial include
  class UnresolvedPermissionCollection < UnresolvedPermissionCollectionImports.const_get :PermissionCollection
    include_class_members UnresolvedPermissionCollectionImports
    overload_protected {
      include Java::Io::Serializable
    }
    
    # Key is permission type, value is a list of the UnresolvedPermissions
    # of the same type.
    # Not serialized; see serialization section at end of class.
    attr_accessor :perms
    alias_method :attr_perms, :perms
    undef_method :perms
    alias_method :attr_perms=, :perms=
    undef_method :perms=
    
    typesig { [] }
    # Create an empty UnresolvedPermissionCollection object.
    def initialize
      @perms = nil
      super()
      @perms = HashMap.new(11)
    end
    
    typesig { [Permission] }
    # Adds a permission to this UnresolvedPermissionCollection.
    # The key for the hash is the unresolved permission's type (class) name.
    # 
    # @param permission the Permission object to add.
    def add(permission)
      if (!(permission.is_a?(UnresolvedPermission)))
        raise IllegalArgumentException.new("invalid permission: " + RJava.cast_to_string(permission))
      end
      up = permission
      v = nil
      synchronized((self)) do
        v = @perms.get(up.get_name)
        if ((v).nil?)
          v = ArrayList.new
          @perms.put(up.get_name, v)
        end
      end
      synchronized((v)) do
        v.add(up)
      end
    end
    
    typesig { [Permission] }
    # get any unresolved permissions of the same type as p,
    # and return the List containing them.
    def get_unresolved_permissions(p)
      synchronized((self)) do
        return @perms.get(p.get_class.get_name)
      end
    end
    
    typesig { [Permission] }
    # always returns false for unresolved permissions
    def implies(permission)
      return false
    end
    
    typesig { [] }
    # Returns an enumeration of all the UnresolvedPermission lists in the
    # container.
    # 
    # @return an enumeration of all the UnresolvedPermission objects.
    def elements
      results = ArrayList.new # where results are stored
      # Get iterator of Map values (which are lists of permissions)
      synchronized((self)) do
        @perms.values.each do |l|
          synchronized((l)) do
            results.add_all(l)
          end
        end
      end
      return Collections.enumeration(results)
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -7176153071733132400 }
      const_attr_reader  :SerialVersionUID
      
      # Need to maintain serialization interoperability with earlier releases,
      # which had the serializable field:
      # private Hashtable permissions; // keyed on type
      # @serialField permissions java.util.Hashtable
      #     A table of the UnresolvedPermissions keyed on type, value is Vector
      #     of permissions
      const_set_lazy(:SerialPersistentFields) { Array.typed(ObjectStreamField).new([ObjectStreamField.new("permissions", Hashtable)]) }
      const_attr_reader  :SerialPersistentFields
    }
    
    typesig { [ObjectOutputStream] }
    # @serialData Default field.
    # Writes the contents of the perms field out as a Hashtable
    # in which the values are Vectors for
    # serialization compatibility with earlier releases.
    def write_object(out)
      # Don't call out.defaultWriteObject()
      # Copy perms into a Hashtable
      permissions = Hashtable.new(@perms.size * 2)
      # Convert each entry (List) into a Vector
      synchronized((self)) do
        set = @perms.entry_set
        set.each do |e|
          # Convert list into Vector
          list = e.get_value
          vec = Vector.new(list.size)
          synchronized((list)) do
            vec.add_all(list)
          end
          # Add to Hashtable being serialized
          permissions.put(e.get_key, vec)
        end
      end
      # Write out serializable fields
      pfields = out.put_fields
      pfields.put("permissions", permissions)
      out.write_fields
    end
    
    typesig { [ObjectInputStream] }
    # Reads in a Hashtable in which the values are Vectors of
    # UnresolvedPermissions and saves them in the perms field.
    def read_object(in_)
      # Don't call defaultReadObject()
      # Read in serialized fields
      gfields = in_.read_fields
      # Get permissions
      permissions = gfields.get("permissions", nil)
      @perms = HashMap.new(permissions.size * 2)
      # Convert each entry (Vector) into a List
      set = permissions.entry_set
      set.each do |e|
        # Convert Vector into ArrayList
        vec = e.get_value
        list = ArrayList.new(vec.size)
        list.add_all(vec)
        # Add to Hashtable being serialized
        @perms.put(e.get_key, list)
      end
    end
    
    private
    alias_method :initialize__unresolved_permission_collection, :initialize
  end
  
end
