require "rjava"

# Portions Copyright 2001-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Krb5::Internal
  module CredentialsUtilImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5
      include_const ::Sun::Security::Krb5::Internal::Ccache, :CredentialsCache
      include_const ::Java::Util, :StringTokenizer
      include ::Sun::Security::Krb5::Internal::Ktab
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :Date
      include_const ::Java::Util, :Vector
      include_const ::Java::Io, :BufferedReader
      include_const ::Java::Io, :InputStreamReader
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Java::Net, :InetAddress
    }
  end
  
  # This class is a utility that contains much of the TGS-Exchange
  # protocol. It is used by ../Credentials.java for service ticket
  # acquisition in both the normal and the x-realm case.
  class CredentialsUtil 
    include_class_members CredentialsUtilImports
    
    class_module.module_eval {
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= Sun::Security::Krb5::Internal::Krb5::DEBUG
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      typesig { [String, Credentials] }
      # Acquires credentials for a specified service using initial credential. Wh
      # en the service has a different realm
      # from the initial credential, we do cross-realm authentication - first, we
      # use the current credential to get
      # a cross-realm credential from the local KDC, then use that cross-realm cr
      # edential to request service credential
      # from the foreigh KDC.
      # 
      # @param service the name of service principal using format components@real
      # m
      # @param ccreds client's initial credential.
      # @exception Exception general exception will be thrown when any error occu
      # rs.
      # @return a <code>Credentials</code> object.
      def acquire_service_creds(service, ccreds)
        sname = ServiceName.new(service)
        service_realm = sname.get_realm_string
        local_realm = ccreds.get_client.get_realm_string
        default_realm = Config.get_instance.get_default_realm
        if ((local_realm).nil?)
          temp = nil
          if (!((temp = ccreds.get_server)).nil?)
            local_realm = (temp.get_realm_string).to_s
          end
        end
        if ((local_realm).nil?)
          local_realm = default_realm
        end
        if ((service_realm).nil?)
          service_realm = local_realm
          sname.set_realm(service_realm)
        end
        # if (!localRealm.equalsIgnoreCase(serviceRealm)) { //do cross-realm auth entication
        # if (DEBUG) {
        # System.out.println(">>>DEBUG: Credentails request cross realm ticket for " + "krbtgt/" + serviceRealm + "@" + localRealm);
        # }
        # Credentials crossCreds = serviceCreds(new ServiceName("krbtgt/" + serviceRealm + "@" + localRealm), ccreds);
        # if (DEBUG) {
        # printDebug(crossCreds);
        # }
        # Credentials result = serviceCreds(sname, crossCreds);
        # if (DEBUG) {
        # printDebug(result);
        # }
        # return result;
        # }
        # else return serviceCreds(sname, ccreds);
        if ((local_realm == service_realm))
          if (self.attr_debug)
            System.out.println(">>> Credentials acquireServiceCreds: same realm")
          end
          return service_creds(sname, ccreds)
        end
        # Get a list of realms to traverse
        realms = Realm.get_realms_list(local_realm, service_realm)
        if ((realms).nil? || (realms.attr_length).equal?(0))
          if (self.attr_debug)
            System.out.println(">>> Credentials acquireServiceCreds: no realms list")
          end
          return nil
        end
        i = 0
        k = 0
        c_tgt = nil
        new_tgt = nil
        the_tgt = nil
        temp_service = nil
        realm = nil
        new_tgt_realm = nil
        the_tgt_realm = nil
        c_tgt = ccreds
        i = 0
        while i < realms.attr_length
          temp_service = ServiceName.new(PrincipalName::TGS_DEFAULT_SRV_NAME, service_realm, realms[i])
          if (self.attr_debug)
            System.out.println(">>> Credentials acquireServiceCreds: main loop: [" + (i).to_s + "] tempService=" + (temp_service).to_s)
          end
          begin
            new_tgt = service_creds(temp_service, c_tgt)
          rescue Exception => exc
            new_tgt = nil
          end
          if ((new_tgt).nil?)
            if (self.attr_debug)
              System.out.println(">>> Credentials acquireServiceCreds: no tgt; searching backwards")
            end
            # No tgt found. Try to get one for a
            # realm as close to the target as possible.
            # That means traversing the realms list backwards.
            new_tgt = nil
            k = realms.attr_length - 1
            while (new_tgt).nil? && k > i
              temp_service = ServiceName.new(PrincipalName::TGS_DEFAULT_SRV_NAME, realms[k], realms[i])
              if (self.attr_debug)
                System.out.println(">>> Credentials acquireServiceCreds: inner loop: [" + (k).to_s + "] tempService=" + (temp_service).to_s)
              end
              begin
                new_tgt = service_creds(temp_service, c_tgt)
              rescue Exception => exc
                new_tgt = nil
              end
              ((k -= 1) + 1)
            end
          end # Ends 'if (newTgt == null)'
          if ((new_tgt).nil?)
            if (self.attr_debug)
              System.out.println(">>> Credentials acquireServiceCreds: no tgt; cannot get creds")
            end
            break
          end
          # We have a tgt. It may or may not be for the target.
          # If it's for the target realm, we're done looking for a tgt.
          new_tgt_realm = (new_tgt.get_server.get_instance_component).to_s
          if (self.attr_debug)
            System.out.println(">>> Credentials acquireServiceCreds: got tgt")
            # printDebug(newTgt);
          end
          if ((new_tgt_realm == service_realm))
            # We got the right tgt
            the_tgt = new_tgt
            the_tgt_realm = new_tgt_realm
            break
          end
          # The new tgt is not for the target realm.
          # See if the realm of the new tgt is in the list of realms
          # and continue looking from there.
          k = i + 1
          while k < realms.attr_length
            if ((new_tgt_realm == realms[k]))
              break
            end
            ((k += 1) - 1)
          end
          if (k < realms.attr_length)
            # (re)set the counter so we start looking
            # from the realm we just obtained a tgt for.
            i = k
            c_tgt = new_tgt
            if (self.attr_debug)
              System.out.println(">>> Credentials acquireServiceCreds: continuing with main loop counter reset to " + (i).to_s)
            end
            next
          else
            # The new tgt's realm is not in the heirarchy of realms.
            # It's probably not safe to get a tgt from
            # a tgs that is outside the known list of realms.
            # Give up now.
            break
          end
        end # Ends outermost/main 'for' loop
        the_creds = nil
        if (!(the_tgt).nil?)
          # We have the right tgt. Let's get the service creds
          if (self.attr_debug)
            System.out.println(">>> Credentials acquireServiceCreds: got right tgt")
            # printDebug(theTgt);
            System.out.println(">>> Credentials acquireServiceCreds: obtaining service creds for " + (sname).to_s)
          end
          begin
            the_creds = service_creds(sname, the_tgt)
          rescue Exception => exc
            if (self.attr_debug)
              System.out.println(exc)
            end
            the_creds = nil
          end
        end
        if (!(the_creds).nil?)
          if (self.attr_debug)
            System.out.println(">>> Credentials acquireServiceCreds: returning creds:")
            Credentials.print_debug(the_creds)
          end
          return the_creds
        end
        raise KrbApErrException.new(Krb5::KRB_AP_ERR_GEN_CRED, "No service creds")
      end
      
      typesig { [ServiceName, Credentials] }
      # This method does the real job to request the service credential.
      def service_creds(service, ccreds)
        return KrbTgsReq.new(ccreds, service).send_and_get_creds
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__credentials_util, :initialize
  end
  
end
