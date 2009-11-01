require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Mscapi
  module RSAPublicKeyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Mscapi
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Security, :InvalidKeyException
      include_const ::Java::Security, :KeyRep
      include_const ::Java::Security, :PublicKey
      include_const ::Sun::Security::Rsa, :RSAPublicKeyImpl
    }
  end
  
  # The handle for an RSA public key using the Microsoft Crypto API.
  # 
  # @since 1.6
  class RSAPublicKey < RSAPublicKeyImports.const_get :Key
    include_class_members RSAPublicKeyImports
    overload_protected {
      include Java::Security::Interfaces::RSAPublicKey
    }
    
    attr_accessor :public_key_blob
    alias_method :attr_public_key_blob, :public_key_blob
    undef_method :public_key_blob
    alias_method :attr_public_key_blob=, :public_key_blob=
    undef_method :public_key_blob=
    
    attr_accessor :encoding
    alias_method :attr_encoding, :encoding
    undef_method :encoding
    alias_method :attr_encoding=, :encoding=
    undef_method :encoding=
    
    attr_accessor :modulus
    alias_method :attr_modulus, :modulus
    undef_method :modulus
    alias_method :attr_modulus=, :modulus=
    undef_method :modulus=
    
    attr_accessor :exponent
    alias_method :attr_exponent, :exponent
    undef_method :exponent
    alias_method :attr_exponent=, :exponent=
    undef_method :exponent=
    
    typesig { [::Java::Long, ::Java::Long, ::Java::Int] }
    # Construct an RSAPublicKey object.
    def initialize(h_crypt_prov, h_crypt_key, key_length)
      @public_key_blob = nil
      @encoding = nil
      @modulus = nil
      @exponent = nil
      super(h_crypt_prov, h_crypt_key, key_length)
      @public_key_blob = nil
      @encoding = nil
      @modulus = nil
      @exponent = nil
    end
    
    typesig { [] }
    # Returns the standard algorithm name for this key. For
    # example, "RSA" would indicate that this key is a RSA key.
    # See Appendix A in the <a href=
    # "../../../guide/security/CryptoSpec.html#AppA">
    # Java Cryptography Architecture API Specification &amp; Reference </a>
    # for information about standard algorithm names.
    # 
    # @return the name of the algorithm associated with this key.
    def get_algorithm
      return "RSA"
    end
    
    typesig { [] }
    # Returns a printable description of the key.
    def to_s
      sb = StringBuffer.new
      sb.append("RSAPublicKey [size=").append(self.attr_key_length).append(" bits, type=").append(get_key_type(self.attr_h_crypt_key)).append(", container=").append(get_container_name(self.attr_h_crypt_prov)).append("]\n  modulus: ").append(get_modulus).append("\n  public exponent: ").append(get_public_exponent)
      return sb.to_s
    end
    
    typesig { [] }
    # Returns the public exponent.
    def get_public_exponent
      if ((@exponent).nil?)
        @public_key_blob = get_public_key_blob(self.attr_h_crypt_key)
        @exponent = BigInteger.new(get_exponent(@public_key_blob))
      end
      return @exponent
    end
    
    typesig { [] }
    # Returns the modulus.
    def get_modulus
      if ((@modulus).nil?)
        @public_key_blob = get_public_key_blob(self.attr_h_crypt_key)
        @modulus = BigInteger.new(get_modulus(@public_key_blob))
      end
      return @modulus
    end
    
    typesig { [] }
    # Returns the name of the primary encoding format of this key,
    # or null if this key does not support encoding.
    # The primary encoding format is
    # named in terms of the appropriate ASN.1 data format, if an
    # ASN.1 specification for this key exists.
    # For example, the name of the ASN.1 data format for public
    # keys is <I>SubjectPublicKeyInfo</I>, as
    # defined by the X.509 standard; in this case, the returned format is
    # <code>"X.509"</code>. Similarly,
    # the name of the ASN.1 data format for private keys is
    # <I>PrivateKeyInfo</I>,
    # as defined by the PKCS #8 standard; in this case, the returned format is
    # <code>"PKCS#8"</code>.
    # 
    # @return the primary encoding format of the key.
    def get_format
      return "X.509"
    end
    
    typesig { [] }
    # Returns the key in its primary encoding format, or null
    # if this key does not support encoding.
    # 
    # @return the encoded key, or null if the key does not support
    # encoding.
    def get_encoded
      if ((@encoding).nil?)
        begin
          @encoding = RSAPublicKeyImpl.new(get_modulus, get_public_exponent).get_encoded
        rescue InvalidKeyException => e
          # ignore
        end
      end
      return @encoding
    end
    
    typesig { [] }
    def write_replace
      return KeyRep.new(KeyRep::Type::PUBLIC, get_algorithm, get_format, get_encoded)
    end
    
    JNI.load_native_method :Java_sun_security_mscapi_RSAPublicKey_getPublicKeyBlob, [:pointer, :long, :int64], :long
    typesig { [::Java::Long] }
    # Returns the Microsoft CryptoAPI representation of the key.
    def get_public_key_blob(h_crypt_key)
      JNI.call_native_method(:Java_sun_security_mscapi_RSAPublicKey_getPublicKeyBlob, JNI.env, self.jni_id, h_crypt_key.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_mscapi_RSAPublicKey_getExponent, [:pointer, :long, :long], :long
    typesig { [Array.typed(::Java::Byte)] }
    # Returns the key's public exponent (in big-endian 2's complement format).
    def get_exponent(key_blob)
      JNI.call_native_method(:Java_sun_security_mscapi_RSAPublicKey_getExponent, JNI.env, self.jni_id, key_blob.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_mscapi_RSAPublicKey_getModulus, [:pointer, :long, :long], :long
    typesig { [Array.typed(::Java::Byte)] }
    # Returns the key's modulus (in big-endian 2's complement format).
    def get_modulus(key_blob)
      JNI.call_native_method(:Java_sun_security_mscapi_RSAPublicKey_getModulus, JNI.env, self.jni_id, key_blob.jni_id)
    end
    
    private
    alias_method :initialize__rsapublic_key, :initialize
  end
  
end
