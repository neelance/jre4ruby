require "rjava"

# 
# Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module WriteAbortedExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # 
  # Signals that one of the ObjectStreamExceptions was thrown during a
  # write operation.  Thrown during a read operation when one of the
  # ObjectStreamExceptions was thrown during a write operation.  The
  # exception that terminated the write can be found in the detail
  # field. The stream is reset to it's initial state and all references
  # to objects already deserialized are discarded.
  # 
  # <p>As of release 1.4, this exception has been retrofitted to conform to
  # the general purpose exception-chaining mechanism.  The "exception causing
  # the abort" that is provided at construction time and
  # accessed via the public {@link #detail} field is now known as the
  # <i>cause</i>, and may be accessed via the {@link Throwable#getCause()}
  # method, as well as the aforementioned "legacy field."
  # 
  # @author  unascribed
  # @since   JDK1.1
  class WriteAbortedException < WriteAbortedExceptionImports.const_get :ObjectStreamException
    include_class_members WriteAbortedExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -3326426625597282442 }
      const_attr_reader  :SerialVersionUID
    }
    
    # 
    # Exception that was caught while writing the ObjectStream.
    # 
    # <p>This field predates the general-purpose exception chaining facility.
    # The {@link Throwable#getCause()} method is now the preferred means of
    # obtaining this information.
    # 
    # @serial
    attr_accessor :detail
    alias_method :attr_detail, :detail
    undef_method :detail
    alias_method :attr_detail=, :detail=
    undef_method :detail=
    
    typesig { [String, Exception] }
    # 
    # Constructs a WriteAbortedException with a string describing
    # the exception and the exception causing the abort.
    # @param s   String describing the exception.
    # @param ex  Exception causing the abort.
    def initialize(s, ex)
      @detail = nil
      super(s)
      init_cause(nil) # Disallow subsequent initCause
      @detail = ex
    end
    
    typesig { [] }
    # 
    # Produce the message and include the message from the nested
    # exception, if there is one.
    def get_message
      if ((@detail).nil?)
        return super
      else
        return (super).to_s + "; " + (@detail.to_s).to_s
      end
    end
    
    typesig { [] }
    # 
    # Returns the exception that terminated the operation (the <i>cause</i>).
    # 
    # @return  the exception that terminated the operation (the <i>cause</i>),
    # which may be null.
    # @since   1.4
    def get_cause
      return @detail
    end
    
    private
    alias_method :initialize__write_aborted_exception, :initialize
  end
  
end
