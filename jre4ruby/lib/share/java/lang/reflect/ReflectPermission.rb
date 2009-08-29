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
module Java::Lang::Reflect
  module ReflectPermissionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Reflect
    }
  end
  
  # The Permission class for reflective operations.  A
  # ReflectPermission is a <em>named permission</em> and has no
  # actions.  The only name currently defined is {@code suppressAccessChecks},
  # which allows suppressing the standard Java language access checks
  # -- for public, default (package) access, protected, and private
  # members -- performed by reflected objects at their point of use.
  # <P>
  # The following table
  # provides a summary description of what the permission allows,
  # and discusses the risks of granting code the permission.
  # <P>
  # 
  # <table border=1 cellpadding=5 summary="Table shows permission target name, what the permission allows, and associated risks">
  # <tr>
  # <th>Permission Target Name</th>
  # <th>What the Permission Allows</th>
  # <th>Risks of Allowing this Permission</th>
  # </tr>
  # 
  # <tr>
  # <td>suppressAccessChecks</td>
  # <td>ability to access
  # fields and invoke methods in a class. Note that this includes
  # not only public, but protected and private fields and methods as well.</td>
  # <td>This is dangerous in that information (possibly confidential) and
  # methods normally unavailable would be accessible to malicious code.</td>
  # </tr>
  # 
  # </table>
  # 
  # @see java.security.Permission
  # @see java.security.BasicPermission
  # @see AccessibleObject
  # @see Field#get
  # @see Field#set
  # @see Method#invoke
  # @see Constructor#newInstance
  # 
  # @since 1.2
  class ReflectPermission < Java::Security::BasicPermission
    include_class_members ReflectPermissionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 7412737110241507485 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [String] }
    # Constructs a ReflectPermission with the specified name.
    # 
    # @param name the name of the ReflectPermission
    # 
    # @throws NullPointerException if {@code name} is {@code null}.
    # @throws IllegalArgumentException if {@code name} is empty.
    def initialize(name)
      super(name)
    end
    
    typesig { [String, String] }
    # Constructs a ReflectPermission with the specified name and actions.
    # The actions should be null; they are ignored.
    # 
    # @param name the name of the ReflectPermission
    # 
    # @param actions should be null
    # 
    # @throws NullPointerException if {@code name} is {@code null}.
    # @throws IllegalArgumentException if {@code name} is empty.
    def initialize(name, actions)
      super(name, actions)
    end
    
    private
    alias_method :initialize__reflect_permission, :initialize
  end
  
end
