require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module IOErrorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # Thrown when a serious I/O error has occurred.
  # 
  # @author  Xueming Shen
  # @since   1.6
  class IOError < IOErrorImports.const_get :JavaError
    include_class_members IOErrorImports
    
    typesig { [JavaThrowable] }
    # Constructs a new instance of IOError with the specified cause. The
    # IOError is created with the detail message of
    # <tt>(cause==null ? null : cause.toString())</tt> (which typically
    # contains the class and detail message of cause).
    # 
    # @param  cause
    #         The cause of this error, or <tt>null</tt> if the cause
    #         is not known
    def initialize(cause)
      super(cause)
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 67100927991680413 }
      const_attr_reader  :SerialVersionUID
    }
    
    private
    alias_method :initialize__ioerror, :initialize
  end
  
end
