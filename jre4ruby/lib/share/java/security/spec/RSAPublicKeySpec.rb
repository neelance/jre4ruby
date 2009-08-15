require "rjava"

# Copyright 1998-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security::Spec
  module RSAPublicKeySpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # This class specifies an RSA public key.
  # 
  # @author Jan Luehe
  # 
  # 
  # @see java.security.Key
  # @see java.security.KeyFactory
  # @see KeySpec
  # @see X509EncodedKeySpec
  # @see RSAPrivateKeySpec
  # @see RSAPrivateCrtKeySpec
  class RSAPublicKeySpec 
    include_class_members RSAPublicKeySpecImports
    include KeySpec
    
    attr_accessor :modulus
    alias_method :attr_modulus, :modulus
    undef_method :modulus
    alias_method :attr_modulus=, :modulus=
    undef_method :modulus=
    
    attr_accessor :public_exponent
    alias_method :attr_public_exponent, :public_exponent
    undef_method :public_exponent
    alias_method :attr_public_exponent=, :public_exponent=
    undef_method :public_exponent=
    
    typesig { [BigInteger, BigInteger] }
    # Creates a new RSAPublicKeySpec.
    # 
    # @param modulus the modulus
    # @param publicExponent the public exponent
    def initialize(modulus, public_exponent)
      @modulus = nil
      @public_exponent = nil
      @modulus = modulus
      @public_exponent = public_exponent
    end
    
    typesig { [] }
    # Returns the modulus.
    # 
    # @return the modulus
    def get_modulus
      return @modulus
    end
    
    typesig { [] }
    # Returns the public exponent.
    # 
    # @return the public exponent
    def get_public_exponent
      return @public_exponent
    end
    
    private
    alias_method :initialize__rsapublic_key_spec, :initialize
  end
  
end
