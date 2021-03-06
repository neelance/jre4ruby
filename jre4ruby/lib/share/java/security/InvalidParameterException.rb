require "rjava"

# Copyright 1996-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security
  module InvalidParameterExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
    }
  end
  
  # This exception, designed for use by the JCA/JCE engine classes,
  # is thrown when an invalid parameter is passed
  # to a method.
  # 
  # @author Benjamin Renaud
  class InvalidParameterException < InvalidParameterExceptionImports.const_get :IllegalArgumentException
    include_class_members InvalidParameterExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -857968536935667808 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Constructs an InvalidParameterException with no detail message.
    # A detail message is a String that describes this particular
    # exception.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Constructs an InvalidParameterException with the specified
    # detail message.  A detail message is a String that describes
    # this particular exception.
    # 
    # @param msg the detail message.
    def initialize(msg)
      super(msg)
    end
    
    private
    alias_method :initialize__invalid_parameter_exception, :initialize
  end
  
end
