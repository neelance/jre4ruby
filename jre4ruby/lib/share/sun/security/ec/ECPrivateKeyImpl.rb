require "rjava"

# Copyright 2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ec
  module ECPrivateKeyImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ec
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include ::Java::Security::Interfaces
      include ::Java::Security::Spec
      include ::Sun::Security::Util
      include_const ::Sun::Security::X509, :AlgorithmId
      include_const ::Sun::Security::Pkcs, :PKCS8Key
    }
  end
  
  # Key implementation for EC private keys.
  # 
  # ASN.1 syntax for EC private keys from SEC 1 v1.5 (draft):
  # 
  # <pre>
  # EXPLICIT TAGS
  # 
  # ECPrivateKey ::= SEQUENCE {
  # version INTEGER { ecPrivkeyVer1(1) } (ecPrivkeyVer1),
  # privateKey OCTET STRING,
  # parameters [0] ECDomainParameters {{ SECGCurveNames }} OPTIONAL,
  # publicKey [1] BIT STRING OPTIONAL
  # }
  # </pre>
  # 
  # We currently ignore the optional parameters and publicKey fields. We
  # require that the parameters are encoded as part of the AlgorithmIdentifier,
  # not in the private key structure.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class ECPrivateKeyImpl < ECPrivateKeyImplImports.const_get :PKCS8Key
    include_class_members ECPrivateKeyImplImports
    overload_protected {
      include ECPrivateKey
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 88695385615075129 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :s
    alias_method :attr_s, :s
    undef_method :s
    alias_method :attr_s=, :s=
    undef_method :s=
    
    # private value
    attr_accessor :params
    alias_method :attr_params, :params
    undef_method :params
    alias_method :attr_params=, :params=
    undef_method :params=
    
    typesig { [Array.typed(::Java::Byte)] }
    # Construct a key from its encoding. Called by the ECKeyFactory and
    # the SunPKCS11 code.
    def initialize(encoded)
      @s = nil
      @params = nil
      super()
      decode(encoded)
    end
    
    typesig { [BigInteger, ECParameterSpec] }
    # Construct a key from its components. Used by the
    # KeyFactory and the SunPKCS11 code.
    def initialize(s, params)
      @s = nil
      @params = nil
      super()
      @s = s
      @params = params
      # generate the encoding
      self.attr_algid = AlgorithmId.new(AlgorithmId::EC_oid, ECParameters.get_algorithm_parameters(params))
      begin
        out = DerOutputStream.new
        out.put_integer(1) # version 1
        priv_bytes = ECParameters.trim_zeroes(s.to_byte_array)
        out.put_octet_string(priv_bytes)
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
      return "EC"
    end
    
    typesig { [] }
    # see JCA doc
    def get_s
      return @s
    end
    
    typesig { [] }
    # see JCA doc
    def get_params
      return @params
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
        if (!(version).equal?(1))
          raise IOException.new("Version must be 1")
        end
        priv_data = data.get_octet_string
        @s = BigInteger.new(1, priv_data)
        while (!(data.available).equal?(0))
          value = data.get_der_value
          if (value.is_context_specific(0))
            # ignore for now
          else
            if (value.is_context_specific(1))
              # ignore for now
            else
              raise InvalidKeyException.new("Unexpected value: " + RJava.cast_to_string(value))
            end
          end
        end
        alg_params = self.attr_algid.get_parameters
        if ((alg_params).nil?)
          raise InvalidKeyException.new("EC domain parameters must be " + "encoded in the algorithm identifier")
        end
        @params = alg_params.get_parameter_spec(ECParameterSpec)
      rescue IOException => e
        raise InvalidKeyException.new("Invalid EC private key", e)
      rescue InvalidParameterSpecException => e
        raise InvalidKeyException.new("Invalid EC private key", e)
      end
    end
    
    typesig { [] }
    # return a string representation of this key for debugging
    def to_s
      return "Sun EC private key, " + RJava.cast_to_string(@params.get_curve.get_field.get_field_size) + " bits\n  private value:  " + RJava.cast_to_string(@s) + "\n  parameters: " + RJava.cast_to_string(@params)
    end
    
    private
    alias_method :initialize__ecprivate_key_impl, :initialize
  end
  
end
