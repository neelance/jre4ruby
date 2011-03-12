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
module Java::Security
  module AlgorithmParametersImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Io
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include_const ::Java::Security::Spec, :InvalidParameterSpecException
    }
  end
  
  # This class is used as an opaque representation of cryptographic parameters.
  # 
  # <p>An <code>AlgorithmParameters</code> object for managing the parameters
  # for a particular algorithm can be obtained by
  # calling one of the <code>getInstance</code> factory methods
  # (static methods that return instances of a given class).
  # 
  # <p>Once an <code>AlgorithmParameters</code> object is obtained, it must be
  # initialized via a call to <code>init</code>, using an appropriate parameter
  # specification or parameter encoding.
  # 
  # <p>A transparent parameter specification is obtained from an
  # <code>AlgorithmParameters</code> object via a call to
  # <code>getParameterSpec</code>, and a byte encoding of the parameters is
  # obtained via a call to <code>getEncoded</code>.
  # 
  # @author Jan Luehe
  # 
  # 
  # @see java.security.spec.AlgorithmParameterSpec
  # @see java.security.spec.DSAParameterSpec
  # @see KeyPairGenerator
  # 
  # @since 1.2
  class AlgorithmParameters 
    include_class_members AlgorithmParametersImports
    
    # The provider
    attr_accessor :provider
    alias_method :attr_provider, :provider
    undef_method :provider
    alias_method :attr_provider=, :provider=
    undef_method :provider=
    
    # The provider implementation (delegate)
    attr_accessor :param_spi
    alias_method :attr_param_spi, :param_spi
    undef_method :param_spi
    alias_method :attr_param_spi=, :param_spi=
    undef_method :param_spi=
    
    # The algorithm
    attr_accessor :algorithm
    alias_method :attr_algorithm, :algorithm
    undef_method :algorithm
    alias_method :attr_algorithm=, :algorithm=
    undef_method :algorithm=
    
    # Has this object been initialized?
    attr_accessor :initialized
    alias_method :attr_initialized, :initialized
    undef_method :initialized
    alias_method :attr_initialized=, :initialized=
    undef_method :initialized=
    
    typesig { [AlgorithmParametersSpi, Provider, String] }
    # Creates an AlgorithmParameters object.
    # 
    # @param paramSpi the delegate
    # @param provider the provider
    # @param algorithm the algorithm
    def initialize(param_spi, provider, algorithm)
      @provider = nil
      @param_spi = nil
      @algorithm = nil
      @initialized = false
      @param_spi = param_spi
      @provider = provider
      @algorithm = algorithm
    end
    
    typesig { [] }
    # Returns the name of the algorithm associated with this parameter object.
    # 
    # @return the algorithm name.
    def get_algorithm
      return @algorithm
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Returns a parameter object for the specified algorithm.
      # 
      # <p> This method traverses the list of registered security Providers,
      # starting with the most preferred Provider.
      # A new AlgorithmParameters object encapsulating the
      # AlgorithmParametersSpi implementation from the first
      # Provider that supports the specified algorithm is returned.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # <p> The returned parameter object must be initialized via a call to
      # <code>init</code>, using an appropriate parameter specification or
      # parameter encoding.
      # 
      # @param algorithm the name of the algorithm requested.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @return the new parameter object.
      # 
      # @exception NoSuchAlgorithmException if no Provider supports an
      #          AlgorithmParametersSpi implementation for the
      #          specified algorithm.
      # 
      # @see Provider
      def get_instance(algorithm)
        begin
          objs = Security.get_impl(algorithm, "AlgorithmParameters", nil)
          return AlgorithmParameters.new(objs[0], objs[1], algorithm)
        rescue NoSuchProviderException => e
          raise NoSuchAlgorithmException.new(algorithm + " not found")
        end
      end
      
      typesig { [String, String] }
      # Returns a parameter object for the specified algorithm.
      # 
      # <p> A new AlgorithmParameters object encapsulating the
      # AlgorithmParametersSpi implementation from the specified provider
      # is returned.  The specified provider must be registered
      # in the security provider list.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # <p>The returned parameter object must be initialized via a call to
      # <code>init</code>, using an appropriate parameter specification or
      # parameter encoding.
      # 
      # @param algorithm the name of the algorithm requested.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @param provider the name of the provider.
      # 
      # @return the new parameter object.
      # 
      # @exception NoSuchAlgorithmException if an AlgorithmParametersSpi
      #          implementation for the specified algorithm is not
      #          available from the specified provider.
      # 
      # @exception NoSuchProviderException if the specified provider is not
      #          registered in the security provider list.
      # 
      # @exception IllegalArgumentException if the provider name is null
      #          or empty.
      # 
      # @see Provider
      def get_instance(algorithm, provider)
        if ((provider).nil? || (provider.length).equal?(0))
          raise IllegalArgumentException.new("missing provider")
        end
        objs = Security.get_impl(algorithm, "AlgorithmParameters", provider)
        return AlgorithmParameters.new(objs[0], objs[1], algorithm)
      end
      
      typesig { [String, Provider] }
      # Returns a parameter object for the specified algorithm.
      # 
      # <p> A new AlgorithmParameters object encapsulating the
      # AlgorithmParametersSpi implementation from the specified Provider
      # object is returned.  Note that the specified Provider object
      # does not have to be registered in the provider list.
      # 
      # <p>The returned parameter object must be initialized via a call to
      # <code>init</code>, using an appropriate parameter specification or
      # parameter encoding.
      # 
      # @param algorithm the name of the algorithm requested.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @param provider the name of the provider.
      # 
      # @return the new parameter object.
      # 
      # @exception NoSuchAlgorithmException if an AlgorithmParameterGeneratorSpi
      #          implementation for the specified algorithm is not available
      #          from the specified Provider object.
      # 
      # @exception IllegalArgumentException if the provider is null.
      # 
      # @see Provider
      # 
      # @since 1.4
      def get_instance(algorithm, provider)
        if ((provider).nil?)
          raise IllegalArgumentException.new("missing provider")
        end
        objs = Security.get_impl(algorithm, "AlgorithmParameters", provider)
        return AlgorithmParameters.new(objs[0], objs[1], algorithm)
      end
    }
    
    typesig { [] }
    # Returns the provider of this parameter object.
    # 
    # @return the provider of this parameter object
    def get_provider
      return @provider
    end
    
    typesig { [AlgorithmParameterSpec] }
    # Initializes this parameter object using the parameters
    # specified in <code>paramSpec</code>.
    # 
    # @param paramSpec the parameter specification.
    # 
    # @exception InvalidParameterSpecException if the given parameter
    # specification is inappropriate for the initialization of this parameter
    # object, or if this parameter object has already been initialized.
    def init(param_spec)
      if (@initialized)
        raise InvalidParameterSpecException.new("already initialized")
      end
      @param_spi.engine_init(param_spec)
      @initialized = true
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Imports the specified parameters and decodes them according to the
    # primary decoding format for parameters. The primary decoding
    # format for parameters is ASN.1, if an ASN.1 specification for this type
    # of parameters exists.
    # 
    # @param params the encoded parameters.
    # 
    # @exception IOException on decoding errors, or if this parameter object
    # has already been initialized.
    def init(params)
      if (@initialized)
        raise IOException.new("already initialized")
      end
      @param_spi.engine_init(params)
      @initialized = true
    end
    
    typesig { [Array.typed(::Java::Byte), String] }
    # Imports the parameters from <code>params</code> and decodes them
    # according to the specified decoding scheme.
    # If <code>format</code> is null, the
    # primary decoding format for parameters is used. The primary decoding
    # format is ASN.1, if an ASN.1 specification for these parameters
    # exists.
    # 
    # @param params the encoded parameters.
    # 
    # @param format the name of the decoding scheme.
    # 
    # @exception IOException on decoding errors, or if this parameter object
    # has already been initialized.
    def init(params, format)
      if (@initialized)
        raise IOException.new("already initialized")
      end
      @param_spi.engine_init(params, format)
      @initialized = true
    end
    
    typesig { [Class] }
    # Returns a (transparent) specification of this parameter object.
    # <code>paramSpec</code> identifies the specification class in which
    # the parameters should be returned. It could, for example, be
    # <code>DSAParameterSpec.class</code>, to indicate that the
    # parameters should be returned in an instance of the
    # <code>DSAParameterSpec</code> class.
    # 
    # @param paramSpec the specification class in which
    # the parameters should be returned.
    # 
    # @return the parameter specification.
    # 
    # @exception InvalidParameterSpecException if the requested parameter
    # specification is inappropriate for this parameter object, or if this
    # parameter object has not been initialized.
    def get_parameter_spec(param_spec)
      if ((@initialized).equal?(false))
        raise InvalidParameterSpecException.new("not initialized")
      end
      return @param_spi.engine_get_parameter_spec(param_spec)
    end
    
    typesig { [] }
    # Returns the parameters in their primary encoding format.
    # The primary encoding format for parameters is ASN.1, if an ASN.1
    # specification for this type of parameters exists.
    # 
    # @return the parameters encoded using their primary encoding format.
    # 
    # @exception IOException on encoding errors, or if this parameter object
    # has not been initialized.
    def get_encoded
      if ((@initialized).equal?(false))
        raise IOException.new("not initialized")
      end
      return @param_spi.engine_get_encoded
    end
    
    typesig { [String] }
    # Returns the parameters encoded in the specified scheme.
    # If <code>format</code> is null, the
    # primary encoding format for parameters is used. The primary encoding
    # format is ASN.1, if an ASN.1 specification for these parameters
    # exists.
    # 
    # @param format the name of the encoding format.
    # 
    # @return the parameters encoded using the specified encoding scheme.
    # 
    # @exception IOException on encoding errors, or if this parameter object
    # has not been initialized.
    def get_encoded(format)
      if ((@initialized).equal?(false))
        raise IOException.new("not initialized")
      end
      return @param_spi.engine_get_encoded(format)
    end
    
    typesig { [] }
    # Returns a formatted string describing the parameters.
    # 
    # @return a formatted string describing the parameters, or null if this
    # parameter object has not been initialized.
    def to_s
      if ((@initialized).equal?(false))
        return nil
      end
      return @param_spi.engine_to_string
    end
    
    private
    alias_method :initialize__algorithm_parameters, :initialize
  end
  
end
