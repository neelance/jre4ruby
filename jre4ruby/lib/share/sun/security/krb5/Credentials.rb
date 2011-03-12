require "rjava"

# Portions Copyright 2000-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5
  module CredentialsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5::Internal::Ccache, :CredentialsCache
      include_const ::Java::Util, :StringTokenizer
      include ::Sun::Security::Krb5::Internal::Ktab
      include_const ::Sun::Security::Krb5::Internal::Crypto, :EType
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :JavaDate
      include_const ::Java::Util, :Vector
      include_const ::Java::Io, :BufferedReader
      include_const ::Java::Io, :InputStreamReader
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Java::Net, :InetAddress
    }
  end
  
  # This class encapsulates the concept of a Kerberos service
  # credential. That includes a Kerberos ticket and an associated
  # session key.
  class Credentials 
    include_class_members CredentialsImports
    
    attr_accessor :ticket
    alias_method :attr_ticket, :ticket
    undef_method :ticket
    alias_method :attr_ticket=, :ticket=
    undef_method :ticket=
    
    attr_accessor :client
    alias_method :attr_client, :client
    undef_method :client
    alias_method :attr_client=, :client=
    undef_method :client=
    
    attr_accessor :server
    alias_method :attr_server, :server
    undef_method :server
    alias_method :attr_server=, :server=
    undef_method :server=
    
    attr_accessor :key
    alias_method :attr_key, :key
    undef_method :key
    alias_method :attr_key=, :key=
    undef_method :key=
    
    attr_accessor :flags
    alias_method :attr_flags, :flags
    undef_method :flags
    alias_method :attr_flags=, :flags=
    undef_method :flags=
    
    attr_accessor :auth_time
    alias_method :attr_auth_time, :auth_time
    undef_method :auth_time
    alias_method :attr_auth_time=, :auth_time=
    undef_method :auth_time=
    
    attr_accessor :start_time
    alias_method :attr_start_time, :start_time
    undef_method :start_time
    alias_method :attr_start_time=, :start_time=
    undef_method :start_time=
    
    attr_accessor :end_time
    alias_method :attr_end_time, :end_time
    undef_method :end_time
    alias_method :attr_end_time=, :end_time=
    undef_method :end_time=
    
    attr_accessor :renew_till
    alias_method :attr_renew_till, :renew_till
    undef_method :renew_till
    alias_method :attr_renew_till=, :renew_till=
    undef_method :renew_till=
    
    attr_accessor :c_addr
    alias_method :attr_c_addr, :c_addr
    undef_method :c_addr
    alias_method :attr_c_addr=, :c_addr=
    undef_method :c_addr=
    
    attr_accessor :service_key
    alias_method :attr_service_key, :service_key
    undef_method :service_key
    alias_method :attr_service_key=, :service_key=
    undef_method :service_key=
    
    class_module.module_eval {
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= Krb5::DEBUG
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      
      def cache
        defined?(@@cache) ? @@cache : @@cache= nil
      end
      alias_method :attr_cache, :cache
      
      def cache=(value)
        @@cache = value
      end
      alias_method :attr_cache=, :cache=
      
      
      def already_loaded
        defined?(@@already_loaded) ? @@already_loaded : @@already_loaded= false
      end
      alias_method :attr_already_loaded, :already_loaded
      
      def already_loaded=(value)
        @@already_loaded = value
      end
      alias_method :attr_already_loaded=, :already_loaded=
      
      
      def already_tried
        defined?(@@already_tried) ? @@already_tried : @@already_tried= false
      end
      alias_method :attr_already_tried, :already_tried
      
      def already_tried=(value)
        @@already_tried = value
      end
      alias_method :attr_already_tried=, :already_tried=
      
      JNI.load_native_method :Java_sun_security_krb5_Credentials_acquireDefaultNativeCreds, [:pointer, :long], :long
      typesig { [] }
      def acquire_default_native_creds
        JNI.call_native_method(:Java_sun_security_krb5_Credentials_acquireDefaultNativeCreds, JNI.env, self.jni_id)
      end
    }
    
    typesig { [Ticket, PrincipalName, PrincipalName, EncryptionKey, TicketFlags, KerberosTime, KerberosTime, KerberosTime, KerberosTime, HostAddresses] }
    def initialize(new_ticket, new_client, new_server, new_key, new_flags, auth_time, new_start_time, new_end_time, renew_till, c_addr)
      @ticket = nil
      @client = nil
      @server = nil
      @key = nil
      @flags = nil
      @auth_time = nil
      @start_time = nil
      @end_time = nil
      @renew_till = nil
      @c_addr = nil
      @service_key = nil
      @ticket = new_ticket
      @client = new_client
      @server = new_server
      @key = new_key
      @flags = new_flags
      @auth_time = auth_time
      @start_time = new_start_time
      @end_time = new_end_time
      @renew_till = renew_till
      @c_addr = c_addr
    end
    
    typesig { [Array.typed(::Java::Byte), String, String, Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Boolean), JavaDate, JavaDate, JavaDate, JavaDate, Array.typed(InetAddress)] }
    def initialize(encoding, client, server, key_bytes, key_type, flags, auth_time, start_time, end_time, renew_till, c_addrs)
      initialize__credentials(Ticket.new(encoding), PrincipalName.new(client, PrincipalName::KRB_NT_PRINCIPAL), PrincipalName.new(server, PrincipalName::KRB_NT_SRV_INST), EncryptionKey.new(key_type, key_bytes), ((flags).nil? ? nil : TicketFlags.new(flags)), ((auth_time).nil? ? nil : KerberosTime.new(auth_time)), ((start_time).nil? ? nil : KerberosTime.new(start_time)), ((end_time).nil? ? nil : KerberosTime.new(end_time)), ((renew_till).nil? ? nil : KerberosTime.new(renew_till)), nil) # caddrs are in the encoding at this point
    end
    
    typesig { [] }
    # Acquires a service ticket for the specified service
    # principal. If the service ticket is not already available, it
    # obtains a new one from the KDC.
    # public Credentials(Credentials tgt, PrincipalName service)
    #     throws KrbException {
    # }
    def get_client
      return @client
    end
    
    typesig { [] }
    def get_server
      return @server
    end
    
    typesig { [] }
    def get_session_key
      return @key
    end
    
    typesig { [] }
    def get_auth_time
      if (!(@auth_time).nil?)
        return @auth_time.to_date
      else
        return nil
      end
    end
    
    typesig { [] }
    def get_start_time
      if (!(@start_time).nil?)
        return @start_time.to_date
      end
      return nil
    end
    
    typesig { [] }
    def get_end_time
      if (!(@end_time).nil?)
        return @end_time.to_date
      end
      return nil
    end
    
    typesig { [] }
    def get_renew_till
      if (!(@renew_till).nil?)
        return @renew_till.to_date
      end
      return nil
    end
    
    typesig { [] }
    def get_flags
      if ((@flags).nil?)
        # Can be in a KRB-CRED
        return nil
      end
      return @flags.to_boolean_array
    end
    
    typesig { [] }
    def get_client_addresses
      if ((@c_addr).nil?)
        return nil
      end
      return @c_addr.get_inet_addresses
    end
    
    typesig { [] }
    def get_encoded
      ret_val = nil
      begin
        ret_val = @ticket.asn1_encode
      rescue Asn1Exception => e
        if (self.attr_debug)
          System.out.println(e)
        end
      rescue IOException => ioe
        if (self.attr_debug)
          System.out.println(ioe)
        end
      end
      return ret_val
    end
    
    typesig { [] }
    def is_forwardable
      return @flags.get(Krb5::TKT_OPTS_FORWARDABLE)
    end
    
    typesig { [] }
    def is_renewable
      return @flags.get(Krb5::TKT_OPTS_RENEWABLE)
    end
    
    typesig { [] }
    def get_ticket
      return @ticket
    end
    
    typesig { [] }
    def get_ticket_flags
      return @flags
    end
    
    typesig { [] }
    # Checks if the service ticket returned by the KDC has the OK-AS-DELEGATE
    # flag set
    # @return true if OK-AS_DELEGATE flag is set, otherwise, return false.
    def check_delegate
      return (@flags.get(Krb5::TKT_OPTS_DELEGATE))
    end
    
    typesig { [] }
    def renew
      options = KDCOptions.new
      options.set(KDCOptions::RENEW, true)
      # Added here to pass KrbKdcRep.check:73
      options.set(KDCOptions::RENEWABLE, true)
      return KrbTgsReq.new(options, self, @server, nil, nil, nil, nil, @c_addr, nil, nil, nil).send_and_get_creds
    end
    
    class_module.module_eval {
      typesig { [PrincipalName, String] }
      # Returns a TGT for the given client principal from a ticket cache.
      # 
      # @param princ the client principal. A value of null means that the
      # default principal name in the credentials cache will be used.
      # @param ticketCache the path to the tickets file. A value
      # of null will be accepted to indicate that the default
      # path should be searched
      # @returns the TGT credentials or null if none were found. If the tgt
      # expired, it is the responsibility of the caller to determine this.
      def acquire_tgtfrom_cache(princ, ticket_cache)
        if ((ticket_cache).nil?)
          # The default ticket cache on Windows is not a file.
          os = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("os.name"))
          if (os.to_upper_case.starts_with("WINDOWS"))
            creds = acquire_default_creds
            if ((creds).nil?)
              if (self.attr_debug)
                System.out.println(">>> Found no TGT's in LSA")
              end
              return nil
            end
            if (!(princ).nil?)
              if ((creds.get_client == princ))
                if (self.attr_debug)
                  System.out.println(">>> Obtained TGT from LSA: " + RJava.cast_to_string(creds))
                end
                return creds
              else
                if (self.attr_debug)
                  System.out.println(">>> LSA contains TGT for " + RJava.cast_to_string(creds.get_client) + " not " + RJava.cast_to_string(princ))
                end
                return nil
              end
            else
              if (self.attr_debug)
                System.out.println(">>> Obtained TGT from LSA: " + RJava.cast_to_string(creds))
              end
              return creds
            end
          end
        end
        # Returns the appropriate cache. If ticketCache is null, it is the
        # default cache otherwise it is the cache filename contained in it.
        ccache = CredentialsCache.get_instance(princ, ticket_cache)
        if ((ccache).nil?)
          return nil
        end
        tgt_cred = ccache.get_default_creds
        if (EType.is_supported(tgt_cred.get_etype))
          return tgt_cred.set_krb_creds
        else
          if (self.attr_debug)
            System.out.println(">>> unsupported key type found the default TGT: " + RJava.cast_to_string(tgt_cred.get_etype))
          end
          return nil
        end
      end
      
      typesig { [PrincipalName, Array.typed(EncryptionKey), Array.typed(::Java::Char)] }
      # Returns a TGT for the given client principal via an AS-Exchange.
      # This method causes pre-authentication data to be sent in the
      # AS-REQ.
      # 
      # @param princ the client principal. This value cannot be null.
      # @param secretKey the secret key of the client principal.This value
      # cannot be null.
      # @returns the TGT credentials
      def acquire_tgt(princ, secret_keys, password)
        if ((princ).nil?)
          raise IllegalArgumentException.new("Cannot have null principal to do AS-Exchange")
        end
        if ((secret_keys).nil?)
          raise IllegalArgumentException.new("Cannot have null secretKey to do AS-Exchange")
        end
        as_rep = nil
        begin
          as_rep = send_asrequest(princ, secret_keys, nil)
        rescue KrbException => ke
          if (((ke.return_code).equal?(Krb5::KDC_ERR_PREAUTH_FAILED)) || ((ke.return_code).equal?(Krb5::KDC_ERR_PREAUTH_REQUIRED)))
            # process pre-auth info
            if (self.attr_debug)
              System.out.println("AcquireTGT: PREAUTH FAILED/REQUIRED," + " re-send AS-REQ")
            end
            error = ke.get_error
            # update salt in PrincipalName
            new_salt = error.get_salt
            if (!(new_salt).nil? && new_salt.attr_length > 0)
              princ.set_salt(String.new(new_salt))
            end
            # refresh keys
            if (!(password).nil?)
              secret_keys = EncryptionKey.acquire_secret_keys(password, princ.get_salt, true, error.get_etype, error.get_params)
            end
            as_rep = send_asrequest(princ, secret_keys, ke.get_error)
          else
            raise ke
          end
        end
        return as_rep.get_creds
      end
      
      typesig { [PrincipalName, Array.typed(EncryptionKey), KRBError] }
      # Sends the AS-REQ
      def send_asrequest(princ, secret_keys, error)
        # %%%
        as_req = nil
        if ((error).nil?)
          as_req = KrbAsReq.new(princ, secret_keys)
        else
          as_req = KrbAsReq.new(princ, secret_keys, true, error.get_etype, error.get_salt, error.get_params)
        end
        kdc = nil
        as_rep = nil
        begin
          kdc = RJava.cast_to_string(as_req.send)
          as_rep = as_req.get_reply(secret_keys)
        rescue KrbException => ke
          if ((ke.return_code).equal?(Krb5::KRB_ERR_RESPONSE_TOO_BIG))
            as_req.send(princ.get_realm_string, kdc, true)
            as_rep = as_req.get_reply(secret_keys)
          else
            raise ke
          end
        end
        return as_rep
      end
      
      typesig { [] }
      # Acquires default credentials.
      # <br>The possible locations for default credentials cache is searched in
      # the following order:
      # <ol>
      # <li> The directory and cache file name specified by "KRB5CCNAME" system.
      # property.
      # <li> The directory and cache file name specified by "KRB5CCNAME"
      # environment variable.
      # <li> A cache file named krb5cc_{user.name} at {user.home} directory.
      # </ol>
      # @return a <code>KrbCreds</code> object if the credential is found,
      # otherwise return null.
      # this method is intentionally changed to not check if the caller's
      # principal name matches cache file's principal name.
      # It assumes that the GSS call has
      # the privilege to access the default cache file.
      def acquire_default_creds
        synchronized(self) do
          result = nil
          if ((self.attr_cache).nil?)
            self.attr_cache = CredentialsCache.get_instance
          end
          if (!(self.attr_cache).nil?)
            if (self.attr_debug)
              System.out.println(">>> KrbCreds found the default ticket " + "granting ticket in credential cache.")
            end
            temp = self.attr_cache.get_default_creds
            if (EType.is_supported(temp.get_etype))
              result = temp.set_krb_creds
            else
              if (self.attr_debug)
                System.out.println(">>> unsupported key type found the default TGT: " + RJava.cast_to_string(temp.get_etype))
              end
            end
          end
          if ((result).nil?)
            # Doesn't seem to be a default cache on this system or
            # TGT has unsupported encryption type
            if (!self.attr_already_tried)
              # See if there's any native code to load
              begin
                ensure_loaded
              rescue JavaException => e
                if (self.attr_debug)
                  System.out.println("Can not load credentials cache")
                  e.print_stack_trace
                end
                self.attr_already_tried = true
              end
            end
            if (self.attr_already_loaded)
              # There is some native code
              if (self.attr_debug)
                System.out.println(">> Acquire default native Credentials")
              end
              result = acquire_default_native_creds
              # only TGT with DES key will be returned by native method
            end
          end
          return result
        end
      end
      
      typesig { [String, JavaFile] }
      # Gets service credential from key table. The credential is used to
      # decrypt the received client message
      # and authenticate the client by verifying the client's credential.
      # 
      # @param serviceName the name of service, using format component@realm
      # @param keyTabFile the file of key table.
      # @return a <code>KrbCreds</code> object.
      def get_service_creds(service_name, key_tab_file)
        k = nil
        service = nil
        result = nil
        begin
          service = PrincipalName.new(service_name)
          if ((service.get_realm).nil?)
            realm = Config.get_instance.get_default_realm
            if ((realm).nil?)
              return nil
            else
              service.set_realm(realm)
            end
          end
        rescue RealmException => e
          if (self.attr_debug)
            e.print_stack_trace
          end
          return nil
        rescue KrbException => e
          if (self.attr_debug)
            e.print_stack_trace
          end
          return nil
        end
        kt = nil
        if ((key_tab_file).nil?)
          kt = KeyTab.get_instance
        else
          kt = KeyTab.get_instance(key_tab_file)
        end
        if ((!(kt).nil?) && (kt.find_service_entry(service)))
          k = kt.read_service_key(service)
          result = Credentials.new(nil, service, nil, nil, nil, nil, nil, nil, nil, nil)
          result.attr_service_key = k
        end
        return result
      end
      
      typesig { [String, Credentials] }
      # Acquires credentials for a specified service using initial credential.
      # When the service has a different realm
      # from the initial credential, we do cross-realm authentication
      # - first, we use the current credential to get
      # a cross-realm credential from the local KDC, then use that
      # cross-realm credential to request service credential
      # from the foreigh KDC.
      # 
      # @param service the name of service principal using format
      # components@realm
      # @param ccreds client's initial credential.
      # @exception IOException if an error occurs in reading the credentials
      # cache
      # @exception KrbException if an error occurs specific to Kerberos
      # @return a <code>Credentials</code> object.
      def acquire_service_creds(service, ccreds)
        return CredentialsUtil.acquire_service_creds(service, ccreds)
      end
      
      typesig { [ServiceName, Credentials] }
      # This method does the real job to request the service credential.
      def service_creds(service, ccreds)
        return KrbTgsReq.new(KDCOptions.new, ccreds, service, nil, nil, nil, nil, nil, nil, nil, nil).send_and_get_creds
      end
    }
    
    typesig { [] }
    def get_cache
      return self.attr_cache
    end
    
    typesig { [] }
    def get_service_key
      return @service_key
    end
    
    class_module.module_eval {
      typesig { [Credentials] }
      # Prints out debug info.
      def print_debug(c)
        System.out.println(">>> DEBUG: ----Credentials----")
        System.out.println("\tclient: " + RJava.cast_to_string(c.attr_client.to_s))
        System.out.println("\tserver: " + RJava.cast_to_string(c.attr_server.to_s))
        System.out.println("\tticket: realm: " + RJava.cast_to_string(c.attr_ticket.attr_realm.to_s))
        System.out.println("\t        sname: " + RJava.cast_to_string(c.attr_ticket.attr_sname.to_s))
        if (!(c.attr_start_time).nil?)
          System.out.println("\tstartTime: " + RJava.cast_to_string(c.attr_start_time.get_time))
        end
        System.out.println("\tendTime: " + RJava.cast_to_string(c.attr_end_time.get_time))
        System.out.println("        ----Credentials end----")
      end
      
      typesig { [] }
      def ensure_loaded
        Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
          local_class_in Credentials
          include_class_members Credentials
          include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            System.load_library("w2k_lsa_auth")
            return nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        self.attr_already_loaded = true
      end
    }
    
    typesig { [] }
    def to_s
      buffer = StringBuffer.new("Credentials:")
      buffer.append("\nclient=").append(@client)
      buffer.append("\nserver=").append(@server)
      if (!(@auth_time).nil?)
        buffer.append("\nauthTime=").append(@auth_time)
      end
      if (!(@start_time).nil?)
        buffer.append("\nstartTime=").append(@start_time)
      end
      buffer.append("\nendTime=").append(@end_time)
      buffer.append("\nrenewTill=").append(@renew_till)
      buffer.append("\nflags: ").append(@flags)
      buffer.append("\nEType (int): ").append(@key.get_etype)
      return buffer.to_s
    end
    
    private
    alias_method :initialize__credentials, :initialize
  end
  
end
