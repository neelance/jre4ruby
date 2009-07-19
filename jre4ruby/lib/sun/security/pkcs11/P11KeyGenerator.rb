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
  module P11KeyGeneratorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Security
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include ::Javax::Crypto
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # KeyGenerator implementation class. This class currently supports
  # DES, DESede, AES, ARCFOUR, and Blowfish.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class P11KeyGenerator < P11KeyGeneratorImports.const_get :KeyGeneratorSpi
    include_class_members P11KeyGeneratorImports
    
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
    
    # mechanism id
    attr_accessor :mechanism
    alias_method :attr_mechanism, :mechanism
    undef_method :mechanism
    alias_method :attr_mechanism=, :mechanism=
    undef_method :mechanism=
    
    # raw key size in bits, e.g. 64 for DES. Always valid.
    attr_accessor :key_size
    alias_method :attr_key_size, :key_size
    undef_method :key_size
    alias_method :attr_key_size=, :key_size=
    undef_method :key_size=
    
    # bits of entropy in the key, e.g. 56 for DES. Always valid.
    attr_accessor :significant_key_size
    alias_method :attr_significant_key_size, :significant_key_size
    undef_method :significant_key_size
    alias_method :attr_significant_key_size=, :significant_key_size=
    undef_method :significant_key_size=
    
    # keyType (CKK_*), needed for TemplateManager call only.
    attr_accessor :key_type
    alias_method :attr_key_type, :key_type
    undef_method :key_type
    alias_method :attr_key_type=, :key_type=
    undef_method :key_type=
    
    # for determining if both 112 and 168 bits of DESede key lengths
    # are supported.
    attr_accessor :support_both_key_sizes
    alias_method :attr_support_both_key_sizes, :support_both_key_sizes
    undef_method :support_both_key_sizes
    alias_method :attr_support_both_key_sizes=, :support_both_key_sizes=
    undef_method :support_both_key_sizes=
    
    # min and max key sizes (in bits) for variable-key-length
    # algorithms, e.g. RC4 and Blowfish
    attr_accessor :min_key_size
    alias_method :attr_min_key_size, :min_key_size
    undef_method :min_key_size
    alias_method :attr_min_key_size=, :min_key_size=
    undef_method :min_key_size=
    
    attr_accessor :max_key_size
    alias_method :attr_max_key_size, :max_key_size
    undef_method :max_key_size
    alias_method :attr_max_key_size=, :max_key_size=
    undef_method :max_key_size=
    
    typesig { [Token, String, ::Java::Long] }
    def initialize(token, algorithm, mechanism)
      @token = nil
      @algorithm = nil
      @mechanism = 0
      @key_size = 0
      @significant_key_size = 0
      @key_type = 0
      @support_both_key_sizes = false
      @min_key_size = 0
      @max_key_size = 0
      super()
      @token = token
      @algorithm = algorithm
      @mechanism = mechanism
      if ((@mechanism).equal?(CKM_DES3_KEY_GEN))
        # Given the current lookup order specified in SunPKCS11.java,
        # if CKM_DES2_KEY_GEN is used to construct this object, it
        # means that CKM_DES3_KEY_GEN is disabled or unsupported.
        @support_both_key_sizes = (token.attr_provider.attr_config.is_enabled(CKM_DES2_KEY_GEN) && (!(token.get_mechanism_info(CKM_DES2_KEY_GEN)).nil?))
      else
        if ((@mechanism).equal?(CKM_RC4_KEY_GEN))
          info = token.get_mechanism_info(mechanism)
          # Although PKCS#11 spec documented that these are in bits,
          # NSS, for one, uses bytes. Multiple by 8 if the number seems
          # unreasonably small.
          if (info.attr_ul_min_key_size < 8)
            @min_key_size = RJava.cast_to_int(info.attr_ul_min_key_size) << 3
            @max_key_size = RJava.cast_to_int(info.attr_ul_max_key_size) << 3
          else
            @min_key_size = RJava.cast_to_int(info.attr_ul_min_key_size)
            @max_key_size = RJava.cast_to_int(info.attr_ul_max_key_size)
          end
          # Explicitly disallow keys shorter than 40-bits for security
          if (@min_key_size < 40)
            @min_key_size = 40
          end
        else
          if ((@mechanism).equal?(CKM_BLOWFISH_KEY_GEN))
            info = token.get_mechanism_info(mechanism)
            @max_key_size = RJava.cast_to_int(info.attr_ul_max_key_size) << 3
            @min_key_size = RJava.cast_to_int(info.attr_ul_min_key_size) << 3
            # Explicitly disallow keys shorter than 40-bits for security
            if (@min_key_size < 40)
              @min_key_size = 40
            end
          end
        end
      end
      set_default_key_size
    end
    
    typesig { [] }
    # set default keysize and also initialize keyType
    def set_default_key_size
      # whether to check default key size against the min and max value
      validate_key_size = false
      case (RJava.cast_to_int(@mechanism))
      when RJava.cast_to_int(CKM_DES_KEY_GEN)
        @key_size = 64
        @significant_key_size = 56
        @key_type = CKK_DES
      when RJava.cast_to_int(CKM_DES2_KEY_GEN)
        @key_size = 128
        @significant_key_size = 112
        @key_type = CKK_DES2
      when RJava.cast_to_int(CKM_DES3_KEY_GEN)
        @key_size = 192
        @significant_key_size = 168
        @key_type = CKK_DES3
      when RJava.cast_to_int(CKM_AES_KEY_GEN)
        @key_type = CKK_AES
        @key_size = 128
        @significant_key_size = 128
      when RJava.cast_to_int(CKM_RC4_KEY_GEN)
        @key_type = CKK_RC4
        @key_size = 128
        validate_key_size = true
      when RJava.cast_to_int(CKM_BLOWFISH_KEY_GEN)
        @key_type = CKK_BLOWFISH
        @key_size = 128
        validate_key_size = true
      else
        raise ProviderException.new("Unknown mechanism " + (@mechanism).to_s)
      end
      if (validate_key_size && ((@key_size > @max_key_size) || (@key_size < @min_key_size)))
        raise ProviderException.new("Unsupported key size")
      end
    end
    
    typesig { [SecureRandom] }
    # see JCE spec
    def engine_init(random)
      @token.ensure_valid
      set_default_key_size
    end
    
    typesig { [AlgorithmParameterSpec, SecureRandom] }
    # see JCE spec
    def engine_init(params, random)
      raise InvalidAlgorithmParameterException.new("AlgorithmParameterSpec not supported")
    end
    
    typesig { [::Java::Int, SecureRandom] }
    # see JCE spec
    def engine_init(key_size, random)
      @token.ensure_valid
      case (RJava.cast_to_int(@mechanism))
      when RJava.cast_to_int(CKM_DES_KEY_GEN)
        if ((!(key_size).equal?(@key_size)) && (!(key_size).equal?(@significant_key_size)))
          raise InvalidParameterException.new("DES key length must be 56 bits")
        end
      when RJava.cast_to_int(CKM_DES2_KEY_GEN), RJava.cast_to_int(CKM_DES3_KEY_GEN)
        new_mechanism = 0
        if (((key_size).equal?(112)) || ((key_size).equal?(128)))
          new_mechanism = CKM_DES2_KEY_GEN
        else
          if (((key_size).equal?(168)) || ((key_size).equal?(192)))
            new_mechanism = CKM_DES3_KEY_GEN
          else
            raise InvalidParameterException.new("DESede key length must be 112, or 168 bits")
          end
        end
        if (!(@mechanism).equal?(new_mechanism))
          if (@support_both_key_sizes)
            @mechanism = new_mechanism
            set_default_key_size
          else
            raise InvalidParameterException.new("Only " + (@significant_key_size).to_s + "-bit DESede key length is supported")
          end
        end
      when RJava.cast_to_int(CKM_AES_KEY_GEN)
        if ((!(key_size).equal?(128)) && (!(key_size).equal?(192)) && (!(key_size).equal?(256)))
          raise InvalidParameterException.new("AES key length must be 128, 192, or 256 bits")
        end
        @key_size = key_size
        @significant_key_size = key_size
      when RJava.cast_to_int(CKM_RC4_KEY_GEN), RJava.cast_to_int(CKM_BLOWFISH_KEY_GEN)
        if ((key_size < @min_key_size) || (key_size > @max_key_size))
          raise InvalidParameterException.new(@algorithm + " key length must be between " + (@min_key_size).to_s + " and " + (@max_key_size).to_s + " bits")
        end
        @key_size = key_size
        @significant_key_size = key_size
      else
        raise ProviderException.new("Unknown mechanism " + (@mechanism).to_s)
      end
    end
    
    typesig { [] }
    # see JCE spec
    def engine_generate_key
      session = nil
      begin
        session = @token.get_obj_session
        attributes = nil
        case (RJava.cast_to_int(@key_type))
        when RJava.cast_to_int(CKK_DES), RJava.cast_to_int(CKK_DES2), RJava.cast_to_int(CKK_DES3)
          # fixed length, do not specify CKA_VALUE_LEN
          attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_SECRET_KEY), ])
        else
          attributes = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_SECRET_KEY), CK_ATTRIBUTE.new(CKA_VALUE_LEN, @key_size >> 3), ])
        end
        attributes = @token.get_attributes(O_GENERATE, CKO_SECRET_KEY, @key_type, attributes)
        key_id = @token.attr_p11._c_generate_key(session.id, CK_MECHANISM.new(@mechanism), attributes)
        return P11Key.secret_key(session, key_id, @algorithm, @significant_key_size, attributes)
      rescue PKCS11Exception => e
        raise ProviderException.new("Could not generate key", e)
      ensure
        @token.release_session(session)
      end
    end
    
    private
    alias_method :initialize__p11key_generator, :initialize
  end
  
end
