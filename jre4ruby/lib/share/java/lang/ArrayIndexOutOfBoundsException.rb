require "rjava"

# Copyright 1994-1997 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ArrayIndexOutOfBoundsExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # Thrown to indicate that an array has been accessed with an
  # illegal index. The index is either negative or greater than or
  # equal to the size of the array.
  # 
  # @author  unascribed
  # @since   JDK1.0
  class ArrayIndexOutOfBoundsException < ArrayIndexOutOfBoundsExceptionImports.const_get :IndexOutOfBoundsException
    include_class_members ArrayIndexOutOfBoundsExceptionImports
    
    typesig { [] }
    # Constructs an <code>ArrayIndexOutOfBoundsException</code> with no
    # detail message.
    def initialize
      super()
    end
    
    typesig { [::Java::Int] }
    # Constructs a new <code>ArrayIndexOutOfBoundsException</code>
    # class with an argument indicating the illegal index.
    # 
    # @param   index   the illegal index.
    def initialize(index)
      super("Array index out of range: " + RJava.cast_to_string(index))
    end
    
    typesig { [String] }
    # Constructs an <code>ArrayIndexOutOfBoundsException</code> class
    # with the specified detail message.
    # 
    # @param   s   the detail message.
    def initialize(s)
      super(s)
    end
    
    private
    alias_method :initialize__array_index_out_of_bounds_exception, :initialize
  end
  
end
