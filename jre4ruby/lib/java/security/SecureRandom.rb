require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SecureRandomImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Util
      include_const ::Java::Security::Provider, :Service
      include ::Sun::Security::Jca
      include_const ::Sun::Security::Jca::GetInstance, :Instance
    }
  end
  
  # This class provides a cryptographically strong random number
  # generator (RNG).
  # 
  # <p>A cryptographically strong random number
  # minimally complies with the statistical random number generator tests
  # specified in <a href="http://csrc.nist.gov/cryptval/140-2.htm">
  # <i>FIPS 140-2, Security Requirements for Cryptographic Modules</i></a>,
  # section 4.9.1.
  # Additionally, SecureRandom must produce non-deterministic output.
  # Therefore any seed material passed to a SecureRandom object must be
  # unpredictable, and all SecureRandom output sequences must be
  # cryptographically strong, as described in
  # <a href="http://www.ietf.org/rfc/rfc1750.txt">
  # <i>RFC 1750: Randomness Recommendations for Security</i></a>.
  # 
  # <p>A caller obtains a SecureRandom instance via the
  # no-argument constructor or one of the <code>getInstance</code> methods:
  # 
  # <pre>
  # SecureRandom random = new SecureRandom();
  # </pre>
  # 
  # <p> Many SecureRandom implementations are in the form of a pseudo-random
  # number generator (PRNG), which means they use a deterministic algorithm
  # to produce a pseudo-random sequence from a true random seed.
  # Other implementations may produce true random numbers,
  # and yet others may use a combination of both techniques.
  # 
  # <p> Typical callers of SecureRandom invoke the following methods
  # to retrieve random bytes:
  # 
  # <pre>
  # SecureRandom random = new SecureRandom();
  # byte bytes[] = new byte[20];
  # random.nextBytes(bytes);
  # </pre>
  # 
  # <p> Callers may also invoke the <code>generateSeed</code> method
  # to generate a given number of seed bytes (to seed other random number
  # generators, for example):
  # <pre>
  # byte seed[] = random.generateSeed(20);
  # </pre>
  # 
  # @see java.security.SecureRandomSpi
  # @see java.util.Random
  # 
  # @author Benjamin Renaud
  # @author Josh Bloch
  class SecureRandom < Java::Util::Random
    include_class_members SecureRandomImports
    
    # The provider.
    # 
    # @serial
    # @since 1.2
    attr_accessor :provider
    alias_method :attr_provider, :provider
    undef_method :provider
    alias_method :attr_provider=, :provider=
    undef_method :provider=
    
    # The provider implementation.
    # 
    # @serial
    # @since 1.2
    attr_accessor :secure_random_spi
    alias_method :attr_secure_random_spi, :secure_random_spi
    undef_method :secure_random_spi
    alias_method :attr_secure_random_spi=, :secure_random_spi=
    undef_method :secure_random_spi=
    
    # The algorithm name of null if unknown.
    # 
    # @serial
    # @since 1.5
    attr_accessor :algorithm
    alias_method :attr_algorithm, :algorithm
    undef_method :algorithm
    alias_method :attr_algorithm=, :algorithm=
    undef_method :algorithm=
    
    class_module.module_eval {
      # Seed Generator
      
      def seed_generator
        defined?(@@seed_generator) ? @@seed_generator : @@seed_generator= nil
      end
      alias_method :attr_seed_generator, :seed_generator
      
      def seed_generator=(value)
        @@seed_generator = value
      end
      alias_method :attr_seed_generator=, :seed_generator=
    }
    
    typesig { [] }
    # Constructs a secure random number generator (RNG) implementing the
    # default random number algorithm.
    # 
    # <p> This constructor traverses the list of registered security Providers,
    # starting with the most preferred Provider.
    # A new SecureRandom object encapsulating the
    # SecureRandomSpi implementation from the first
    # Provider that supports a SecureRandom (RNG) algorithm is returned.
    # If none of the Providers support a RNG algorithm,
    # then an implementation-specific default is returned.
    # 
    # <p> Note that the list of registered providers may be retrieved via
    # the {@link Security#getProviders() Security.getProviders()} method.
    # 
    # <p> See Appendix A in the <a href=
    # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
    # Java Cryptography Architecture API Specification &amp; Reference </a>
    # for information about standard RNG algorithm names.
    # 
    # <p> The returned SecureRandom object has not been seeded.  To seed the
    # returned object, call the <code>setSeed</code> method.
    # If <code>setSeed</code> is not called, the first call to
    # <code>nextBytes</code> will force the SecureRandom object to seed itself.
    # This self-seeding will not occur if <code>setSeed</code> was
    # previously called.
    def initialize
      # This call to our superclass constructor will result in a call
      # to our own <code>setSeed</code> method, which will return
      # immediately when it is passed zero.
      @provider = nil
      @secure_random_spi = nil
      @algorithm = nil
      @state = nil
      @digest = nil
      @random_bytes = nil
      @random_bytes_used = 0
      @counter = 0
      super(0)
      @provider = nil
      @secure_random_spi = nil
      @digest = nil
      get_default_prng(false, nil)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Constructs a secure random number generator (RNG) implementing the
    # default random number algorithm.
    # The SecureRandom instance is seeded with the specified seed bytes.
    # 
    # <p> This constructor traverses the list of registered security Providers,
    # starting with the most preferred Provider.
    # A new SecureRandom object encapsulating the
    # SecureRandomSpi implementation from the first
    # Provider that supports a SecureRandom (RNG) algorithm is returned.
    # If none of the Providers support a RNG algorithm,
    # then an implementation-specific default is returned.
    # 
    # <p> Note that the list of registered providers may be retrieved via
    # the {@link Security#getProviders() Security.getProviders()} method.
    # 
    # <p> See Appendix A in the <a href=
    # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
    # Java Cryptography Architecture API Specification &amp; Reference </a>
    # for information about standard RNG algorithm names.
    # 
    # @param seed the seed.
    def initialize(seed)
      @provider = nil
      @secure_random_spi = nil
      @algorithm = nil
      @state = nil
      @digest = nil
      @random_bytes = nil
      @random_bytes_used = 0
      @counter = 0
      super(0)
      @provider = nil
      @secure_random_spi = nil
      @digest = nil
      get_default_prng(true, seed)
    end
    
    typesig { [::Java::Boolean, Array.typed(::Java::Byte)] }
    def get_default_prng(set_seed, seed)
      prng = get_prng_algorithm
      if ((prng).nil?)
        # bummer, get the SUN implementation
        prng = "SHA1PRNG"
        @secure_random_spi = Sun::Security::Provider::SecureRandom.new
        @provider = Providers.get_sun_provider
        if (set_seed)
          @secure_random_spi.engine_set_seed(seed)
        end
      else
        begin
          random = SecureRandom.get_instance(prng)
          @secure_random_spi = random.get_secure_random_spi
          @provider = random.get_provider
          if (set_seed)
            @secure_random_spi.engine_set_seed(seed)
          end
        rescue NoSuchAlgorithmException => nsae
          # never happens, because we made sure the algorithm exists
          raise RuntimeException.new(nsae)
        end
      end
      # JDK 1.1 based implementations subclass SecureRandom instead of
      # SecureRandomSpi. They will also go through this code path because
      # they must call a SecureRandom constructor as it is their superclass.
      # If we are dealing with such an implementation, do not set the
      # algorithm value as it would be inaccurate.
      if ((get_class).equal?(SecureRandom.class))
        @algorithm = prng
      end
    end
    
    typesig { [SecureRandomSpi, Provider] }
    # Creates a SecureRandom object.
    # 
    # @param secureRandomSpi the SecureRandom implementation.
    # @param provider the provider.
    def initialize(secure_random_spi, provider)
      initialize__secure_random(secure_random_spi, provider, nil)
    end
    
    typesig { [SecureRandomSpi, Provider, String] }
    def initialize(secure_random_spi, provider, algorithm)
      @provider = nil
      @secure_random_spi = nil
      @algorithm = nil
      @state = nil
      @digest = nil
      @random_bytes = nil
      @random_bytes_used = 0
      @counter = 0
      super(0)
      @provider = nil
      @secure_random_spi = nil
      @digest = nil
      @secure_random_spi = secure_random_spi
      @provider = provider
      @algorithm = algorithm
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Returns a SecureRandom object that implements the specified
      # Random Number Generator (RNG) algorithm.
      # 
      # <p> This method traverses the list of registered security Providers,
      # starting with the most preferred Provider.
      # A new SecureRandom object encapsulating the
      # SecureRandomSpi implementation from the first
      # Provider that supports the specified algorithm is returned.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # <p> The returned SecureRandom object has not been seeded.  To seed the
      # returned object, call the <code>setSeed</code> method.
      # If <code>setSeed</code> is not called, the first call to
      # <code>nextBytes</code> will force the SecureRandom object to seed itself.
      # This self-seeding will not occur if <code>setSeed</code> was
      # previously called.
      # 
      # @param algorithm the name of the RNG algorithm.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard RNG algorithm names.
      # 
      # @return the new SecureRandom object.
      # 
      # @exception NoSuchAlgorithmException if no Provider supports a
      # SecureRandomSpi implementation for the
      # specified algorithm.
      # 
      # @see Provider
      # 
      # @since 1.2
      def get_instance(algorithm)
        instance = GetInstance.get_instance("SecureRandom", SecureRandomSpi.class, algorithm)
        return SecureRandom.new(instance.attr_impl, instance.attr_provider, algorithm)
      end
      
      typesig { [String, String] }
      # Returns a SecureRandom object that implements the specified
      # Random Number Generator (RNG) algorithm.
      # 
      # <p> A new SecureRandom object encapsulating the
      # SecureRandomSpi implementation from the specified provider
      # is returned.  The specified provider must be registered
      # in the security provider list.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # <p> The returned SecureRandom object has not been seeded.  To seed the
      # returned object, call the <code>setSeed</code> method.
      # If <code>setSeed</code> is not called, the first call to
      # <code>nextBytes</code> will force the SecureRandom object to seed itself.
      # This self-seeding will not occur if <code>setSeed</code> was
      # previously called.
      # 
      # @param algorithm the name of the RNG algorithm.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard RNG algorithm names.
      # 
      # @param provider the name of the provider.
      # 
      # @return the new SecureRandom object.
      # 
      # @exception NoSuchAlgorithmException if a SecureRandomSpi
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
      # 
      # @since 1.2
      def get_instance(algorithm, provider)
        instance = GetInstance.get_instance("SecureRandom", SecureRandomSpi.class, algorithm, provider)
        return SecureRandom.new(instance.attr_impl, instance.attr_provider, algorithm)
      end
      
      typesig { [String, Provider] }
      # Returns a SecureRandom object that implements the specified
      # Random Number Generator (RNG) algorithm.
      # 
      # <p> A new SecureRandom object encapsulating the
      # SecureRandomSpi implementation from the specified Provider
      # object is returned.  Note that the specified Provider object
      # does not have to be registered in the provider list.
      # 
      # <p> The returned SecureRandom object has not been seeded.  To seed the
      # returned object, call the <code>setSeed</code> method.
      # If <code>setSeed</code> is not called, the first call to
      # <code>nextBytes</code> will force the SecureRandom object to seed itself.
      # This self-seeding will not occur if <code>setSeed</code> was
      # previously called.
      # 
      # @param algorithm the name of the RNG algorithm.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard RNG algorithm names.
      # 
      # @param provider the provider.
      # 
      # @return the new SecureRandom object.
      # 
      # @exception NoSuchAlgorithmException if a SecureRandomSpi
      # implementation for the specified algorithm is not available
      # from the specified Provider object.
      # 
      # @exception IllegalArgumentException if the specified provider is null.
      # 
      # @see Provider
      # 
      # @since 1.4
      def get_instance(algorithm, provider)
        instance = GetInstance.get_instance("SecureRandom", SecureRandomSpi.class, algorithm, provider)
        return SecureRandom.new(instance.attr_impl, instance.attr_provider, algorithm)
      end
    }
    
    typesig { [] }
    # Returns the SecureRandomSpi of this SecureRandom object.
    def get_secure_random_spi
      return @secure_random_spi
    end
    
    typesig { [] }
    # Returns the provider of this SecureRandom object.
    # 
    # @return the provider of this SecureRandom object.
    def get_provider
      return @provider
    end
    
    typesig { [] }
    # Returns the name of the algorithm implemented by this SecureRandom
    # object.
    # 
    # @return the name of the algorithm or <code>unknown</code>
    # if the algorithm name cannot be determined.
    # @since 1.5
    def get_algorithm
      return (!(@algorithm).nil?) ? @algorithm : "unknown"
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Reseeds this random object. The given seed supplements, rather than
    # replaces, the existing seed. Thus, repeated calls are guaranteed
    # never to reduce randomness.
    # 
    # @param seed the seed.
    # 
    # @see #getSeed
    def set_seed(seed)
      synchronized(self) do
        @secure_random_spi.engine_set_seed(seed)
      end
    end
    
    typesig { [::Java::Long] }
    # Reseeds this random object, using the eight bytes contained
    # in the given <code>long seed</code>. The given seed supplements,
    # rather than replaces, the existing seed. Thus, repeated calls
    # are guaranteed never to reduce randomness.
    # 
    # <p>This method is defined for compatibility with
    # <code>java.util.Random</code>.
    # 
    # @param seed the seed.
    # 
    # @see #getSeed
    def set_seed(seed)
      # Ignore call from super constructor (as well as any other calls
      # unfortunate enough to be passing 0).  It's critical that we
      # ignore call from superclass constructor, as digest has not
      # yet been initialized at that point.
      if (!(seed).equal?(0))
        @secure_random_spi.engine_set_seed(long_to_byte_array(seed))
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Generates a user-specified number of random bytes.
    # 
    # <p> If a call to <code>setSeed</code> had not occurred previously,
    # the first call to this method forces this SecureRandom object
    # to seed itself.  This self-seeding will not occur if
    # <code>setSeed</code> was previously called.
    # 
    # @param bytes the array to be filled in with random bytes.
    def next_bytes(bytes)
      synchronized(self) do
        @secure_random_spi.engine_next_bytes(bytes)
      end
    end
    
    typesig { [::Java::Int] }
    # Generates an integer containing the user-specified number of
    # pseudo-random bits (right justified, with leading zeros).  This
    # method overrides a <code>java.util.Random</code> method, and serves
    # to provide a source of random bits to all of the methods inherited
    # from that class (for example, <code>nextInt</code>,
    # <code>nextLong</code>, and <code>nextFloat</code>).
    # 
    # @param numBits number of pseudo-random bits to be generated, where
    # 0 <= <code>numBits</code> <= 32.
    # 
    # @return an <code>int</code> containing the user-specified number
    # of pseudo-random bits (right justified, with leading zeros).
    def next(num_bits)
      num_bytes = (num_bits + 7) / 8
      b = Array.typed(::Java::Byte).new(num_bytes) { 0 }
      next_ = 0
      next_bytes(b)
      i = 0
      while i < num_bytes
        next_ = (next_ << 8) + (b[i] & 0xff)
        ((i += 1) - 1)
      end
      return next_ >> (num_bytes * 8 - num_bits)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Returns the given number of seed bytes, computed using the seed
      # generation algorithm that this class uses to seed itself.  This
      # call may be used to seed other random number generators.
      # 
      # <p>This method is only included for backwards compatibility.
      # The caller is encouraged to use one of the alternative
      # <code>getInstance</code> methods to obtain a SecureRandom object, and
      # then call the <code>generateSeed</code> method to obtain seed bytes
      # from that object.
      # 
      # @param numBytes the number of seed bytes to generate.
      # 
      # @return the seed bytes.
      # 
      # @see #setSeed
      def get_seed(num_bytes)
        if ((self.attr_seed_generator).nil?)
          self.attr_seed_generator = SecureRandom.new
        end
        return self.attr_seed_generator.generate_seed(num_bytes)
      end
    }
    
    typesig { [::Java::Int] }
    # Returns the given number of seed bytes, computed using the seed
    # generation algorithm that this class uses to seed itself.  This
    # call may be used to seed other random number generators.
    # 
    # @param numBytes the number of seed bytes to generate.
    # 
    # @return the seed bytes.
    def generate_seed(num_bytes)
      return @secure_random_spi.engine_generate_seed(num_bytes)
    end
    
    class_module.module_eval {
      typesig { [::Java::Long] }
      # Helper function to convert a long into a byte array (least significant
      # byte first).
      def long_to_byte_array(l)
        ret_val = Array.typed(::Java::Byte).new(8) { 0 }
        i = 0
        while i < 8
          ret_val[i] = l
          l >>= 8
          ((i += 1) - 1)
        end
        return ret_val
      end
      
      typesig { [] }
      # Gets a default PRNG algorithm by looking through all registered
      # providers. Returns the first PRNG algorithm of the first provider that
      # has registered a SecureRandom implementation, or null if none of the
      # registered providers supplies a SecureRandom implementation.
      def get_prng_algorithm
        Providers.get_provider_list.providers.each do |p|
          p.get_services.each do |s|
            if ((s.get_type == "SecureRandom"))
              return s.get_algorithm
            end
          end
        end
        return nil
      end
      
      # Declare serialVersionUID to be compatible with JDK1.1
      const_set_lazy(:SerialVersionUID) { 4940670005562187 }
      const_attr_reader  :SerialVersionUID
    }
    
    # Retain unused values serialized from JDK1.1
    # 
    # @serial
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    # @serial
    attr_accessor :digest
    alias_method :attr_digest, :digest
    undef_method :digest
    alias_method :attr_digest=, :digest=
    undef_method :digest=
    
    # @serial
    # 
    # We know that the MessageDigest class does not implement
    # java.io.Serializable.  However, since this field is no longer
    # used, it will always be NULL and won't affect the serialization
    # of the SecureRandom class itself.
    attr_accessor :random_bytes
    alias_method :attr_random_bytes, :random_bytes
    undef_method :random_bytes
    alias_method :attr_random_bytes=, :random_bytes=
    undef_method :random_bytes=
    
    # @serial
    attr_accessor :random_bytes_used
    alias_method :attr_random_bytes_used, :random_bytes_used
    undef_method :random_bytes_used
    alias_method :attr_random_bytes_used=, :random_bytes_used=
    undef_method :random_bytes_used=
    
    # @serial
    attr_accessor :counter
    alias_method :attr_counter, :counter
    undef_method :counter
    alias_method :attr_counter=, :counter=
    undef_method :counter=
    
    private
    alias_method :initialize__secure_random, :initialize
  end
  
end
