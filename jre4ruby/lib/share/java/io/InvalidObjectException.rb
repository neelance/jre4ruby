require "rjava"

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
  module InvalidObjectExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # Indicates that one or more deserialized objects failed validation
  # tests.  The argument should provide the reason for the failure.
  # 
  # @see ObjectInputValidation
  # @since JDK1.1
  # 
  # @author  unascribed
  # @since   JDK1.1
  class InvalidObjectException < InvalidObjectExceptionImports.const_get :ObjectStreamException
    include_class_members InvalidObjectExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 3233174318281839583 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [String] }
    # Constructs an <code>InvalidObjectException</code>.
    # @param reason Detailed message explaining the reason for the failure.
    # 
    # @see ObjectInputValidation
    def initialize(reason)
      super(reason)
    end
    
    private
    alias_method :initialize__invalid_object_exception, :initialize
  end
  
end
