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
  module PermissionCollectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Util
    }
  end
  
  # Abstract class representing a collection of Permission objects.
  # 
  # <p>With a PermissionCollection, you can:
  # <UL>
  # <LI> add a permission to the collection using the <code>add</code> method.
  # <LI> check to see if a particular permission is implied in the
  # collection, using the <code>implies</code> method.
  # <LI> enumerate all the permissions, using the <code>elements</code> method.
  # </UL>
  # <P>
  # 
  # <p>When it is desirable to group together a number of Permission objects
  # of the same type, the <code>newPermissionCollection</code> method on that
  # particular type of Permission object should first be called. The default
  # behavior (from the Permission class) is to simply return null.
  # Subclasses of class Permission override the method if they need to store
  # their permissions in a particular PermissionCollection object in order
  # to provide the correct semantics when the
  # <code>PermissionCollection.implies</code> method is called.
  # If a non-null value is returned, that PermissionCollection must be used.
  # If null is returned, then the caller of <code>newPermissionCollection</code>
  # is free to store permissions of the
  # given type in any PermissionCollection they choose
  # (one that uses a Hashtable, one that uses a Vector, etc).
  # 
  # <p>The PermissionCollection returned by the
  # <code>Permission.newPermissionCollection</code>
  # method is a homogeneous collection, which stores only Permission objects
  # for a given Permission type.  A PermissionCollection may also be
  # heterogeneous.  For example, Permissions is a PermissionCollection
  # subclass that represents a collection of PermissionCollections.
  # That is, its members are each a homogeneous PermissionCollection.
  # For example, a Permissions object might have a FilePermissionCollection
  # for all the FilePermission objects, a SocketPermissionCollection for all the
  # SocketPermission objects, and so on. Its <code>add</code> method adds a
  # permission to the appropriate collection.
  # 
  # <p>Whenever a permission is added to a heterogeneous PermissionCollection
  # such as Permissions, and the PermissionCollection doesn't yet contain a
  # PermissionCollection of the specified permission's type, the
  # PermissionCollection should call
  # the <code>newPermissionCollection</code> method on the permission's class
  # to see if it requires a special PermissionCollection. If
  # <code>newPermissionCollection</code>
  # returns null, the PermissionCollection
  # is free to store the permission in any type of PermissionCollection it
  # desires (one using a Hashtable, one using a Vector, etc.). For example,
  # the Permissions object uses a default PermissionCollection implementation
  # that stores the permission objects in a Hashtable.
  # 
  # <p> Subclass implementations of PermissionCollection should assume
  # that they may be called simultaneously from multiple threads,
  # and therefore should be synchronized properly.  Furthermore,
  # Enumerations returned via the <code>elements</code> method are
  # not <em>fail-fast</em>.  Modifications to a collection should not be
  # performed while enumerating over that collection.
  # 
  # @see Permission
  # @see Permissions
  # 
  # 
  # @author Roland Schemers
  class PermissionCollection 
    include_class_members PermissionCollectionImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -6727011328946861783 }
      const_attr_reader  :SerialVersionUID
    }
    
    # when set, add will throw an exception.
    attr_accessor :read_only
    alias_method :attr_read_only, :read_only
    undef_method :read_only
    alias_method :attr_read_only=, :read_only=
    undef_method :read_only=
    
    typesig { [Permission] }
    # Adds a permission object to the current collection of permission objects.
    # 
    # @param permission the Permission object to add.
    # 
    # @exception SecurityException -  if this PermissionCollection object
    # has been marked readonly
    def add(permission)
      raise NotImplementedError
    end
    
    typesig { [Permission] }
    # Checks to see if the specified permission is implied by
    # the collection of Permission objects held in this PermissionCollection.
    # 
    # @param permission the Permission object to compare.
    # 
    # @return true if "permission" is implied by the  permissions in
    # the collection, false if not.
    def implies(permission)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns an enumeration of all the Permission objects in the collection.
    # 
    # @return an enumeration of all the Permissions.
    def elements
      raise NotImplementedError
    end
    
    typesig { [] }
    # Marks this PermissionCollection object as "readonly". After
    # a PermissionCollection object
    # is marked as readonly, no new Permission objects can be added to it
    # using <code>add</code>.
    def set_read_only
      @read_only = true
    end
    
    typesig { [] }
    # Returns true if this PermissionCollection object is marked as readonly.
    # If it is readonly, no new Permission objects can be added to it
    # using <code>add</code>.
    # 
    # <p>By default, the object is <i>not</i> readonly. It can be set to
    # readonly by a call to <code>setReadOnly</code>.
    # 
    # @return true if this PermissionCollection object is marked as readonly,
    # false otherwise.
    def is_read_only
      return @read_only
    end
    
    typesig { [] }
    # Returns a string describing this PermissionCollection object,
    # providing information about all the permissions it contains.
    # The format is:
    # <pre>
    # super.toString() (
    # // enumerate all the Permission
    # // objects and call toString() on them,
    # // one per line..
    # )</pre>
    # 
    # <code>super.toString</code> is a call to the <code>toString</code>
    # method of this
    # object's superclass, which is Object. The result is
    # this PermissionCollection's type name followed by this object's
    # hashcode, thus enabling clients to differentiate different
    # PermissionCollections object, even if they contain the same permissions.
    # 
    # @return information about this PermissionCollection object,
    # as described above.
    def to_s
      enum_ = elements
      sb = StringBuilder.new
      sb.append(RJava.cast_to_string(super) + " (\n")
      while (enum_.has_more_elements)
        begin
          sb.append(" ")
          sb.append(enum_.next_element.to_s)
          sb.append("\n")
        rescue NoSuchElementException => e
          # ignore
        end
      end
      sb.append(")\n")
      return sb.to_s
    end
    
    typesig { [] }
    def initialize
      @read_only = false
    end
    
    private
    alias_method :initialize__permission_collection, :initialize
  end
  
end
