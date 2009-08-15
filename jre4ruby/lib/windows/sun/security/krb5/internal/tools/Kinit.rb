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
# 
# 
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal::Tools
  module KinitImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Tools
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5::Internal::Ccache
      include_const ::Java::Io, :BufferedReader
      include_const ::Java::Io, :InputStreamReader
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Util, :Arrays
      include_const ::Sun::Security::Util, :Password
    }
  end
  
  # Kinit tool for obtaining Kerberos v5 tickets.
  # 
  # @author Yanni Zhang
  # @author Ram Marti
  class Kinit 
    include_class_members KinitImports
    
    attr_accessor :options
    alias_method :attr_options, :options
    undef_method :options
    alias_method :attr_options=, :options=
    undef_method :options=
    
    class_module.module_eval {
      const_set_lazy(:DEBUG) { Krb5::DEBUG }
      const_attr_reader  :DEBUG
      
      typesig { [Array.typed(String)] }
      # The main method is used to accept user command line input for ticket
      # request.
      # <p>
      # Usage: kinit [-A] [-f] [-p] [-c cachename] [[-k [-t keytab_file_name]]
      # [principal] [password]
      # <ul>
      # <li>    -A        do not include addresses
      # <li>    -f        forwardable
      # <li>    -p        proxiable
      # <li>    -c        cache name (i.e., FILE://c:\temp\mykrb5cc)
      # <li>    -k        use keytab
      # <li>    -t        keytab file name
      # <li>    principal the principal name (i.e., duke@java.sun.com)
      # <li>    password  the principal's Kerberos password
      # </ul>
      # <p>
      # Use java sun.security.krb5.tools.Kinit -help to bring up help menu.
      # <p>
      # We currently support only file-based credentials cache to
      # store the tickets obtained from the KDC.
      # By default, for all Unix platforms a cache file named
      # /tmp/krb5cc_&lt;uid&gt will be generated. The &lt;uid&gt is the
      # numeric user identifier.
      # For all other platforms, a cache file named
      # &lt;USER_HOME&gt/krb5cc_&lt;USER_NAME&gt would be generated.
      # <p>
      # &lt;USER_HOME&gt is obtained from <code>java.lang.System</code>
      # property <i>user.home</i>.
      # &lt;USER_NAME&gt is obtained from <code>java.lang.System</code>
      # property <i>user.name</i>.
      # If &lt;USER_HOME&gt is null the cache file would be stored in
      # the current directory that the program is running from.
      # &lt;USER_NAME&gt is operating system's login username.
      # It could be different from user's principal name.
      # </p>
      # <p>
      # For instance, on Windows NT, it could be
      # c:\winnt\profiles\duke\krb5cc_duke, in
      # which duke is the &lt;USER_NAME&gt, and c:\winnt\profile\duke is the
      # &lt;USER_HOME&gt.
      # <p>
      # A single user could have multiple principal names,
      # but the primary principal of the credentials cache could only be one,
      # which means one cache file could only store tickets for one
      # specific user principal. If the user switches
      # the principal name at the next Kinit, the cache file generated for the
      # new ticket would overwrite the old cache file by default.
      # To avoid overwriting, you need to specify
      # a different cache file name when you request a
      # new ticket.
      # </p>
      # <p>
      # You can specify the location of the cache file by using the -c option
      def main(args)
        begin
          self_ = Kinit.new(args)
        rescue JavaException => e
          msg = nil
          if (e.is_a?(KrbException))
            msg = RJava.cast_to_string((e).krb_error_message) + " " + RJava.cast_to_string((e).return_code_message)
          else
            msg = RJava.cast_to_string(e.get_message)
          end
          if (!(msg).nil?)
            System.err.println("Exception: " + msg)
          else
            System.out.println("Exception: " + RJava.cast_to_string(e))
          end
          e.print_stack_trace
          System.exit(-1)
        end
        return
      end
    }
    
    typesig { [Array.typed(String)] }
    # Constructs a new Kinit object.
    # @param args array of ticket request options.
    # Avaiable options are: -f, -p, -c, principal, password.
    # @exception IOException if an I/O error occurs.
    # @exception RealmException if the Realm could not be instantiated.
    # @exception KrbException if error occurs during Kerberos operation.
    def initialize(args)
      @options = nil
      if ((args).nil? || (args.attr_length).equal?(0))
        @options = KinitOptions.new
      else
        @options = KinitOptions.new(args)
      end
      princ_name = nil
      principal = @options.get_principal
      if (!(principal).nil?)
        princ_name = RJava.cast_to_string(principal.to_s)
      end
      if (DEBUG)
        System.out.println("Principal is " + RJava.cast_to_string(principal))
      end
      psswd = @options.attr_password
      skeys = nil
      use_keytab = @options.use_keytab_file
      if (!use_keytab)
        if ((princ_name).nil?)
          raise IllegalArgumentException.new(" Can not obtain principal name")
        end
        if ((psswd).nil?)
          System.out.print("Password for " + princ_name + ":")
          System.out.flush
          psswd = Password.read_password(System.in)
          if (DEBUG)
            System.out.println(">>> Kinit console input " + RJava.cast_to_string(String.new(psswd)))
          end
        end
      else
        if (DEBUG)
          System.out.println(">>> Kinit using keytab")
        end
        if ((princ_name).nil?)
          raise IllegalArgumentException.new("Principal name must be specified.")
        end
        ktab_name = @options.keytab_file_name
        if (!(ktab_name).nil?)
          if (DEBUG)
            System.out.println(">>> Kinit keytab file name: " + ktab_name)
          end
        end
        # assert princName and principal are nonnull
        skeys = EncryptionKey.acquire_secret_keys(principal, ktab_name)
        if ((skeys).nil? || (skeys.attr_length).equal?(0))
          msg = "No supported key found in keytab"
          if (!(princ_name).nil?)
            msg += " for principal " + princ_name
          end
          raise KrbException.new(msg)
        end
      end
      opt = KDCOptions.new
      set_options(KDCOptions::FORWARDABLE, @options.attr_forwardable, opt)
      set_options(KDCOptions::PROXIABLE, @options.attr_proxiable, opt)
      realm = @options.get_kdcrealm
      if ((realm).nil?)
        realm = RJava.cast_to_string(Config.get_instance.get_default_realm)
      end
      if (DEBUG)
        System.out.println(">>> Kinit realm name is " + realm)
      end
      sname = PrincipalName.new("krbtgt" + "/" + realm, PrincipalName::KRB_NT_SRV_INST)
      sname.set_realm(realm)
      if (DEBUG)
        System.out.println(">>> Creating KrbAsReq")
      end
      as_req = nil
      addresses = nil
      begin
        if (@options.get_address_option)
          addresses = HostAddresses.get_local_addresses
        end
        if (use_keytab)
          as_req = KrbAsReq.new(skeys, opt, principal, sname, nil, nil, nil, nil, addresses, nil)
        else
          as_req = KrbAsReq.new(psswd, opt, principal, sname, nil, nil, nil, nil, addresses, nil)
        end
      rescue KrbException => exc
        raise exc
      rescue JavaException => exc
        raise KrbException.new(exc.to_s)
      end
      as_rep = nil
      begin
        as_rep = send_asrequest(as_req, use_keytab, realm, psswd, skeys)
      rescue KrbException => ke
        if (((ke.return_code).equal?(Krb5::KDC_ERR_PREAUTH_FAILED)) || ((ke.return_code).equal?(Krb5::KDC_ERR_PREAUTH_REQUIRED)))
          if (DEBUG)
            System.out.println("Kinit: PREAUTH FAILED/REQ, re-send AS-REQ")
          end
          error = ke.get_error
          etype = error.get_etype
          salt = error.get_salt
          s2kparams = error.get_params
          if (use_keytab)
            as_req = KrbAsReq.new(skeys, true, etype, salt, s2kparams, opt, principal, sname, nil, nil, nil, nil, addresses, nil)
          else
            as_req = KrbAsReq.new(psswd, true, etype, salt, s2kparams, opt, principal, sname, nil, nil, nil, nil, addresses, nil)
          end
          as_rep = send_asrequest(as_req, use_keytab, realm, psswd, skeys)
        else
          raise ke
        end
      end
      credentials = as_rep.set_credentials
      # we always create a new cache and store the ticket we get
      cache = CredentialsCache.create(principal, @options.attr_cachename)
      if ((cache).nil?)
        raise IOException.new("Unable to create the cache file " + RJava.cast_to_string(@options.attr_cachename))
      end
      cache.update(credentials)
      cache.save
      if ((@options.attr_password).nil?)
        # Assume we're running interactively
        System.out.println("New ticket is stored in cache file " + RJava.cast_to_string(@options.attr_cachename))
      else
        Arrays.fill(@options.attr_password, Character.new(?0.ord))
      end
      # clear the password
      if (!(psswd).nil?)
        Arrays.fill(psswd, Character.new(?0.ord))
      end
      @options = nil # release reference to options
    end
    
    class_module.module_eval {
      typesig { [KrbAsReq, ::Java::Boolean, String, Array.typed(::Java::Char), Array.typed(EncryptionKey)] }
      def send_asrequest(as_req, use_keytab, realm, passwd, skeys)
        if (DEBUG)
          System.out.println(">>> Kinit: sending as_req to realm " + realm)
        end
        kdc = as_req.send(realm)
        if (DEBUG)
          System.out.println(">>> reading response from kdc")
        end
        as_rep = nil
        begin
          if (use_keytab)
            as_rep = as_req.get_reply(skeys)
          else
            as_rep = as_req.get_reply(passwd)
          end
        rescue KrbException => ke
          if ((ke.return_code).equal?(Krb5::KRB_ERR_RESPONSE_TOO_BIG))
            as_req.send(realm, kdc, true) # useTCP is set
            if (use_keytab)
              as_rep = as_req.get_reply(skeys)
            else
              as_rep = as_req.get_reply(passwd)
            end
          else
            raise ke
          end
        end
        return as_rep
      end
      
      typesig { [::Java::Int, ::Java::Int, KDCOptions] }
      def set_options(flag, option, opt)
        case (option)
        when 0
        when -1
          opt.set(flag, false)
        when 1
          opt.set(flag, true)
        end
      end
    }
    
    private
    alias_method :initialize__kinit, :initialize
  end
  
  Kinit.main($*) if $0 == __FILE__
end
