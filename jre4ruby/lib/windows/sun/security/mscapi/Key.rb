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
  module KeyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Mscapi
    }
  end
  
  # The handle for an RSA or DSA key using the Microsoft Crypto API.
  # 
  # @see DSAPrivateKey
  # @see RSAPrivateKey
  # @see RSAPublicKey
  # 
  # @since 1.6
  # @author  Stanley Man-Kit Ho
  class Key 
    include_class_members KeyImports
    include Java::Security::Key
    
    # Native handle
    attr_accessor :h_crypt_prov
    alias_method :attr_h_crypt_prov, :h_crypt_prov
    undef_method :h_crypt_prov
    alias_method :attr_h_crypt_prov=, :h_crypt_prov=
    undef_method :h_crypt_prov=
    
    attr_accessor :h_crypt_key
    alias_method :attr_h_crypt_key, :h_crypt_key
    undef_method :h_crypt_key
    alias_method :attr_h_crypt_key=, :h_crypt_key=
    undef_method :h_crypt_key=
    
    # Key length
    attr_accessor :key_length
    alias_method :attr_key_length, :key_length
    undef_method :key_length
    alias_method :attr_key_length=, :key_length=
    undef_method :key_length=
    
    typesig { [::Java::Long, ::Java::Long, ::Java::Int] }
    # Construct a Key object.
    def initialize(h_crypt_prov, h_crypt_key, key_length)
      @h_crypt_prov = 0
      @h_crypt_key = 0
      @key_length = 0
      @h_crypt_prov = h_crypt_prov
      @h_crypt_key = h_crypt_key
      @key_length = key_length
    end
    
    typesig { [] }
    # Finalization method
    def finalize
      begin
        synchronized((self)) do
          clean_up(@h_crypt_prov, @h_crypt_key)
          @h_crypt_prov = 0
          @h_crypt_key = 0
        end
      ensure
        super
      end
    end
    
    class_module.module_eval {
      JNI.native_method :Java_sun_security_mscapi_Key_cleanUp, [:pointer, :long, :int64, :int64], :void
      typesig { [::Java::Long, ::Java::Long] }
      # Native method to cleanup the key handle.
      def clean_up(h_crypt_prov, h_crypt_key)
        JNI.__send__(:Java_sun_security_mscapi_Key_cleanUp, JNI.env, self.jni_id, h_crypt_prov.to_int, h_crypt_key.to_int)
      end
    }
    
    typesig { [] }
    # Return bit length of the key.
    def bit_length
      return @key_length
    end
    
    typesig { [] }
    # Return native HCRYPTKEY handle.
    def get_hcrypt_key
      return @h_crypt_key
    end
    
    typesig { [] }
    # Return native HCRYPTPROV handle.
    def get_hcrypt_provider
      return @h_crypt_prov
    end
    
    typesig { [] }
    # Returns the standard algorithm name for this key. For
    # example, "DSA" would indicate that this key is a DSA key.
    # See Appendix A in the <a href=
    # "../../../guide/security/CryptoSpec.html#AppA">
    # Java Cryptography Architecture API Specification &amp; Reference </a>
    # for information about standard algorithm names.
    # 
    # @return the name of the algorithm associated with this key.
    def get_algorithm
      raise NotImplementedError
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
      return nil
    end
    
    typesig { [] }
    # Returns the key in its primary encoding format, or null
    # if this key does not support encoding.
    # 
    # @return the encoded key, or null if the key does not support
    # encoding.
    def get_encoded
      return nil
    end
    
    class_module.module_eval {
      JNI.native_method :Java_sun_security_mscapi_Key_getContainerName, [:pointer, :long, :int64], :long
      typesig { [::Java::Long] }
      def get_container_name(h_crypt_prov)
        JNI.__send__(:Java_sun_security_mscapi_Key_getContainerName, JNI.env, self.jni_id, h_crypt_prov.to_int)
      end
      
      JNI.native_method :Java_sun_security_mscapi_Key_getKeyType, [:pointer, :long, :int64], :long
      typesig { [::Java::Long] }
      def get_key_type(h_crypt_key)
        JNI.__send__(:Java_sun_security_mscapi_Key_getKeyType, JNI.env, self.jni_id, h_crypt_key.to_int)
      end
    }
    
    private
    alias_method :initialize__key, :initialize
  end
  
end
