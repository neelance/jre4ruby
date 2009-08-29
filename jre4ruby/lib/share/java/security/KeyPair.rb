require "rjava"

# Copyright 1996-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security
  module KeyPairImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Util
    }
  end
  
  # This class is a simple holder for a key pair (a public key and a
  # private key). It does not enforce any security, and, when initialized,
  # should be treated like a PrivateKey.
  # 
  # @see PublicKey
  # @see PrivateKey
  # 
  # @author Benjamin Renaud
  class KeyPair 
    include_class_members KeyPairImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -7565189502268009837 }
      const_attr_reader  :SerialVersionUID
    }
    
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
    
    typesig { [PublicKey, PrivateKey] }
    # Constructs a key pair from the given public key and private key.
    # 
    # <p>Note that this constructor only stores references to the public
    # and private key components in the generated key pair. This is safe,
    # because <code>Key</code> objects are immutable.
    # 
    # @param publicKey the public key.
    # 
    # @param privateKey the private key.
    def initialize(public_key, private_key)
      @private_key = nil
      @public_key = nil
      @public_key = public_key
      @private_key = private_key
    end
    
    typesig { [] }
    # Returns a reference to the public key component of this key pair.
    # 
    # @return a reference to the public key.
    def get_public
      return @public_key
    end
    
    typesig { [] }
    # Returns a reference to the private key component of this key pair.
    # 
    # @return a reference to the private key.
    def get_private
      return @private_key
    end
    
    private
    alias_method :initialize__key_pair, :initialize
  end
  
end
