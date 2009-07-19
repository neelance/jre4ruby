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
  module KeyFactoryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Util
      include_const ::Java::Security::Provider, :Service
      include_const ::Java::Security::Spec, :KeySpec
      include_const ::Java::Security::Spec, :InvalidKeySpecException
      include_const ::Sun::Security::Util, :Debug
      include ::Sun::Security::Jca
      include_const ::Sun::Security::Jca::GetInstance, :Instance
    }
  end
  
  # Key factories are used to convert <I>keys</I> (opaque
  # cryptographic keys of type <code>Key</code>) into <I>key specifications</I>
  # (transparent representations of the underlying key material), and vice
  # versa.
  # 
  # <P> Key factories are bi-directional. That is, they allow you to build an
  # opaque key object from a given key specification (key material), or to
  # retrieve the underlying key material of a key object in a suitable format.
  # 
  # <P> Multiple compatible key specifications may exist for the same key.
  # For example, a DSA public key may be specified using
  # <code>DSAPublicKeySpec</code> or
  # <code>X509EncodedKeySpec</code>. A key factory can be used to translate
  # between compatible key specifications.
  # 
  # <P> The following is an example of how to use a key factory in order to
  # instantiate a DSA public key from its encoding.
  # Assume Alice has received a digital signature from Bob.
  # Bob also sent her his public key (in encoded format) to verify
  # his signature. Alice then performs the following actions:
  # 
  # <pre>
  # X509EncodedKeySpec bobPubKeySpec = new X509EncodedKeySpec(bobEncodedPubKey);
  # KeyFactory keyFactory = KeyFactory.getInstance("DSA");
  # PublicKey bobPubKey = keyFactory.generatePublic(bobPubKeySpec);
  # Signature sig = Signature.getInstance("DSA");
  # sig.initVerify(bobPubKey);
  # sig.update(data);
  # sig.verify(signature);
  # </pre>
  # 
  # @author Jan Luehe
  # 
  # 
  # @see Key
  # @see PublicKey
  # @see PrivateKey
  # @see java.security.spec.KeySpec
  # @see java.security.spec.DSAPublicKeySpec
  # @see java.security.spec.X509EncodedKeySpec
  # 
  # @since 1.2
  class KeyFactory 
    include_class_members KeyFactoryImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("jca", "KeyFactory") }
      const_attr_reader  :Debug
    }
    
    # The algorithm associated with this key factory
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
    
    # The provider implementation (delegate)
    attr_accessor :spi
    alias_method :attr_spi, :spi
    undef_method :spi
    alias_method :attr_spi=, :spi=
    undef_method :spi=
    
    # lock for mutex during provider selection
    attr_accessor :lock
    alias_method :attr_lock, :lock
    undef_method :lock
    alias_method :attr_lock=, :lock=
    undef_method :lock=
    
    # remaining services to try in provider selection
    # null once provider is selected
    attr_accessor :service_iterator
    alias_method :attr_service_iterator, :service_iterator
    undef_method :service_iterator
    alias_method :attr_service_iterator=, :service_iterator=
    undef_method :service_iterator=
    
    typesig { [KeyFactorySpi, Provider, String] }
    # Creates a KeyFactory object.
    # 
    # @param keyFacSpi the delegate
    # @param provider the provider
    # @param algorithm the name of the algorithm
    # to associate with this <tt>KeyFactory</tt>
    def initialize(key_fac_spi, provider, algorithm)
      @algorithm = nil
      @provider = nil
      @spi = nil
      @lock = Object.new
      @service_iterator = nil
      @spi = key_fac_spi
      @provider = provider
      @algorithm = algorithm
    end
    
    typesig { [String] }
    def initialize(algorithm)
      @algorithm = nil
      @provider = nil
      @spi = nil
      @lock = Object.new
      @service_iterator = nil
      @algorithm = algorithm
      list = GetInstance.get_services("KeyFactory", algorithm)
      @service_iterator = list.iterator
      # fetch and instantiate initial spi
      if ((next_spi(nil)).nil?)
        raise NoSuchAlgorithmException.new(algorithm + " KeyFactory not available")
      end
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Returns a KeyFactory object that converts
      # public/private keys of the specified algorithm.
      # 
      # <p> This method traverses the list of registered security Providers,
      # starting with the most preferred Provider.
      # A new KeyFactory object encapsulating the
      # KeyFactorySpi implementation from the first
      # Provider that supports the specified algorithm is returned.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # @param algorithm the name of the requested key algorithm.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @return the new KeyFactory object.
      # 
      # @exception NoSuchAlgorithmException if no Provider supports a
      # KeyFactorySpi implementation for the
      # specified algorithm.
      # 
      # @see Provider
      def get_instance(algorithm)
        return KeyFactory.new(algorithm)
      end
      
      typesig { [String, String] }
      # Returns a KeyFactory object that converts
      # public/private keys of the specified algorithm.
      # 
      # <p> A new KeyFactory object encapsulating the
      # KeyFactorySpi implementation from the specified provider
      # is returned.  The specified provider must be registered
      # in the security provider list.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # @param algorithm the name of the requested key algorithm.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @param provider the name of the provider.
      # 
      # @return the new KeyFactory object.
      # 
      # @exception NoSuchAlgorithmException if a KeyFactorySpi
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
        instance = GetInstance.get_instance("KeyFactory", KeyFactorySpi.class, algorithm, provider)
        return KeyFactory.new(instance.attr_impl, instance.attr_provider, algorithm)
      end
      
      typesig { [String, Provider] }
      # Returns a KeyFactory object that converts
      # public/private keys of the specified algorithm.
      # 
      # <p> A new KeyFactory object encapsulating the
      # KeyFactorySpi implementation from the specified Provider
      # object is returned.  Note that the specified Provider object
      # does not have to be registered in the provider list.
      # 
      # @param algorithm the name of the requested key algorithm.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @param provider the provider.
      # 
      # @return the new KeyFactory object.
      # 
      # @exception NoSuchAlgorithmException if a KeyFactorySpi
      # implementation for the specified algorithm is not available
      # from the specified Provider object.
      # 
      # @exception IllegalArgumentException if the specified provider is null.
      # 
      # @see Provider
      # 
      # @since 1.4
      def get_instance(algorithm, provider)
        instance = GetInstance.get_instance("KeyFactory", KeyFactorySpi.class, algorithm, provider)
        return KeyFactory.new(instance.attr_impl, instance.attr_provider, algorithm)
      end
    }
    
    typesig { [] }
    # Returns the provider of this key factory object.
    # 
    # @return the provider of this key factory object
    def get_provider
      synchronized((@lock)) do
        # disable further failover after this call
        @service_iterator = nil
        return @provider
      end
    end
    
    typesig { [] }
    # Gets the name of the algorithm
    # associated with this <tt>KeyFactory</tt>.
    # 
    # @return the name of the algorithm associated with this
    # <tt>KeyFactory</tt>
    def get_algorithm
      return @algorithm
    end
    
    typesig { [KeyFactorySpi] }
    # Update the active KeyFactorySpi of this class and return the next
    # implementation for failover. If no more implemenations are
    # available, this method returns null. However, the active spi of
    # this class is never set to null.
    def next_spi(old_spi)
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
          s = @service_iterator.next
          begin
            obj = s.new_instance(nil)
            if ((obj.is_a?(KeyFactorySpi)).equal?(false))
              next
            end
            spi = obj
            @provider = s.get_provider
            @spi = spi
            return spi
          rescue NoSuchAlgorithmException => e
            # ignore
          end
        end
        @service_iterator = nil
        return nil
      end
    end
    
    typesig { [KeySpec] }
    # Generates a public key object from the provided key specification
    # (key material).
    # 
    # @param keySpec the specification (key material) of the public key.
    # 
    # @return the public key.
    # 
    # @exception InvalidKeySpecException if the given key specification
    # is inappropriate for this key factory to produce a public key.
    def generate_public(key_spec)
      if ((@service_iterator).nil?)
        return @spi.engine_generate_public(key_spec)
      end
      failure = nil
      my_spi = @spi
      begin
        begin
          return my_spi.engine_generate_public(key_spec)
        rescue Exception => e
          if ((failure).nil?)
            failure = e
          end
          my_spi = next_spi(my_spi)
        end
      end while (!(my_spi).nil?)
      if (failure.is_a?(RuntimeException))
        raise failure
      end
      if (failure.is_a?(InvalidKeySpecException))
        raise failure
      end
      raise InvalidKeySpecException.new("Could not generate public key", failure)
    end
    
    typesig { [KeySpec] }
    # Generates a private key object from the provided key specification
    # (key material).
    # 
    # @param keySpec the specification (key material) of the private key.
    # 
    # @return the private key.
    # 
    # @exception InvalidKeySpecException if the given key specification
    # is inappropriate for this key factory to produce a private key.
    def generate_private(key_spec)
      if ((@service_iterator).nil?)
        return @spi.engine_generate_private(key_spec)
      end
      failure = nil
      my_spi = @spi
      begin
        begin
          return my_spi.engine_generate_private(key_spec)
        rescue Exception => e
          if ((failure).nil?)
            failure = e
          end
          my_spi = next_spi(my_spi)
        end
      end while (!(my_spi).nil?)
      if (failure.is_a?(RuntimeException))
        raise failure
      end
      if (failure.is_a?(InvalidKeySpecException))
        raise failure
      end
      raise InvalidKeySpecException.new("Could not generate private key", failure)
    end
    
    typesig { [Key, Class] }
    # Returns a specification (key material) of the given key object.
    # <code>keySpec</code> identifies the specification class in which
    # the key material should be returned. It could, for example, be
    # <code>DSAPublicKeySpec.class</code>, to indicate that the
    # key material should be returned in an instance of the
    # <code>DSAPublicKeySpec</code> class.
    # 
    # @param key the key.
    # 
    # @param keySpec the specification class in which
    # the key material should be returned.
    # 
    # @return the underlying key specification (key material) in an instance
    # of the requested specification class.
    # 
    # @exception InvalidKeySpecException if the requested key specification is
    # inappropriate for the given key, or the given key cannot be processed
    # (e.g., the given key has an unrecognized algorithm or format).
    def get_key_spec(key, key_spec)
      if ((@service_iterator).nil?)
        return @spi.engine_get_key_spec(key, key_spec)
      end
      failure = nil
      my_spi = @spi
      begin
        begin
          return my_spi.engine_get_key_spec(key, key_spec)
        rescue Exception => e
          if ((failure).nil?)
            failure = e
          end
          my_spi = next_spi(my_spi)
        end
      end while (!(my_spi).nil?)
      if (failure.is_a?(RuntimeException))
        raise failure
      end
      if (failure.is_a?(InvalidKeySpecException))
        raise failure
      end
      raise InvalidKeySpecException.new("Could not get key spec", failure)
    end
    
    typesig { [Key] }
    # Translates a key object, whose provider may be unknown or potentially
    # untrusted, into a corresponding key object of this key factory.
    # 
    # @param key the key whose provider is unknown or untrusted.
    # 
    # @return the translated key.
    # 
    # @exception InvalidKeyException if the given key cannot be processed
    # by this key factory.
    def translate_key(key)
      if ((@service_iterator).nil?)
        return @spi.engine_translate_key(key)
      end
      failure = nil
      my_spi = @spi
      begin
        begin
          return my_spi.engine_translate_key(key)
        rescue Exception => e
          if ((failure).nil?)
            failure = e
          end
          my_spi = next_spi(my_spi)
        end
      end while (!(my_spi).nil?)
      if (failure.is_a?(RuntimeException))
        raise failure
      end
      if (failure.is_a?(InvalidKeyException))
        raise failure
      end
      raise InvalidKeyException.new("Could not translate key", failure)
    end
    
    private
    alias_method :initialize__key_factory, :initialize
  end
  
end
