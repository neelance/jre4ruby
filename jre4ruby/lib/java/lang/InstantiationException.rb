require "rjava"

# 
# Copyright 1995-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang
  module InstantiationExceptionImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # 
  # Thrown when an application tries to create an instance of a class
  # using the {@code newInstance} method in class
  # {@code Class}, but the specified class object cannot be
  # instantiated.  The instantiation can fail for a variety of
  # reasons including but not limited to:
  # 
  # <ul>
  # <li> the class object represents an abstract class, an interface,
  # an array class, a primitive type, or {@code void}
  # <li> the class has no nullary constructor
  # </ul>
  # 
  # @author  unascribed
  # @see     java.lang.Class#newInstance()
  # @since   JDK1.0
  class InstantiationException < InstantiationExceptionImports.const_get :Exception
    include_class_members InstantiationExceptionImports
    
    typesig { [] }
    # 
    # Constructs an {@code InstantiationException} with no detail message.
    def initialize
      super()
    end
    
    typesig { [String] }
    # 
    # Constructs an {@code InstantiationException} with the
    # specified detail message.
    # 
    # @param   s   the detail message.
    def initialize(s)
      super(s)
    end
    
    private
    alias_method :initialize__instantiation_exception, :initialize
  end
  
end
