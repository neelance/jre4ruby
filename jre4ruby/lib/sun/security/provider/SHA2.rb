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
  module SHA2Imports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
    }
  end
  
  # This class implements the Secure Hash Algorithm SHA-256 developed by
  # the National Institute of Standards and Technology along with the
  # National Security Agency.
  # 
  # <p>It implements java.security.MessageDigestSpi, and can be used
  # through Java Cryptography Architecture (JCA), as a pluggable
  # MessageDigest implementation.
  # 
  # @since       1.4.2
  # @author      Valerie Peng
  # @author      Andreas Sterbenz
  class SHA2 < SHA2Imports.const_get :DigestBase
    include_class_members SHA2Imports
    
    class_module.module_eval {
      const_set_lazy(:ITERATION) { 64 }
      const_attr_reader  :ITERATION
      
      # Constants for each round
      const_set_lazy(:ROUND_CONSTS) { Array.typed(::Java::Int).new([0x428a2f98, 0x71374491, -0x4a3f0431, -0x164a245b, 0x3956c25b, 0x59f111f1, -0x6dc07d5c, -0x54e3a12b, -0x27f85568, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, -0x7f214e02, -0x6423f959, -0x3e640e8c, -0x1b64963f, -0x1041b87a, 0xfc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, -0x67c1aeae, -0x57ce3993, -0x4ffcd838, -0x40a68039, -0x391ff40d, -0x2a586eb9, 0x6ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, -0x7e3d36d2, -0x6d8dd37b, -0x5d40175f, -0x57e599b5, -0x3db47490, -0x3893ae5d, -0x2e6d17e7, -0x2966f9dc, -0xbf1ca7b, 0x106aa070, 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, -0x7b3787ec, -0x7338fdf8, -0x6f410006, -0x5baf9315, -0x41065c09, -0x398e870e]) }
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
    
    typesig { [] }
    # Creates a new SHA object.
    def initialize
      @w = nil
      @state = nil
      super("SHA-256", 32, 64)
      @state = Array.typed(::Java::Int).new(8) { 0 }
      @w = Array.typed(::Java::Int).new(64) { 0 }
      impl_reset
    end
    
    typesig { [SHA2] }
    # Creates a SHA2 object.with state (for cloning)
    def initialize(base)
      @w = nil
      @state = nil
      super(base)
      @state = base.attr_state.clone
      @w = Array.typed(::Java::Int).new(64) { 0 }
    end
    
    typesig { [] }
    def clone
      return SHA2.new(self)
    end
    
    typesig { [] }
    # Resets the buffers and hash value to start a new hash.
    def impl_reset
      @state[0] = 0x6a09e667
      @state[1] = -0x4498517b
      @state[2] = 0x3c6ef372
      @state[3] = -0x5ab00ac6
      @state[4] = 0x510e527f
      @state[5] = -0x64fa9774
      @state[6] = 0x1f83d9ab
      @state[7] = 0x5be0cd19
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    def impl_digest(out, ofs)
      bits_processed = self.attr_bytes_processed << 3
      index = RJava.cast_to_int(self.attr_bytes_processed) & 0x3f
      pad_len = (index < 56) ? (56 - index) : (120 - index)
      engine_update(self.attr_padding, 0, pad_len)
      i2b_big4(RJava.cast_to_int((bits_processed >> 32)), self.attr_buffer, 56)
      i2b_big4(RJava.cast_to_int(bits_processed), self.attr_buffer, 60)
      impl_compress(self.attr_buffer, 0)
      i2b_big(@state, 0, out, ofs, 32)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
      # logical function ch(x,y,z) as defined in spec:
      # @return (x and y) xor ((complement x) and z)
      # @param x int
      # @param y int
      # @param z int
      def lf_ch(x, y, z)
        return (x & y) ^ ((~x) & z)
      end
      
      typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
      # logical function maj(x,y,z) as defined in spec:
      # @return (x and y) xor (x and z) xor (y and z)
      # @param x int
      # @param y int
      # @param z int
      def lf_maj(x, y, z)
        return (x & y) ^ (x & z) ^ (y & z)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # logical function R(x,s) - right shift
      # @return x right shift for s times
      # @param x int
      # @param s int
      def lf__r(x, s)
        return (x >> s)
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # logical function S(x,s) - right rotation
      # @return x circular right shift for s times
      # @param x int
      # @param s int
      def lf__s(x, s)
        return (x >> s) | (x << (32 - s))
      end
      
      typesig { [::Java::Int] }
      # logical function sigma0(x) - xor of results of right rotations
      # @return S(x,2) xor S(x,13) xor S(x,22)
      # @param x int
      def lf_sigma0(x)
        return lf__s(x, 2) ^ lf__s(x, 13) ^ lf__s(x, 22)
      end
      
      typesig { [::Java::Int] }
      # logical function sigma1(x) - xor of results of right rotations
      # @return S(x,6) xor S(x,11) xor S(x,25)
      # @param x int
      def lf_sigma1(x)
        return lf__s(x, 6) ^ lf__s(x, 11) ^ lf__s(x, 25)
      end
      
      typesig { [::Java::Int] }
      # logical function delta0(x) - xor of results of right shifts/rotations
      # @return int
      # @param x int
      def lf_delta0(x)
        return lf__s(x, 7) ^ lf__s(x, 18) ^ lf__r(x, 3)
      end
      
      typesig { [::Java::Int] }
      # logical function delta1(x) - xor of results of right shifts/rotations
      # @return int
      # @param x int
      def lf_delta1(x)
        return lf__s(x, 17) ^ lf__s(x, 19) ^ lf__r(x, 10)
      end
    }
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Process the current block to update the state variable state.
    def impl_compress(buf, ofs)
      b2i_big64(buf, ofs, @w)
      # The first 16 ints are from the byte stream, compute the rest of
      # the W[]'s
      t = 16
      while t < ITERATION
        @w[t] = lf_delta1(@w[t - 2]) + @w[t - 7] + lf_delta0(@w[t - 15]) + @w[t - 16]
        ((t += 1) - 1)
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
        ((i += 1) - 1)
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
    
    private
    alias_method :initialize__sha2, :initialize
  end
  
end
