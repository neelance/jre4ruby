require "rjava"

# Copyright 1996-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ExceptionInInitializerErrorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # Signals that an unexpected exception has occurred in a static initializer.
  # An <code>ExceptionInInitializerError</code> is thrown to indicate that an
  # exception occurred during evaluation of a static initializer or the
  # initializer for a static variable.
  # 
  # <p>As of release 1.4, this exception has been retrofitted to conform to
  # the general purpose exception-chaining mechanism.  The "saved throwable
  # object" that may be provided at construction time and accessed via
  # the {@link #getException()} method is now known as the <i>cause</i>,
  # and may be accessed via the {@link Throwable#getCause()} method, as well
  # as the aforementioned "legacy method."
  # 
  # @author  Frank Yellin
  # @since   JDK1.1
  class ExceptionInInitializerError < ExceptionInInitializerErrorImports.const_get :LinkageError
    include_class_members ExceptionInInitializerErrorImports
    
    class_module.module_eval {
      # Use serialVersionUID from JDK 1.1.X for interoperability
      const_set_lazy(:SerialVersionUID) { 1521711792217232256 }
      const_attr_reader  :SerialVersionUID
    }
    
    # This field holds the exception if the
    # ExceptionInInitializerError(Throwable thrown) constructor was
    # used to instantiate the object
    # 
    # @serial
    attr_accessor :exception
    alias_method :attr_exception, :exception
    undef_method :exception
    alias_method :attr_exception=, :exception=
    undef_method :exception=
    
    typesig { [] }
    # Constructs an <code>ExceptionInInitializerError</code> with
    # <code>null</code> as its detail message string and with no saved
    # throwable object.
    # A detail message is a String that describes this particular exception.
    def initialize
      @exception = nil
      super()
      init_cause(nil) # Disallow subsequent initCause
    end
    
    typesig { [JavaThrowable] }
    # Constructs a new <code>ExceptionInInitializerError</code> class by
    # saving a reference to the <code>Throwable</code> object thrown for
    # later retrieval by the {@link #getException()} method. The detail
    # message string is set to <code>null</code>.
    # 
    # @param thrown The exception thrown
    def initialize(thrown)
      @exception = nil
      super()
      init_cause(nil) # Disallow subsequent initCause
      @exception = thrown
    end
    
    typesig { [String] }
    # Constructs an ExceptionInInitializerError with the specified detail
    # message string.  A detail message is a String that describes this
    # particular exception. The detail message string is saved for later
    # retrieval by the {@link Throwable#getMessage()} method. There is no
    # saved throwable object.
    # 
    # 
    # @param s the detail message
    def initialize(s)
      @exception = nil
      super(s)
      init_cause(nil) # Disallow subsequent initCause
    end
    
    typesig { [] }
    # Returns the exception that occurred during a static initialization that
    # caused this error to be created.
    # 
    # <p>This method predates the general-purpose exception chaining facility.
    # The {@link Throwable#getCause()} method is now the preferred means of
    # obtaining this information.
    # 
    # @return the saved throwable object of this
    # <code>ExceptionInInitializerError</code>, or <code>null</code>
    # if this <code>ExceptionInInitializerError</code> has no saved
    # throwable object.
    def get_exception
      return @exception
    end
    
    typesig { [] }
    # Returns the cause of this error (the exception that occurred
    # during a static initialization that caused this error to be created).
    # 
    # @return  the cause of this error or <code>null</code> if the
    # cause is nonexistent or unknown.
    # @since   1.4
    def get_cause
      return @exception
    end
    
    private
    alias_method :initialize__exception_in_initializer_error, :initialize
  end
  
end
