require "rjava"

# Copyright 1999-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module ServiceConfigurationErrorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
    }
  end
  
  # Error thrown when something goes wrong while looking up service providers.
  # In particular, this error will be thrown in the following situations:
  # 
  # <ul>
  # <li> A concrete provider class cannot be found,
  # <li> A concrete provider class cannot be instantiated,
  # <li> The format of a provider-configuration file is illegal, or
  # <li> An IOException occurs while reading a provider-configuration file.
  # </ul>
  # 
  # @author Mark Reinhold
  # @since 1.3
  class ServiceConfigurationError < ServiceConfigurationErrorImports.const_get :JavaError
    include_class_members ServiceConfigurationErrorImports
    
    typesig { [String] }
    # Constructs a new instance with the specified detail string.
    def initialize(msg)
      super(msg)
    end
    
    typesig { [Exception] }
    # Constructs a new instance that wraps the specified throwable.
    def initialize(x)
      super(x)
    end
    
    private
    alias_method :initialize__service_configuration_error, :initialize
  end
  
end
