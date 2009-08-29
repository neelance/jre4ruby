require "rjava"

# Copyright 1997-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module GuardedObjectImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
    }
  end
  
  # A GuardedObject is an object that is used to protect access to
  # another object.
  # 
  # <p>A GuardedObject encapsulates a target object and a Guard object,
  # such that access to the target object is possible
  # only if the Guard object allows it.
  # Once an object is encapsulated by a GuardedObject,
  # access to that object is controlled by the <code>getObject</code>
  # method, which invokes the
  # <code>checkGuard</code> method on the Guard object that is
  # guarding access. If access is not allowed,
  # an exception is thrown.
  # 
  # @see Guard
  # @see Permission
  # 
  # @author Roland Schemers
  # @author Li Gong
  class GuardedObject 
    include_class_members GuardedObjectImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -5240450096227834308 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :object
    alias_method :attr_object, :object
    undef_method :object
    alias_method :attr_object=, :object=
    undef_method :object=
    
    # the object we are guarding
    attr_accessor :guard
    alias_method :attr_guard, :guard
    undef_method :guard
    alias_method :attr_guard=, :guard=
    undef_method :guard=
    
    typesig { [Object, Guard] }
    # the guard
    # 
    # Constructs a GuardedObject using the specified object and guard.
    # If the Guard object is null, then no restrictions will
    # be placed on who can access the object.
    # 
    # @param object the object to be guarded.
    # 
    # @param guard the Guard object that guards access to the object.
    def initialize(object, guard)
      @object = nil
      @guard = nil
      @guard = guard
      @object = object
    end
    
    typesig { [] }
    # Retrieves the guarded object, or throws an exception if access
    # to the guarded object is denied by the guard.
    # 
    # @return the guarded object.
    # 
    # @exception SecurityException if access to the guarded object is
    # denied.
    def get_object
      if (!(@guard).nil?)
        @guard.check_guard(@object)
      end
      return @object
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Writes this object out to a stream (i.e., serializes it).
    # We check the guard if there is one.
    def write_object(oos)
      if (!(@guard).nil?)
        @guard.check_guard(@object)
      end
      oos.default_write_object
    end
    
    private
    alias_method :initialize__guarded_object, :initialize
  end
  
end
