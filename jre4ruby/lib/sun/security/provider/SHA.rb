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
  module SHAImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
    }
  end
  
  # This class implements the Secure Hash Algorithm (SHA) developed by
  # the National Institute of Standards and Technology along with the
  # National Security Agency.  This is the updated version of SHA
  # fip-180 as superseded by fip-180-1.
  # 
  # <p>It implement JavaSecurity MessageDigest, and can be used by in
  # the Java Security framework, as a pluggable implementation, as a
  # filter for the digest stream classes.
  # 
  # @author      Roger Riggs
  # @author      Benjamin Renaud
  # @author      Andreas Sterbenz
  class SHA < SHAImports.const_get :DigestBase
    include_class_members SHAImports
    
    # Buffer of int's and count of characters accumulated
    # 64 bytes are included in each hash block so the low order
    # bits of count are used to know how to pack the bytes into ints
    # and to know when to compute the block and start the next one.
    attr_accessor :w
    alias_method :attr_w, :w
    undef_method :w
    alias_method :attr_w=, :w=
    undef_method :w=
    
    # state of this
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
      super("SHA-1", 20, 64)
      @state = Array.typed(::Java::Int).new(5) { 0 }
      @w = Array.typed(::Java::Int).new(80) { 0 }
      impl_reset
    end
    
    typesig { [SHA] }
    # Creates a SHA object.with state (for cloning)
    def initialize(base)
      @w = nil
      @state = nil
      super(base)
      @state = base.attr_state.clone
      @w = Array.typed(::Java::Int).new(80) { 0 }
    end
    
    typesig { [] }
    # Clones this object.
    def clone
      return SHA.new(self)
    end
    
    typesig { [] }
    # Resets the buffers and hash value to start a new hash.
    def impl_reset
      @state[0] = 0x67452301
      @state[1] = -0x10325477
      @state[2] = -0x67452302
      @state[3] = 0x10325476
      @state[4] = -0x3c2d1e10
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Computes the final hash and copies the 20 bytes to the output array.
    def impl_digest(out, ofs)
      bits_processed = self.attr_bytes_processed << 3
      index = RJava.cast_to_int(self.attr_bytes_processed) & 0x3f
      pad_len = (index < 56) ? (56 - index) : (120 - index)
      engine_update(self.attr_padding, 0, pad_len)
      i2b_big4(RJava.cast_to_int((bits_processed >> 32)), self.attr_buffer, 56)
      i2b_big4(RJava.cast_to_int(bits_processed), self.attr_buffer, 60)
      impl_compress(self.attr_buffer, 0)
      i2b_big(@state, 0, out, ofs, 20)
    end
    
    class_module.module_eval {
      # Constants for each round
      const_set_lazy(:Round1_kt) { 0x5a827999 }
      const_attr_reader  :Round1_kt
      
      const_set_lazy(:Round2_kt) { 0x6ed9eba1 }
      const_attr_reader  :Round2_kt
      
      const_set_lazy(:Round3_kt) { -0x70e44324 }
      const_attr_reader  :Round3_kt
      
      const_set_lazy(:Round4_kt) { -0x359d3e2a }
      const_attr_reader  :Round4_kt
    }
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Compute a the hash for the current block.
    # 
    # This is in the same vein as Peter Gutmann's algorithm listed in
    # the back of Applied Cryptography, Compact implementation of
    # "old" NIST Secure Hash Algorithm.
    def impl_compress(buf, ofs)
      b2i_big64(buf, ofs, @w)
      # The first 16 ints have the byte stream, compute the rest of
      # the buffer
      t = 16
      while t <= 79
        temp = @w[t - 3] ^ @w[t - 8] ^ @w[t - 14] ^ @w[t - 16]
        @w[t] = (temp << 1) | (temp >> 31)
        t += 1
      end
      a = @state[0]
      b = @state[1]
      c = @state[2]
      d = @state[3]
      e = @state[4]
      # Round 1
      i = 0
      while i < 20
        temp = ((a << 5) | (a >> (32 - 5))) + ((b & c) | ((~b) & d)) + e + @w[i] + Round1_kt
        e = d
        d = c
        c = ((b << 30) | (b >> (32 - 30)))
        b = a
        a = temp
        i += 1
      end
      # Round 2
      i_ = 20
      while i_ < 40
        temp = ((a << 5) | (a >> (32 - 5))) + (b ^ c ^ d) + e + @w[i_] + Round2_kt
        e = d
        d = c
        c = ((b << 30) | (b >> (32 - 30)))
        b = a
        a = temp
        i_ += 1
      end
      # Round 3
      i__ = 40
      while i__ < 60
        temp = ((a << 5) | (a >> (32 - 5))) + ((b & c) | (b & d) | (c & d)) + e + @w[i__] + Round3_kt
        e = d
        d = c
        c = ((b << 30) | (b >> (32 - 30)))
        b = a
        a = temp
        i__ += 1
      end
      # Round 4
      i___ = 60
      while i___ < 80
        temp = ((a << 5) | (a >> (32 - 5))) + (b ^ c ^ d) + e + @w[i___] + Round4_kt
        e = d
        d = c
        c = ((b << 30) | (b >> (32 - 30)))
        b = a
        a = temp
        i___ += 1
      end
      @state[0] += a
      @state[1] += b
      @state[2] += c
      @state[3] += d
      @state[4] += e
    end
    
    private
    alias_method :initialize__sha, :initialize
  end
  
end
