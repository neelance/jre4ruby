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
module Sun::Security::Internal::Spec
  module TlsKeyMaterialSpecImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Internal::Spec
      include_const ::Java::Security::Spec, :KeySpec
      include_const ::Javax::Crypto, :SecretKey
      include_const ::Javax::Crypto::Spec, :IvParameterSpec
    }
  end
  
  # KeySpec class for SSL/TLS key material.
  # 
  # <p>Instances of this class are returned by the <code>generateKey()</code>
  # method of KeyGenerators of the type "TlsKeyMaterial".
  # Instances of this class are immutable.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  # @deprecated Sun JDK internal use only --- WILL BE REMOVED in Dolphin (JDK 7)
  class TlsKeyMaterialSpec 
    include_class_members TlsKeyMaterialSpecImports
    include KeySpec
    include SecretKey
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 812912859129525028 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :client_mac_key
    alias_method :attr_client_mac_key, :client_mac_key
    undef_method :client_mac_key
    alias_method :attr_client_mac_key=, :client_mac_key=
    undef_method :client_mac_key=
    
    attr_accessor :server_mac_key
    alias_method :attr_server_mac_key, :server_mac_key
    undef_method :server_mac_key
    alias_method :attr_server_mac_key=, :server_mac_key=
    undef_method :server_mac_key=
    
    attr_accessor :client_cipher_key
    alias_method :attr_client_cipher_key, :client_cipher_key
    undef_method :client_cipher_key
    alias_method :attr_client_cipher_key=, :client_cipher_key=
    undef_method :client_cipher_key=
    
    attr_accessor :server_cipher_key
    alias_method :attr_server_cipher_key, :server_cipher_key
    undef_method :server_cipher_key
    alias_method :attr_server_cipher_key=, :server_cipher_key=
    undef_method :server_cipher_key=
    
    attr_accessor :client_iv
    alias_method :attr_client_iv, :client_iv
    undef_method :client_iv
    alias_method :attr_client_iv=, :client_iv=
    undef_method :client_iv=
    
    attr_accessor :server_iv
    alias_method :attr_server_iv, :server_iv
    undef_method :server_iv
    alias_method :attr_server_iv=, :server_iv=
    undef_method :server_iv=
    
    typesig { [SecretKey, SecretKey] }
    # Constructs a new TlsKeymaterialSpec from the client and server MAC
    # keys.
    # This call is equivalent to
    # <code>new TlsKeymaterialSpec(clientMacKey, serverMacKey,
    # null, null, null, null)</code>.
    # 
    # @param clientMacKey the client MAC key
    # @param serverMacKey the server MAC key
    # @throws NullPointerException if clientMacKey or serverMacKey is null
    def initialize(client_mac_key, server_mac_key)
      initialize__tls_key_material_spec(client_mac_key, server_mac_key, nil, nil, nil, nil)
    end
    
    typesig { [SecretKey, SecretKey, SecretKey, SecretKey] }
    # Constructs a new TlsKeymaterialSpec from the client and server MAC
    # keys and client and server cipher keys.
    # This call is equivalent to
    # <code>new TlsKeymaterialSpec(clientMacKey, serverMacKey,
    # clientCipherKey, serverCipherKey, null, null)</code>.
    # 
    # @param clientMacKey the client MAC key
    # @param serverMacKey the server MAC key
    # @param clientCipherKey the client cipher key (or null)
    # @param serverCipherKey the server cipher key (or null)
    # @throws NullPointerException if clientMacKey or serverMacKey is null
    def initialize(client_mac_key, server_mac_key, client_cipher_key, server_cipher_key)
      initialize__tls_key_material_spec(client_mac_key, server_mac_key, client_cipher_key, nil, server_cipher_key, nil)
    end
    
    typesig { [SecretKey, SecretKey, SecretKey, IvParameterSpec, SecretKey, IvParameterSpec] }
    # Constructs a new TlsKeymaterialSpec from the client and server MAC
    # keys, client and server cipher keys, and client and server
    # initialization vectors.
    # 
    # @param clientMacKey the client MAC key
    # @param serverMacKey the server MAC key
    # @param clientCipherKey the client cipher key (or null)
    # @param clientIv the client initialization vector (or null)
    # @param serverCipherKey the server cipher key (or null)
    # @param serverIv the server initialization vector (or null)
    # 
    # @throws NullPointerException if clientMacKey or serverMacKey is null
    def initialize(client_mac_key, server_mac_key, client_cipher_key, client_iv, server_cipher_key, server_iv)
      @client_mac_key = nil
      @server_mac_key = nil
      @client_cipher_key = nil
      @server_cipher_key = nil
      @client_iv = nil
      @server_iv = nil
      if (((client_mac_key).nil?) || ((server_mac_key).nil?))
        raise NullPointerException.new("MAC keys must not be null")
      end
      @client_mac_key = client_mac_key
      @server_mac_key = server_mac_key
      @client_cipher_key = client_cipher_key
      @server_cipher_key = server_cipher_key
      @client_iv = client_iv
      @server_iv = server_iv
    end
    
    typesig { [] }
    # Returns <code>TlsKeyMaterial</code>.
    # 
    # @return <code>TlsKeyMaterial</code>.
    def get_algorithm
      return "TlsKeyMaterial"
    end
    
    typesig { [] }
    # Returns <code>null</code> because keys of this type have no encoding.
    # 
    # @return <code>null</code> because keys of this type have no encoding.
    def get_format
      return nil
    end
    
    typesig { [] }
    # Returns <code>null</code> because keys of this type have no encoding.
    # 
    # @return <code>null</code> because keys of this type have no encoding.
    def get_encoded
      return nil
    end
    
    typesig { [] }
    # Returns the client MAC key.
    # 
    # @return the client MAC key.
    def get_client_mac_key
      return @client_mac_key
    end
    
    typesig { [] }
    # Return the server MAC key.
    # 
    # @return the server MAC key.
    def get_server_mac_key
      return @server_mac_key
    end
    
    typesig { [] }
    # Return the client cipher key (or null).
    # 
    # @return the client cipher key (or null).
    def get_client_cipher_key
      return @client_cipher_key
    end
    
    typesig { [] }
    # Return the client initialization vector (or null).
    # 
    # @return the client initialization vector (or null).
    def get_client_iv
      return @client_iv
    end
    
    typesig { [] }
    # Return the server cipher key (or null).
    # 
    # @return the server cipher key (or null).
    def get_server_cipher_key
      return @server_cipher_key
    end
    
    typesig { [] }
    # Return the server initialization vector (or null).
    # 
    # @return the server initialization vector (or null).
    def get_server_iv
      return @server_iv
    end
    
    private
    alias_method :initialize__tls_key_material_spec, :initialize
  end
  
end
