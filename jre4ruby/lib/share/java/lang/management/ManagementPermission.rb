require "rjava"

# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang::Management
  module ManagementPermissionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Management
    }
  end
  
  # The permission which the SecurityManager will check when code
  # that is running with a SecurityManager calls methods defined
  # in the management interface for the Java platform.
  # <P>
  # The following table
  # provides a summary description of what the permission allows,
  # and discusses the risks of granting code the permission.
  # <P>
  # 
  # <table border=1 cellpadding=5 summary="Table shows permission target name, wh
  # at the permission allows, and associated risks">
  # <tr>
  # <th>Permission Target Name</th>
  # <th>What the Permission Allows</th>
  # <th>Risks of Allowing this Permission</th>
  # </tr>
  # 
  # <tr>
  # <td>control</td>
  # <td>Ability to control the runtime characteristics of the Java virtual
  # machine, for example, setting the -verbose:gc and -verbose:class flag,
  # setting the threshold of a memory pool, and enabling and disabling
  # the thread contention monitoring support.
  # </td>
  # <td>This allows an attacker to control the runtime characteristics
  # of the Java virtual machine and cause the system to misbehave.
  # </td>
  # </tr>
  # <tr>
  # <td>monitor</td>
  # <td>Ability to retrieve runtime information about
  # the Java virtual machine such as thread
  # stack trace, a list of all loaded class names, and input arguments
  # to the Java virtual machine.</td>
  # <td>This allows malicious code to monitor runtime information and
  # uncover vulnerabilities.</td>
  # </tr>
  # 
  # </table>
  # 
  # <p>
  # Programmers do not normally create ManagementPermission objects directly.
  # Instead they are created by the security policy code based on reading
  # the security policy file.
  # 
  # @author  Mandy Chung
  # @since   1.5
  # 
  # @see java.security.BasicPermission
  # @see java.security.Permission
  # @see java.security.Permissions
  # @see java.security.PermissionCollection
  # @see java.lang.SecurityManager
  class ManagementPermission < Java::Security::BasicPermission
    include_class_members ManagementPermissionImports
    
    typesig { [String] }
    # Constructs a ManagementPermission with the specified name.
    # 
    # @param name Permission name. Must be either "monitor" or "control".
    # 
    # @throws NullPointerException if <code>name</code> is <code>null</code>.
    # @throws IllegalArgumentException if <code>name</code> is empty or invalid.
    def initialize(name)
      super(name)
      if (!(name == "control") && !(name == "monitor"))
        raise IllegalArgumentException.new("name: " + name)
      end
    end
    
    typesig { [String, String] }
    # Constructs a new ManagementPermission object.
    # 
    # @param name Permission name. Must be either "monitor" or "control".
    # @param actions Must be either null or the empty string.
    # 
    # @throws NullPointerException if <code>name</code> is <code>null</code>.
    # @throws IllegalArgumentException if <code>name</code> is empty or
    # if arguments are invalid.
    def initialize(name, actions)
      super(name)
      if (!(name == "control") && !(name == "monitor"))
        raise IllegalArgumentException.new("name: " + name)
      end
      if (!(actions).nil? && actions.length > 0)
        raise IllegalArgumentException.new("actions: " + actions)
      end
    end
    
    private
    alias_method :initialize__management_permission, :initialize
  end
  
end
