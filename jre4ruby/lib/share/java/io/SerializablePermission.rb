require "rjava"

# Copyright 1997-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Io
  module SerializablePermissionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include ::Java::Security
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :StringTokenizer
    }
  end
  
  # This class is for Serializable permissions. A SerializablePermission
  # contains a name (also referred to as a "target name") but
  # no actions list; you either have the named permission
  # or you don't.
  # 
  # <P>
  # The target name is the name of the Serializable permission (see below).
  # 
  # <P>
  # The following table lists all the possible SerializablePermission target names,
  # and for each provides a description of what the permission allows
  # and a discussion of the risks of granting code the permission.
  # <P>
  # 
  # <table border=1 cellpadding=5 summary="Permission target name, what the permission allows, and associated risks">
  # <tr>
  # <th>Permission Target Name</th>
  # <th>What the Permission Allows</th>
  # <th>Risks of Allowing this Permission</th>
  # </tr>
  # 
  # <tr>
  #   <td>enableSubclassImplementation</td>
  #   <td>Subclass implementation of ObjectOutputStream or ObjectInputStream
  # to override the default serialization or deserialization, respectively,
  # of objects</td>
  #   <td>Code can use this to serialize or
  # deserialize classes in a purposefully malfeasant manner. For example,
  # during serialization, malicious code can use this to
  # purposefully store confidential private field data in a way easily accessible
  # to attackers. Or, during deserialization it could, for example, deserialize
  # a class with all its private fields zeroed out.</td>
  # </tr>
  # 
  # <tr>
  #   <td>enableSubstitution</td>
  #   <td>Substitution of one object for another during
  # serialization or deserialization</td>
  #   <td>This is dangerous because malicious code
  # can replace the actual object with one which has incorrect or
  # malignant data.</td>
  # </tr>
  # 
  # </table>
  # 
  # @see java.security.BasicPermission
  # @see java.security.Permission
  # @see java.security.Permissions
  # @see java.security.PermissionCollection
  # @see java.lang.SecurityManager
  # 
  # 
  # @author Joe Fialli
  # @since 1.2
  # code was borrowed originally from java.lang.RuntimePermission.
  class SerializablePermission < SerializablePermissionImports.const_get :BasicPermission
    include_class_members SerializablePermissionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 8537212141160296410 }
      const_attr_reader  :SerialVersionUID
    }
    
    # @serial
    attr_accessor :actions
    alias_method :attr_actions, :actions
    undef_method :actions
    alias_method :attr_actions=, :actions=
    undef_method :actions=
    
    typesig { [String] }
    # Creates a new SerializablePermission with the specified name.
    # The name is the symbolic name of the SerializablePermission, such as
    # "enableSubstitution", etc.
    # 
    # @param name the name of the SerializablePermission.
    # 
    # @throws NullPointerException if <code>name</code> is <code>null</code>.
    # @throws IllegalArgumentException if <code>name</code> is empty.
    def initialize(name)
      @actions = nil
      super(name)
    end
    
    typesig { [String, String] }
    # Creates a new SerializablePermission object with the specified name.
    # The name is the symbolic name of the SerializablePermission, and the
    # actions String is currently unused and should be null.
    # 
    # @param name the name of the SerializablePermission.
    # @param actions currently unused and must be set to null
    # 
    # @throws NullPointerException if <code>name</code> is <code>null</code>.
    # @throws IllegalArgumentException if <code>name</code> is empty.
    def initialize(name, actions)
      @actions = nil
      super(name, actions)
    end
    
    private
    alias_method :initialize__serializable_permission, :initialize
  end
  
end
