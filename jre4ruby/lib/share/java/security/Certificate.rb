require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security
  module CertificateImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Io
      include_const ::Java::Util, :Date
    }
  end
  
  # <p>This is an interface of abstract methods for managing a
  # variety of identity certificates.
  # An identity certificate is a guarantee by a principal that
  # a public key is that of another principal.  (A principal represents
  # an entity such as an individual user, a group, or a corporation.)
  # 
  # <p>In particular, this interface is intended to be a common
  # abstraction for constructs that have different formats but
  # important common uses.  For example, different types of
  # certificates, such as X.509 certificates and PGP certificates,
  # share general certificate functionality (the need to encode and
  # decode certificates) and some types of information, such as a
  # public key, the principal whose key it is, and the guarantor
  # guaranteeing that the public key is that of the specified
  # principal. So an implementation of X.509 certificates and an
  # implementation of PGP certificates can both utilize the Certificate
  # interface, even though their formats and additional types and
  # amounts of information stored are different.
  # 
  # <p><b>Important</b>: This interface is useful for cataloging and
  # grouping objects sharing certain common uses. It does not have any
  # semantics of its own. In particular, a Certificate object does not
  # make any statement as to the <i>validity</i> of the binding. It is
  # the duty of the application implementing this interface to verify
  # the certificate and satisfy itself of its validity.
  # 
  # @author Benjamin Renaud
  # @deprecated A new certificate handling package is created in the Java platform.
  # This Certificate interface is entirely deprecated and
  # is here to allow for a smooth transition to the new
  # package.
  # @see java.security.cert.Certificate
  module Certificate
    include_class_members CertificateImports
    
    typesig { [] }
    # Returns the guarantor of the certificate, that is, the principal
    # guaranteeing that the public key associated with this certificate
    # is that of the principal associated with this certificate. For X.509
    # certificates, the guarantor will typically be a Certificate Authority
    # (such as the United States Postal Service or Verisign, Inc.).
    # 
    # @return the guarantor which guaranteed the principal-key
    # binding.
    def get_guarantor
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the principal of the principal-key pair being guaranteed by
    # the guarantor.
    # 
    # @return the principal to which this certificate is bound.
    def get_principal
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the key of the principal-key pair being guaranteed by
    # the guarantor.
    # 
    # @return the public key that this certificate certifies belongs
    # to a particular principal.
    def get_public_key
      raise NotImplementedError
    end
    
    typesig { [OutputStream] }
    # Encodes the certificate to an output stream in a format that can
    # be decoded by the <code>decode</code> method.
    # 
    # @param stream the output stream to which to encode the
    # certificate.
    # 
    # @exception KeyException if the certificate is not
    # properly initialized, or data is missing, etc.
    # 
    # @exception IOException if a stream exception occurs while
    # trying to output the encoded certificate to the output stream.
    # 
    # @see #decode
    # @see #getFormat
    def encode(stream)
      raise NotImplementedError
    end
    
    typesig { [InputStream] }
    # Decodes a certificate from an input stream. The format should be
    # that returned by <code>getFormat</code> and produced by
    # <code>encode</code>.
    # 
    # @param stream the input stream from which to fetch the data
    # being decoded.
    # 
    # @exception KeyException if the certificate is not properly initialized,
    # or data is missing, etc.
    # 
    # @exception IOException if an exception occurs while trying to input
    # the encoded certificate from the input stream.
    # 
    # @see #encode
    # @see #getFormat
    def decode(stream)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the name of the coding format. This is used as a hint to find
    # an appropriate parser. It could be "X.509", "PGP", etc. This is
    # the format produced and understood by the <code>encode</code>
    # and <code>decode</code> methods.
    # 
    # @return the name of the coding format.
    def get_format
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Returns a string that represents the contents of the certificate.
    # 
    # @param detailed whether or not to give detailed information
    # about the certificate
    # 
    # @return a string representing the contents of the certificate
    def to_s(detailed)
      raise NotImplementedError
    end
  end
  
end