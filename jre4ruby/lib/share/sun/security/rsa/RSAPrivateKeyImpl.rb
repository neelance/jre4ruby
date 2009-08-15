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
  module RSAPrivateKeyImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Rsa
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include ::Java::Security::Interfaces
      include ::Sun::Security::Util
      include_const ::Sun::Security::Pkcs, :PKCS8Key
    }
  end
  
  # Key implementation for RSA private keys, non-CRT form (modulus, private
  # exponent only). For CRT private keys, see RSAPrivateCrtKeyImpl. We need
  # separate classes to ensure correct behavior in instanceof checks, etc.
  # 
  # Note: RSA keys must be at least 512 bits long
  # 
  # @see RSAPrivateCrtKeyImpl
  # @see RSAKeyFactory
  # 
  # @since   1.5
  # @author  Andreas Sterbenz
  class RSAPrivateKeyImpl < RSAPrivateKeyImplImports.const_get :PKCS8Key
    include_class_members RSAPrivateKeyImplImports
    overload_protected {
      include RSAPrivateKey
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -33106691987952810 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :n
    alias_method :attr_n, :n
    undef_method :n
    alias_method :attr_n=, :n=
    undef_method :n=
    
    # modulus
    attr_accessor :d
    alias_method :attr_d, :d
    undef_method :d
    alias_method :attr_d=, :d=
    undef_method :d=
    
    typesig { [BigInteger, BigInteger] }
    # private exponent
    # 
    # Construct a key from its components. Used by the
    # RSAKeyFactory and the RSAKeyPairGenerator.
    def initialize(n, d)
      @n = nil
      @d = nil
      super()
      @n = n
      @d = d
      RSAKeyFactory.check_rsaprovider_key_lengths(n.bit_length, nil)
      # generate the encoding
      self.attr_algid = RSAPrivateCrtKeyImpl.attr_rsa_id
      begin
        out = DerOutputStream.new
        out.put_integer(0) # version must be 0
        out.put_integer(n)
        out.put_integer(0)
        out.put_integer(d)
        out.put_integer(0)
        out.put_integer(0)
        out.put_integer(0)
        out.put_integer(0)
        out.put_integer(0)
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
    def get_private_exponent
      return @d
    end
    
    typesig { [] }
    # return a string representation of this key for debugging
    def to_s
      return "Sun RSA private key, " + RJava.cast_to_string(@n.bit_length) + " bits\n  modulus: " + RJava.cast_to_string(@n) + "\n  private exponent: " + RJava.cast_to_string(@d)
    end
    
    private
    alias_method :initialize__rsaprivate_key_impl, :initialize
  end
  
end
