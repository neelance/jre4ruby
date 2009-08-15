require "rjava"

# Copyright 1994-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module IllegalArgumentExceptionImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # Thrown to indicate that a method has been passed an illegal or
  # inappropriate argument.
  # 
  # @author  unascribed
  # @see     java.lang.Thread#setPriority(int)
  # @since   JDK1.0
  class IllegalArgumentException < IllegalArgumentExceptionImports.const_get :RuntimeException
    include_class_members IllegalArgumentExceptionImports
    
    typesig { [] }
    # Constructs an <code>IllegalArgumentException</code> with no
    # detail message.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Constructs an <code>IllegalArgumentException</code> with the
    # specified detail message.
    # 
    # @param   s   the detail message.
    def initialize(s)
      super(s)
    end
    
    typesig { [String, JavaThrowable] }
    # Constructs a new exception with the specified detail message and
    # cause.
    # 
    # <p>Note that the detail message associated with <code>cause</code> is
    # <i>not</i> automatically incorporated in this exception's detail
    # message.
    # 
    # @param  message the detail message (which is saved for later retrieval
    # by the {@link Throwable#getMessage()} method).
    # @param  cause the cause (which is saved for later retrieval by the
    # {@link Throwable#getCause()} method).  (A <tt>null</tt> value
    # is permitted, and indicates that the cause is nonexistent or
    # unknown.)
    # @since 1.5
    def initialize(message, cause)
      super(message, cause)
    end
    
    typesig { [JavaThrowable] }
    # Constructs a new exception with the specified cause and a detail
    # message of <tt>(cause==null ? null : cause.toString())</tt> (which
    # typically contains the class and detail message of <tt>cause</tt>).
    # This constructor is useful for exceptions that are little more than
    # wrappers for other throwables (for example, {@link
    # java.security.PrivilegedActionException}).
    # 
    # @param  cause the cause (which is saved for later retrieval by the
    # {@link Throwable#getCause()} method).  (A <tt>null</tt> value is
    # permitted, and indicates that the cause is nonexistent or
    # unknown.)
    # @since  1.5
    def initialize(cause)
      super(cause)
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -5365630128856068164 }
      const_attr_reader  :SerialVersionUID
    }
    
    private
    alias_method :initialize__illegal_argument_exception, :initialize
  end
  
end
