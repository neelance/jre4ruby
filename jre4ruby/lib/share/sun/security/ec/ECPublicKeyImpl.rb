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
  module ECPublicKeyImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ec
      include_const ::Java::Io, :IOException
      include ::Java::Security
      include ::Java::Security::Interfaces
      include ::Java::Security::Spec
      include ::Sun::Security::Util
      include ::Sun::Security::X509
    }
  end
  
  # Key implementation for EC public keys.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class ECPublicKeyImpl < ECPublicKeyImplImports.const_get :X509Key
    include_class_members ECPublicKeyImplImports
    overload_protected {
      include ECPublicKey
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -2462037275160462289 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :w
    alias_method :attr_w, :w
    undef_method :w
    alias_method :attr_w=, :w=
    undef_method :w=
    
    attr_accessor :params
    alias_method :attr_params, :params
    undef_method :params
    alias_method :attr_params=, :params=
    undef_method :params=
    
    typesig { [ECPoint, ECParameterSpec] }
    # Construct a key from its components. Used by the
    # ECKeyFactory and SunPKCS11.
    def initialize(w, params)
      @w = nil
      @params = nil
      super()
      @w = w
      @params = params
      # generate the encoding
      self.attr_algid = AlgorithmId.new(AlgorithmId::EC_oid, ECParameters.get_algorithm_parameters(params))
      self.attr_key = ECParameters.encode_point(w, params.get_curve)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Construct a key from its encoding. Used by RSAKeyFactory.
    def initialize(encoded)
      @w = nil
      @params = nil
      super()
      decode(encoded)
    end
    
    typesig { [] }
    # see JCA doc
    def get_algorithm
      return "EC"
    end
    
    typesig { [] }
    # see JCA doc
    def get_w
      return @w
    end
    
    typesig { [] }
    # see JCA doc
    def get_params
      return @params
    end
    
    typesig { [] }
    # Internal API to get the encoded point. Currently used by SunPKCS11.
    # This may change/go away depending on what we do with the public API.
    def get_encoded_public_value
      return self.attr_key.clone
    end
    
    typesig { [] }
    # Parse the key. Called by X509Key.
    def parse_key_bits
      begin
        alg_params = self.attr_algid.get_parameters
        @params = alg_params.get_parameter_spec(ECParameterSpec)
        @w = ECParameters.decode_point(self.attr_key, @params.get_curve)
      rescue IOException => e
        raise InvalidKeyException.new("Invalid EC key", e)
      rescue InvalidParameterSpecException => e
        raise InvalidKeyException.new("Invalid EC key", e)
      end
    end
    
    typesig { [] }
    # return a string representation of this key for debugging
    def to_s
      return "Sun EC public key, " + RJava.cast_to_string(@params.get_curve.get_field.get_field_size) + " bits\n  public x coord: " + RJava.cast_to_string(@w.get_affine_x) + "\n  public y coord: " + RJava.cast_to_string(@w.get_affine_y) + "\n  parameters: " + RJava.cast_to_string(@params)
    end
    
    typesig { [] }
    def write_replace
      return KeyRep.new(KeyRep::Type::PUBLIC, get_algorithm, get_format, get_encoded)
    end
    
    private
    alias_method :initialize__ecpublic_key_impl, :initialize
  end
  
end
