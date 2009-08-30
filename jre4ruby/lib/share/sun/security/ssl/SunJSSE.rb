require "rjava"

# Copyright 1999-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SunJSSEImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Security
    }
  end
  
  # The JSSE provider.
  # 
  # The RSA implementation has been removed from JSSE, but we still need to
  # register the same algorithms for compatibility. We just point to the RSA
  # implementation in the SunRsaSign provider. This works because all classes
  # are in the bootclasspath and therefore loaded by the same classloader.
  # 
  # SunJSSE now supports an experimental FIPS compliant mode when used with an
  # appropriate FIPS certified crypto provider. In FIPS mode, we:
  # . allow only TLS 1.0
  # . allow only FIPS approved ciphersuites
  # . perform all crypto in the FIPS crypto provider
  # 
  # It is currently not possible to use both FIPS compliant SunJSSE and
  # standard JSSE at the same time because of the various static data structures
  # we use.
  # 
  # However, we do want to allow FIPS mode to be enabled at runtime and without
  # editing the java.security file. That means we need to allow
  # Security.removeProvider("SunJSSE") to work, which creates an instance of
  # this class in non-FIPS mode. That is why we delay the selection of the mode
  # as long as possible. This is until we open an SSL/TLS connection and the
  # data structures need to be initialized or until SunJSSE is initialized in
  # FIPS mode.
  class SunJSSE < Java::Security::Provider
    include_class_members SunJSSEImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 3231825739635378733 }
      const_attr_reader  :SerialVersionUID
      
      
      def info
        defined?(@@info) ? @@info : @@info= "Sun JSSE provider" + "(PKCS12, SunX509 key/trust factories, SSLv3, TLSv1)"
      end
      alias_method :attr_info, :info
      
      def info=(value)
        @@info = value
      end
      alias_method :attr_info=, :info=
      
      
      def fips_info
        defined?(@@fips_info) ? @@fips_info : @@fips_info= "Sun JSSE provider (FIPS mode, crypto provider "
      end
      alias_method :attr_fips_info, :fips_info
      
      def fips_info=(value)
        @@fips_info = value
      end
      alias_method :attr_fips_info=, :fips_info=
      
      # tri-valued flag:
      # null  := no final decision made
      # false := data structures initialized in non-FIPS mode
      # true  := data structures initialized in FIPS mode
      
      def fips
        defined?(@@fips) ? @@fips : @@fips= nil
      end
      alias_method :attr_fips, :fips
      
      def fips=(value)
        @@fips = value
      end
      alias_method :attr_fips=, :fips=
      
      # the FIPS certificate crypto provider that we use to perform all crypto
      # operations. null in non-FIPS mode
      
      def crypto_provider
        defined?(@@crypto_provider) ? @@crypto_provider : @@crypto_provider= nil
      end
      alias_method :attr_crypto_provider, :crypto_provider
      
      def crypto_provider=(value)
        @@crypto_provider = value
      end
      alias_method :attr_crypto_provider=, :crypto_provider=
      
      typesig { [] }
      def is_fips
        synchronized(self) do
          if ((self.attr_fips).nil?)
            self.attr_fips = false
          end
          return self.attr_fips
        end
      end
      
      typesig { [Java::Security::Provider] }
      # ensure we can use FIPS mode using the specified crypto provider.
      # enable FIPS mode if not already enabled.
      def ensure_fips(p)
        synchronized(self) do
          if ((self.attr_fips).nil?)
            self.attr_fips = true
            self.attr_crypto_provider = p
          else
            if ((self.attr_fips).equal?(false))
              raise ProviderException.new("SunJSSE already initialized in non-FIPS mode")
            end
            if (!(self.attr_crypto_provider).equal?(p))
              raise ProviderException.new("SunJSSE already initialized with FIPS crypto provider " + RJava.cast_to_string(self.attr_crypto_provider))
            end
          end
        end
      end
    }
    
    typesig { [] }
    # standard constructor
    def initialize
      super("SunJSSE", 1.6, self.attr_info)
      subclass_check
      if ((Boolean::TRUE == self.attr_fips))
        raise ProviderException.new("SunJSSE is already initialized in FIPS mode")
      end
      register_algorithms(false)
    end
    
    typesig { [Java::Security::Provider] }
    # prefered constructor to enable FIPS mode at runtime
    def initialize(crypto_provider)
      initialize__sun_jsse(check_null(crypto_provider), crypto_provider.get_name)
    end
    
    typesig { [String] }
    # constructor to enable FIPS mode from java.security file
    def initialize(crypto_provider)
      initialize__sun_jsse(nil, check_null(crypto_provider))
    end
    
    class_module.module_eval {
      typesig { [T] }
      def check_null(t)
        if ((t).nil?)
          raise ProviderException.new("cryptoProvider must not be null")
        end
        return t
      end
    }
    
    typesig { [Java::Security::Provider, String] }
    def initialize(crypto_provider, provider_name)
      super("SunJSSE", 1.6, self.attr_fips_info + provider_name + ")")
      subclass_check
      if ((crypto_provider).nil?)
        # Calling Security.getProvider() will cause other providers to be
        # loaded. That is not good but unavoidable here.
        crypto_provider = Security.get_provider(provider_name)
        if ((crypto_provider).nil?)
          raise ProviderException.new("Crypto provider not installed: " + provider_name)
        end
      end
      ensure_fips(crypto_provider)
      register_algorithms(true)
    end
    
    typesig { [::Java::Boolean] }
    def register_algorithms(isfips)
      AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members SunJSSE
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          do_register(isfips)
          return nil
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [::Java::Boolean] }
    def do_register(isfips)
      if ((isfips).equal?(false))
        put("KeyFactory.RSA", "sun.security.rsa.RSAKeyFactory")
        put("Alg.Alias.KeyFactory.1.2.840.113549.1.1", "RSA")
        put("Alg.Alias.KeyFactory.OID.1.2.840.113549.1.1", "RSA")
        put("KeyPairGenerator.RSA", "sun.security.rsa.RSAKeyPairGenerator")
        put("Alg.Alias.KeyPairGenerator.1.2.840.113549.1.1", "RSA")
        put("Alg.Alias.KeyPairGenerator.OID.1.2.840.113549.1.1", "RSA")
        put("Signature.MD2withRSA", "sun.security.rsa.RSASignature$MD2withRSA")
        put("Alg.Alias.Signature.1.2.840.113549.1.1.2", "MD2withRSA")
        put("Alg.Alias.Signature.OID.1.2.840.113549.1.1.2", "MD2withRSA")
        put("Signature.MD5withRSA", "sun.security.rsa.RSASignature$MD5withRSA")
        put("Alg.Alias.Signature.1.2.840.113549.1.1.4", "MD5withRSA")
        put("Alg.Alias.Signature.OID.1.2.840.113549.1.1.4", "MD5withRSA")
        put("Signature.SHA1withRSA", "sun.security.rsa.RSASignature$SHA1withRSA")
        put("Alg.Alias.Signature.1.2.840.113549.1.1.5", "SHA1withRSA")
        put("Alg.Alias.Signature.OID.1.2.840.113549.1.1.5", "SHA1withRSA")
        put("Alg.Alias.Signature.1.3.14.3.2.29", "SHA1withRSA")
        put("Alg.Alias.Signature.OID.1.3.14.3.2.29", "SHA1withRSA")
      end
      put("Signature.MD5andSHA1withRSA", "sun.security.ssl.RSASignature")
      put("KeyManagerFactory.SunX509", "sun.security.ssl.KeyManagerFactoryImpl$SunX509")
      put("KeyManagerFactory.NewSunX509", "sun.security.ssl.KeyManagerFactoryImpl$X509")
      put("TrustManagerFactory.SunX509", "sun.security.ssl.TrustManagerFactoryImpl$SimpleFactory")
      put("TrustManagerFactory.PKIX", "sun.security.ssl.TrustManagerFactoryImpl$PKIXFactory")
      put("Alg.Alias.TrustManagerFactory.SunPKIX", "PKIX")
      put("Alg.Alias.TrustManagerFactory.X509", "PKIX")
      put("Alg.Alias.TrustManagerFactory.X.509", "PKIX")
      if ((isfips).equal?(false))
        put("SSLContext.SSL", "sun.security.ssl.SSLContextImpl")
        put("SSLContext.SSLv3", "sun.security.ssl.SSLContextImpl")
      end
      put("SSLContext.TLS", "sun.security.ssl.SSLContextImpl")
      put("SSLContext.TLSv1", "sun.security.ssl.SSLContextImpl")
      put("SSLContext.Default", "sun.security.ssl.DefaultSSLContextImpl")
      # KeyStore
      put("KeyStore.PKCS12", "sun.security.pkcs12.PKCS12KeyStore")
    end
    
    typesig { [] }
    def subclass_check
      if (!(get_class).equal?(Com::Sun::Net::Ssl::Internal::Ssl::Provider))
        raise AssertionError.new("Illegal subclass: " + RJava.cast_to_string(get_class))
      end
    end
    
    typesig { [] }
    def finalize
      # empty
      super
    end
    
    private
    alias_method :initialize__sun_jsse, :initialize
  end
  
end
