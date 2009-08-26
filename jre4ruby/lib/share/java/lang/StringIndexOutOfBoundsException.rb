require "rjava"

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
  module StringIndexOutOfBoundsExceptionImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # Thrown by <code>String</code> methods to indicate that an index
  # is either negative or greater than the size of the string.  For
  # some methods such as the charAt method, this exception also is
  # thrown when the index is equal to the size of the string.
  # 
  # @author  unascribed
  # @see     java.lang.String#charAt(int)
  # @since   JDK1.0
  class StringIndexOutOfBoundsException < StringIndexOutOfBoundsExceptionImports.const_get :IndexOutOfBoundsException
    include_class_members StringIndexOutOfBoundsExceptionImports
    
    typesig { [] }
    # Constructs a <code>StringIndexOutOfBoundsException</code> with no
    # detail message.
    # 
    # @since   JDK1.0.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Constructs a <code>StringIndexOutOfBoundsException</code> with
    # the specified detail message.
    # 
    # @param   s   the detail message.
    def initialize(s)
      super(s)
    end
    
    typesig { [::Java::Int] }
    # Constructs a new <code>StringIndexOutOfBoundsException</code>
    # class with an argument indicating the illegal index.
    # 
    # @param   index   the illegal index.
    def initialize(index)
      super("String index out of range: " + RJava.cast_to_string(index))
    end
    
    private
    alias_method :initialize__string_index_out_of_bounds_exception, :initialize
  end
  
end