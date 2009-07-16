require "rjava"

# 
# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Rsa
  module SunRsaSignEntriesImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Rsa
      include_const ::Java::Util, :Map
    }
  end
  
  # 
  # Defines the entries of the SunRsaSign provider.
  # 
  # @author  Andreas Sterbenz
  class SunRsaSignEntries 
    include_class_members SunRsaSignEntriesImports
    
    typesig { [] }
    def initialize
      # empty
    end
    
    class_module.module_eval {
      typesig { [Map] }
      def put_entries(map)
        # main algorithms
        map.put("KeyFactory.RSA", "sun.security.rsa.RSAKeyFactory")
        map.put("KeyPairGenerator.RSA", "sun.security.rsa.RSAKeyPairGenerator")
        map.put("Signature.MD2withRSA", "sun.security.rsa.RSASignature$MD2withRSA")
        map.put("Signature.MD5withRSA", "sun.security.rsa.RSASignature$MD5withRSA")
        map.put("Signature.SHA1withRSA", "sun.security.rsa.RSASignature$SHA1withRSA")
        map.put("Signature.SHA256withRSA", "sun.security.rsa.RSASignature$SHA256withRSA")
        map.put("Signature.SHA384withRSA", "sun.security.rsa.RSASignature$SHA384withRSA")
        map.put("Signature.SHA512withRSA", "sun.security.rsa.RSASignature$SHA512withRSA")
        # attributes for supported key classes
        rsa_key_classes = "java.security.interfaces.RSAPublicKey" + "|java.security.interfaces.RSAPrivateKey"
        map.put("Signature.MD2withRSA SupportedKeyClasses", rsa_key_classes)
        map.put("Signature.MD5withRSA SupportedKeyClasses", rsa_key_classes)
        map.put("Signature.SHA1withRSA SupportedKeyClasses", rsa_key_classes)
        map.put("Signature.SHA256withRSA SupportedKeyClasses", rsa_key_classes)
        map.put("Signature.SHA384withRSA SupportedKeyClasses", rsa_key_classes)
        map.put("Signature.SHA512withRSA SupportedKeyClasses", rsa_key_classes)
        # aliases
        map.put("Alg.Alias.KeyFactory.1.2.840.113549.1.1", "RSA")
        map.put("Alg.Alias.KeyFactory.OID.1.2.840.113549.1.1", "RSA")
        map.put("Alg.Alias.KeyPairGenerator.1.2.840.113549.1.1", "RSA")
        map.put("Alg.Alias.KeyPairGenerator.OID.1.2.840.113549.1.1", "RSA")
        map.put("Alg.Alias.Signature.1.2.840.113549.1.1.2", "MD2withRSA")
        map.put("Alg.Alias.Signature.OID.1.2.840.113549.1.1.2", "MD2withRSA")
        map.put("Alg.Alias.Signature.1.2.840.113549.1.1.4", "MD5withRSA")
        map.put("Alg.Alias.Signature.OID.1.2.840.113549.1.1.4", "MD5withRSA")
        map.put("Alg.Alias.Signature.1.2.840.113549.1.1.5", "SHA1withRSA")
        map.put("Alg.Alias.Signature.OID.1.2.840.113549.1.1.5", "SHA1withRSA")
        map.put("Alg.Alias.Signature.1.3.14.3.2.29", "SHA1withRSA")
        map.put("Alg.Alias.Signature.1.2.840.113549.1.1.11", "SHA256withRSA")
        map.put("Alg.Alias.Signature.OID.1.2.840.113549.1.1.11", "SHA256withRSA")
        map.put("Alg.Alias.Signature.1.2.840.113549.1.1.12", "SHA384withRSA")
        map.put("Alg.Alias.Signature.OID.1.2.840.113549.1.1.12", "SHA384withRSA")
        map.put("Alg.Alias.Signature.1.2.840.113549.1.1.13", "SHA512withRSA")
        map.put("Alg.Alias.Signature.OID.1.2.840.113549.1.1.13", "SHA512withRSA")
      end
    }
    
    private
    alias_method :initialize__sun_rsa_sign_entries, :initialize
  end
  
end
