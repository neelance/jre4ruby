require "rjava"

# Copyright 1997-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security
  module AlgorithmParametersSpiImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Io
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include_const ::Java::Security::Spec, :InvalidParameterSpecException
    }
  end
  
  # This class defines the <i>Service Provider Interface</i> (<b>SPI</b>)
  # for the <code>AlgorithmParameters</code> class, which is used to manage
  # algorithm parameters.
  # 
  # <p> All the abstract methods in this class must be implemented by each
  # cryptographic service provider who wishes to supply parameter management
  # for a particular algorithm.
  # 
  # @author Jan Luehe
  # 
  # 
  # @see AlgorithmParameters
  # @see java.security.spec.AlgorithmParameterSpec
  # @see java.security.spec.DSAParameterSpec
  # 
  # @since 1.2
  class AlgorithmParametersSpi 
    include_class_members AlgorithmParametersSpiImports
    
    typesig { [AlgorithmParameterSpec] }
    # Initializes this parameters object using the parameters
    # specified in <code>paramSpec</code>.
    # 
    # @param paramSpec the parameter specification.
    # 
    # @exception InvalidParameterSpecException if the given parameter
    # specification is inappropriate for the initialization of this parameter
    # object.
    def engine_init(param_spec)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Imports the specified parameters and decodes them
    # according to the primary decoding format for parameters.
    # The primary decoding format for parameters is ASN.1, if an ASN.1
    # specification for this type of parameters exists.
    # 
    # @param params the encoded parameters.
    # 
    # @exception IOException on decoding errors
    def engine_init(params)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte), String] }
    # Imports the parameters from <code>params</code> and
    # decodes them according to the specified decoding format.
    # If <code>format</code> is null, the
    # primary decoding format for parameters is used. The primary decoding
    # format is ASN.1, if an ASN.1 specification for these parameters
    # exists.
    # 
    # @param params the encoded parameters.
    # 
    # @param format the name of the decoding format.
    # 
    # @exception IOException on decoding errors
    def engine_init(params, format)
      raise NotImplementedError
    end
    
    typesig { [Class] }
    # Returns a (transparent) specification of this parameters
    # object.
    # <code>paramSpec</code> identifies the specification class in which
    # the parameters should be returned. It could, for example, be
    # <code>DSAParameterSpec.class</code>, to indicate that the
    # parameters should be returned in an instance of the
    # <code>DSAParameterSpec</code> class.
    # 
    # @param paramSpec the the specification class in which
    # the parameters should be returned.
    # 
    # @return the parameter specification.
    # 
    # @exception InvalidParameterSpecException if the requested parameter
    # specification is inappropriate for this parameter object.
    def engine_get_parameter_spec(param_spec)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the parameters in their primary encoding format.
    # The primary encoding format for parameters is ASN.1, if an ASN.1
    # specification for this type of parameters exists.
    # 
    # @return the parameters encoded using their primary encoding format.
    # 
    # @exception IOException on encoding errors.
    def engine_get_encoded
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Returns the parameters encoded in the specified format.
    # If <code>format</code> is null, the
    # primary encoding format for parameters is used. The primary encoding
    # format is ASN.1, if an ASN.1 specification for these parameters
    # exists.
    # 
    # @param format the name of the encoding format.
    # 
    # @return the parameters encoded using the specified encoding scheme.
    # 
    # @exception IOException on encoding errors.
    def engine_get_encoded(format)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a formatted string describing the parameters.
    # 
    # @return a formatted string describing the parameters.
    def engine_to_string
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__algorithm_parameters_spi, :initialize
  end
  
end
