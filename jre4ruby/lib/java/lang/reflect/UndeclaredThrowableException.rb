require "rjava"

# 
# Copyright 1999-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang::Reflect
  module UndeclaredThrowableExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Reflect
    }
  end
  
  # 
  # Thrown by a method invocation on a proxy instance if its invocation
  # handler's {@link InvocationHandler#invoke invoke} method throws a
  # checked exception (a {@code Throwable} that is not assignable
  # to {@code RuntimeException} or {@code Error}) that
  # is not assignable to any of the exception types declared in the
  # {@code throws} clause of the method that was invoked on the
  # proxy instance and dispatched to the invocation handler.
  # 
  # <p>An {@code UndeclaredThrowableException} instance contains
  # the undeclared checked exception that was thrown by the invocation
  # handler, and it can be retrieved with the
  # {@code getUndeclaredThrowable()} method.
  # {@code UndeclaredThrowableException} extends
  # {@code RuntimeException}, so it is an unchecked exception
  # that wraps a checked exception.
  # 
  # <p>As of release 1.4, this exception has been retrofitted to
  # conform to the general purpose exception-chaining mechanism.  The
  # "undeclared checked exception that was thrown by the invocation
  # handler" that may be provided at construction time and accessed via
  # the {@link #getUndeclaredThrowable()} method is now known as the
  # <i>cause</i>, and may be accessed via the {@link
  # Throwable#getCause()} method, as well as the aforementioned "legacy
  # method."
  # 
  # @author      Peter Jones
  # @see         InvocationHandler
  # @since       1.3
  class UndeclaredThrowableException < UndeclaredThrowableExceptionImports.const_get :RuntimeException
    include_class_members UndeclaredThrowableExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 330127114055056639 }
      const_attr_reader  :SerialVersionUID
    }
    
    # 
    # the undeclared checked exception that was thrown
    # @serial
    attr_accessor :undeclared_throwable
    alias_method :attr_undeclared_throwable, :undeclared_throwable
    undef_method :undeclared_throwable
    alias_method :attr_undeclared_throwable=, :undeclared_throwable=
    undef_method :undeclared_throwable=
    
    typesig { [Exception] }
    # 
    # Constructs an {@code UndeclaredThrowableException} with the
    # specified {@code Throwable}.
    # 
    # @param   undeclaredThrowable the undeclared checked exception
    # that was thrown
    def initialize(undeclared_throwable)
      @undeclared_throwable = nil
      super(nil) # Disallow initCause
      @undeclared_throwable = undeclared_throwable
    end
    
    typesig { [Exception, String] }
    # 
    # Constructs an {@code UndeclaredThrowableException} with the
    # specified {@code Throwable} and a detail message.
    # 
    # @param   undeclaredThrowable the undeclared checked exception
    # that was thrown
    # @param   s the detail message
    def initialize(undeclared_throwable, s)
      @undeclared_throwable = nil
      super(s, nil) # Disallow initCause
      @undeclared_throwable = undeclared_throwable
    end
    
    typesig { [] }
    # 
    # Returns the {@code Throwable} instance wrapped in this
    # {@code UndeclaredThrowableException}, which may be {@code null}.
    # 
    # <p>This method predates the general-purpose exception chaining facility.
    # The {@link Throwable#getCause()} method is now the preferred means of
    # obtaining this information.
    # 
    # @return the undeclared checked exception that was thrown
    def get_undeclared_throwable
      return @undeclared_throwable
    end
    
    typesig { [] }
    # 
    # Returns the cause of this exception (the {@code Throwable}
    # instance wrapped in this {@code UndeclaredThrowableException},
    # which may be {@code null}).
    # 
    # @return  the cause of this exception.
    # @since   1.4
    def get_cause
      return @undeclared_throwable
    end
    
    private
    alias_method :initialize__undeclared_throwable_exception, :initialize
  end
  
end
