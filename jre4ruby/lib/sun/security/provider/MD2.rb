require "rjava"

# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module MD2Imports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include_const ::Java::Util, :Arrays
    }
  end
  
  # Implementation for the MD2 algorithm, see RFC1319. It is very slow and
  # not particular secure. It is only supported to be able to verify
  # RSA/Verisign root certificates signed using MD2withRSA. It should not
  # be used for anything else.
  # 
  # @since   1.5
  # @author  Andreas Sterbenz
  class MD2 < MD2Imports.const_get :DigestBase
    include_class_members MD2Imports
    
    # state, 48 ints
    attr_accessor :x
    alias_method :attr_x, :x
    undef_method :x
    alias_method :attr_x=, :x=
    undef_method :x=
    
    # checksum, 16 ints. they are really bytes, but byte arithmetic in
    # the JVM is much slower that int arithmetic.
    attr_accessor :c
    alias_method :attr_c, :c
    undef_method :c
    alias_method :attr_c=, :c=
    undef_method :c=
    
    # temporary store for checksum C during final digest
    attr_accessor :c_bytes
    alias_method :attr_c_bytes, :c_bytes
    undef_method :c_bytes
    alias_method :attr_c_bytes=, :c_bytes=
    undef_method :c_bytes=
    
    typesig { [] }
    # Create a new MD2 digest. Called by the JCA framework
    def initialize
      @x = nil
      @c = nil
      @c_bytes = nil
      super("MD2", 16, 16)
      @x = Array.typed(::Java::Int).new(48) { 0 }
      @c = Array.typed(::Java::Int).new(16) { 0 }
      @c_bytes = Array.typed(::Java::Byte).new(16) { 0 }
    end
    
    typesig { [MD2] }
    def initialize(base)
      @x = nil
      @c = nil
      @c_bytes = nil
      super(base)
      @x = base.attr_x.clone
      @c = base.attr_c.clone
      @c_bytes = Array.typed(::Java::Byte).new(16) { 0 }
    end
    
    typesig { [] }
    def clone
      return MD2.new(self)
    end
    
    typesig { [] }
    # reset state and checksum
    def impl_reset
      Arrays.fill(@x, 0)
      Arrays.fill(@c, 0)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # finish the digest
    def impl_digest(out, ofs)
      pad_value = 16 - (RJava.cast_to_int(self.attr_bytes_processed) & 15)
      engine_update(PADDING[pad_value], 0, pad_value)
      i = 0
      while i < 16
        @c_bytes[i] = @c[i]
        i += 1
      end
      impl_compress(@c_bytes, 0)
      i_ = 0
      while i_ < 16
        out[ofs + i_] = @x[i_]
        i_ += 1
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # one iteration of the compression function
    def impl_compress(b, ofs)
      i = 0
      while i < 16
        k = b[ofs + i] & 0xff
        @x[16 + i] = k
        @x[32 + i] = k ^ @x[i]
        i += 1
      end
      # update the checksum
      t = @c[15]
      i_ = 0
      while i_ < 16
        t = (@c[i_] ^= S[@x[16 + i_] ^ t])
        i_ += 1
      end
      t = 0
      i__ = 0
      while i__ < 18
        j = 0
        while j < 48
          t = (@x[j] ^= S[t])
          j += 1
        end
        t = (t + i__) & 0xff
        i__ += 1
      end
    end
    
    class_module.module_eval {
      # substitution table derived from Pi. Copied from the RFC.
      const_set_lazy(:S) { Array.typed(::Java::Int).new([41, 46, 67, 201, 162, 216, 124, 1, 61, 54, 84, 161, 236, 240, 6, 19, 98, 167, 5, 243, 192, 199, 115, 140, 152, 147, 43, 217, 188, 76, 130, 202, 30, 155, 87, 60, 253, 212, 224, 22, 103, 66, 111, 24, 138, 23, 229, 18, 190, 78, 196, 214, 218, 158, 222, 73, 160, 251, 245, 142, 187, 47, 238, 122, 169, 104, 121, 145, 21, 178, 7, 63, 148, 194, 16, 137, 11, 34, 95, 33, 128, 127, 93, 154, 90, 144, 50, 39, 53, 62, 204, 231, 191, 247, 151, 3, 255, 25, 48, 179, 72, 165, 181, 209, 215, 94, 146, 42, 172, 86, 170, 198, 79, 184, 56, 210, 150, 164, 125, 182, 118, 252, 107, 226, 156, 116, 4, 241, 69, 157, 112, 89, 100, 113, 135, 32, 134, 91, 207, 101, 230, 45, 168, 2, 27, 96, 37, 173, 174, 176, 185, 246, 28, 70, 97, 105, 52, 64, 126, 15, 85, 71, 163, 35, 221, 81, 175, 58, 195, 92, 249, 206, 186, 197, 234, 38, 44, 83, 13, 110, 133, 40, 132, 9, 211, 223, 205, 244, 65, 129, 77, 82, 106, 220, 55, 200, 108, 193, 171, 250, 36, 225, 123, 8, 12, 189, 177, 74, 120, 136, 149, 139, 227, 99, 232, 109, 233, 203, 213, 254, 59, 0, 29, 57, 242, 239, 183, 14, 102, 88, 208, 228, 166, 119, 114, 248, 235, 117, 75, 10, 49, 68, 80, 180, 143, 237, 31, 26, 219, 153, 141, 51, 159, 17, 131, 20, ]) }
      const_attr_reader  :S
      
      when_class_loaded do
        const_set :PADDING, Array.typed(::Java::Byte).new(17) { 0 }
        i = 1
        while i < 17
          b = Array.typed(::Java::Byte).new(i) { 0 }
          Arrays.fill(b, i)
          PADDING[i] = b
          i += 1
        end
      end
    }
    
    private
    alias_method :initialize__md2, :initialize
  end
  
end
