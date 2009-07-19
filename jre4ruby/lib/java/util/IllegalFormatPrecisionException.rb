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
module Java::Util
  module IllegalFormatPrecisionExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # Unchecked exception thrown when the precision is a negative value other than
  # <tt>-1</tt>, the conversion does not support a precision, or the value is
  # otherwise unsupported.
  # 
  # @since 1.5
  class IllegalFormatPrecisionException < IllegalFormatPrecisionExceptionImports.const_get :IllegalFormatException
    include_class_members IllegalFormatPrecisionExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 18711008 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :p
    alias_method :attr_p, :p
    undef_method :p
    alias_method :attr_p=, :p=
    undef_method :p=
    
    typesig { [::Java::Int] }
    # Constructs an instance of this class with the specified precision.
    # 
    # @param  p
    # The precision
    def initialize(p)
      @p = 0
      super()
      @p = p
    end
    
    typesig { [] }
    # Returns the precision
    # 
    # @return  The precision
    def get_precision
      return @p
    end
    
    typesig { [] }
    def get_message
      return JavaInteger.to_s(@p)
    end
    
    private
    alias_method :initialize__illegal_format_precision_exception, :initialize
  end
  
end
