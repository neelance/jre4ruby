require "rjava"

# 
# Copyright 1998-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Action
  module GetPropertyActionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Action
    }
  end
  
  # 
  # A convenience class for retrieving the string value of a system
  # property as a privileged action.
  # 
  # <p>An instance of this class can be used as the argument of
  # <code>AccessController.doPrivileged</code>.
  # 
  # <p>The following code retrieves the value of the system
  # property named <code>"prop"</code> as a privileged action: <p>
  # 
  # <pre>
  # String s = java.security.AccessController.doPrivileged
  # (new GetPropertyAction("prop"));
  # </pre>
  # 
  # @author Roland Schemers
  # @see java.security.PrivilegedAction
  # @see java.security.AccessController
  # @since 1.2
  class GetPropertyAction 
    include_class_members GetPropertyActionImports
    include Java::Security::PrivilegedAction
    
    attr_accessor :the_prop
    alias_method :attr_the_prop, :the_prop
    undef_method :the_prop
    alias_method :attr_the_prop=, :the_prop=
    undef_method :the_prop=
    
    attr_accessor :default_val
    alias_method :attr_default_val, :default_val
    undef_method :default_val
    alias_method :attr_default_val=, :default_val=
    undef_method :default_val=
    
    typesig { [String] }
    # 
    # Constructor that takes the name of the system property whose
    # string value needs to be determined.
    # 
    # @param theProp the name of the system property.
    def initialize(the_prop)
      @the_prop = nil
      @default_val = nil
      @the_prop = the_prop
    end
    
    typesig { [String, String] }
    # 
    # Constructor that takes the name of the system property and the default
    # value of that property.
    # 
    # @param theProp the name of the system property.
    # @param defaulVal the default value.
    def initialize(the_prop, default_val)
      @the_prop = nil
      @default_val = nil
      @the_prop = the_prop
      @default_val = default_val
    end
    
    typesig { [] }
    # 
    # Determines the string value of the system property whose
    # name was specified in the constructor.
    # 
    # @return the string value of the system property,
    # or the default value if there is no property with that key.
    def run
      value = System.get_property(@the_prop)
      return ((value).nil?) ? @default_val : value
    end
    
    private
    alias_method :initialize__get_property_action, :initialize
  end
  
end
