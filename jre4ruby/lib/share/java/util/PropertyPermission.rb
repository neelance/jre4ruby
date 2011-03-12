require "rjava"

# Copyright 1997-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util
  module PropertyPermissionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Io, :Serializable
      include_const ::Java::Io, :IOException
      include ::Java::Security
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :Collections
      include_const ::Java::Io, :ObjectStreamField
      include_const ::Java::Io, :ObjectOutputStream
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Io, :IOException
      include_const ::Sun::Security::Util, :SecurityConstants
    }
  end
  
  # This class is for property permissions.
  # 
  # <P>
  # The name is the name of the property ("java.home",
  # "os.name", etc). The naming
  # convention follows the  hierarchical property naming convention.
  # Also, an asterisk
  # may appear at the end of the name, following a ".", or by itself, to
  # signify a wildcard match. For example: "java.*" or "*" is valid,
  # "*java" or "a*b" is not valid.
  # <P>
  # <P>
  # The actions to be granted are passed to the constructor in a string containing
  # a list of zero or more comma-separated keywords. The possible keywords are
  # "read" and "write". Their meaning is defined as follows:
  # <P>
  # <DL>
  #    <DT> read
  #    <DD> read permission. Allows <code>System.getProperty</code> to
  #         be called.
  #    <DT> write
  #    <DD> write permission. Allows <code>System.setProperty</code> to
  #         be called.
  # </DL>
  # <P>
  # The actions string is converted to lowercase before processing.
  # <P>
  # Care should be taken before granting code permission to access
  # certain system properties.  For example, granting permission to
  # access the "java.home" system property gives potentially malevolent
  # code sensitive information about the system environment (the Java
  # installation directory).  Also, granting permission to access
  # the "user.name" and "user.home" system properties gives potentially
  # malevolent code sensitive information about the user environment
  # (the user's account name and home directory).
  # 
  # @see java.security.BasicPermission
  # @see java.security.Permission
  # @see java.security.Permissions
  # @see java.security.PermissionCollection
  # @see java.lang.SecurityManager
  # 
  # 
  # @author Roland Schemers
  # @since 1.2
  # 
  # @serial exclude
  class PropertyPermission < PropertyPermissionImports.const_get :BasicPermission
    include_class_members PropertyPermissionImports
    
    class_module.module_eval {
      # Read action.
      const_set_lazy(:READ) { 0x1 }
      const_attr_reader  :READ
      
      # Write action.
      const_set_lazy(:WRITE) { 0x2 }
      const_attr_reader  :WRITE
      
      # All actions (read,write);
      const_set_lazy(:ALL) { READ | WRITE }
      const_attr_reader  :ALL
      
      # No actions.
      const_set_lazy(:NONE) { 0x0 }
      const_attr_reader  :NONE
    }
    
    # The actions mask.
    attr_accessor :mask
    alias_method :attr_mask, :mask
    undef_method :mask
    alias_method :attr_mask=, :mask=
    undef_method :mask=
    
    # The actions string.
    # 
    # @serial
    attr_accessor :actions
    alias_method :attr_actions, :actions
    undef_method :actions
    alias_method :attr_actions=, :actions=
    undef_method :actions=
    
    typesig { [::Java::Int] }
    # Left null as long as possible, then
    # created and re-used in the getAction function.
    # initialize a PropertyPermission object. Common to all constructors.
    # Also called during de-serialization.
    # 
    # @param mask the actions mask to use.
    def init(mask)
      if (!((mask & ALL)).equal?(mask))
        raise IllegalArgumentException.new("invalid actions mask")
      end
      if ((mask).equal?(NONE))
        raise IllegalArgumentException.new("invalid actions mask")
      end
      if ((get_name).nil?)
        raise NullPointerException.new("name can't be null")
      end
      @mask = mask
    end
    
    typesig { [String, String] }
    # Creates a new PropertyPermission object with the specified name.
    # The name is the name of the system property, and
    # <i>actions</i> contains a comma-separated list of the
    # desired actions granted on the property. Possible actions are
    # "read" and "write".
    # 
    # @param name the name of the PropertyPermission.
    # @param actions the actions string.
    # 
    # @throws NullPointerException if <code>name</code> is <code>null</code>.
    # @throws IllegalArgumentException if <code>name</code> is empty or if
    # <code>actions</code> is invalid.
    def initialize(name, actions)
      @mask = 0
      @actions = nil
      super(name, actions)
      init(get_mask(actions))
    end
    
    typesig { [Permission] }
    # Checks if this PropertyPermission object "implies" the specified
    # permission.
    # <P>
    # More specifically, this method returns true if:<p>
    # <ul>
    # <li> <i>p</i> is an instanceof PropertyPermission,<p>
    # <li> <i>p</i>'s actions are a subset of this
    # object's actions, and <p>
    # <li> <i>p</i>'s name is implied by this object's
    #      name. For example, "java.*" implies "java.home".
    # </ul>
    # @param p the permission to check against.
    # 
    # @return true if the specified permission is implied by this object,
    # false if not.
    def implies(p)
      if (!(p.is_a?(PropertyPermission)))
        return false
      end
      that = p
      # we get the effective mask. i.e., the "and" of this and that.
      # They must be equal to that.mask for implies to return true.
      return (((@mask & that.attr_mask)).equal?(that.attr_mask)) && super(that)
    end
    
    typesig { [Object] }
    # Checks two PropertyPermission objects for equality. Checks that <i>obj</i> is
    # a PropertyPermission, and has the same name and actions as this object.
    # <P>
    # @param obj the object we are testing for equality with this object.
    # @return true if obj is a PropertyPermission, and has the same name and
    # actions as this PropertyPermission object.
    def ==(obj)
      if ((obj).equal?(self))
        return true
      end
      if (!(obj.is_a?(PropertyPermission)))
        return false
      end
      that = obj
      return ((@mask).equal?(that.attr_mask)) && ((self.get_name == that.get_name))
    end
    
    typesig { [] }
    # Returns the hash code value for this object.
    # The hash code used is the hash code of this permissions name, that is,
    # <code>getName().hashCode()</code>, where <code>getName</code> is
    # from the Permission superclass.
    # 
    # @return a hash code value for this object.
    def hash_code
      return self.get_name.hash_code
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Converts an actions String to an actions mask.
      # 
      # @param action the action string.
      # @return the actions mask.
      def get_mask(actions)
        mask = NONE
        if ((actions).nil?)
          return mask
        end
        # Check against use of constants (used heavily within the JDK)
        if ((actions).equal?(SecurityConstants::PROPERTY_READ_ACTION))
          return READ
        end
        if ((actions).equal?(SecurityConstants::PROPERTY_WRITE_ACTION))
          return WRITE
        else
          if ((actions).equal?(SecurityConstants::PROPERTY_RW_ACTION))
            return READ | WRITE
          end
        end
        a = actions.to_char_array
        i = a.attr_length - 1
        if (i < 0)
          return mask
        end
        while (!(i).equal?(-1))
          c = 0
          # skip whitespace
          while ((!(i).equal?(-1)) && (((c = a[i])).equal?(Character.new(?\s.ord)) || (c).equal?(Character.new(?\r.ord)) || (c).equal?(Character.new(?\n.ord)) || (c).equal?(Character.new(?\f.ord)) || (c).equal?(Character.new(?\t.ord))))
            i -= 1
          end
          # check for the known strings
          matchlen = 0
          if (i >= 3 && ((a[i - 3]).equal?(Character.new(?r.ord)) || (a[i - 3]).equal?(Character.new(?R.ord))) && ((a[i - 2]).equal?(Character.new(?e.ord)) || (a[i - 2]).equal?(Character.new(?E.ord))) && ((a[i - 1]).equal?(Character.new(?a.ord)) || (a[i - 1]).equal?(Character.new(?A.ord))) && ((a[i]).equal?(Character.new(?d.ord)) || (a[i]).equal?(Character.new(?D.ord))))
            matchlen = 4
            mask |= READ
          else
            if (i >= 4 && ((a[i - 4]).equal?(Character.new(?w.ord)) || (a[i - 4]).equal?(Character.new(?W.ord))) && ((a[i - 3]).equal?(Character.new(?r.ord)) || (a[i - 3]).equal?(Character.new(?R.ord))) && ((a[i - 2]).equal?(Character.new(?i.ord)) || (a[i - 2]).equal?(Character.new(?I.ord))) && ((a[i - 1]).equal?(Character.new(?t.ord)) || (a[i - 1]).equal?(Character.new(?T.ord))) && ((a[i]).equal?(Character.new(?e.ord)) || (a[i]).equal?(Character.new(?E.ord))))
              matchlen = 5
              mask |= WRITE
            else
              # parse error
              raise IllegalArgumentException.new("invalid permission: " + actions)
            end
          end
          # make sure we didn't just match the tail of a word
          # like "ackbarfaccept".  Also, skip to the comma.
          seencomma = false
          while (i >= matchlen && !seencomma)
            case (a[i - matchlen])
            when Character.new(?,.ord)
              seencomma = true
              # FALLTHROUGH
            when Character.new(?\s.ord), Character.new(?\r.ord), Character.new(?\n.ord), Character.new(?\f.ord), Character.new(?\t.ord)
              # FALLTHROUGH
            else
              raise IllegalArgumentException.new("invalid permission: " + actions)
            end
            i -= 1
          end
          # point i at the location of the comma minus one (or -1).
          i -= matchlen
        end
        return mask
      end
      
      typesig { [::Java::Int] }
      # Return the canonical string representation of the actions.
      # Always returns present actions in the following order:
      # read, write.
      # 
      # @return the canonical string representation of the actions.
      def get_actions(mask)
        sb = StringBuilder.new
        comma = false
        if (((mask & READ)).equal?(READ))
          comma = true
          sb.append("read")
        end
        if (((mask & WRITE)).equal?(WRITE))
          if (comma)
            sb.append(Character.new(?,.ord))
          else
            comma = true
          end
          sb.append("write")
        end
        return sb.to_s
      end
    }
    
    typesig { [] }
    # Returns the "canonical string representation" of the actions.
    # That is, this method always returns present actions in the following order:
    # read, write. For example, if this PropertyPermission object
    # allows both write and read actions, a call to <code>getActions</code>
    # will return the string "read,write".
    # 
    # @return the canonical string representation of the actions.
    def get_actions
      if ((@actions).nil?)
        @actions = RJava.cast_to_string(get_actions(@mask))
      end
      return @actions
    end
    
    typesig { [] }
    # Return the current action mask.
    # Used by the PropertyPermissionCollection
    # 
    # @return the actions mask.
    def get_mask
      return @mask
    end
    
    typesig { [] }
    # Returns a new PermissionCollection object for storing
    # PropertyPermission objects.
    # <p>
    # 
    # @return a new PermissionCollection object suitable for storing
    # PropertyPermissions.
    def new_permission_collection
      return PropertyPermissionCollection.new
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 885438825399942851 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [Java::Io::ObjectOutputStream] }
    # WriteObject is called to save the state of the PropertyPermission
    # to a stream. The actions are serialized, and the superclass
    # takes care of the name.
    def write_object(s)
      synchronized(self) do
        # Write out the actions. The superclass takes care of the name
        # call getActions to make sure actions field is initialized
        if ((@actions).nil?)
          get_actions
        end
        s.default_write_object
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # readObject is called to restore the state of the PropertyPermission from
    # a stream.
    def read_object(s)
      synchronized(self) do
        # Read in the action, then initialize the rest
        s.default_read_object
        init(get_mask(@actions))
      end
    end
    
    private
    alias_method :initialize__property_permission, :initialize
  end
  
  # A PropertyPermissionCollection stores a set of PropertyPermission
  # permissions.
  # 
  # @see java.security.Permission
  # @see java.security.Permissions
  # @see java.security.PermissionCollection
  # 
  # 
  # @author Roland Schemers
  # 
  # @serial include
  class PropertyPermissionCollection < PropertyPermissionImports.const_get :PermissionCollection
    include_class_members PropertyPermissionImports
    overload_protected {
      include Serializable
    }
    
    # Key is property name; value is PropertyPermission.
    # Not serialized; see serialization section at end of class.
    attr_accessor :perms
    alias_method :attr_perms, :perms
    undef_method :perms
    alias_method :attr_perms=, :perms=
    undef_method :perms=
    
    # Boolean saying if "*" is in the collection.
    # 
    # @see #serialPersistentFields
    # No sync access; OK for this to be stale.
    attr_accessor :all_allowed
    alias_method :attr_all_allowed, :all_allowed
    undef_method :all_allowed
    alias_method :attr_all_allowed=, :all_allowed=
    undef_method :all_allowed=
    
    typesig { [] }
    # Create an empty PropertyPermissions object.
    def initialize
      @perms = nil
      @all_allowed = false
      super()
      @perms = HashMap.new(32) # Capacity for default policy
      @all_allowed = false
    end
    
    typesig { [Permission] }
    # Adds a permission to the PropertyPermissions. The key for the hash is
    # the name.
    # 
    # @param permission the Permission object to add.
    # 
    # @exception IllegalArgumentException - if the permission is not a
    #                                       PropertyPermission
    # 
    # @exception SecurityException - if this PropertyPermissionCollection
    #                                object has been marked readonly
    def add(permission)
      if (!(permission.is_a?(PropertyPermission)))
        raise IllegalArgumentException.new("invalid permission: " + RJava.cast_to_string(permission))
      end
      if (is_read_only)
        raise SecurityException.new("attempt to add a Permission to a readonly PermissionCollection")
      end
      pp = permission
      prop_name = pp.get_name
      synchronized((self)) do
        existing = @perms.get(prop_name)
        if (!(existing).nil?)
          old_mask = existing.get_mask
          new_mask = pp.get_mask
          if (!(old_mask).equal?(new_mask))
            effective = old_mask | new_mask
            actions = PropertyPermission.get_actions(effective)
            @perms.put(prop_name, PropertyPermission.new(prop_name, actions))
          end
        else
          @perms.put(prop_name, permission)
        end
      end
      if (!@all_allowed)
        if ((prop_name == "*"))
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
      if (!(permission.is_a?(PropertyPermission)))
        return false
      end
      pp = permission
      x = nil
      desired = pp.get_mask
      effective = 0
      # short circuit if the "*" Permission was added
      if (@all_allowed)
        synchronized((self)) do
          x = @perms.get("*")
        end
        if (!(x).nil?)
          effective |= x.get_mask
          if (((effective & desired)).equal?(desired))
            return true
          end
        end
      end
      # strategy:
      # Check for full match first. Then work our way up the
      # name looking for matches on a.b.*
      name = pp.get_name
      # System.out.println("check "+name);
      synchronized((self)) do
        x = @perms.get(name)
      end
      if (!(x).nil?)
        # we have a direct hit!
        effective |= x.get_mask
        if (((effective & desired)).equal?(desired))
          return true
        end
      end
      # work our way up the tree...
      last = 0
      offset = 0
      offset = name.length - 1
      while (!((last = name.last_index_of(".", offset))).equal?(-1))
        name = RJava.cast_to_string(name.substring(0, last + 1)) + "*"
        # System.out.println("check "+name);
        synchronized((self)) do
          x = @perms.get(name)
        end
        if (!(x).nil?)
          effective |= x.get_mask
          if (((effective & desired)).equal?(desired))
            return true
          end
        end
        offset = last - 1
      end
      # we don't have to check for "*" as it was already checked
      # at the top (all_allowed), so we just return false
      return false
    end
    
    typesig { [] }
    # Returns an enumeration of all the PropertyPermission objects in the
    # container.
    # 
    # @return an enumeration of all the PropertyPermission objects.
    def elements
      # Convert Iterator of Map values into an Enumeration
      synchronized((self)) do
        return Collections.enumeration(@perms.values)
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 7015263904581634791 }
      const_attr_reader  :SerialVersionUID
      
      # Need to maintain serialization interoperability with earlier releases,
      # which had the serializable field:
      # 
      # Table of permissions.
      # 
      # @serial
      # 
      # private Hashtable permissions;
      # @serialField permissions java.util.Hashtable
      #     A table of the PropertyPermissions.
      # @serialField all_allowed boolean
      #     boolean saying if "*" is in the collection.
      const_set_lazy(:SerialPersistentFields) { Array.typed(ObjectStreamField).new([ObjectStreamField.new("permissions", Hashtable), ObjectStreamField.new("all_allowed", Boolean::TYPE)]) }
      const_attr_reader  :SerialPersistentFields
    }
    
    typesig { [ObjectOutputStream] }
    # @serialData Default fields.
    # Writes the contents of the perms field out as a Hashtable for
    # serialization compatibility with earlier releases. all_allowed
    # unchanged.
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
      out.write_fields
    end
    
    typesig { [ObjectInputStream] }
    # Reads in a Hashtable of PropertyPermissions and saves them in the
    # perms field. Reads in all_allowed.
    def read_object(in_)
      # Don't call defaultReadObject()
      # Read in serialized fields
      gfields = in_.read_fields
      # Get all_allowed
      @all_allowed = gfields.get("all_allowed", false)
      # Get permissions
      permissions = gfields.get("permissions", nil)
      @perms = HashMap.new(permissions.size * 2)
      @perms.put_all(permissions)
    end
    
    private
    alias_method :initialize__property_permission_collection, :initialize
  end
  
end
