require "rjava"

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
# This file is available under and governed by the GNU General Public
# License version 2 only, as published by the Free Software Foundation.
# However, the following notice accompanied the original version of this
# file:
# 
# Written by Doug Lea with assistance from members of JCP JSR-166
# Expert Group and released to the public domain, as explained at
# http://creativecommons.org/licenses/publicdomain
module Java::Util::Concurrent
  module RejectedExecutionExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
    }
  end
  
  # Exception thrown by an {@link Executor} when a task cannot be
  # accepted for execution.
  # 
  # @since 1.5
  # @author Doug Lea
  class RejectedExecutionException < RejectedExecutionExceptionImports.const_get :RuntimeException
    include_class_members RejectedExecutionExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -375805702767069545 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Constructs a <tt>RejectedExecutionException</tt> with no detail message.
    # The cause is not initialized, and may subsequently be
    # initialized by a call to {@link #initCause(Throwable) initCause}.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Constructs a <tt>RejectedExecutionException</tt> with the
    # specified detail message. The cause is not initialized, and may
    # subsequently be initialized by a call to {@link
    # #initCause(Throwable) initCause}.
    # 
    # @param message the detail message
    def initialize(message)
      super(message)
    end
    
    typesig { [String, JavaThrowable] }
    # Constructs a <tt>RejectedExecutionException</tt> with the
    # specified detail message and cause.
    # 
    # @param  message the detail message
    # @param  cause the cause (which is saved for later retrieval by the
    #         {@link #getCause()} method)
    def initialize(message, cause)
      super(message, cause)
    end
    
    typesig { [JavaThrowable] }
    # Constructs a <tt>RejectedExecutionException</tt> with the
    # specified cause.  The detail message is set to: <pre> (cause ==
    # null ? null : cause.toString())</pre> (which typically contains
    # the class and detail message of <tt>cause</tt>).
    # 
    # @param  cause the cause (which is saved for later retrieval by the
    #         {@link #getCause()} method)
    def initialize(cause)
      super(cause)
    end
    
    private
    alias_method :initialize__rejected_execution_exception, :initialize
  end
  
end
