require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jgss
  module GSSUtilImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss
      include_const ::Com::Sun::Security::Auth::Callback, :TextCallbackHandler
      include_const ::Javax::Security::Auth, :Subject
      include_const ::Javax::Security::Auth::Kerberos, :KerberosPrincipal
      include_const ::Javax::Security::Auth::Kerberos, :KerberosTicket
      include_const ::Javax::Security::Auth::Kerberos, :KerberosKey
      include ::Org::Ietf::Jgss
      include_const ::Sun::Security::Jgss::Spi, :GSSNameSpi
      include_const ::Sun::Security::Jgss::Spi, :GSSCredentialSpi
      include_const ::Sun::Security::Action, :GetPropertyAction
      include_const ::Sun::Security::Jgss::Krb5, :Krb5NameElement
      include_const ::Sun::Security::Jgss::Spnego, :SpNegoCredElement
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :Iterator
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :AccessControlContext
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Javax::Security::Auth::Callback, :CallbackHandler
      include_const ::Javax::Security::Auth::Login, :LoginContext
      include_const ::Javax::Security::Auth::Login, :LoginException
      include_const ::Sun::Security::Action, :GetBooleanAction
    }
  end
  
  # The GSSUtilImplementation that knows how to work with the internals of
  # the GSS-API.
  class GSSUtil 
    include_class_members GSSUtilImports
    
    class_module.module_eval {
      const_set_lazy(:GSS_KRB5_MECH_OID) { GSSUtil.create_oid("1.2.840.113554.1.2.2") }
      const_attr_reader  :GSS_KRB5_MECH_OID
      
      const_set_lazy(:GSS_KRB5_MECH_OID2) { GSSUtil.create_oid("1.3.5.1.5.2") }
      const_attr_reader  :GSS_KRB5_MECH_OID2
      
      const_set_lazy(:GSS_SPNEGO_MECH_OID) { GSSUtil.create_oid("1.3.6.1.5.5.2") }
      const_attr_reader  :GSS_SPNEGO_MECH_OID
      
      const_set_lazy(:NT_GSS_KRB5_PRINCIPAL) { GSSUtil.create_oid("1.2.840.113554.1.2.2.1") }
      const_attr_reader  :NT_GSS_KRB5_PRINCIPAL
      
      const_set_lazy(:NT_HOSTBASED_SERVICE2) { GSSUtil.create_oid("1.2.840.113554.1.2.1.4") }
      const_attr_reader  :NT_HOSTBASED_SERVICE2
      
      const_set_lazy(:DEFAULT_HANDLER) { "auth.login.defaultCallbackHandler" }
      const_attr_reader  :DEFAULT_HANDLER
      
      const_set_lazy(:CALLER_UNKNOWN) { -1 }
      const_attr_reader  :CALLER_UNKNOWN
      
      const_set_lazy(:CALLER_INITIATE) { 1 }
      const_attr_reader  :CALLER_INITIATE
      
      const_set_lazy(:CALLER_ACCEPT) { 2 }
      const_attr_reader  :CALLER_ACCEPT
      
      const_set_lazy(:CALLER_SSL_CLIENT) { 3 }
      const_attr_reader  :CALLER_SSL_CLIENT
      
      const_set_lazy(:CALLER_SSL_SERVER) { 4 }
      const_attr_reader  :CALLER_SSL_SERVER
      
      const_set_lazy(:CALLER_HTTP_NEGOTIATE) { 5 }
      const_attr_reader  :CALLER_HTTP_NEGOTIATE
      
      when_class_loaded do
        const_set :DEBUG, (AccessController.do_privileged(GetBooleanAction.new("sun.security.jgss.debug"))).boolean_value
      end
      
      typesig { [String] }
      def debug(message)
        if (DEBUG)
          raise AssertError if not ((!(message).nil?))
          System.out.println(message)
        end
      end
      
      typesig { [String] }
      # NOTE: this method is only for creating Oid objects with
      # known to be valid <code>oidStr</code> given it ignores
      # the GSSException
      def create_oid(oid_str)
        begin
          return Oid.new(oid_str)
        rescue GSSException => e
          debug("Ignored invalid OID: " + oid_str)
          return nil
        end
      end
      
      typesig { [Oid] }
      def is_sp_nego_mech(oid)
        return ((GSS_SPNEGO_MECH_OID == oid))
      end
      
      typesig { [Oid] }
      def is_kerberos_mech(oid)
        return ((GSS_KRB5_MECH_OID == oid) || (GSS_KRB5_MECH_OID2 == oid))
      end
      
      typesig { [Oid] }
      def get_mech_str(oid)
        if (is_sp_nego_mech(oid))
          return "SPNEGO"
        else
          if (is_kerberos_mech(oid))
            return "Kerberos V5"
          else
            return oid.to_s
          end
        end
      end
      
      typesig { [GSSName, GSSCredential] }
      # Note: The current impl only works with Sun's impl of
      # GSSName and GSSCredential since it depends on package
      # private APIs.
      def get_subject(name, creds)
        priv_credentials = nil
        pub_credentials = HashSet.new # empty Set
        gss_credentials = nil
        krb5principals = HashSet.new
        if (name.is_a?(GSSNameImpl))
          begin
            ne = (name).get_element(GSS_KRB5_MECH_OID)
            krb_name = ne.to_s
            if (ne.is_a?(Krb5NameElement))
              krb_name = RJava.cast_to_string((ne).get_krb5principal_name.get_name)
            end
            krb_princ = KerberosPrincipal.new(krb_name)
            krb5principals.add(krb_princ)
          rescue GSSException => ge
            debug("Skipped name " + RJava.cast_to_string(name) + " due to " + RJava.cast_to_string(ge))
          end
        end
        if (creds.is_a?(GSSCredentialImpl))
          gss_credentials = (creds).get_elements
          priv_credentials = HashSet.new(gss_credentials.size)
          populate_credentials(priv_credentials, gss_credentials)
        else
          priv_credentials = HashSet.new # empty Set
        end
        debug("Created Subject with the following")
        debug("principals=" + RJava.cast_to_string(krb5principals))
        debug("public creds=" + RJava.cast_to_string(pub_credentials))
        debug("private creds=" + RJava.cast_to_string(priv_credentials))
        return Subject.new(false, krb5principals, pub_credentials, priv_credentials)
      end
      
      typesig { [JavaSet, JavaSet] }
      # Populates the set credentials with elements from gssCredentials. At
      # the same time, it converts any subclasses of KerberosTicket
      # into KerberosTicket instances and any subclasses of KerberosKey into
      # KerberosKey instances. (It is not desirable to expose the customer
      # to sun.security.jgss.krb5.Krb5InitCredential which extends
      # KerberosTicket and sun.security.jgss.krb5.Kbr5AcceptCredential which
      # extends KerberosKey.)
      def populate_credentials(credentials, gss_credentials)
        cred = nil
        elements = gss_credentials.iterator
        while (elements.has_next)
          cred = elements.next_
          # Retrieve the internal cred out of SpNegoCredElement
          if (cred.is_a?(SpNegoCredElement))
            cred = (cred).get_internal_cred
          end
          if (cred.is_a?(KerberosTicket))
            if (!(cred.get_class.get_name == "javax.security.auth.kerberos.KerberosTicket"))
              temp_tkt = cred
              cred = KerberosTicket.new(temp_tkt.get_encoded, temp_tkt.get_client, temp_tkt.get_server, temp_tkt.get_session_key.get_encoded, temp_tkt.get_session_key_type, temp_tkt.get_flags, temp_tkt.get_auth_time, temp_tkt.get_start_time, temp_tkt.get_end_time, temp_tkt.get_renew_till, temp_tkt.get_client_addresses)
            end
            credentials.add(cred)
          else
            if (cred.is_a?(KerberosKey))
              if (!(cred.get_class.get_name == "javax.security.auth.kerberos.KerberosKey"))
                temp_key = cred
                cred = KerberosKey.new(temp_key.get_principal, temp_key.get_encoded, temp_key.get_key_type, temp_key.get_version_number)
              end
              credentials.add(cred)
            else
              # Ignore non-KerberosTicket and non-KerberosKey elements
              debug("Skipped cred element: " + RJava.cast_to_string(cred))
            end
          end
        end
      end
      
      typesig { [::Java::Int, Oid] }
      # Authenticate using the login module from the specified
      # configuration entry.
      # 
      # @param caller the caller of JAAS Login
      # @param mech the mech to be used
      # @return the authenticated subject
      def login(caller, mech)
        cb = nil
        if ((caller).equal?(GSSUtil::CALLER_HTTP_NEGOTIATE))
          cb = Sun::Net::Www::Protocol::Http::NegotiateCallbackHandler.new
        else
          default_handler = Java::Security::Security.get_property(DEFAULT_HANDLER)
          # get the default callback handler
          if ((!(default_handler).nil?) && (!(default_handler.length).equal?(0)))
            cb = nil
          else
            cb = TextCallbackHandler.new
          end
        end
        # New instance of LoginConfigImpl must be created for each login,
        # since the entry name is not passed as the first argument, but
        # generated with caller and mech inside LoginConfigImpl
        lc = LoginContext.new("", nil, cb, LoginConfigImpl.new(caller, mech))
        lc.login
        return lc.get_subject
      end
      
      typesig { [::Java::Int] }
      # Determines if the application doesn't mind if the mechanism obtains
      # the required credentials from outside of the current Subject. Our
      # Kerberos v5 mechanism would do a JAAS login on behalf of the
      # application if this were the case.
      # 
      # The application indicates this by explicitly setting the system
      # property javax.security.auth.useSubjectCredsOnly to false.
      def use_subject_creds_only(caller)
        # HTTP/SPNEGO doesn't use the standard JAAS framework. Instead, it
        # uses the java.net.Authenticator style, therefore always return
        # false here.
        if ((caller).equal?(CALLER_HTTP_NEGOTIATE))
          return false
        end
        # Don't use GetBooleanAction because the default value in the JRE
        # (when this is unset) has to treated as true.
        prop_value = AccessController.do_privileged(GetPropertyAction.new("javax.security.auth.useSubjectCredsOnly", "true"))
        # This property has to be explicitly set to "false". Invalid
        # values should be ignored and the default "true" assumed.
        return (!prop_value.equals_ignore_case("false"))
      end
      
      typesig { [] }
      # Determines the SPNEGO interoperability mode with Microsoft;
      # by default it is set to true.
      # 
      # To disable it, the application indicates this by explicitly setting
      # the system property sun.security.spnego.interop to false.
      def use_msinterop
        # Don't use GetBooleanAction because the default value in the JRE
        # (when this is unset) has to treated as true.
        prop_value = AccessController.do_privileged(GetPropertyAction.new("sun.security.spnego.msinterop", "true"))
        # This property has to be explicitly set to "false". Invalid
        # values should be ignored and the default "true" assumed.
        return (!prop_value.equals_ignore_case("false"))
      end
      
      typesig { [GSSNameSpi, Oid, ::Java::Boolean, Class] }
      # Searches the private credentials of current Subject with the
      # specified criteria and returns the matching GSSCredentialSpi
      # object out of Sun's impl of GSSCredential. Returns null if
      # no Subject present or a Vector which contains 0 or more
      # matching GSSCredentialSpi objects.
      def search_subject(name, mech, initiate, cred_cls)
        debug("Search Subject for " + RJava.cast_to_string(get_mech_str(mech)) + RJava.cast_to_string((initiate ? " INIT" : " ACCEPT")) + " cred (" + RJava.cast_to_string(((name).nil? ? "<<DEF>>" : name.to_s)) + ", " + RJava.cast_to_string(cred_cls.get_name) + ")")
        acc = AccessController.get_context
        begin
          creds = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
            extend LocalClass
            include_class_members GSSUtil
            include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
            
            typesig { [] }
            define_method :run do
              acc_subj = Subject.get_subject(acc)
              result = nil
              if (!(acc_subj).nil?)
                result = self.class::Vector.new
                iterator_ = acc_subj.get_private_credentials(GSSCredentialImpl).iterator
                while (iterator_.has_next)
                  cred = iterator_.next_
                  debug("...Found cred" + RJava.cast_to_string(cred))
                  begin
                    ce = cred.get_element(mech, initiate)
                    debug("......Found element: " + RJava.cast_to_string(ce))
                    if ((ce.get_class == cred_cls) && ((name).nil? || (name == ce.get_name)))
                      result.add(ce)
                    else
                      debug("......Discard element")
                    end
                  rescue self.class::GSSException => ge
                    debug("...Discard cred (" + RJava.cast_to_string(ge) + ")")
                  end
                end
              else
                debug("No Subject")
              end
              return result
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          return creds
        rescue PrivilegedActionException => pae
          debug("Unexpected exception when searching Subject:")
          if (DEBUG)
            pae.print_stack_trace
          end
          return nil
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__gssutil, :initialize
  end
  
end
