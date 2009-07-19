require "rjava"

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
module Sun::Security::Provider
  module DSAParameterGeneratorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Security, :AlgorithmParameterGeneratorSpi
      include_const ::Java::Security, :AlgorithmParameters
      include_const ::Java::Security, :InvalidAlgorithmParameterException
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security, :NoSuchProviderException
      include_const ::Java::Security, :InvalidParameterException
      include_const ::Java::Security, :SecureRandom
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include_const ::Java::Security::Spec, :InvalidParameterSpecException
      include_const ::Java::Security::Spec, :DSAParameterSpec
    }
  end
  
  # This class generates parameters for the DSA algorithm. It uses a default
  # prime modulus size of 1024 bits, which can be overwritten during
  # initialization.
  # 
  # @author Jan Luehe
  # 
  # 
  # @see java.security.AlgorithmParameters
  # @see java.security.spec.AlgorithmParameterSpec
  # @see DSAParameters
  # 
  # @since 1.2
  class DSAParameterGenerator < DSAParameterGeneratorImports.const_get :AlgorithmParameterGeneratorSpi
    include_class_members DSAParameterGeneratorImports
    
    # the modulus length
    attr_accessor :mod_len
    alias_method :attr_mod_len, :mod_len
    undef_method :mod_len
    alias_method :attr_mod_len=, :mod_len=
    undef_method :mod_len=
    
    # default
    # the source of randomness
    attr_accessor :random
    alias_method :attr_random, :random
    undef_method :random
    alias_method :attr_random=, :random=
    undef_method :random=
    
    class_module.module_eval {
      # useful constants
      const_set_lazy(:ZERO) { BigInteger.value_of(0) }
      const_attr_reader  :ZERO
      
      const_set_lazy(:ONE) { BigInteger.value_of(1) }
      const_attr_reader  :ONE
      
      const_set_lazy(:TWO) { BigInteger.value_of(2) }
      const_attr_reader  :TWO
    }
    
    # Make a SHA-1 hash function
    attr_accessor :sha
    alias_method :attr_sha, :sha
    undef_method :sha
    alias_method :attr_sha=, :sha=
    undef_method :sha=
    
    typesig { [] }
    def initialize
      @mod_len = 0
      @random = nil
      @sha = nil
      super()
      @mod_len = 1024
      @sha = SHA.new
    end
    
    typesig { [::Java::Int, SecureRandom] }
    # Initializes this parameter generator for a certain strength
    # and source of randomness.
    # 
    # @param strength the strength (size of prime) in bits
    # @param random the source of randomness
    def engine_init(strength, random)
      # Bruce Schneier, "Applied Cryptography", 2nd Edition,
      # Description of DSA:
      # [...] The algorithm uses the following parameter:
      # p=a prime number L bits long, when L ranges from 512 to 1024 and is
      # a multiple of 64. [...]
      if ((strength < 512) || (strength > 1024) || (!(strength % 64).equal?(0)))
        raise InvalidParameterException.new("Prime size must range from 512 to 1024 " + "and be a multiple of 64")
      end
      @mod_len = strength
      @random = random
    end
    
    typesig { [AlgorithmParameterSpec, SecureRandom] }
    # Initializes this parameter generator with a set of
    # algorithm-specific parameter generation values.
    # 
    # @param params the set of algorithm-specific parameter generation values
    # @param random the source of randomness
    # 
    # @exception InvalidAlgorithmParameterException if the given parameter
    # generation values are inappropriate for this parameter generator
    def engine_init(gen_param_spec, random)
      raise InvalidAlgorithmParameterException.new("Invalid parameter")
    end
    
    typesig { [] }
    # Generates the parameters.
    # 
    # @return the new AlgorithmParameters object
    def engine_generate_parameters
      alg_params = nil
      begin
        if ((@random).nil?)
          @random = SecureRandom.new
        end
        p_and_q = generate_pand_q(@random, @mod_len)
        param_p = p_and_q[0]
        param_q = p_and_q[1]
        param_g = generate_g(param_p, param_q)
        dsa_param_spec = DSAParameterSpec.new(param_p, param_q, param_g)
        alg_params = AlgorithmParameters.get_instance("DSA", "SUN")
        alg_params.init(dsa_param_spec)
      rescue InvalidParameterSpecException => e
        # this should never happen
        raise RuntimeException.new(e.get_message)
      rescue NoSuchAlgorithmException => e
        # this should never happen, because we provide it
        raise RuntimeException.new(e.get_message)
      rescue NoSuchProviderException => e
        # this should never happen, because we provide it
        raise RuntimeException.new(e.get_message)
      end
      return alg_params
    end
    
    typesig { [SecureRandom, ::Java::Int] }
    # Generates the prime and subprime parameters for DSA,
    # using the provided source of randomness.
    # This method will generate new seeds until a suitable
    # seed has been found.
    # 
    # @param random the source of randomness to generate the
    # seed
    # @param L the size of <code>p</code>, in bits.
    # 
    # @return an array of BigInteger, with <code>p</code> at index 0 and
    # <code>q</code> at index 1.
    def generate_pand_q(random, l)
      result = nil
      seed = Array.typed(::Java::Byte).new(20) { 0 }
      while ((result).nil?)
        i = 0
        while i < 20
          seed[i] = random.next_int
          ((i += 1) - 1)
        end
        result = generate_pand_q(seed, l)
      end
      return result
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Generates the prime and subprime parameters for DSA.
    # 
    # <p>The seed parameter corresponds to the <code>SEED</code> parameter
    # referenced in the FIPS specification of the DSA algorithm,
    # and L is the size of <code>p</code>, in bits.
    # 
    # @param seed the seed to generate the parameters
    # @param L the size of <code>p</code>, in bits.
    # 
    # @return an array of BigInteger, with <code>p</code> at index 0,
    # <code>q</code> at index 1, the seed at index 2, and the counter value
    # at index 3, or null if the seed does not yield suitable numbers.
    def generate_pand_q(seed, l)
      # Useful variables
      g = seed.attr_length * 8
      n = (l - 1) / 160
      b = (l - 1) % 160
      seed_ = BigInteger.new(1, seed)
      twog = TWO.pow(2 * g)
      # Step 2 (Step 1 is getting seed).
      u1 = _sha(seed)
      u2 = _sha(to_byte_array((seed_.add(ONE)).mod(twog)))
      xor(u1, u2)
      u = u1
      # Step 3: For q by setting the msb and lsb to 1
      u[0] |= 0x80
      u[19] |= 1
      q = BigInteger.new(1, u)
      # Step 5
      if (!q.is_probable_prime(80))
        return nil
      else
        v = Array.typed(BigInteger).new(n + 1) { nil }
        offset = TWO
        # Step 6
        counter = 0
        while counter < 4096
          # Step 7
          k = 0
          while k <= n
            k_ = BigInteger.value_of(k)
            tmp = (seed_.add(offset).add(k_)).mod(twog)
            v[k] = BigInteger.new(1, _sha(to_byte_array(tmp)))
            ((k += 1) - 1)
          end
          # Step 8
          w = v[0]
          i = 1
          while i < n
            w = w.add(v[i].multiply(TWO.pow(i * 160)))
            ((i += 1) - 1)
          end
          w = w.add((v[n].mod(TWO.pow(b))).multiply(TWO.pow(n * 160)))
          twolm1 = TWO.pow(l - 1)
          x = w.add(twolm1)
          # Step 9
          c = x.mod(q.multiply(TWO))
          p = x.subtract(c.subtract(ONE))
          # Step 10 - 13
          if ((p <=> twolm1) > -1 && p.is_probable_prime(80))
            result = Array.typed(BigInteger).new([p, q, seed_, BigInteger.value_of(counter)])
            return result
          end
          offset = offset.add(BigInteger.value_of(n)).add(ONE)
          ((counter += 1) - 1)
        end
        return nil
      end
    end
    
    typesig { [BigInteger, BigInteger] }
    # Generates the <code>g</code> parameter for DSA.
    # 
    # @param p the prime, <code>p</code>.
    # @param q the subprime, <code>q</code>.
    # 
    # @param the <code>g</code>
    def generate_g(p, q)
      h = ONE
      p_minus_one_over_q = (p.subtract(ONE)).divide(q)
      g = ONE
      while ((g <=> TWO) < 0)
        g = h.mod_pow(p_minus_one_over_q, p)
        h = h.add(ONE)
      end
      return g
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Returns the SHA-1 digest of some data
    def _sha(array)
      @sha.engine_reset
      @sha.engine_update(array, 0, array.attr_length)
      return @sha.engine_digest
    end
    
    typesig { [BigInteger] }
    # Converts the result of a BigInteger.toByteArray call to an exact
    # signed magnitude representation for any positive number.
    def to_byte_array(big_int)
      result = big_int.to_byte_array
      if ((result[0]).equal?(0))
        tmp = Array.typed(::Java::Byte).new(result.attr_length - 1) { 0 }
        System.arraycopy(result, 1, tmp, 0, tmp.attr_length)
        result = tmp
      end
      return result
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # XORs U2 into U1
    def xor(u1, u2)
      i = 0
      while i < u1.attr_length
        u1[i] ^= u2[i]
        ((i += 1) - 1)
      end
    end
    
    private
    alias_method :initialize__dsaparameter_generator, :initialize
  end
  
end
