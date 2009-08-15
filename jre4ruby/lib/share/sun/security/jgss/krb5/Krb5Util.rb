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
module Sun::Security::Jgss::Krb5
  module Krb5UtilImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Krb5
      include_const ::Javax::Security::Auth::Kerberos, :KerberosTicket
      include_const ::Javax::Security::Auth::Kerberos, :KerberosKey
      include_const ::Javax::Security::Auth::Kerberos, :KerberosPrincipal
      include_const ::Javax::Security::Auth, :Subject
      include_const ::Javax::Security::Auth::Login, :LoginException
      include_const ::Java::Security, :AccessControlContext
      include_const ::Sun::Security::Jgss, :GSSUtil
      include_const ::Sun::Security::Krb5, :Credentials
      include_const ::Sun::Security::Krb5, :EncryptionKey
      include_const ::Sun::Security::Krb5, :KrbException
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :JavaList
    }
  end
  
  # Utilities for obtaining and converting Kerberos tickets.
  class Krb5Util 
    include_class_members Krb5UtilImports
    
    class_module.module_eval {
      const_set_lazy(:DEBUG) { Java::Security::AccessController.do_privileged(Sun::Security::Action::GetBooleanAction.new("sun.security.krb5.debug")).boolean_value }
      const_attr_reader  :DEBUG
    }
    
    typesig { [] }
    # Default constructor
    def initialize
      # Cannot create one of these
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, String, String, String, AccessControlContext] }
      # Retrieve the service ticket for serverPrincipal from caller's Subject
      # or from Subject obtained by logging in, or if not found, via the
      # Ticket Granting Service using the TGT obtained from the Subject.
      # 
      # Caller must have permission to:
      # - access and update Subject's private credentials
      # - create LoginContext
      # - read the auth.login.defaultCallbackHandler security property
      # 
      # NOTE: This method is used by JSSE Kerberos Cipher Suites
      def get_ticket_from_subject_and_tgs(caller, client_principal, server_principal, tgs_principal, acc)
        # 1. Try to find service ticket in acc subject
        acc_subj = Subject.get_subject(acc)
        ticket = SubjectComber.find(acc_subj, server_principal, client_principal, KerberosTicket)
        if (!(ticket).nil?)
          return ticket # found it
        end
        login_subj = nil
        if (!GSSUtil.use_subject_creds_only(caller))
          # 2. Try to get ticket from login
          begin
            login_subj = GSSUtil.login(caller, GSSUtil::GSS_KRB5_MECH_OID)
            ticket = SubjectComber.find(login_subj, server_principal, client_principal, KerberosTicket)
            if (!(ticket).nil?)
              return ticket # found it
            end
          rescue LoginException => e
            # No login entry to use
            # ignore and continue
          end
        end
        # Service ticket not found in subject or login
        # Try to get TGT to acquire service ticket
        # 3. Try to get TGT from acc subject
        tgt = SubjectComber.find(acc_subj, tgs_principal, client_principal, KerberosTicket)
        from_acc = false
        if ((tgt).nil? && !(login_subj).nil?)
          # 4. Try to get TGT from login subject
          tgt = SubjectComber.find(login_subj, tgs_principal, client_principal, KerberosTicket)
          from_acc = false
        else
          from_acc = true
        end
        # 5. Try to get service ticket using TGT
        if (!(tgt).nil?)
          tgt_creds = ticket_to_creds(tgt)
          service_creds = Credentials.acquire_service_creds(server_principal, tgt_creds)
          if (!(service_creds).nil?)
            ticket = creds_to_ticket(service_creds)
            # Store service ticket in acc's Subject
            if (from_acc && !(acc_subj).nil? && !acc_subj.is_read_only)
              acc_subj.get_private_credentials.add(ticket)
            end
          end
        end
        return ticket
      end
      
      typesig { [::Java::Int, String, String, AccessControlContext] }
      # Retrieves the ticket corresponding to the client/server principal
      # pair from the Subject in the specified AccessControlContext.
      # If the ticket can not be found in the Subject, and if
      # useSubjectCredsOnly is false, then obtain ticket from
      # a LoginContext.
      def get_ticket(caller, client_principal, server_principal, acc)
        # Try to get ticket from acc's Subject
        acc_subj = Subject.get_subject(acc)
        ticket = SubjectComber.find(acc_subj, server_principal, client_principal, KerberosTicket)
        # Try to get ticket from Subject obtained from GSSUtil
        if ((ticket).nil? && !GSSUtil.use_subject_creds_only(caller))
          subject = GSSUtil.login(caller, GSSUtil::GSS_KRB5_MECH_OID)
          ticket = SubjectComber.find(subject, server_principal, client_principal, KerberosTicket)
        end
        return ticket
      end
      
      typesig { [::Java::Int, AccessControlContext] }
      # Retrieves the caller's Subject, or Subject obtained by logging in
      # via the specified caller.
      # 
      # Caller must have permission to:
      # - access the Subject
      # - create LoginContext
      # - read the auth.login.defaultCallbackHandler security property
      # 
      # NOTE: This method is used by JSSE Kerberos Cipher Suites
      def get_subject(caller, acc)
        # Try to get the Subject from acc
        subject = Subject.get_subject(acc)
        # Try to get Subject obtained from GSSUtil
        if ((subject).nil? && !GSSUtil.use_subject_creds_only(caller))
          subject = GSSUtil.login(caller, GSSUtil::GSS_KRB5_MECH_OID)
        end
        return subject
      end
      
      typesig { [::Java::Int, String, AccessControlContext] }
      # Retrieves the keys for the specified server principal from
      # the Subject in the specified AccessControlContext.
      # If the ticket can not be found in the Subject, and if
      # useSubjectCredsOnly is false, then obtain keys from
      # a LoginContext.
      # 
      # NOTE: This method is used by JSSE Kerberos Cipher Suites
      def get_keys(caller, server_principal, acc)
        acc_subj = Subject.get_subject(acc)
        kkeys = SubjectComber.find_many(acc_subj, server_principal, nil, KerberosKey)
        if ((kkeys).nil? && !GSSUtil.use_subject_creds_only(caller))
          subject = GSSUtil.login(caller, GSSUtil::GSS_KRB5_MECH_OID)
          kkeys = SubjectComber.find_many(subject, server_principal, nil, KerberosKey)
        end
        len = 0
        if (!(kkeys).nil? && (len = kkeys.size) > 0)
          keys = Array.typed(KerberosKey).new(len) { nil }
          kkeys.to_array(keys)
          return keys
        else
          return nil
        end
      end
      
      typesig { [Credentials] }
      def creds_to_ticket(service_creds)
        session_key = service_creds.get_session_key
        return KerberosTicket.new(service_creds.get_encoded, KerberosPrincipal.new(service_creds.get_client.get_name), KerberosPrincipal.new(service_creds.get_server.get_name, KerberosPrincipal::KRB_NT_SRV_INST), session_key.get_bytes, session_key.get_etype, service_creds.get_flags, service_creds.get_auth_time, service_creds.get_start_time, service_creds.get_end_time, service_creds.get_renew_till, service_creds.get_client_addresses)
      end
      
      typesig { [KerberosTicket] }
      def ticket_to_creds(kerb_ticket)
        return Credentials.new(kerb_ticket.get_encoded, kerb_ticket.get_client.get_name, kerb_ticket.get_server.get_name, kerb_ticket.get_session_key.get_encoded, kerb_ticket.get_session_key_type, kerb_ticket.get_flags, kerb_ticket.get_auth_time, kerb_ticket.get_start_time, kerb_ticket.get_end_time, kerb_ticket.get_renew_till, kerb_ticket.get_client_addresses)
      end
    }
    
    private
    alias_method :initialize__krb5util, :initialize
  end
  
end
