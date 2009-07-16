require "rjava"

# 
# Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Io
  module NotActiveExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # 
  # Thrown when serialization or deserialization is not active.
  # 
  # @author  unascribed
  # @since   JDK1.1
  class NotActiveException < NotActiveExceptionImports.const_get :ObjectStreamException
    include_class_members NotActiveExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -3893467273049808895 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [String] }
    # 
    # Constructor to create a new NotActiveException with the reason given.
    # 
    # @param reason  a String describing the reason for the exception.
    def initialize(reason)
      super(reason)
    end
    
    typesig { [] }
    # 
    # Constructor to create a new NotActiveException without a reason.
    def initialize
      super()
    end
    
    private
    alias_method :initialize__not_active_exception, :initialize
  end
  
end
