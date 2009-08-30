require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Protocol::Http
  module NegotiatorImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Http
      include_const ::Java::Io, :IOException
      include_const ::Org::Ietf::Jgss, :GSSContext
      include_const ::Org::Ietf::Jgss, :GSSException
      include_const ::Org::Ietf::Jgss, :GSSName
      include_const ::Org::Ietf::Jgss, :Oid
      include_const ::Sun::Security::Jgss, :GSSManagerImpl
      include_const ::Sun::Security::Jgss, :GSSUtil
    }
  end
  
  # This class encapsulates all JAAS and JGSS API calls in a seperate class
  # outside NegotiateAuthentication.java so that J2SE build can go smoothly
  # without the presence of it.
  # 
  # @author weijun.wang@sun.com
  # @since 1.6
  class NegotiatorImpl < NegotiatorImplImports.const_get :Negotiator
    include_class_members NegotiatorImplImports
    
    class_module.module_eval {
      const_set_lazy(:DEBUG) { Java::Security::AccessController.do_privileged(Sun::Security::Action::GetBooleanAction.new("sun.security.krb5.debug")) }
      const_attr_reader  :DEBUG
    }
    
    attr_accessor :context
    alias_method :attr_context, :context
    undef_method :context
    alias_method :attr_context=, :context=
    undef_method :context=
    
    attr_accessor :one_token
    alias_method :attr_one_token, :one_token
    undef_method :one_token
    alias_method :attr_one_token=, :one_token=
    undef_method :one_token=
    
    typesig { [String, String] }
    # Initialize the object, which includes:<ul>
    # <li>Find out what GSS mechanism to use from <code>http.negotiate.mechanism.oid</code>,
    # defaults SPNEGO
    # <li>Creating the GSSName for the target host, "HTTP/"+hostname
    # <li>Creating GSSContext
    # <li>A first call to initSecContext</ul>
    # @param hostname name of peer server
    # @param scheme auth scheme requested, Negotiate ot Kerberos
    # @throws GSSException if any JGSS-API call fails
    def init(hostname, scheme)
      # "1.2.840.113554.1.2.2" Kerberos
      # "1.3.6.1.5.5.2" SPNEGO
      oid = nil
      if (scheme.equals_ignore_case("Kerberos"))
        # we can only use Kerberos mech when the scheme is kerberos
        oid = GSSUtil::GSS_KRB5_MECH_OID
      else
        pref = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
          extend LocalClass
          include_class_members NegotiatorImpl
          include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return System.get_property("http.auth.preference", "spnego")
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        if (pref.equals_ignore_case("kerberos"))
          oid = GSSUtil::GSS_KRB5_MECH_OID
        else
          # currently there is no 3rd mech we can use
          oid = GSSUtil::GSS_SPNEGO_MECH_OID
        end
      end
      manager = GSSManagerImpl.new(GSSUtil::CALLER_HTTP_NEGOTIATE)
      peer_name = "HTTP/" + hostname
      server_name = manager.create_name(peer_name, nil)
      @context = manager.create_context(server_name, oid, nil, GSSContext::DEFAULT_LIFETIME)
      # In order to support credential delegation in HTTP/SPNEGO,
      # we always request it before initSecContext. The current
      # implementation will check the OK-AS-DELEGATE flag inside
      # the service ticket of the web server, and only enable
      # delegation when this flag is set. This check is only
      # performed when the GSS caller is CALLER_HTTP_NEGOTIATE,
      # so all other normal GSS-API calls are not affected.
      @context.request_cred_deleg(true)
      @one_token = @context.init_sec_context(Array.typed(::Java::Byte).new(0) { 0 }, 0, 0)
    end
    
    typesig { [String, String] }
    # Constructor
    # @param hostname name of peer server
    # @param scheme auth scheme requested, Negotiate ot Kerberos
    # @throws java.io.IOException If negotiator cannot be constructed
    def initialize(hostname, scheme)
      @context = nil
      @one_token = nil
      super()
      begin
        init(hostname, scheme)
      rescue GSSException => e
        if (DEBUG)
          System.out.println("Negotiate support not initiated, will fallback to other scheme if allowed. Reason:")
          e.print_stack_trace
        end
        ioe = IOException.new("Negotiate support not initiated")
        ioe.init_cause(e)
        raise ioe
      end
    end
    
    typesig { [] }
    # Return the first token of GSS, in SPNEGO, it's called NegTokenInit
    # @return the first token
    def first_token
      return @one_token
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Return the rest tokens of GSS, in SPNEGO, it's called NegTokenTarg
    # @param token the token received from server
    # @return the next token
    # @throws java.io.IOException if the token cannot be created successfully
    def next_token(token)
      begin
        return @context.init_sec_context(token, 0, token.attr_length)
      rescue GSSException => e
        if (DEBUG)
          System.out.println("Negotiate support cannot continue. Reason:")
          e.print_stack_trace
        end
        ioe = IOException.new("Negotiate support cannot continue")
        ioe.init_cause(e)
        raise ioe
      end
    end
    
    private
    alias_method :initialize__negotiator_impl, :initialize
  end
  
end
