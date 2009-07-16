require "rjava"

# 
# Copyright 1999 Sun Microsystems, Inc.  All Rights Reserved.
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
  module RSAKeyGenParameterSpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
    }
  end
  
  # 
  # This class specifies the set of parameters used to generate an RSA
  # key pair.
  # 
  # @author Jan Luehe
  # 
  # @see java.security.KeyPairGenerator#initialize(java.security.spec.AlgorithmParameterSpec)
  # 
  # @since 1.3
  class RSAKeyGenParameterSpec 
    include_class_members RSAKeyGenParameterSpecImports
    include AlgorithmParameterSpec
    
    attr_accessor :keysize
    alias_method :attr_keysize, :keysize
    undef_method :keysize
    alias_method :attr_keysize=, :keysize=
    undef_method :keysize=
    
    attr_accessor :public_exponent
    alias_method :attr_public_exponent, :public_exponent
    undef_method :public_exponent
    alias_method :attr_public_exponent=, :public_exponent=
    undef_method :public_exponent=
    
    class_module.module_eval {
      # 
      # The public-exponent value F0 = 3.
      const_set_lazy(:F0) { BigInteger.value_of(3) }
      const_attr_reader  :F0
      
      # 
      # The public exponent-value F4 = 65537.
      const_set_lazy(:F4) { BigInteger.value_of(65537) }
      const_attr_reader  :F4
    }
    
    typesig { [::Java::Int, BigInteger] }
    # 
    # Constructs a new <code>RSAParameterSpec</code> object from the
    # given keysize and public-exponent value.
    # 
    # @param keysize the modulus size (specified in number of bits)
    # @param publicExponent the public exponent
    def initialize(keysize, public_exponent)
      @keysize = 0
      @public_exponent = nil
      @keysize = keysize
      @public_exponent = public_exponent
    end
    
    typesig { [] }
    # 
    # Returns the keysize.
    # 
    # @return the keysize.
    def get_keysize
      return @keysize
    end
    
    typesig { [] }
    # 
    # Returns the public-exponent value.
    # 
    # @return the public-exponent value.
    def get_public_exponent
      return @public_exponent
    end
    
    private
    alias_method :initialize__rsakey_gen_parameter_spec, :initialize
  end
  
end
