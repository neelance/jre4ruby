require "rjava"

# Copyright 1997-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security::Cert
  module CRLExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
      include_const ::Java::Security, :GeneralSecurityException
    }
  end
  
  # CRL (Certificate Revocation List) Exception.
  # 
  # @author Hemma Prafullchandra
  class CRLException < CRLExceptionImports.const_get :GeneralSecurityException
    include_class_members CRLExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -6694728944094197147 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Constructs a CRLException with no detail message. A
    # detail message is a String that describes this particular
    # exception.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Constructs a CRLException with the specified detail
    # message. A detail message is a String that describes this
    # particular exception.
    # 
    # @param message the detail message.
    def initialize(message)
      super(message)
    end
    
    typesig { [String, JavaThrowable] }
    # Creates a <code>CRLException</code> with the specified
    # detail message and cause.
    # 
    # @param message the detail message (which is saved for later retrieval
    # by the {@link #getMessage()} method).
    # @param cause the cause (which is saved for later retrieval by the
    # {@link #getCause()} method).  (A <tt>null</tt> value is permitted,
    # and indicates that the cause is nonexistent or unknown.)
    # @since 1.5
    def initialize(message, cause)
      super(message, cause)
    end
    
    typesig { [JavaThrowable] }
    # Creates a <code>CRLException</code> with the specified cause
    # and a detail message of <tt>(cause==null ? null : cause.toString())</tt>
    # (which typically contains the class and detail message of
    # <tt>cause</tt>).
    # 
    # @param cause the cause (which is saved for later retrieval by the
    # {@link #getCause()} method).  (A <tt>null</tt> value is permitted,
    # and indicates that the cause is nonexistent or unknown.)
    # @since 1.5
    def initialize(cause)
      super(cause)
    end
    
    private
    alias_method :initialize__crlexception, :initialize
  end
  
end
