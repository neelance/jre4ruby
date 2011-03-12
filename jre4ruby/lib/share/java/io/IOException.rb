require "rjava"

# Copyright 1994-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module IOExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # Signals that an I/O exception of some sort has occurred. This
  # class is the general class of exceptions produced by failed or
  # interrupted I/O operations.
  # 
  # @author  unascribed
  # @see     java.io.InputStream
  # @see     java.io.OutputStream
  # @since   JDK1.0
  class IOException < IOExceptionImports.const_get :JavaException
    include_class_members IOExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 7818375828146090155 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Constructs an {@code IOException} with {@code null}
    # as its error detail message.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Constructs an {@code IOException} with the specified detail message.
    # 
    # @param message
    #        The detail message (which is saved for later retrieval
    #        by the {@link #getMessage()} method)
    def initialize(message)
      super(message)
    end
    
    typesig { [String, JavaThrowable] }
    # Constructs an {@code IOException} with the specified detail message
    # and cause.
    # 
    # <p> Note that the detail message associated with {@code cause} is
    # <i>not</i> automatically incorporated into this exception's detail
    # message.
    # 
    # @param message
    #        The detail message (which is saved for later retrieval
    #        by the {@link #getMessage()} method)
    # 
    # @param cause
    #        The cause (which is saved for later retrieval by the
    #        {@link #getCause()} method).  (A null value is permitted,
    #        and indicates that the cause is nonexistent or unknown.)
    # 
    # @since 1.6
    def initialize(message, cause)
      super(message, cause)
    end
    
    typesig { [JavaThrowable] }
    # Constructs an {@code IOException} with the specified cause and a
    # detail message of {@code (cause==null ? null : cause.toString())}
    # (which typically contains the class and detail message of {@code cause}).
    # This constructor is useful for IO exceptions that are little more
    # than wrappers for other throwables.
    # 
    # @param cause
    #        The cause (which is saved for later retrieval by the
    #        {@link #getCause()} method).  (A null value is permitted,
    #        and indicates that the cause is nonexistent or unknown.)
    # 
    # @since 1.6
    def initialize(cause)
      super(cause)
    end
    
    private
    alias_method :initialize__ioexception, :initialize
  end
  
end
