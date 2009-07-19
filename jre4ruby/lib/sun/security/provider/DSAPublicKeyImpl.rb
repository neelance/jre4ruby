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
module Sun::Security::Provider
  module DSAPublicKeyImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Security, :KeyRep
      include_const ::Java::Security, :InvalidKeyException
    }
  end
  
  # An X.509 public key for the Digital Signature Algorithm.
  # 
  # The difference between DSAPublicKeyImpl and DSAPublicKey is that
  # DSAPublicKeyImpl calls writeReplace with KeyRep, and DSAPublicKey
  # calls writeObject.
  # 
  # See the comments in DSAKeyFactory, 4532506, and 6232513.
  class DSAPublicKeyImpl < DSAPublicKeyImplImports.const_get :DSAPublicKey
    include_class_members DSAPublicKeyImplImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 7819830118247182730 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [BigInteger, BigInteger, BigInteger, BigInteger] }
    # Make a DSA public key out of a public key and three parameters.
    # The p, q, and g parameters may be null, but if so, parameters will need
    # to be supplied from some other source before this key can be used in
    # cryptographic operations.  PKIX RFC2459bis explicitly allows DSA public
    # keys without parameters, where the parameters are provided in the
    # issuer's DSA public key.
    # 
    # @param y the actual key bits
    # @param p DSA parameter p, may be null if all of p, q, and g are null.
    # @param q DSA parameter q, may be null if all of p, q, and g are null.
    # @param g DSA parameter g, may be null if all of p, q, and g are null.
    def initialize(y, p, q, g)
      super(y, p, q, g)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Make a DSA public key from its DER encoding (X.509).
    def initialize(encoded)
      super(encoded)
    end
    
    typesig { [] }
    def write_replace
      return KeyRep.new(KeyRep::Type::PUBLIC, get_algorithm, get_format, get_encoded)
    end
    
    private
    alias_method :initialize__dsapublic_key_impl, :initialize
  end
  
end
