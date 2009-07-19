require "rjava"

# Copyright 1997-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module BasicPermissionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Security
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Io, :ObjectStreamField
      include_const ::Java::Io, :ObjectOutputStream
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # The BasicPermission class extends the Permission class, and
  # can be used as the base class for permissions that want to
  # follow the same naming convention as BasicPermission.
  # <P>
  # The name for a BasicPermission is the name of the given permission
  # (for example, "exit",
  # "setFactory", "print.queueJob", etc). The naming
  # convention follows the  hierarchical property naming convention.
  # An asterisk may appear by itself, or if immediately preceded by a "."
  # may appear at the end of the name, to signify a wildcard match.
  # For example, "*" and "java.*" are valid, while "*java", "a*b",
  # and "java*" are not valid.
  # <P>
  # The action string (inherited from Permission) is unused.
  # Thus, BasicPermission is commonly used as the base class for
  # "named" permissions
  # (ones that contain a name but no actions list; you either have the
  # named permission or you don't.)
  # Subclasses may implement actions on top of BasicPermission,
  # if desired.
  # <p>
  # <P>
  # @see java.security.Permission
  # @see java.security.Permissions
  # @see java.security.PermissionCollection
  # @see java.lang.RuntimePermission
  # @see java.security.SecurityPermission
  # @see java.util.PropertyPermission
  # @see java.awt.AWTPermission
  # @see java.net.NetPermission
  # @see java.lang.SecurityManager
  # 
  # 
  # @author Marianne Mueller
  # @author Roland Schemers
  class BasicPermission < BasicPermissionImports.const_get :Permission
    include_class_members BasicPermissionImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 6279438298436773498 }
      const_attr_reader  :SerialVersionUID
    }
    
    # does this permission have a wildcard at the end?
    attr_accessor :wildcard
    alias_method :attr_wildcard, :wildcard
    undef_method :wildcard
    alias_method :attr_wildcard=, :wildcard=
    undef_method :wildcard=
    
    # the name without the wildcard on the end
    attr_accessor :path
    alias_method :attr_path, :path
    undef_method :path
    alias_method :attr_path=, :path=
    undef_method :path=
    
    # is this permission the old-style exitVM permission (pre JDK 1.6)?
    attr_accessor :exit_vm
    alias_method :attr_exit_vm, :exit_vm
    undef_method :exit_vm
    alias_method :attr_exit_vm=, :exit_vm=
    undef_method :exit_vm=
    
    typesig { [String] }
    # initialize a BasicPermission object. Common to all constructors.
    def init(name)
      if ((name).nil?)
        raise NullPointerException.new("name can't be null")
      end
      len = name.length
      if ((len).equal?(0))
        raise IllegalArgumentException.new("name can't be empty")
      end
      last = name.char_at(len - 1)
      # Is wildcard or ends with ".*"?
      if ((last).equal?(Character.new(?*.ord)) && ((len).equal?(1) || (name.char_at(len - 2)).equal?(Character.new(?..ord))))
        @wildcard = true
        if ((len).equal?(1))
          @path = ""
        else
          @path = (name.substring(0, len - 1)).to_s
        end
      else
        if ((name == "exitVM"))
          @wildcard = true
          @path = "exitVM."
          @exit_vm = true
        else
          @path = name
        end
      end
    end
    
    typesig { [String] }
    # Creates a new BasicPermission with the specified name.
    # Name is the symbolic name of the permission, such as
    # "setFactory",
    # "print.queueJob", or "topLevelWindow", etc.
    # 
    # @param name the name of the BasicPermission.
    # 
    # @throws NullPointerException if <code>name</code> is <code>null</code>.
    # @throws IllegalArgumentException if <code>name</code> is empty.
    def initialize(name)
      @wildcard = false
      @path = nil
      @exit_vm = false
      super(name)
      init(name)
    end
    
    typesig { [String, String] }
    # Creates a new BasicPermission object with the specified name.
    # The name is the symbolic name of the BasicPermission, and the
    # actions String is currently unused.
    # 
    # @param name the name of the BasicPermission.
    # @param actions ignored.
    # 
    # @throws NullPointerException if <code>name</code> is <code>null</code>.
    # @throws IllegalArgumentException if <code>name</code> is empty.
    def initialize(name, actions)
      @wildcard = false
      @path = nil
      @exit_vm = false
      super(name)
      init(name)
    end
    
    typesig { [Permission] }
    # Checks if the specified permission is "implied" by
    # this object.
    # <P>
    # More specifically, this method returns true if:<p>
    # <ul>
    # <li> <i>p</i>'s class is the same as this object's class, and<p>
    # <li> <i>p</i>'s name equals or (in the case of wildcards)
    # is implied by this object's
    # name. For example, "a.b.*" implies "a.b.c".
    # </ul>
    # 
    # @param p the permission to check against.
    # 
    # @return true if the passed permission is equal to or
    # implied by this permission, false otherwise.
    def implies(p)
      if (((p).nil?) || (!(p.get_class).equal?(get_class)))
        return false
      end
      that = p
      if (@wildcard)
        if (that.attr_wildcard)
          # one wildcard can imply another
          return that.attr_path.starts_with(@path)
        else
          # make sure ap.path is longer so a.b.* doesn't imply a.b
          return (that.attr_path.length > @path.length) && that.attr_path.starts_with(@path)
        end
      else
        if (that.attr_wildcard)
          # a non-wildcard can't imply a wildcard
          return false
        else
          return (@path == that.attr_path)
        end
      end
    end
    
    typesig { [Object] }
    # Checks two BasicPermission objects for equality.
    # Checks that <i>obj</i>'s class is the same as this object's class
    # and has the same name as this object.
    # <P>
    # @param obj the object we are testing for equality with this object.
    # @return true if <i>obj</i> is a BasicPermission, and has the same name
    # as this BasicPermission object, false otherwise.
    def equals(obj)
      if ((obj).equal?(self))
        return true
      end
      if (((obj).nil?) || (!(obj.get_class).equal?(get_class)))
        return false
      end
      bp = obj
      return (get_name == bp.get_name)
    end
    
    typesig { [] }
    # Returns the hash code value for this object.
    # The hash code used is the hash code of the name, that is,
    # <code>getName().hashCode()</code>, where <code>getName</code> is
    # from the Permission superclass.
    # 
    # @return a hash code value for this object.
    def hash_code
      return self.get_name.hash_code
    end
    
    typesig { [] }
    # Returns the canonical string representation of the actions,
    # which currently is the empty string "", since there are no actions for
    # a BasicPermission.
    # 
    # @return the empty string "".
    def get_actions
      return ""
    end
    
    typesig { [] }
    # Returns a new PermissionCollection object for storing BasicPermission
    # objects.
    # 
    # <p>BasicPermission objects must be stored in a manner that allows them
    # to be inserted in any order, but that also enables the
    # PermissionCollection <code>implies</code> method
    # to be implemented in an efficient (and consistent) manner.
    # 
    # @return a new PermissionCollection object suitable for
    # storing BasicPermissions.
    def new_permission_collection
      return BasicPermissionCollection.new(self.get_class)
    end
    
    typesig { [ObjectInputStream] }
    # readObject is called to restore the state of the BasicPermission from
    # a stream.
    def read_object(s)
      s.default_read_object
      # init is called to initialize the rest of the values.
      init(get_name)
    end
    
    typesig { [] }
    # Returns the canonical name of this BasicPermission.
    # All internal invocations of getName should invoke this method, so
    # that the pre-JDK 1.6 "exitVM" and current "exitVM.*" permission are
    # equivalent in equals/hashCode methods.
    # 
    # @return the canonical name of this BasicPermission.
    def get_canonical_name
      return @exit_vm ? "exitVM.*" : get_name
    end
    
    private
    alias_method :initialize__basic_permission, :initialize
  end
  
  # A BasicPermissionCollection stores a collection
  # of BasicPermission permissions. BasicPermission objects
  # must be stored in a manner that allows them to be inserted in any
  # order, but enable the implies function to evaluate the implies
  # method in an efficient (and consistent) manner.
  # 
  # A BasicPermissionCollection handles comparing a permission like "a.b.c.d.e"
  # with a Permission such as "a.b.*", or "*".
  # 
  # @see java.security.Permission
  # @see java.security.Permissions
  # @see java.security.PermissionsImpl
  # 
  # 
  # @author Roland Schemers
  # 
  # @serial include
  class BasicPermissionCollection < BasicPermissionImports.const_get :PermissionCollection
    include_class_members BasicPermissionImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 739301742472979399 }
      const_attr_reader  :SerialVersionUID
    }
    
    # Key is name, value is permission. All permission objects in
    # collection must be of the same type.
    # Not serialized; see serialization section at end of class.
    attr_accessor :perms
    alias_method :attr_perms, :perms
    undef_method :perms
    alias_method :attr_perms=, :perms=
    undef_method :perms=
    
    # This is set to <code>true</code> if this BasicPermissionCollection
    # contains a BasicPermission with '*' as its permission name.
    # 
    # @see #serialPersistentFields
    attr_accessor :all_allowed
    alias_method :attr_all_allowed, :all_allowed
    undef_method :all_allowed
    alias_method :attr_all_allowed=, :all_allowed=
    undef_method :all_allowed=
    
    # The class to which all BasicPermissions in this
    # BasicPermissionCollection belongs.
    # 
    # @see #serialPersistentFields
    attr_accessor :perm_class
    alias_method :attr_perm_class, :perm_class
    undef_method :perm_class
    alias_method :attr_perm_class=, :perm_class=
    undef_method :perm_class=
    
    typesig { [Class] }
    # Create an empty BasicPermissionCollection object.
    def initialize(clazz)
      @perms = nil
      @all_allowed = false
      @perm_class = nil
      super()
      @perms = HashMap.new(11)
      @all_allowed = false
      @perm_class = clazz
    end
    
    typesig { [Permission] }
    # Adds a permission to the BasicPermissions. The key for the hash is
    # permission.path.
    # 
    # @param permission the Permission object to add.
    # 
    # @exception IllegalArgumentException - if the permission is not a
    # BasicPermission, or if
    # the permission is not of the
    # same Class as the other
    # permissions in this collection.
    # 
    # @exception SecurityException - if this BasicPermissionCollection object
    # has been marked readonly
    def add(permission)
      if (!(permission.is_a?(BasicPermission)))
        raise IllegalArgumentException.new("invalid permission: " + (permission).to_s)
      end
      if (is_read_only)
        raise SecurityException.new("attempt to add a Permission to a readonly PermissionCollection")
      end
      bp = permission
      # make sure we only add new BasicPermissions of the same class
      # Also check null for compatibility with deserialized form from
      # previous versions.
      if ((@perm_class).nil?)
        # adding first permission
        @perm_class = bp.get_class
      else
        if (!(bp.get_class).equal?(@perm_class))
          raise IllegalArgumentException.new("invalid permission: " + (permission).to_s)
        end
      end
      synchronized((self)) do
        @perms.put(bp.get_canonical_name, permission)
      end
      # No sync on all_allowed; staleness OK
      if (!@all_allowed)
        if ((bp.get_canonical_name == "*"))
          @all_allowed = true
        end
      end
    end
    
    typesig { [Permission] }
    # Check and see if this set of permissions implies the permissions
    # expressed in "permission".
    # 
    # @param p the Permission object to compare
    # 
    # @return true if "permission" is a proper subset of a permission in
    # the set, false if not.
    def implies(permission)
      if (!(permission.is_a?(BasicPermission)))
        return false
      end
      bp = permission
      # random subclasses of BasicPermission do not imply each other
      if (!(bp.get_class).equal?(@perm_class))
        return false
      end
      # short circuit if the "*" Permission was added
      if (@all_allowed)
        return true
      end
      # strategy:
      # Check for full match first. Then work our way up the
      # path looking for matches on a.b..*
      path = bp.get_canonical_name
      # System.out.println("check "+path);
      x = nil
      synchronized((self)) do
        x = @perms.get(path)
      end
      if (!(x).nil?)
        # we have a direct hit!
        return x.implies(permission)
      end
      # work our way up the tree...
      last = 0
      offset = 0
      offset = path.length - 1
      while (!((last = path.last_index_of(".", offset))).equal?(-1))
        path = (path.substring(0, last + 1)).to_s + "*"
        # System.out.println("check "+path);
        synchronized((self)) do
          x = @perms.get(path)
        end
        if (!(x).nil?)
          return x.implies(permission)
        end
        offset = last - 1
      end
      # we don't have to check for "*" as it was already checked
      # at the top (all_allowed), so we just return false
      return false
    end
    
    typesig { [] }
    # Returns an enumeration of all the BasicPermission objects in the
    # container.
    # 
    # @return an enumeration of all the BasicPermission objects.
    def elements
      # Convert Iterator of Map values into an Enumeration
      synchronized((self)) do
        return Collections.enumeration(@perms.values)
      end
    end
    
    class_module.module_eval {
      # Need to maintain serialization interoperability with earlier releases,
      # which had the serializable field:
      # 
      # @serial the Hashtable is indexed by the BasicPermission name
      # 
      # private Hashtable permissions;
      # 
      # @serialField permissions java.util.Hashtable
      # The BasicPermissions in this BasicPermissionCollection.
      # All BasicPermissions in the collection must belong to the same class.
      # The Hashtable is indexed by the BasicPermission name; the value
      # of the Hashtable entry is the permission.
      # @serialField all_allowed boolean
      # This is set to <code>true</code> if this BasicPermissionCollection
      # contains a BasicPermission with '*' as its permission name.
      # @serialField permClass java.lang.Class
      # The class to which all BasicPermissions in this
      # BasicPermissionCollection belongs.
      const_set_lazy(:SerialPersistentFields) { Array.typed(ObjectStreamField).new([ObjectStreamField.new("permissions", Hashtable.class), ObjectStreamField.new("all_allowed", Boolean::TYPE), ObjectStreamField.new("permClass", Class.class), ]) }
      const_attr_reader  :SerialPersistentFields
    }
    
    typesig { [ObjectOutputStream] }
    # @serialData Default fields.
    # 
    # 
    # Writes the contents of the perms field out as a Hashtable for
    # serialization compatibility with earlier releases. all_allowed
    # and permClass unchanged.
    def write_object(out)
      # Don't call out.defaultWriteObject()
      # Copy perms into a Hashtable
      permissions = Hashtable.new(@perms.size * 2)
      synchronized((self)) do
        permissions.put_all(@perms)
      end
      # Write out serializable fields
      pfields = out.put_fields
      pfields.put("all_allowed", @all_allowed)
      pfields.put("permissions", permissions)
      pfields.put("permClass", @perm_class)
      out.write_fields
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # readObject is called to restore the state of the
    # BasicPermissionCollection from a stream.
    def read_object(in_)
      # Don't call defaultReadObject()
      # Read in serialized fields
      gfields = in_.read_fields
      # Get permissions
      permissions = gfields.get("permissions", nil)
      @perms = HashMap.new(permissions.size * 2)
      @perms.put_all(permissions)
      # Get all_allowed
      @all_allowed = gfields.get("all_allowed", false)
      # Get permClass
      @perm_class = gfields.get("permClass", nil)
      if ((@perm_class).nil?)
        # set permClass
        e = permissions.elements
        if (e.has_more_elements)
          p = e.next_element
          @perm_class = p.get_class
        end
      end
    end
    
    private
    alias_method :initialize__basic_permission_collection, :initialize
  end
  
end
