require "rjava"

# Copyright 1995-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
  module RuntimeExceptionImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # <code>RuntimeException</code> is the superclass of those
  # exceptions that can be thrown during the normal operation of the
  # Java Virtual Machine.
  # <p>
  # A method is not required to declare in its <code>throws</code>
  # clause any subclasses of <code>RuntimeException</code> that might
  # be thrown during the execution of the method but not caught.
  # 
  # 
  # @author  Frank Yellin
  # @since   JDK1.0
  class RuntimeException < RuntimeExceptionImports.const_get :JavaException
    include_class_members RuntimeExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -7034897190745766939 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Constructs a new runtime exception with <code>null</code> as its
    # detail message.  The cause is not initialized, and may subsequently be
    # initialized by a call to {@link #initCause}.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Constructs a new runtime exception with the specified detail message.
    # The cause is not initialized, and may subsequently be initialized by a
    # call to {@link #initCause}.
    # 
    # @param   message   the detail message. The detail message is saved for
    # later retrieval by the {@link #getMessage()} method.
    def initialize(message)
      super(message)
    end
    
    typesig { [String, JavaThrowable] }
    # Constructs a new runtime exception with the specified detail message and
    # cause.  <p>Note that the detail message associated with
    # <code>cause</code> is <i>not</i> automatically incorporated in
    # this runtime exception's detail message.
    # 
    # @param  message the detail message (which is saved for later retrieval
    # by the {@link #getMessage()} method).
    # @param  cause the cause (which is saved for later retrieval by the
    # {@link #getCause()} method).  (A <tt>null</tt> value is
    # permitted, and indicates that the cause is nonexistent or
    # unknown.)
    # @since  1.4
    def initialize(message, cause)
      super(message, cause)
    end
    
    typesig { [JavaThrowable] }
    # Constructs a new runtime exception with the specified cause and a
    # detail message of <tt>(cause==null ? null : cause.toString())</tt>
    # (which typically contains the class and detail message of
    # <tt>cause</tt>).  This constructor is useful for runtime exceptions
    # that are little more than wrappers for other throwables.
    # 
    # @param  cause the cause (which is saved for later retrieval by the
    # {@link #getCause()} method).  (A <tt>null</tt> value is
    # permitted, and indicates that the cause is nonexistent or
    # unknown.)
    # @since  1.4
    def initialize(cause)
      super(cause)
    end
    
    private
    alias_method :initialize__runtime_exception, :initialize
  end
  
end
