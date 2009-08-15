require "rjava"

# Copyright 2005-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DefaultSSLContextImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include ::Java::Util
      include ::Java::Security
      include ::Javax::Net::Ssl
    }
  end
  
  # "Default" SSLContext as returned by SSLContext.getDefault(). It comes
  # initialized with default KeyManagers and TrustManagers created using
  # various system properties.
  # 
  # @since   1.6
  class DefaultSSLContextImpl < DefaultSSLContextImplImports.const_get :SSLContextImpl
    include_class_members DefaultSSLContextImplImports
    
    class_module.module_eval {
      const_set_lazy(:NONE) { "NONE" }
      const_attr_reader  :NONE
      
      const_set_lazy(:P11KEYSTORE) { "PKCS11" }
      const_attr_reader  :P11KEYSTORE
      
      const_set_lazy(:Debug) { Debug.get_instance("ssl") }
      const_attr_reader  :Debug
      
      
      def default_impl
        defined?(@@default_impl) ? @@default_impl : @@default_impl= nil
      end
      alias_method :attr_default_impl, :default_impl
      
      def default_impl=(value)
        @@default_impl = value
      end
      alias_method :attr_default_impl=, :default_impl=
      
      
      def default_trust_managers
        defined?(@@default_trust_managers) ? @@default_trust_managers : @@default_trust_managers= nil
      end
      alias_method :attr_default_trust_managers, :default_trust_managers
      
      def default_trust_managers=(value)
        @@default_trust_managers = value
      end
      alias_method :attr_default_trust_managers=, :default_trust_managers=
      
      
      def default_key_managers
        defined?(@@default_key_managers) ? @@default_key_managers : @@default_key_managers= nil
      end
      alias_method :attr_default_key_managers, :default_key_managers
      
      def default_key_managers=(value)
        @@default_key_managers = value
      end
      alias_method :attr_default_key_managers=, :default_key_managers=
    }
    
    typesig { [] }
    def initialize
      super(self.attr_default_impl)
      begin
        SSLContextImpl.instance_method(:engine_init).bind(self).call(get_default_key_manager, get_default_trust_manager, nil)
      rescue JavaException => e
        if (!(Debug).nil? && Debug.is_on("defaultctx"))
          System.out.println("default context init failed: " + RJava.cast_to_string(e))
        end
        raise e
      end
      if ((self.attr_default_impl).nil?)
        self.attr_default_impl = self
      end
    end
    
    typesig { [Array.typed(KeyManager), Array.typed(TrustManager), SecureRandom] }
    def engine_init(km, tm, sr)
      raise KeyManagementException.new("Default SSLContext is initialized automatically")
    end
    
    class_module.module_eval {
      typesig { [] }
      def get_default_impl
        synchronized(self) do
          if ((self.attr_default_impl).nil?)
            DefaultSSLContextImpl.new
          end
          return self.attr_default_impl
        end
      end
      
      typesig { [] }
      def get_default_trust_manager
        synchronized(self) do
          if (!(self.attr_default_trust_managers).nil?)
            return self.attr_default_trust_managers
          end
          ks = TrustManagerFactoryImpl.get_cacerts_key_store("defaultctx")
          tmf = TrustManagerFactory.get_instance(TrustManagerFactory.get_default_algorithm)
          tmf.init(ks)
          self.attr_default_trust_managers = tmf.get_trust_managers
          return self.attr_default_trust_managers
        end
      end
      
      typesig { [] }
      def get_default_key_manager
        synchronized(self) do
          if (!(self.attr_default_key_managers).nil?)
            return self.attr_default_key_managers
          end
          props = HashMap.new
          AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
            extend LocalClass
            include_class_members DefaultSSLContextImpl
            include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
            
            typesig { [] }
            define_method :run do
              props.put("keyStore", System.get_property("javax.net.ssl.keyStore", ""))
              props.put("keyStoreType", System.get_property("javax.net.ssl.keyStoreType", KeyStore.get_default_type))
              props.put("keyStoreProvider", System.get_property("javax.net.ssl.keyStoreProvider", ""))
              props.put("keyStorePasswd", System.get_property("javax.net.ssl.keyStorePassword", ""))
              return nil
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          default_key_store = props.get("keyStore")
          default_key_store_type = props.get("keyStoreType")
          default_key_store_provider = props.get("keyStoreProvider")
          if (!(Debug).nil? && Debug.is_on("defaultctx"))
            System.out.println("keyStore is : " + default_key_store)
            System.out.println("keyStore type is : " + default_key_store_type)
            System.out.println("keyStore provider is : " + default_key_store_provider)
          end
          if ((P11KEYSTORE == default_key_store_type) && !(NONE == default_key_store))
            raise IllegalArgumentException.new("if keyStoreType is " + P11KEYSTORE + ", then keyStore must be " + NONE)
          end
          fs = nil
          if (!(default_key_store.length).equal?(0) && !(NONE == default_key_store))
            fs = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
              extend LocalClass
              include_class_members DefaultSSLContextImpl
              include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
              
              typesig { [] }
              define_method :run do
                return FileInputStream.new(default_key_store)
              end
              
              typesig { [] }
              define_method :initialize do
                super()
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          end
          default_key_store_password = props.get("keyStorePasswd")
          passwd = nil
          if (!(default_key_store_password.length).equal?(0))
            passwd = default_key_store_password.to_char_array
          end
          # Try to initialize key store.
          ks = nil
          if (!((default_key_store_type.length)).equal?(0))
            if (!(Debug).nil? && Debug.is_on("defaultctx"))
              System.out.println("init keystore")
            end
            if ((default_key_store_provider.length).equal?(0))
              ks = KeyStore.get_instance(default_key_store_type)
            else
              ks = KeyStore.get_instance(default_key_store_type, default_key_store_provider)
            end
            # if defaultKeyStore is NONE, fs will be null
            ks.load(fs, passwd)
          end
          if (!(fs).nil?)
            fs.close
            fs = nil
          end
          # Try to initialize key manager.
          if (!(Debug).nil? && Debug.is_on("defaultctx"))
            System.out.println("init keymanager of type " + RJava.cast_to_string(KeyManagerFactory.get_default_algorithm))
          end
          kmf = KeyManagerFactory.get_instance(KeyManagerFactory.get_default_algorithm)
          if ((P11KEYSTORE == default_key_store_type))
            kmf.init(ks, nil) # do not pass key passwd if using token
          else
            kmf.init(ks, passwd)
          end
          self.attr_default_key_managers = kmf.get_key_managers
          return self.attr_default_key_managers
        end
      end
    }
    
    private
    alias_method :initialize__default_sslcontext_impl, :initialize
  end
  
end
