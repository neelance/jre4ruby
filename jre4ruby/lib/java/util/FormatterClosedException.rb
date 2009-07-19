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
  module FormatterClosedExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # Unchecked exception thrown when the formatter has been closed.
  # 
  # <p> Unless otherwise specified, passing a <tt>null</tt> argument to any
  # method or constructor in this class will cause a {@link
  # NullPointerException} to be thrown.
  # 
  # @since 1.5
  class FormatterClosedException < FormatterClosedExceptionImports.const_get :IllegalStateException
    include_class_members FormatterClosedExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 18111216 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Constructs an instance of this class.
    def initialize
      super()
    end
    
    private
    alias_method :initialize__formatter_closed_exception, :initialize
  end
  
end
