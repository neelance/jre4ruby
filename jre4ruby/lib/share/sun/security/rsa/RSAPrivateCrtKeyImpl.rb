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
  module RSAPrivateCrtKeyImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Rsa
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include ::Java::Security::Interfaces
      include ::Sun::Security::Util
      include_const ::Sun::Security::X509, :AlgorithmId
      include_const ::Sun::Security::Pkcs, :PKCS8Key
    }
  end
  
  # Key implementation for RSA private keys, CRT form. For non-CRT private
  # keys, see RSAPrivateKeyImpl. We need separate classes to ensure
  # correct behavior in instanceof checks, etc.
  # 
  # Note: RSA keys must be at least 512 bits long
  # 
  # @see RSAPrivateKeyImpl
  # @see RSAKeyFactory
  # 
  # @since   1.5
  # @author  Andreas Sterbenz
  class RSAPrivateCrtKeyImpl < RSAPrivateCrtKeyImplImports.const_get :PKCS8Key
    include_class_members RSAPrivateCrtKeyImplImports
    overload_protected {
      include RSAPrivateCrtKey
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -1326088454257084918 }
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
    
    # public exponent
    attr_accessor :d
    alias_method :attr_d, :d
    undef_method :d
    alias_method :attr_d=, :d=
    undef_method :d=
    
    # private exponent
    attr_accessor :p
    alias_method :attr_p, :p
    undef_method :p
    alias_method :attr_p=, :p=
    undef_method :p=
    
    # prime p
    attr_accessor :q
    alias_method :attr_q, :q
    undef_method :q
    alias_method :attr_q=, :q=
    undef_method :q=
    
    # prime q
    attr_accessor :pe
    alias_method :attr_pe, :pe
    undef_method :pe
    alias_method :attr_pe=, :pe=
    undef_method :pe=
    
    # prime exponent p
    attr_accessor :qe
    alias_method :attr_qe, :qe
    undef_method :qe
    alias_method :attr_qe=, :qe=
    undef_method :qe=
    
    # prime exponent q
    attr_accessor :coeff
    alias_method :attr_coeff, :coeff
    undef_method :coeff
    alias_method :attr_coeff=, :coeff=
    undef_method :coeff=
    
    class_module.module_eval {
      # CRT coeffcient
      # algorithmId used to identify RSA keys
      const_set_lazy(:RsaId) { AlgorithmId.new(AlgorithmId::RSAEncryption_oid) }
      const_attr_reader  :RsaId
      
      typesig { [Array.typed(::Java::Byte)] }
      # Generate a new key from its encoding. Returns a CRT key if possible
      # and a non-CRT key otherwise. Used by RSAKeyFactory.
      def new_key(encoded)
        key = RSAPrivateCrtKeyImpl.new(encoded)
        if ((key.get_public_exponent.signum).equal?(0))
          # public exponent is missing, return a non-CRT key
          return RSAPrivateKeyImpl.new(key.get_modulus, key.get_private_exponent)
        else
          return key
        end
      end
    }
    
    typesig { [Array.typed(::Java::Byte)] }
    # Construct a key from its encoding. Called from newKey above.
    def initialize(encoded)
      @n = nil
      @e = nil
      @d = nil
      @p = nil
      @q = nil
      @pe = nil
      @qe = nil
      @coeff = nil
      super()
      decode(encoded)
      RSAKeyFactory.check_rsaprovider_key_lengths(@n.bit_length, @e)
    end
    
    typesig { [BigInteger, BigInteger, BigInteger, BigInteger, BigInteger, BigInteger, BigInteger, BigInteger] }
    # Construct a key from its components. Used by the
    # RSAKeyFactory and the RSAKeyPairGenerator.
    def initialize(n, e, d, p, q, pe, qe, coeff)
      @n = nil
      @e = nil
      @d = nil
      @p = nil
      @q = nil
      @pe = nil
      @qe = nil
      @coeff = nil
      super()
      @n = n
      @e = e
      @d = d
      @p = p
      @q = q
      @pe = pe
      @qe = qe
      @coeff = coeff
      RSAKeyFactory.check_rsaprovider_key_lengths(n.bit_length, e)
      # generate the encoding
      self.attr_algid = RsaId
      begin
        out = DerOutputStream.new
        out.put_integer(0) # version must be 0
        out.put_integer(n)
        out.put_integer(e)
        out.put_integer(d)
        out.put_integer(p)
        out.put_integer(q)
        out.put_integer(pe)
        out.put_integer(qe)
        out.put_integer(coeff)
        val = DerValue.new(DerValue.attr_tag_sequence, out.to_byte_array)
        self.attr_key = val.to_byte_array
      rescue IOException => exc
        # should never occur
        raise InvalidKeyException.new(exc)
      end
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
    # see JCA doc
    def get_private_exponent
      return @d
    end
    
    typesig { [] }
    # see JCA doc
    def get_prime_p
      return @p
    end
    
    typesig { [] }
    # see JCA doc
    def get_prime_q
      return @q
    end
    
    typesig { [] }
    # see JCA doc
    def get_prime_exponent_p
      return @pe
    end
    
    typesig { [] }
    # see JCA doc
    def get_prime_exponent_q
      return @qe
    end
    
    typesig { [] }
    # see JCA doc
    def get_crt_coefficient
      return @coeff
    end
    
    typesig { [] }
    # Parse the key. Called by PKCS8Key.
    def parse_key_bits
      begin
        in_ = DerInputStream.new(self.attr_key)
        der_value = in_.get_der_value
        if (!(der_value.attr_tag).equal?(DerValue.attr_tag_sequence))
          raise IOException.new("Not a SEQUENCE")
        end
        data = der_value.attr_data
        version = data.get_integer
        if (!(version).equal?(0))
          raise IOException.new("Version must be 0")
        end
        @n = get_big_integer(data)
        @e = get_big_integer(data)
        @d = get_big_integer(data)
        @p = get_big_integer(data)
        @q = get_big_integer(data)
        @pe = get_big_integer(data)
        @qe = get_big_integer(data)
        @coeff = get_big_integer(data)
        if (!(der_value.attr_data.available).equal?(0))
          raise IOException.new("Extra data available")
        end
      rescue IOException => e
        raise InvalidKeyException.new("Invalid RSA private key", e)
      end
    end
    
    class_module.module_eval {
      typesig { [DerInputStream] }
      # Read a BigInteger from the DerInputStream.
      def get_big_integer(data)
        b = data.get_big_integer
        # Some implementations do not correctly encode ASN.1 INTEGER values
        # in 2's complement format, resulting in a negative integer when
        # decoded. Correct the error by converting it to a positive integer.
        # 
        # See CR 6255949
        if (b.signum < 0)
          b = BigInteger.new(1, b.to_byte_array)
        end
        return b
      end
    }
    
    typesig { [] }
    # return a string representation of this key for debugging
    def to_s
      sb = StringBuffer.new
      sb.append("Sun RSA private CRT key, ")
      sb.append(@n.bit_length)
      sb.append(" bits\n  modulus:          ")
      sb.append(@n)
      sb.append("\n  public exponent:  ")
      sb.append(@e)
      sb.append("\n  private exponent: ")
      sb.append(@d)
      sb.append("\n  prime p:          ")
      sb.append(@p)
      sb.append("\n  prime q:          ")
      sb.append(@q)
      sb.append("\n  prime exponent p: ")
      sb.append(@pe)
      sb.append("\n  prime exponent q: ")
      sb.append(@qe)
      sb.append("\n  crt coefficient:  ")
      sb.append(@coeff)
      return sb.to_s
    end
    
    private
    alias_method :initialize__rsaprivate_crt_key_impl, :initialize
  end
  
end
