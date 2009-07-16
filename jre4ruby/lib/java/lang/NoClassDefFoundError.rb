require "rjava"

# 
# Copyright 1994-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
  module NoClassDefFoundErrorImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # 
  # Thrown if the Java Virtual Machine or a <code>ClassLoader</code> instance
  # tries to load in the definition of a class (as part of a normal method call
  # or as part of creating a new instance using the <code>new</code> expression)
  # and no definition of the class could be found.
  # <p>
  # The searched-for class definition existed when the currently
  # executing class was compiled, but the definition can no longer be
  # found.
  # 
  # @author  unascribed
  # @since   JDK1.0
  class NoClassDefFoundError < NoClassDefFoundErrorImports.const_get :LinkageError
    include_class_members NoClassDefFoundErrorImports
    
    typesig { [] }
    # 
    # Constructs a <code>NoClassDefFoundError</code> with no detail message.
    def initialize
      super()
    end
    
    typesig { [String] }
    # 
    # Constructs a <code>NoClassDefFoundError</code> with the specified
    # detail message.
    # 
    # @param   s   the detail message.
    def initialize(s)
      super(s)
    end
    
    private
    alias_method :initialize__no_class_def_found_error, :initialize
  end
  
end
