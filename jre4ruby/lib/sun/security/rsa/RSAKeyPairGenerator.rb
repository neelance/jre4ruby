require "rjava"

# 
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
module Sun::Security::Rsa
  module RSAKeyPairGeneratorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Rsa
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include_const ::Java::Security::Spec, :RSAKeyGenParameterSpec
      include_const ::Sun::Security::Jca, :JCAUtil
    }
  end
  
  # 
  # RSA keypair generation. Standard algorithm, minimum key length 512 bit.
  # We generate two random primes until we find two where phi is relative
  # prime to the public exponent. Default exponent is 65537. It has only bit 0
  # and bit 4 set, which makes it particularly efficient.
  # 
  # @since   1.5
  # @author  Andreas Sterbenz
  class RSAKeyPairGenerator < RSAKeyPairGeneratorImports.const_get :KeyPairGeneratorSpi
    include_class_members RSAKeyPairGeneratorImports
    
    # public exponent to use
    attr_accessor :public_exponent
    alias_method :attr_public_exponent, :public_exponent
    undef_method :public_exponent
    alias_method :attr_public_exponent=, :public_exponent=
    undef_method :public_exponent=
    
    # size of the key to generate, >= RSAKeyFactory.MIN_MODLEN
    attr_accessor :key_size
    alias_method :attr_key_size, :key_size
    undef_method :key_size
    alias_method :attr_key_size=, :key_size=
    undef_method :key_size=
    
    # PRNG to use
    attr_accessor :random
    alias_method :attr_random, :random
    undef_method :random
    alias_method :attr_random=, :random=
    undef_method :random=
    
    typesig { [] }
    def initialize
      @public_exponent = nil
      @key_size = 0
      @random = nil
      super()
      # initialize to default in case the app does not call initialize()
      initialize_(1024, nil)
    end
    
    typesig { [::Java::Int, SecureRandom] }
    # initialize the generator. See JCA doc
    def initialize_(key_size, random)
      # do not allow unreasonably small or large key sizes,
      # probably user error
      begin
        RSAKeyFactory.check_key_lengths(key_size, RSAKeyGenParameterSpec::F4, 512, 64 * 1024)
      rescue InvalidKeyException => e
        raise InvalidParameterException.new(e.get_message)
      end
      @key_size = key_size
      @random = random
      @public_exponent = RSAKeyGenParameterSpec::F4
    end
    
    typesig { [AlgorithmParameterSpec, SecureRandom] }
    # second initialize method. See JCA doc.
    def initialize_(params, random)
      if ((params.is_a?(RSAKeyGenParameterSpec)).equal?(false))
        raise InvalidAlgorithmParameterException.new("Params must be instance of RSAKeyGenParameterSpec")
      end
      rsa_spec = params
      tmp_key_size = rsa_spec.get_keysize
      tmp_public_exponent = rsa_spec.get_public_exponent
      if ((tmp_public_exponent).nil?)
        tmp_public_exponent = RSAKeyGenParameterSpec::F4
      else
        if ((tmp_public_exponent <=> RSAKeyGenParameterSpec::F0) < 0)
          raise InvalidAlgorithmParameterException.new("Public exponent must be 3 or larger")
        end
        if (tmp_public_exponent.bit_length > tmp_key_size)
          raise InvalidAlgorithmParameterException.new("Public exponent must be smaller than key size")
        end
      end
      # do not allow unreasonably large key sizes, probably user error
      begin
        RSAKeyFactory.check_key_lengths(tmp_key_size, tmp_public_exponent, 512, 64 * 1024)
      rescue InvalidKeyException => e
        raise InvalidAlgorithmParameterException.new("Invalid key sizes", e)
      end
      @key_size = tmp_key_size
      @public_exponent = tmp_public_exponent
      @random = random
    end
    
    typesig { [] }
    # generate the keypair. See JCA doc
    def generate_key_pair
      # accomodate odd key sizes in case anybody wants to use them
      lp = (@key_size + 1) >> 1
      lq = @key_size - lp
      if ((@random).nil?)
        @random = JCAUtil.get_secure_random
      end
      e = @public_exponent
      while (true)
        # generate two random primes of size lp/lq
        p = BigInteger.probable_prime(lp, @random)
        q = nil
        n = nil
        begin
          q = BigInteger.probable_prime(lq, @random)
          # convention is for p > q
          if ((p <=> q) < 0)
            tmp = p
            p = q
            q = tmp
          end
          # modulus n = p * q
          n = p.multiply(q)
        end while (n.bit_length < @key_size)
        # phi = (p - 1) * (q - 1) must be relative prime to e
        # otherwise RSA just won't work ;-)
        p1 = p.subtract(BigInteger::ONE)
        q1 = q.subtract(BigInteger::ONE)
        phi = p1.multiply(q1)
        # generate new p and q until they work. typically
        # the first try will succeed when using F4
        if (((e.gcd(phi) == BigInteger::ONE)).equal?(false))
          next
        end
        # private exponent d is the inverse of e mod phi
        d = e.mod_inverse(phi)
        # 1st prime exponent pe = d mod (p - 1)
        pe = d.mod(p1)
        # 2nd prime exponent qe = d mod (q - 1)
        qe = d.mod(q1)
        # crt coefficient coeff is the inverse of q mod p
        coeff = q.mod_inverse(p)
        begin
          public_key = RSAPublicKeyImpl.new(n, e)
          private_key = RSAPrivateCrtKeyImpl.new(n, e, d, p, q, pe, qe, coeff)
          return KeyPair.new(public_key, private_key)
        rescue InvalidKeyException => exc
          # invalid key exception only thrown for keys < 512 bit,
          # will not happen here
          raise RuntimeException.new(exc)
        end
      end
    end
    
    private
    alias_method :initialize__rsakey_pair_generator, :initialize
  end
  
end
