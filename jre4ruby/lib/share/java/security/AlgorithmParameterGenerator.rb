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
  module AlgorithmParameterGeneratorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
    }
  end
  
  # The <code>AlgorithmParameterGenerator</code> class is used to generate a
  # set of
  # parameters to be used with a certain algorithm. Parameter generators
  # are constructed using the <code>getInstance</code> factory methods
  # (static methods that return instances of a given class).
  # 
  # <P>The object that will generate the parameters can be initialized
  # in two different ways: in an algorithm-independent manner, or in an
  # algorithm-specific manner:
  # 
  # <ul>
  # <li>The algorithm-independent approach uses the fact that all parameter
  # generators share the concept of a "size" and a
  # source of randomness. The measure of size is universally shared
  # by all algorithm parameters, though it is interpreted differently
  # for different algorithms. For example, in the case of parameters for
  # the <i>DSA</i> algorithm, "size" corresponds to the size
  # of the prime modulus (in bits).
  # When using this approach, algorithm-specific parameter generation
  # values - if any - default to some standard values, unless they can be
  # derived from the specified size.<P>
  # 
  # <li>The other approach initializes a parameter generator object
  # using algorithm-specific semantics, which are represented by a set of
  # algorithm-specific parameter generation values. To generate
  # Diffie-Hellman system parameters, for example, the parameter generation
  # values usually
  # consist of the size of the prime modulus and the size of the
  # random exponent, both specified in number of bits.
  # </ul>
  # 
  # <P>In case the client does not explicitly initialize the
  # AlgorithmParameterGenerator
  # (via a call to an <code>init</code> method), each provider must supply (and
  # document) a default initialization. For example, the Sun provider uses a
  # default modulus prime size of 1024 bits for the generation of DSA
  # parameters.
  # 
  # @author Jan Luehe
  # 
  # 
  # @see AlgorithmParameters
  # @see java.security.spec.AlgorithmParameterSpec
  # 
  # @since 1.2
  class AlgorithmParameterGenerator 
    include_class_members AlgorithmParameterGeneratorImports
    
    # The provider
    attr_accessor :provider
    alias_method :attr_provider, :provider
    undef_method :provider
    alias_method :attr_provider=, :provider=
    undef_method :provider=
    
    # The provider implementation (delegate)
    attr_accessor :param_gen_spi
    alias_method :attr_param_gen_spi, :param_gen_spi
    undef_method :param_gen_spi
    alias_method :attr_param_gen_spi=, :param_gen_spi=
    undef_method :param_gen_spi=
    
    # The algorithm
    attr_accessor :algorithm
    alias_method :attr_algorithm, :algorithm
    undef_method :algorithm
    alias_method :attr_algorithm=, :algorithm=
    undef_method :algorithm=
    
    typesig { [AlgorithmParameterGeneratorSpi, Provider, String] }
    # Creates an AlgorithmParameterGenerator object.
    # 
    # @param paramGenSpi the delegate
    # @param provider the provider
    # @param algorithm the algorithm
    def initialize(param_gen_spi, provider, algorithm)
      @provider = nil
      @param_gen_spi = nil
      @algorithm = nil
      @param_gen_spi = param_gen_spi
      @provider = provider
      @algorithm = algorithm
    end
    
    typesig { [] }
    # Returns the standard name of the algorithm this parameter
    # generator is associated with.
    # 
    # @return the string name of the algorithm.
    def get_algorithm
      return @algorithm
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Returns an AlgorithmParameterGenerator object for generating
      # a set of parameters to be used with the specified algorithm.
      # 
      # <p> This method traverses the list of registered security Providers,
      # starting with the most preferred Provider.
      # A new AlgorithmParameterGenerator object encapsulating the
      # AlgorithmParameterGeneratorSpi implementation from the first
      # Provider that supports the specified algorithm is returned.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # @param algorithm the name of the algorithm this
      # parameter generator is associated with.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @return the new AlgorithmParameterGenerator object.
      # 
      # @exception NoSuchAlgorithmException if no Provider supports an
      # AlgorithmParameterGeneratorSpi implementation for the
      # specified algorithm.
      # 
      # @see Provider
      def get_instance(algorithm)
        begin
          objs = Security.get_impl(algorithm, "AlgorithmParameterGenerator", nil)
          return AlgorithmParameterGenerator.new(objs[0], objs[1], algorithm)
        rescue NoSuchProviderException => e
          raise NoSuchAlgorithmException.new(algorithm + " not found")
        end
      end
      
      typesig { [String, String] }
      # Returns an AlgorithmParameterGenerator object for generating
      # a set of parameters to be used with the specified algorithm.
      # 
      # <p> A new AlgorithmParameterGenerator object encapsulating the
      # AlgorithmParameterGeneratorSpi implementation from the specified provider
      # is returned.  The specified provider must be registered
      # in the security provider list.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # @param algorithm the name of the algorithm this
      # parameter generator is associated with.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @param provider the string name of the Provider.
      # 
      # @return the new AlgorithmParameterGenerator object.
      # 
      # @exception NoSuchAlgorithmException if an AlgorithmParameterGeneratorSpi
      # implementation for the specified algorithm is not
      # available from the specified provider.
      # 
      # @exception NoSuchProviderException if the specified provider is not
      # registered in the security provider list.
      # 
      # @exception IllegalArgumentException if the provider name is null
      # or empty.
      # 
      # @see Provider
      def get_instance(algorithm, provider)
        if ((provider).nil? || (provider.length).equal?(0))
          raise IllegalArgumentException.new("missing provider")
        end
        objs = Security.get_impl(algorithm, "AlgorithmParameterGenerator", provider)
        return AlgorithmParameterGenerator.new(objs[0], objs[1], algorithm)
      end
      
      typesig { [String, Provider] }
      # Returns an AlgorithmParameterGenerator object for generating
      # a set of parameters to be used with the specified algorithm.
      # 
      # <p> A new AlgorithmParameterGenerator object encapsulating the
      # AlgorithmParameterGeneratorSpi implementation from the specified Provider
      # object is returned.  Note that the specified Provider object
      # does not have to be registered in the provider list.
      # 
      # @param algorithm the string name of the algorithm this
      # parameter generator is associated with.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @param provider the Provider object.
      # 
      # @return the new AlgorithmParameterGenerator object.
      # 
      # @exception NoSuchAlgorithmException if an AlgorithmParameterGeneratorSpi
      # implementation for the specified algorithm is not available
      # from the specified Provider object.
      # 
      # @exception IllegalArgumentException if the specified provider is null.
      # 
      # @see Provider
      # 
      # @since 1.4
      def get_instance(algorithm, provider)
        if ((provider).nil?)
          raise IllegalArgumentException.new("missing provider")
        end
        objs = Security.get_impl(algorithm, "AlgorithmParameterGenerator", provider)
        return AlgorithmParameterGenerator.new(objs[0], objs[1], algorithm)
      end
    }
    
    typesig { [] }
    # Returns the provider of this algorithm parameter generator object.
    # 
    # @return the provider of this algorithm parameter generator object
    def get_provider
      return @provider
    end
    
    typesig { [::Java::Int] }
    # Initializes this parameter generator for a certain size.
    # To create the parameters, the <code>SecureRandom</code>
    # implementation of the highest-priority installed provider is used as
    # the source of randomness.
    # (If none of the installed providers supply an implementation of
    # <code>SecureRandom</code>, a system-provided source of randomness is
    # used.)
    # 
    # @param size the size (number of bits).
    def init(size)
      @param_gen_spi.engine_init(size, SecureRandom.new)
    end
    
    typesig { [::Java::Int, SecureRandom] }
    # Initializes this parameter generator for a certain size and source
    # of randomness.
    # 
    # @param size the size (number of bits).
    # @param random the source of randomness.
    def init(size, random)
      @param_gen_spi.engine_init(size, random)
    end
    
    typesig { [AlgorithmParameterSpec] }
    # Initializes this parameter generator with a set of algorithm-specific
    # parameter generation values.
    # To generate the parameters, the <code>SecureRandom</code>
    # implementation of the highest-priority installed provider is used as
    # the source of randomness.
    # (If none of the installed providers supply an implementation of
    # <code>SecureRandom</code>, a system-provided source of randomness is
    # used.)
    # 
    # @param genParamSpec the set of algorithm-specific parameter generation values.
    # 
    # @exception InvalidAlgorithmParameterException if the given parameter
    # generation values are inappropriate for this parameter generator.
    def init(gen_param_spec)
      @param_gen_spi.engine_init(gen_param_spec, SecureRandom.new)
    end
    
    typesig { [AlgorithmParameterSpec, SecureRandom] }
    # Initializes this parameter generator with a set of algorithm-specific
    # parameter generation values.
    # 
    # @param genParamSpec the set of algorithm-specific parameter generation values.
    # @param random the source of randomness.
    # 
    # @exception InvalidAlgorithmParameterException if the given parameter
    # generation values are inappropriate for this parameter generator.
    def init(gen_param_spec, random)
      @param_gen_spi.engine_init(gen_param_spec, random)
    end
    
    typesig { [] }
    # Generates the parameters.
    # 
    # @return the new AlgorithmParameters object.
    def generate_parameters
      return @param_gen_spi.engine_generate_parameters
    end
    
    private
    alias_method :initialize__algorithm_parameter_generator, :initialize
  end
  
end
