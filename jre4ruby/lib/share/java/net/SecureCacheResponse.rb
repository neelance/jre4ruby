require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Net
  module SecureCacheResponseImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Javax::Net::Ssl, :SSLPeerUnverifiedException
      include_const ::Java::Security, :Principal
      include_const ::Java::Util, :JavaList
    }
  end
  
  # Represents a cache response originally retrieved through secure
  # means, such as TLS.
  # 
  # @since 1.5
  class SecureCacheResponse < SecureCacheResponseImports.const_get :CacheResponse
    include_class_members SecureCacheResponseImports
    
    typesig { [] }
    # Returns the cipher suite in use on the original connection that
    # retrieved the network resource.
    # 
    # @return a string representing the cipher suite
    def get_cipher_suite
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the certificate chain that were sent to the server during
    # handshaking of the original connection that retrieved the
    # network resource.  Note: This method is useful only
    # when using certificate-based cipher suites.
    # 
    # @return an immutable List of Certificate representing the
    #           certificate chain that was sent to the server. If no
    #           certificate chain was sent, null will be returned.
    # @see #getLocalPrincipal()
    def get_local_certificate_chain
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the server's certificate chain, which was established as
    # part of defining the session in the original connection that
    # retrieved the network resource, from cache.  Note: This method
    # can be used only when using certificate-based cipher suites;
    # using it with non-certificate-based cipher suites, such as
    # Kerberos, will throw an SSLPeerUnverifiedException.
    # 
    # @return an immutable List of Certificate representing the server's
    #         certificate chain.
    # @throws SSLPeerUnverifiedException if the peer is not verified.
    # @see #getPeerPrincipal()
    def get_server_certificate_chain
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the server's principal which was established as part of
    # defining the session during the original connection that
    # retrieved the network resource.
    # 
    # @return the server's principal. Returns an X500Principal of the
    # end-entity certiticate for X509-based cipher suites, and
    # KerberosPrincipal for Kerberos cipher suites.
    # 
    # @throws SSLPeerUnverifiedException if the peer was not verified.
    # 
    # @see #getServerCertificateChain()
    # @see #getLocalPrincipal()
    def get_peer_principal
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the principal that was sent to the server during
    # handshaking in the original connection that retrieved the
    # network resource.
    # 
    # @return the principal sent to the server. Returns an X500Principal
    # of the end-entity certificate for X509-based cipher suites, and
    # KerberosPrincipal for Kerberos cipher suites. If no principal was
    # sent, then null is returned.
    # 
    # @see #getLocalCertificateChain()
    # @see #getPeerPrincipal()
    def get_local_principal
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__secure_cache_response, :initialize
  end
  
end
