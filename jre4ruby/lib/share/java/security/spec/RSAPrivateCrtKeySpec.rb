require "rjava"

# Copyright 1998-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module RSAPrivateCrtKeySpecImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # This class specifies an RSA private key, as defined in the PKCS#1
  # standard, using the Chinese Remainder Theorem (CRT) information values for
  # efficiency.
  # 
  # @author Jan Luehe
  # 
  # 
  # @see java.security.Key
  # @see java.security.KeyFactory
  # @see KeySpec
  # @see PKCS8EncodedKeySpec
  # @see RSAPrivateKeySpec
  # @see RSAPublicKeySpec
  class RSAPrivateCrtKeySpec < RSAPrivateCrtKeySpecImports.const_get :RSAPrivateKeySpec
    include_class_members RSAPrivateCrtKeySpecImports
    
    attr_accessor :public_exponent
    alias_method :attr_public_exponent, :public_exponent
    undef_method :public_exponent
    alias_method :attr_public_exponent=, :public_exponent=
    undef_method :public_exponent=
    
    attr_accessor :prime_p
    alias_method :attr_prime_p, :prime_p
    undef_method :prime_p
    alias_method :attr_prime_p=, :prime_p=
    undef_method :prime_p=
    
    attr_accessor :prime_q
    alias_method :attr_prime_q, :prime_q
    undef_method :prime_q
    alias_method :attr_prime_q=, :prime_q=
    undef_method :prime_q=
    
    attr_accessor :prime_exponent_p
    alias_method :attr_prime_exponent_p, :prime_exponent_p
    undef_method :prime_exponent_p
    alias_method :attr_prime_exponent_p=, :prime_exponent_p=
    undef_method :prime_exponent_p=
    
    attr_accessor :prime_exponent_q
    alias_method :attr_prime_exponent_q, :prime_exponent_q
    undef_method :prime_exponent_q
    alias_method :attr_prime_exponent_q=, :prime_exponent_q=
    undef_method :prime_exponent_q=
    
    attr_accessor :crt_coefficient
    alias_method :attr_crt_coefficient, :crt_coefficient
    undef_method :crt_coefficient
    alias_method :attr_crt_coefficient=, :crt_coefficient=
    undef_method :crt_coefficient=
    
    typesig { [BigInteger, BigInteger, BigInteger, BigInteger, BigInteger, BigInteger, BigInteger, BigInteger] }
    # Creates a new <code>RSAPrivateCrtKeySpec</code>
    # given the modulus, publicExponent, privateExponent,
    # primeP, primeQ, primeExponentP, primeExponentQ, and
    # crtCoefficient as defined in PKCS#1.
    # 
    # @param modulus the modulus n
    # @param publicExponent the public exponent e
    # @param privateExponent the private exponent d
    # @param primeP the prime factor p of n
    # @param primeQ the prime factor q of n
    # @param primeExponentP this is d mod (p-1)
    # @param primeExponentQ this is d mod (q-1)
    # @param crtCoefficient the Chinese Remainder Theorem
    # coefficient q-1 mod p
    def initialize(modulus, public_exponent, private_exponent, prime_p, prime_q, prime_exponent_p, prime_exponent_q, crt_coefficient)
      @public_exponent = nil
      @prime_p = nil
      @prime_q = nil
      @prime_exponent_p = nil
      @prime_exponent_q = nil
      @crt_coefficient = nil
      super(modulus, private_exponent)
      @public_exponent = public_exponent
      @prime_p = prime_p
      @prime_q = prime_q
      @prime_exponent_p = prime_exponent_p
      @prime_exponent_q = prime_exponent_q
      @crt_coefficient = crt_coefficient
    end
    
    typesig { [] }
    # Returns the public exponent.
    # 
    # @return the public exponent
    def get_public_exponent
      return @public_exponent
    end
    
    typesig { [] }
    # Returns the primeP.
    # 
    # @return the primeP
    def get_prime_p
      return @prime_p
    end
    
    typesig { [] }
    # Returns the primeQ.
    # 
    # @return the primeQ
    def get_prime_q
      return @prime_q
    end
    
    typesig { [] }
    # Returns the primeExponentP.
    # 
    # @return the primeExponentP
    def get_prime_exponent_p
      return @prime_exponent_p
    end
    
    typesig { [] }
    # Returns the primeExponentQ.
    # 
    # @return the primeExponentQ
    def get_prime_exponent_q
      return @prime_exponent_q
    end
    
    typesig { [] }
    # Returns the crtCoefficient.
    # 
    # @return the crtCoefficient
    def get_crt_coefficient
      return @crt_coefficient
    end
    
    private
    alias_method :initialize__rsaprivate_crt_key_spec, :initialize
  end
  
end
