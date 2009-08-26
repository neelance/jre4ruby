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
  module KeyManagerFactoryImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Collections
      include ::Java::Security
      include ::Java::Security::KeyStore
      include ::Javax::Net::Ssl
    }
  end
  
  class KeyManagerFactoryImpl < KeyManagerFactoryImplImports.const_get :KeyManagerFactorySpi
    include_class_members KeyManagerFactoryImplImports
    
    attr_accessor :key_manager
    alias_method :attr_key_manager, :key_manager
    undef_method :key_manager
    alias_method :attr_key_manager=, :key_manager=
    undef_method :key_manager=
    
    attr_accessor :is_initialized
    alias_method :attr_is_initialized, :is_initialized
    undef_method :is_initialized
    alias_method :attr_is_initialized=, :is_initialized=
    undef_method :is_initialized=
    
    typesig { [] }
    def initialize
      @key_manager = nil
      @is_initialized = false
      super()
      # empty
    end
    
    typesig { [] }
    # Returns one key manager for each type of key material.
    def engine_get_key_managers
      if (!@is_initialized)
        raise IllegalStateException.new("KeyManagerFactoryImpl is not initialized")
      end
      return Array.typed(KeyManager).new([@key_manager])
    end
    
    class_module.module_eval {
      # Factory for the SunX509 keymanager
      const_set_lazy(:SunX509) { Class.new(KeyManagerFactoryImpl) do
        include_class_members KeyManagerFactoryImpl
        
        typesig { [self::KeyStore, Array.typed(::Java::Char)] }
        def engine_init(ks, password)
          if ((!(ks).nil?) && SunJSSE.is_fips)
            if (!(ks.get_provider).equal?(SunJSSE.attr_crypto_provider))
              raise self.class::KeyStoreException.new("FIPS mode: KeyStore must be " + "from provider " + RJava.cast_to_string(SunJSSE.attr_crypto_provider.get_name))
            end
          end
          self.attr_key_manager = self.class::SunX509KeyManagerImpl.new(ks, password)
          self.attr_is_initialized = true
        end
        
        typesig { [self::ManagerFactoryParameters] }
        def engine_init(spec)
          raise self.class::InvalidAlgorithmParameterException.new("SunX509KeyManager does not use ManagerFactoryParameters")
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__sun_x509, :initialize
      end }
      
      # Factory for the X509 keymanager
      const_set_lazy(:X509) { Class.new(KeyManagerFactoryImpl) do
        include_class_members KeyManagerFactoryImpl
        
        typesig { [self::KeyStore, Array.typed(::Java::Char)] }
        def engine_init(ks, password)
          if ((ks).nil?)
            self.attr_key_manager = self.class::X509KeyManagerImpl.new(Collections.empty_list)
          else
            if (SunJSSE.is_fips && (!(ks.get_provider).equal?(SunJSSE.attr_crypto_provider)))
              raise self.class::KeyStoreException.new("FIPS mode: KeyStore must be " + "from provider " + RJava.cast_to_string(SunJSSE.attr_crypto_provider.get_name))
            end
            begin
              builder = Builder.new_instance(ks, self.class::PasswordProtection.new(password))
              self.attr_key_manager = self.class::X509KeyManagerImpl.new(builder)
            rescue self.class::RuntimeException => e
              raise self.class::KeyStoreException.new("initialization failed", e)
            end
          end
          self.attr_is_initialized = true
        end
        
        typesig { [self::ManagerFactoryParameters] }
        def engine_init(params)
          if ((params.is_a?(self.class::KeyStoreBuilderParameters)).equal?(false))
            raise self.class::InvalidAlgorithmParameterException.new("Parameters must be instance of KeyStoreBuilderParameters")
          end
          if (SunJSSE.is_fips)
            # XXX should be fixed
            raise self.class::InvalidAlgorithmParameterException.new("FIPS mode: KeyStoreBuilderParameters not supported")
          end
          builders = (params).get_parameters
          self.attr_key_manager = self.class::X509KeyManagerImpl.new(builders)
          self.attr_is_initialized = true
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__x509, :initialize
      end }
    }
    
    private
    alias_method :initialize__key_manager_factory_impl, :initialize
  end
  
end
