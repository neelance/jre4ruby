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
module Sun::Security::Mscapi
  module RSAPrivateKeyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Mscapi
      include_const ::Java::Security, :PrivateKey
    }
  end
  
  # The handle for an RSA private key using the Microsoft Crypto API.
  # 
  # @author Stanley Man-Kit Ho
  # @since 1.6
  class RSAPrivateKey < RSAPrivateKeyImports.const_get :Key
    include_class_members RSAPrivateKeyImports
    overload_protected {
      include PrivateKey
    }
    
    typesig { [::Java::Long, ::Java::Long, ::Java::Int] }
    # Construct an RSAPrivateKey object.
    def initialize(h_crypt_prov, h_crypt_key, key_length)
      super(h_crypt_prov, h_crypt_key, key_length)
    end
    
    typesig { [] }
    # Returns the standard algorithm name for this key. For
    # example, "RSA" would indicate that this key is a RSA key.
    # See Appendix A in the <a href=
    # "../../../guide/security/CryptoSpec.html#AppA">
    # Java Cryptography Architecture API Specification &amp; Reference </a>
    # for information about standard algorithm names.
    # 
    # @return the name of the algorithm associated with this key.
    def get_algorithm
      return "RSA"
    end
    
    typesig { [] }
    def to_s
      return "RSAPrivateKey [size=" + RJava.cast_to_string(self.attr_key_length) + " bits, type=" + RJava.cast_to_string(get_key_type(self.attr_h_crypt_key)) + ", container=" + RJava.cast_to_string(get_container_name(self.attr_h_crypt_prov)) + "]"
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # This class is not serializable
    def write_object(out)
      raise Java::Io::NotSerializableException.new
    end
    
    private
    alias_method :initialize__rsaprivate_key, :initialize
  end
  
end
