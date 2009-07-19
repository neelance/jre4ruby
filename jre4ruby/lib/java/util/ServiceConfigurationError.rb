require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ServiceConfigurationErrorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # Error thrown when something goes wrong while loading a service provider.
  # 
  # <p> This error will be thrown in the following situations:
  # 
  # <ul>
  # 
  # <li> The format of a provider-configuration file violates the <a
  # href="ServiceLoader.html#format">specification</a>; </li>
  # 
  # <li> An {@link java.io.IOException IOException} occurs while reading a
  # provider-configuration file; </li>
  # 
  # <li> A concrete provider class named in a provider-configuration file
  # cannot be found; </li>
  # 
  # <li> A concrete provider class is not a subclass of the service class;
  # </li>
  # 
  # <li> A concrete provider class cannot be instantiated; or
  # 
  # <li> Some other kind of error occurs. </li>
  # 
  # </ul>
  # 
  # 
  # @author Mark Reinhold
  # @since 1.6
  class ServiceConfigurationError < ServiceConfigurationErrorImports.const_get :JavaError
    include_class_members ServiceConfigurationErrorImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 74132770414881 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [String] }
    # Constructs a new instance with the specified message.
    # 
    # @param  msg  The message, or <tt>null</tt> if there is no message
    def initialize(msg)
      super(msg)
    end
    
    typesig { [String, Exception] }
    # Constructs a new instance with the specified message and cause.
    # 
    # @param  msg  The message, or <tt>null</tt> if there is no message
    # 
    # @param  cause  The cause, or <tt>null</tt> if the cause is nonexistent
    # or unknown
    def initialize(msg, cause)
      super(msg, cause)
    end
    
    private
    alias_method :initialize__service_configuration_error, :initialize
  end
  
end
