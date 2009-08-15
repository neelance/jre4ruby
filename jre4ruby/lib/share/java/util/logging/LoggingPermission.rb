require "rjava"

# Copyright 2000-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Logging
  module LoggingPermissionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Logging
      include ::Java::Security
    }
  end
  
  # The permission which the SecurityManager will check when code
  # that is running with a SecurityManager calls one of the logging
  # control methods (such as Logger.setLevel).
  # <p>
  # Currently there is only one named LoggingPermission.  This is "control"
  # and it grants the ability to control the logging configuration, for
  # example by adding or removing Handlers, by adding or removing Filters,
  # or by changing logging levels.
  # <p>
  # Programmers do not normally create LoggingPermission objects directly.
  # Instead they are created by the security policy code based on reading
  # the security policy file.
  # 
  # 
  # @since 1.4
  # @see java.security.BasicPermission
  # @see java.security.Permission
  # @see java.security.Permissions
  # @see java.security.PermissionCollection
  # @see java.lang.SecurityManager
  class LoggingPermission < Java::Security::BasicPermission
    include_class_members LoggingPermissionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 63564341580231582 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [String, String] }
    # Creates a new LoggingPermission object.
    # 
    # @param name Permission name.  Must be "control".
    # @param actions Must be either null or the empty string.
    # 
    # @throws NullPointerException if <code>name</code> is <code>null</code>.
    # @throws IllegalArgumentException if <code>name</code> is empty or if
    # arguments are invalid.
    def initialize(name, actions)
      super(name)
      if (!(name == "control"))
        raise IllegalArgumentException.new("name: " + name)
      end
      if (!(actions).nil? && actions.length > 0)
        raise IllegalArgumentException.new("actions: " + actions)
      end
    end
    
    private
    alias_method :initialize__logging_permission, :initialize
  end
  
end
