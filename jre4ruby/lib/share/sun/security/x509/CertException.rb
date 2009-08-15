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
module Sun::Security::X509
  module CertExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
    }
  end
  
  # CertException indicates one of a variety of certificate problems.
  # 
  # @deprecated use one of Exceptions defined in the java.security.cert
  # package.
  # 
  # @see java.security.Certificate
  # 
  # 
  # @author David Brownell
  class CertException < CertExceptionImports.const_get :SecurityException
    include_class_members CertExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 6930793039696446142 }
      const_attr_reader  :SerialVersionUID
      
      # Zero is reserved.
      # Indicates that the signature in the certificate is not valid.
      const_set_lazy(:Verf_INVALID_SIG) { 1 }
      const_attr_reader  :Verf_INVALID_SIG
      
      # Indicates that the certificate was revoked, and so is invalid.
      const_set_lazy(:Verf_INVALID_REVOKED) { 2 }
      const_attr_reader  :Verf_INVALID_REVOKED
      
      # Indicates that the certificate is not yet valid.
      const_set_lazy(:Verf_INVALID_NOTBEFORE) { 3 }
      const_attr_reader  :Verf_INVALID_NOTBEFORE
      
      # Indicates that the certificate has expired and so is not valid.
      const_set_lazy(:Verf_INVALID_EXPIRED) { 4 }
      const_attr_reader  :Verf_INVALID_EXPIRED
      
      # Indicates that a certificate authority in the certification
      # chain is not trusted.
      const_set_lazy(:Verf_CA_UNTRUSTED) { 5 }
      const_attr_reader  :Verf_CA_UNTRUSTED
      
      # Indicates that the certification chain is too long.
      const_set_lazy(:Verf_CHAIN_LENGTH) { 6 }
      const_attr_reader  :Verf_CHAIN_LENGTH
      
      # Indicates an error parsing the ASN.1/DER encoding of the certificate.
      const_set_lazy(:Verf_PARSE_ERROR) { 7 }
      const_attr_reader  :Verf_PARSE_ERROR
      
      # Indicates an error constructing a certificate or certificate chain.
      const_set_lazy(:Err_CONSTRUCTION) { 8 }
      const_attr_reader  :Err_CONSTRUCTION
      
      # Indicates a problem with the public key
      const_set_lazy(:Err_INVALID_PUBLIC_KEY) { 9 }
      const_attr_reader  :Err_INVALID_PUBLIC_KEY
      
      # Indicates a problem with the certificate version
      const_set_lazy(:Err_INVALID_VERSION) { 10 }
      const_attr_reader  :Err_INVALID_VERSION
      
      # Indicates a problem with the certificate format
      const_set_lazy(:Err_INVALID_FORMAT) { 11 }
      const_attr_reader  :Err_INVALID_FORMAT
      
      # Indicates a problem with the certificate encoding
      const_set_lazy(:Err_ENCODING) { 12 }
      const_attr_reader  :Err_ENCODING
    }
    
    # Private data members
    attr_accessor :verf_code
    alias_method :attr_verf_code, :verf_code
    undef_method :verf_code
    alias_method :attr_verf_code=, :verf_code=
    undef_method :verf_code=
    
    attr_accessor :more_data
    alias_method :attr_more_data, :more_data
    undef_method :more_data
    alias_method :attr_more_data=, :more_data=
    undef_method :more_data=
    
    typesig { [::Java::Int, String] }
    # Constructs a certificate exception using an error code
    # (<code>verf_*</code>) and a string describing the context
    # of the error.
    def initialize(code, moredata)
      @verf_code = 0
      @more_data = nil
      super()
      @verf_code = code
      @more_data = moredata
    end
    
    typesig { [::Java::Int] }
    # Constructs a certificate exception using just an error code,
    # without a string describing the context.
    def initialize(code)
      @verf_code = 0
      @more_data = nil
      super()
      @verf_code = code
    end
    
    typesig { [] }
    # Returns the error code with which the exception was created.
    def get_verf_code
      return @verf_code
    end
    
    typesig { [] }
    # Returns a string describing the context in which the exception
    # was reported.
    def get_more_data
      return @more_data
    end
    
    typesig { [] }
    # Return a string corresponding to the error code used to create
    # this exception.
    def get_verf_description
      case (@verf_code)
      when Verf_INVALID_SIG
        return "The signature in the certificate is not valid."
      when Verf_INVALID_REVOKED
        return "The certificate has been revoked."
      when Verf_INVALID_NOTBEFORE
        return "The certificate is not yet valid."
      when Verf_INVALID_EXPIRED
        return "The certificate has expired."
      when Verf_CA_UNTRUSTED
        return "The Authority which issued the certificate is not trusted."
      when Verf_CHAIN_LENGTH
        return "The certificate path to a trusted authority is too long."
      when Verf_PARSE_ERROR
        return "The certificate could not be parsed."
      when Err_CONSTRUCTION
        return "There was an error when constructing the certificate."
      when Err_INVALID_PUBLIC_KEY
        return "The public key was not in the correct format."
      when Err_INVALID_VERSION
        return "The certificate has an invalid version number."
      when Err_INVALID_FORMAT
        return "The certificate has an invalid format."
      when Err_ENCODING
        return "Problem encountered while encoding the data."
      else
        return "Unknown code:  " + RJava.cast_to_string(@verf_code)
      end
    end
    
    typesig { [] }
    # Returns a string describing the certificate exception.
    def to_s
      return "[Certificate Exception: " + RJava.cast_to_string(get_message) + "]"
    end
    
    typesig { [] }
    # Returns a string describing the certificate exception.
    def get_message
      return get_verf_description + ((!(@more_data).nil?) ? ("\n  (" + @more_data + ")") : "")
    end
    
    private
    alias_method :initialize__cert_exception, :initialize
  end
  
end
