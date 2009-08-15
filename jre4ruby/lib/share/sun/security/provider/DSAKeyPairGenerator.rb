require "rjava"

# Copyright 1997-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Provider
  module DSAKeyPairGeneratorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include_const ::Java::Security, :SecureRandom
      include_const ::Java::Security::Interfaces, :DSAParams
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include_const ::Java::Security::Spec, :InvalidParameterSpecException
      include_const ::Java::Security::Spec, :DSAParameterSpec
      include_const ::Sun::Security::Jca, :JCAUtil
    }
  end
  
  # This class generates DSA key parameters and public/private key
  # pairs according to the DSS standard NIST FIPS 186. It uses the
  # updated version of SHA, SHA-1 as described in FIPS 180-1.
  # 
  # @author Benjamin Renaud
  # @author Andreas Sterbenz
  class DSAKeyPairGenerator < DSAKeyPairGeneratorImports.const_get :KeyPairGenerator
    include_class_members DSAKeyPairGeneratorImports
    overload_protected {
      include Java::Security::Interfaces::DSAKeyPairGenerator
    }
    
    # The modulus length
    attr_accessor :modlen
    alias_method :attr_modlen, :modlen
    undef_method :modlen
    alias_method :attr_modlen=, :modlen=
    undef_method :modlen=
    
    # whether to force new parameters to be generated for each KeyPair
    attr_accessor :force_new_parameters
    alias_method :attr_force_new_parameters, :force_new_parameters
    undef_method :force_new_parameters
    alias_method :attr_force_new_parameters=, :force_new_parameters=
    undef_method :force_new_parameters=
    
    # preset algorithm parameters.
    attr_accessor :params
    alias_method :attr_params, :params
    undef_method :params
    alias_method :attr_params=, :params=
    undef_method :params=
    
    # The source of random bits to use
    attr_accessor :random
    alias_method :attr_random, :random
    undef_method :random
    alias_method :attr_random=, :random=
    undef_method :random=
    
    typesig { [] }
    def initialize
      @modlen = 0
      @force_new_parameters = false
      @params = nil
      @random = nil
      super("DSA")
      initialize_(1024, nil)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      def check_strength(strength)
        if ((strength < 512) || (strength > 1024) || (!(strength % 64).equal?(0)))
          raise InvalidParameterException.new("Modulus size must range from 512 to 1024 " + "and be a multiple of 64")
        end
      end
    }
    
    typesig { [::Java::Int, SecureRandom] }
    def initialize_(modlen, random)
      check_strength(modlen)
      @random = random
      @modlen = modlen
      @params = nil
      @force_new_parameters = false
    end
    
    typesig { [::Java::Int, ::Java::Boolean, SecureRandom] }
    # Initializes the DSA key pair generator. If <code>genParams</code>
    # is false, a set of pre-computed parameters is used.
    def initialize_(modlen, gen_params, random)
      check_strength(modlen)
      if (gen_params)
        @params = nil
      else
        @params = ParameterCache.get_cached_dsaparameter_spec(modlen)
        if ((@params).nil?)
          raise InvalidParameterException.new("No precomputed parameters for requested modulus size " + "available")
        end
      end
      @modlen = modlen
      @random = random
      @force_new_parameters = gen_params
    end
    
    typesig { [DSAParams, SecureRandom] }
    # Initializes the DSA object using a DSA parameter object.
    # 
    # @param params a fully initialized DSA parameter object.
    def initialize_(params, random)
      if ((params).nil?)
        raise InvalidParameterException.new("Params must not be null")
      end
      spec = DSAParameterSpec.new(params.get_p, params.get_q, params.get_g)
      initialize0(spec, random)
    end
    
    typesig { [AlgorithmParameterSpec, SecureRandom] }
    # Initializes the DSA object using a parameter object.
    # 
    # @param params the parameter set to be used to generate
    # the keys.
    # @param random the source of randomness for this generator.
    # 
    # @exception InvalidAlgorithmParameterException if the given parameters
    # are inappropriate for this key pair generator
    def initialize_(params, random)
      if (!(params.is_a?(DSAParameterSpec)))
        raise InvalidAlgorithmParameterException.new("Inappropriate parameter")
      end
      initialize0(params, random)
    end
    
    typesig { [DSAParameterSpec, SecureRandom] }
    def initialize0(params, random)
      modlen = params.get_p.bit_length
      check_strength(modlen)
      @modlen = modlen
      @params = params
      @random = random
      @force_new_parameters = false
    end
    
    typesig { [] }
    # Generates a pair of keys usable by any JavaSecurity compliant
    # DSA implementation.
    def generate_key_pair
      if ((@random).nil?)
        @random = JCAUtil.get_secure_random
      end
      spec = nil
      begin
        if (@force_new_parameters)
          # generate new parameters each time
          spec = ParameterCache.get_new_dsaparameter_spec(@modlen, @random)
        else
          if ((@params).nil?)
            @params = ParameterCache.get_dsaparameter_spec(@modlen, @random)
          end
          spec = @params
        end
      rescue GeneralSecurityException => e
        raise ProviderException.new(e)
      end
      return generate_key_pair(spec.get_p, spec.get_q, spec.get_g, @random)
    end
    
    typesig { [BigInteger, BigInteger, BigInteger, SecureRandom] }
    def generate_key_pair(p, q, g, random)
      x = generate_x(random, q)
      y = generate_y(x, p, g)
      begin
        # See the comments in DSAKeyFactory, 4532506, and 6232513.
        pub = nil
        if (DSAKeyFactory::SERIAL_INTEROP)
          pub = DSAPublicKey.new(y, p, q, g)
        else
          pub = DSAPublicKeyImpl.new(y, p, q, g)
        end
        priv = DSAPrivateKey.new(x, p, q, g)
        pair = KeyPair.new(pub, priv)
        return pair
      rescue InvalidKeyException => e
        raise ProviderException.new(e)
      end
    end
    
    typesig { [SecureRandom, BigInteger] }
    # Generate the private key component of the key pair using the
    # provided source of random bits. This method uses the random but
    # source passed to generate a seed and then calls the seed-based
    # generateX method.
    def generate_x(random, q)
      x = nil
      while (true)
        seed = Array.typed(::Java::Int).new(5) { 0 }
        i = 0
        while i < 5
          seed[i] = random.next_int
          i += 1
        end
        x = generate_x(seed, q)
        if (x.signum > 0 && ((x <=> q) < 0))
          break
        end
      end
      return x
    end
    
    typesig { [Array.typed(::Java::Int), BigInteger] }
    # Given a seed, generate the private key component of the key
    # pair. In the terminology used in the DSA specification
    # (FIPS-186) seed is the XSEED quantity.
    # 
    # @param seed the seed to use to generate the private key.
    def generate_x(seed, q)
      # check out t in the spec.
      t = Array.typed(::Java::Int).new([0x67452301, -0x10325477, -0x67452302, 0x10325476, -0x3c2d1e10])
      tmp = DSA._sha_7(seed, t)
      tmp_bytes = Array.typed(::Java::Byte).new(tmp.attr_length * 4) { 0 }
      i = 0
      while i < tmp.attr_length
        k = tmp[i]
        j = 0
        while j < 4
          tmp_bytes[(i * 4) + j] = (k >> (24 - (j * 8)))
          j += 1
        end
        i += 1
      end
      x = BigInteger.new(1, tmp_bytes).mod(q)
      return x
    end
    
    typesig { [BigInteger, BigInteger, BigInteger] }
    # Generate the public key component y of the key pair.
    # 
    # @param x the private key component.
    # 
    # @param p the base parameter.
    def generate_y(x, p, g)
      y = g.mod_pow(x, p)
      return y
    end
    
    private
    alias_method :initialize__dsakey_pair_generator, :initialize
  end
  
end
