require "rjava"

# 
# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CertificateImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
      include_const ::Java::Util, :Arrays
      include_const ::Java::Security, :PublicKey
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security, :NoSuchProviderException
      include_const ::Java::Security, :InvalidKeyException
      include_const ::Java::Security, :SignatureException
      include_const ::Sun::Security::X509, :X509CertImpl
    }
  end
  
  # 
  # <p>Abstract class for managing a variety of identity certificates.
  # An identity certificate is a binding of a principal to a public key which
  # is vouched for by another principal.  (A principal represents
  # an entity such as an individual user, a group, or a corporation.)
  # <p>
  # This class is an abstraction for certificates that have different
  # formats but important common uses.  For example, different types of
  # certificates, such as X.509 and PGP, share general certificate
  # functionality (like encoding and verifying) and
  # some types of information (like a public key).
  # <p>
  # X.509, PGP, and SDSI certificates can all be implemented by
  # subclassing the Certificate class, even though they contain different
  # sets of information, and they store and retrieve the information in
  # different ways.
  # 
  # @see X509Certificate
  # @see CertificateFactory
  # 
  # @author Hemma Prafullchandra
  class Certificate 
    include_class_members CertificateImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -3585440601605666277 }
      const_attr_reader  :SerialVersionUID
    }
    
    # the certificate type
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    typesig { [String] }
    # 
    # Creates a certificate of the specified type.
    # 
    # @param type the standard name of the certificate type.
    # See Appendix A in the <a href=
    # "../../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
    # Java Cryptography Architecture API Specification &amp; Reference </a>
    # for information about standard certificate types.
    def initialize(type)
      @type = nil
      @type = type
    end
    
    typesig { [] }
    # 
    # Returns the type of this certificate.
    # 
    # @return the type of this certificate.
    def get_type
      return @type
    end
    
    typesig { [Object] }
    # 
    # Compares this certificate for equality with the specified
    # object. If the <code>other</code> object is an
    # <code>instanceof</code> <code>Certificate</code>, then
    # its encoded form is retrieved and compared with the
    # encoded form of this certificate.
    # 
    # @param other the object to test for equality with this certificate.
    # @return true iff the encoded forms of the two certificates
    # match, false otherwise.
    def equals(other)
      if ((self).equal?(other))
        return true
      end
      if (!(other.is_a?(Certificate)))
        return false
      end
      begin
        this_cert = X509CertImpl.get_encoded_internal(self)
        other_cert = X509CertImpl.get_encoded_internal(other)
        return (Arrays == this_cert)
      rescue CertificateException => e
        return false
      end
    end
    
    typesig { [] }
    # 
    # Returns a hashcode value for this certificate from its
    # encoded form.
    # 
    # @return the hashcode value.
    def hash_code
      retval = 0
      begin
        cert_data = X509CertImpl.get_encoded_internal(self)
        i = 1
        while i < cert_data.attr_length
          retval += cert_data[i] * i
          ((i += 1) - 1)
        end
        return retval
      rescue CertificateException => e
        return retval
      end
    end
    
    typesig { [] }
    # 
    # Returns the encoded form of this certificate. It is
    # assumed that each certificate type would have only a single
    # form of encoding; for example, X.509 certificates would
    # be encoded as ASN.1 DER.
    # 
    # @return the encoded form of this certificate
    # 
    # @exception CertificateEncodingException if an encoding error occurs.
    def get_encoded
      raise NotImplementedError
    end
    
    typesig { [PublicKey] }
    # 
    # Verifies that this certificate was signed using the
    # private key that corresponds to the specified public key.
    # 
    # @param key the PublicKey used to carry out the verification.
    # 
    # @exception NoSuchAlgorithmException on unsupported signature
    # algorithms.
    # @exception InvalidKeyException on incorrect key.
    # @exception NoSuchProviderException if there's no default provider.
    # @exception SignatureException on signature errors.
    # @exception CertificateException on encoding errors.
    def verify(key)
      raise NotImplementedError
    end
    
    typesig { [PublicKey, String] }
    # 
    # Verifies that this certificate was signed using the
    # private key that corresponds to the specified public key.
    # This method uses the signature verification engine
    # supplied by the specified provider.
    # 
    # @param key the PublicKey used to carry out the verification.
    # @param sigProvider the name of the signature provider.
    # 
    # @exception NoSuchAlgorithmException on unsupported signature
    # algorithms.
    # @exception InvalidKeyException on incorrect key.
    # @exception NoSuchProviderException on incorrect provider.
    # @exception SignatureException on signature errors.
    # @exception CertificateException on encoding errors.
    def verify(key, sig_provider)
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns a string representation of this certificate.
    # 
    # @return a string representation of this certificate.
    def to_s
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Gets the public key from this certificate.
    # 
    # @return the public key.
    def get_public_key
      raise NotImplementedError
    end
    
    class_module.module_eval {
      # 
      # Alternate Certificate class for serialization.
      # @since 1.3
      const_set_lazy(:CertificateRep) { Class.new do
        include_class_members Certificate
        include Java::Io::Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -8563758940495660020 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        attr_accessor :data
        alias_method :attr_data, :data
        undef_method :data
        alias_method :attr_data=, :data=
        undef_method :data=
        
        typesig { [String, Array.typed(::Java::Byte)] }
        # 
        # Construct the alternate Certificate class with the Certificate
        # type and Certificate encoding bytes.
        # 
        # <p>
        # 
        # @param type the standard name of the Certificate type. <p>
        # 
        # @param data the Certificate data.
        def initialize(type, data)
          @type = nil
          @data = nil
          @type = type
          @data = data
        end
        
        typesig { [] }
        # 
        # Resolve the Certificate Object.
        # 
        # <p>
        # 
        # @return the resolved Certificate Object
        # 
        # @throws java.io.ObjectStreamException if the Certificate
        # could not be resolved
        def read_resolve
          begin
            cf = CertificateFactory.get_instance(@type)
            return cf.generate_certificate(Java::Io::ByteArrayInputStream.new(@data))
          rescue CertificateException => e
            raise Java::Io::NotSerializableException.new("java.security.cert.Certificate: " + @type + ": " + (e.get_message).to_s)
          end
        end
        
        private
        alias_method :initialize__certificate_rep, :initialize
      end }
    }
    
    typesig { [] }
    # 
    # Replace the Certificate to be serialized.
    # 
    # @return the alternate Certificate object to be serialized
    # 
    # @throws java.io.ObjectStreamException if a new object representing
    # this Certificate could not be created
    # @since 1.3
    def write_replace
      begin
        return CertificateRep.new(@type, get_encoded)
      rescue CertificateException => e
        raise Java::Io::NotSerializableException.new("java.security.cert.Certificate: " + @type + ": " + (e.get_message).to_s)
      end
    end
    
    private
    alias_method :initialize__certificate, :initialize
  end
  
end
