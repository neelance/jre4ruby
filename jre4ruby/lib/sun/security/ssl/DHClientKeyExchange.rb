require "rjava"

# 
# Copyright 1997-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module DHClientKeyExchangeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # 
  # Message used by clients to send their Diffie-Hellman public
  # keys to servers.
  # 
  # @author David Brownell
  class DHClientKeyExchange < DHClientKeyExchangeImports.const_get :HandshakeMessage
    include_class_members DHClientKeyExchangeImports
    
    typesig { [] }
    def message_type
      return self.attr_ht_client_key_exchange
    end
    
    # 
    # This value may be empty if it was included in the
    # client's certificate ...
    attr_accessor :dh_yc
    alias_method :attr_dh_yc, :dh_yc
    undef_method :dh_yc
    alias_method :attr_dh_yc=, :dh_yc=
    undef_method :dh_yc=
    
    typesig { [] }
    # 1 to 2^16 -1 bytes
    def get_client_public_key
      return BigInteger.new(1, @dh_yc)
    end
    
    typesig { [BigInteger] }
    # 
    # Either pass the client's public key explicitly (because it's
    # using DHE or DH_anon), or implicitly (the public key was in the
    # certificate).
    def initialize(public_key)
      @dh_yc = nil
      super()
      @dh_yc = to_byte_array(public_key)
    end
    
    typesig { [] }
    def initialize
      @dh_yc = nil
      super()
      @dh_yc = nil
    end
    
    typesig { [HandshakeInStream] }
    # 
    # Get the client's public key either explicitly or implicitly.
    # (It's ugly to have an empty record be sent in the latter case,
    # but that's what the protocol spec requires.)
    def initialize(input)
      @dh_yc = nil
      super()
      @dh_yc = input.get_bytes16
    end
    
    typesig { [] }
    def message_length
      if ((@dh_yc).nil?)
        return 0
      else
        return @dh_yc.attr_length + 2
      end
    end
    
    typesig { [HandshakeOutStream] }
    def send(s)
      s.put_bytes16(@dh_yc)
    end
    
    typesig { [PrintStream] }
    def print(s)
      s.println("*** ClientKeyExchange, DH")
      if (!(self.attr_debug).nil? && Debug.is_on("verbose"))
        Debug.println(s, "DH Public key", @dh_yc)
      end
    end
    
    private
    alias_method :initialize__dhclient_key_exchange, :initialize
  end
  
end
