require "rjava"

# Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Provider
  module DSAPublicKeyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include ::Java::Util
      include ::Java::Io
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Security, :InvalidKeyException
      include_const ::Java::Security, :ProviderException
      include_const ::Java::Security, :AlgorithmParameters
      include_const ::Java::Security::Spec, :DSAParameterSpec
      include_const ::Java::Security::Spec, :InvalidParameterSpecException
      include_const ::Java::Security::Interfaces, :DSAParams
      include_const ::Sun::Security::X509, :X509Key
      include_const ::Sun::Security::X509, :AlgIdDSA
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :DerInputStream
      include_const ::Sun::Security::Util, :DerOutputStream
    }
  end
  
  # An X.509 public key for the Digital Signature Algorithm.
  # 
  # @author Benjamin Renaud
  # 
  # 
  # @see DSAPrivateKey
  # @see AlgIdDSA
  # @see DSA
  class DSAPublicKey < DSAPublicKeyImports.const_get :X509Key
    include_class_members DSAPublicKeyImports
    overload_protected {
      include Java::Security::Interfaces::DSAPublicKey
      include Serializable
    }
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.1. for interoperability
      const_set_lazy(:SerialVersionUID) { -2994193307391104133 }
      const_attr_reader  :SerialVersionUID
    }
    
    # the public key
    attr_accessor :y
    alias_method :attr_y, :y
    undef_method :y
    alias_method :attr_y=, :y=
    undef_method :y=
    
    typesig { [] }
    # Keep this constructor for backwards compatibility with JDK1.1.
    def initialize
      @y = nil
      super()
    end
    
    typesig { [BigInteger, BigInteger, BigInteger, BigInteger] }
    # Make a DSA public key out of a public key and three parameters.
    # The p, q, and g parameters may be null, but if so, parameters will need
    # to be supplied from some other source before this key can be used in
    # cryptographic operations.  PKIX RFC2459bis explicitly allows DSA public
    # keys without parameters, where the parameters are provided in the
    # issuer's DSA public key.
    # 
    # @param y the actual key bits
    # @param p DSA parameter p, may be null if all of p, q, and g are null.
    # @param q DSA parameter q, may be null if all of p, q, and g are null.
    # @param g DSA parameter g, may be null if all of p, q, and g are null.
    def initialize(y, p, q, g)
      @y = nil
      super()
      @y = y
      self.attr_algid = AlgIdDSA.new(p, q, g)
      begin
        self.attr_key = DerValue.new(DerValue.attr_tag_integer, y.to_byte_array).to_byte_array
        encode
      rescue IOException => e
        raise InvalidKeyException.new("could not DER encode y: " + RJava.cast_to_string(e.get_message))
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Make a DSA public key from its DER encoding (X.509).
    def initialize(encoded)
      @y = nil
      super()
      decode(encoded)
    end
    
    typesig { [] }
    # Returns the DSA parameters associated with this key, or null if the
    # parameters could not be parsed.
    def get_params
      begin
        if (self.attr_algid.is_a?(DSAParams))
          return self.attr_algid
        else
          param_spec = nil
          alg_params = self.attr_algid.get_parameters
          if ((alg_params).nil?)
            return nil
          end
          param_spec = alg_params.get_parameter_spec(DSAParameterSpec)
          return param_spec
        end
      rescue InvalidParameterSpecException => e
        return nil
      end
    end
    
    typesig { [] }
    # Get the raw public value, y, without the parameters.
    # 
    # @see getParameters
    def get_y
      return @y
    end
    
    typesig { [] }
    def to_s
      return "Sun DSA Public Key\n    Parameters:" + RJava.cast_to_string(self.attr_algid) + "\n  y:\n" + RJava.cast_to_string(Debug.to_hex_string(@y)) + "\n"
    end
    
    typesig { [] }
    def parse_key_bits
      begin
        in_ = DerInputStream.new(self.attr_key)
        @y = in_.get_big_integer
      rescue IOException => e
        raise InvalidKeyException.new("Invalid key: y value\n" + RJava.cast_to_string(e.get_message))
      end
    end
    
    private
    alias_method :initialize__dsapublic_key, :initialize
  end
  
end
