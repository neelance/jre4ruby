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
module Sun::Security::Mscapi
  module SunMSCAPIImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Mscapi
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :Provider
      include_const ::Java::Security, :ProviderException
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Sun::Security::Action, :PutAllAction
    }
  end
  
  # A Cryptographic Service Provider for the Microsoft Crypto API.
  # 
  # @since 1.6
  class SunMSCAPI < SunMSCAPIImports.const_get :Provider
    include_class_members SunMSCAPIImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 8622598936488630849 }
      const_attr_reader  :SerialVersionUID
      
      # TODO
      const_set_lazy(:INFO) { "Sun's Microsoft Crypto API provider" }
      const_attr_reader  :INFO
      
      when_class_loaded do
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members SunMSCAPI
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            System.load_library("sunmscapi")
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
    }
    
    typesig { [] }
    def initialize
      super("SunMSCAPI", 1.7, INFO)
      # if there is no security manager installed, put directly into
      # the provider. Otherwise, create a temporary map and use a
      # doPrivileged() call at the end to transfer the contents
      map = ((System.get_security_manager).nil?) ? self : HashMap.new
      # Secure random
      map.put("SecureRandom.Windows-PRNG", "sun.security.mscapi.PRNG")
      # Key store
      map.put("KeyStore.Windows-MY", "sun.security.mscapi.KeyStore$MY")
      map.put("KeyStore.Windows-ROOT", "sun.security.mscapi.KeyStore$ROOT")
      # Signature engines
      map.put("Signature.SHA1withRSA", "sun.security.mscapi.RSASignature$SHA1")
      map.put("Signature.MD5withRSA", "sun.security.mscapi.RSASignature$MD5")
      map.put("Signature.MD2withRSA", "sun.security.mscapi.RSASignature$MD2")
      # supported key classes
      map.put("Signature.SHA1withRSA SupportedKeyClasses", "sun.security.mscapi.Key")
      map.put("Signature.MD5withRSA SupportedKeyClasses", "sun.security.mscapi.Key")
      map.put("Signature.MD2withRSA SupportedKeyClasses", "sun.security.mscapi.Key")
      map.put("Signature.NONEwithRSA SupportedKeyClasses", "sun.security.mscapi.Key")
      # Key Pair Generator engines
      map.put("KeyPairGenerator.RSA", "sun.security.mscapi.RSAKeyPairGenerator")
      map.put("KeyPairGenerator.RSA KeySize", "1024")
      # Cipher engines
      map.put("Cipher.RSA", "sun.security.mscapi.RSACipher")
      map.put("Cipher.RSA/ECB/PKCS1Padding", "sun.security.mscapi.RSACipher")
      map.put("Cipher.RSA SupportedModes", "ECB")
      map.put("Cipher.RSA SupportedPaddings", "PKCS1PADDING")
      map.put("Cipher.RSA SupportedKeyClasses", "sun.security.mscapi.Key")
      if (!(map).equal?(self))
        AccessController.do_privileged(PutAllAction.new(self, map))
      end
    end
    
    class_module.module_eval {
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
            raise ProviderException.new("The SunMSCAPI provider may have been tampered with.")
          end
        end
      end
    }
    
    private
    alias_method :initialize__sun_mscapi, :initialize
  end
  
end
