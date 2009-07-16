require "rjava"

# 
# Copyright 1996-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SSLSessionImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include ::Java::Net
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :Vector
      include_const ::Java::Security, :Principal
      include_const ::Java::Security, :PrivateKey
      include_const ::Java::Security, :SecureRandom
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :CertificateEncodingException
      include_const ::Javax::Crypto, :SecretKey
      include_const ::Javax::Net::Ssl, :SSLSession
      include_const ::Javax::Net::Ssl, :SSLSessionContext
      include_const ::Javax::Net::Ssl, :SSLSessionBindingListener
      include_const ::Javax::Net::Ssl, :SSLSessionBindingEvent
      include_const ::Javax::Net::Ssl, :SSLPeerUnverifiedException
      include_const ::Javax::Net::Ssl, :SSLSession
      include_const ::Javax::Net::Ssl, :SSLPermission
      include_const ::Javax::Security::Auth::Kerberos, :KerberosPrincipal
      include_const ::Javax::Security::Auth::X500, :X500Principal
    }
  end
  
  # 
  # Implements the SSL session interface, and exposes the session context
  # which is maintained by SSL servers.
  # 
  # <P> Servers have the ability to manage the sessions associated with
  # their authentication context(s).  They can do this by enumerating the
  # IDs of the sessions which are cached, examining those sessions, and then
  # perhaps invalidating a given session so that it can't be used again.
  # If servers do not explicitly manage the cache, sessions will linger
  # until memory is low enough that the runtime environment purges cache
  # entries automatically to reclaim space.
  # 
  # <P><em> The only reason this class is not package-private is that
  # there's no other public way to get at the server session context which
  # is associated with any given authentication context. </em>
  # 
  # @author David Brownell
  class SSLSessionImpl 
    include_class_members SSLSessionImplImports
    include SSLSession
    
    class_module.module_eval {
      # 
      # we only really need a single null session
      const_set_lazy(:NullSession) { SSLSessionImpl.new }
      const_attr_reader  :NullSession
      
      # compression methods
      const_set_lazy(:Compression_null) { 0 }
      const_attr_reader  :Compression_null
    }
    
    # 
    # The state of a single session, as described in section 7.1
    # of the SSLv3 spec.
    attr_accessor :protocol_version
    alias_method :attr_protocol_version, :protocol_version
    undef_method :protocol_version
    alias_method :attr_protocol_version=, :protocol_version=
    undef_method :protocol_version=
    
    attr_accessor :session_id
    alias_method :attr_session_id, :session_id
    undef_method :session_id
    alias_method :attr_session_id=, :session_id=
    undef_method :session_id=
    
    attr_accessor :peer_certs
    alias_method :attr_peer_certs, :peer_certs
    undef_method :peer_certs
    alias_method :attr_peer_certs=, :peer_certs=
    undef_method :peer_certs=
    
    attr_accessor :compression_method
    alias_method :attr_compression_method, :compression_method
    undef_method :compression_method
    alias_method :attr_compression_method=, :compression_method=
    undef_method :compression_method=
    
    attr_accessor :cipher_suite
    alias_method :attr_cipher_suite, :cipher_suite
    undef_method :cipher_suite
    alias_method :attr_cipher_suite=, :cipher_suite=
    undef_method :cipher_suite=
    
    attr_accessor :master_secret
    alias_method :attr_master_secret, :master_secret
    undef_method :master_secret
    alias_method :attr_master_secret=, :master_secret=
    undef_method :master_secret=
    
    # 
    # Information not part of the SSLv3 protocol spec, but used
    # to support session management policies.
    attr_accessor :creation_time
    alias_method :attr_creation_time, :creation_time
    undef_method :creation_time
    alias_method :attr_creation_time=, :creation_time=
    undef_method :creation_time=
    
    attr_accessor :last_used_time
    alias_method :attr_last_used_time, :last_used_time
    undef_method :last_used_time
    alias_method :attr_last_used_time=, :last_used_time=
    undef_method :last_used_time=
    
    attr_accessor :host
    alias_method :attr_host, :host
    undef_method :host
    alias_method :attr_host=, :host=
    undef_method :host=
    
    attr_accessor :port
    alias_method :attr_port, :port
    undef_method :port
    alias_method :attr_port=, :port=
    undef_method :port=
    
    attr_accessor :context
    alias_method :attr_context, :context
    undef_method :context
    alias_method :attr_context=, :context=
    undef_method :context=
    
    attr_accessor :session_count
    alias_method :attr_session_count, :session_count
    undef_method :session_count
    alias_method :attr_session_count=, :session_count=
    undef_method :session_count=
    
    attr_accessor :invalidated
    alias_method :attr_invalidated, :invalidated
    undef_method :invalidated
    alias_method :attr_invalidated=, :invalidated=
    undef_method :invalidated=
    
    attr_accessor :local_certs
    alias_method :attr_local_certs, :local_certs
    undef_method :local_certs
    alias_method :attr_local_certs=, :local_certs=
    undef_method :local_certs=
    
    attr_accessor :local_private_key
    alias_method :attr_local_private_key, :local_private_key
    undef_method :local_private_key
    alias_method :attr_local_private_key=, :local_private_key=
    undef_method :local_private_key=
    
    # Principals for non-certificate based cipher suites
    attr_accessor :peer_principal
    alias_method :attr_peer_principal, :peer_principal
    undef_method :peer_principal
    alias_method :attr_peer_principal=, :peer_principal=
    undef_method :peer_principal=
    
    attr_accessor :local_principal
    alias_method :attr_local_principal, :local_principal
    undef_method :local_principal
    alias_method :attr_local_principal=, :local_principal=
    undef_method :local_principal=
    
    class_module.module_eval {
      # 
      # We count session creations, eventually for statistical data but
      # also since counters make shorter debugging IDs than the big ones
      # we use in the protocol for uniqueness-over-time.
      
      def counter
        defined?(@@counter) ? @@counter : @@counter= 0
      end
      alias_method :attr_counter, :counter
      
      def counter=(value)
        @@counter = value
      end
      alias_method :attr_counter=, :counter=
      
      # 
      # Use of session caches is globally enabled/disabled.
      
      def default_rejoinable
        defined?(@@default_rejoinable) ? @@default_rejoinable : @@default_rejoinable= true
      end
      alias_method :attr_default_rejoinable, :default_rejoinable
      
      def default_rejoinable=(value)
        @@default_rejoinable = value
      end
      alias_method :attr_default_rejoinable=, :default_rejoinable=
      
      # Class and subclass dynamic debugging support
      const_set_lazy(:Debug) { Debug.get_instance("ssl") }
      const_attr_reader  :Debug
    }
    
    typesig { [] }
    # 
    # Create a new non-rejoinable session, using the default (null)
    # cipher spec.  This constructor returns a session which could
    # be used either by a client or by a server, as a connection is
    # first opened and before handshaking begins.
    def initialize
      initialize__sslsession_impl(ProtocolVersion::NONE, CipherSuite::C_NULL, SessionId.new(false, nil), nil, -1)
    end
    
    typesig { [ProtocolVersion, CipherSuite, SecureRandom, String, ::Java::Int] }
    # 
    # Create a new session, using a given cipher spec.  This will
    # be rejoinable if session caching is enabled; the constructor
    # is intended mostly for use by serves.
    def initialize(protocol_version, cipher_suite, generator, host, port)
      initialize__sslsession_impl(protocol_version, cipher_suite, SessionId.new(self.attr_default_rejoinable, generator), host, port)
    end
    
    typesig { [ProtocolVersion, CipherSuite, SessionId, String, ::Java::Int] }
    # 
    # Record a new session, using a given cipher spec and session ID.
    def initialize(protocol_version, cipher_suite, id, host, port)
      @protocol_version = nil
      @session_id = nil
      @peer_certs = nil
      @compression_method = 0
      @cipher_suite = nil
      @master_secret = nil
      @creation_time = System.current_time_millis
      @last_used_time = 0
      @host = nil
      @port = 0
      @context = nil
      @session_count = 0
      @invalidated = false
      @local_certs = nil
      @local_private_key = nil
      @peer_principal = nil
      @local_principal = nil
      @table = Hashtable.new
      @accept_large_fragments = Debug.get_boolean_property("jsse.SSLEngine.acceptLargeFragments", false)
      @protocol_version = protocol_version
      @session_id = id
      @peer_certs = nil
      @compression_method = Compression_null
      @cipher_suite = cipher_suite
      @master_secret = nil
      @host = host
      @port = port
      @session_count = (self.attr_counter += 1)
      if (!(Debug).nil? && Debug.is_on("session"))
        System.out.println("%% Created:  " + (self).to_s)
      end
    end
    
    typesig { [SecretKey] }
    def set_master_secret(secret)
      if ((@master_secret).nil?)
        @master_secret = secret
      else
        raise RuntimeException.new("setMasterSecret() error")
      end
    end
    
    typesig { [] }
    # 
    # Returns the master secret ... treat with extreme caution!
    def get_master_secret
      return @master_secret
    end
    
    typesig { [Array.typed(X509Certificate)] }
    def set_peer_certificates(peer)
      if ((@peer_certs).nil?)
        @peer_certs = peer
      end
    end
    
    typesig { [Array.typed(X509Certificate)] }
    def set_local_certificates(local)
      @local_certs = local
    end
    
    typesig { [PrivateKey] }
    def set_local_private_key(private_key)
      @local_private_key = private_key
    end
    
    typesig { [Principal] }
    # 
    # Set the peer principal.
    def set_peer_principal(principal)
      if ((@peer_principal).nil?)
        @peer_principal = principal
      end
    end
    
    typesig { [Principal] }
    # 
    # Set the local principal.
    def set_local_principal(principal)
      @local_principal = principal
    end
    
    typesig { [] }
    # 
    # Returns true iff this session may be resumed ... sessions are
    # usually resumable.  Security policies may suggest otherwise,
    # for example sessions that haven't been used for a while (say,
    # a working day) won't be resumable, and sessions might have a
    # maximum lifetime in any case.
    def is_rejoinable
      return !(@session_id).nil? && !(@session_id.length).equal?(0) && !@invalidated && is_local_authentication_valid
    end
    
    typesig { [] }
    def is_valid
      synchronized(self) do
        return is_rejoinable
      end
    end
    
    typesig { [] }
    # 
    # Check if the authentication used when establishing this session
    # is still valid. Returns true if no authentication was used
    def is_local_authentication_valid
      if (!(@local_private_key).nil?)
        begin
          # if the private key is no longer valid, getAlgorithm()
          # should throw an exception
          # (e.g. Smartcard has been removed from the reader)
          @local_private_key.get_algorithm
        rescue Exception => e
          invalidate
          return false
        end
      end
      return true
    end
    
    typesig { [] }
    # 
    # Returns the ID for this session.  The ID is fixed for the
    # duration of the session; neither it, nor its value, changes.
    def get_id
      return @session_id.get_id
    end
    
    typesig { [] }
    # 
    # For server sessions, this returns the set of sessions which
    # are currently valid in this process.  For client sessions,
    # this returns null.
    def get_session_context
      # 
      # An interim security policy until we can do something
      # more specific in 1.2. Only allow trusted code (code which
      # can set system properties) to get an
      # SSLSessionContext. This is to limit the ability of code to
      # look up specific sessions or enumerate over them. Otherwise,
      # code can only get session objects from successful SSL
      # connections which implies that they must have had permission
      # to make the network connection in the first place.
      sm = nil
      if (!((sm = System.get_security_manager)).nil?)
        sm.check_permission(SSLPermission.new("getSSLSessionContext"))
      end
      return @context
    end
    
    typesig { [] }
    def get_session_id
      return @session_id
    end
    
    typesig { [] }
    # 
    # Returns the cipher spec in use on this session
    def get_suite
      return @cipher_suite
    end
    
    typesig { [] }
    # 
    # Returns the name of the cipher suite in use on this session
    def get_cipher_suite
      return get_suite.attr_name
    end
    
    typesig { [] }
    def get_protocol_version
      return @protocol_version
    end
    
    typesig { [] }
    # 
    # Returns the standard name of the protocol in use on this session
    def get_protocol
      return get_protocol_version.attr_name
    end
    
    typesig { [] }
    # 
    # Returns the compression technique used in this session
    def get_compression
      return @compression_method
    end
    
    typesig { [] }
    # 
    # Returns the hashcode for this session
    def hash_code
      return @session_id.hash_code
    end
    
    typesig { [Object] }
    # 
    # Returns true if sessions have same ids, false otherwise.
    def equals(obj)
      if ((obj).equal?(self))
        return true
      end
      if (obj.is_a?(SSLSessionImpl))
        sess = obj
        return (!(@session_id).nil?) && ((@session_id == sess.get_session_id))
      end
      return false
    end
    
    typesig { [] }
    # 
    # Return the cert chain presented by the peer in the
    # java.security.cert format.
    # Note: This method can be used only when using certificate-based
    # cipher suites; using it with non-certificate-based cipher suites,
    # such as Kerberos, will throw an SSLPeerUnverifiedException.
    # 
    # @return array of peer X.509 certs, with the peer's own cert
    # first in the chain, and with the "root" CA last.
    def get_peer_certificates
      # 
      # clone to preserve integrity of session ... caller can't
      # change record of peer identity even by accident, much
      # less do it intentionally.
      if (((@cipher_suite.attr_key_exchange).equal?(K_KRB5)) || ((@cipher_suite.attr_key_exchange).equal?(K_KRB5_EXPORT)))
        raise SSLPeerUnverifiedException.new("no certificates expected" + " for Kerberos cipher suites")
      end
      if ((@peer_certs).nil?)
        raise SSLPeerUnverifiedException.new("peer not authenticated")
      end
      # Certs are immutable objects, therefore we don't clone them.
      # But do need to clone the array, so that nothing is inserted
      # into peerCerts.
      return @peer_certs.clone
    end
    
    typesig { [] }
    # 
    # Return the cert chain presented to the peer in the
    # java.security.cert format.
    # Note: This method is useful only when using certificate-based
    # cipher suites.
    # 
    # @return array of peer X.509 certs, with the peer's own cert
    # first in the chain, and with the "root" CA last.
    def get_local_certificates
      # 
      # clone to preserve integrity of session ... caller can't
      # change record of peer identity even by accident, much
      # less do it intentionally.
      return ((@local_certs).nil? ? nil : @local_certs.clone)
    end
    
    typesig { [] }
    # 
    # Return the cert chain presented by the peer in the
    # javax.security.cert format.
    # Note: This method can be used only when using certificate-based
    # cipher suites; using it with non-certificate-based cipher suites,
    # such as Kerberos, will throw an SSLPeerUnverifiedException.
    # 
    # @return array of peer X.509 certs, with the peer's own cert
    # first in the chain, and with the "root" CA last.
    def get_peer_certificate_chain
      # 
      # clone to preserve integrity of session ... caller can't
      # change record of peer identity even by accident, much
      # less do it intentionally.
      if (((@cipher_suite.attr_key_exchange).equal?(K_KRB5)) || ((@cipher_suite.attr_key_exchange).equal?(K_KRB5_EXPORT)))
        raise SSLPeerUnverifiedException.new("no certificates expected" + " for Kerberos cipher suites")
      end
      if ((@peer_certs).nil?)
        raise SSLPeerUnverifiedException.new("peer not authenticated")
      end
      certs = nil
      certs = Array.typed(Javax::Security::Cert::X509Certificate).new(@peer_certs.attr_length) { nil }
      i = 0
      while i < @peer_certs.attr_length
        der = nil
        begin
          der = @peer_certs[i].get_encoded
          certs[i] = Javax::Security::Cert::X509Certificate.get_instance(der)
        rescue CertificateEncodingException => e
          raise SSLPeerUnverifiedException.new(e.get_message)
        rescue Javax::Security::Cert::CertificateException => e
          raise SSLPeerUnverifiedException.new(e_.get_message)
        end
        ((i += 1) - 1)
      end
      return certs
    end
    
    typesig { [] }
    # 
    # Return the cert chain presented by the peer.
    # Note: This method can be used only when using certificate-based
    # cipher suites; using it with non-certificate-based cipher suites,
    # such as Kerberos, will throw an SSLPeerUnverifiedException.
    # 
    # @return array of peer X.509 certs, with the peer's own cert
    # first in the chain, and with the "root" CA last.
    def get_certificate_chain
      # 
      # clone to preserve integrity of session ... caller can't
      # change record of peer identity even by accident, much
      # less do it intentionally.
      if (((@cipher_suite.attr_key_exchange).equal?(K_KRB5)) || ((@cipher_suite.attr_key_exchange).equal?(K_KRB5_EXPORT)))
        raise SSLPeerUnverifiedException.new("no certificates expected" + " for Kerberos cipher suites")
      end
      if (!(@peer_certs).nil?)
        return @peer_certs.clone
      else
        raise SSLPeerUnverifiedException.new("peer not authenticated")
      end
    end
    
    typesig { [] }
    # 
    # Returns the identity of the peer which was established as part of
    # defining the session.
    # 
    # @return the peer's principal. Returns an X500Principal of the
    # end-entity certiticate for X509-based cipher suites, and
    # KerberosPrincipal for Kerberos cipher suites.
    # 
    # @throws SSLPeerUnverifiedException if the peer's identity has not
    # been verified
    def get_peer_principal
      if (((@cipher_suite.attr_key_exchange).equal?(K_KRB5)) || ((@cipher_suite.attr_key_exchange).equal?(K_KRB5_EXPORT)))
        if ((@peer_principal).nil?)
          raise SSLPeerUnverifiedException.new("peer not authenticated")
        else
          return @peer_principal
        end
      end
      if ((@peer_certs).nil?)
        raise SSLPeerUnverifiedException.new("peer not authenticated")
      end
      return (@peer_certs[0].get_subject_x500principal)
    end
    
    typesig { [] }
    # 
    # Returns the principal that was sent to the peer during handshaking.
    # 
    # @return the principal sent to the peer. Returns an X500Principal
    # of the end-entity certificate for X509-based cipher suites, and
    # KerberosPrincipal for Kerberos cipher suites. If no principal was
    # sent, then null is returned.
    def get_local_principal
      if (((@cipher_suite.attr_key_exchange).equal?(K_KRB5)) || ((@cipher_suite.attr_key_exchange).equal?(K_KRB5_EXPORT)))
        return ((@local_principal).nil? ? nil : @local_principal)
      end
      return ((@local_certs).nil? ? nil : @local_certs[0].get_subject_x500principal)
    end
    
    typesig { [] }
    # 
    # Returns the time this session was created.
    def get_creation_time
      return @creation_time
    end
    
    typesig { [] }
    # 
    # Returns the last time this session was used to initialize
    # a connection.
    def get_last_accessed_time
      return (!(@last_used_time).equal?(0)) ? @last_used_time : @creation_time
    end
    
    typesig { [::Java::Long] }
    def set_last_accessed_time(time)
      @last_used_time = time
    end
    
    typesig { [] }
    # 
    # Returns the network address of the session's peer.  This
    # implementation does not insist that connections between
    # different ports on the same host must necessarily belong
    # to different sessions, though that is of course allowed.
    def get_peer_address
      begin
        return InetAddress.get_by_name(@host)
      rescue Java::Net::UnknownHostException => e
        return nil
      end
    end
    
    typesig { [] }
    def get_peer_host
      return @host
    end
    
    typesig { [] }
    # 
    # Need to provide the port info for caching sessions based on
    # host and port. Accessed by SSLSessionContextImpl
    def get_peer_port
      return @port
    end
    
    typesig { [SSLSessionContextImpl] }
    def set_context(ctx)
      if ((@context).nil?)
        @context = ctx
      end
    end
    
    typesig { [] }
    # 
    # Invalidate a session.  Active connections may still exist, but
    # no connections will be able to rejoin this session.
    def invalidate
      synchronized(self) do
        # 
        # Can't invalidate the NULL session -- this would be
        # attempted when we get a handshaking error on a brand
        # new connection, with no "real" session yet.
        if ((self).equal?(NullSession))
          return
        end
        @invalidated = true
        if (!(Debug).nil? && Debug.is_on("session"))
          System.out.println("%% Invalidated:  " + (self).to_s)
        end
        if (!(@context).nil?)
          @context.remove(@session_id)
          @context = nil
        end
      end
    end
    
    # 
    # Table of application-specific session data indexed by an application
    # key and the calling security context. This is important since
    # sessions can be shared across different protection domains.
    attr_accessor :table
    alias_method :attr_table, :table
    undef_method :table
    alias_method :attr_table=, :table=
    undef_method :table=
    
    typesig { [String, Object] }
    # 
    # Assigns a session value.  Session change events are given if
    # appropriate, to any original value as well as the new value.
    def put_value(key, value)
      if (((key).nil?) || ((value).nil?))
        raise IllegalArgumentException.new("arguments can not be null")
      end
      secure_key = SecureKey.new(key)
      old_value = @table.put(secure_key, value)
      if (old_value.is_a?(SSLSessionBindingListener))
        e = nil
        e = SSLSessionBindingEvent.new(self, key)
        (old_value).value_unbound(e)
      end
      if (value.is_a?(SSLSessionBindingListener))
        e_ = nil
        e_ = SSLSessionBindingEvent.new(self, key)
        (value).value_bound(e_)
      end
    end
    
    typesig { [String] }
    # 
    # Returns the specified session value.
    def get_value(key)
      if ((key).nil?)
        raise IllegalArgumentException.new("argument can not be null")
      end
      secure_key = SecureKey.new(key)
      return @table.get(secure_key)
    end
    
    typesig { [String] }
    # 
    # Removes the specified session value, delivering a session changed
    # event as appropriate.
    def remove_value(key)
      if ((key).nil?)
        raise IllegalArgumentException.new("argument can not be null")
      end
      secure_key = SecureKey.new(key)
      value = @table.remove(secure_key)
      if (value.is_a?(SSLSessionBindingListener))
        e = nil
        e = SSLSessionBindingEvent.new(self, key)
        (value).value_unbound(e)
      end
    end
    
    typesig { [] }
    # 
    # Lists the names of the session values.
    def get_value_names
      e = nil
      v = Vector.new
      key = nil
      security_ctx = SecureKey.get_current_security_context
      e = @table.keys
      while e.has_more_elements
        key = e.next_element
        if ((security_ctx == key.get_security_context))
          v.add_element(key.get_app_key)
        end
      end
      names = Array.typed(String).new(v.size) { nil }
      v.copy_into(names)
      return names
    end
    
    # 
    # Use large packet sizes now or follow RFC 2246 packet sizes (2^14)
    # until changed.
    # 
    # In the TLS specification (section 6.2.1, RFC2246), it is not
    # recommended that the plaintext has more than 2^14 bytes.
    # However, some TLS implementations violate the specification.
    # This is a workaround for interoperability with these stacks.
    # 
    # Application could accept large fragments up to 2^15 bytes by
    # setting the system property jsse.SSLEngine.acceptLargeFragments
    # to "true".
    attr_accessor :accept_large_fragments
    alias_method :attr_accept_large_fragments, :accept_large_fragments
    undef_method :accept_large_fragments
    alias_method :attr_accept_large_fragments=, :accept_large_fragments=
    undef_method :accept_large_fragments=
    
    typesig { [] }
    # 
    # Expand the buffer size of both SSL/TLS network packet and
    # application data.
    def expand_buffer_sizes
      synchronized(self) do
        @accept_large_fragments = true
      end
    end
    
    typesig { [] }
    # 
    # Gets the current size of the largest SSL/TLS packet that is expected
    # when using this session.
    def get_packet_buffer_size
      synchronized(self) do
        return @accept_large_fragments ? Record.attr_max_large_record_size : Record.attr_max_record_size
      end
    end
    
    typesig { [] }
    # 
    # Gets the current size of the largest application data that is
    # expected when using this session.
    def get_application_buffer_size
      synchronized(self) do
        return get_packet_buffer_size - Record.attr_header_size
      end
    end
    
    typesig { [] }
    # Returns a string representation of this SSL session
    def to_s
      return "[Session-" + (@session_count).to_s + ", " + (get_cipher_suite).to_s + "]"
    end
    
    typesig { [] }
    # 
    # When SSL sessions are finalized, all values bound to
    # them are removed.
    def finalize
      names = get_value_names
      i = 0
      while i < names.attr_length
        remove_value(names[i])
        ((i += 1) - 1)
      end
    end
    
    private
    alias_method :initialize__sslsession_impl, :initialize
  end
  
  # 
  # This "struct" class serves as a Hash Key that combines an
  # application-specific key and a security context.
  class SecureKey 
    include_class_members SSLSessionImplImports
    
    class_module.module_eval {
      
      def null_object
        defined?(@@null_object) ? @@null_object : @@null_object= Object.new
      end
      alias_method :attr_null_object, :null_object
      
      def null_object=(value)
        @@null_object = value
      end
      alias_method :attr_null_object=, :null_object=
    }
    
    attr_accessor :app_key
    alias_method :attr_app_key, :app_key
    undef_method :app_key
    alias_method :attr_app_key=, :app_key=
    undef_method :app_key=
    
    attr_accessor :security_ctx
    alias_method :attr_security_ctx, :security_ctx
    undef_method :security_ctx
    alias_method :attr_security_ctx=, :security_ctx=
    undef_method :security_ctx=
    
    class_module.module_eval {
      typesig { [] }
      def get_current_security_context
        sm = System.get_security_manager
        context = nil
        if (!(sm).nil?)
          context = sm.get_security_context
        end
        if ((context).nil?)
          context = self.attr_null_object
        end
        return context
      end
    }
    
    typesig { [Object] }
    def initialize(key)
      @app_key = nil
      @security_ctx = nil
      @app_key = key
      @security_ctx = get_current_security_context
    end
    
    typesig { [] }
    def get_app_key
      return @app_key
    end
    
    typesig { [] }
    def get_security_context
      return @security_ctx
    end
    
    typesig { [] }
    def hash_code
      return @app_key.hash_code ^ @security_ctx.hash_code
    end
    
    typesig { [Object] }
    def equals(o)
      return o.is_a?(SecureKey) && ((o).attr_app_key == @app_key) && ((o).attr_security_ctx == @security_ctx)
    end
    
    private
    alias_method :initialize__secure_key, :initialize
  end
  
end
