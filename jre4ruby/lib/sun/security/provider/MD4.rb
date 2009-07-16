require "rjava"

# 
# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module MD4Imports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include ::Java::Security
    }
  end
  
  # 
  # The MD4 class is used to compute an MD4 message digest over a given
  # buffer of bytes. It is an implementation of the RSA Data Security Inc
  # MD4 algorithim as described in internet RFC 1320.
  # 
  # <p>The MD4 algorithm is very weak and should not be used unless it is
  # unavoidable. Therefore, it is not registered in our standard providers. To
  # obtain an implementation, call the static getInstance() method in this
  # class.
  # 
  # @author      Andreas Sterbenz
  class MD4 < MD4Imports.const_get :DigestBase
    include_class_members MD4Imports
    
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
      const_set_lazy(:S11) { 3 }
      const_attr_reader  :S11
      
      const_set_lazy(:S12) { 7 }
      const_attr_reader  :S12
      
      const_set_lazy(:S13) { 11 }
      const_attr_reader  :S13
      
      const_set_lazy(:S14) { 19 }
      const_attr_reader  :S14
      
      const_set_lazy(:S21) { 3 }
      const_attr_reader  :S21
      
      const_set_lazy(:S22) { 5 }
      const_attr_reader  :S22
      
      const_set_lazy(:S23) { 9 }
      const_attr_reader  :S23
      
      const_set_lazy(:S24) { 13 }
      const_attr_reader  :S24
      
      const_set_lazy(:S31) { 3 }
      const_attr_reader  :S31
      
      const_set_lazy(:S32) { 9 }
      const_attr_reader  :S32
      
      const_set_lazy(:S33) { 11 }
      const_attr_reader  :S33
      
      const_set_lazy(:S34) { 15 }
      const_attr_reader  :S34
      
      when_class_loaded do
        const_set :Md4Provider, Class.new(Provider.class == Class ? Provider : Object) do
          extend LocalClass
          include_class_members MD4
          include Provider if Provider.class == Module
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self, "MD4Provider", 1.0, "MD4 MessageDigest")
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members MD4
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            Md4Provider.put("MessageDigest.MD4", "sun.security.provider.MD4")
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [] }
      def get_instance
        begin
          return MessageDigest.get_instance("MD4", Md4Provider)
        rescue NoSuchAlgorithmException => e
          # should never occur
          raise ProviderException.new(e)
        end
      end
    }
    
    typesig { [] }
    # Standard constructor, creates a new MD4 instance.
    def initialize
      @state = nil
      @x = nil
      super("MD4", 16, 64)
      @state = Array.typed(::Java::Int).new(4) { 0 }
      @x = Array.typed(::Java::Int).new(16) { 0 }
      impl_reset
    end
    
    typesig { [MD4] }
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
      return MD4.new(self)
    end
    
    typesig { [] }
    # 
    # Reset the state of this object.
    def impl_reset
      # Load magic initialization constants.
      @state[0] = 0x67452301
      @state[1] = -0x10325477
      @state[2] = -0x67452302
      @state[3] = 0x10325476
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # 
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
      typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
      def _ff(a, b, c, d, x, s)
        a += ((b & c) | ((~b) & d)) + x
        return ((a << s) | (a >> (32 - s)))
      end
      
      typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
      def _gg(a, b, c, d, x, s)
        a += ((b & c) | (b & d) | (c & d)) + x + 0x5a827999
        return ((a << s) | (a >> (32 - s)))
      end
      
      typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
      def _hh(a, b, c, d, x, s)
        a += ((b ^ c) ^ d) + x + 0x6ed9eba1
        return ((a << s) | (a >> (32 - s)))
      end
    }
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # 
    # This is where the functions come together as the generic MD4
    # transformation operation. It consumes sixteen
    # bytes from the buffer, beginning at the specified offset.
    def impl_compress(buf, ofs)
      b2i_little64(buf, ofs, @x)
      a = @state[0]
      b = @state[1]
      c = @state[2]
      d = @state[3]
      # Round 1
      a = _ff(a, b, c, d, @x[0], S11)
      # 1
      d = _ff(d, a, b, c, @x[1], S12)
      # 2
      c = _ff(c, d, a, b, @x[2], S13)
      # 3
      b = _ff(b, c, d, a, @x[3], S14)
      # 4
      a = _ff(a, b, c, d, @x[4], S11)
      # 5
      d = _ff(d, a, b, c, @x[5], S12)
      # 6
      c = _ff(c, d, a, b, @x[6], S13)
      # 7
      b = _ff(b, c, d, a, @x[7], S14)
      # 8
      a = _ff(a, b, c, d, @x[8], S11)
      # 9
      d = _ff(d, a, b, c, @x[9], S12)
      # 10
      c = _ff(c, d, a, b, @x[10], S13)
      # 11
      b = _ff(b, c, d, a, @x[11], S14)
      # 12
      a = _ff(a, b, c, d, @x[12], S11)
      # 13
      d = _ff(d, a, b, c, @x[13], S12)
      # 14
      c = _ff(c, d, a, b, @x[14], S13)
      # 15
      b = _ff(b, c, d, a, @x[15], S14)
      # 16
      # Round 2
      a = _gg(a, b, c, d, @x[0], S21)
      # 17
      d = _gg(d, a, b, c, @x[4], S22)
      # 18
      c = _gg(c, d, a, b, @x[8], S23)
      # 19
      b = _gg(b, c, d, a, @x[12], S24)
      # 20
      a = _gg(a, b, c, d, @x[1], S21)
      # 21
      d = _gg(d, a, b, c, @x[5], S22)
      # 22
      c = _gg(c, d, a, b, @x[9], S23)
      # 23
      b = _gg(b, c, d, a, @x[13], S24)
      # 24
      a = _gg(a, b, c, d, @x[2], S21)
      # 25
      d = _gg(d, a, b, c, @x[6], S22)
      # 26
      c = _gg(c, d, a, b, @x[10], S23)
      # 27
      b = _gg(b, c, d, a, @x[14], S24)
      # 28
      a = _gg(a, b, c, d, @x[3], S21)
      # 29
      d = _gg(d, a, b, c, @x[7], S22)
      # 30
      c = _gg(c, d, a, b, @x[11], S23)
      # 31
      b = _gg(b, c, d, a, @x[15], S24)
      # 32
      # Round 3
      a = _hh(a, b, c, d, @x[0], S31)
      # 33
      d = _hh(d, a, b, c, @x[8], S32)
      # 34
      c = _hh(c, d, a, b, @x[4], S33)
      # 35
      b = _hh(b, c, d, a, @x[12], S34)
      # 36
      a = _hh(a, b, c, d, @x[2], S31)
      # 37
      d = _hh(d, a, b, c, @x[10], S32)
      # 38
      c = _hh(c, d, a, b, @x[6], S33)
      # 39
      b = _hh(b, c, d, a, @x[14], S34)
      # 40
      a = _hh(a, b, c, d, @x[1], S31)
      # 41
      d = _hh(d, a, b, c, @x[9], S32)
      # 42
      c = _hh(c, d, a, b, @x[5], S33)
      # 43
      b = _hh(b, c, d, a, @x[13], S34)
      # 44
      a = _hh(a, b, c, d, @x[3], S31)
      # 45
      d = _hh(d, a, b, c, @x[11], S32)
      # 46
      c = _hh(c, d, a, b, @x[7], S33)
      # 47
      b = _hh(b, c, d, a, @x[15], S34)
      # 48
      @state[0] += a
      @state[1] += b
      @state[2] += c
      @state[3] += d
    end
    
    private
    alias_method :initialize__md4, :initialize
  end
  
end
