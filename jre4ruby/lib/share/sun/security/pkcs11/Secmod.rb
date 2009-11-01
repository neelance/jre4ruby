require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Pkcs11
  module SecmodImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Io
      include ::Java::Util
      include ::Java::Security
      include ::Java::Security::KeyStore
      include_const ::Java::Security::Cert, :X509Certificate
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # The Secmod class defines the interface to the native NSS
  # library and the configuration information it stores in its
  # secmod.db file.
  # 
  # <p>Example code:
  # <pre>
  # Secmod secmod = Secmod.getInstance();
  # if (secmod.isInitialized() == false) {
  # secmod.initialize("/home/myself/.mozilla", "/usr/sfw/lib/mozilla");
  # }
  # 
  # Provider p = secmod.getModule(ModuleType.KEYSTORE).getProvider();
  # KeyStore ks = KeyStore.getInstance("PKCS11", p);
  # ks.load(null, password);
  # </pre>
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class Secmod 
    include_class_members SecmodImports
    
    class_module.module_eval {
      const_set_lazy(:DEBUG) { false }
      const_attr_reader  :DEBUG
      
      when_class_loaded do
        Sun::Security::Pkcs11::Wrapper::PKCS11.load_native
        const_set :INSTANCE, Secmod.new
      end
      
      const_set_lazy(:NSS_LIB_NAME) { "nss3" }
      const_attr_reader  :NSS_LIB_NAME
      
      const_set_lazy(:SOFTTOKEN_LIB_NAME) { "softokn3" }
      const_attr_reader  :SOFTTOKEN_LIB_NAME
      
      const_set_lazy(:TRUST_LIB_NAME) { "nssckbi" }
      const_attr_reader  :TRUST_LIB_NAME
    }
    
    # handle to be passed to the native code, 0 means not initialized
    attr_accessor :nss_handle
    alias_method :attr_nss_handle, :nss_handle
    undef_method :nss_handle
    alias_method :attr_nss_handle=, :nss_handle=
    undef_method :nss_handle=
    
    # whether this is a supported version of NSS
    attr_accessor :supported
    alias_method :attr_supported, :supported
    undef_method :supported
    alias_method :attr_supported=, :supported=
    undef_method :supported=
    
    # list of the modules
    attr_accessor :modules
    alias_method :attr_modules, :modules
    undef_method :modules
    alias_method :attr_modules=, :modules=
    undef_method :modules=
    
    attr_accessor :config_dir
    alias_method :attr_config_dir, :config_dir
    undef_method :config_dir
    alias_method :attr_config_dir=, :config_dir=
    undef_method :config_dir=
    
    attr_accessor :nss_lib_dir
    alias_method :attr_nss_lib_dir, :nss_lib_dir
    undef_method :nss_lib_dir
    alias_method :attr_nss_lib_dir=, :nss_lib_dir=
    undef_method :nss_lib_dir=
    
    typesig { [] }
    def initialize
      @nss_handle = 0
      @supported = false
      @modules = nil
      @config_dir = nil
      @nss_lib_dir = nil
      # empty
    end
    
    class_module.module_eval {
      typesig { [] }
      # Return the singleton Secmod instance.
      def get_instance
        return INSTANCE
      end
    }
    
    typesig { [] }
    def is_loaded
      if ((@nss_handle).equal?(0))
        @nss_handle = nss_get_library_handle(System.map_library_name(NSS_LIB_NAME))
        if (!(@nss_handle).equal?(0))
          fetch_versions
        end
      end
      return (!(@nss_handle).equal?(0))
    end
    
    typesig { [] }
    def fetch_versions
      @supported = nss_version_check(@nss_handle, "3.7")
    end
    
    typesig { [] }
    # Test whether this Secmod has been initialized. Returns true
    # if NSS has been initialized using either the initialize() method
    # or by directly calling the native NSS APIs. The latter may be
    # the case if the current process contains components that use
    # NSS directly.
    # 
    # @throws IOException if an incompatible version of NSS
    # has been loaded
    def is_initialized
      synchronized(self) do
        # NSS does not allow us to check if it is initialized already
        # assume that if it is loaded it is also initialized
        if ((is_loaded).equal?(false))
          return false
        end
        if ((@supported).equal?(false))
          raise IOException.new("An incompatible version of NSS is already loaded, " + "3.7 or later required")
        end
        return true
      end
    end
    
    typesig { [] }
    def get_config_dir
      return @config_dir
    end
    
    typesig { [] }
    def get_lib_dir
      return @nss_lib_dir
    end
    
    typesig { [String, String] }
    # Initialize this Secmod.
    # 
    # @param configDir the directory containing the NSS configuration
    # files such as secmod.db
    # @param nssLibDir the directory containing the NSS libraries
    # (libnss3.so or nss3.dll) or null if the library is on
    # the system default shared library path
    # 
    # @throws IOException if NSS has already been initialized,
    # the specified directories are invalid, or initialization
    # fails for any other reason
    def initialize_(config_dir, nss_lib_dir)
      initialize_(DbMode::READ_WRITE, config_dir, nss_lib_dir)
    end
    
    typesig { [DbMode, String, String] }
    def initialize_(db_mode, config_dir, nss_lib_dir)
      synchronized(self) do
        if (is_initialized)
          raise IOException.new("NSS is already initialized")
        end
        if ((db_mode).nil?)
          raise NullPointerException.new
        end
        if ((!(db_mode).equal?(DbMode::NO_DB)) && ((config_dir).nil?))
          raise NullPointerException.new
        end
        platform_lib_name = System.map_library_name("nss3")
        platform_path = nil
        if ((nss_lib_dir).nil?)
          platform_path = platform_lib_name
        else
          base = JavaFile.new(nss_lib_dir)
          if ((base.is_directory).equal?(false))
            raise IOException.new("nssLibDir must be a directory:" + nss_lib_dir)
          end
          platform_file = JavaFile.new(base, platform_lib_name)
          if ((platform_file.is_file).equal?(false))
            raise FileNotFoundException.new(platform_file.get_path)
          end
          platform_path = RJava.cast_to_string(platform_file.get_path)
        end
        if (!(config_dir).nil?)
          config_base = JavaFile.new(config_dir)
          if ((config_base.is_directory).equal?(false))
            raise IOException.new("configDir must be a directory: " + config_dir)
          end
          secmod_file = JavaFile.new(config_base, "secmod.db")
          if ((secmod_file.is_file).equal?(false))
            raise FileNotFoundException.new(secmod_file.get_path)
          end
        end
        if (DEBUG)
          System.out.println("lib: " + platform_path)
        end
        @nss_handle = nss_load_library(platform_path)
        if (DEBUG)
          System.out.println("handle: " + RJava.cast_to_string(@nss_handle))
        end
        fetch_versions
        if ((@supported).equal?(false))
          raise IOException.new("The specified version of NSS is incompatible, " + "3.7 or later required")
        end
        if (DEBUG)
          System.out.println("dir: " + config_dir)
        end
        initok = nss_init(db_mode.attr_function_name, @nss_handle, config_dir)
        if (DEBUG)
          System.out.println("init: " + RJava.cast_to_string(initok))
        end
        if ((initok).equal?(false))
          raise IOException.new("NSS initialization failed")
        end
        @config_dir = config_dir
        @nss_lib_dir = nss_lib_dir
      end
    end
    
    typesig { [] }
    # Return an immutable list of all available modules.
    # 
    # @throws IllegalStateException if this Secmod is misconfigured
    # or not initialized
    def get_modules
      synchronized(self) do
        begin
          if ((is_initialized).equal?(false))
            raise IllegalStateException.new("NSS not initialized")
          end
        rescue IOException => e
          # IOException if misconfigured
          raise IllegalStateException.new(e)
        end
        if ((@modules).nil?)
          modules = nss_get_module_list(@nss_handle)
          @modules = Collections.unmodifiable_list(modules)
        end
        return @modules
      end
    end
    
    class_module.module_eval {
      typesig { [X509Certificate, String] }
      def get_digest(cert, algorithm)
        begin
          md = MessageDigest.get_instance(algorithm)
          return md.digest(cert.get_encoded)
        rescue GeneralSecurityException => e
          raise ProviderException.new(e)
        end
      end
    }
    
    typesig { [X509Certificate, TrustType] }
    def is_trusted(cert, trust_type)
      bytes = Bytes.new(get_digest(cert, "SHA-1"))
      attr = get_module_trust(ModuleType::KEYSTORE, bytes)
      if ((attr).nil?)
        attr = get_module_trust(ModuleType::FIPS, bytes)
        if ((attr).nil?)
          attr = get_module_trust(ModuleType::TRUSTANCHOR, bytes)
        end
      end
      return ((attr).nil?) ? false : attr.is_trusted(trust_type)
    end
    
    typesig { [ModuleType, Bytes] }
    def get_module_trust(type, bytes)
      module_ = get_module(type)
      t = ((module_).nil?) ? nil : module_.get_trust(bytes)
      return t
    end
    
    class_module.module_eval {
      const_set_lazy(:CRYPTO) { ModuleType::CRYPTO }
      const_attr_reader  :CRYPTO
      
      const_set_lazy(:KEYSTORE) { ModuleType::KEYSTORE }
      const_attr_reader  :KEYSTORE
      
      const_set_lazy(:FIPS) { ModuleType::FIPS }
      const_attr_reader  :FIPS
      
      const_set_lazy(:TRUSTANCHOR) { ModuleType::TRUSTANCHOR }
      const_attr_reader  :TRUSTANCHOR
      
      const_set_lazy(:EXTERNAL) { ModuleType::EXTERNAL }
      const_attr_reader  :EXTERNAL
      
      # Constants describing the different types of NSS modules.
      # For this API, NSS modules are classified as either one
      # of the internal modules delivered as part of NSS or
      # as an external module provided by a 3rd party.
      class ModuleType 
        include_class_members Secmod
        
        class_module.module_eval {
          # The NSS Softtoken crypto module. This is the first
          # slot of the softtoken object.
          # This module provides
          # implementations for cryptographic algorithms but no KeyStore.
          const_set_lazy(:CRYPTO) { ModuleType.new.set_value_name("CRYPTO") }
          const_attr_reader  :CRYPTO
          
          # The NSS Softtoken KeyStore module. This is the second
          # slot of the softtoken object.
          # This module provides
          # implementations for cryptographic algorithms (after login)
          # and the KeyStore.
          const_set_lazy(:KEYSTORE) { ModuleType.new.set_value_name("KEYSTORE") }
          const_attr_reader  :KEYSTORE
          
          # The NSS Softtoken module in FIPS mode. Note that in FIPS mode the
          # softtoken presents only one slot, not separate CRYPTO and KEYSTORE
          # slots as in non-FIPS mode.
          const_set_lazy(:FIPS) { ModuleType.new.set_value_name("FIPS") }
          const_attr_reader  :FIPS
          
          # The NSS builtin trust anchor module. This is the
          # NSSCKBI object. It provides no crypto functions.
          const_set_lazy(:TRUSTANCHOR) { ModuleType.new.set_value_name("TRUSTANCHOR") }
          const_attr_reader  :TRUSTANCHOR
          
          # An external module.
          const_set_lazy(:EXTERNAL) { ModuleType.new.set_value_name("EXTERNAL") }
          const_attr_reader  :EXTERNAL
        }
        
        typesig { [String] }
        def set_value_name(name)
          @value_name = name
          self
        end
        
        typesig { [] }
        def to_s
          @value_name
        end
        
        class_module.module_eval {
          typesig { [] }
          def values
            [CRYPTO, KEYSTORE, FIPS, TRUSTANCHOR, EXTERNAL]
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__module_type, :initialize
      end
    }
    
    typesig { [ModuleType] }
    # Returns the first module of the specified type. If no such
    # module exists, this method returns null.
    # 
    # @throws IllegalStateException if this Secmod is misconfigured
    # or not initialized
    def get_module(type)
      get_modules.each do |module|
        if ((module_.get_type).equal?(type))
          return module_
        end
      end
      return nil
    end
    
    class_module.module_eval {
      const_set_lazy(:TEMPLATE_EXTERNAL) { "library = %s\n" + "name = \"%s\"\n" + "slotListIndex = %d\n" }
      const_attr_reader  :TEMPLATE_EXTERNAL
      
      const_set_lazy(:TEMPLATE_TRUSTANCHOR) { "library = %s\n" + "name = \"NSS Trust Anchors\"\n" + "slotListIndex = 0\n" + "enabledMechanisms = { KeyStore }\n" + "nssUseSecmodTrust = true\n" }
      const_attr_reader  :TEMPLATE_TRUSTANCHOR
      
      const_set_lazy(:TEMPLATE_CRYPTO) { "library = %s\n" + "name = \"NSS SoftToken Crypto\"\n" + "slotListIndex = 0\n" + "disabledMechanisms = { KeyStore }\n" }
      const_attr_reader  :TEMPLATE_CRYPTO
      
      const_set_lazy(:TEMPLATE_KEYSTORE) { "library = %s\n" + "name = \"NSS SoftToken KeyStore\"\n" + "slotListIndex = 1\n" + "nssUseSecmodTrust = true\n" }
      const_attr_reader  :TEMPLATE_KEYSTORE
      
      const_set_lazy(:TEMPLATE_FIPS) { "library = %s\n" + "name = \"NSS FIPS SoftToken\"\n" + "slotListIndex = 0\n" + "nssUseSecmodTrust = true\n" }
      const_attr_reader  :TEMPLATE_FIPS
      
      # A representation of one PKCS#11 slot in a PKCS#11 module.
      const_set_lazy(:Module) { Class.new do
        include_class_members Secmod
        
        # name of the native library
        attr_accessor :library_name
        alias_method :attr_library_name, :library_name
        undef_method :library_name
        alias_method :attr_library_name=, :library_name=
        undef_method :library_name=
        
        # descriptive name used by NSS
        attr_accessor :common_name
        alias_method :attr_common_name, :common_name
        undef_method :common_name
        alias_method :attr_common_name=, :common_name=
        undef_method :common_name=
        
        attr_accessor :slot
        alias_method :attr_slot, :slot
        undef_method :slot
        alias_method :attr_slot=, :slot=
        undef_method :slot=
        
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        attr_accessor :config
        alias_method :attr_config, :config
        undef_method :config
        alias_method :attr_config=, :config=
        undef_method :config=
        
        attr_accessor :provider
        alias_method :attr_provider, :provider
        undef_method :provider
        alias_method :attr_provider=, :provider=
        undef_method :provider=
        
        # trust attributes. Used for the KEYSTORE and TRUSTANCHOR modules only
        attr_accessor :trust
        alias_method :attr_trust, :trust
        undef_method :trust
        alias_method :attr_trust=, :trust=
        undef_method :trust=
        
        typesig { [String, String, ::Java::Boolean, ::Java::Int] }
        def initialize(library_name, common_name, fips, slot)
          @library_name = nil
          @common_name = nil
          @slot = 0
          @type = nil
          @config = nil
          @provider = nil
          @trust = nil
          type = nil
          if (((library_name).nil?) || ((library_name.length).equal?(0)))
            # must be softtoken
            library_name = RJava.cast_to_string(System.map_library_name(SOFTTOKEN_LIB_NAME))
            if ((fips).equal?(false))
              type = ((slot).equal?(0)) ? ModuleType::CRYPTO : ModuleType::KEYSTORE
            else
              type = ModuleType::FIPS
              if (!(slot).equal?(0))
                raise self.class::RuntimeException.new("Slot index should be 0 for FIPS slot")
              end
            end
          else
            if (library_name.ends_with(System.map_library_name(TRUST_LIB_NAME)) || (common_name == "Builtin Roots Module"))
              type = ModuleType::TRUSTANCHOR
            else
              type = ModuleType::EXTERNAL
            end
            if (fips)
              raise self.class::RuntimeException.new("FIPS flag set for non-internal " + "module: " + library_name + ", " + common_name)
            end
          end
          @library_name = library_name
          @common_name = common_name
          @slot = slot
          @type = type
          init_configuration
        end
        
        typesig { [] }
        def init_configuration
          case (@type)
          when EXTERNAL
            @config = RJava.cast_to_string(String.format(TEMPLATE_EXTERNAL, @library_name, @common_name + " " + RJava.cast_to_string(@slot), @slot))
          when CRYPTO
            @config = RJava.cast_to_string(String.format(TEMPLATE_CRYPTO, @library_name))
          when KEYSTORE
            @config = RJava.cast_to_string(String.format(TEMPLATE_KEYSTORE, @library_name))
          when FIPS
            @config = RJava.cast_to_string(String.format(TEMPLATE_FIPS, @library_name))
          when TRUSTANCHOR
            @config = RJava.cast_to_string(String.format(TEMPLATE_TRUSTANCHOR, @library_name))
          else
            raise self.class::RuntimeException.new("Unknown module type: " + RJava.cast_to_string(@type))
          end
        end
        
        typesig { [] }
        # Get the configuration for this module. This is a string
        # in the SunPKCS11 configuration format. It can be
        # customized with additional options and then made
        # current using the setConfiguration() method.
        def get_configuration
          synchronized(self) do
            return @config
          end
        end
        
        typesig { [String] }
        # Set the configuration for this module.
        # 
        # @throws IllegalStateException if the associated provider
        # instance has already been created.
        def set_configuration(config)
          synchronized(self) do
            if (!(@provider).nil?)
              raise self.class::IllegalStateException.new("Provider instance already created")
            end
            @config = config
          end
        end
        
        typesig { [] }
        # Return the pathname of the native library that implements
        # this module. For example, /usr/lib/libpkcs11.so.
        def get_library_name
          return @library_name
        end
        
        typesig { [] }
        # Returns the type of this module.
        def get_type
          return @type
        end
        
        typesig { [] }
        # Returns the provider instance that is associated with this
        # module. The first call to this method creates the provider
        # instance.
        def get_provider
          synchronized(self) do
            if ((@provider).nil?)
              @provider = new_provider
            end
            return @provider
          end
        end
        
        typesig { [] }
        def has_initialized_provider
          synchronized(self) do
            return !(@provider).nil?
          end
        end
        
        typesig { [class_self::SunPKCS11] }
        def set_provider(p)
          if (!(@provider).nil?)
            raise self.class::ProviderException.new("Secmod provider already initialized")
          end
          @provider = p
        end
        
        typesig { [] }
        def new_provider
          begin
            in_ = self.class::ByteArrayInputStream.new(@config.get_bytes("UTF8"))
            return self.class::SunPKCS11.new(in_)
          rescue self.class::JavaException => e
            # XXX
            raise self.class::ProviderException.new(e)
          end
        end
        
        typesig { [class_self::Token, class_self::X509Certificate] }
        def set_trust(token, cert)
          synchronized(self) do
            bytes = self.class::Bytes.new(get_digest(cert, "SHA-1"))
            attr = get_trust(bytes)
            if ((attr).nil?)
              attr = self.class::TrustAttributes.new(token, cert, bytes, CKT_NETSCAPE_TRUSTED_DELEGATOR)
              @trust.put(bytes, attr)
            else
              # does it already have the correct trust settings?
              if ((attr.is_trusted(TrustType::ALL)).equal?(false))
                # XXX not yet implemented
                raise self.class::ProviderException.new("Cannot change existing trust attributes")
              end
            end
          end
        end
        
        typesig { [class_self::Bytes] }
        def get_trust(hash)
          if ((@trust).nil?)
            # If provider is not set, create a temporary provider to
            # retrieve the trust information. This can happen if we need
            # to get the trust information for the trustanchor module
            # because we need to look for user customized settings in the
            # keystore module (which may not have a provider created yet).
            # Creating a temporary provider and then dropping it on the
            # floor immediately is flawed, but it's the best we can do
            # for now.
            synchronized((self)) do
              p = @provider
              if ((p).nil?)
                p = new_provider
              end
              begin
                @trust = Secmod.get_trust(p)
              rescue self.class::PKCS11Exception => e
                raise self.class::RuntimeException.new(e)
              end
            end
          end
          return @trust.get(hash)
        end
        
        typesig { [] }
        def to_s
          return @common_name + " (" + RJava.cast_to_string(@type) + ", " + @library_name + ", slot " + RJava.cast_to_string(@slot) + ")"
        end
        
        private
        alias_method :initialize__module, :initialize
      end }
      
      const_set_lazy(:ALL) { TrustType::ALL }
      const_attr_reader  :ALL
      
      const_set_lazy(:CLIENT_AUTH) { TrustType::CLIENT_AUTH }
      const_attr_reader  :CLIENT_AUTH
      
      const_set_lazy(:SERVER_AUTH) { TrustType::SERVER_AUTH }
      const_attr_reader  :SERVER_AUTH
      
      const_set_lazy(:CODE_SIGNING) { TrustType::CODE_SIGNING }
      const_attr_reader  :CODE_SIGNING
      
      const_set_lazy(:EMAIL_PROTECTION) { TrustType::EMAIL_PROTECTION }
      const_attr_reader  :EMAIL_PROTECTION
      
      # Constants representing NSS trust categories.
      class TrustType 
        include_class_members Secmod
        
        class_module.module_eval {
          # Trusted for all purposes
          const_set_lazy(:ALL) { TrustType.new.set_value_name("ALL") }
          const_attr_reader  :ALL
          
          # Trusted for SSL client authentication
          const_set_lazy(:CLIENT_AUTH) { TrustType.new.set_value_name("CLIENT_AUTH") }
          const_attr_reader  :CLIENT_AUTH
          
          # Trusted for SSL server authentication
          const_set_lazy(:SERVER_AUTH) { TrustType.new.set_value_name("SERVER_AUTH") }
          const_attr_reader  :SERVER_AUTH
          
          # Trusted for code signing
          const_set_lazy(:CODE_SIGNING) { TrustType.new.set_value_name("CODE_SIGNING") }
          const_attr_reader  :CODE_SIGNING
          
          # Trusted for email protection
          const_set_lazy(:EMAIL_PROTECTION) { TrustType.new.set_value_name("EMAIL_PROTECTION") }
          const_attr_reader  :EMAIL_PROTECTION
        }
        
        typesig { [String] }
        def set_value_name(name)
          @value_name = name
          self
        end
        
        typesig { [] }
        def to_s
          @value_name
        end
        
        class_module.module_eval {
          typesig { [] }
          def values
            [ALL, CLIENT_AUTH, SERVER_AUTH, CODE_SIGNING, EMAIL_PROTECTION]
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__trust_type, :initialize
      end
      
      const_set_lazy(:READ_WRITE) { DbMode::READ_WRITE }
      const_attr_reader  :READ_WRITE
      
      const_set_lazy(:READ_ONLY) { DbMode::READ_ONLY }
      const_attr_reader  :READ_ONLY
      
      const_set_lazy(:NO_DB) { DbMode::NO_DB }
      const_attr_reader  :NO_DB
      
      class DbMode 
        include_class_members Secmod
        
        class_module.module_eval {
          const_set_lazy(:READ_WRITE) { DbMode.new("NSS_InitReadWrite").set_value_name("READ_WRITE") }
          const_attr_reader  :READ_WRITE
          
          const_set_lazy(:READ_ONLY) { DbMode.new("NSS_Init").set_value_name("READ_ONLY") }
          const_attr_reader  :READ_ONLY
          
          const_set_lazy(:NO_DB) { DbMode.new("NSS_NoDB_Init").set_value_name("NO_DB") }
          const_attr_reader  :NO_DB
        }
        
        attr_accessor :function_name
        alias_method :attr_function_name, :function_name
        undef_method :function_name
        alias_method :attr_function_name=, :function_name=
        undef_method :function_name=
        
        typesig { [String] }
        def initialize(function_name)
          @function_name = nil
          @function_name = function_name
        end
        
        typesig { [String] }
        def set_value_name(name)
          @value_name = name
          self
        end
        
        typesig { [] }
        def to_s
          @value_name
        end
        
        class_module.module_eval {
          typesig { [] }
          def values
            [READ_WRITE, READ_ONLY, NO_DB]
          end
        }
        
        private
        alias_method :initialize__db_mode, :initialize
      end
      
      # A LoadStoreParameter for use with the NSS Softtoken or
      # NSS TrustAnchor KeyStores.
      # <p>
      # It allows the set of trusted certificates that are returned by
      # the KeyStore to be specified.
      const_set_lazy(:KeyStoreLoadParameter) { Class.new do
        include_class_members Secmod
        include LoadStoreParameter
        
        attr_accessor :trust_type
        alias_method :attr_trust_type, :trust_type
        undef_method :trust_type
        alias_method :attr_trust_type=, :trust_type=
        undef_method :trust_type=
        
        attr_accessor :protection
        alias_method :attr_protection, :protection
        undef_method :protection
        alias_method :attr_protection=, :protection=
        undef_method :protection=
        
        typesig { [class_self::TrustType, Array.typed(::Java::Char)] }
        def initialize(trust_type, password)
          initialize__key_store_load_parameter(trust_type, self.class::PasswordProtection.new(password))
        end
        
        typesig { [class_self::TrustType, class_self::ProtectionParameter] }
        def initialize(trust_type, prot)
          @trust_type = nil
          @protection = nil
          if ((trust_type).nil?)
            raise self.class::NullPointerException.new("trustType must not be null")
          end
          @trust_type = trust_type
          @protection = prot
        end
        
        typesig { [] }
        def get_protection_parameter
          return @protection
        end
        
        typesig { [] }
        def get_trust_type
          return @trust_type
        end
        
        private
        alias_method :initialize__key_store_load_parameter, :initialize
      end }
      
      const_set_lazy(:TrustAttributes) { Class.new do
        include_class_members Secmod
        
        attr_accessor :handle
        alias_method :attr_handle, :handle
        undef_method :handle
        alias_method :attr_handle=, :handle=
        undef_method :handle=
        
        attr_accessor :client_auth
        alias_method :attr_client_auth, :client_auth
        undef_method :client_auth
        alias_method :attr_client_auth=, :client_auth=
        undef_method :client_auth=
        
        attr_accessor :server_auth
        alias_method :attr_server_auth, :server_auth
        undef_method :server_auth
        alias_method :attr_server_auth=, :server_auth=
        undef_method :server_auth=
        
        attr_accessor :code_signing
        alias_method :attr_code_signing, :code_signing
        undef_method :code_signing
        alias_method :attr_code_signing=, :code_signing=
        undef_method :code_signing=
        
        attr_accessor :email_protection
        alias_method :attr_email_protection, :email_protection
        undef_method :email_protection
        alias_method :attr_email_protection=, :email_protection=
        undef_method :email_protection=
        
        attr_accessor :sha_hash
        alias_method :attr_sha_hash, :sha_hash
        undef_method :sha_hash
        alias_method :attr_sha_hash=, :sha_hash=
        undef_method :sha_hash=
        
        typesig { [class_self::Token, class_self::X509Certificate, class_self::Bytes, ::Java::Long] }
        def initialize(token, cert, bytes, trust_value)
          @handle = 0
          @client_auth = 0
          @server_auth = 0
          @code_signing = 0
          @email_protection = 0
          @sha_hash = nil
          session = nil
          begin
            session = token.get_op_session
            # XXX use KeyStore TrustType settings to determine which
            # attributes to set
            # XXX per PKCS#11 spec, the serial number should be in ASN.1
            attrs = Array.typed(self.class::CK_ATTRIBUTE).new([self.class::CK_ATTRIBUTE.new(CKA_TOKEN, true), self.class::CK_ATTRIBUTE.new(CKA_CLASS, CKO_NETSCAPE_TRUST), self.class::CK_ATTRIBUTE.new(CKA_NETSCAPE_TRUST_SERVER_AUTH, trust_value), self.class::CK_ATTRIBUTE.new(CKA_NETSCAPE_TRUST_CODE_SIGNING, trust_value), self.class::CK_ATTRIBUTE.new(CKA_NETSCAPE_TRUST_EMAIL_PROTECTION, trust_value), self.class::CK_ATTRIBUTE.new(CKA_NETSCAPE_TRUST_CLIENT_AUTH, trust_value), self.class::CK_ATTRIBUTE.new(CKA_NETSCAPE_CERT_SHA1_HASH, bytes.attr_b), self.class::CK_ATTRIBUTE.new(CKA_NETSCAPE_CERT_MD5_HASH, get_digest(cert, "MD5")), self.class::CK_ATTRIBUTE.new(CKA_ISSUER, cert.get_issuer_x500principal.get_encoded), self.class::CK_ATTRIBUTE.new(CKA_SERIAL_NUMBER, cert.get_serial_number.to_byte_array), ])
            @handle = token.attr_p11._c_create_object(session.id, attrs)
            @sha_hash = bytes.attr_b
            @client_auth = trust_value
            @server_auth = trust_value
            @code_signing = trust_value
            @email_protection = trust_value
          rescue self.class::PKCS11Exception => e
            raise self.class::ProviderException.new("Could not create trust object", e)
          ensure
            token.release_session(session)
          end
        end
        
        typesig { [class_self::Token, class_self::Session, ::Java::Long] }
        def initialize(token, session, handle)
          @handle = 0
          @client_auth = 0
          @server_auth = 0
          @code_signing = 0
          @email_protection = 0
          @sha_hash = nil
          @handle = handle
          attrs = Array.typed(self.class::CK_ATTRIBUTE).new([self.class::CK_ATTRIBUTE.new(CKA_NETSCAPE_TRUST_SERVER_AUTH), self.class::CK_ATTRIBUTE.new(CKA_NETSCAPE_TRUST_CODE_SIGNING), self.class::CK_ATTRIBUTE.new(CKA_NETSCAPE_TRUST_EMAIL_PROTECTION), self.class::CK_ATTRIBUTE.new(CKA_NETSCAPE_CERT_SHA1_HASH), ])
          token.attr_p11._c_get_attribute_value(session.id, handle, attrs)
          @server_auth = attrs[0].get_long
          @code_signing = attrs[1].get_long
          @email_protection = attrs[2].get_long
          @sha_hash = attrs[3].get_byte_array
          attrs = Array.typed(self.class::CK_ATTRIBUTE).new([self.class::CK_ATTRIBUTE.new(CKA_NETSCAPE_TRUST_CLIENT_AUTH), ])
          c = 0
          begin
            token.attr_p11._c_get_attribute_value(session.id, handle, attrs)
            c = attrs[0].get_long
          rescue self.class::PKCS11Exception => e
            # trust anchor module does not support this attribute
            c = @server_auth
          end
          @client_auth = c
        end
        
        typesig { [] }
        def get_hash
          return self.class::Bytes.new(@sha_hash)
        end
        
        typesig { [class_self::TrustType] }
        def is_trusted(type)
          case (type)
          when CLIENT_AUTH
            return is_trusted(@client_auth)
          when SERVER_AUTH
            return is_trusted(@server_auth)
          when CODE_SIGNING
            return is_trusted(@code_signing)
          when EMAIL_PROTECTION
            return is_trusted(@email_protection)
          when ALL
            return is_trusted(TrustType::CLIENT_AUTH) && is_trusted(TrustType::SERVER_AUTH) && is_trusted(TrustType::CODE_SIGNING) && is_trusted(TrustType::EMAIL_PROTECTION)
          else
            return false
          end
        end
        
        typesig { [::Java::Long] }
        def is_trusted(l)
          # XXX CKT_TRUSTED?
          return ((l).equal?(CKT_NETSCAPE_TRUSTED_DELEGATOR))
        end
        
        private
        alias_method :initialize__trust_attributes, :initialize
      end }
      
      const_set_lazy(:Bytes) { Class.new do
        include_class_members Secmod
        
        attr_accessor :b
        alias_method :attr_b, :b
        undef_method :b
        alias_method :attr_b=, :b=
        undef_method :b=
        
        typesig { [Array.typed(::Java::Byte)] }
        def initialize(b)
          @b = nil
          @b = b
        end
        
        typesig { [] }
        def hash_code
          return Arrays.hash_code(@b)
        end
        
        typesig { [Object] }
        def ==(o)
          if ((self).equal?(o))
            return true
          end
          if ((o.is_a?(self.class::Bytes)).equal?(false))
            return false
          end
          other = o
          return (Arrays == @b)
        end
        
        private
        alias_method :initialize__bytes, :initialize
      end }
      
      typesig { [SunPKCS11] }
      def get_trust(provider)
        trust_map = HashMap.new
        token = provider.get_token
        session = nil
        begin
          session = token.get_op_session
          max_num = 8192
          attrs = Array.typed(CK_ATTRIBUTE).new([CK_ATTRIBUTE.new(CKA_CLASS, CKO_NETSCAPE_TRUST), ])
          token.attr_p11._c_find_objects_init(session.id, attrs)
          handles = token.attr_p11._c_find_objects(session.id, max_num)
          token.attr_p11._c_find_objects_final(session.id)
          if (DEBUG)
            System.out.println("handles: " + RJava.cast_to_string(handles.attr_length))
          end
          handles.each do |handle|
            trust = TrustAttributes.new(token, session, handle)
            trust_map.put(trust.get_hash, trust)
          end
        ensure
          token.release_session(session)
        end
        return trust_map
      end
      
      JNI.load_native_method :Java_sun_security_pkcs11_Secmod_nssGetLibraryHandle, [:pointer, :long, :long], :int64
      typesig { [String] }
      def nss_get_library_handle(library_name)
        JNI.call_native_method(:Java_sun_security_pkcs11_Secmod_nssGetLibraryHandle, JNI.env, self.jni_id, library_name.jni_id)
      end
      
      JNI.load_native_method :Java_sun_security_pkcs11_Secmod_nssLoadLibrary, [:pointer, :long, :long], :int64
      typesig { [String] }
      def nss_load_library(name)
        JNI.call_native_method(:Java_sun_security_pkcs11_Secmod_nssLoadLibrary, JNI.env, self.jni_id, name.jni_id)
      end
      
      JNI.load_native_method :Java_sun_security_pkcs11_Secmod_nssVersionCheck, [:pointer, :long, :int64, :long], :int8
      typesig { [::Java::Long, String] }
      def nss_version_check(handle, min_version)
        JNI.call_native_method(:Java_sun_security_pkcs11_Secmod_nssVersionCheck, JNI.env, self.jni_id, handle.to_int, min_version.jni_id) != 0
      end
      
      JNI.load_native_method :Java_sun_security_pkcs11_Secmod_nssInit, [:pointer, :long, :long, :int64, :long], :int8
      typesig { [String, ::Java::Long, String] }
      def nss_init(function_name, handle, config_dir)
        JNI.call_native_method(:Java_sun_security_pkcs11_Secmod_nssInit, JNI.env, self.jni_id, function_name.jni_id, handle.to_int, config_dir.jni_id) != 0
      end
      
      JNI.load_native_method :Java_sun_security_pkcs11_Secmod_nssGetModuleList, [:pointer, :long, :int64], :long
      typesig { [::Java::Long] }
      def nss_get_module_list(handle)
        JNI.call_native_method(:Java_sun_security_pkcs11_Secmod_nssGetModuleList, JNI.env, self.jni_id, handle.to_int)
      end
    }
    
    private
    alias_method :initialize__secmod, :initialize
  end
  
end
