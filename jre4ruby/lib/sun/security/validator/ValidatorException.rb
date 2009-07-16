require "rjava"

# 
# Copyright 2002-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Validator
  module ValidatorExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Validator
      include ::Java::Security::Cert
    }
  end
  
  # 
  # ValidatorException thrown by the Validator. It has optional fields that
  # allow better error diagnostics.
  # 
  # @author Andreas Sterbenz
  class ValidatorException < ValidatorExceptionImports.const_get :CertificateException
    include_class_members ValidatorExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -2836879718282292155 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:T_NO_TRUST_ANCHOR) { "No trusted certificate found" }
      const_attr_reader  :T_NO_TRUST_ANCHOR
      
      const_set_lazy(:T_EE_EXTENSIONS) { "End entity certificate extension check failed" }
      const_attr_reader  :T_EE_EXTENSIONS
      
      const_set_lazy(:T_CA_EXTENSIONS) { "CA certificate extension check failed" }
      const_attr_reader  :T_CA_EXTENSIONS
      
      const_set_lazy(:T_CERT_EXPIRED) { "Certificate expired" }
      const_attr_reader  :T_CERT_EXPIRED
      
      const_set_lazy(:T_SIGNATURE_ERROR) { "Certificate signature validation failed" }
      const_attr_reader  :T_SIGNATURE_ERROR
      
      const_set_lazy(:T_NAME_CHAINING) { "Certificate chaining error" }
      const_attr_reader  :T_NAME_CHAINING
    }
    
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    attr_accessor :cert
    alias_method :attr_cert, :cert
    undef_method :cert
    alias_method :attr_cert=, :cert=
    undef_method :cert=
    
    typesig { [String] }
    def initialize(msg)
      @type = nil
      @cert = nil
      super(msg)
    end
    
    typesig { [String, Exception] }
    def initialize(msg, cause)
      @type = nil
      @cert = nil
      super(msg)
      init_cause(cause)
    end
    
    typesig { [Object] }
    def initialize(type)
      initialize__validator_exception(type, nil)
    end
    
    typesig { [Object, X509Certificate] }
    def initialize(type, cert)
      @type = nil
      @cert = nil
      super(type)
      @type = type
      @cert = cert
    end
    
    typesig { [Object, X509Certificate, Exception] }
    def initialize(type, cert, cause)
      initialize__validator_exception(type, cert)
      init_cause(cause)
    end
    
    typesig { [String, Object, X509Certificate] }
    def initialize(msg, type, cert)
      @type = nil
      @cert = nil
      super(msg)
      @type = type
      @cert = cert
    end
    
    typesig { [String, Object, X509Certificate, Exception] }
    def initialize(msg, type, cert, cause)
      initialize__validator_exception(msg, type, cert)
      init_cause(cause)
    end
    
    typesig { [] }
    # 
    # Get the type of the failure (one of the T_XXX constants), if
    # available. This may be helpful when designing a user interface.
    def get_error_type
      return @type
    end
    
    typesig { [] }
    # 
    # Get the certificate causing the exception, if available.
    def get_error_certificate
      return @cert
    end
    
    private
    alias_method :initialize__validator_exception, :initialize
  end
  
end
