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
module Java::Security::Spec
  module RSAMultiPrimePrivateCrtKeySpecImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Spec
      include_const ::Java::Math, :BigInteger
    }
  end
  
  # This class specifies an RSA multi-prime private key, as defined in the
  # PKCS#1 v2.1, using the Chinese Remainder Theorem (CRT) information
  # values for efficiency.
  # 
  # @author Valerie Peng
  # 
  # 
  # @see java.security.Key
  # @see java.security.KeyFactory
  # @see KeySpec
  # @see PKCS8EncodedKeySpec
  # @see RSAPrivateKeySpec
  # @see RSAPublicKeySpec
  # @see RSAOtherPrimeInfo
  # 
  # @since 1.4
  class RSAMultiPrimePrivateCrtKeySpec < RSAMultiPrimePrivateCrtKeySpecImports.const_get :RSAPrivateKeySpec
    include_class_members RSAMultiPrimePrivateCrtKeySpecImports
    
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
    
    attr_accessor :other_prime_info
    alias_method :attr_other_prime_info, :other_prime_info
    undef_method :other_prime_info
    alias_method :attr_other_prime_info=, :other_prime_info=
    undef_method :other_prime_info=
    
    typesig { [BigInteger, BigInteger, BigInteger, BigInteger, BigInteger, BigInteger, BigInteger, BigInteger, Array.typed(RSAOtherPrimeInfo)] }
    # Creates a new <code>RSAMultiPrimePrivateCrtKeySpec</code>
    # given the modulus, publicExponent, privateExponent,
    # primeP, primeQ, primeExponentP, primeExponentQ,
    # crtCoefficient, and otherPrimeInfo as defined in PKCS#1 v2.1.
    # 
    # <p>Note that the contents of <code>otherPrimeInfo</code>
    # are copied to protect against subsequent modification when
    # constructing this object.
    # 
    # @param modulus the modulus n.
    # @param publicExponent the public exponent e.
    # @param privateExponent the private exponent d.
    # @param primeP the prime factor p of n.
    # @param primeQ the prime factor q of n.
    # @param primeExponentP this is d mod (p-1).
    # @param primeExponentQ this is d mod (q-1).
    # @param crtCoefficient the Chinese Remainder Theorem
    # coefficient q-1 mod p.
    # @param otherPrimeInfo triplets of the rest of primes, null can be
    # specified if there are only two prime factors (p and q).
    # @exception NullPointerException if any of the parameters, i.e.
    # <code>modulus</code>,
    # <code>publicExponent</code>, <code>privateExponent</code>,
    # <code>primeP</code>, <code>primeQ</code>,
    # <code>primeExponentP</code>, <code>primeExponentQ</code>,
    # <code>crtCoefficient</code>, is null.
    # @exception IllegalArgumentException if an empty, i.e. 0-length,
    # <code>otherPrimeInfo</code> is specified.
    def initialize(modulus, public_exponent, private_exponent, prime_p, prime_q, prime_exponent_p, prime_exponent_q, crt_coefficient, other_prime_info)
      @public_exponent = nil
      @prime_p = nil
      @prime_q = nil
      @prime_exponent_p = nil
      @prime_exponent_q = nil
      @crt_coefficient = nil
      @other_prime_info = nil
      super(modulus, private_exponent)
      if ((modulus).nil?)
        raise NullPointerException.new("the modulus parameter must be " + "non-null")
      end
      if ((public_exponent).nil?)
        raise NullPointerException.new("the publicExponent parameter " + "must be non-null")
      end
      if ((private_exponent).nil?)
        raise NullPointerException.new("the privateExponent parameter " + "must be non-null")
      end
      if ((prime_p).nil?)
        raise NullPointerException.new("the primeP parameter " + "must be non-null")
      end
      if ((prime_q).nil?)
        raise NullPointerException.new("the primeQ parameter " + "must be non-null")
      end
      if ((prime_exponent_p).nil?)
        raise NullPointerException.new("the primeExponentP parameter " + "must be non-null")
      end
      if ((prime_exponent_q).nil?)
        raise NullPointerException.new("the primeExponentQ parameter " + "must be non-null")
      end
      if ((crt_coefficient).nil?)
        raise NullPointerException.new("the crtCoefficient parameter " + "must be non-null")
      end
      @public_exponent = public_exponent
      @prime_p = prime_p
      @prime_q = prime_q
      @prime_exponent_p = prime_exponent_p
      @prime_exponent_q = prime_exponent_q
      @crt_coefficient = crt_coefficient
      if ((other_prime_info).nil?)
        @other_prime_info = nil
      else
        if ((other_prime_info.attr_length).equal?(0))
          raise IllegalArgumentException.new("the otherPrimeInfo " + "parameter must not be empty")
        else
          @other_prime_info = other_prime_info.clone
        end
      end
    end
    
    typesig { [] }
    # Returns the public exponent.
    # 
    # @return the public exponent.
    def get_public_exponent
      return @public_exponent
    end
    
    typesig { [] }
    # Returns the primeP.
    # 
    # @return the primeP.
    def get_prime_p
      return @prime_p
    end
    
    typesig { [] }
    # Returns the primeQ.
    # 
    # @return the primeQ.
    def get_prime_q
      return @prime_q
    end
    
    typesig { [] }
    # Returns the primeExponentP.
    # 
    # @return the primeExponentP.
    def get_prime_exponent_p
      return @prime_exponent_p
    end
    
    typesig { [] }
    # Returns the primeExponentQ.
    # 
    # @return the primeExponentQ.
    def get_prime_exponent_q
      return @prime_exponent_q
    end
    
    typesig { [] }
    # Returns the crtCoefficient.
    # 
    # @return the crtCoefficient.
    def get_crt_coefficient
      return @crt_coefficient
    end
    
    typesig { [] }
    # Returns a copy of the otherPrimeInfo or null if there are
    # only two prime factors (p and q).
    # 
    # @return the otherPrimeInfo. Returns a new array each
    # time this method is called.
    def get_other_prime_info
      if ((@other_prime_info).nil?)
        return nil
      end
      return @other_prime_info.clone
    end
    
    private
    alias_method :initialize__rsamulti_prime_private_crt_key_spec, :initialize
  end
  
end
