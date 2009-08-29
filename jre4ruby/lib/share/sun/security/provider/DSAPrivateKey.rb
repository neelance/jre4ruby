require "rjava"

# Copyright 1996-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DSAPrivateKeyImports #:nodoc:
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
      include_const ::Sun::Security::X509, :AlgIdDSA
      include_const ::Sun::Security::Pkcs, :PKCS8Key
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :DerInputStream
      include_const ::Sun::Security::Util, :DerOutputStream
    }
  end
  
  # A PKCS#8 private key for the Digital Signature Algorithm.
  # 
  # @author Benjamin Renaud
  # 
  # 
  # @see DSAPublicKey
  # @see AlgIdDSA
  # @see DSA
  class DSAPrivateKey < DSAPrivateKeyImports.const_get :PKCS8Key
    include_class_members DSAPrivateKeyImports
    overload_protected {
      include Java::Security::Interfaces::DSAPrivateKey
      include Serializable
    }
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.1. for interoperability
      const_set_lazy(:SerialVersionUID) { -3244453684193605938 }
      const_attr_reader  :SerialVersionUID
    }
    
    # the private key
    attr_accessor :x
    alias_method :attr_x, :x
    undef_method :x
    alias_method :attr_x=, :x=
    undef_method :x=
    
    typesig { [] }
    # Keep this constructor for backwards compatibility with JDK1.1.
    def initialize
      @x = nil
      super()
    end
    
    typesig { [BigInteger, BigInteger, BigInteger, BigInteger] }
    # Make a DSA private key out of a private key and three parameters.
    def initialize(x, p, q, g)
      @x = nil
      super()
      @x = x
      self.attr_algid = AlgIdDSA.new(p, q, g)
      begin
        self.attr_key = DerValue.new(DerValue.attr_tag_integer, x.to_byte_array).to_byte_array
        encode
      rescue IOException => e
        ike = InvalidKeyException.new("could not DER encode x: " + RJava.cast_to_string(e.get_message))
        ike.init_cause(e)
        raise ike
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Make a DSA private key from its DER encoding (PKCS #8).
    def initialize(encoded)
      @x = nil
      super()
      clear_old_key
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
    # Get the raw private key, x, without the parameters.
    # 
    # @see getParameters
    def get_x
      return @x
    end
    
    typesig { [] }
    def clear_old_key
      i = 0
      if (!(self.attr_encoded_key).nil?)
        i = 0
        while i < self.attr_encoded_key.attr_length
          self.attr_encoded_key[i] = 0x0
          i += 1
        end
      end
      if (!(self.attr_key).nil?)
        i = 0
        while i < self.attr_key.attr_length
          self.attr_key[i] = 0x0
          i += 1
        end
      end
    end
    
    typesig { [] }
    def to_s
      return "Sun DSA Private Key \nparameters:" + RJava.cast_to_string(self.attr_algid) + "\nx: " + RJava.cast_to_string(Debug.to_hex_string(@x)) + "\n"
    end
    
    typesig { [] }
    def parse_key_bits
      begin
        in_ = DerInputStream.new(self.attr_key)
        @x = in_.get_big_integer
      rescue IOException => e
        ike = InvalidKeyException.new(e.get_message)
        ike.init_cause(e)
        raise ike
      end
    end
    
    private
    alias_method :initialize__dsaprivate_key, :initialize
  end
  
end
