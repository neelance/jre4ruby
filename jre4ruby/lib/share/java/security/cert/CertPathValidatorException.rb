require "rjava"

# Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CertPathValidatorExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
      include_const ::Java::Security, :GeneralSecurityException
    }
  end
  
  # An exception indicating one of a variety of problems encountered when
  # validating a certification path.
  # <p>
  # A <code>CertPathValidatorException</code> provides support for wrapping
  # exceptions. The {@link #getCause getCause} method returns the throwable,
  # if any, that caused this exception to be thrown.
  # <p>
  # A <code>CertPathValidatorException</code> may also include the
  # certification path that was being validated when the exception was thrown
  # and the index of the certificate in the certification path that caused the
  # exception to be thrown. Use the {@link #getCertPath getCertPath} and
  # {@link #getIndex getIndex} methods to retrieve this information.
  # 
  # <p>
  # <b>Concurrent Access</b>
  # <p>
  # Unless otherwise specified, the methods defined in this class are not
  # thread-safe. Multiple threads that need to access a single
  # object concurrently should synchronize amongst themselves and
  # provide the necessary locking. Multiple threads each manipulating
  # separate objects need not synchronize.
  # 
  # @see CertPathValidator
  # 
  # @since       1.4
  # @author      Yassir Elley
  class CertPathValidatorException < CertPathValidatorExceptionImports.const_get :GeneralSecurityException
    include_class_members CertPathValidatorExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -3083180014971893139 }
      const_attr_reader  :SerialVersionUID
    }
    
    # @serial the index of the certificate in the certification path
    # that caused the exception to be thrown
    attr_accessor :index
    alias_method :attr_index, :index
    undef_method :index
    alias_method :attr_index=, :index=
    undef_method :index=
    
    # @serial the <code>CertPath</code> that was being validated when
    # the exception was thrown
    attr_accessor :cert_path
    alias_method :attr_cert_path, :cert_path
    undef_method :cert_path
    alias_method :attr_cert_path=, :cert_path=
    undef_method :cert_path=
    
    typesig { [] }
    # Creates a <code>CertPathValidatorException</code> with
    # no detail message.
    def initialize
      @index = 0
      @cert_path = nil
      super()
      @index = -1
    end
    
    typesig { [String] }
    # Creates a <code>CertPathValidatorException</code> with the given
    # detail message. A detail message is a <code>String</code> that
    # describes this particular exception.
    # 
    # @param msg the detail message
    def initialize(msg)
      @index = 0
      @cert_path = nil
      super(msg)
      @index = -1
    end
    
    typesig { [JavaThrowable] }
    # Creates a <code>CertPathValidatorException</code> that wraps the
    # specified throwable. This allows any exception to be converted into a
    # <code>CertPathValidatorException</code>, while retaining information
    # about the wrapped exception, which may be useful for debugging. The
    # detail message is set to (<code>cause==null ? null : cause.toString()
    # </code>) (which typically contains the class and detail message of
    # cause).
    # 
    # @param cause the cause (which is saved for later retrieval by the
    # {@link #getCause getCause()} method). (A <code>null</code> value is
    # permitted, and indicates that the cause is nonexistent or unknown.)
    def initialize(cause)
      @index = 0
      @cert_path = nil
      super(cause)
      @index = -1
    end
    
    typesig { [String, JavaThrowable] }
    # Creates a <code>CertPathValidatorException</code> with the specified
    # detail message and cause.
    # 
    # @param msg the detail message
    # @param cause the cause (which is saved for later retrieval by the
    # {@link #getCause getCause()} method). (A <code>null</code> value is
    # permitted, and indicates that the cause is nonexistent or unknown.)
    def initialize(msg, cause)
      @index = 0
      @cert_path = nil
      super(msg, cause)
      @index = -1
    end
    
    typesig { [String, JavaThrowable, CertPath, ::Java::Int] }
    # Creates a <code>CertPathValidatorException</code> with the specified
    # detail message, cause, certification path, and index.
    # 
    # @param msg the detail message (or <code>null</code> if none)
    # @param cause the cause (or <code>null</code> if none)
    # @param certPath the certification path that was in the process of
    # being validated when the error was encountered
    # @param index the index of the certificate in the certification path
    # that caused the error (or -1 if not applicable). Note that
    # the list of certificates in a <code>CertPath</code> is zero based.
    # @throws IndexOutOfBoundsException if the index is out of range
    # <code>(index < -1 || (certPath != null && index >=
    # certPath.getCertificates().size())</code>
    # @throws IllegalArgumentException if <code>certPath</code> is
    # <code>null</code> and <code>index</code> is not -1
    def initialize(msg, cause, cert_path, index)
      @index = 0
      @cert_path = nil
      super(msg, cause)
      @index = -1
      if ((cert_path).nil? && !(index).equal?(-1))
        raise IllegalArgumentException.new
      end
      if (index < -1 || (!(cert_path).nil? && index >= cert_path.get_certificates.size))
        raise IndexOutOfBoundsException.new
      end
      @cert_path = cert_path
      @index = index
    end
    
    typesig { [] }
    # Returns the certification path that was being validated when
    # the exception was thrown.
    # 
    # @return the <code>CertPath</code> that was being validated when
    # the exception was thrown (or <code>null</code> if not specified)
    def get_cert_path
      return @cert_path
    end
    
    typesig { [] }
    # Returns the index of the certificate in the certification path
    # that caused the exception to be thrown. Note that the list of
    # certificates in a <code>CertPath</code> is zero based. If no
    # index has been set, -1 is returned.
    # 
    # @return the index that has been set, or -1 if none has been set
    def get_index
      return @index
    end
    
    private
    alias_method :initialize__cert_path_validator_exception, :initialize
  end
  
end