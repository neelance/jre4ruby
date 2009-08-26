require "rjava"

# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SHA5Imports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include ::Java::Security
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # This class implements the Secure Hash Algorithm SHA-384 and SHA-512
  # developed by the National Institute of Standards and Technology along
  # with the National Security Agency.
  # 
  # The two algorithms are almost identical. This file contains a base
  # class SHA5 and two nested static subclasses as the classes to be used
  # by the JCA framework.
  # 
  # <p>It implements java.security.MessageDigestSpi, and can be used
  # through Java Cryptography Architecture (JCA), as a pluggable
  # MessageDigest implementation.
  # 
  # @since       1.4.2
  # @author      Valerie Peng
  # @author      Andreas Sterbenz
  class SHA5 < SHA5Imports.const_get :DigestBase
    include_class_members SHA5Imports
    
    class_module.module_eval {
      const_set_lazy(:ITERATION) { 80 }
      const_attr_reader  :ITERATION
      
      # Constants for each round/iteration
      const_set_lazy(:ROUND_CONSTS) { Array.typed(::Java::Long).new([0x428a2f98d728ae22, 0x7137449123ef65cd, -0x4a3f043013b2c4d1, -0x164a245a7e762444, 0x3956c25bf348b538, 0x59f111f1b605d019, -0x6dc07d5b50e6b065, -0x54e3a12a25927ee8, -0x27f855675cfcfdbe, 0x12835b0145706fbe, 0x243185be4ee4b28c, 0x550c7dc3d5ffb4e2, 0x72be5d74f27b896f, -0x7f214e01c4e9694f, -0x6423f958da38edcb, -0x3e640e8b3096d96c, -0x1b64963e610eb52e, -0x1041b879c7b0da1d, 0xfc19dc68b8cd5b5, 0x240ca1cc77ac9c65, 0x2de92c6f592b0275, 0x4a7484aa6ea6e483, 0x5cb0a9dcbd41fbd4, 0x76f988da831153b5, -0x67c1aead11992055, -0x57ce3992d24bcdf0, -0x4ffcd8376704dec1, -0x40a680384110f11c, -0x391ff40cc257703e, -0x2a586eb86cf558db, 0x6ca6351e003826f, 0x142929670a0e6e70, 0x27b70a8546d22ffc, 0x2e1b21385c26c926, 0x4d2c6dfc5ac42aed, 0x53380d139d95b3df, 0x650a73548baf63de, 0x766a0abb3c77b2a8, -0x7e3d36d1b812511a, -0x6d8dd37aeb7dcac5, -0x5d40175eb30efc9c, -0x57e599b443bdcfff, -0x3db4748f2f07686f, -0x3893ae5cf9ab41d0, -0x2e6d17e62910ade8, -0x2966f9dbaa9a56f0, -0xbf1ca7aa88edfd6, 0x106aa07032bbd1b8, 0x19a4c116b8d2d0c8, 0x1e376c085141ab53, 0x2748774cdf8eeb99, 0x34b0bcb5e19b48a8, 0x391c0cb3c5c95a63, 0x4ed8aa4ae3418acb, 0x5b9cca4f7763e373, 0x682e6ff3d6b2b8a3, 0x748f82ee5defb2fc, 0x78a5636f43172f60, -0x7b3787eb5e0f548e, -0x7338fdf7e59bc614, -0x6f410005dc9ce1d8, -0x5baf9314217d4217, -0x41065c084d3986eb, -0x398e870d1c8dacd5, -0x35d8c13115d99e64, -0x2e794738de3f3df9, -0x15258229321f14e2, -0xa82b08011912e88, 0x6f067aa72176fba, 0xa637dc5a2c898a6, 0x113f9804bef90dae, 0x1b710b35131c471b, 0x28db77f523047d84, 0x32caab7b40c72493, 0x3c9ebe0a15c9bebc, 0x431d67c49c100d4c, 0x4cc5d4becb3e42b6, 0x597f299cfc657e2a, 0x5fcb6fab3ad6faec, 0x6c44198c4a475817]) }
      const_attr_reader  :ROUND_CONSTS
    }
    
    # buffer used by implCompress()
    attr_accessor :w
    alias_method :attr_w, :w
    undef_method :w
    alias_method :attr_w=, :w=
    undef_method :w=
    
    # state of this object
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    # initial state value. different between SHA-384 and SHA-512
    attr_accessor :initial_hashes
    alias_method :attr_initial_hashes, :initial_hashes
    undef_method :initial_hashes
    alias_method :attr_initial_hashes=, :initial_hashes=
    undef_method :initial_hashes=
    
    typesig { [String, ::Java::Int, Array.typed(::Java::Long)] }
    # Creates a new SHA object.
    def initialize(name, digest_length, initial_hashes)
      @w = nil
      @state = nil
      @initial_hashes = nil
      super(name, digest_length, 128)
      @initial_hashes = initial_hashes
      @state = Array.typed(::Java::Long).new(8) { 0 }
      @w = Array.typed(::Java::Long).new(80) { 0 }
      impl_reset
    end
    
    typesig { [SHA5] }
    # Creates a SHA object with state (for cloning)
    def initialize(base)
      @w = nil
      @state = nil
      @initial_hashes = nil
      super(base)
      @initial_hashes = base.attr_initial_hashes
      @state = base.attr_state.clone
      @w = Array.typed(::Java::Long).new(80) { 0 }
    end
    
    typesig { [] }
    def impl_reset
      System.arraycopy(@initial_hashes, 0, @state, 0, @state.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    def impl_digest(out, ofs)
      bits_processed = self.attr_bytes_processed << 3
      index = RJava.cast_to_int(self.attr_bytes_processed) & 0x7f
      pad_len = (index < 112) ? (112 - index) : (240 - index)
      engine_update(self.attr_padding, 0, pad_len + 8)
      i2b_big4(RJava.cast_to_int((bits_processed >> 32)), self.attr_buffer, 120)
      i2b_big4(RJava.cast_to_int(bits_processed), self.attr_buffer, 124)
      impl_compress(self.attr_buffer, 0)
      l2b_big(@state, 0, out, ofs, engine_get_digest_length)
    end
    
    class_module.module_eval {
      typesig { [::Java::Long, ::Java::Long, ::Java::Long] }
      # logical function ch(x,y,z) as defined in spec:
      # @return (x and y) xor ((complement x) and z)
      # @param x long
      # @param y long
      # @param z long
      def lf_ch(x, y, z)
        return (x & y) ^ ((~x) & z)
      end
      
      typesig { [::Java::Long, ::Java::Long, ::Java::Long] }
      # logical function maj(x,y,z) as defined in spec:
      # @return (x and y) xor (x and z) xor (y and z)
      # @param x long
      # @param y long
      # @param z long
      def lf_maj(x, y, z)
        return (x & y) ^ (x & z) ^ (y & z)
      end
      
      typesig { [::Java::Long, ::Java::Int] }
      # logical function R(x,s) - right shift
      # @return x right shift for s times
      # @param x long
      # @param s int
      def lf__r(x, s)
        return (x >> s)
      end
      
      typesig { [::Java::Long, ::Java::Int] }
      # logical function S(x,s) - right rotation
      # @return x circular right shift for s times
      # @param x long
      # @param s int
      def lf__s(x, s)
        return (x >> s) | (x << (64 - s))
      end
      
      typesig { [::Java::Long] }
      # logical function sigma0(x) - xor of results of right rotations
      # @return S(x,28) xor S(x,34) xor S(x,39)
      # @param x long
      def lf_sigma0(x)
        return lf__s(x, 28) ^ lf__s(x, 34) ^ lf__s(x, 39)
      end
      
      typesig { [::Java::Long] }
      # logical function sigma1(x) - xor of results of right rotations
      # @return S(x,14) xor S(x,18) xor S(x,41)
      # @param x long
      def lf_sigma1(x)
        return lf__s(x, 14) ^ lf__s(x, 18) ^ lf__s(x, 41)
      end
      
      typesig { [::Java::Long] }
      # logical function delta0(x) - xor of results of right shifts/rotations
      # @return long
      # @param x long
      def lf_delta0(x)
        return lf__s(x, 1) ^ lf__s(x, 8) ^ lf__r(x, 7)
      end
      
      typesig { [::Java::Long] }
      # logical function delta1(x) - xor of results of right shifts/rotations
      # @return long
      # @param x long
      def lf_delta1(x)
        return lf__s(x, 19) ^ lf__s(x, 61) ^ lf__r(x, 6)
      end
    }
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Compute the hash for the current block.
    # 
    # This is in the same vein as Peter Gutmann's algorithm listed in
    # the back of Applied Cryptography, Compact implementation of
    # "old" NIST Secure Hash Algorithm.
    def impl_compress(buf, ofs)
      b2l_big128(buf, ofs, @w)
      # The first 16 longs are from the byte stream, compute the rest of
      # the W[]'s
      t = 16
      while t < ITERATION
        @w[t] = lf_delta1(@w[t - 2]) + @w[t - 7] + lf_delta0(@w[t - 15]) + @w[t - 16]
        t += 1
      end
      a = @state[0]
      b = @state[1]
      c = @state[2]
      d = @state[3]
      e = @state[4]
      f = @state[5]
      g = @state[6]
      h = @state[7]
      i = 0
      while i < ITERATION
        t1 = h + lf_sigma1(e) + lf_ch(e, f, g) + ROUND_CONSTS[i] + @w[i]
        t2 = lf_sigma0(a) + lf_maj(a, b, c)
        h = g
        g = f
        f = e
        e = d + t1
        d = c
        c = b
        b = a
        a = t1 + t2
        i += 1
      end
      @state[0] += a
      @state[1] += b
      @state[2] += c
      @state[3] += d
      @state[4] += e
      @state[5] += f
      @state[6] += g
      @state[7] += h
    end
    
    class_module.module_eval {
      # SHA-512 implementation class.
      const_set_lazy(:SHA512) { Class.new(SHA5) do
        include_class_members SHA5
        
        class_module.module_eval {
          const_set_lazy(:INITIAL_HASHES) { Array.typed(::Java::Long).new([0x6a09e667f3bcc908, -0x4498517a7b3558c5, 0x3c6ef372fe94f82b, -0x5ab00ac5a0e2c90f, 0x510e527fade682d1, -0x64fa9773d4c193e1, 0x1f83d9abfb41bd6b, 0x5be0cd19137e2179]) }
          const_attr_reader  :INITIAL_HASHES
        }
        
        typesig { [] }
        def initialize
          super("SHA-512", 64, self.class::INITIAL_HASHES)
        end
        
        typesig { [class_self::SHA512] }
        def initialize(base)
          super(base)
        end
        
        typesig { [] }
        def clone
          return self.class::SHA512.new(self)
        end
        
        private
        alias_method :initialize__sha512, :initialize
      end }
      
      # SHA-384 implementation class.
      const_set_lazy(:SHA384) { Class.new(SHA5) do
        include_class_members SHA5
        
        class_module.module_eval {
          const_set_lazy(:INITIAL_HASHES) { Array.typed(::Java::Long).new([-0x344462a23efa6128, 0x629a292a367cd507, -0x6ea6fea5cf8f22e9, 0x152fecd8f70e5939, 0x67332667ffc00b31, -0x714bb57897a7eaef, -0x24f3d1f29b067059, 0x47b5481dbefa4fa4]) }
          const_attr_reader  :INITIAL_HASHES
        }
        
        typesig { [] }
        def initialize
          super("SHA-384", 48, self.class::INITIAL_HASHES)
        end
        
        typesig { [class_self::SHA384] }
        def initialize(base)
          super(base)
        end
        
        typesig { [] }
        def clone
          return self.class::SHA384.new(self)
        end
        
        private
        alias_method :initialize__sha384, :initialize
      end }
    }
    
    private
    alias_method :initialize__sha5, :initialize
  end
  
end
