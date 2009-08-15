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
module Sun::Security::Ssl
  module KerberosClientKeyExchangeImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :AccessControlContext
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Java::Security, :SecureRandom
      include_const ::Java::Net, :InetAddress
      include_const ::Javax::Net::Ssl, :SSLException
      include_const ::Javax::Security::Auth::Kerberos, :KerberosTicket
      include_const ::Javax::Security::Auth::Kerberos, :KerberosKey
      include_const ::Javax::Security::Auth::Kerberos, :KerberosPrincipal
      include_const ::Javax::Security::Auth::Kerberos, :ServicePermission
      include_const ::Sun::Security::Jgss, :GSSUtil
      include_const ::Sun::Security::Krb5, :Config
      include_const ::Sun::Security::Krb5, :EncryptionKey
      include_const ::Sun::Security::Krb5, :EncryptedData
      include_const ::Sun::Security::Krb5, :PrincipalName
      include_const ::Sun::Security::Krb5, :Realm
      include_const ::Sun::Security::Krb5, :KrbException
      include_const ::Sun::Security::Krb5::Internal, :Ticket
      include_const ::Sun::Security::Krb5::Internal, :EncTicketPart
      include_const ::Sun::Security::Krb5::Internal::Crypto, :KeyUsage
      include_const ::Sun::Security::Jgss::Krb5, :Krb5Util
    }
  end
  
  # This is Kerberos option in the client key exchange message
  # (CLIENT -> SERVER). It holds the Kerberos ticket and the encrypted
  # premaster secret encrypted with the session key sealed in the ticket.
  # From RFC 2712:
  # struct
  # {
  # opaque Ticket;
  # opaque authenticator;            // optional
  # opaque EncryptedPreMasterSecret; // encrypted with the session key
  # // which is sealed in the ticket
  # } KerberosWrapper;
  # 
  # 
  # Ticket and authenticator are encrypted as per RFC 1510 (in ASN.1)
  # Encrypted pre-master secret has the same structure as it does for RSA
  # except for Kerberos, the encryption key is the session key instead of
  # the RSA public key.
  # 
  # XXX authenticator currently ignored
  class KerberosClientKeyExchange < KerberosClientKeyExchangeImports.const_get :HandshakeMessage
    include_class_members KerberosClientKeyExchangeImports
    
    attr_accessor :pre_master
    alias_method :attr_pre_master, :pre_master
    undef_method :pre_master
    alias_method :attr_pre_master=, :pre_master=
    undef_method :pre_master=
    
    attr_accessor :encoded_ticket
    alias_method :attr_encoded_ticket, :encoded_ticket
    undef_method :encoded_ticket
    alias_method :attr_encoded_ticket=, :encoded_ticket=
    undef_method :encoded_ticket=
    
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
    
    typesig { [String, ::Java::Boolean, AccessControlContext, ProtocolVersion, SecureRandom] }
    # Creates an instance of KerberosClientKeyExchange consisting of the
    # Kerberos service ticket, authenticator and encrypted premaster secret.
    # Called by client handshaker.
    # 
    # @param serverName name of server with which to do handshake;
    # this is used to get the Kerberos service ticket
    # @param protocolVersion Maximum version supported by client (i.e,
    # version it requested in client hello)
    # @param rand random number generator to use for generating pre-master
    # secret
    def initialize(server_name, is_loopback, acc, protocol_version, rand)
      @pre_master = nil
      @encoded_ticket = nil
      @peer_principal = nil
      @local_principal = nil
      super()
      # Get service ticket
      ticket = get_service_ticket(server_name, is_loopback, acc)
      @encoded_ticket = ticket.get_encoded
      # Record the Kerberos principals
      @peer_principal = ticket.get_server
      @local_principal = ticket.get_client
      # Optional authenticator, encrypted using session key,
      # currently ignored
      # Generate premaster secret and encrypt it using session key
      session_key = EncryptionKey.new(ticket.get_session_key_type, ticket.get_session_key.get_encoded)
      @pre_master = KerberosPreMasterSecret.new(protocol_version, rand, session_key)
    end
    
    typesig { [ProtocolVersion, ProtocolVersion, SecureRandom, HandshakeInStream, Array.typed(KerberosKey)] }
    # Creates an instance of KerberosClientKeyExchange from its ASN.1 encoding.
    # Used by ServerHandshaker to verify and obtain premaster secret.
    # 
    # @param protocolVersion current protocol version
    # @param clientVersion version requested by client in its ClientHello;
    # used by premaster secret version check
    # @param rand random number generator used for generating random
    # premaster secret if ticket and/or premaster verification fails
    # @param input inputstream from which to get ASN.1-encoded KerberosWrapper
    # @param serverKey server's master secret key
    def initialize(protocol_version, client_version, rand, input, server_keys)
      @pre_master = nil
      @encoded_ticket = nil
      @peer_principal = nil
      @local_principal = nil
      super()
      # Read ticket
      @encoded_ticket = input.get_bytes16
      if (!(self.attr_debug).nil? && Debug.is_on("verbose"))
        Debug.println(System.out, "encoded Kerberos service ticket", @encoded_ticket)
      end
      session_key = nil
      begin
        t = Ticket.new(@encoded_ticket)
        enc_part = t.attr_enc_part
        ticket_sname = t.attr_sname
        ticket_realm = t.attr_realm
        server_principal = server_keys[0].get_principal.get_name
        # permission to access and use the secret key of the Kerberized
        # "host" service is done in ServerHandshaker.getKerberosKeys()
        # to ensure server has the permission to use the secret key
        # before promising the client
        # 
        # Check that ticket Sname matches serverPrincipal
        ticket_princ = ticket_sname.to_s.concat("@" + RJava.cast_to_string(ticket_realm.to_s))
        if (!(ticket_princ == server_principal))
          if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
            System.out.println("Service principal in Ticket does not" + " match associated principal in KerberosKey")
          end
          raise IOException.new("Server principal is " + server_principal + " but ticket is for " + ticket_princ)
        end
        # See if we have the right key to decrypt the ticket to get
        # the session key.
        enc_part_key_type = enc_part.get_etype
        dkey = find_key(enc_part_key_type, server_keys)
        if ((dkey).nil?)
          # %%% Should print string repr of etype
          raise IOException.new("Cannot find key of appropriate type to decrypt ticket - need etype " + RJava.cast_to_string(enc_part_key_type))
        end
        secret_key = EncryptionKey.new(enc_part_key_type, dkey.get_encoded)
        # Decrypt encPart using server's secret key
        bytes = enc_part.decrypt(secret_key, KeyUsage::KU_TICKET)
        # Reset data stream after decryption, remove redundant bytes
        temp = enc_part.reset(bytes, true)
        enc_ticket_part = EncTicketPart.new(temp)
        # Record the Kerberos Principals
        @peer_principal = KerberosPrincipal.new(enc_ticket_part.attr_cname.get_name)
        @local_principal = KerberosPrincipal.new(ticket_sname.get_name)
        session_key = enc_ticket_part.attr_key
        if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
          System.out.println("server principal: " + server_principal)
          System.out.println("realm: " + RJava.cast_to_string(enc_ticket_part.attr_crealm.to_s))
          System.out.println("cname: " + RJava.cast_to_string(enc_ticket_part.attr_cname.to_s))
        end
      rescue IOException => e
        raise e
      rescue JavaException => e
        if (!(self.attr_debug).nil? && Debug.is_on("handshake"))
          System.out.println("KerberosWrapper error getting session key," + " generating random secret (" + RJava.cast_to_string(e.get_message) + ")")
        end
        session_key = nil
      end
      input.get_bytes16 # XXX Read and ignore authenticator
      if (!(session_key).nil?)
        @pre_master = KerberosPreMasterSecret.new(protocol_version, client_version, rand, input, session_key)
      else
        # Generate bogus premaster secret
        @pre_master = KerberosPreMasterSecret.new(protocol_version, rand)
      end
    end
    
    typesig { [] }
    def message_type
      return self.attr_ht_client_key_exchange
    end
    
    typesig { [] }
    def message_length
      return (6 + @encoded_ticket.attr_length + @pre_master.get_encrypted.attr_length)
    end
    
    typesig { [HandshakeOutStream] }
    def send(s)
      s.put_bytes16(@encoded_ticket)
      s.put_bytes16(nil) # XXX no authenticator
      s.put_bytes16(@pre_master.get_encrypted)
    end
    
    typesig { [PrintStream] }
    def print(s)
      s.println("*** ClientKeyExchange, Kerberos")
      if (!(self.attr_debug).nil? && Debug.is_on("verbose"))
        Debug.println(s, "Kerberos service ticket", @encoded_ticket)
        Debug.println(s, "Random Secret", @pre_master.get_unencrypted)
        Debug.println(s, "Encrypted random Secret", @pre_master.get_encrypted)
      end
    end
    
    class_module.module_eval {
      typesig { [String, ::Java::Boolean, AccessControlContext] }
      # Similar to sun.security.jgss.krb5.Krb5InitCredenetial/Krb5Context
      def get_service_ticket(srv_name, is_loopback, acc)
        # get the local hostname if srvName is loopback address
        server_name = srv_name
        if (is_loopback)
          local_host = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members KerberosClientKeyExchange
            include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              hostname = nil
              begin
                hostname = RJava.cast_to_string(InetAddress.get_local_host.get_host_name)
              rescue Java::Net::UnknownHostException => e
                hostname = "localhost"
              end
              return hostname
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          server_name = local_host
        end
        # Resolve serverName (possibly in IP addr form) to Kerberos principal
        # name for service with hostname
        service_name = "host/" + server_name
        principal = nil
        begin
          principal = PrincipalName.new(service_name, PrincipalName::KRB_NT_SRV_HST)
        rescue SecurityException => se
          raise se
        rescue JavaException => e
          ioe = IOException.new("Invalid service principal" + " name: " + service_name)
          ioe.init_cause(e)
          raise ioe
        end
        realm = principal.get_realm_as_string
        server_principal = principal.to_s
        tgs_principal = "krbtgt/" + realm + "@" + realm
        client_principal = nil # use default
        # check permission to obtain a service ticket to initiate a
        # context with the "host" service
        sm = System.get_security_manager
        if (!(sm).nil?)
          sm.check_permission(ServicePermission.new(server_principal, "initiate"), acc)
        end
        begin
          ticket = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
            extend LocalClass
            include_class_members KerberosClientKeyExchange
            include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
            
            typesig { [] }
            define_method :run do
              return Krb5Util.get_ticket_from_subject_and_tgs(GSSUtil::CALLER_SSL_CLIENT, client_principal, server_principal, tgs_principal, acc)
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          if ((ticket).nil?)
            raise IOException.new("Failed to find any kerberos service" + " ticket for " + server_principal)
          end
          return ticket
        rescue PrivilegedActionException => e
          ioe = IOException.new("Attempt to obtain kerberos service ticket for " + server_principal + " failed!")
          ioe.init_cause(e)
          raise ioe
        end
      end
    }
    
    typesig { [] }
    def get_pre_master_secret
      return @pre_master
    end
    
    typesig { [] }
    def get_peer_principal
      return @peer_principal
    end
    
    typesig { [] }
    def get_local_principal
      return @local_principal
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, Array.typed(KerberosKey)] }
      def find_key(etype, keys)
        ktype = 0
        i = 0
        while i < keys.attr_length
          ktype = keys[i].get_key_type
          if ((etype).equal?(ktype))
            return keys[i]
          end
          i += 1
        end
        # Key not found.
        # %%% kludge to allow DES keys to be used for diff etypes
        if (((etype).equal?(EncryptedData::ETYPE_DES_CBC_CRC) || (etype).equal?(EncryptedData::ETYPE_DES_CBC_MD5)))
          i_ = 0
          while i_ < keys.attr_length
            ktype = keys[i_].get_key_type
            if ((ktype).equal?(EncryptedData::ETYPE_DES_CBC_CRC) || (ktype).equal?(EncryptedData::ETYPE_DES_CBC_MD5))
              return KerberosKey.new(keys[i_].get_principal, keys[i_].get_encoded, etype, keys[i_].get_version_number)
            end
            i_ += 1
          end
        end
        return nil
      end
    }
    
    private
    alias_method :initialize__kerberos_client_key_exchange, :initialize
  end
  
end
