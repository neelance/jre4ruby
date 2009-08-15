require "rjava"

# Copyright 2000-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CertPathBuilderExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
      include_const ::Java::Security, :GeneralSecurityException
    }
  end
  
  # An exception indicating one of a variety of problems encountered when
  # building a certification path with a <code>CertPathBuilder</code>.
  # <p>
  # A <code>CertPathBuilderException</code> provides support for wrapping
  # exceptions. The {@link #getCause getCause} method returns the throwable,
  # if any, that caused this exception to be thrown.
  # <p>
  # <b>Concurrent Access</b>
  # <p>
  # Unless otherwise specified, the methods defined in this class are not
  # thread-safe. Multiple threads that need to access a single
  # object concurrently should synchronize amongst themselves and
  # provide the necessary locking. Multiple threads each manipulating
  # separate objects need not synchronize.
  # 
  # @see CertPathBuilder
  # 
  # @since       1.4
  # @author      Sean Mullan
  class CertPathBuilderException < CertPathBuilderExceptionImports.const_get :GeneralSecurityException
    include_class_members CertPathBuilderExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 5316471420178794402 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Creates a <code>CertPathBuilderException</code> with <code>null</code>
    # as its detail message.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Creates a <code>CertPathBuilderException</code> with the given
    # detail message. The detail message is a <code>String</code> that
    # describes this particular exception in more detail.
    # 
    # @param msg the detail message
    def initialize(msg)
      super(msg)
    end
    
    typesig { [JavaThrowable] }
    # Creates a <code>CertPathBuilderException</code> that wraps the specified
    # throwable. This allows any exception to be converted into a
    # <code>CertPathBuilderException</code>, while retaining information
    # about the wrapped exception, which may be useful for debugging. The
    # detail message is set to (<code>cause==null ? null : cause.toString()
    # </code>) (which typically contains the class and detail message of
    # cause).
    # 
    # @param cause the cause (which is saved for later retrieval by the
    # {@link #getCause getCause()} method). (A <code>null</code> value is
    # permitted, and indicates that the cause is nonexistent or unknown.)
    def initialize(cause)
      super(cause)
    end
    
    typesig { [String, JavaThrowable] }
    # Creates a <code>CertPathBuilderException</code> with the specified
    # detail message and cause.
    # 
    # @param msg the detail message
    # @param  cause the cause (which is saved for later retrieval by the
    # {@link #getCause getCause()} method). (A <code>null</code> value is
    # permitted, and indicates that the cause is nonexistent or unknown.)
    def initialize(msg, cause)
      super(msg, cause)
    end
    
    private
    alias_method :initialize__cert_path_builder_exception, :initialize
  end
  
end
