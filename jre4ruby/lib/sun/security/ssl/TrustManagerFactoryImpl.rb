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
  module TrustManagerFactoryImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Util
      include ::Java::Io
      include ::Java::Math
      include ::Java::Security
      include ::Java::Security::Cert
      include ::Javax::Net::Ssl
      include_const ::Java::Security::Spec, :AlgorithmParameterSpec
      include_const ::Sun::Security::Validator, :Validator
    }
  end
  
  class TrustManagerFactoryImpl < TrustManagerFactoryImplImports.const_get :TrustManagerFactorySpi
    include_class_members TrustManagerFactoryImplImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("ssl") }
      const_attr_reader  :Debug
    }
    
    attr_accessor :trust_manager
    alias_method :attr_trust_manager, :trust_manager
    undef_method :trust_manager
    alias_method :attr_trust_manager=, :trust_manager=
    undef_method :trust_manager=
    
    attr_accessor :is_initialized
    alias_method :attr_is_initialized, :is_initialized
    undef_method :is_initialized
    alias_method :attr_is_initialized=, :is_initialized=
    undef_method :is_initialized=
    
    typesig { [] }
    def initialize
      @trust_manager = nil
      @is_initialized = false
      super()
      @trust_manager = nil
      @is_initialized = false
      # empty
    end
    
    typesig { [KeyStore] }
    def engine_init(ks)
      if ((ks).nil?)
        begin
          ks = get_cacerts_key_store("trustmanager")
        rescue SecurityException => se
          # eat security exceptions but report other throwables
          if (!(Debug).nil? && Debug.is_on("trustmanager"))
            System.out.println("SunX509: skip default keystore: " + (se).to_s)
          end
        rescue JavaError => err
          if (!(Debug).nil? && Debug.is_on("trustmanager"))
            System.out.println("SunX509: skip default keystore: " + (err).to_s)
          end
          raise err
        rescue RuntimeException => re
          if (!(Debug).nil? && Debug.is_on("trustmanager"))
            System.out.println("SunX509: skip default keystore: " + (re).to_s)
          end
          raise re
        rescue Exception => e
          if (!(Debug).nil? && Debug.is_on("trustmanager"))
            System.out.println("SunX509: skip default keystore: " + (e).to_s)
          end
          raise KeyStoreException.new("problem accessing trust store" + (e).to_s)
        end
      end
      @trust_manager = get_instance(ks)
      @is_initialized = true
    end
    
    typesig { [KeyStore] }
    def get_instance(ks)
      raise NotImplementedError
    end
    
    typesig { [ManagerFactoryParameters] }
    def get_instance(spec)
      raise NotImplementedError
    end
    
    typesig { [ManagerFactoryParameters] }
    def engine_init(spec)
      @trust_manager = get_instance(spec)
      @is_initialized = true
    end
    
    typesig { [] }
    # Returns one trust manager for each type of trust material.
    def engine_get_trust_managers
      if (!@is_initialized)
        raise IllegalStateException.new("TrustManagerFactoryImpl is not initialized")
      end
      return Array.typed(TrustManager).new([@trust_manager])
    end
    
    class_module.module_eval {
      typesig { [JavaFile] }
      # Try to get an InputStream based on the file we pass in.
      def get_file_input_stream(file)
        return AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members TrustManagerFactoryImpl
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            begin
              if (file.exists)
                return FileInputStream.new(file)
              else
                return nil
              end
            rescue FileNotFoundException => e
              # couldn't find it, oh well.
              return nil
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [String] }
      # Returns the keystore with the configured CA certificates.
      def get_cacerts_key_store(dbgname)
        store_file_name = nil
        store_file = nil
        fis = nil
        default_trust_store_type = nil
        default_trust_store_provider = nil
        props = HashMap.new
        sep = JavaFile.attr_separator
        ks = nil
        AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members TrustManagerFactoryImpl
          include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            props.put("trustStore", System.get_property("javax.net.ssl.trustStore"))
            props.put("javaHome", System.get_property("java.home"))
            props.put("trustStoreType", System.get_property("javax.net.ssl.trustStoreType", KeyStore.get_default_type))
            props.put("trustStoreProvider", System.get_property("javax.net.ssl.trustStoreProvider", ""))
            props.put("trustStorePasswd", System.get_property("javax.net.ssl.trustStorePassword", ""))
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        # Try:
        # javax.net.ssl.trustStore  (if this variable exists, stop)
        # jssecacerts
        # cacerts
        # 
        # If none exists, we use an empty keystore.
        store_file_name = (props.get("trustStore")).to_s
        if (!("NONE" == store_file_name))
          if (!(store_file_name).nil?)
            store_file = JavaFile.new(store_file_name)
            fis = get_file_input_stream(store_file)
          else
            java_home = props.get("javaHome")
            store_file = JavaFile.new(java_home + sep + "lib" + sep + "security" + sep + "jssecacerts")
            if (((fis = get_file_input_stream(store_file))).nil?)
              store_file = JavaFile.new(java_home + sep + "lib" + sep + "security" + sep + "cacerts")
              fis = get_file_input_stream(store_file)
            end
          end
          if (!(fis).nil?)
            store_file_name = (store_file.get_path).to_s
          else
            store_file_name = "No File Available, using empty keystore."
          end
        end
        default_trust_store_type = (props.get("trustStoreType")).to_s
        default_trust_store_provider = (props.get("trustStoreProvider")).to_s
        if (!(Debug).nil? && Debug.is_on(dbgname))
          System.out.println("trustStore is: " + store_file_name)
          System.out.println("trustStore type is : " + default_trust_store_type)
          System.out.println("trustStore provider is : " + default_trust_store_provider)
        end
        # Try to initialize trust store.
        if (!(default_trust_store_type.length).equal?(0))
          if (!(Debug).nil? && Debug.is_on(dbgname))
            System.out.println("init truststore")
          end
          if ((default_trust_store_provider.length).equal?(0))
            ks = KeyStore.get_instance(default_trust_store_type)
          else
            ks = KeyStore.get_instance(default_trust_store_type, default_trust_store_provider)
          end
          passwd = nil
          default_trust_store_password = props.get("trustStorePasswd")
          if (!(default_trust_store_password.length).equal?(0))
            passwd = default_trust_store_password.to_char_array
          end
          # if trustStore is NONE, fis will be null
          ks.load(fis, passwd)
          # Zero out the temporary password storage
          if (!(passwd).nil?)
            i = 0
            while i < passwd.attr_length
              passwd[i] = RJava.cast_to_char(0)
              ((i += 1) - 1)
            end
          end
        end
        if (!(fis).nil?)
          fis.close
        end
        return ks
      end
      
      const_set_lazy(:SimpleFactory) { Class.new(TrustManagerFactoryImpl) do
        include_class_members TrustManagerFactoryImpl
        
        typesig { [KeyStore] }
        def get_instance(ks)
          return X509TrustManagerImpl.new(Validator::TYPE_SIMPLE, ks)
        end
        
        typesig { [ManagerFactoryParameters] }
        def get_instance(spec)
          raise InvalidAlgorithmParameterException.new("SunX509 TrustManagerFactory does not use " + "ManagerFactoryParameters")
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__simple_factory, :initialize
      end }
      
      const_set_lazy(:PKIXFactory) { Class.new(TrustManagerFactoryImpl) do
        include_class_members TrustManagerFactoryImpl
        
        typesig { [KeyStore] }
        def get_instance(ks)
          return X509TrustManagerImpl.new(Validator::TYPE_PKIX, ks)
        end
        
        typesig { [ManagerFactoryParameters] }
        def get_instance(spec)
          if ((spec.is_a?(CertPathTrustManagerParameters)).equal?(false))
            raise InvalidAlgorithmParameterException.new("Parameters must be CertPathTrustManagerParameters")
          end
          params = (spec).get_parameters
          if ((params.is_a?(PKIXBuilderParameters)).equal?(false))
            raise InvalidAlgorithmParameterException.new("Encapsulated parameters must be PKIXBuilderParameters")
          end
          pkix_params = params
          return X509TrustManagerImpl.new(Validator::TYPE_PKIX, pkix_params)
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__pkixfactory, :initialize
      end }
    }
    
    private
    alias_method :initialize__trust_manager_factory_impl, :initialize
  end
  
end
