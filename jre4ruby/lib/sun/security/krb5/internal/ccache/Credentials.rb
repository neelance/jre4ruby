require "rjava"

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
# 
# 
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal::Ccache
  module CredentialsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Ccache
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
    }
  end
  
  class Credentials 
    include_class_members CredentialsImports
    
    attr_accessor :cname
    alias_method :attr_cname, :cname
    undef_method :cname
    alias_method :attr_cname=, :cname=
    undef_method :cname=
    
    attr_accessor :crealm
    alias_method :attr_crealm, :crealm
    undef_method :crealm
    alias_method :attr_crealm=, :crealm=
    undef_method :crealm=
    
    attr_accessor :sname
    alias_method :attr_sname, :sname
    undef_method :sname
    alias_method :attr_sname=, :sname=
    undef_method :sname=
    
    attr_accessor :srealm
    alias_method :attr_srealm, :srealm
    undef_method :srealm
    alias_method :attr_srealm=, :srealm=
    undef_method :srealm=
    
    attr_accessor :key
    alias_method :attr_key, :key
    undef_method :key
    alias_method :attr_key=, :key=
    undef_method :key=
    
    attr_accessor :authtime
    alias_method :attr_authtime, :authtime
    undef_method :authtime
    alias_method :attr_authtime=, :authtime=
    undef_method :authtime=
    
    attr_accessor :starttime
    alias_method :attr_starttime, :starttime
    undef_method :starttime
    alias_method :attr_starttime=, :starttime=
    undef_method :starttime=
    
    # optional
    attr_accessor :endtime
    alias_method :attr_endtime, :endtime
    undef_method :endtime
    alias_method :attr_endtime=, :endtime=
    undef_method :endtime=
    
    attr_accessor :renew_till
    alias_method :attr_renew_till, :renew_till
    undef_method :renew_till
    alias_method :attr_renew_till=, :renew_till=
    undef_method :renew_till=
    
    # optional
    attr_accessor :caddr
    alias_method :attr_caddr, :caddr
    undef_method :caddr
    alias_method :attr_caddr=, :caddr=
    undef_method :caddr=
    
    # optional; for proxied tickets only
    attr_accessor :authorization_data
    alias_method :attr_authorization_data, :authorization_data
    undef_method :authorization_data
    alias_method :attr_authorization_data=, :authorization_data=
    undef_method :authorization_data=
    
    # optional, not being actually used
    attr_accessor :is_enc_in_skey
    alias_method :attr_is_enc_in_skey, :is_enc_in_skey
    undef_method :is_enc_in_skey
    alias_method :attr_is_enc_in_skey=, :is_enc_in_skey=
    undef_method :is_enc_in_skey=
    
    # true if ticket is encrypted in another ticket's skey
    attr_accessor :flags
    alias_method :attr_flags, :flags
    undef_method :flags
    alias_method :attr_flags=, :flags=
    undef_method :flags=
    
    attr_accessor :ticket
    alias_method :attr_ticket, :ticket
    undef_method :ticket
    alias_method :attr_ticket=, :ticket=
    undef_method :ticket=
    
    attr_accessor :second_ticket
    alias_method :attr_second_ticket, :second_ticket
    undef_method :second_ticket
    alias_method :attr_second_ticket=, :second_ticket=
    undef_method :second_ticket=
    
    # optional
    attr_accessor :debug
    alias_method :attr_debug, :debug
    undef_method :debug
    alias_method :attr_debug=, :debug=
    undef_method :debug=
    
    typesig { [PrincipalName, PrincipalName, EncryptionKey, KerberosTime, KerberosTime, KerberosTime, KerberosTime, ::Java::Boolean, TicketFlags, HostAddresses, AuthorizationData, Ticket, Ticket] }
    def initialize(new_cname, new_sname, new_key, new_authtime, new_starttime, new_endtime, new_renew_till, new_is_enc_in_skey, new_flags, new_caddr, new_auth_data, new_ticket, new_second_ticket)
      @cname = nil
      @crealm = nil
      @sname = nil
      @srealm = nil
      @key = nil
      @authtime = nil
      @starttime = nil
      @endtime = nil
      @renew_till = nil
      @caddr = nil
      @authorization_data = nil
      @is_enc_in_skey = false
      @flags = nil
      @ticket = nil
      @second_ticket = nil
      @debug = Krb5::DEBUG
      @cname = new_cname.clone
      if (!(new_cname.get_realm).nil?)
        @crealm = new_cname.get_realm.clone
      end
      @sname = new_sname.clone
      if (!(new_sname.get_realm).nil?)
        @srealm = new_sname.get_realm.clone
      end
      @key = new_key.clone
      @authtime = new_authtime.clone
      @starttime = new_starttime.clone
      @endtime = new_endtime.clone
      @renew_till = new_renew_till.clone
      if (!(new_caddr).nil?)
        @caddr = new_caddr.clone
      end
      if (!(new_auth_data).nil?)
        @authorization_data = new_auth_data.clone
      end
      @is_enc_in_skey = new_is_enc_in_skey
      @flags = new_flags.clone
      @ticket = (new_ticket.clone)
      if (!(new_second_ticket).nil?)
        @second_ticket = new_second_ticket.clone
      end
    end
    
    typesig { [KDCRep, Ticket, AuthorizationData, ::Java::Boolean] }
    def initialize(kdc_rep, new_second_ticket, new_authorization_data, new_is_enc_in_skey)
      @cname = nil
      @crealm = nil
      @sname = nil
      @srealm = nil
      @key = nil
      @authtime = nil
      @starttime = nil
      @endtime = nil
      @renew_till = nil
      @caddr = nil
      @authorization_data = nil
      @is_enc_in_skey = false
      @flags = nil
      @ticket = nil
      @second_ticket = nil
      @debug = Krb5::DEBUG
      if ((kdc_rep.attr_enc_kdcrep_part).nil?)
        # can't store while encrypted
        return
      end
      @crealm = kdc_rep.attr_crealm.clone
      @cname = kdc_rep.attr_cname.clone
      @ticket = kdc_rep.attr_ticket.clone
      @key = kdc_rep.attr_enc_kdcrep_part.attr_key.clone
      @flags = kdc_rep.attr_enc_kdcrep_part.attr_flags.clone
      @authtime = kdc_rep.attr_enc_kdcrep_part.attr_authtime.clone
      @starttime = kdc_rep.attr_enc_kdcrep_part.attr_starttime.clone
      @endtime = kdc_rep.attr_enc_kdcrep_part.attr_endtime.clone
      @renew_till = kdc_rep.attr_enc_kdcrep_part.attr_renew_till.clone
      @srealm = kdc_rep.attr_enc_kdcrep_part.attr_srealm.clone
      @sname = kdc_rep.attr_enc_kdcrep_part.attr_sname.clone
      @caddr = kdc_rep.attr_enc_kdcrep_part.attr_caddr.clone
      @second_ticket = new_second_ticket.clone
      @authorization_data = new_authorization_data.clone
      @is_enc_in_skey = new_is_enc_in_skey
    end
    
    typesig { [KDCRep] }
    def initialize(kdc_rep)
      initialize__credentials(kdc_rep, nil)
    end
    
    typesig { [KDCRep, Ticket] }
    def initialize(kdc_rep, new_ticket)
      @cname = nil
      @crealm = nil
      @sname = nil
      @srealm = nil
      @key = nil
      @authtime = nil
      @starttime = nil
      @endtime = nil
      @renew_till = nil
      @caddr = nil
      @authorization_data = nil
      @is_enc_in_skey = false
      @flags = nil
      @ticket = nil
      @second_ticket = nil
      @debug = Krb5::DEBUG
      @sname = kdc_rep.attr_enc_kdcrep_part.attr_sname.clone
      @srealm = kdc_rep.attr_enc_kdcrep_part.attr_srealm.clone
      begin
        @sname.set_realm(@srealm)
      rescue RealmException => e
      end
      @cname = kdc_rep.attr_cname.clone
      @crealm = kdc_rep.attr_crealm.clone
      begin
        @cname.set_realm(@crealm)
      rescue RealmException => e
      end
      @key = kdc_rep.attr_enc_kdcrep_part.attr_key.clone
      @authtime = kdc_rep.attr_enc_kdcrep_part.attr_authtime.clone
      if (!(kdc_rep.attr_enc_kdcrep_part.attr_starttime).nil?)
        @starttime = kdc_rep.attr_enc_kdcrep_part.attr_starttime.clone
      else
        @starttime = nil
      end
      @endtime = kdc_rep.attr_enc_kdcrep_part.attr_endtime.clone
      if (!(kdc_rep.attr_enc_kdcrep_part.attr_renew_till).nil?)
        @renew_till = kdc_rep.attr_enc_kdcrep_part.attr_renew_till.clone
      else
        @renew_till = nil
      end
      # if (kdcRep.msgType == Krb5.KRB_AS_REP) {
      # isEncInSKey = false;
      # secondTicket = null;
      # }
      @flags = kdc_rep.attr_enc_kdcrep_part.attr_flags
      if (!(kdc_rep.attr_enc_kdcrep_part.attr_caddr).nil?)
        @caddr = kdc_rep.attr_enc_kdcrep_part.attr_caddr.clone
      else
        @caddr = nil
      end
      @ticket = kdc_rep.attr_ticket.clone
      if (!(new_ticket).nil?)
        @second_ticket = new_ticket.clone
        @is_enc_in_skey = true
      else
        @second_ticket = nil
        @is_enc_in_skey = false
      end
    end
    
    typesig { [] }
    # Checks if this credential is expired
    def is_valid
      valid = true
      if (@endtime.get_time < System.current_time_millis)
        valid = false
      else
        if ((@starttime.get_time > System.current_time_millis) || (((@starttime).nil?) && (@authtime.get_time > System.current_time_millis)))
          valid = false
        end
      end
      return valid
    end
    
    typesig { [] }
    def get_service_principal
      if ((@sname.get_realm).nil?)
        @sname.set_realm(@srealm)
      end
      return @sname
    end
    
    typesig { [] }
    def set_krb_creds
      return Sun::Security::Krb5::Credentials.new(@ticket, @cname, @sname, @key, @flags, @authtime, @starttime, @endtime, @renew_till, @caddr)
    end
    
    typesig { [] }
    def get_auth_time
      return @authtime
    end
    
    typesig { [] }
    def get_end_time
      return @endtime
    end
    
    typesig { [] }
    def get_ticket_flags
      return @flags
    end
    
    typesig { [] }
    def get_etype
      return @key.get_etype
    end
    
    private
    alias_method :initialize__credentials, :initialize
  end
  
end
