require "rjava"

# Copyright 1994-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # The class <code>Exception</code> and its subclasses are a form of
  # <code>Throwable</code> that indicates conditions that a reasonable
  # application might want to catch.
  # 
  # @author  Frank Yellin
  # @see     java.lang.Error
  # @since   JDK1.0
  class JavaException < ExceptionImports.const_get :JavaThrowable
    include_class_members ExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -3387516993124229948 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Constructs a new exception with <code>null</code> as its detail message.
    # The cause is not initialized, and may subsequently be initialized by a
    # call to {@link #initCause}.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Constructs a new exception with the specified detail message.  The
    # cause is not initialized, and may subsequently be initialized by
    # a call to {@link #initCause}.
    # 
    # @param   message   the detail message. The detail message is saved for
    # later retrieval by the {@link #getMessage()} method.
    def initialize(message)
      super(message)
    end
    
    typesig { [String, JavaThrowable] }
    # Constructs a new exception with the specified detail message and
    # cause.  <p>Note that the detail message associated with
    # <code>cause</code> is <i>not</i> automatically incorporated in
    # this exception's detail message.
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
    # Constructs a new exception with the specified cause and a detail
    # message of <tt>(cause==null ? null : cause.toString())</tt> (which
    # typically contains the class and detail message of <tt>cause</tt>).
    # This constructor is useful for exceptions that are little more than
    # wrappers for other throwables (for example, {@link
    # java.security.PrivilegedActionException}).
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
    alias_method :initialize__exception, :initialize
  end
  
end
