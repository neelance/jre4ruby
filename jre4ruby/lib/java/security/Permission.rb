require "rjava"

# 
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
module Java::Security
  module PermissionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
    }
  end
  
  # 
  # Abstract class for representing access to a system resource.
  # All permissions have a name (whose interpretation depends on the subclass),
  # as well as abstract functions for defining the semantics of the
  # particular Permission subclass.
  # 
  # <p>Most Permission objects also include an "actions" list that tells the actions
  # that are permitted for the object.  For example,
  # for a <code>java.io.FilePermission</code> object, the permission name is
  # the pathname of a file (or directory), and the actions list
  # (such as "read, write") specifies which actions are granted for the
  # specified file (or for files in the specified directory).
  # The actions list is optional for Permission objects, such as
  # <code>java.lang.RuntimePermission</code>,
  # that don't need such a list; you either have the named permission (such
  # as "system.exit") or you don't.
  # 
  # <p>An important method that must be implemented by each subclass is
  # the <code>implies</code> method to compare Permissions. Basically,
  # "permission p1 implies permission p2" means that
  # if one is granted permission p1, one is naturally granted permission p2.
  # Thus, this is not an equality test, but rather more of a
  # subset test.
  # 
  # <P> Permission objects are similar to String objects in that they
  # are immutable once they have been created. Subclasses should not
  # provide methods that can change the state of a permission
  # once it has been created.
  # 
  # @see Permissions
  # @see PermissionCollection
  # 
  # 
  # @author Marianne Mueller
  # @author Roland Schemers
  class Permission 
    include_class_members PermissionImports
    include Guard
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -5636570222231596674 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    typesig { [String] }
    # 
    # Constructs a permission with the specified name.
    # 
    # @param name name of the Permission object being created.
    def initialize(name)
      @name = nil
      @name = name
    end
    
    typesig { [Object] }
    # 
    # Implements the guard interface for a permission. The
    # <code>SecurityManager.checkPermission</code> method is called,
    # passing this permission object as the permission to check.
    # Returns silently if access is granted. Otherwise, throws
    # a SecurityException.
    # 
    # @param object the object being guarded (currently ignored).
    # 
    # @throws SecurityException
    # if a security manager exists and its
    # <code>checkPermission</code> method doesn't allow access.
    # 
    # @see Guard
    # @see GuardedObject
    # @see SecurityManager#checkPermission
    def check_guard(object)
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_permission(self)
      end
    end
    
    typesig { [Permission] }
    # 
    # Checks if the specified permission's actions are "implied by"
    # this object's actions.
    # <P>
    # This must be implemented by subclasses of Permission, as they are the
    # only ones that can impose semantics on a Permission object.
    # 
    # <p>The <code>implies</code> method is used by the AccessController to determine
    # whether or not a requested permission is implied by another permission that
    # is known to be valid in the current execution context.
    # 
    # @param permission the permission to check against.
    # 
    # @return true if the specified permission is implied by this object,
    # false if not.
    def implies(permission)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # 
    # Checks two Permission objects for equality.
    # <P>
    # Do not use the <code>equals</code> method for making access control
    # decisions; use the <code>implies</code> method.
    # 
    # @param obj the object we are testing for equality with this object.
    # 
    # @return true if both Permission objects are equivalent.
    def equals(obj)
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the hash code value for this Permission object.
    # <P>
    # The required <code>hashCode</code> behavior for Permission Objects is
    # the following: <p>
    # <ul>
    # <li>Whenever it is invoked on the same Permission object more than
    # once during an execution of a Java application, the
    # <code>hashCode</code> method
    # must consistently return the same integer. This integer need not
    # remain consistent from one execution of an application to another
    # execution of the same application. <p>
    # <li>If two Permission objects are equal according to the
    # <code>equals</code>
    # method, then calling the <code>hashCode</code> method on each of the
    # two Permission objects must produce the same integer result.
    # </ul>
    # 
    # @return a hash code value for this object.
    def hash_code
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the name of this Permission.
    # For example, in the case of a <code>java.io.FilePermission</code>,
    # the name will be a pathname.
    # 
    # @return the name of this Permission.
    def get_name
      return @name
    end
    
    typesig { [] }
    # 
    # Returns the actions as a String. This is abstract
    # so subclasses can defer creating a String representation until
    # one is needed. Subclasses should always return actions in what they
    # consider to be their
    # canonical form. For example, two FilePermission objects created via
    # the following:
    # 
    # <pre>
    # perm1 = new FilePermission(p1,"read,write");
    # perm2 = new FilePermission(p2,"write,read");
    # </pre>
    # 
    # both return
    # "read,write" when the <code>getActions</code> method is invoked.
    # 
    # @return the actions of this Permission.
    def get_actions
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns an empty PermissionCollection for a given Permission object, or null if
    # one is not defined. Subclasses of class Permission should
    # override this if they need to store their permissions in a particular
    # PermissionCollection object in order to provide the correct semantics
    # when the <code>PermissionCollection.implies</code> method is called.
    # If null is returned,
    # then the caller of this method is free to store permissions of this
    # type in any PermissionCollection they choose (one that uses a Hashtable,
    # one that uses a Vector, etc).
    # 
    # @return a new PermissionCollection object for this type of Permission, or
    # null if one is not defined.
    def new_permission_collection
      return nil
    end
    
    typesig { [] }
    # 
    # Returns a string describing this Permission.  The convention is to
    # specify the class name, the permission name, and the actions in
    # the following format: '("ClassName" "name" "actions")'.
    # 
    # @return information about this Permission.
    def to_s
      actions = get_actions
      if (((actions).nil?) || ((actions.length).equal?(0)))
        # OPTIONAL
        return "(" + (get_class.get_name).to_s + " " + @name + ")"
      else
        return "(" + (get_class.get_name).to_s + " " + @name + " " + actions + ")"
      end
    end
    
    private
    alias_method :initialize__permission, :initialize
  end
  
end
