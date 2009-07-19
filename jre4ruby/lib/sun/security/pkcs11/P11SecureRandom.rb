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
module Sun::Security::Pkcs11
  module P11SecureRandomImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Util
      include ::Java::Security
      include ::Sun::Security::Pkcs11::Wrapper
      include ::Sun::Security::Pkcs11::Wrapper::PKCS11Constants
    }
  end
  
  # SecureRandom implementation class. Some tokens support only
  # C_GenerateRandom() and not C_SeedRandom(). In order not to lose an
  # application specified seed, we create a SHA1PRNG that we mix with in that
  # case.
  # 
  # Note that since SecureRandom is thread safe, we only need one
  # instance per PKCS#11 token instance. It is created on demand and cached
  # in the SunPKCS11 class.
  # 
  # Also note that we obtain the PKCS#11 session on demand, no need to tie one
  # up.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class P11SecureRandom < P11SecureRandomImports.const_get :SecureRandomSpi
    include_class_members P11SecureRandomImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -8939510236124553291 }
      const_attr_reader  :SerialVersionUID
    }
    
    # token instance
    attr_accessor :token
    alias_method :attr_token, :token
    undef_method :token
    alias_method :attr_token=, :token=
    undef_method :token=
    
    # PRNG for mixing, non-null if active (i.e. setSeed() has been called)
    attr_accessor :mix_random
    alias_method :attr_mix_random, :mix_random
    undef_method :mix_random
    alias_method :attr_mix_random=, :mix_random=
    undef_method :mix_random=
    
    # buffer, if mixing is used
    attr_accessor :mix_buffer
    alias_method :attr_mix_buffer, :mix_buffer
    undef_method :mix_buffer
    alias_method :attr_mix_buffer=, :mix_buffer=
    undef_method :mix_buffer=
    
    # bytes remaining in buffer, if mixing is used
    attr_accessor :buffered
    alias_method :attr_buffered, :buffered
    undef_method :buffered
    alias_method :attr_buffered=, :buffered=
    undef_method :buffered=
    
    typesig { [Token] }
    def initialize(token)
      @token = nil
      @mix_random = nil
      @mix_buffer = nil
      @buffered = 0
      super()
      @token = token
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # see JCA spec
    def engine_set_seed(seed)
      synchronized(self) do
        if ((seed).nil?)
          raise NullPointerException.new("seed must not be null")
        end
        session = nil
        begin
          session = @token.get_op_session
          @token.attr_p11._c_seed_random(session.id, seed)
        rescue PKCS11Exception => e
          # cannot set seed
          # let a SHA1PRNG use that seed instead
          random = @mix_random
          if (!(random).nil?)
            random.set_seed(seed)
          else
            begin
              @mix_buffer = Array.typed(::Java::Byte).new(20) { 0 }
              random = SecureRandom.get_instance("SHA1PRNG")
              # initialize object before assigning to class field
              random.set_seed(seed)
              @mix_random = random
            rescue NoSuchAlgorithmException => ee
              raise ProviderException.new(ee)
            end
          end
        ensure
          @token.release_session(session)
        end
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # see JCA spec
    def engine_next_bytes(bytes)
      if (((bytes).nil?) || ((bytes.attr_length).equal?(0)))
        return
      end
      session = nil
      begin
        session = @token.get_op_session
        @token.attr_p11._c_generate_random(session.id, bytes)
        mix(bytes)
      rescue PKCS11Exception => e
        raise ProviderException.new("nextBytes() failed", e)
      ensure
        @token.release_session(session)
      end
    end
    
    typesig { [::Java::Int] }
    # see JCA spec
    def engine_generate_seed(num_bytes)
      b = Array.typed(::Java::Byte).new(num_bytes) { 0 }
      engine_next_bytes(b)
      return b
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def mix(b)
      random = @mix_random
      if ((random).nil?)
        # avoid mixing if setSeed() has never been called
        return
      end
      synchronized((self)) do
        ofs = 0
        len = b.attr_length
        while (((len -= 1) + 1) > 0)
          if ((@buffered).equal?(0))
            random.next_bytes(@mix_buffer)
            @buffered = @mix_buffer.attr_length
          end
          b[((ofs += 1) - 1)] ^= @mix_buffer[@mix_buffer.attr_length - @buffered]
          ((@buffered -= 1) + 1)
        end
      end
    end
    
    private
    alias_method :initialize__p11secure_random, :initialize
  end
  
end
