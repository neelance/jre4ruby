require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DSAParametersImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include ::Java::Util
      include ::Java::Io
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Security, :AlgorithmParametersSpi
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include_const ::Java::Security::Spec, :DSAParameterSpec
      include_const ::Java::Security::Spec, :InvalidParameterSpecException
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :DerOutputStream
    }
  end
  
  # This class implements the parameter set used by the
  # Digital Signature Algorithm as specified in the FIPS 186
  # standard.
  # 
  # @author Jan Luehe
  # 
  # 
  # @since 1.2
  class DSAParameters < DSAParametersImports.const_get :AlgorithmParametersSpi
    include_class_members DSAParametersImports
    
    # the prime (p)
    attr_accessor :p
    alias_method :attr_p, :p
    undef_method :p
    alias_method :attr_p=, :p=
    undef_method :p=
    
    # the sub-prime (q)
    attr_accessor :q
    alias_method :attr_q, :q
    undef_method :q
    alias_method :attr_q=, :q=
    undef_method :q=
    
    # the base (g)
    attr_accessor :g
    alias_method :attr_g, :g
    undef_method :g
    alias_method :attr_g=, :g=
    undef_method :g=
    
    typesig { [AlgorithmParameterSpec] }
    def engine_init(param_spec)
      if (!(param_spec.is_a?(DSAParameterSpec)))
        raise InvalidParameterSpecException.new("Inappropriate parameter specification")
      end
      @p = (param_spec).get_p
      @q = (param_spec).get_q
      @g = (param_spec).get_g
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def engine_init(params)
      encoded_params = DerValue.new(params)
      if (!(encoded_params.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("DSA params parsing error")
      end
      encoded_params.attr_data.reset
      @p = encoded_params.attr_data.get_big_integer
      @q = encoded_params.attr_data.get_big_integer
      @g = encoded_params.attr_data.get_big_integer
      if (!(encoded_params.attr_data.available).equal?(0))
        raise IOException.new("encoded params have " + (encoded_params.attr_data.available).to_s + " extra bytes")
      end
    end
    
    typesig { [Array.typed(::Java::Byte), String] }
    def engine_init(params, decoding_method)
      engine_init(params)
    end
    
    typesig { [Class] }
    def engine_get_parameter_spec(param_spec)
      begin
        dsa_param_spec = Class.for_name("java.security.spec.DSAParameterSpec")
        if (dsa_param_spec.is_assignable_from(param_spec))
          return DSAParameterSpec.new(@p, @q, @g)
        else
          raise InvalidParameterSpecException.new("Inappropriate parameter Specification")
        end
      rescue ClassNotFoundException => e
        raise InvalidParameterSpecException.new("Unsupported parameter specification: " + (e.get_message).to_s)
      end
    end
    
    typesig { [] }
    def engine_get_encoded
      out = DerOutputStream.new
      bytes = DerOutputStream.new
      bytes.put_integer(@p)
      bytes.put_integer(@q)
      bytes.put_integer(@g)
      out.write(DerValue.attr_tag_sequence, bytes)
      return out.to_byte_array
    end
    
    typesig { [String] }
    def engine_get_encoded(encoding_method)
      return engine_get_encoded
    end
    
    typesig { [] }
    # Returns a formatted string describing the parameters.
    def engine_to_string
      return "\n\tp: " + (Debug.to_hex_string(@p)).to_s + "\n\tq: " + (Debug.to_hex_string(@q)).to_s + "\n\tg: " + (Debug.to_hex_string(@g)).to_s + "\n"
    end
    
    typesig { [] }
    def initialize
      @p = nil
      @q = nil
      @g = nil
      super()
    end
    
    private
    alias_method :initialize__dsaparameters, :initialize
  end
  
end
