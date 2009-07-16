require "rjava"

# 
# Copyright 2001 Sun Microsystems, Inc.  All Rights Reserved.
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
  module RSAOtherPrimeInfoImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # 
  # This class represents the triplet (prime, exponent, and coefficient)
  # inside RSA's OtherPrimeInfo structure, as defined in the PKCS#1 v2.1.
  # The ASN.1 syntax of RSA's OtherPrimeInfo is as follows:
  # 
  # <pre>
  # OtherPrimeInfo ::= SEQUENCE {
  # prime INTEGER,
  # exponent INTEGER,
  # coefficient INTEGER
  # }
  # 
  # </pre>
  # 
  # @author Valerie Peng
  # 
  # 
  # @see RSAPrivateCrtKeySpec
  # @see java.security.interfaces.RSAMultiPrimePrivateCrtKey
  # 
  # @since 1.4
  class RSAOtherPrimeInfo 
    include_class_members RSAOtherPrimeInfoImports
    
    attr_accessor :prime
    alias_method :attr_prime, :prime
    undef_method :prime
    alias_method :attr_prime=, :prime=
    undef_method :prime=
    
    attr_accessor :prime_exponent
    alias_method :attr_prime_exponent, :prime_exponent
    undef_method :prime_exponent
    alias_method :attr_prime_exponent=, :prime_exponent=
    undef_method :prime_exponent=
    
    attr_accessor :crt_coefficient
    alias_method :attr_crt_coefficient, :crt_coefficient
    undef_method :crt_coefficient
    alias_method :attr_crt_coefficient=, :crt_coefficient=
    undef_method :crt_coefficient=
    
    typesig { [BigInteger, BigInteger, BigInteger] }
    # 
    # Creates a new <code>RSAOtherPrimeInfo</code>
    # given the prime, primeExponent, and
    # crtCoefficient as defined in PKCS#1.
    # 
    # @param prime the prime factor of n.
    # @param primeExponent the exponent.
    # @param crtCoefficient the Chinese Remainder Theorem
    # coefficient.
    # @exception NullPointerException if any of the parameters, i.e.
    # <code>prime</code>, <code>primeExponent</code>,
    # <code>crtCoefficient</code>, is null.
    def initialize(prime, prime_exponent, crt_coefficient)
      @prime = nil
      @prime_exponent = nil
      @crt_coefficient = nil
      if ((prime).nil?)
        raise NullPointerException.new("the prime parameter must be " + "non-null")
      end
      if ((prime_exponent).nil?)
        raise NullPointerException.new("the primeExponent parameter " + "must be non-null")
      end
      if ((crt_coefficient).nil?)
        raise NullPointerException.new("the crtCoefficient parameter " + "must be non-null")
      end
      @prime = prime
      @prime_exponent = prime_exponent
      @crt_coefficient = crt_coefficient
    end
    
    typesig { [] }
    # 
    # Returns the prime.
    # 
    # @return the prime.
    def get_prime
      return @prime
    end
    
    typesig { [] }
    # 
    # Returns the prime's exponent.
    # 
    # @return the primeExponent.
    def get_exponent
      return @prime_exponent
    end
    
    typesig { [] }
    # 
    # Returns the prime's crtCoefficient.
    # 
    # @return the crtCoefficient.
    def get_crt_coefficient
      return @crt_coefficient
    end
    
    private
    alias_method :initialize__rsaother_prime_info, :initialize
  end
  
end
