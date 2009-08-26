require "rjava"

# Copyright 2003-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SunPKCS11Imports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Io
      include ::Java::Util
      include ::Java::Security
      include ::Java::Security::Interfaces
      include ::Javax::Crypto::Interfaces
      include_const ::Javax::Security::Auth, :Subject
      include_const ::Javax::Security::Auth::Login, :LoginException
      include_const ::Javax::Security::Auth::Login, :FailedLoginException
      include_const ::Javax::Security::Auth::Callback, :Callback
      include_const ::Javax::Security::Auth::Callback, :CallbackHandler
      include_const ::Javax::Security::Auth::Callback, :ConfirmationCallback
      include_const ::Javax::Security::Auth::Callback, :PasswordCallback
      include_const ::Javax::Security::Auth::Callback, :TextOutputCallback
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::Util, :ResourcesMgr
      include ::Sun::Security::Pkcs11::Secmod
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # PKCS#11 provider main class.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class SunPKCS11 < SunPKCS11Imports.const_get :AuthProvider
    include_class_members SunPKCS11Imports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -1354835039035306505 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:Debug) { Debug.get_instance("sunpkcs11") }
      const_attr_reader  :Debug
      
      
      def dummy_config_id
        defined?(@@dummy_config_id) ? @@dummy_config_id : @@dummy_config_id= 0
      end
      alias_method :attr_dummy_config_id, :dummy_config_id
      
      def dummy_config_id=(value)
        @@dummy_config_id = value
      end
      alias_method :attr_dummy_config_id=, :dummy_config_id=
    }
    
    # the PKCS11 object through which we make the native calls
    attr_accessor :p11
    alias_method :attr_p11, :p11
    undef_method :p11
    alias_method :attr_p11=, :p11=
    undef_method :p11=
    
    # name of the configuration file
    attr_accessor :config_name
    alias_method :attr_config_name, :config_name
    undef_method :config_name
    alias_method :attr_config_name=, :config_name=
    undef_method :config_name=
    
    # configuration information
    attr_accessor :config
    alias_method :attr_config, :config
    undef_method :config
    alias_method :attr_config=, :config=
    undef_method :config=
    
    # id of the PKCS#11 slot we are using
    attr_accessor :slot_id
    alias_method :attr_slot_id, :slot_id
    undef_method :slot_id
    alias_method :attr_slot_id=, :slot_id=
    undef_method :slot_id=
    
    attr_accessor :p_handler
    alias_method :attr_p_handler, :p_handler
    undef_method :p_handler
    alias_method :attr_p_handler=, :p_handler=
    undef_method :p_handler=
    
    attr_accessor :lock_handler
    alias_method :attr_lock_handler, :lock_handler
    undef_method :lock_handler
    alias_method :attr_lock_handler=, :lock_handler=
    undef_method :lock_handler=
    
    attr_accessor :removable
    alias_method :attr_removable, :removable
    undef_method :removable
    alias_method :attr_removable=, :removable=
    undef_method :removable=
    
    attr_accessor :nss_module
    alias_method :attr_nss_module, :nss_module
    undef_method :nss_module
    alias_method :attr_nss_module=, :nss_module=
    undef_method :nss_module=
    
    attr_accessor :nss_use_secmod_trust
    alias_method :attr_nss_use_secmod_trust, :nss_use_secmod_trust
    undef_method :nss_use_secmod_trust
    alias_method :attr_nss_use_secmod_trust=, :nss_use_secmod_trust=
    undef_method :nss_use_secmod_trust=
    
    attr_accessor :token
    alias_method :attr_token, :token
    undef_method :token
    alias_method :attr_token=, :token=
    undef_method :token=
    
    attr_accessor :poller
    alias_method :attr_poller, :poller
    undef_method :poller
    alias_method :attr_poller=, :poller=
    undef_method :poller=
    
    typesig { [] }
    def get_token
      return @token
    end
    
    typesig { [] }
    def initialize
      @p11 = nil
      @config_name = nil
      @config = nil
      @slot_id = 0
      @p_handler = nil
      @lock_handler = nil
      @removable = false
      @nss_module = nil
      @nss_use_secmod_trust = false
      @token = nil
      @poller = nil
      super("SunPKCS11-Dummy", 1.7, "SunPKCS11-Dummy")
      @lock_handler = Object.new
      raise ProviderException.new("SunPKCS11 requires configuration file argument")
    end
    
    typesig { [String] }
    def initialize(config_name)
      initialize__sun_pkcs11(check_null(config_name), nil)
    end
    
    typesig { [InputStream] }
    def initialize(config_stream)
      initialize__sun_pkcs11(get_dummy_config_name, check_null(config_stream))
    end
    
    class_module.module_eval {
      typesig { [T] }
      def check_null(obj)
        if ((obj).nil?)
          raise NullPointerException.new
        end
        return obj
      end
      
      typesig { [] }
      def get_dummy_config_name
        synchronized(self) do
          id = (self.attr_dummy_config_id += 1)
          return "---DummyConfig-" + RJava.cast_to_string(id) + "---"
        end
      end
    }
    
    typesig { [String, InputStream] }
    # @deprecated use new SunPKCS11(String) or new SunPKCS11(InputStream) instead
    def initialize(config_name, config_stream)
      @p11 = nil
      @config_name = nil
      @config = nil
      @slot_id = 0
      @p_handler = nil
      @lock_handler = nil
      @removable = false
      @nss_module = nil
      @nss_use_secmod_trust = false
      @token = nil
      @poller = nil
      super("SunPKCS11-" + RJava.cast_to_string(Config.get_config(config_name, config_stream).get_name), 1.7, Config.get_config(config_name, config_stream).get_description)
      @lock_handler = Object.new
      @config_name = config_name
      @config = Config.remove_config(config_name)
      if (!(Debug).nil?)
        System.out.println("SunPKCS11 loading " + config_name)
      end
      library = @config.get_library
      function_list = @config.get_function_list
      slot_id = @config.get_slot_id
      slot_list_index = @config.get_slot_list_index
      use_secmod = @config.get_nss_use_secmod
      nss_use_secmod_trust = @config.get_nss_use_secmod_trust
      nss_module = nil
      # Initialization via Secmod. The way this works is as follows:
      # SunPKCS11 is either in normal mode or in NSS Secmod mode.
      # Secmod is activated by specifying one or more of the following
      # options in the config file:
      # nssUseSecmod, nssSecmodDirectory, nssLibrary, nssModule
      # 
      # XXX add more explanation here
      # 
      # If we are in Secmod mode and configured to use either the
      # nssKeyStore or the nssTrustAnchors module, we automatically
      # switch to using the NSS trust attributes for trusted certs (KeyStore).
      if (use_secmod)
        # note: Config ensures library/slot/slotListIndex not specified
        # in secmod mode.
        secmod = Secmod.get_instance
        nss_db_mode = @config.get_nss_db_mode
        begin
          nss_library_directory = @config.get_nss_library_directory
          nss_secmod_directory = @config.get_nss_secmod_directory
          if (secmod.is_initialized)
            if (!(nss_secmod_directory).nil?)
              s = secmod.get_config_dir
              if ((!(s).nil?) && (((s == nss_secmod_directory)).equal?(false)))
                raise ProviderException.new("Secmod directory " + nss_secmod_directory + " invalid, NSS already initialized with " + s)
              end
            end
            if (!(nss_library_directory).nil?)
              s = secmod.get_lib_dir
              if ((!(s).nil?) && (((s == nss_library_directory)).equal?(false)))
                raise ProviderException.new("NSS library directory " + nss_library_directory + " invalid, NSS already initialized with " + s)
              end
            end
          else
            if (!(nss_db_mode).equal?(DbMode::NO_DB))
              if ((nss_secmod_directory).nil?)
                raise ProviderException.new("Secmod not initialized and " + "nssSecmodDirectory not specified")
              end
            else
              if (!(nss_secmod_directory).nil?)
                raise ProviderException.new("nssSecmodDirectory must not be specified in noDb mode")
              end
            end
            secmod.initialize_(nss_db_mode, nss_secmod_directory, nss_library_directory)
          end
        rescue IOException => e
          # XXX which exception to throw
          raise ProviderException.new("Could not initialize NSS", e)
        end
        modules = secmod.get_modules
        if (@config.get_show_info)
          System.out.println("NSS modules: " + RJava.cast_to_string(modules))
        end
        module_name = @config.get_nss_module
        if ((module_name).nil?)
          nss_module = secmod.get_module(ModuleType::FIPS)
          if (!(nss_module).nil?)
            module_name = "fips"
          else
            module_name = RJava.cast_to_string(((nss_db_mode).equal?(DbMode::NO_DB)) ? "crypto" : "keystore")
          end
        end
        if ((module_name == "fips"))
          nss_module = secmod.get_module(ModuleType::FIPS)
          nss_use_secmod_trust = true
          function_list = "FC_GetFunctionList"
        else
          if ((module_name == "keystore"))
            nss_module = secmod.get_module(ModuleType::KEYSTORE)
            nss_use_secmod_trust = true
          else
            if ((module_name == "crypto"))
              nss_module = secmod.get_module(ModuleType::CRYPTO)
            else
              if ((module_name == "trustanchors"))
                # XXX should the option be called trustanchor or trustanchors??
                nss_module = secmod.get_module(ModuleType::TRUSTANCHOR)
                nss_use_secmod_trust = true
              else
                if (module_name.starts_with("external-"))
                  module_index = 0
                  begin
                    module_index = JavaInteger.parse_int(module_name.substring("external-".length))
                  rescue NumberFormatException => e
                    module_index = -1
                  end
                  if (module_index < 1)
                    raise ProviderException.new("Invalid external module: " + module_name)
                  end
                  k = 0
                  modules.each do |module|
                    if ((module_.get_type).equal?(ModuleType::EXTERNAL))
                      if (((k += 1)).equal?(module_index))
                        nss_module = module_
                        break
                      end
                    end
                  end
                  if ((nss_module).nil?)
                    raise ProviderException.new("Invalid module " + module_name + ": only " + RJava.cast_to_string(k) + " external NSS modules available")
                  end
                else
                  raise ProviderException.new("Unknown NSS module: " + module_name)
                end
              end
            end
          end
        end
        if ((nss_module).nil?)
          raise ProviderException.new("NSS module not available: " + module_name)
        end
        if (nss_module.has_initialized_provider)
          raise ProviderException.new("Secmod module already configured")
        end
        library = RJava.cast_to_string(nss_module.attr_library_name)
        slot_list_index = nss_module.attr_slot
      end
      @nss_use_secmod_trust = nss_use_secmod_trust
      @nss_module = nss_module
      library_file = JavaFile.new(library)
      # if the filename is a simple filename without path
      # (e.g. "libpkcs11.so"), it may refer to a library somewhere on the
      # OS library search path. Omit the test for file existance as that
      # only looks in the current directory.
      if (((library_file.get_name == library)).equal?(false))
        if ((JavaFile.new(library).is_file).equal?(false))
          msg = "Library " + library + " does not exist"
          if ((@config.get_handle_startup_errors).equal?(Config::ERR_HALT))
            raise ProviderException.new(msg)
          else
            raise UnsupportedOperationException.new(msg)
          end
        end
      end
      begin
        if (!(Debug).nil?)
          Debug.println("Initializing PKCS#11 library " + library)
        end
        init_args = CK_C_INITIALIZE_ARGS.new
        nss_args = @config.get_nss_args
        if (!(nss_args).nil?)
          init_args.attr_p_reserved = nss_args
        end
        # request multithreaded access first
        init_args.attr_flags = CKF_OS_LOCKING_OK
        tmp_pkcs11 = nil
        begin
          tmp_pkcs11 = PKCS11.get_instance(library, function_list, init_args, @config.get_omit_initialize)
        rescue PKCS11Exception => e
          if (!(Debug).nil?)
            Debug.println("Multi-threaded initialization failed: " + RJava.cast_to_string(e))
          end
          if ((@config.get_allow_single_threaded_modules).equal?(false))
            raise e
          end
          # fall back to single threaded access
          if ((nss_args).nil?)
            # if possible, use null initArgs for better compatibility
            init_args = nil
          else
            init_args.attr_flags = 0
          end
          tmp_pkcs11 = PKCS11.get_instance(library, function_list, init_args, @config.get_omit_initialize)
        end
        @p11 = tmp_pkcs11
        p11info = @p11._c_get_info
        if (p11info.attr_cryptoki_version.attr_major < 2)
          raise ProviderException.new("Only PKCS#11 v2.0 and later " + "supported, library version is v" + RJava.cast_to_string(p11info.attr_cryptoki_version))
        end
        show_info = @config.get_show_info
        if (show_info)
          System.out.println("Information for provider " + RJava.cast_to_string(get_name))
          System.out.println("Library info:")
          System.out.println(p11info)
        end
        if ((slot_id < 0) || show_info)
          slots = @p11._c_get_slot_list(false)
          if (show_info)
            System.out.println("All slots: " + RJava.cast_to_string(to_s(slots)))
            slots = @p11._c_get_slot_list(true)
            System.out.println("Slots with tokens: " + RJava.cast_to_string(to_s(slots)))
          end
          if (slot_id < 0)
            if ((slot_list_index < 0) || (slot_list_index >= slots.attr_length))
              raise ProviderException.new("slotListIndex is " + RJava.cast_to_string(slot_list_index) + " but token only has " + RJava.cast_to_string(slots.attr_length) + " slots")
            end
            slot_id = slots[slot_list_index]
          end
        end
        @slot_id = slot_id
        slot_info = @p11._c_get_slot_info(slot_id)
        @removable = !((slot_info.attr_flags & CKF_REMOVABLE_DEVICE)).equal?(0)
        init_token(slot_info)
        if (!(nss_module).nil?)
          nss_module.set_provider(self)
        end
      rescue JavaException => e
        if ((@config.get_handle_startup_errors).equal?(Config::ERR_IGNORE_ALL))
          raise UnsupportedOperationException.new("Initialization failed", e)
        else
          raise ProviderException.new("Initialization failed", e)
        end
      end
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Long)] }
      def to_s(longs)
        if ((longs.attr_length).equal?(0))
          return "(none)"
        end
        sb = StringBuilder.new
        sb.append(longs[0])
        i = 1
        while i < longs.attr_length
          sb.append(", ")
          sb.append(longs[i])
          i += 1
        end
        return sb.to_s
      end
      
      # set to true once self verification is complete
      
      def integrity_verified
        defined?(@@integrity_verified) ? @@integrity_verified : @@integrity_verified= false
      end
      alias_method :attr_integrity_verified, :integrity_verified
      
      def integrity_verified=(value)
        @@integrity_verified = value
      end
      alias_method :attr_integrity_verified=, :integrity_verified=
      
      typesig { [Class] }
      def verify_self_integrity(c)
        if (self.attr_integrity_verified)
          return
        end
        do_verify_self_integrity(c)
      end
      
      typesig { [Class] }
      def do_verify_self_integrity(c)
        synchronized(self) do
          self.attr_integrity_verified = JarVerifier.verify(c)
          if ((self.attr_integrity_verified).equal?(false))
            raise ProviderException.new("The SunPKCS11 provider may have been tampered with.")
          end
        end
      end
    }
    
    typesig { [Object] }
    def ==(obj)
      return (self).equal?(obj)
    end
    
    typesig { [] }
    def hash_code
      return System.identity_hash_code(self)
    end
    
    class_module.module_eval {
      typesig { [String] }
      def s(s1)
        return Array.typed(String).new([s1])
      end
      
      typesig { [String, String] }
      def s(s1, s2)
        return Array.typed(String).new([s1, s2])
      end
      
      const_set_lazy(:Descriptor) { Class.new do
        include_class_members SunPKCS11
        
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        attr_accessor :algorithm
        alias_method :attr_algorithm, :algorithm
        undef_method :algorithm
        alias_method :attr_algorithm=, :algorithm=
        undef_method :algorithm=
        
        attr_accessor :class_name
        alias_method :attr_class_name, :class_name
        undef_method :class_name
        alias_method :attr_class_name=, :class_name=
        undef_method :class_name=
        
        attr_accessor :aliases
        alias_method :attr_aliases, :aliases
        undef_method :aliases
        alias_method :attr_aliases=, :aliases=
        undef_method :aliases=
        
        attr_accessor :mechanisms
        alias_method :attr_mechanisms, :mechanisms
        undef_method :mechanisms
        alias_method :attr_mechanisms=, :mechanisms=
        undef_method :mechanisms=
        
        typesig { [self::String, self::String, self::String, Array.typed(self::String), Array.typed(::Java::Int)] }
        def initialize(type, algorithm, class_name, aliases, mechanisms)
          @type = nil
          @algorithm = nil
          @class_name = nil
          @aliases = nil
          @mechanisms = nil
          @type = type
          @algorithm = algorithm
          @class_name = class_name
          @aliases = aliases
          @mechanisms = mechanisms
        end
        
        typesig { [self::Token, ::Java::Int] }
        def service(token, mechanism)
          return self.class::P11Service.new(token, @type, @algorithm, @class_name, @aliases, mechanism)
        end
        
        typesig { [] }
        def to_s
          return @type + "." + @algorithm
        end
        
        private
        alias_method :initialize__descriptor, :initialize
      end }
      
      # Map from mechanism to List of Descriptors that should be
      # registered if the mechanism is supported
      const_set_lazy(:Descriptors) { HashMap.new }
      const_attr_reader  :Descriptors
      
      typesig { [::Java::Long] }
      def m(m1)
        return Array.typed(::Java::Int).new([RJava.cast_to_int(m1)])
      end
      
      typesig { [::Java::Long, ::Java::Long] }
      def m(m1, m2)
        return Array.typed(::Java::Int).new([RJava.cast_to_int(m1), RJava.cast_to_int(m2)])
      end
      
      typesig { [::Java::Long, ::Java::Long, ::Java::Long] }
      def m(m1, m2, m3)
        return Array.typed(::Java::Int).new([RJava.cast_to_int(m1), RJava.cast_to_int(m2), RJava.cast_to_int(m3)])
      end
      
      typesig { [::Java::Long, ::Java::Long, ::Java::Long, ::Java::Long] }
      def m(m1, m2, m3, m4)
        return Array.typed(::Java::Int).new([RJava.cast_to_int(m1), RJava.cast_to_int(m2), RJava.cast_to_int(m3), RJava.cast_to_int(m4)])
      end
      
      typesig { [String, String, String, Array.typed(::Java::Int)] }
      def d(type, algorithm, class_name, m)
        register(Descriptor.new(type, algorithm, class_name, nil, m))
      end
      
      typesig { [String, String, String, Array.typed(String), Array.typed(::Java::Int)] }
      def d(type, algorithm, class_name, aliases, m)
        register(Descriptor.new(type, algorithm, class_name, aliases, m))
      end
      
      typesig { [Descriptor] }
      def register(d)
        i = 0
        while i < d.attr_mechanisms.attr_length
          m = d.attr_mechanisms[i]
          key = JavaInteger.value_of(m)
          list = Descriptors.get(key)
          if ((list).nil?)
            list = ArrayList.new
            Descriptors.put(key, list)
          end
          list.add(d)
          i += 1
        end
      end
      
      const_set_lazy(:MD) { "MessageDigest" }
      const_attr_reader  :MD
      
      const_set_lazy(:SIG) { "Signature" }
      const_attr_reader  :SIG
      
      const_set_lazy(:KPG) { "KeyPairGenerator" }
      const_attr_reader  :KPG
      
      const_set_lazy(:KG) { "KeyGenerator" }
      const_attr_reader  :KG
      
      const_set_lazy(:AGP) { "AlgorithmParameters" }
      const_attr_reader  :AGP
      
      const_set_lazy(:KF) { "KeyFactory" }
      const_attr_reader  :KF
      
      const_set_lazy(:SKF) { "SecretKeyFactory" }
      const_attr_reader  :SKF
      
      const_set_lazy(:CIP) { "Cipher" }
      const_attr_reader  :CIP
      
      const_set_lazy(:MAC) { "Mac" }
      const_attr_reader  :MAC
      
      const_set_lazy(:KA) { "KeyAgreement" }
      const_attr_reader  :KA
      
      const_set_lazy(:KS) { "KeyStore" }
      const_attr_reader  :KS
      
      const_set_lazy(:SR) { "SecureRandom" }
      const_attr_reader  :SR
      
      when_class_loaded do
        # names of all the implementation classes
        # use local variables, only used here
        p11digest = "sun.security.pkcs11.P11Digest"
        p11mac = "sun.security.pkcs11.P11MAC"
        p11key_pair_generator = "sun.security.pkcs11.P11KeyPairGenerator"
        p11key_generator = "sun.security.pkcs11.P11KeyGenerator"
        p11rsakey_factory = "sun.security.pkcs11.P11RSAKeyFactory"
        p11dsakey_factory = "sun.security.pkcs11.P11DSAKeyFactory"
        p11dhkey_factory = "sun.security.pkcs11.P11DHKeyFactory"
        p11key_agreement = "sun.security.pkcs11.P11KeyAgreement"
        p11secret_key_factory = "sun.security.pkcs11.P11SecretKeyFactory"
        p11cipher = "sun.security.pkcs11.P11Cipher"
        p11rsacipher = "sun.security.pkcs11.P11RSACipher"
        p11signature = "sun.security.pkcs11.P11Signature"
        # XXX register all aliases
        d(MD, "MD2", p11digest, m(CKM_MD2))
        d(MD, "MD5", p11digest, m(CKM_MD5))
        d(MD, "SHA1", p11digest, s("SHA", "SHA-1"), m(CKM_SHA_1))
        d(MD, "SHA-256", p11digest, m(CKM_SHA256))
        d(MD, "SHA-384", p11digest, m(CKM_SHA384))
        d(MD, "SHA-512", p11digest, m(CKM_SHA512))
        d(MAC, "HmacMD5", p11mac, m(CKM_MD5_HMAC))
        d(MAC, "HmacSHA1", p11mac, m(CKM_SHA_1_HMAC))
        d(MAC, "HmacSHA256", p11mac, m(CKM_SHA256_HMAC))
        d(MAC, "HmacSHA384", p11mac, m(CKM_SHA384_HMAC))
        d(MAC, "HmacSHA512", p11mac, m(CKM_SHA512_HMAC))
        d(MAC, "SslMacMD5", p11mac, m(CKM_SSL3_MD5_MAC))
        d(MAC, "SslMacSHA1", p11mac, m(CKM_SSL3_SHA1_MAC))
        d(KPG, "RSA", p11key_pair_generator, m(CKM_RSA_PKCS_KEY_PAIR_GEN))
        d(KPG, "DSA", p11key_pair_generator, m(CKM_DSA_KEY_PAIR_GEN))
        d(KPG, "DH", p11key_pair_generator, s("DiffieHellman"), m(CKM_DH_PKCS_KEY_PAIR_GEN))
        d(KPG, "EC", p11key_pair_generator, m(CKM_EC_KEY_PAIR_GEN))
        d(KG, "ARCFOUR", p11key_generator, s("RC4"), m(CKM_RC4_KEY_GEN))
        d(KG, "DES", p11key_generator, m(CKM_DES_KEY_GEN))
        d(KG, "DESede", p11key_generator, m(CKM_DES3_KEY_GEN, CKM_DES2_KEY_GEN))
        d(KG, "AES", p11key_generator, m(CKM_AES_KEY_GEN))
        d(KG, "Blowfish", p11key_generator, m(CKM_BLOWFISH_KEY_GEN))
        # register (Secret)KeyFactories if there are any mechanisms
        # for a particular algorithm that we support
        d(KF, "RSA", p11rsakey_factory, m(CKM_RSA_PKCS_KEY_PAIR_GEN, CKM_RSA_PKCS, CKM_RSA_X_509))
        d(KF, "DSA", p11dsakey_factory, m(CKM_DSA_KEY_PAIR_GEN, CKM_DSA, CKM_DSA_SHA1))
        d(KF, "DH", p11dhkey_factory, s("DiffieHellman"), m(CKM_DH_PKCS_KEY_PAIR_GEN, CKM_DH_PKCS_DERIVE))
        d(KF, "EC", p11dhkey_factory, m(CKM_EC_KEY_PAIR_GEN, CKM_ECDH1_DERIVE, CKM_ECDSA, CKM_ECDSA_SHA1))
        # AlgorithmParameters for EC.
        # Only needed until we have an EC implementation in the SUN provider.
        d(AGP, "EC", "sun.security.ec.ECParameters", s("1.2.840.10045.2.1"), m(CKM_EC_KEY_PAIR_GEN, CKM_ECDH1_DERIVE, CKM_ECDSA, CKM_ECDSA_SHA1))
        d(KA, "DH", p11key_agreement, s("DiffieHellman"), m(CKM_DH_PKCS_DERIVE))
        d(KA, "ECDH", "sun.security.pkcs11.P11ECDHKeyAgreement", m(CKM_ECDH1_DERIVE))
        d(SKF, "ARCFOUR", p11secret_key_factory, s("RC4"), m(CKM_RC4))
        d(SKF, "DES", p11secret_key_factory, m(CKM_DES_CBC))
        d(SKF, "DESede", p11secret_key_factory, m(CKM_DES3_CBC))
        d(SKF, "AES", p11secret_key_factory, m(CKM_AES_CBC))
        d(SKF, "Blowfish", p11secret_key_factory, m(CKM_BLOWFISH_CBC))
        # XXX attributes for Ciphers (supported modes, padding)
        d(CIP, "ARCFOUR", p11cipher, s("RC4"), m(CKM_RC4))
        # XXX only CBC/NoPadding for block ciphers
        d(CIP, "DES/CBC/NoPadding", p11cipher, m(CKM_DES_CBC))
        d(CIP, "DESede/CBC/NoPadding", p11cipher, m(CKM_DES3_CBC))
        d(CIP, "AES/CBC/NoPadding", p11cipher, m(CKM_AES_CBC))
        d(CIP, "Blowfish/CBC/NoPadding", p11cipher, m(CKM_BLOWFISH_CBC))
        # XXX RSA_X_509, RSA_OAEP not yet supported
        d(CIP, "RSA/ECB/PKCS1Padding", p11rsacipher, m(CKM_RSA_PKCS))
        d(SIG, "RawDSA", p11signature, s("NONEwithDSA"), m(CKM_DSA))
        d(SIG, "DSA", p11signature, s("SHA1withDSA"), m(CKM_DSA_SHA1, CKM_DSA))
        d(SIG, "NONEwithECDSA", p11signature, m(CKM_ECDSA))
        d(SIG, "SHA1withECDSA", p11signature, s("ECDSA"), m(CKM_ECDSA_SHA1, CKM_ECDSA))
        d(SIG, "SHA256withECDSA", p11signature, m(CKM_ECDSA))
        d(SIG, "SHA384withECDSA", p11signature, m(CKM_ECDSA))
        d(SIG, "SHA512withECDSA", p11signature, m(CKM_ECDSA))
        d(SIG, "MD2withRSA", p11signature, m(CKM_MD2_RSA_PKCS, CKM_RSA_PKCS, CKM_RSA_X_509))
        d(SIG, "MD5withRSA", p11signature, m(CKM_MD5_RSA_PKCS, CKM_RSA_PKCS, CKM_RSA_X_509))
        d(SIG, "SHA1withRSA", p11signature, m(CKM_SHA1_RSA_PKCS, CKM_RSA_PKCS, CKM_RSA_X_509))
        d(SIG, "SHA256withRSA", p11signature, m(CKM_SHA256_RSA_PKCS, CKM_RSA_PKCS, CKM_RSA_X_509))
        d(SIG, "SHA384withRSA", p11signature, m(CKM_SHA384_RSA_PKCS, CKM_RSA_PKCS, CKM_RSA_X_509))
        d(SIG, "SHA512withRSA", p11signature, m(CKM_SHA512_RSA_PKCS, CKM_RSA_PKCS, CKM_RSA_X_509))
        d(KG, "SunTlsRsaPremasterSecret", "sun.security.pkcs11.P11TlsRsaPremasterSecretGenerator", m(CKM_SSL3_PRE_MASTER_KEY_GEN, CKM_TLS_PRE_MASTER_KEY_GEN))
        d(KG, "SunTlsMasterSecret", "sun.security.pkcs11.P11TlsMasterSecretGenerator", m(CKM_SSL3_MASTER_KEY_DERIVE, CKM_TLS_MASTER_KEY_DERIVE, CKM_SSL3_MASTER_KEY_DERIVE_DH, CKM_TLS_MASTER_KEY_DERIVE_DH))
        d(KG, "SunTlsKeyMaterial", "sun.security.pkcs11.P11TlsKeyMaterialGenerator", m(CKM_SSL3_KEY_AND_MAC_DERIVE, CKM_TLS_KEY_AND_MAC_DERIVE))
        d(KG, "SunTlsPrf", "sun.security.pkcs11.P11TlsPrfGenerator", m(CKM_TLS_PRF, CKM_NSS_TLS_PRF_GENERAL))
      end
      
      # background thread that periodically checks for token insertion
      # if no token is present. We need to do that in a separate thread because
      # the insertion check may block for quite a long time on some tokens.
      const_set_lazy(:TokenPoller) { Class.new do
        include_class_members SunPKCS11
        include Runnable
        
        attr_accessor :provider
        alias_method :attr_provider, :provider
        undef_method :provider
        alias_method :attr_provider=, :provider=
        undef_method :provider=
        
        attr_accessor :enabled
        alias_method :attr_enabled, :enabled
        undef_method :enabled
        alias_method :attr_enabled=, :enabled=
        undef_method :enabled=
        
        typesig { [self::SunPKCS11] }
        def initialize(provider)
          @provider = nil
          @enabled = false
          @provider = provider
          @enabled = true
        end
        
        typesig { [] }
        def run
          interval = @provider.attr_config.get_insertion_check_interval
          while (@enabled)
            begin
              JavaThread.sleep(interval)
            rescue self.class::InterruptedException => e
              break
            end
            if ((@enabled).equal?(false))
              break
            end
            begin
              @provider.init_token(nil)
            rescue self.class::PKCS11Exception => e
              # ignore
            end
          end
        end
        
        typesig { [] }
        def disable
          @enabled = false
        end
        
        private
        alias_method :initialize__token_poller, :initialize
      end }
    }
    
    typesig { [] }
    # create the poller thread, if not already active
    def create_poller
      if (!(@poller).nil?)
        return
      end
      poller = TokenPoller.new(self)
      t = JavaThread.new(poller, "Poller " + RJava.cast_to_string(get_name))
      t.set_daemon(true)
      t.set_priority(JavaThread::MIN_PRIORITY)
      t.start
      @poller = poller
    end
    
    typesig { [] }
    # destroy the poller thread, if active
    def destroy_poller
      if (!(@poller).nil?)
        @poller.disable
        @poller = nil
      end
    end
    
    typesig { [] }
    def has_valid_token
      # Commented out to work with Solaris softtoken impl which
      # returns 0-value flags, e.g. both REMOVABLE_DEVICE and
      # TOKEN_PRESENT are false, when it can't access the token.
      # if (removable == false) {
      # return true;
      # }
      token = @token
      return (!(token).nil?) && token.is_valid
    end
    
    typesig { [Token] }
    # destroy the token. Called if we detect that it has been removed
    def uninit_token(token)
      synchronized(self) do
        if (!(@token).equal?(token))
          # mismatch, our token must already be destroyed
          return
        end
        destroy_poller
        @token = nil
        AccessController.do_privileged(# unregister all algorithms
        Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members SunPKCS11
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            clear
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        create_poller
      end
    end
    
    typesig { [CK_SLOT_INFO] }
    # test if a token is present and initialize this provider for it if so.
    # does nothing if no token is found
    # called from constructor and by poller
    def init_token(slot_info)
      if ((slot_info).nil?)
        slot_info = @p11._c_get_slot_info(@slot_id)
      end
      if (@removable && ((slot_info.attr_flags & CKF_TOKEN_PRESENT)).equal?(0))
        create_poller
        return
      end
      destroy_poller
      show_info = @config.get_show_info
      if (show_info)
        System.out.println("Slot info for slot " + RJava.cast_to_string(@slot_id) + ":")
        System.out.println(slot_info)
      end
      token = Token.new(self)
      if (show_info)
        System.out.println("Token info for token in slot " + RJava.cast_to_string(@slot_id) + ":")
        System.out.println(token.attr_token_info)
      end
      supported_mechanisms = @p11._c_get_mechanism_list(@slot_id)
      supported_algs = HashMap.new
      i = 0
      while i < supported_mechanisms.attr_length
        long_mech = supported_mechanisms[i]
        is_enabled_ = @config.is_enabled(long_mech)
        if (show_info)
          mech_info = @p11._c_get_mechanism_info(@slot_id, long_mech)
          System.out.println("Mechanism " + RJava.cast_to_string(Functions.get_mechanism_name(long_mech)) + ":")
          if ((is_enabled_).equal?(false))
            System.out.println("DISABLED in configuration")
          end
          System.out.println(mech_info)
        end
        if ((is_enabled_).equal?(false))
          i += 1
          next
        end
        # we do not know of mechs with the upper 32 bits set
        if (!(long_mech >> 32).equal?(0))
          i += 1
          next
        end
        mech = RJava.cast_to_int(long_mech)
        integer_mech = JavaInteger.value_of(mech)
        ds = Descriptors.get(integer_mech)
        if ((ds).nil?)
          i += 1
          next
        end
        ds.each do |d|
          old_mech = supported_algs.get(d_)
          if ((old_mech).nil?)
            supported_algs.put(d_, integer_mech)
            next
          end
          int_old_mech = old_mech.int_value
          j = 0
          while j < d_.attr_mechanisms.attr_length
            next_mech = d_.attr_mechanisms[j]
            if ((mech).equal?(next_mech))
              supported_algs.put(d_, integer_mech)
              break
            else
              if ((int_old_mech).equal?(next_mech))
                break
              end
            end
            j += 1
          end
        end
        i += 1
      end
      AccessController.do_privileged(# register algorithms in provider
      Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members SunPKCS11
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          supported_algs.entry_set.each do |entry|
            d_ = entry.get_key
            mechanism = entry.get_value.int_value
            s_ = d_.service(token, mechanism)
            put_service(s_)
          end
          if ((!((token.attr_token_info.attr_flags & CKF_RNG)).equal?(0)) && self.attr_config.is_enabled(PCKM_SECURERANDOM) && !token.attr_session_manager.low_max_sessions)
            # do not register SecureRandom if the token does
            # not support many sessions. if we did, we might
            # run out of sessions in the middle of a
            # nextBytes() call where we cannot fail over.
            put_service(self.class::P11Service.new(token, SR, "PKCS11", "sun.security.pkcs11.P11SecureRandom", nil, PCKM_SECURERANDOM))
          end
          if (self.attr_config.is_enabled(PCKM_KEYSTORE))
            put_service(self.class::P11Service.new(token, KS, "PKCS11", "sun.security.pkcs11.P11KeyStore", s("PKCS11-" + RJava.cast_to_string(self.attr_config.get_name)), PCKM_KEYSTORE))
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
      @token = token
    end
    
    class_module.module_eval {
      const_set_lazy(:P11Service) { Class.new(Service) do
        include_class_members SunPKCS11
        
        attr_accessor :token
        alias_method :attr_token, :token
        undef_method :token
        alias_method :attr_token=, :token=
        undef_method :token=
        
        attr_accessor :mechanism
        alias_method :attr_mechanism, :mechanism
        undef_method :mechanism
        alias_method :attr_mechanism=, :mechanism=
        undef_method :mechanism=
        
        typesig { [self::Token, self::String, self::String, self::String, Array.typed(self::String), ::Java::Long] }
        def initialize(token, type, algorithm, class_name, al, mechanism)
          @token = nil
          @mechanism = 0
          super(token.attr_provider, type, algorithm, class_name, to_list(al), nil)
          @token = token
          @mechanism = mechanism & 0xffffffff
        end
        
        class_module.module_eval {
          typesig { [Array.typed(self::String)] }
          def to_list(aliases)
            return ((aliases).nil?) ? nil : Arrays.as_list(aliases)
          end
        }
        
        typesig { [Object] }
        def new_instance(param)
          if ((@token.is_valid).equal?(false))
            raise self.class::NoSuchAlgorithmException.new("Token has been removed")
          end
          begin
            return new_instance0(param)
          rescue self.class::PKCS11Exception => e
            raise self.class::NoSuchAlgorithmException.new(e)
          end
        end
        
        typesig { [Object] }
        def new_instance0(param)
          algorithm = get_algorithm
          type = get_type
          if ((type).equal?(MD))
            return self.class::P11Digest.new(@token, algorithm, @mechanism)
          else
            if ((type).equal?(CIP))
              verify_self_integrity(get_class)
              if (algorithm.starts_with("RSA"))
                return self.class::P11RSACipher.new(@token, algorithm, @mechanism)
              else
                return self.class::P11Cipher.new(@token, algorithm, @mechanism)
              end
            else
              if ((type).equal?(SIG))
                return self.class::P11Signature.new(@token, algorithm, @mechanism)
              else
                if ((type).equal?(MAC))
                  verify_self_integrity(get_class)
                  return self.class::P11Mac.new(@token, algorithm, @mechanism)
                else
                  if ((type).equal?(KPG))
                    return self.class::P11KeyPairGenerator.new(@token, algorithm, @mechanism)
                  else
                    if ((type).equal?(KA))
                      verify_self_integrity(get_class)
                      if ((algorithm == "ECDH"))
                        return self.class::P11ECDHKeyAgreement.new(@token, algorithm, @mechanism)
                      else
                        return self.class::P11KeyAgreement.new(@token, algorithm, @mechanism)
                      end
                    else
                      if ((type).equal?(KF))
                        return @token.get_key_factory(algorithm)
                      else
                        if ((type).equal?(SKF))
                          verify_self_integrity(get_class)
                          return self.class::P11SecretKeyFactory.new(@token, algorithm)
                        else
                          if ((type).equal?(KG))
                            verify_self_integrity(get_class)
                            # reference equality
                            if ((algorithm).equal?("SunTlsRsaPremasterSecret"))
                              return self.class::P11TlsRsaPremasterSecretGenerator.new(@token, algorithm, @mechanism)
                            else
                              if ((algorithm).equal?("SunTlsMasterSecret"))
                                return self.class::P11TlsMasterSecretGenerator.new(@token, algorithm, @mechanism)
                              else
                                if ((algorithm).equal?("SunTlsKeyMaterial"))
                                  return self.class::P11TlsKeyMaterialGenerator.new(@token, algorithm, @mechanism)
                                else
                                  if ((algorithm).equal?("SunTlsPrf"))
                                    return self.class::P11TlsPrfGenerator.new(@token, algorithm, @mechanism)
                                  else
                                    return self.class::P11KeyGenerator.new(@token, algorithm, @mechanism)
                                  end
                                end
                              end
                            end
                          else
                            if ((type).equal?(SR))
                              return @token.get_random
                            else
                              if ((type).equal?(KS))
                                return @token.get_key_store
                              else
                                if ((type).equal?(AGP))
                                  return Sun::Security::Ec::self.class::ECParameters.new
                                else
                                  raise self.class::NoSuchAlgorithmException.new("Unknown type: " + type)
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
        
        typesig { [Object] }
        def supports_parameter(param)
          if (((param).nil?) || ((@token.is_valid).equal?(false)))
            return false
          end
          if ((param.is_a?(self.class::Key)).equal?(false))
            raise self.class::InvalidParameterException.new("Parameter must be a Key")
          end
          algorithm = get_algorithm
          type = get_type
          key = param
          key_algorithm = key.get_algorithm
          # RSA signatures and cipher
          if ((((type).equal?(CIP)) && algorithm.starts_with("RSA")) || ((type).equal?(SIG)) && algorithm.ends_with("RSA"))
            if (((key_algorithm == "RSA")).equal?(false))
              return false
            end
            return is_local_key(key) || (key.is_a?(self.class::RSAPrivateKey)) || (key.is_a?(self.class::RSAPublicKey))
          end
          # EC
          if ((((type).equal?(KA)) && (algorithm == "ECDH")) || (((type).equal?(SIG)) && algorithm.ends_with("ECDSA")))
            if (((key_algorithm == "EC")).equal?(false))
              return false
            end
            return is_local_key(key) || (key.is_a?(self.class::ECPrivateKey)) || (key.is_a?(self.class::ECPublicKey))
          end
          # DSA signatures
          if (((type).equal?(SIG)) && algorithm.ends_with("DSA"))
            if (((key_algorithm == "DSA")).equal?(false))
              return false
            end
            return is_local_key(key) || (key.is_a?(self.class::DSAPrivateKey)) || (key.is_a?(self.class::DSAPublicKey))
          end
          # MACs and symmetric ciphers
          if (((type).equal?(CIP)) || ((type).equal?(MAC)))
            # do not check algorithm name, mismatch is unlikely anyway
            return is_local_key(key) || ("RAW" == key.get_format)
          end
          # DH key agreement
          if ((type).equal?(KA))
            if (((key_algorithm == "DH")).equal?(false))
              return false
            end
            return is_local_key(key) || (key.is_a?(self.class::DHPrivateKey)) || (key.is_a?(self.class::DHPublicKey))
          end
          # should not reach here,
          # unknown engine type or algorithm
          raise self.class::AssertionError.new("SunPKCS11 error: " + type + ", " + algorithm)
        end
        
        typesig { [self::Key] }
        def is_local_key(key)
          return (key.is_a?(self.class::P11Key)) && (((key).attr_token).equal?(@token))
        end
        
        typesig { [] }
        def to_s
          return RJava.cast_to_string(super) + " (" + RJava.cast_to_string(Functions.get_mechanism_name(@mechanism)) + ")"
        end
        
        private
        alias_method :initialize__p11service, :initialize
      end }
    }
    
    typesig { [Subject, CallbackHandler] }
    # Log in to this provider.
    # 
    # <p> If the token expects a PIN to be supplied by the caller,
    # the <code>handler</code> implementation must support
    # a <code>PasswordCallback</code>.
    # 
    # <p> To determine if the token supports a protected authentication path,
    # the CK_TOKEN_INFO flag, CKF_PROTECTED_AUTHENTICATION_PATH, is consulted.
    # 
    # @param subject this parameter is ignored
    # @param handler the <code>CallbackHandler</code> used by
    # this provider to communicate with the caller
    # 
    # @exception LoginException if the login operation fails
    # @exception SecurityException if the does not pass a security check for
    # <code>SecurityPermission("authProvider.<i>name</i>")</code>,
    # where <i>name</i> is the value returned by
    # this provider's <code>getName</code> method
    def login(subject, handler)
      # security check
      sm = System.get_security_manager
      if (!(sm).nil?)
        if (!(Debug).nil?)
          Debug.println("checking login permission")
        end
        sm.check_permission(SecurityPermission.new("authProvider." + RJava.cast_to_string(self.get_name)))
      end
      if ((has_valid_token).equal?(false))
        raise LoginException.new("No token present")
      end
      # see if a login is required
      if (((@token.attr_token_info.attr_flags & CKF_LOGIN_REQUIRED)).equal?(0))
        if (!(Debug).nil?)
          Debug.println("login operation not required for token - " + "ignoring login request")
        end
        return
      end
      # see if user already logged in
      begin
        if (@token.is_logged_in_now(nil))
          # user already logged in
          if (!(Debug).nil?)
            Debug.println("user already logged in")
          end
          return
        end
      rescue PKCS11Exception => e
        # ignore - fall thru and attempt login
      end
      # get the pin if necessary
      pin = nil
      if (((@token.attr_token_info.attr_flags & CKF_PROTECTED_AUTHENTICATION_PATH)).equal?(0))
        # get password
        my_handler = get_callback_handler(handler)
        if ((my_handler).nil?)
          # XXX PolicyTool is dependent on this message text
          raise LoginException.new("no password provided, and no callback handler " + "available for retrieving password")
        end
        form = Java::Text::MessageFormat.new(ResourcesMgr.get_string("PKCS11 Token [providerName] Password: "))
        source = Array.typed(Object).new([get_name])
        pcall = PasswordCallback.new(form.format(source), false)
        callbacks = Array.typed(Callback).new([pcall])
        begin
          my_handler.handle(callbacks)
        rescue JavaException => e
          le = LoginException.new("Unable to perform password callback")
          le.init_cause(e)
          raise le
        end
        pin = pcall.get_password
        pcall.clear_password
        if ((pin).nil?)
          if (!(Debug).nil?)
            Debug.println("caller passed NULL pin")
          end
        end
      end
      # perform token login
      session = nil
      begin
        session = @token.get_op_session
        # pin is NULL if using CKF_PROTECTED_AUTHENTICATION_PATH
        @p11._c_login(session.id, CKU_USER, pin)
        if (!(Debug).nil?)
          Debug.println("login succeeded")
        end
      rescue PKCS11Exception => pe
        if ((pe.get_error_code).equal?(CKR_USER_ALREADY_LOGGED_IN))
          # let this one go
          if (!(Debug).nil?)
            Debug.println("user already logged in")
          end
          return
        else
          if ((pe.get_error_code).equal?(CKR_PIN_INCORRECT))
            fle = FailedLoginException.new
            fle.init_cause(pe)
            raise fle
          else
            le = LoginException.new
            le.init_cause(pe)
            raise le
          end
        end
      ensure
        @token.release_session(session)
        if (!(pin).nil?)
          Arrays.fill(pin, Character.new(?\s.ord))
        end
      end
      # we do not store the PIN in the subject for now
    end
    
    typesig { [] }
    # Log out from this provider
    # 
    # @exception LoginException if the logout operation fails
    # @exception SecurityException if the does not pass a security check for
    # <code>SecurityPermission("authProvider.<i>name</i>")</code>,
    # where <i>name</i> is the value returned by
    # this provider's <code>getName</code> method
    def logout
      # security check
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_permission(SecurityPermission.new("authProvider." + RJava.cast_to_string(self.get_name)))
      end
      if ((has_valid_token).equal?(false))
        # app may call logout for cleanup, allow
        return
      end
      if (((@token.attr_token_info.attr_flags & CKF_LOGIN_REQUIRED)).equal?(0))
        if (!(Debug).nil?)
          Debug.println("logout operation not required for token - " + "ignoring logout request")
        end
        return
      end
      begin
        if ((@token.is_logged_in_now(nil)).equal?(false))
          if (!(Debug).nil?)
            Debug.println("user not logged in")
          end
          return
        end
      rescue PKCS11Exception => e
        # ignore
      end
      # perform token logout
      session = nil
      begin
        session = @token.get_op_session
        @p11._c_logout(session.id)
        if (!(Debug).nil?)
          Debug.println("logout succeeded")
        end
      rescue PKCS11Exception => pe
        if ((pe.get_error_code).equal?(CKR_USER_NOT_LOGGED_IN))
          # let this one go
          if (!(Debug).nil?)
            Debug.println("user not logged in")
          end
          return
        end
        le = LoginException.new
        le.init_cause(pe)
        raise le
      ensure
        @token.release_session(session)
      end
    end
    
    typesig { [CallbackHandler] }
    # Set a <code>CallbackHandler</code>
    # 
    # <p> The provider uses this handler if one is not passed to the
    # <code>login</code> method.  The provider also uses this handler
    # if it invokes <code>login</code> on behalf of callers.
    # In either case if a handler is not set via this method,
    # the provider queries the
    # <i>auth.login.defaultCallbackHandler</i> security property
    # for the fully qualified class name of a default handler implementation.
    # If the security property is not set,
    # the provider is assumed to have alternative means
    # for obtaining authentication information.
    # 
    # @param handler a <code>CallbackHandler</code> for obtaining
    # authentication information, which may be <code>null</code>
    # 
    # @exception SecurityException if the caller does not pass a
    # security check for
    # <code>SecurityPermission("authProvider.<i>name</i>")</code>,
    # where <i>name</i> is the value returned by
    # this provider's <code>getName</code> method
    def set_callback_handler(handler)
      # security check
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_permission(SecurityPermission.new("authProvider." + RJava.cast_to_string(self.get_name)))
      end
      synchronized((@lock_handler)) do
        @p_handler = handler
      end
    end
    
    typesig { [CallbackHandler] }
    def get_callback_handler(handler)
      # get default handler if necessary
      if (!(handler).nil?)
        return handler
      end
      if (!(Debug).nil?)
        Debug.println("getting provider callback handler")
      end
      synchronized((@lock_handler)) do
        # see if handler was set via setCallbackHandler
        if (!(@p_handler).nil?)
          return @p_handler
        end
        begin
          if (!(Debug).nil?)
            Debug.println("getting default callback handler")
          end
          my_handler = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
            extend LocalClass
            include_class_members SunPKCS11
            include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
            
            typesig { [] }
            define_method :run do
              default_handler = Java::Security::Security.get_property("auth.login.defaultCallbackHandler")
              if ((default_handler).nil? || (default_handler.length).equal?(0))
                # ok
                if (!(Debug).nil?)
                  Debug.println("no default handler set")
                end
                return nil
              end
              c = Class.for_name(default_handler, true, JavaThread.current_thread.get_context_class_loader)
              return c.new_instance
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          # save it
          @p_handler = my_handler
          return my_handler
        rescue PrivilegedActionException => pae
          # ok
          if (!(Debug).nil?)
            Debug.println("Unable to load default callback handler")
            pae.print_stack_trace
          end
        end
      end
      return nil
    end
    
    typesig { [] }
    def write_replace
      return SunPKCS11Rep.new(self)
    end
    
    class_module.module_eval {
      # Serialized representation of the SunPKCS11 provider.
      const_set_lazy(:SunPKCS11Rep) { Class.new do
        include_class_members SunPKCS11
        include Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -2896606995897745419 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :provider_name
        alias_method :attr_provider_name, :provider_name
        undef_method :provider_name
        alias_method :attr_provider_name=, :provider_name=
        undef_method :provider_name=
        
        attr_accessor :config_name
        alias_method :attr_config_name, :config_name
        undef_method :config_name
        alias_method :attr_config_name=, :config_name=
        undef_method :config_name=
        
        typesig { [self::SunPKCS11] }
        def initialize(provider)
          @provider_name = nil
          @config_name = nil
          @provider_name = RJava.cast_to_string(provider.get_name)
          @config_name = RJava.cast_to_string(provider.attr_config_name)
          if (!(Security.get_provider(@provider_name)).equal?(provider))
            raise self.class::NotSerializableException.new("Only SunPKCS11 providers " + "installed in java.security.Security can be serialized")
          end
        end
        
        typesig { [] }
        def read_resolve
          p = Security.get_provider(@provider_name)
          if (((p).nil?) || (((p.attr_config_name == @config_name)).equal?(false)))
            raise self.class::NotSerializableException.new("Could not find " + @provider_name + " in installed providers")
          end
          return p
        end
        
        private
        alias_method :initialize__sun_pkcs11rep, :initialize
      end }
    }
    
    private
    alias_method :initialize__sun_pkcs11, :initialize
  end
  
end
