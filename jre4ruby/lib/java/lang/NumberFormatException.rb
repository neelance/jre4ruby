require "rjava"

# 
# Copyright 1994-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
  module NumberFormatExceptionImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # 
  # Thrown to indicate that the application has attempted to convert
  # a string to one of the numeric types, but that the string does not
  # have the appropriate format.
  # 
  # @author  unascribed
  # @see     java.lang.Integer#toString()
  # @since   JDK1.0
  class NumberFormatException < NumberFormatExceptionImports.const_get :IllegalArgumentException
    include_class_members NumberFormatExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -2848938806368998894 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # 
    # Constructs a <code>NumberFormatException</code> with no detail message.
    def initialize
      super()
    end
    
    typesig { [String] }
    # 
    # Constructs a <code>NumberFormatException</code> with the
    # specified detail message.
    # 
    # @param   s   the detail message.
    def initialize(s)
      super(s)
    end
    
    class_module.module_eval {
      typesig { [String] }
      # 
      # Factory method for making a <code>NumberFormatException</code>
      # given the specified input which caused the error.
      # 
      # @param   s   the input causing the error
      def for_input_string(s)
        return NumberFormatException.new("For input string: \"" + s + "\"")
      end
    }
    
    private
    alias_method :initialize__number_format_exception, :initialize
  end
  
end
