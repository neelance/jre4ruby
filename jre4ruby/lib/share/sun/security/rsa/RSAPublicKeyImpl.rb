require "rjava"

# Copyright 2003-2008 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Rsa
  module RSAPublicKeyImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Rsa
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include ::Java::Security::Interfaces
      include ::Sun::Security::Util
      include_const ::Sun::Security::X509, :X509Key
    }
  end
  
  # Key implementation for RSA public keys.
  # 
  # Note: RSA keys must be at least 512 bits long
  # 
  # @see RSAPrivateCrtKeyImpl
  # @see RSAKeyFactory
  # 
  # @since   1.5
  # @author  Andreas Sterbenz
  class RSAPublicKeyImpl < RSAPublicKeyImplImports.const_get :X509Key
    include_class_members RSAPublicKeyImplImports
    overload_protected {
      include RSAPublicKey
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 2644735423591199609 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :n
    alias_method :attr_n, :n
    undef_method :n
    alias_method :attr_n=, :n=
    undef_method :n=
    
    # modulus
    attr_accessor :e
    alias_method :attr_e, :e
    undef_method :e
    alias_method :attr_e=, :e=
    undef_method :e=
    
    typesig { [BigInteger, BigInteger] }
    # public exponent
    # 
    # Construct a key from its components. Used by the
    # RSAKeyFactory and the RSAKeyPairGenerator.
    def initialize(n, e)
      @n = nil
      @e = nil
      super()
      @n = n
      @e = e
      RSAKeyFactory.check_rsaprovider_key_lengths(n.bit_length, e)
      # generate the encoding
      self.attr_algid = RSAPrivateCrtKeyImpl.attr_rsa_id
      begin
        out = DerOutputStream.new
        out.put_integer(n)
        out.put_integer(e)
        val = DerValue.new(DerValue.attr_tag_sequence, out.to_byte_array)
        self.attr_key = val.to_byte_array
      rescue IOException => exc
        # should never occur
        raise InvalidKeyException.new(exc)
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Construct a key from its encoding. Used by RSAKeyFactory.
    def initialize(encoded)
      @n = nil
      @e = nil
      super()
      decode(encoded)
      RSAKeyFactory.check_rsaprovider_key_lengths(@n.bit_length, @e)
    end
    
    typesig { [] }
    # see JCA doc
    def get_algorithm
      return "RSA"
    end
    
    typesig { [] }
    # see JCA doc
    def get_modulus
      return @n
    end
    
    typesig { [] }
    # see JCA doc
    def get_public_exponent
      return @e
    end
    
    typesig { [] }
    # Parse the key. Called by X509Key.
    def parse_key_bits
      begin
        in_ = DerInputStream.new(self.attr_key)
        der_value = in_.get_der_value
        if (!(der_value.attr_tag).equal?(DerValue.attr_tag_sequence))
          raise IOException.new("Not a SEQUENCE")
        end
        data = der_value.attr_data
        @n = RSAPrivateCrtKeyImpl.get_big_integer(data)
        @e = RSAPrivateCrtKeyImpl.get_big_integer(data)
        if (!(der_value.attr_data.available).equal?(0))
          raise IOException.new("Extra data available")
        end
      rescue IOException => e
        raise InvalidKeyException.new("Invalid RSA public key", e)
      end
    end
    
    typesig { [] }
    # return a string representation of this key for debugging
    def to_s
      return "Sun RSA public key, " + RJava.cast_to_string(@n.bit_length) + " bits\n  modulus: " + RJava.cast_to_string(@n) + "\n  public exponent: " + RJava.cast_to_string(@e)
    end
    
    typesig { [] }
    def write_replace
      return KeyRep.new(KeyRep::Type::PUBLIC, get_algorithm, get_format, get_encoded)
    end
    
    private
    alias_method :initialize__rsapublic_key_impl, :initialize
  end
  
end
