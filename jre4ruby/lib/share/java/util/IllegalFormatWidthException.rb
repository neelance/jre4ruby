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
  module IllegalFormatWidthExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # Unchecked exception thrown when the format width is a negative value other
  # than <tt>-1</tt> or is otherwise unsupported.
  # 
  # @since 1.5
  class IllegalFormatWidthException < IllegalFormatWidthExceptionImports.const_get :IllegalFormatException
    include_class_members IllegalFormatWidthExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 16660902 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :w
    alias_method :attr_w, :w
    undef_method :w
    alias_method :attr_w=, :w=
    undef_method :w=
    
    typesig { [::Java::Int] }
    # Constructs an instance of this class with the specified width.
    # 
    # @param  w
    # The width
    def initialize(w)
      @w = 0
      super()
      @w = w
    end
    
    typesig { [] }
    # Returns the width
    # 
    # @return  The width
    def get_width
      return @w
    end
    
    typesig { [] }
    def get_message
      return JavaInteger.to_s(@w)
    end
    
    private
    alias_method :initialize__illegal_format_width_exception, :initialize
  end
  
end
