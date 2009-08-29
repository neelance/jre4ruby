require "rjava"

# Copyright 2003-2008 Sun Microsystems, Inc.  All Rights Reserved.
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
  module P11KeyPairGeneratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include ::Java::Security::Spec
      include_const ::Javax::Crypto::Spec, :DHParameterSpec
      include_const ::Sun::Security::Provider, :ParameterCache
      include ::Sun::Security::Pkcs11::Wrapper
      include_const ::Sun::Security::Rsa, :RSAKeyFactory
    }
  end
  
  # KeyPairGenerator implementation class. This class currently supports
  # RSA, DSA, DH, and EC.
  # 
  # Note that for DSA and DH we rely on the Sun and SunJCE providers to
  # obtain the parameters from.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class P11KeyPairGenerator < P11KeyPairGeneratorImports.const_get :KeyPairGeneratorSpi
    include_class_members P11KeyPairGeneratorImports
    
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
    
    # selected or default key size, always valid
    attr_accessor :key_size
    alias_method :attr_key_size, :key_size
    undef_method :key_size
    alias_method :attr_key_size=, :key_size=
    undef_method :key_size=
    
    # parameters specified via init, if any
    attr_accessor :params
    alias_method :attr_params, :params
    undef_method :params
    alias_method :attr_params=, :params=
    undef_method :params=
    
    # for RSA, selected or default value of public exponent, always valid
    attr_accessor :rsa_public_exponent
    alias_method :attr_rsa_public_exponent, :rsa_public_exponent
    undef_method :rsa_public_exponent
    alias_method :attr_rsa_public_exponent=, :rsa_public_exponent=
    undef_method :rsa_public_exponent=
    
    # SecureRandom instance, if specified in init
    attr_accessor :random
    alias_method :attr_random, :random
    undef_method :random
    alias_method :attr_random=, :random=
    undef_method :random=
    
    typesig { [Token, String, ::Java::Long] }
    def initialize(token, algorithm, mechanism)
      @token = nil
      @algorithm = nil
      @mechanism = 0
      @key_size = 0
      @params = nil
      @rsa_public_exponent = nil
      @random = nil
      super()
      @rsa_public_exponent = RSAKeyGenParameterSpec::F4
      @token = token
      @algorithm = algorithm
      @mechanism = mechanism
      if ((algorithm == "EC"))
        initialize_(256, nil)
      else
        initialize_(1024, nil)
      end
    end
    
    typesig { [::Java::Int, SecureRandom] }
    # see JCA spec
    def initialize_(key_size, random)
      @token.ensure_valid
      begin
        check_key_size(key_size, nil)
      rescue InvalidAlgorithmParameterException => e
        raise InvalidParameterException.new(e.get_message)
      end
      @key_size = key_size
      @params = nil
      @random = random
      if ((@algorithm == "EC"))
        @params = P11ECKeyFactory.get_ecparameter_spec(key_size)
        if ((@params).nil?)
          raise InvalidParameterException.new("No EC parameters available for key size " + RJava.cast_to_string(key_size) + " bits")
        end
      end
    end
    
    typesig { [AlgorithmParameterSpec, SecureRandom] }
    # see JCA spec
    def initialize_(params, random)
      @token.ensure_valid
      if ((@algorithm == "DH"))
        if ((params.is_a?(DHParameterSpec)).equal?(false))
          raise InvalidAlgorithmParameterException.new("DHParameterSpec required for Diffie-Hellman")
        end
        dh_params = params
        tmp_key_size = dh_params.get_p.bit_length
        check_key_size(tmp_key_size, dh_params)
        @key_size = tmp_key_size
        @params = dh_params
        # XXX sanity check params
      else
        if ((@algorithm == "RSA"))
          if ((params.is_a?(RSAKeyGenParameterSpec)).equal?(false))
            raise InvalidAlgorithmParameterException.new("RSAKeyGenParameterSpec required for RSA")
          end
          rsa_params = params
          tmp_key_size = rsa_params.get_keysize
          check_key_size(tmp_key_size, rsa_params)
          @key_size = tmp_key_size
          @params = nil
          @rsa_public_exponent = rsa_params.get_public_exponent
          # XXX sanity check params
        else
          if ((@algorithm == "DSA"))
            if ((params.is_a?(DSAParameterSpec)).equal?(false))
              raise InvalidAlgorithmParameterException.new("DSAParameterSpec required for DSA")
            end
            dsa_params = params
            tmp_key_size = dsa_params.get_p.bit_length
            check_key_size(tmp_key_size, dsa_params)
            @key_size = tmp_key_size
            @params = dsa_params
            # XXX sanity check params
          else
            if ((@algorithm == "EC"))
              ec_params = nil
              if (params.is_a?(ECParameterSpec))
                ec_params = P11ECKeyFactory.get_ecparameter_spec(params)
                if ((ec_params).nil?)
                  raise InvalidAlgorithmParameterException.new("Unsupported curve: " + RJava.cast_to_string(params))
                end
              else
                if (params.is_a?(ECGenParameterSpec))
                  name = (params).get_name
                  ec_params = P11ECKeyFactory.get_ecparameter_spec(name)
                  if ((ec_params).nil?)
                    raise InvalidAlgorithmParameterException.new("Unknown curve name: " + name)
                  end
                else
                  raise InvalidAlgorithmParameterException.new("ECParameterSpec or ECGenParameterSpec required for EC")
                end
              end
              tmp_key_size = ec_params.get_curve.get_field.get_field_size
              check_key_size(tmp_key_size, ec_params)
              @key_size = tmp_key_size
              @params = ec_params
            else
              raise ProviderException.new("Unknown algorithm: " + @algorithm)
            end
          end
        end
      end
      @random = random
    end
    
    typesig { [::Java::Int, AlgorithmParameterSpec] }
    def check_key_size(key_size, params)
      if ((@algorithm == "EC"))
        if (key_size < 112)
          raise InvalidAlgorithmParameterException.new("Key size must be at least 112 bit")
        end
        if (key_size > 2048)
          # sanity check, nobody really wants keys this large
          raise InvalidAlgorithmParameterException.new("Key size must be at most 2048 bit")
        end
        return
      else
        if ((@algorithm == "RSA"))
          tmp_exponent = @rsa_public_exponent
          if (!(params).nil?)
            # Already tested for instanceof RSAKeyGenParameterSpec above
            tmp_exponent = (params).get_public_exponent
          end
          begin
            # This provider supports 64K or less.
            RSAKeyFactory.check_key_lengths(key_size, tmp_exponent, 512, 64 * 1024)
          rescue InvalidKeyException => e
            raise InvalidAlgorithmParameterException.new(e.get_message)
          end
          return
        end
      end
      if (key_size < 512)
        raise InvalidAlgorithmParameterException.new("Key size must be at least 512 bit")
      end
      if ((@algorithm == "DH") && (!(params).nil?))
        # sanity check, nobody really wants keys this large
        if (key_size > 64 * 1024)
          raise InvalidAlgorithmParameterException.new("Key size must be at most 65536 bit")
        end
      else
        # this restriction is in the spec for DSA
        # since we currently use DSA parameters for DH as well,
        # it also applies to DH if no parameters are specified
        if ((key_size > 1024) || (!((key_size & 0x3f)).equal?(0)))
          raise InvalidAlgorithmParameterException.new("Key size must be a multiple of 64 and at most 1024 bit")
        end
      end
    end
    
    typesig { [] }
    # see JCA spec
    def generate_key_pair
      @token.ensure_valid
      public_key_template = nil
      private_key_template = nil
      key_type = 0
      if ((@algorithm == "RSA"))
        key_type = CKK_RSA
        public_key_template = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_MODULUS_BITS, @key_size), CK_ATTRIBUTE.new(CKA_PUBLIC_EXPONENT, @rsa_public_exponent), ])
        # empty
        private_key_template = Array.typed(CK_ATTRIBUTE).new([])
      else
        if ((@algorithm == "DSA"))
          key_type = CKK_DSA
          dsa_params = nil
          if ((@params).nil?)
            begin
              dsa_params = ParameterCache.get_dsaparameter_spec(@key_size, @random)
            rescue GeneralSecurityException => e
              raise ProviderException.new("Could not generate DSA parameters", e)
            end
          else
            dsa_params = @params
          end
          public_key_template = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_PRIME, dsa_params.get_p), CK_ATTRIBUTE.new(CKA_SUBPRIME, dsa_params.get_q), CK_ATTRIBUTE.new(CKA_BASE, dsa_params.get_g), ])
          # empty
          private_key_template = Array.typed(CK_ATTRIBUTE).new([])
        else
          if ((@algorithm == "DH"))
            key_type = CKK_DH
            dh_params = nil
            private_bits = 0
            if ((@params).nil?)
              begin
                dh_params = ParameterCache.get_dhparameter_spec(@key_size, @random)
              rescue GeneralSecurityException => e
                raise ProviderException.new("Could not generate DH parameters", e)
              end
              private_bits = 0
            else
              dh_params = @params
              private_bits = dh_params.get_l
            end
            if (private_bits <= 0)
              # XXX find better defaults
              private_bits = (@key_size >= 1024) ? 768 : 512
            end
            public_key_template = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_PRIME, dh_params.get_p), CK_ATTRIBUTE.new(CKA_BASE, dh_params.get_g)])
            private_key_template = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_VALUE_BITS, private_bits), ])
          else
            if ((@algorithm == "EC"))
              key_type = CKK_EC
              encoded_params = P11ECKeyFactory.encode_parameters(@params)
              public_key_template = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_EC_PARAMS, encoded_params), ])
              # empty
              private_key_template = Array.typed(CK_ATTRIBUTE).new([])
            else
              raise ProviderException.new("Unknown algorithm: " + @algorithm)
            end
          end
        end
      end
      session = nil
      begin
        session = @token.get_obj_session
        public_key_template = @token.get_attributes(O_GENERATE, CKO_PUBLIC_KEY, key_type, public_key_template)
        private_key_template = @token.get_attributes(O_GENERATE, CKO_PRIVATE_KEY, key_type, private_key_template)
        key_ids = @token.attr_p11._c_generate_key_pair(session.id, CK_MECHANISM.new(@mechanism), public_key_template, private_key_template)
        public_key_ = P11Key.public_key(session, key_ids[0], @algorithm, @key_size, public_key_template)
        private_key_ = P11Key.private_key(session, key_ids[1], @algorithm, @key_size, private_key_template)
        return KeyPair.new(public_key_, private_key_)
      rescue PKCS11Exception => e
        raise ProviderException.new(e)
      ensure
        @token.release_session(session)
      end
    end
    
    private
    alias_method :initialize__p11key_pair_generator, :initialize
  end
  
end
