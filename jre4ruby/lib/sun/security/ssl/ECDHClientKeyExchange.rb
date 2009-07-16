require "rjava"

# 
# Copyright 2006-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ECDHClientKeyExchangeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Security, :PublicKey
      include_const ::Java::Security::Interfaces, :ECPublicKey
      include ::Java::Security::Spec
    }
  end
  
  # 
  # ClientKeyExchange message for all ECDH based key exchange methods. It
  # contains the client's ephemeral public value.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class ECDHClientKeyExchange < ECDHClientKeyExchangeImports.const_get :HandshakeMessage
    include_class_members ECDHClientKeyExchangeImports
    
    typesig { [] }
    def message_type
      return self.attr_ht_client_key_exchange
    end
    
    attr_accessor :encoded_point
    alias_method :attr_encoded_point, :encoded_point
    undef_method :encoded_point
    alias_method :attr_encoded_point=, :encoded_point=
    undef_method :encoded_point=
    
    typesig { [] }
    def get_encoded_point
      return @encoded_point
    end
    
    typesig { [PublicKey] }
    # Called by the client with its ephemeral public key.
    def initialize(public_key)
      @encoded_point = nil
      super()
      ec_key = public_key
      point = ec_key.get_w
      params = ec_key.get_params
      @encoded_point = JsseJce.encode_point(point, params.get_curve)
    end
    
    typesig { [HandshakeInStream] }
    def initialize(input)
      @encoded_point = nil
      super()
      @encoded_point = input.get_bytes8
    end
    
    typesig { [] }
    def message_length
      return @encoded_point.attr_length + 1
    end
    
    typesig { [HandshakeOutStream] }
    def send(s)
      s.put_bytes8(@encoded_point)
    end
    
    typesig { [PrintStream] }
    def print(s)
      s.println("*** ECDHClientKeyExchange")
      if (!(self.attr_debug).nil? && Debug.is_on("verbose"))
        Debug.println(s, "ECDH Public value", @encoded_point)
      end
    end
    
    private
    alias_method :initialize__ecdhclient_key_exchange, :initialize
  end
  
end
