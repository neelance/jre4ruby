require "rjava"

# Copyright 1996-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module InvocationTargetExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Reflect
    }
  end
  
  # InvocationTargetException is a checked exception that wraps
  # an exception thrown by an invoked method or constructor.
  # 
  # <p>As of release 1.4, this exception has been retrofitted to conform to
  # the general purpose exception-chaining mechanism.  The "target exception"
  # that is provided at construction time and accessed via the
  # {@link #getTargetException()} method is now known as the <i>cause</i>,
  # and may be accessed via the {@link Throwable#getCause()} method,
  # as well as the aforementioned "legacy method."
  # 
  # @see Method
  # @see Constructor
  class InvocationTargetException < InvocationTargetExceptionImports.const_get :JavaException
    include_class_members InvocationTargetExceptionImports
    
    class_module.module_eval {
      # Use serialVersionUID from JDK 1.1.X for interoperability
      const_set_lazy(:SerialVersionUID) { 4085088731926701167 }
      const_attr_reader  :SerialVersionUID
    }
    
    # This field holds the target if the
    # InvocationTargetException(Throwable target) constructor was
    # used to instantiate the object
    # 
    # @serial
    attr_accessor :target
    alias_method :attr_target, :target
    undef_method :target
    alias_method :attr_target=, :target=
    undef_method :target=
    
    typesig { [] }
    # Constructs an {@code InvocationTargetException} with
    # {@code null} as the target exception.
    def initialize
      @target = nil
      super(nil) # Disallow initCause
    end
    
    typesig { [JavaThrowable] }
    # Constructs a InvocationTargetException with a target exception.
    # 
    # @param target the target exception
    def initialize(target)
      @target = nil
      super(nil) # Disallow initCause
      @target = target
    end
    
    typesig { [JavaThrowable, String] }
    # Constructs a InvocationTargetException with a target exception
    # and a detail message.
    # 
    # @param target the target exception
    # @param s      the detail message
    def initialize(target, s)
      @target = nil
      super(s, nil) # Disallow initCause
      @target = target
    end
    
    typesig { [] }
    # Get the thrown target exception.
    # 
    # <p>This method predates the general-purpose exception chaining facility.
    # The {@link Throwable#getCause()} method is now the preferred means of
    # obtaining this information.
    # 
    # @return the thrown target exception (cause of this exception).
    def get_target_exception
      return @target
    end
    
    typesig { [] }
    # Returns the cause of this exception (the thrown target exception,
    # which may be {@code null}).
    # 
    # @return  the cause of this exception.
    # @since   1.4
    def get_cause
      return @target
    end
    
    private
    alias_method :initialize__invocation_target_exception, :initialize
  end
  
end
