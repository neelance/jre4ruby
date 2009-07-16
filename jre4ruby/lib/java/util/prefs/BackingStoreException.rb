require "rjava"

# 
# Copyright 2000-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Prefs
  module BackingStoreExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Prefs
      include_const ::Java::Io, :NotSerializableException
    }
  end
  
  # 
  # Thrown to indicate that a preferences operation could not complete because
  # of a failure in the backing store, or a failure to contact the backing
  # store.
  # 
  # @author  Josh Bloch
  # @since   1.4
  class BackingStoreException < BackingStoreExceptionImports.const_get :Exception
    include_class_members BackingStoreExceptionImports
    
    typesig { [String] }
    # 
    # Constructs a BackingStoreException with the specified detail message.
    # 
    # @param s the detail message.
    def initialize(s)
      super(s)
    end
    
    typesig { [Exception] }
    # 
    # Constructs a BackingStoreException with the specified cause.
    # 
    # @param cause the cause
    def initialize(cause)
      super(cause)
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 859796500401108469 }
      const_attr_reader  :SerialVersionUID
    }
    
    private
    alias_method :initialize__backing_store_exception, :initialize
  end
  
end
