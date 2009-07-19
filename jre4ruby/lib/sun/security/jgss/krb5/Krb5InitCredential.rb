require "rjava"

# Copyright 2000-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jgss::Krb5
  module Krb5InitCredentialImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Krb5
      include ::Org::Ietf::Jgss
      include_const ::Sun::Security::Jgss, :GSSUtil
      include ::Sun::Security::Jgss::Spi
      include ::Sun::Security::Krb5
      include_const ::Sun::Security::Krb5, :Config
      include ::Javax::Security::Auth::Kerberos
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :Date
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :AccessControlContext
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :PrivilegedActionException
    }
  end
  
  # Implements the krb5 initiator credential element.
  # 
  # @author Mayank Upadhyay
  # @author Ram Marti
  # @since 1.4
  class Krb5InitCredential < Krb5InitCredentialImports.const_get :KerberosTicket
    include_class_members Krb5InitCredentialImports
    include Krb5CredElement
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 7723415700837898232 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :krb5credentials
    alias_method :attr_krb5credentials, :krb5credentials
    undef_method :krb5credentials
    alias_method :attr_krb5credentials=, :krb5credentials=
    undef_method :krb5credentials=
    
    typesig { [Krb5NameElement, Array.typed(::Java::Byte), KerberosPrincipal, KerberosPrincipal, Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Boolean), Date, Date, Date, Date, Array.typed(InetAddress)] }
    def initialize(name, asn1encoding, client, server, session_key, key_type, flags, auth_time, start_time, end_time, renew_till, client_addresses)
      @name = nil
      @krb5credentials = nil
      super(asn1encoding, client, server, session_key, key_type, flags, auth_time, start_time, end_time, renew_till, client_addresses)
      @name = name
      begin
        # Cache this for later use by the sun.security.krb5 package.
        @krb5credentials = Credentials.new(asn1encoding, client.get_name, server.get_name, session_key, key_type, flags, auth_time, start_time, end_time, renew_till, client_addresses)
      rescue KrbException => e
        raise GSSException.new(GSSException::NO_CRED, -1, e.get_message)
      rescue IOException => e
        raise GSSException.new(GSSException::NO_CRED, -1, e.get_message)
      end
    end
    
    typesig { [Krb5NameElement, Credentials, Array.typed(::Java::Byte), KerberosPrincipal, KerberosPrincipal, Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Boolean), Date, Date, Date, Date, Array.typed(InetAddress)] }
    def initialize(name, delegated_cred, asn1encoding, client, server, session_key, key_type, flags, auth_time, start_time, end_time, renew_till, client_addresses)
      @name = nil
      @krb5credentials = nil
      super(asn1encoding, client, server, session_key, key_type, flags, auth_time, start_time, end_time, renew_till, client_addresses)
      @name = name
      # A delegated cred does not have all fields set. So do not try to
      # creat new Credentials out of the delegatedCred.
      @krb5credentials = delegated_cred
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, Krb5NameElement, ::Java::Int] }
      def get_instance(caller, name, init_lifetime)
        tgt = get_tgt(caller, name, init_lifetime)
        if ((tgt).nil?)
          raise GSSException.new(GSSException::NO_CRED, -1, "Failed to find any Kerberos tgt")
        end
        if ((name).nil?)
          full_name = tgt.get_client.get_name
          name = Krb5NameElement.get_instance(full_name, Krb5MechFactory::NT_GSS_KRB5_PRINCIPAL)
        end
        return Krb5InitCredential.new(name, tgt.get_encoded, tgt.get_client, tgt.get_server, tgt.get_session_key.get_encoded, tgt.get_session_key_type, tgt.get_flags, tgt.get_auth_time, tgt.get_start_time, tgt.get_end_time, tgt.get_renew_till, tgt.get_client_addresses)
      end
      
      typesig { [Krb5NameElement, Credentials] }
      def get_instance(name, delegated_cred)
        session_key = delegated_cred.get_session_key
        # all of the following data is optional in a KRB-CRED
        # messages. This check for each field.
        c_princ = delegated_cred.get_client
        s_princ = delegated_cred.get_server
        client = nil
        server = nil
        cred_name = nil
        if (!(c_princ).nil?)
          full_name = c_princ.get_name
          cred_name = Krb5NameElement.get_instance(full_name, Krb5MechFactory::NT_GSS_KRB5_PRINCIPAL)
          client = KerberosPrincipal.new(full_name)
        end
        # XXX Compare name to credName
        if (!(s_princ).nil?)
          server = KerberosPrincipal.new(s_princ.get_name, KerberosPrincipal::KRB_NT_SRV_INST)
        end
        return Krb5InitCredential.new(cred_name, delegated_cred, delegated_cred.get_encoded, client, server, session_key.get_bytes, session_key.get_etype, delegated_cred.get_flags, delegated_cred.get_auth_time, delegated_cred.get_start_time, delegated_cred.get_end_time, delegated_cred.get_renew_till, delegated_cred.get_client_addresses)
      end
    }
    
    typesig { [] }
    # Returns the principal name for this credential. The name
    # is in mechanism specific format.
    # 
    # @return GSSNameSpi representing principal name of this credential
    # @exception GSSException may be thrown
    def get_name
      return @name
    end
    
    typesig { [] }
    # Returns the init lifetime remaining.
    # 
    # @return the init lifetime remaining in seconds
    # @exception GSSException may be thrown
    def get_init_lifetime
      ret_val = 0
      ret_val = RJava.cast_to_int((get_end_time.get_time - (Date.new.get_time)))
      return ret_val
    end
    
    typesig { [] }
    # Returns the accept lifetime remaining.
    # 
    # @return the accept lifetime remaining in seconds
    # @exception GSSException may be thrown
    def get_accept_lifetime
      return 0
    end
    
    typesig { [] }
    def is_initiator_credential
      return true
    end
    
    typesig { [] }
    def is_acceptor_credential
      return false
    end
    
    typesig { [] }
    # Returns the oid representing the underlying credential
    # mechanism oid.
    # 
    # @return the Oid for this credential mechanism
    # @exception GSSException may be thrown
    def get_mechanism
      return Krb5MechFactory::GSS_KRB5_MECH_OID
    end
    
    typesig { [] }
    def get_provider
      return Krb5MechFactory::PROVIDER
    end
    
    typesig { [] }
    # Returns a sun.security.krb5.Credentials instance so that it maybe
    # used in that package for th Kerberos protocol.
    def get_krb5credentials
      return @krb5credentials
    end
    
    typesig { [] }
    # XXX Call to this.refresh() should refresh the locally cached copy
    # of krb5Credentials also.
    # 
    # 
    # Called to invalidate this credential element.
    def dispose
      begin
        destroy
      rescue Javax::Security::Auth::DestroyFailedException => e
        gss_exception = GSSException.new(GSSException::FAILURE, -1, "Could not destroy credentials - " + (e.get_message).to_s)
        gss_exception.init_cause(e)
      end
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, Krb5NameElement, ::Java::Int] }
      # XXX call to this.destroy() should destroy the locally cached copy
      # of krb5Credentials and then call super.destroy().
      def get_tgt(caller, name, init_lifetime)
        realm = nil
        client_principal = nil
        tgs_principal = nil
        # Find the TGT for the realm that the client is in. If the client
        # name is not available, then use the default realm.
        if (!(name).nil?)
          client_principal = ((name.get_krb5principal_name).get_name).to_s
          realm = ((name.get_krb5principal_name).get_realm_as_string).to_s
        else
          client_principal = (nil).to_s
          begin
            config = Config.get_instance
            realm = (config.get_default_realm).to_s
          rescue KrbException => e
            ge = GSSException.new(GSSException::NO_CRED, -1, "Attempt to obtain INITIATE credentials failed!" + " (" + (e.get_message).to_s + ")")
            ge.init_cause(e)
            raise ge
          end
        end
        acc = AccessController.get_context
        begin
          real_caller = ((caller).equal?(GSSUtil::CALLER_UNKNOWN)) ? GSSUtil::CALLER_INITIATE : caller
          return AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
            extend LocalClass
            include_class_members Krb5InitCredential
            include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
            
            typesig { [] }
            define_method :run do
              return Krb5Util.get_ticket(real_caller, client_principal, tgs_principal, acc)
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        rescue PrivilegedActionException => e
          ge = GSSException.new(GSSException::NO_CRED, -1, "Attempt to obtain new INITIATE credentials failed!" + " (" + (e.get_message).to_s + ")")
          ge.init_cause(e.get_exception)
          raise ge
        end
      end
    }
    
    private
    alias_method :initialize__krb5init_credential, :initialize
  end
  
end
