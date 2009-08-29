require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module RSACoreImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Rsa
      include_const ::Java::Math, :BigInteger
      include ::Java::Util
      include_const ::Java::Security, :SecureRandom
      include ::Java::Security::Interfaces
      include_const ::Javax::Crypto, :BadPaddingException
      include_const ::Sun::Security::Jca, :JCAUtil
    }
  end
  
  # Core of the RSA implementation. Has code to perform public and private key
  # RSA operations (with and without CRT for private key ops). Private CRT ops
  # also support blinding to twart timing attacks.
  # 
  # The code in this class only does the core RSA operation. Padding and
  # unpadding must be done externally.
  # 
  # Note: RSA keys should be at least 512 bits long
  # 
  # @since   1.5
  # @author  Andreas Sterbenz
  class RSACore 
    include_class_members RSACoreImports
    
    typesig { [] }
    def initialize
      # empty
    end
    
    class_module.module_eval {
      typesig { [BigInteger] }
      # Return the number of bytes required to store the magnitude byte[] of
      # this BigInteger. Do not count a 0x00 byte toByteArray() would
      # prefix for 2's complement form.
      def get_byte_length(b)
        n = b.bit_length
        return (n + 7) >> 3
      end
      
      typesig { [RSAKey] }
      # Return the number of bytes required to store the modulus of this
      # RSA key.
      def get_byte_length(key)
        return get_byte_length(key.get_modulus)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # temporary, used by RSACipher and RSAPadding. Move this somewhere else
      def convert(b, ofs, len)
        if (((ofs).equal?(0)) && ((len).equal?(b.attr_length)))
          return b
        else
          t = Array.typed(::Java::Byte).new(len) { 0 }
          System.arraycopy(b, ofs, t, 0, len)
          return t
        end
      end
      
      typesig { [Array.typed(::Java::Byte), RSAPublicKey] }
      # Perform an RSA public key operation.
      def rsa(msg, key)
        return crypt(msg, key.get_modulus, key.get_public_exponent)
      end
      
      typesig { [Array.typed(::Java::Byte), RSAPrivateKey] }
      # Perform an RSA private key operation. Uses CRT if the key is a
      # CRT key.
      def rsa(msg, key)
        if (key.is_a?(RSAPrivateCrtKey))
          return crt_crypt(msg, key)
        else
          return crypt(msg, key.get_modulus, key.get_private_exponent)
        end
      end
      
      typesig { [Array.typed(::Java::Byte), BigInteger, BigInteger] }
      # RSA public key ops and non-CRT private key ops. Simple modPow().
      def crypt(msg, n, exp)
        m = parse_msg(msg, n)
        c = m.mod_pow(exp, n)
        return to_byte_array(c, get_byte_length(n))
      end
      
      typesig { [Array.typed(::Java::Byte), RSAPrivateCrtKey] }
      # RSA private key operations with CRT. Algorithm and variable naming
      # are taken from PKCS#1 v2.1, section 5.1.2.
      # 
      # The only difference is the addition of blinding to twart timing attacks.
      # This is described in the RSA Bulletin#2 (Jan 96) among other places.
      # This means instead of implementing RSA as
      # m = c ^ d mod n (or RSA in CRT variant)
      # we do
      # r  = random(0, n-1)
      # c' = c  * r^e  mod n
      # m' = c' ^ d    mod n (or RSA in CRT variant)
      # m  = m' * r^-1 mod n (where r^-1 is the modular inverse of r mod n)
      # This works because r^(e*d) * r^-1 = r * r^-1 = 1 (all mod n)
      # 
      # We do not generate new blinding parameters for each operation but reuse
      # them BLINDING_MAX_REUSE times (see definition below).
      def crt_crypt(msg, key)
        n = key.get_modulus
        c = parse_msg(msg, n)
        p = key.get_prime_p
        q = key.get_prime_q
        d_p = key.get_prime_exponent_p
        d_q = key.get_prime_exponent_q
        q_inv = key.get_crt_coefficient
        params = nil
        if (ENABLE_BLINDING)
          params = get_blinding_parameters(key)
          c = c.multiply(params.attr_re).mod(n)
        else
          params = nil
        end
        # m1 = c ^ dP mod p
        m1 = c.mod_pow(d_p, p)
        # m2 = c ^ dQ mod q
        m2 = c.mod_pow(d_q, q)
        # h = (m1 - m2) * qInv mod p
        mtmp = m1.subtract(m2)
        if (mtmp.signum < 0)
          mtmp = mtmp.add(p)
        end
        h = mtmp.multiply(q_inv).mod(p)
        # m = m2 + q * h
        m = h.multiply(q).add(m2)
        if (!(params).nil?)
          m = m.multiply(params.attr_r_inv).mod(n)
        end
        return to_byte_array(m, get_byte_length(n))
      end
      
      typesig { [Array.typed(::Java::Byte), BigInteger] }
      # Parse the msg into a BigInteger and check against the modulus n.
      def parse_msg(msg, n)
        m = BigInteger.new(1, msg)
        if ((m <=> n) >= 0)
          raise BadPaddingException.new("Message is larger than modulus")
        end
        return m
      end
      
      typesig { [BigInteger, ::Java::Int] }
      # Return the encoding of this BigInteger that is exactly len bytes long.
      # Prefix/strip off leading 0x00 bytes if necessary.
      # Precondition: bi must fit into len bytes
      def to_byte_array(bi, len)
        b = bi.to_byte_array
        n = b.attr_length
        if ((n).equal?(len))
          return b
        end
        # BigInteger prefixed a 0x00 byte for 2's complement form, remove it
        if (((n).equal?(len + 1)) && ((b[0]).equal?(0)))
          t = Array.typed(::Java::Byte).new(len) { 0 }
          System.arraycopy(b, 1, t, 0, len)
          return t
        end
        # must be smaller
        raise AssertError if not ((n < len))
        t = Array.typed(::Java::Byte).new(len) { 0 }
        System.arraycopy(b, 0, t, (len - n), n)
        return t
      end
      
      # globally enable/disable use of blinding
      const_set_lazy(:ENABLE_BLINDING) { true }
      const_attr_reader  :ENABLE_BLINDING
      
      # maximum number of times that we will use a set of blinding parameters
      # value suggested by Paul Kocher (quoted by NSS)
      const_set_lazy(:BLINDING_MAX_REUSE) { 50 }
      const_attr_reader  :BLINDING_MAX_REUSE
      
      # cache for blinding parameters. Map<BigInteger,BlindingParameters>
      # use a weak hashmap so that cached values are automatically cleared
      # when the modulus is GC'ed
      const_set_lazy(:BlindingCache) { WeakHashMap.new }
      const_attr_reader  :BlindingCache
      
      # Set of blinding parameters for a given RSA key.
      # 
      # The RSA modulus is usually unique, so we index by modulus in
      # blindingCache. However, to protect against the unlikely case of two
      # keys sharing the same modulus, we also store the public exponent.
      # This means we cannot cache blinding parameters for multiple keys that
      # share the same modulus, but since sharing moduli is fundamentally broken
      # an insecure, this does not matter.
      const_set_lazy(:BlindingParameters) { Class.new do
        include_class_members RSACore
        
        # e (RSA public exponent)
        attr_accessor :e
        alias_method :attr_e, :e
        undef_method :e
        alias_method :attr_e=, :e=
        undef_method :e=
        
        # r ^ e mod n
        attr_accessor :re
        alias_method :attr_re, :re
        undef_method :re
        alias_method :attr_re=, :re=
        undef_method :re=
        
        # inverse of r mod n
        attr_accessor :r_inv
        alias_method :attr_r_inv, :r_inv
        undef_method :r_inv
        alias_method :attr_r_inv=, :r_inv=
        undef_method :r_inv=
        
        # how many more times this parameter object can be used
        attr_accessor :remaining_uses
        alias_method :attr_remaining_uses, :remaining_uses
        undef_method :remaining_uses
        alias_method :attr_remaining_uses=, :remaining_uses=
        undef_method :remaining_uses=
        
        typesig { [class_self::BigInteger, class_self::BigInteger, class_self::BigInteger] }
        def initialize(e, re, r_inv)
          @e = nil
          @re = nil
          @r_inv = nil
          @remaining_uses = 0
          @e = e
          @re = re
          @r_inv = r_inv
          # initialize remaining uses, subtract current use now
          @remaining_uses = BLINDING_MAX_REUSE - 1
        end
        
        typesig { [class_self::BigInteger] }
        def valid(e)
          k = ((@remaining_uses -= 1) + 1)
          return (k > 0) && (@e == e)
        end
        
        private
        alias_method :initialize__blinding_parameters, :initialize
      end }
      
      typesig { [RSAPrivateCrtKey] }
      # Return valid RSA blinding parameters for the given private key.
      # Use cached parameters if available. If not, generate new parameters
      # and cache.
      def get_blinding_parameters(key)
        modulus = key.get_modulus
        e = key.get_public_exponent
        params = nil
        # we release the lock between get() and put()
        # that means threads might concurrently generate new blinding
        # parameters for the same modulus. this is only a slight waste
        # of cycles and seems preferable in terms of scalability
        # to locking out all threads while generating new parameters
        synchronized((BlindingCache)) do
          params = BlindingCache.get(modulus)
        end
        if ((!(params).nil?) && params.valid(e))
          return params
        end
        len = modulus.bit_length
        random = JCAUtil.get_secure_random
        r = BigInteger.new(len, random).mod(modulus)
        re = r.mod_pow(e, modulus)
        r_inv = r.mod_inverse(modulus)
        params = BlindingParameters.new(e, re, r_inv)
        synchronized((BlindingCache)) do
          BlindingCache.put(modulus, params)
        end
        return params
      end
    }
    
    private
    alias_method :initialize__rsacore, :initialize
  end
  
end
