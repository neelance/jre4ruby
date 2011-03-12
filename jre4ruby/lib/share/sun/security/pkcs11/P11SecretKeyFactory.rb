require "rjava"

# Copyright 2003-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Pkcs11
  module P11SecretKeyFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Util
      include ::Java::Security
      include ::Java::Security::Spec
      include ::Javax::Crypto
      include ::Javax::Crypto::Spec
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # SecretKeyFactory implementation class. This class currently supports
  # DES, DESede, AES, ARCFOUR, and Blowfish.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class P11SecretKeyFactory < P11SecretKeyFactoryImports.const_get :SecretKeyFactorySpi
    include_class_members P11SecretKeyFactoryImports
    
    # token instance
    attr_accessor :token
    alias_method :attr_token, :token
    undef_method :token
    alias_method :attr_token=, :token=
    undef_method :token=
    
    # algorithm name
    attr_accessor :algorithm
    alias_method :attr_algorithm, :algorithm
    undef_method :algorithm
    alias_method :attr_algorithm=, :algorithm=
    undef_method :algorithm=
    
    typesig { [Token, String] }
    def initialize(token, algorithm)
      @token = nil
      @algorithm = nil
      super()
      @token = token
      @algorithm = algorithm
    end
    
    class_module.module_eval {
      when_class_loaded do
        const_set :KeyTypes, HashMap.new
        add_key_type("RC4", CKK_RC4)
        add_key_type("ARCFOUR", CKK_RC4)
        add_key_type("DES", CKK_DES)
        add_key_type("DESede", CKK_DES3)
        add_key_type("AES", CKK_AES)
        add_key_type("Blowfish", CKK_BLOWFISH)
        # we don't implement RC2 or IDEA, but we want to be able to generate
        # keys for those SSL/TLS ciphersuites.
        add_key_type("RC2", CKK_RC2)
        add_key_type("IDEA", CKK_IDEA)
        add_key_type("TlsPremasterSecret", PCKK_TLSPREMASTER)
        add_key_type("TlsRsaPremasterSecret", PCKK_TLSRSAPREMASTER)
        add_key_type("TlsMasterSecret", PCKK_TLSMASTER)
        add_key_type("Generic", CKK_GENERIC_SECRET)
      end
      
      typesig { [String, ::Java::Long] }
      def add_key_type(name, id)
        l = Long.value_of(id)
        KeyTypes.put(name, l)
        KeyTypes.put(name.to_upper_case(Locale::ENGLISH), l)
      end
      
      typesig { [String] }
      def get_key_type(algorithm)
        l = KeyTypes.get(algorithm)
        if ((l).nil?)
          algorithm = RJava.cast_to_string(algorithm.to_upper_case(Locale::ENGLISH))
          l = KeyTypes.get(algorithm)
          if ((l).nil?)
            if (algorithm.starts_with("HMAC"))
              return PCKK_HMAC
            else
              if (algorithm.starts_with("SSLMAC"))
                return PCKK_SSLMAC
              end
            end
          end
        end
        return (!(l).nil?) ? l.long_value : -1
      end
      
      typesig { [Token, Key, String] }
      # Convert an arbitrary key of algorithm into a P11Key of provider.
      # Used engineTranslateKey(), P11Cipher.init(), and P11Mac.init().
      def convert_key(token, key, algorithm)
        token.ensure_valid
        if ((key).nil?)
          raise InvalidKeyException.new("Key must not be null")
        end
        if ((key.is_a?(SecretKey)).equal?(false))
          raise InvalidKeyException.new("Key must be a SecretKey")
        end
        algorithm_type = 0
        if ((algorithm).nil?)
          algorithm = RJava.cast_to_string(key.get_algorithm)
          algorithm_type = get_key_type(algorithm)
        else
          algorithm_type = get_key_type(algorithm)
          key_algorithm_type = get_key_type(key.get_algorithm)
          if (!(algorithm_type).equal?(key_algorithm_type))
            if (((algorithm_type).equal?(PCKK_HMAC)) || ((algorithm_type).equal?(PCKK_SSLMAC)))
              # ignore key algorithm for MACs
            else
              raise InvalidKeyException.new("Key algorithm must be " + algorithm)
            end
          end
        end
        if (key.is_a?(P11Key))
          p11key = key
          if ((p11key.attr_token).equal?(token))
            return p11key
          end
        end
        p11key = token.attr_secret_cache.get(key)
        if (!(p11key).nil?)
          return p11key
        end
        if ((("RAW" == key.get_format)).equal?(false))
          raise InvalidKeyException.new("Encoded format must be RAW")
        end
        encoded = key.get_encoded
        p11key = create_key(token, encoded, algorithm, algorithm_type)
        token.attr_secret_cache.put(key, p11key)
        return p11key
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      def fix_desparity(key, offset)
        i = 0
        while i < 8
          b = key[offset] & 0xfe
          b |= (JavaInteger.bit_count(b) & 1) ^ 1
          key[((offset += 1) - 1)] = b
          i += 1
        end
      end
      
      typesig { [Token, Array.typed(::Java::Byte), String, ::Java::Long] }
      def create_key(token, encoded, algorithm, key_type)
        n = encoded.attr_length
        key_length = 0
        case ((key_type).to_int)
        when (CKK_RC4).to_int
          if ((n < 5) || (n > 128))
            raise InvalidKeyException.new("ARCFOUR key length must be between 5 and 128 bytes")
          end
          key_length = n << 3
        when (CKK_DES).to_int
          if (!(n).equal?(8))
            raise InvalidKeyException.new("DES key length must be 8 bytes")
          end
          key_length = 56
          fix_desparity(encoded, 0)
        when (CKK_DES3).to_int
          if ((n).equal?(16))
            key_type = CKK_DES2
          else
            if ((n).equal?(24))
              key_type = CKK_DES3
              fix_desparity(encoded, 16)
            else
              raise InvalidKeyException.new("DESede key length must be 16 or 24 bytes")
            end
          end
          fix_desparity(encoded, 0)
          fix_desparity(encoded, 8)
          key_length = n * 7
        when (CKK_AES).to_int
          if ((!(n).equal?(16)) && (!(n).equal?(24)) && (!(n).equal?(32)))
            raise InvalidKeyException.new("AES key length must be 16, 24, or 32 bytes")
          end
          key_length = n << 3
        when (CKK_BLOWFISH).to_int
          if ((n < 5) || (n > 56))
            raise InvalidKeyException.new("Blowfish key length must be between 5 and 56 bytes")
          end
          key_length = n << 3
        when (CKK_GENERIC_SECRET).to_int, (PCKK_TLSPREMASTER).to_int, (PCKK_TLSRSAPREMASTER).to_int, (PCKK_TLSMASTER).to_int
          key_type = CKK_GENERIC_SECRET
          key_length = n << 3
        when (PCKK_SSLMAC).to_int, (PCKK_HMAC).to_int
          if ((n).equal?(0))
            raise InvalidKeyException.new("MAC keys must not be empty")
          end
          key_type = CKK_GENERIC_SECRET
          key_length = n << 3
        else
          raise InvalidKeyException.new("Unknown algorithm " + algorithm)
        end
        session = nil
        begin
          attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_SECRET_KEY), CK_ATTRIBUTE.new(CKA_KEY_TYPE, key_type), CK_ATTRIBUTE.new(CKA_VALUE, encoded)])
          attributes = token.get_attributes(O_IMPORT, CKO_SECRET_KEY, key_type, attributes)
          session = token.get_obj_session
          key_id = token.attr_p11._c_create_object(session.id, attributes)
          p11key = P11Key.secret_key(session, key_id, algorithm, key_length, attributes)
          return p11key
        rescue PKCS11Exception => e
          raise InvalidKeyException.new("Could not create key", e)
        ensure
          token.release_session(session)
        end
      end
    }
    
    typesig { [KeySpec] }
    # see JCE spec
    def engine_generate_secret(key_spec)
      @token.ensure_valid
      if ((key_spec).nil?)
        raise InvalidKeySpecException.new("KeySpec must not be null")
      end
      if (key_spec.is_a?(SecretKeySpec))
        begin
          key = convert_key(@token, key_spec, @algorithm)
          return key
        rescue InvalidKeyException => e
          raise InvalidKeySpecException.new(e)
        end
      else
        if (@algorithm.equals_ignore_case("DES"))
          if (key_spec.is_a?(DESKeySpec))
            key_bytes = (key_spec).get_key
            key_spec = SecretKeySpec.new(key_bytes, "DES")
            return engine_generate_secret(key_spec)
          end
        else
          if (@algorithm.equals_ignore_case("DESede"))
            if (key_spec.is_a?(DESedeKeySpec))
              key_bytes = (key_spec).get_key
              key_spec = SecretKeySpec.new(key_bytes, "DESede")
              return engine_generate_secret(key_spec)
            end
          end
        end
      end
      raise InvalidKeySpecException.new("Unsupported spec: " + RJava.cast_to_string(key_spec.get_class.get_name))
    end
    
    typesig { [SecretKey] }
    def get_key_bytes(key)
      begin
        key = engine_translate_key(key)
        if ((("RAW" == key.get_format)).equal?(false))
          raise InvalidKeySpecException.new("Could not obtain key bytes")
        end
        k = key.get_encoded
        return k
      rescue InvalidKeyException => e
        raise InvalidKeySpecException.new(e)
      end
    end
    
    typesig { [SecretKey, Class] }
    # see JCE spec
    def engine_get_key_spec(key, key_spec)
      @token.ensure_valid
      if (((key).nil?) || ((key_spec).nil?))
        raise InvalidKeySpecException.new("key and keySpec must not be null")
      end
      if (SecretKeySpec.is_assignable_from(key_spec))
        return SecretKeySpec.new(get_key_bytes(key), @algorithm)
      else
        if (@algorithm.equals_ignore_case("DES"))
          begin
            if (DESKeySpec.is_assignable_from(key_spec))
              return DESKeySpec.new(get_key_bytes(key))
            end
          rescue InvalidKeyException => e
            raise InvalidKeySpecException.new(e)
          end
        else
          if (@algorithm.equals_ignore_case("DESede"))
            begin
              if (DESedeKeySpec.is_assignable_from(key_spec))
                return DESedeKeySpec.new(get_key_bytes(key))
              end
            rescue InvalidKeyException => e
              raise InvalidKeySpecException.new(e)
            end
          end
        end
      end
      raise InvalidKeySpecException.new("Unsupported spec: " + RJava.cast_to_string(key_spec.get_name))
    end
    
    typesig { [SecretKey] }
    # see JCE spec
    def engine_translate_key(key)
      return convert_key(@token, key, @algorithm)
    end
    
    private
    alias_method :initialize__p11secret_key_factory, :initialize
  end
  
end
