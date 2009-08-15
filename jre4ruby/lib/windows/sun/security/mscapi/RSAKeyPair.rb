require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Mscapi
  module RSAKeyPairImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Mscapi
    }
  end
  
  # The handle for an RSA public/private keypair using the Microsoft Crypto API.
  # 
  # @since 1.6
  class RSAKeyPair 
    include_class_members RSAKeyPairImports
    
    attr_accessor :private_key
    alias_method :attr_private_key, :private_key
    undef_method :private_key
    alias_method :attr_private_key=, :private_key=
    undef_method :private_key=
    
    attr_accessor :public_key
    alias_method :attr_public_key, :public_key
    undef_method :public_key
    alias_method :attr_public_key=, :public_key=
    undef_method :public_key=
    
    typesig { [::Java::Long, ::Java::Long, ::Java::Int] }
    # Construct an RSAKeyPair object.
    def initialize(h_crypt_prov, h_crypt_key, key_length)
      @private_key = nil
      @public_key = nil
      @private_key = RSAPrivateKey.new(h_crypt_prov, h_crypt_key, key_length)
      @public_key = RSAPublicKey.new(h_crypt_prov, h_crypt_key, key_length)
    end
    
    typesig { [] }
    def get_private
      return @private_key
    end
    
    typesig { [] }
    def get_public
      return @public_key
    end
    
    private
    alias_method :initialize__rsakey_pair, :initialize
  end
  
end
