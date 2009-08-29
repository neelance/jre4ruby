require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module MD5Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
    }
  end
  
  # The MD5 class is used to compute an MD5 message digest over a given
  # buffer of bytes. It is an implementation of the RSA Data Security Inc
  # MD5 algorithim as described in internet RFC 1321.
  # 
  # @author      Chuck McManis
  # @author      Benjamin Renaud
  # @author      Andreas Sterbenz
  class MD5 < MD5Imports.const_get :DigestBase
    include_class_members MD5Imports
    
    # state of this object
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    # temporary buffer, used by implCompress()
    attr_accessor :x
    alias_method :attr_x, :x
    undef_method :x
    alias_method :attr_x=, :x=
    undef_method :x=
    
    class_module.module_eval {
      # rotation constants
      const_set_lazy(:S11) { 7 }
      const_attr_reader  :S11
      
      const_set_lazy(:S12) { 12 }
      const_attr_reader  :S12
      
      const_set_lazy(:S13) { 17 }
      const_attr_reader  :S13
      
      const_set_lazy(:S14) { 22 }
      const_attr_reader  :S14
      
      const_set_lazy(:S21) { 5 }
      const_attr_reader  :S21
      
      const_set_lazy(:S22) { 9 }
      const_attr_reader  :S22
      
      const_set_lazy(:S23) { 14 }
      const_attr_reader  :S23
      
      const_set_lazy(:S24) { 20 }
      const_attr_reader  :S24
      
      const_set_lazy(:S31) { 4 }
      const_attr_reader  :S31
      
      const_set_lazy(:S32) { 11 }
      const_attr_reader  :S32
      
      const_set_lazy(:S33) { 16 }
      const_attr_reader  :S33
      
      const_set_lazy(:S34) { 23 }
      const_attr_reader  :S34
      
      const_set_lazy(:S41) { 6 }
      const_attr_reader  :S41
      
      const_set_lazy(:S42) { 10 }
      const_attr_reader  :S42
      
      const_set_lazy(:S43) { 15 }
      const_attr_reader  :S43
      
      const_set_lazy(:S44) { 21 }
      const_attr_reader  :S44
    }
    
    typesig { [] }
    # Standard constructor, creates a new MD5 instance.
    def initialize
      @state = nil
      @x = nil
      super("MD5", 16, 64)
      @state = Array.typed(::Java::Int).new(4) { 0 }
      @x = Array.typed(::Java::Int).new(16) { 0 }
      impl_reset
    end
    
    typesig { [MD5] }
    # Cloning constructor
    def initialize(base)
      @state = nil
      @x = nil
      super(base)
      @state = base.attr_state.clone
      @x = Array.typed(::Java::Int).new(16) { 0 }
    end
    
    typesig { [] }
    # clone this object
    def clone
      return MD5.new(self)
    end
    
    typesig { [] }
    # Reset the state of this object.
    def impl_reset
      # Load magic initialization constants.
      @state[0] = 0x67452301
      @state[1] = -0x10325477
      @state[2] = -0x67452302
      @state[3] = 0x10325476
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Perform the final computations, any buffered bytes are added
    # to the digest, the count is added to the digest, and the resulting
    # digest is stored.
    def impl_digest(out, ofs)
      bits_processed = self.attr_bytes_processed << 3
      index = RJava.cast_to_int(self.attr_bytes_processed) & 0x3f
      pad_len = (index < 56) ? (56 - index) : (120 - index)
      engine_update(self.attr_padding, 0, pad_len)
      i2b_little4(RJava.cast_to_int(bits_processed), self.attr_buffer, 56)
      i2b_little4(RJava.cast_to_int((bits_processed >> 32)), self.attr_buffer, 60)
      impl_compress(self.attr_buffer, 0)
      i2b_little(@state, 0, out, ofs, 16)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
      # **********************************************************
      # The MD5 Functions. The results of this
      # implementation were checked against the RSADSI version.
      # **********************************************************
      def _ff(a, b, c, d, x, s, ac)
        a += ((b & c) | ((~b) & d)) + x + ac
        return ((a << s) | (a >> (32 - s))) + b
      end
      
      typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
      def _gg(a, b, c, d, x, s, ac)
        a += ((b & d) | (c & (~d))) + x + ac
        return ((a << s) | (a >> (32 - s))) + b
      end
      
      typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
      def _hh(a, b, c, d, x, s, ac)
        a += ((b ^ c) ^ d) + x + ac
        return ((a << s) | (a >> (32 - s))) + b
      end
      
      typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
      def _ii(a, b, c, d, x, s, ac)
        a += (c ^ (b | (~d))) + x + ac
        return ((a << s) | (a >> (32 - s))) + b
      end
    }
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # This is where the functions come together as the generic MD5
    # transformation operation. It consumes sixteen
    # bytes from the buffer, beginning at the specified offset.
    def impl_compress(buf, ofs)
      b2i_little64(buf, ofs, @x)
      a = @state[0]
      b = @state[1]
      c = @state[2]
      d = @state[3]
      # Round 1
      a = _ff(a, b, c, d, @x[0], S11, -0x28955b88)
      # 1
      d = _ff(d, a, b, c, @x[1], S12, -0x173848aa)
      # 2
      c = _ff(c, d, a, b, @x[2], S13, 0x242070db)
      # 3
      b = _ff(b, c, d, a, @x[3], S14, -0x3e423112)
      # 4
      a = _ff(a, b, c, d, @x[4], S11, -0xa83f051)
      # 5
      d = _ff(d, a, b, c, @x[5], S12, 0x4787c62a)
      # 6
      c = _ff(c, d, a, b, @x[6], S13, -0x57cfb9ed)
      # 7
      b = _ff(b, c, d, a, @x[7], S14, -0x2b96aff)
      # 8
      a = _ff(a, b, c, d, @x[8], S11, 0x698098d8)
      # 9
      d = _ff(d, a, b, c, @x[9], S12, -0x74bb0851)
      # 10
      c = _ff(c, d, a, b, @x[10], S13, -0xa44f)
      # 11
      b = _ff(b, c, d, a, @x[11], S14, -0x76a32842)
      # 12
      a = _ff(a, b, c, d, @x[12], S11, 0x6b901122)
      # 13
      d = _ff(d, a, b, c, @x[13], S12, -0x2678e6d)
      # 14
      c = _ff(c, d, a, b, @x[14], S13, -0x5986bc72)
      # 15
      b = _ff(b, c, d, a, @x[15], S14, 0x49b40821)
      # 16
      # Round 2
      a = _gg(a, b, c, d, @x[1], S21, -0x9e1da9e)
      # 17
      d = _gg(d, a, b, c, @x[6], S22, -0x3fbf4cc0)
      # 18
      c = _gg(c, d, a, b, @x[11], S23, 0x265e5a51)
      # 19
      b = _gg(b, c, d, a, @x[0], S24, -0x16493856)
      # 20
      a = _gg(a, b, c, d, @x[5], S21, -0x29d0efa3)
      # 21
      d = _gg(d, a, b, c, @x[10], S22, 0x2441453)
      # 22
      c = _gg(c, d, a, b, @x[15], S23, -0x275e197f)
      # 23
      b = _gg(b, c, d, a, @x[4], S24, -0x182c0438)
      # 24
      a = _gg(a, b, c, d, @x[9], S21, 0x21e1cde6)
      # 25
      d = _gg(d, a, b, c, @x[14], S22, -0x3cc8f82a)
      # 26
      c = _gg(c, d, a, b, @x[3], S23, -0xb2af279)
      # 27
      b = _gg(b, c, d, a, @x[8], S24, 0x455a14ed)
      # 28
      a = _gg(a, b, c, d, @x[13], S21, -0x561c16fb)
      # 29
      d = _gg(d, a, b, c, @x[2], S22, -0x3105c08)
      # 30
      c = _gg(c, d, a, b, @x[7], S23, 0x676f02d9)
      # 31
      b = _gg(b, c, d, a, @x[12], S24, -0x72d5b376)
      # 32
      # Round 3
      a = _hh(a, b, c, d, @x[5], S31, -0x5c6be)
      # 33
      d = _hh(d, a, b, c, @x[8], S32, -0x788e097f)
      # 34
      c = _hh(c, d, a, b, @x[11], S33, 0x6d9d6122)
      # 35
      b = _hh(b, c, d, a, @x[14], S34, -0x21ac7f4)
      # 36
      a = _hh(a, b, c, d, @x[1], S31, -0x5b4115bc)
      # 37
      d = _hh(d, a, b, c, @x[4], S32, 0x4bdecfa9)
      # 38
      c = _hh(c, d, a, b, @x[7], S33, -0x944b4a0)
      # 39
      b = _hh(b, c, d, a, @x[10], S34, -0x41404390)
      # 40
      a = _hh(a, b, c, d, @x[13], S31, 0x289b7ec6)
      # 41
      d = _hh(d, a, b, c, @x[0], S32, -0x155ed806)
      # 42
      c = _hh(c, d, a, b, @x[3], S33, -0x2b10cf7b)
      # 43
      b = _hh(b, c, d, a, @x[6], S34, 0x4881d05)
      # 44
      a = _hh(a, b, c, d, @x[9], S31, -0x262b2fc7)
      # 45
      d = _hh(d, a, b, c, @x[12], S32, -0x1924661b)
      # 46
      c = _hh(c, d, a, b, @x[15], S33, 0x1fa27cf8)
      # 47
      b = _hh(b, c, d, a, @x[2], S34, -0x3b53a99b)
      # 48
      # Round 4
      a = _ii(a, b, c, d, @x[0], S41, -0xbd6ddbc)
      # 49
      d = _ii(d, a, b, c, @x[7], S42, 0x432aff97)
      # 50
      c = _ii(c, d, a, b, @x[14], S43, -0x546bdc59)
      # 51
      b = _ii(b, c, d, a, @x[5], S44, -0x36c5fc7)
      # 52
      a = _ii(a, b, c, d, @x[12], S41, 0x655b59c3)
      # 53
      d = _ii(d, a, b, c, @x[3], S42, -0x70f3336e)
      # 54
      c = _ii(c, d, a, b, @x[10], S43, -0x100b83)
      # 55
      b = _ii(b, c, d, a, @x[1], S44, -0x7a7ba22f)
      # 56
      a = _ii(a, b, c, d, @x[8], S41, 0x6fa87e4f)
      # 57
      d = _ii(d, a, b, c, @x[15], S42, -0x1d31920)
      # 58
      c = _ii(c, d, a, b, @x[6], S43, -0x5cfebcec)
      # 59
      b = _ii(b, c, d, a, @x[13], S44, 0x4e0811a1)
      # 60
      a = _ii(a, b, c, d, @x[4], S41, -0x8ac817e)
      # 61
      d = _ii(d, a, b, c, @x[11], S42, -0x42c50dcb)
      # 62
      c = _ii(c, d, a, b, @x[2], S43, 0x2ad7d2bb)
      # 63
      b = _ii(b, c, d, a, @x[9], S44, -0x14792c6f)
      # 64
      @state[0] += a
      @state[1] += b
      @state[2] += c
      @state[3] += d
    end
    
    private
    alias_method :initialize__md5, :initialize
  end
  
end
