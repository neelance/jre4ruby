require "rjava"

# Copyright 2001-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module JsseJceImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Util
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include_const ::Java::Security::Interfaces, :RSAPublicKey
      include_const ::Java::Security::Spec, :RSAPublicKeySpec
      include ::Java::Security::Spec
      include ::Javax::Crypto
      include_const ::Java::Security, :Provider
      include_const ::Sun::Security::Jca, :Providers
      include_const ::Sun::Security::Jca, :ProviderList
      include_const ::Sun::Security::Ec, :ECParameters
      include_const ::Sun::Security::Ec, :NamedCurve
      include_const ::Sun::Security::Ssl::SunJSSE, :CryptoProvider
    }
  end
  
  # explicit import to override the Provider class in this package
  # need internal Sun classes for FIPS tricks
  # 
  # This class contains a few static methods for interaction with the JCA/JCE
  # to obtain implementations, etc.
  # 
  # @author  Andreas Sterbenz
  class JsseJce 
    include_class_members JsseJceImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("ssl") }
      const_attr_reader  :Debug
      
      # Flag indicating whether EC crypto is available.
      # If null, then we have not checked yet.
      # If yes, then all the EC based crypto we need is available.
      
      def ec_available
        defined?(@@ec_available) ? @@ec_available : @@ec_available= nil
      end
      alias_method :attr_ec_available, :ec_available
      
      def ec_available=(value)
        @@ec_available = value
      end
      alias_method :attr_ec_available=, :ec_available=
      
      when_class_loaded do
        # force FIPS flag initialization
        # Because isFIPS() is synchronized and cryptoProvider is not modified
        # after it completes, this also eliminates the need for any further
        # synchronization when accessing cryptoProvider
        if ((SunJSSE.is_fips).equal?(false))
          const_set :FipsProviderList, nil
        else
          # Setup a ProviderList that can be used by the trust manager
          # during certificate chain validation. All the crypto must be
          # from the FIPS provider, but we also allow the required
          # certificate related services from the SUN provider.
          sun = Security.get_provider("SUN")
          if ((sun).nil?)
            raise RuntimeException.new("FIPS mode: SUN provider must be installed")
          end
          sun_certs = SunCertificates.new(sun)
          const_set :FipsProviderList, ProviderList.new_list(self.attr_crypto_provider, sun_certs)
        end
      end
      
      const_set_lazy(:SunCertificates) { Class.new(Provider) do
        include_class_members JsseJce
        
        typesig { [self::Provider] }
        def initialize(p)
          super("SunCertificates", 1.0, "SunJSSE internal")
          AccessController.do_privileged(Class.new(self.class::PrivilegedAction.class == Class ? self.class::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members SunCertificates
            include self::PrivilegedAction if self::PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              # copy certificate related services from the Sun provider
              p.entry_set.each do |entry|
                key = entry.get_key
                if (key.starts_with("CertPathValidator.") || key.starts_with("CertPathBuilder.") || key.starts_with("CertStore.") || key.starts_with("CertificateFactory."))
                  put(key, entry.get_value)
                end
              end
              return nil
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        
        private
        alias_method :initialize__sun_certificates, :initialize
      end }
      
      # JCE transformation string for RSA with PKCS#1 v1.5 padding.
      # Can be used for encryption, decryption, signing, verifying.
      const_set_lazy(:CIPHER_RSA_PKCS1) { "RSA/ECB/PKCS1Padding" }
      const_attr_reader  :CIPHER_RSA_PKCS1
      
      # JCE transformation string for the stream cipher RC4.
      const_set_lazy(:CIPHER_RC4) { "RC4" }
      const_attr_reader  :CIPHER_RC4
      
      # JCE transformation string for DES in CBC mode without padding.
      const_set_lazy(:CIPHER_DES) { "DES/CBC/NoPadding" }
      const_attr_reader  :CIPHER_DES
      
      # JCE transformation string for (3-key) Triple DES in CBC mode
      # without padding.
      const_set_lazy(:CIPHER_3DES) { "DESede/CBC/NoPadding" }
      const_attr_reader  :CIPHER_3DES
      
      # JCE transformation string for AES in CBC mode
      # without padding.
      const_set_lazy(:CIPHER_AES) { "AES/CBC/NoPadding" }
      const_attr_reader  :CIPHER_AES
      
      # JCA identifier string for DSA, i.e. a DSA with SHA-1.
      const_set_lazy(:SIGNATURE_DSA) { "DSA" }
      const_attr_reader  :SIGNATURE_DSA
      
      # JCA identifier string for ECDSA, i.e. a ECDSA with SHA-1.
      const_set_lazy(:SIGNATURE_ECDSA) { "SHA1withECDSA" }
      const_attr_reader  :SIGNATURE_ECDSA
      
      # JCA identifier string for Raw DSA, i.e. a DSA signature without
      # hashing where the application provides the SHA-1 hash of the data.
      # Note that the standard name is "NONEwithDSA" but we use "RawDSA"
      # for compatibility.
      const_set_lazy(:SIGNATURE_RAWDSA) { "RawDSA" }
      const_attr_reader  :SIGNATURE_RAWDSA
      
      # JCA identifier string for Raw ECDSA, i.e. a DSA signature without
      # hashing where the application provides the SHA-1 hash of the data.
      const_set_lazy(:SIGNATURE_RAWECDSA) { "NONEwithECDSA" }
      const_attr_reader  :SIGNATURE_RAWECDSA
      
      # JCA identifier string for Raw RSA, i.e. a RSA PKCS#1 v1.5 signature
      # without hashing where the application provides the hash of the data.
      # Used for RSA client authentication with a 36 byte hash.
      const_set_lazy(:SIGNATURE_RAWRSA) { "NONEwithRSA" }
      const_attr_reader  :SIGNATURE_RAWRSA
      
      # JCA identifier string for the SSL/TLS style RSA Signature. I.e.
      # an signature using RSA with PKCS#1 v1.5 padding signing a
      # concatenation of an MD5 and SHA-1 digest.
      const_set_lazy(:SIGNATURE_SSLRSA) { "MD5andSHA1withRSA" }
      const_attr_reader  :SIGNATURE_SSLRSA
    }
    
    typesig { [] }
    def initialize
      # no instantiation of this class
    end
    
    class_module.module_eval {
      typesig { [] }
      def is_ec_available
        if ((self.attr_ec_available).nil?)
          begin
            JsseJce.get_signature(SIGNATURE_ECDSA)
            JsseJce.get_signature(SIGNATURE_RAWECDSA)
            JsseJce.get_key_agreement("ECDH")
            JsseJce.get_key_factory("EC")
            JsseJce.get_key_pair_generator("EC")
            self.attr_ec_available = true
          rescue JavaException => e
            self.attr_ec_available = false
          end
        end
        return self.attr_ec_available
      end
      
      typesig { [] }
      def clear_ec_available
        self.attr_ec_available = nil
      end
      
      typesig { [String] }
      # Return an JCE cipher implementation for the specified algorithm.
      def get_cipher(transformation)
        begin
          if ((self.attr_crypto_provider).nil?)
            return Cipher.get_instance(transformation)
          else
            return Cipher.get_instance(transformation, self.attr_crypto_provider)
          end
        rescue NoSuchPaddingException => e
          raise NoSuchAlgorithmException.new(e)
        end
      end
      
      typesig { [String] }
      # Return an JCA signature implementation for the specified algorithm.
      # The algorithm string should be one of the constants defined
      # in this class.
      def get_signature(algorithm)
        if ((self.attr_crypto_provider).nil?)
          return Signature.get_instance(algorithm)
        else
          # reference equality
          if ((algorithm).equal?(SIGNATURE_SSLRSA))
            # The SunPKCS11 provider currently does not support this
            # special algorithm. We allow a fallback in this case because
            # the SunJSSE implementation does the actual crypto using
            # a NONEwithRSA signature obtained from the cryptoProvider.
            if ((self.attr_crypto_provider.get_service("Signature", algorithm)).nil?)
              # Calling Signature.getInstance() and catching the exception
              # would be cleaner, but exceptions are a little expensive.
              # So we check directly via getService().
              begin
                return Signature.get_instance(algorithm, "SunJSSE")
              rescue NoSuchProviderException => e
                raise NoSuchAlgorithmException.new(e)
              end
            end
          end
          return Signature.get_instance(algorithm, self.attr_crypto_provider)
        end
      end
      
      typesig { [String] }
      def get_key_generator(algorithm)
        if ((self.attr_crypto_provider).nil?)
          return KeyGenerator.get_instance(algorithm)
        else
          return KeyGenerator.get_instance(algorithm, self.attr_crypto_provider)
        end
      end
      
      typesig { [String] }
      def get_key_pair_generator(algorithm)
        if ((self.attr_crypto_provider).nil?)
          return KeyPairGenerator.get_instance(algorithm)
        else
          return KeyPairGenerator.get_instance(algorithm, self.attr_crypto_provider)
        end
      end
      
      typesig { [String] }
      def get_key_agreement(algorithm)
        if ((self.attr_crypto_provider).nil?)
          return KeyAgreement.get_instance(algorithm)
        else
          return KeyAgreement.get_instance(algorithm, self.attr_crypto_provider)
        end
      end
      
      typesig { [String] }
      def get_mac(algorithm)
        if ((self.attr_crypto_provider).nil?)
          return Mac.get_instance(algorithm)
        else
          return Mac.get_instance(algorithm, self.attr_crypto_provider)
        end
      end
      
      typesig { [String] }
      def get_key_factory(algorithm)
        if ((self.attr_crypto_provider).nil?)
          return KeyFactory.get_instance(algorithm)
        else
          return KeyFactory.get_instance(algorithm, self.attr_crypto_provider)
        end
      end
      
      typesig { [] }
      def get_secure_random
        if ((self.attr_crypto_provider).nil?)
          return SecureRandom.new
        end
        # Try "PKCS11" first. If that is not supported, iterate through
        # the provider and return the first working implementation.
        begin
          return SecureRandom.get_instance("PKCS11", self.attr_crypto_provider)
        rescue NoSuchAlgorithmException => e
          # ignore
        end
        self.attr_crypto_provider.get_services.each do |s|
          if ((s.get_type == "SecureRandom"))
            begin
              return SecureRandom.get_instance(s.get_algorithm, self.attr_crypto_provider)
            rescue NoSuchAlgorithmException => ee
              # ignore
            end
          end
        end
        raise KeyManagementException.new("FIPS mode: no SecureRandom " + " implementation found in provider " + RJava.cast_to_string(self.attr_crypto_provider.get_name))
      end
      
      typesig { [] }
      def get_md5
        return get_message_digest("MD5")
      end
      
      typesig { [] }
      def get_sha
        return get_message_digest("SHA")
      end
      
      typesig { [String] }
      def get_message_digest(algorithm)
        begin
          if ((self.attr_crypto_provider).nil?)
            return MessageDigest.get_instance(algorithm)
          else
            return MessageDigest.get_instance(algorithm, self.attr_crypto_provider)
          end
        rescue NoSuchAlgorithmException => e
          raise RuntimeException.new("Algorithm " + algorithm + " not available", e)
        end
      end
      
      typesig { [PublicKey] }
      def get_rsakey_length(key)
        modulus = nil
        if (key.is_a?(RSAPublicKey))
          modulus = (key).get_modulus
        else
          spec = get_rsapublic_key_spec(key)
          modulus = spec.get_modulus
        end
        return modulus.bit_length
      end
      
      typesig { [PublicKey] }
      def get_rsapublic_key_spec(key)
        if (key.is_a?(RSAPublicKey))
          rsa_key = key
          return RSAPublicKeySpec.new(rsa_key.get_modulus, rsa_key.get_public_exponent)
        end
        begin
          factory = JsseJce.get_key_factory("RSA")
          return factory.get_key_spec(key, RSAPublicKeySpec)
        rescue JavaException => e
          raise RuntimeException.new.init_cause(e)
        end
      end
      
      typesig { [String] }
      def get_ecparameter_spec(named_curve_oid)
        return NamedCurve.get_ecparameter_spec(named_curve_oid)
      end
      
      typesig { [ECParameterSpec] }
      def get_named_curve_oid(params)
        return ECParameters.get_curve_name(params)
      end
      
      typesig { [Array.typed(::Java::Byte), EllipticCurve] }
      def decode_point(encoded, curve)
        return ECParameters.decode_point(encoded, curve)
      end
      
      typesig { [ECPoint, EllipticCurve] }
      def encode_point(point, curve)
        return ECParameters.encode_point(point, curve)
      end
      
      typesig { [] }
      # In FIPS mode, set thread local providers; otherwise a no-op.
      # Must be paired with endFipsProvider.
      def begin_fips_provider
        if ((FipsProviderList).nil?)
          return nil
        else
          return Providers.begin_thread_provider_list(FipsProviderList)
        end
      end
      
      typesig { [Object] }
      def end_fips_provider(o)
        if (!(FipsProviderList).nil?)
          Providers.end_thread_provider_list(o)
        end
      end
    }
    
    private
    alias_method :initialize__jsse_jce, :initialize
  end
  
end
