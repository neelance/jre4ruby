require "rjava"

# Copyright 2001-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security::Interfaces
  module RSAMultiPrimePrivateCrtKeyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Interfaces
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Security::Spec, :RSAOtherPrimeInfo
    }
  end
  
  # The interface to an RSA multi-prime private key, as defined in the
  # PKCS#1 v2.1, using the <i>Chinese Remainder Theorem</i>
  # (CRT) information values.
  # 
  # @author Valerie Peng
  # 
  # 
  # @see java.security.spec.RSAPrivateKeySpec
  # @see java.security.spec.RSAMultiPrimePrivateCrtKeySpec
  # @see RSAPrivateKey
  # @see RSAPrivateCrtKey
  # 
  # @since 1.4
  module RSAMultiPrimePrivateCrtKey
    include_class_members RSAMultiPrimePrivateCrtKeyImports
    include RSAPrivateKey
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 618058533534628008 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Returns the public exponent.
    # 
    # @return the public exponent.
    def get_public_exponent
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the primeP.
    # 
    # @return the primeP.
    def get_prime_p
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the primeQ.
    # 
    # @return the primeQ.
    def get_prime_q
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the primeExponentP.
    # 
    # @return the primeExponentP.
    def get_prime_exponent_p
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the primeExponentQ.
    # 
    # @return the primeExponentQ.
    def get_prime_exponent_q
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the crtCoefficient.
    # 
    # @return the crtCoefficient.
    def get_crt_coefficient
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the otherPrimeInfo or null if there are only
    # two prime factors (p and q).
    # 
    # @return the otherPrimeInfo.
    def get_other_prime_info
      raise NotImplementedError
    end
  end
  
end
