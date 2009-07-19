require "rjava"

# Copyright 1996-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module RSASignatureImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Util, :Arrays
      include ::Java::Security
    }
  end
  
  # Signature implementation for the SSL/TLS RSA Signature variant with both
  # MD5 and SHA-1 MessageDigests. Used for explicit RSA server authentication
  # (RSA signed server key exchange for RSA_EXPORT and DHE_RSA) and RSA client
  # authentication (RSA signed certificate verify message).
  # 
  # It conforms to the standard JCA Signature API. It is registered in the
  # SunJSSE provider to avoid more complicated getInstance() code and
  # negative interaction with the JCA mechanisms for hardware providers.
  # 
  # The class should be instantiated via the getInstance() method in this class,
  # which returns the implementation from the prefered provider. The internal
  # implementation allows the hashes to be explicitly set, which is required
  # for RSA client authentication. It can be obtained via the
  # getInternalInstance() method.
  # 
  # This class is not thread safe.
  class RSASignature < RSASignatureImports.const_get :SignatureSpi
    include_class_members RSASignatureImports
    
    attr_accessor :raw_rsa
    alias_method :attr_raw_rsa, :raw_rsa
    undef_method :raw_rsa
    alias_method :attr_raw_rsa=, :raw_rsa=
    undef_method :raw_rsa=
    
    attr_accessor :md5
    alias_method :attr_md5, :md5
    undef_method :md5
    alias_method :attr_md5=, :md5=
    undef_method :md5=
    
    attr_accessor :sha
    alias_method :attr_sha, :sha
    undef_method :sha
    alias_method :attr_sha=, :sha=
    undef_method :sha=
    
    # flag indicating if the MessageDigests are in reset state
    attr_accessor :is_reset
    alias_method :attr_is_reset, :is_reset
    undef_method :is_reset
    alias_method :attr_is_reset=, :is_reset=
    undef_method :is_reset=
    
    typesig { [] }
    def initialize
      @raw_rsa = nil
      @md5 = nil
      @sha = nil
      @is_reset = false
      super()
      @raw_rsa = JsseJce.get_signature(JsseJce::SIGNATURE_RAWRSA)
      @is_reset = true
    end
    
    class_module.module_eval {
      typesig { [] }
      # Get an implementation for the RSA signature. Follows the standard
      # JCA getInstance() model, so it return the implementation from the
      # provider with the highest precedence, which may be this class.
      def get_instance
        return JsseJce.get_signature(JsseJce::SIGNATURE_SSLRSA)
      end
      
      typesig { [] }
      # Get an internal implementation for the RSA signature. Used for RSA
      # client authentication, which needs the ability to set the digests
      # to externally provided values via the setHashes() method.
      def get_internal_instance
        return Signature.get_instance(JsseJce::SIGNATURE_SSLRSA, "SunJSSE")
      end
      
      typesig { [Signature, MessageDigest, MessageDigest] }
      # Set the MD5 and SHA hashes to the provided objects.
      def set_hashes(sig, md5, sha)
        sig.set_parameter("hashes", Array.typed(MessageDigest).new([md5, sha]))
      end
    }
    
    typesig { [] }
    # Reset the MessageDigests unless they are already reset.
    def reset
      if ((@is_reset).equal?(false))
        @md5.reset
        @sha.reset
        @is_reset = true
      end
    end
    
    class_module.module_eval {
      typesig { [Key] }
      def check_null(key)
        if ((key).nil?)
          raise InvalidKeyException.new("Key must not be null")
        end
      end
    }
    
    typesig { [PublicKey] }
    def engine_init_verify(public_key)
      check_null(public_key)
      reset
      @raw_rsa.init_verify(public_key)
    end
    
    typesig { [PrivateKey] }
    def engine_init_sign(private_key)
      engine_init_sign(private_key, nil)
    end
    
    typesig { [PrivateKey, SecureRandom] }
    def engine_init_sign(private_key, random)
      check_null(private_key)
      reset
      @raw_rsa.init_sign(private_key, random)
    end
    
    typesig { [] }
    # lazily initialize the MessageDigests
    def init_digests
      if ((@md5).nil?)
        @md5 = JsseJce.get_md5
        @sha = JsseJce.get_sha
      end
    end
    
    typesig { [::Java::Byte] }
    def engine_update(b)
      init_digests
      @is_reset = false
      @md5.update(b)
      @sha.update(b)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def engine_update(b, off, len)
      init_digests
      @is_reset = false
      @md5.update(b, off, len)
      @sha.update(b, off, len)
    end
    
    typesig { [] }
    def get_digest
      begin
        init_digests
        data = Array.typed(::Java::Byte).new(36) { 0 }
        @md5.digest(data, 0, 16)
        @sha.digest(data, 16, 20)
        @is_reset = true
        return data
      rescue DigestException => e
        # should never occur
        raise SignatureException.new(e)
      end
    end
    
    typesig { [] }
    def engine_sign
      @raw_rsa.update(get_digest)
      return @raw_rsa.sign
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def engine_verify(sig_bytes)
      return engine_verify(sig_bytes, 0, sig_bytes.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def engine_verify(sig_bytes, offset, length)
      @raw_rsa.update(get_digest)
      return @raw_rsa.verify(sig_bytes, offset, length)
    end
    
    typesig { [String, Object] }
    def engine_set_parameter(param, value)
      if (((param == "hashes")).equal?(false))
        raise InvalidParameterException.new("Parameter not supported: " + param)
      end
      if ((value.is_a?(Array.typed(MessageDigest))).equal?(false))
        raise InvalidParameterException.new("value must be MessageDigest[]")
      end
      digests = value
      @md5 = digests[0]
      @sha = digests[1]
    end
    
    typesig { [String] }
    def engine_get_parameter(param)
      raise InvalidParameterException.new("Parameters not supported")
    end
    
    private
    alias_method :initialize__rsasignature, :initialize
  end
  
end
