require "rjava"

# Copyright 1995-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ClassNotFoundExceptionImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # Thrown when an application tries to load in a class through its
  # string name using:
  # <ul>
  # <li>The <code>forName</code> method in class <code>Class</code>.
  # <li>The <code>findSystemClass</code> method in class
  # <code>ClassLoader</code> .
  # <li>The <code>loadClass</code> method in class <code>ClassLoader</code>.
  # </ul>
  # <p>
  # but no definition for the class with the specified name could be found.
  # 
  # <p>As of release 1.4, this exception has been retrofitted to conform to
  # the general purpose exception-chaining mechanism.  The "optional exception
  # that was raised while loading the class" that may be provided at
  # construction time and accessed via the {@link #getException()} method is
  # now known as the <i>cause</i>, and may be accessed via the {@link
  # Throwable#getCause()} method, as well as the aforementioned "legacy method."
  # 
  # @author  unascribed
  # @see     java.lang.Class#forName(java.lang.String)
  # @see     java.lang.ClassLoader#findSystemClass(java.lang.String)
  # @see     java.lang.ClassLoader#loadClass(java.lang.String, boolean)
  # @since   JDK1.0
  class ClassNotFoundException < ClassNotFoundExceptionImports.const_get :Exception
    include_class_members ClassNotFoundExceptionImports
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.1.X for interoperability
      const_set_lazy(:SerialVersionUID) { 9176873029745254542 }
      const_attr_reader  :SerialVersionUID
    }
    
    # This field holds the exception ex if the
    # ClassNotFoundException(String s, Throwable ex) constructor was
    # used to instantiate the object
    # @serial
    # @since 1.2
    attr_accessor :ex
    alias_method :attr_ex, :ex
    undef_method :ex
    alias_method :attr_ex=, :ex=
    undef_method :ex=
    
    typesig { [] }
    # Constructs a <code>ClassNotFoundException</code> with no detail message.
    def initialize
      @ex = nil
      super(nil) # Disallow initCause
    end
    
    typesig { [String] }
    # Constructs a <code>ClassNotFoundException</code> with the
    # specified detail message.
    # 
    # @param   s   the detail message.
    def initialize(s)
      @ex = nil
      super(s, nil) # Disallow initCause
    end
    
    typesig { [String, Exception] }
    # Constructs a <code>ClassNotFoundException</code> with the
    # specified detail message and optional exception that was
    # raised while loading the class.
    # 
    # @param s the detail message
    # @param ex the exception that was raised while loading the class
    # @since 1.2
    def initialize(s, ex)
      @ex = nil
      super(s, nil) # Disallow initCause
      @ex = ex
    end
    
    typesig { [] }
    # Returns the exception that was raised if an error occurred while
    # attempting to load the class. Otherwise, returns <tt>null</tt>.
    # 
    # <p>This method predates the general-purpose exception chaining facility.
    # The {@link Throwable#getCause()} method is now the preferred means of
    # obtaining this information.
    # 
    # @return the <code>Exception</code> that was raised while loading a class
    # @since 1.2
    def get_exception
      return @ex
    end
    
    typesig { [] }
    # Returns the cause of this exception (the exception that was raised
    # if an error occurred while attempting to load the class; otherwise
    # <tt>null</tt>).
    # 
    # @return  the cause of this exception.
    # @since   1.4
    def get_cause
      return @ex
    end
    
    private
    alias_method :initialize__class_not_found_exception, :initialize
  end
  
end
