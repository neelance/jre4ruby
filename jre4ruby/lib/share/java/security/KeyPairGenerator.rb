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
  module KeyPairGeneratorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Util
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include_const ::Java::Security::Provider, :Service
      include ::Sun::Security::Jca
      include_const ::Sun::Security::Jca::GetInstance, :Instance
    }
  end
  
  # The KeyPairGenerator class is used to generate pairs of
  # public and private keys. Key pair generators are constructed using the
  # <code>getInstance</code> factory methods (static methods that
  # return instances of a given class).
  # 
  # <p>A Key pair generator for a particular algorithm creates a public/private
  # key pair that can be used with this algorithm. It also associates
  # algorithm-specific parameters with each of the generated keys.
  # 
  # <p>There are two ways to generate a key pair: in an algorithm-independent
  # manner, and in an algorithm-specific manner.
  # The only difference between the two is the initialization of the object:
  # 
  # <ul>
  # <li><b>Algorithm-Independent Initialization</b>
  # <p>All key pair generators share the concepts of a keysize and a
  # source of randomness. The keysize is interpreted differently for different
  # algorithms (e.g., in the case of the <i>DSA</i> algorithm, the keysize
  # corresponds to the length of the modulus).
  # There is an
  # {@link #initialize(int, java.security.SecureRandom) initialize}
  # method in this KeyPairGenerator class that takes these two universally
  # shared types of arguments. There is also one that takes just a
  # <code>keysize</code> argument, and uses the <code>SecureRandom</code>
  # implementation of the highest-priority installed provider as the source
  # of randomness. (If none of the installed providers supply an implementation
  # of <code>SecureRandom</code>, a system-provided source of randomness is
  # used.)
  # 
  # <p>Since no other parameters are specified when you call the above
  # algorithm-independent <code>initialize</code> methods, it is up to the
  # provider what to do about the algorithm-specific parameters (if any) to be
  # associated with each of the keys.
  # 
  # <p>If the algorithm is the <i>DSA</i> algorithm, and the keysize (modulus
  # size) is 512, 768, or 1024, then the <i>Sun</i> provider uses a set of
  # precomputed values for the <code>p</code>, <code>q</code>, and
  # <code>g</code> parameters. If the modulus size is not one of the above
  # values, the <i>Sun</i> provider creates a new set of parameters. Other
  # providers might have precomputed parameter sets for more than just the
  # three modulus sizes mentioned above. Still others might not have a list of
  # precomputed parameters at all and instead always create new parameter sets.
  # <p>
  # 
  # <li><b>Algorithm-Specific Initialization</b>
  # <p>For situations where a set of algorithm-specific parameters already
  # exists (e.g., so-called <i>community parameters</i> in DSA), there are two
  # {@link #initialize(java.security.spec.AlgorithmParameterSpec)
  # initialize} methods that have an <code>AlgorithmParameterSpec</code>
  # argument. One also has a <code>SecureRandom</code> argument, while the
  # the other uses the <code>SecureRandom</code>
  # implementation of the highest-priority installed provider as the source
  # of randomness. (If none of the installed providers supply an implementation
  # of <code>SecureRandom</code>, a system-provided source of randomness is
  # used.)
  # </ul>
  # 
  # <p>In case the client does not explicitly initialize the KeyPairGenerator
  # (via a call to an <code>initialize</code> method), each provider must
  # supply (and document) a default initialization.
  # For example, the <i>Sun</i> provider uses a default modulus size (keysize)
  # of 1024 bits.
  # 
  # <p>Note that this class is abstract and extends from
  # <code>KeyPairGeneratorSpi</code> for historical reasons.
  # Application developers should only take notice of the methods defined in
  # this <code>KeyPairGenerator</code> class; all the methods in
  # the superclass are intended for cryptographic service providers who wish to
  # supply their own implementations of key pair generators.
  # 
  # @author Benjamin Renaud
  # 
  # 
  # @see java.security.spec.AlgorithmParameterSpec
  class KeyPairGenerator < KeyPairGeneratorImports.const_get :KeyPairGeneratorSpi
    include_class_members KeyPairGeneratorImports
    
    attr_accessor :algorithm
    alias_method :attr_algorithm, :algorithm
    undef_method :algorithm
    alias_method :attr_algorithm=, :algorithm=
    undef_method :algorithm=
    
    # The provider
    attr_accessor :provider
    alias_method :attr_provider, :provider
    undef_method :provider
    alias_method :attr_provider=, :provider=
    undef_method :provider=
    
    typesig { [String] }
    # Creates a KeyPairGenerator object for the specified algorithm.
    # 
    # @param algorithm the standard string name of the algorithm.
    # See Appendix A in the <a href=
    # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
    # Java Cryptography Architecture API Specification &amp; Reference </a>
    # for information about standard algorithm names.
    def initialize(algorithm)
      @algorithm = nil
      @provider = nil
      super()
      @algorithm = algorithm
    end
    
    typesig { [] }
    # Returns the standard name of the algorithm for this key pair generator.
    # See Appendix A in the <a href=
    # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
    # Java Cryptography Architecture API Specification &amp; Reference </a>
    # for information about standard algorithm names.
    # 
    # @return the standard string name of the algorithm.
    def get_algorithm
      return @algorithm
    end
    
    class_module.module_eval {
      typesig { [Instance, String] }
      def get_instance(instance, algorithm)
        kpg = nil
        if (instance.attr_impl.is_a?(KeyPairGenerator))
          kpg = instance.attr_impl
        else
          spi = instance.attr_impl
          kpg = Delegate.new(spi, algorithm)
        end
        kpg.attr_provider = instance.attr_provider
        return kpg
      end
      
      typesig { [String] }
      # Returns a KeyPairGenerator object that generates public/private
      # key pairs for the specified algorithm.
      # 
      # <p> This method traverses the list of registered security Providers,
      # starting with the most preferred Provider.
      # A new KeyPairGenerator object encapsulating the
      # KeyPairGeneratorSpi implementation from the first
      # Provider that supports the specified algorithm is returned.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # @param algorithm the standard string name of the algorithm.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @return the new KeyPairGenerator object.
      # 
      # @exception NoSuchAlgorithmException if no Provider supports a
      # KeyPairGeneratorSpi implementation for the
      # specified algorithm.
      # 
      # @see Provider
      def get_instance(algorithm)
        list = GetInstance.get_services("KeyPairGenerator", algorithm)
        t = list.iterator
        if ((t.has_next).equal?(false))
          raise NoSuchAlgorithmException.new(algorithm + " KeyPairGenerator not available")
        end
        # find a working Spi or KeyPairGenerator subclass
        failure = nil
        begin
          s = t.next_
          begin
            instance = GetInstance.get_instance(s, KeyPairGeneratorSpi)
            if (instance.attr_impl.is_a?(KeyPairGenerator))
              return get_instance(instance, algorithm)
            else
              return Delegate.new(instance, t, algorithm)
            end
          rescue NoSuchAlgorithmException => e
            if ((failure).nil?)
              failure = e
            end
          end
        end while (t.has_next)
        raise failure
      end
      
      typesig { [String, String] }
      # Returns a KeyPairGenerator object that generates public/private
      # key pairs for the specified algorithm.
      # 
      # <p> A new KeyPairGenerator object encapsulating the
      # KeyPairGeneratorSpi implementation from the specified provider
      # is returned.  The specified provider must be registered
      # in the security provider list.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # @param algorithm the standard string name of the algorithm.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @param provider the string name of the provider.
      # 
      # @return the new KeyPairGenerator object.
      # 
      # @exception NoSuchAlgorithmException if a KeyPairGeneratorSpi
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
        instance = GetInstance.get_instance("KeyPairGenerator", KeyPairGeneratorSpi, algorithm, provider)
        return get_instance(instance, algorithm)
      end
      
      typesig { [String, Provider] }
      # Returns a KeyPairGenerator object that generates public/private
      # key pairs for the specified algorithm.
      # 
      # <p> A new KeyPairGenerator object encapsulating the
      # KeyPairGeneratorSpi implementation from the specified Provider
      # object is returned.  Note that the specified Provider object
      # does not have to be registered in the provider list.
      # 
      # @param algorithm the standard string name of the algorithm.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @param provider the provider.
      # 
      # @return the new KeyPairGenerator object.
      # 
      # @exception NoSuchAlgorithmException if a KeyPairGeneratorSpi
      # implementation for the specified algorithm is not available
      # from the specified Provider object.
      # 
      # @exception IllegalArgumentException if the specified provider is null.
      # 
      # @see Provider
      # 
      # @since 1.4
      def get_instance(algorithm, provider)
        instance = GetInstance.get_instance("KeyPairGenerator", KeyPairGeneratorSpi, algorithm, provider)
        return get_instance(instance, algorithm)
      end
    }
    
    typesig { [] }
    # Returns the provider of this key pair generator object.
    # 
    # @return the provider of this key pair generator object
    def get_provider
      disable_failover
      return @provider
    end
    
    typesig { [] }
    def disable_failover
      # empty, overridden in Delegate
    end
    
    typesig { [::Java::Int] }
    # Initializes the key pair generator for a certain keysize using
    # a default parameter set and the <code>SecureRandom</code>
    # implementation of the highest-priority installed provider as the source
    # of randomness.
    # (If none of the installed providers supply an implementation of
    # <code>SecureRandom</code>, a system-provided source of randomness is
    # used.)
    # 
    # @param keysize the keysize. This is an
    # algorithm-specific metric, such as modulus length, specified in
    # number of bits.
    # 
    # @exception InvalidParameterException if the <code>keysize</code> is not
    # supported by this KeyPairGenerator object.
    def initialize_(keysize)
      initialize_(keysize, JCAUtil.get_secure_random)
    end
    
    typesig { [::Java::Int, SecureRandom] }
    # Initializes the key pair generator for a certain keysize with
    # the given source of randomness (and a default parameter set).
    # 
    # @param keysize the keysize. This is an
    # algorithm-specific metric, such as modulus length, specified in
    # number of bits.
    # @param random the source of randomness.
    # 
    # @exception InvalidParameterException if the <code>keysize</code> is not
    # supported by this KeyPairGenerator object.
    # 
    # @since 1.2
    def initialize_(keysize, random)
      # This does nothing, because either
      # 1. the implementation object returned by getInstance() is an
      # instance of KeyPairGenerator which has its own
      # initialize(keysize, random) method, so the application would
      # be calling that method directly, or
      # 2. the implementation returned by getInstance() is an instance
      # of Delegate, in which case initialize(keysize, random) is
      # overridden to call the corresponding SPI method.
      # (This is a special case, because the API and SPI method have the
      # same name.)
    end
    
    typesig { [AlgorithmParameterSpec] }
    # Initializes the key pair generator using the specified parameter
    # set and the <code>SecureRandom</code>
    # implementation of the highest-priority installed provider as the source
    # of randomness.
    # (If none of the installed providers supply an implementation of
    # <code>SecureRandom</code>, a system-provided source of randomness is
    # used.).
    # 
    # <p>This concrete method has been added to this previously-defined
    # abstract class.
    # This method calls the KeyPairGeneratorSpi
    # {@link KeyPairGeneratorSpi#initialize(
    # java.security.spec.AlgorithmParameterSpec,
    # java.security.SecureRandom) initialize} method,
    # passing it <code>params</code> and a source of randomness (obtained
    # from the highest-priority installed provider or system-provided if none
    # of the installed providers supply one).
    # That <code>initialize</code> method always throws an
    # UnsupportedOperationException if it is not overridden by the provider.
    # 
    # @param params the parameter set used to generate the keys.
    # 
    # @exception InvalidAlgorithmParameterException if the given parameters
    # are inappropriate for this key pair generator.
    # 
    # @since 1.2
    def initialize_(params)
      initialize_(params, JCAUtil.get_secure_random)
    end
    
    typesig { [AlgorithmParameterSpec, SecureRandom] }
    # Initializes the key pair generator with the given parameter
    # set and source of randomness.
    # 
    # <p>This concrete method has been added to this previously-defined
    # abstract class.
    # This method calls the KeyPairGeneratorSpi {@link
    # KeyPairGeneratorSpi#initialize(
    # java.security.spec.AlgorithmParameterSpec,
    # java.security.SecureRandom) initialize} method,
    # passing it <code>params</code> and <code>random</code>.
    # That <code>initialize</code>
    # method always throws an
    # UnsupportedOperationException if it is not overridden by the provider.
    # 
    # @param params the parameter set used to generate the keys.
    # @param random the source of randomness.
    # 
    # @exception InvalidAlgorithmParameterException if the given parameters
    # are inappropriate for this key pair generator.
    # 
    # @since 1.2
    def initialize_(params, random)
      # This does nothing, because either
      # 1. the implementation object returned by getInstance() is an
      # instance of KeyPairGenerator which has its own
      # initialize(params, random) method, so the application would
      # be calling that method directly, or
      # 2. the implementation returned by getInstance() is an instance
      # of Delegate, in which case initialize(params, random) is
      # overridden to call the corresponding SPI method.
      # (This is a special case, because the API and SPI method have the
      # same name.)
    end
    
    typesig { [] }
    # Generates a key pair.
    # 
    # <p>If this KeyPairGenerator has not been initialized explicitly,
    # provider-specific defaults will be used for the size and other
    # (algorithm-specific) values of the generated keys.
    # 
    # <p>This will generate a new key pair every time it is called.
    # 
    # <p>This method is functionally equivalent to
    # {@link #generateKeyPair() generateKeyPair}.
    # 
    # @return the generated key pair
    # 
    # @since 1.2
    def gen_key_pair
      return generate_key_pair
    end
    
    typesig { [] }
    # Generates a key pair.
    # 
    # <p>If this KeyPairGenerator has not been initialized explicitly,
    # provider-specific defaults will be used for the size and other
    # (algorithm-specific) values of the generated keys.
    # 
    # <p>This will generate a new key pair every time it is called.
    # 
    # <p>This method is functionally equivalent to
    # {@link #genKeyPair() genKeyPair}.
    # 
    # @return the generated key pair
    def generate_key_pair
      # This does nothing (except returning null), because either:
      # 
      # 1. the implementation object returned by getInstance() is an
      # instance of KeyPairGenerator which has its own implementation
      # of generateKeyPair (overriding this one), so the application
      # would be calling that method directly, or
      # 
      # 2. the implementation returned by getInstance() is an instance
      # of Delegate, in which case generateKeyPair is
      # overridden to invoke the corresponding SPI method.
      # 
      # (This is a special case, because in JDK 1.1.x the generateKeyPair
      # method was used both as an API and a SPI method.)
      return nil
    end
    
    class_module.module_eval {
      # The following class allows providers to extend from KeyPairGeneratorSpi
      # rather than from KeyPairGenerator. It represents a KeyPairGenerator
      # with an encapsulated, provider-supplied SPI object (of type
      # KeyPairGeneratorSpi).
      # If the provider implementation is an instance of KeyPairGeneratorSpi,
      # the getInstance() methods above return an instance of this class, with
      # the SPI object encapsulated.
      # 
      # Note: All SPI methods from the original KeyPairGenerator class have been
      # moved up the hierarchy into a new class (KeyPairGeneratorSpi), which has
      # been interposed in the hierarchy between the API (KeyPairGenerator)
      # and its original parent (Object).
      # 
      # 
      # error failover notes:
      # 
      # . we failover if the implementation throws an error during init
      # by retrying the init on other providers
      # 
      # . we also failover if the init succeeded but the subsequent call
      # to generateKeyPair() fails. In order for this to work, we need
      # to remember the parameters to the last successful call to init
      # and initialize() the next spi using them.
      # 
      # . although not specified, KeyPairGenerators could be thread safe,
      # so we make sure we do not interfere with that
      # 
      # . failover is not available, if:
      # . getInstance(algorithm, provider) was used
      # . a provider extends KeyPairGenerator rather than
      # KeyPairGeneratorSpi (JDK 1.1 style)
      # . once getProvider() is called
      const_set_lazy(:Delegate) { Class.new(KeyPairGenerator) do
        include_class_members KeyPairGenerator
        
        # The provider implementation (delegate)
        attr_accessor :spi
        alias_method :attr_spi, :spi
        undef_method :spi
        alias_method :attr_spi=, :spi=
        undef_method :spi=
        
        attr_accessor :lock
        alias_method :attr_lock, :lock
        undef_method :lock
        alias_method :attr_lock=, :lock=
        undef_method :lock=
        
        attr_accessor :service_iterator
        alias_method :attr_service_iterator, :service_iterator
        undef_method :service_iterator
        alias_method :attr_service_iterator=, :service_iterator=
        undef_method :service_iterator=
        
        class_module.module_eval {
          const_set_lazy(:I_NONE) { 1 }
          const_attr_reader  :I_NONE
          
          const_set_lazy(:I_SIZE) { 2 }
          const_attr_reader  :I_SIZE
          
          const_set_lazy(:I_PARAMS) { 3 }
          const_attr_reader  :I_PARAMS
        }
        
        attr_accessor :init_type
        alias_method :attr_init_type, :init_type
        undef_method :init_type
        alias_method :attr_init_type=, :init_type=
        undef_method :init_type=
        
        attr_accessor :init_key_size
        alias_method :attr_init_key_size, :init_key_size
        undef_method :init_key_size
        alias_method :attr_init_key_size=, :init_key_size=
        undef_method :init_key_size=
        
        attr_accessor :init_params
        alias_method :attr_init_params, :init_params
        undef_method :init_params
        alias_method :attr_init_params=, :init_params=
        undef_method :init_params=
        
        attr_accessor :init_random
        alias_method :attr_init_random, :init_random
        undef_method :init_random
        alias_method :attr_init_random=, :init_random=
        undef_method :init_random=
        
        typesig { [self::KeyPairGeneratorSpi, String] }
        # constructor
        def initialize(spi, algorithm)
          @spi = nil
          @lock = nil
          @service_iterator = nil
          @init_type = 0
          @init_key_size = 0
          @init_params = nil
          @init_random = nil
          super(algorithm)
          @lock = self.class::Object.new
          @spi = spi
        end
        
        typesig { [self::Instance, self::Iterator, String] }
        def initialize(instance, service_iterator, algorithm)
          @spi = nil
          @lock = nil
          @service_iterator = nil
          @init_type = 0
          @init_key_size = 0
          @init_params = nil
          @init_random = nil
          super(algorithm)
          @lock = self.class::Object.new
          @spi = instance.attr_impl
          self.attr_provider = instance.attr_provider
          @service_iterator = service_iterator
          @init_type = self.class::I_NONE
        end
        
        typesig { [self::KeyPairGeneratorSpi, ::Java::Boolean] }
        # Update the active spi of this class and return the next
        # implementation for failover. If no more implemenations are
        # available, this method returns null. However, the active spi of
        # this class is never set to null.
        def next_spi(old_spi, reinit)
          synchronized((@lock)) do
            # somebody else did a failover concurrently
            # try that spi now
            if ((!(old_spi).nil?) && (!(old_spi).equal?(@spi)))
              return @spi
            end
            if ((@service_iterator).nil?)
              return nil
            end
            while (@service_iterator.has_next)
              s = @service_iterator.next_
              begin
                inst = s.new_instance(nil)
                # ignore non-spis
                if ((inst.is_a?(self.class::KeyPairGeneratorSpi)).equal?(false))
                  next
                end
                if (inst.is_a?(self.class::KeyPairGenerator))
                  next
                end
                spi = inst
                if (reinit)
                  if ((@init_type).equal?(self.class::I_SIZE))
                    spi.initialize_(@init_key_size, @init_random)
                  else
                    if ((@init_type).equal?(self.class::I_PARAMS))
                      spi.initialize_(@init_params, @init_random)
                    else
                      if (!(@init_type).equal?(self.class::I_NONE))
                        raise self.class::AssertionError.new("KeyPairGenerator initType: " + RJava.cast_to_string(@init_type))
                      end
                    end
                  end
                end
                self.attr_provider = s.get_provider
                @spi = spi
                return spi
              rescue self.class::JavaException => e
                # ignore
              end
            end
            disable_failover
            return nil
          end
        end
        
        typesig { [] }
        def disable_failover
          @service_iterator = nil
          @init_type = 0
          @init_params = nil
          @init_random = nil
        end
        
        typesig { [::Java::Int, self::SecureRandom] }
        # engine method
        def initialize_(keysize, random)
          if ((@service_iterator).nil?)
            @spi.initialize_(keysize, random)
            return
          end
          failure = nil
          my_spi = @spi
          begin
            begin
              my_spi.initialize_(keysize, random)
              @init_type = self.class::I_SIZE
              @init_key_size = keysize
              @init_params = nil
              @init_random = random
              return
            rescue self.class::RuntimeException => e
              if ((failure).nil?)
                failure = e
              end
              my_spi = next_spi(my_spi, false)
            end
          end while (!(my_spi).nil?)
          raise failure
        end
        
        typesig { [self::AlgorithmParameterSpec, self::SecureRandom] }
        # engine method
        def initialize_(params, random)
          if ((@service_iterator).nil?)
            @spi.initialize_(params, random)
            return
          end
          failure = nil
          my_spi = @spi
          begin
            begin
              my_spi.initialize_(params, random)
              @init_type = self.class::I_PARAMS
              @init_key_size = 0
              @init_params = params
              @init_random = random
              return
            rescue self.class::JavaException => e
              if ((failure).nil?)
                failure = e
              end
              my_spi = next_spi(my_spi, false)
            end
          end while (!(my_spi).nil?)
          if (failure.is_a?(self.class::RuntimeException))
            raise failure
          end
          # must be an InvalidAlgorithmParameterException
          raise failure
        end
        
        typesig { [] }
        # engine method
        def generate_key_pair
          if ((@service_iterator).nil?)
            return @spi.generate_key_pair
          end
          failure = nil
          my_spi = @spi
          begin
            begin
              return my_spi.generate_key_pair
            rescue self.class::RuntimeException => e
              if ((failure).nil?)
                failure = e
              end
              my_spi = next_spi(my_spi, true)
            end
          end while (!(my_spi).nil?)
          raise failure
        end
        
        private
        alias_method :initialize__delegate, :initialize
      end }
    }
    
    private
    alias_method :initialize__key_pair_generator, :initialize
  end
  
end
