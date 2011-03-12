require "rjava"

# Portions Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Krb5::Internal::Tools
  module KinitOptionsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Tools
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5::Internal::Ccache
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :Vector
      include_const ::Java::Io, :BufferedReader
      include_const ::Java::Io, :InputStreamReader
      include_const ::Java::Io, :FileInputStream
    }
  end
  
  # Maintains user-specific options or default settings when the user requests
  # a KDC ticket using Kinit.
  # 
  # @author Yanni Zhang
  # @author Ram Marti
  class KinitOptions 
    include_class_members KinitOptionsImports
    
    attr_accessor :validate
    alias_method :attr_validate, :validate
    undef_method :validate
    alias_method :attr_validate=, :validate=
    undef_method :validate=
    
    # forwardable and proxiable flags have two states:
    # -1 - flag set to be not forwardable or proxiable;
    # 1 - flag set to be forwardable or proxiable.
    attr_accessor :forwardable
    alias_method :attr_forwardable, :forwardable
    undef_method :forwardable
    alias_method :attr_forwardable=, :forwardable=
    undef_method :forwardable=
    
    attr_accessor :proxiable
    alias_method :attr_proxiable, :proxiable
    undef_method :proxiable
    alias_method :attr_proxiable=, :proxiable=
    undef_method :proxiable=
    
    attr_accessor :renew
    alias_method :attr_renew, :renew
    undef_method :renew
    alias_method :attr_renew=, :renew=
    undef_method :renew=
    
    attr_accessor :lifetime
    alias_method :attr_lifetime, :lifetime
    undef_method :lifetime
    alias_method :attr_lifetime=, :lifetime=
    undef_method :lifetime=
    
    attr_accessor :renewable_lifetime
    alias_method :attr_renewable_lifetime, :renewable_lifetime
    undef_method :renewable_lifetime
    alias_method :attr_renewable_lifetime=, :renewable_lifetime=
    undef_method :renewable_lifetime=
    
    attr_accessor :target_service
    alias_method :attr_target_service, :target_service
    undef_method :target_service
    alias_method :attr_target_service=, :target_service=
    undef_method :target_service=
    
    attr_accessor :keytab_file
    alias_method :attr_keytab_file, :keytab_file
    undef_method :keytab_file
    alias_method :attr_keytab_file=, :keytab_file=
    undef_method :keytab_file=
    
    attr_accessor :cachename
    alias_method :attr_cachename, :cachename
    undef_method :cachename
    alias_method :attr_cachename=, :cachename=
    undef_method :cachename=
    
    attr_accessor :principal
    alias_method :attr_principal, :principal
    undef_method :principal
    alias_method :attr_principal=, :principal=
    undef_method :principal=
    
    attr_accessor :realm
    alias_method :attr_realm, :realm
    undef_method :realm
    alias_method :attr_realm=, :realm=
    undef_method :realm=
    
    attr_accessor :password
    alias_method :attr_password, :password
    undef_method :password
    alias_method :attr_password=, :password=
    undef_method :password=
    
    attr_accessor :keytab
    alias_method :attr_keytab, :keytab
    undef_method :keytab
    alias_method :attr_keytab=, :keytab=
    undef_method :keytab=
    
    attr_accessor :debug
    alias_method :attr_debug, :debug
    undef_method :debug
    alias_method :attr_debug=, :debug=
    undef_method :debug=
    
    attr_accessor :include_addresses
    alias_method :attr_include_addresses, :include_addresses
    undef_method :include_addresses
    alias_method :attr_include_addresses=, :include_addresses=
    undef_method :include_addresses=
    
    # default.
    attr_accessor :use_keytab
    alias_method :attr_use_keytab, :use_keytab
    undef_method :use_keytab
    alias_method :attr_use_keytab=, :use_keytab=
    undef_method :use_keytab=
    
    # default = false.
    attr_accessor :ktab_name
    alias_method :attr_ktab_name, :ktab_name
    undef_method :ktab_name
    alias_method :attr_ktab_name=, :ktab_name=
    undef_method :ktab_name=
    
    typesig { [] }
    # keytab file name
    def initialize
      @validate = false
      @forwardable = -1
      @proxiable = -1
      @renew = false
      @lifetime = nil
      @renewable_lifetime = nil
      @target_service = nil
      @keytab_file = nil
      @cachename = nil
      @principal = nil
      @realm = nil
      @password = nil
      @keytab = false
      @debug = Krb5::DEBUG
      @include_addresses = true
      @use_keytab = false
      @ktab_name = nil
      # no args were specified in the command line;
      # use default values
      @cachename = RJava.cast_to_string(FileCredentialsCache.get_default_cache_name)
      if ((@cachename).nil?)
        raise RuntimeException.new("default cache name error")
      end
      @principal = get_default_principal
    end
    
    typesig { [String] }
    def set_kdcrealm(r)
      @realm = r
    end
    
    typesig { [] }
    def get_kdcrealm
      if ((@realm).nil?)
        if (!(@principal).nil?)
          return @principal.get_realm_string
        end
      end
      return nil
    end
    
    typesig { [Array.typed(String)] }
    def initialize(args)
      @validate = false
      @forwardable = -1
      @proxiable = -1
      @renew = false
      @lifetime = nil
      @renewable_lifetime = nil
      @target_service = nil
      @keytab_file = nil
      @cachename = nil
      @principal = nil
      @realm = nil
      @password = nil
      @keytab = false
      @debug = Krb5::DEBUG
      @include_addresses = true
      @use_keytab = false
      @ktab_name = nil
      # currently we provide support for -f -p -c principal options
      p = nil # store principal
      i = 0
      while i < args.attr_length
        if ((args[i] == "-f"))
          @forwardable = 1
        else
          if ((args[i] == "-p"))
            @proxiable = 1
          else
            if ((args[i] == "-c"))
              if (args[i + 1].starts_with("-"))
                raise IllegalArgumentException.new("input format " + " not correct: " + " -c  option " + "must be followed " + "by the cache name")
              end
              @cachename = RJava.cast_to_string(args[(i += 1)])
              if ((@cachename.length >= 5) && @cachename.substring(0, 5).equals_ignore_case("FILE:"))
                @cachename = RJava.cast_to_string(@cachename.substring(5))
              end
            else
              if ((args[i] == "-A"))
                @include_addresses = false
              else
                if ((args[i] == "-k"))
                  @use_keytab = true
                else
                  if ((args[i] == "-t"))
                    if (!(@ktab_name).nil?)
                      raise IllegalArgumentException.new("-t option/keytab file name repeated")
                    else
                      if (i + 1 < args.attr_length)
                        @ktab_name = RJava.cast_to_string(args[(i += 1)])
                      else
                        raise IllegalArgumentException.new("-t option requires keytab file name")
                      end
                    end
                    @use_keytab = true
                  else
                    if (args[i].equals_ignore_case("-help"))
                      print_help
                      System.exit(0)
                    else
                      if ((p).nil?)
                        # Haven't yet processed a "principal"
                        p = RJava.cast_to_string(args[i])
                        begin
                          @principal = PrincipalName.new(p)
                        rescue JavaException => e
                          raise IllegalArgumentException.new("invalid " + "Principal name: " + p + RJava.cast_to_string(e.get_message))
                        end
                        if ((@principal.get_realm).nil?)
                          realm = Config.get_instance.get_default("default_realm", "libdefaults")
                          if (!(realm).nil?)
                            @principal.set_realm(realm)
                          else
                            raise IllegalArgumentException.new("invalid " + "Realm name")
                          end
                        end
                      else
                        if ((@password).nil?)
                          # Have already processed a Principal, this must be a password
                          @password = args[i].to_char_array
                        else
                          raise IllegalArgumentException.new("too many parameters")
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
        i += 1
      end
      # we should get cache name before getting the default principal name
      if ((@cachename).nil?)
        @cachename = RJava.cast_to_string(FileCredentialsCache.get_default_cache_name)
        if ((@cachename).nil?)
          raise RuntimeException.new("default cache name error")
        end
      end
      if ((@principal).nil?)
        @principal = get_default_principal
      end
    end
    
    typesig { [] }
    def get_default_principal
      cname = nil
      realm = nil
      begin
        realm = RJava.cast_to_string(Config.get_instance.get_default_realm)
      rescue KrbException => e
        System.out.println("Can not get default realm " + RJava.cast_to_string(e.get_message))
        e.print_stack_trace
        return nil
      end
      # get default principal name from the cachename if it is
      # available.
      begin
        cis = CCacheInputStream.new(FileInputStream.new(@cachename))
        version = 0
        if (((version = cis.read_version)).equal?(FileCCacheConstants::KRB5_FCC_FVNO_4))
          cis.read_tag
        else
          if ((version).equal?(FileCCacheConstants::KRB5_FCC_FVNO_1) || (version).equal?(FileCCacheConstants::KRB5_FCC_FVNO_2))
            cis.set_native_byte_order
          end
        end
        p = cis.read_principal(version)
        cis.close
        temp = p.get_realm_string
        if ((temp).nil?)
          p.set_realm(realm)
        end
        if (@debug)
          System.out.println(">>>KinitOptions principal name from " + "the cache is :" + RJava.cast_to_string(p))
        end
        return p
      rescue IOException => e
        # ignore any exceptions; we will use the user name as the
        # principal name
        if (@debug)
          e.print_stack_trace
        end
      rescue RealmException => e
        if (@debug)
          e.print_stack_trace
        end
      end
      username = System.get_property("user.name")
      if (@debug)
        System.out.println(">>>KinitOptions default username is :" + username)
      end
      if (!(realm).nil?)
        begin
          p_ = PrincipalName.new(username)
          if ((p_.get_realm).nil?)
            p_.set_realm(realm)
          end
          return p_
        rescue RealmException => e
          # ignore exception , return null
          if (@debug)
            System.out.println("Exception in getting principal " + "name " + RJava.cast_to_string(e.get_message))
            e.print_stack_trace
          end
        end
      end
      return nil
    end
    
    typesig { [] }
    def print_help
      System.out.println("Usage: kinit " + "[-A] [-f] [-p] [-c cachename] " + "[[-k [-t keytab_file_name]] [principal] " + "[password]")
      System.out.println("\tavailable options to " + "Kerberos 5 ticket request:")
      System.out.println("\t    -A   do not include addresses")
      System.out.println("\t    -f   forwardable")
      System.out.println("\t    -p   proxiable")
      System.out.println("\t    -c   cache name " + "(i.e., FILE:\\d:\\myProfiles\\mykrb5cache)")
      System.out.println("\t    -k   use keytab")
      System.out.println("\t    -t   keytab file name")
      System.out.println("\t    principal   the principal name " + "(i.e., qweadf@ATHENA.MIT.EDU qweadf)")
      System.out.println("\t    password   " + "the principal's Kerberos password")
    end
    
    typesig { [] }
    def get_address_option
      return @include_addresses
    end
    
    typesig { [] }
    def use_keytab_file
      return @use_keytab
    end
    
    typesig { [] }
    def keytab_file_name
      return @ktab_name
    end
    
    typesig { [] }
    def get_principal
      return @principal
    end
    
    private
    alias_method :initialize__kinit_options, :initialize
  end
  
end
