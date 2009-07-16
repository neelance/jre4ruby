require "rjava"

# 
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
# 
# 
# ===========================================================================
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# 
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
# ===========================================================================
module Sun::Security::Krb5::Internal::Ccache
  module FileCredentialsCacheImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Ccache
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :Vector
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :FileInputStream
      include_const ::Java::Io, :FileOutputStream
      include_const ::Java::Io, :BufferedReader
      include_const ::Java::Io, :InputStreamReader
      include ::Java::Lang::Reflect
    }
  end
  
  # 
  # CredentialsCache stores credentials(tickets, session keys, etc) in a
  # semi-permanent store
  # for later use by different program.
  # 
  # @author Yanni Zhang
  # @author Ram Marti
  class FileCredentialsCache < FileCredentialsCacheImports.const_get :CredentialsCache
    include_class_members FileCredentialsCacheImports
    include FileCCacheConstants
    
    attr_accessor :version
    alias_method :attr_version, :version
    undef_method :version
    alias_method :attr_version=, :version=
    undef_method :version=
    
    attr_accessor :tag
    alias_method :attr_tag, :tag
    undef_method :tag
    alias_method :attr_tag=, :tag=
    undef_method :tag=
    
    # optional
    attr_accessor :primary_principal
    alias_method :attr_primary_principal, :primary_principal
    undef_method :primary_principal
    alias_method :attr_primary_principal=, :primary_principal=
    undef_method :primary_principal=
    
    attr_accessor :primary_realm
    alias_method :attr_primary_realm, :primary_realm
    undef_method :primary_realm
    alias_method :attr_primary_realm=, :primary_realm=
    undef_method :primary_realm=
    
    attr_accessor :credentials_list
    alias_method :attr_credentials_list, :credentials_list
    undef_method :credentials_list
    alias_method :attr_credentials_list=, :credentials_list=
    undef_method :credentials_list=
    
    class_module.module_eval {
      
      def dir
        defined?(@@dir) ? @@dir : @@dir= nil
      end
      alias_method :attr_dir, :dir
      
      def dir=(value)
        @@dir = value
      end
      alias_method :attr_dir=, :dir=
      
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= Krb5::DEBUG
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      typesig { [PrincipalName, String] }
      def acquire_instance(principal, cache)
        synchronized(self) do
          begin
            fcc = FileCredentialsCache.new
            if ((cache).nil?)
              self.attr_cache_name = fcc.get_default_cache_name
            else
              self.attr_cache_name = fcc.check_validation(cache)
            end
            if (((self.attr_cache_name).nil?) || !(JavaFile.new(self.attr_cache_name)).exists)
              # invalid cache name or the file doesn't exist
              return nil
            end
            if (!(principal).nil?)
              fcc.attr_primary_principal = principal
              fcc.attr_primary_realm = principal.get_realm
            end
            fcc.load(self.attr_cache_name)
            return fcc
          rescue IOException => e
            # we don't handle it now, instead we return a null at the end.
            if (self.attr_debug)
              e.print_stack_trace
            end
          rescue KrbException => e
            # we don't handle it now, instead we return a null at the end.
            if (self.attr_debug)
              e_.print_stack_trace
            end
          end
          return nil
        end
      end
      
      typesig { [] }
      def acquire_instance
        return acquire_instance(nil, nil)
      end
      
      typesig { [PrincipalName, String] }
      def _new(principal, name)
        synchronized(self) do
          begin
            fcc = FileCredentialsCache.new
            self.attr_cache_name = fcc.check_validation(name)
            if ((self.attr_cache_name).nil?)
              # invalid cache name or the file doesn't exist
              return nil
            end
            fcc.init(principal, self.attr_cache_name)
            return fcc
          rescue IOException => e
          rescue KrbException => e
          end
          return nil
        end
      end
      
      typesig { [PrincipalName] }
      def _new(principal)
        synchronized(self) do
          begin
            fcc = FileCredentialsCache.new
            self.attr_cache_name = fcc.get_default_cache_name
            fcc.init(principal, self.attr_cache_name)
            return fcc
          rescue IOException => e
            if (self.attr_debug)
              e.print_stack_trace
            end
          rescue KrbException => e
            if (self.attr_debug)
              e_.print_stack_trace
            end
          end
          return nil
        end
      end
    }
    
    typesig { [] }
    def initialize
      @version = 0
      @tag = nil
      @primary_principal = nil
      @primary_realm = nil
      @credentials_list = nil
      super()
    end
    
    typesig { [String] }
    def exists(cache)
      file = JavaFile.new(cache)
      if (file.exists)
        return true
      else
        return false
      end
    end
    
    typesig { [PrincipalName, String] }
    def init(principal, name)
      synchronized(self) do
        @primary_principal = principal
        @primary_realm = principal.get_realm
        cos = CCacheOutputStream.new(FileOutputStream.new(name))
        @version = KRB5_FCC_FVNO_3
        cos.write_header(@primary_principal, @version)
        cos.close
        load(name)
      end
    end
    
    typesig { [String] }
    def load(name)
      synchronized(self) do
        p = nil
        cis = CCacheInputStream.new(FileInputStream.new(name))
        @version = cis.read_version
        if ((@version).equal?(KRB5_FCC_FVNO_4))
          @tag = cis.read_tag
        else
          @tag = nil
          if ((@version).equal?(KRB5_FCC_FVNO_1) || (@version).equal?(KRB5_FCC_FVNO_2))
            cis.set_native_byte_order
          end
        end
        p = cis.read_principal(@version)
        if (!(@primary_principal).nil?)
          if (!(@primary_principal.match(p)))
            raise IOException.new("Primary principals don't match.")
          end
        else
          @primary_principal = p
        end
        @primary_realm = @primary_principal.get_realm
        @credentials_list = Vector.new
        while (cis.available > 0)
          @credentials_list.add_element(cis.read_cred(@version))
        end
        cis.close
      end
    end
    
    typesig { [Credentials] }
    # 
    # Updates the credentials list. If the specified credentials for the
    # service is new, add it to the list. If there is an entry in the list,
    # replace the old credentials with the new one.
    # @param c the credentials.
    def update(c)
      synchronized(self) do
        if (!(@credentials_list).nil?)
          if (@credentials_list.is_empty)
            @credentials_list.add_element(c)
          else
            tmp = nil
            matched = false
            i = 0
            while i < @credentials_list.size
              tmp = @credentials_list.element_at(i)
              if (match(c.attr_sname.get_name_strings, tmp.attr_sname.get_name_strings) && ((c.attr_sname.get_realm_string).equals_ignore_case(tmp.attr_sname.get_realm_string)))
                matched = true
                if (c.attr_endtime.get_time >= tmp.attr_endtime.get_time)
                  if (self.attr_debug)
                    System.out.println(" >>> FileCredentialsCache " + "Ticket matched, overwrite " + "the old one.")
                  end
                  @credentials_list.remove_element_at(i)
                  @credentials_list.add_element(c)
                end
              end
              ((i += 1) - 1)
            end
            if ((matched).equal?(false))
              if (self.attr_debug)
                System.out.println(" >>> FileCredentialsCache Ticket " + "not exactly matched, " + "add new one into cache.")
              end
              @credentials_list.add_element(c)
            end
          end
        end
      end
    end
    
    typesig { [] }
    def get_primary_principal
      synchronized(self) do
        return @primary_principal
      end
    end
    
    typesig { [] }
    # 
    # Saves the credentials cache file to the disk.
    def save
      synchronized(self) do
        cos = CCacheOutputStream.new(FileOutputStream.new(self.attr_cache_name))
        cos.write_header(@primary_principal, @version)
        tmp = nil
        if (!((tmp = get_creds_list)).nil?)
          i = 0
          while i < tmp.attr_length
            cos.add_creds(tmp[i])
            ((i += 1) - 1)
          end
        end
        cos.close
      end
    end
    
    typesig { [Array.typed(String), Array.typed(String)] }
    def match(s1, s2)
      if (!(s1.attr_length).equal?(s2.attr_length))
        return false
      else
        i = 0
        while i < s1.attr_length
          if (!(s1[i].equals_ignore_case(s2[i])))
            return false
          end
          ((i += 1) - 1)
        end
      end
      return true
    end
    
    typesig { [] }
    # 
    # Returns the list of credentials entries in the cache file.
    def get_creds_list
      synchronized(self) do
        if (((@credentials_list).nil?) || (@credentials_list.is_empty))
          return nil
        else
          tmp = Array.typed(Credentials).new(@credentials_list.size) { nil }
          i = 0
          while i < @credentials_list.size
            tmp[i] = @credentials_list.element_at(i)
            ((i += 1) - 1)
          end
          return tmp
        end
      end
    end
    
    typesig { [LoginOptions, PrincipalName, Realm] }
    def get_creds(options, sname, srealm)
      if ((options).nil?)
        return get_creds(sname, srealm)
      else
        list = get_creds_list
        if ((list).nil?)
          return nil
        else
          i = 0
          while i < list.attr_length
            if (sname.match(list[i].attr_sname) && ((srealm.to_s == list[i].attr_srealm.to_s)))
              if (list[i].attr_flags.match(options))
                return list[i]
              end
            end
            ((i += 1) - 1)
          end
        end
        return nil
      end
    end
    
    typesig { [PrincipalName, Realm] }
    # 
    # Gets a credentials for a specified service.
    # @param sname service principal name.
    # @param srealm the realm that the service belongs to.
    def get_creds(sname, srealm)
      list = get_creds_list
      if ((list).nil?)
        return nil
      else
        i = 0
        while i < list.attr_length
          if (sname.match(list[i].attr_sname) && ((srealm.to_s == list[i].attr_srealm.to_s)))
            return list[i]
          end
          ((i += 1) - 1)
        end
      end
      return nil
    end
    
    typesig { [] }
    def get_default_creds
      list = get_creds_list
      if ((list).nil?)
        return nil
      else
        i = list.attr_length - 1
        while i >= 0
          if (list[i].attr_sname.to_s.starts_with("krbtgt"))
            name_strings = list[i].attr_sname.get_name_strings
            # find the TGT for the current realm krbtgt/realm@realm
            if ((name_strings[1] == list[i].attr_srealm.to_s))
              return list[i]
            end
          end
          ((i -= 1) + 1)
        end
      end
      return nil
    end
    
    class_module.module_eval {
      typesig { [] }
      # 
      # Returns path name of the credentials cache file.
      # The path name is searched in the following order:
      # 
      # 1. /tmp/krb5cc_<uid> on unix systems
      # 2. <user.home>/krb5cc_<user.name>
      # 3. <user.home>/krb5cc (if can't get <user.name>)
      def get_default_cache_name
        std_cache_name_component = "krb5cc"
        name = nil
        # get cache name from system.property
        osname = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("os.name"))
        # 
        # For Unix platforms we use the default cache name to be
        # /tmp/krbcc_uid ; for all other platforms  we use
        # {user_home}/krb5_cc{user_name}
        # Please note that for Windows 2K we will use LSA to get
        # the TGT from the the default cache even before we come here;
        # however when we create cache we will create a cache under
        # {user_home}/krb5_cc{user_name} for non-Unix platforms including
        # Windows 2K.
        if (!(osname).nil?)
          cmd = nil
          uid_str = nil
          uid = 0
          if (osname.starts_with("SunOS") || (osname.starts_with("Linux")))
            begin
              c = Class.for_name("com.sun.security.auth.module.UnixSystem")
              constructor = c.get_constructor
              obj = constructor.new_instance
              method = c.get_method("getUid")
              uid = (method.invoke(obj)).long_value
              name = (JavaFile.attr_separator).to_s + "tmp" + (JavaFile.attr_separator).to_s + std_cache_name_component + "_" + (uid).to_s
              if (self.attr_debug)
                System.out.println(">>>KinitOptions cache name is " + name)
              end
              return name
            rescue Exception => e
              if (self.attr_debug)
                System.out.println("Exception in obtaining uid " + "for Unix platforms " + "Using user's home directory")
                e.print_stack_trace
              end
            end
          end
        end
        # we did not get the uid;
        user_name = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("user.name"))
        user_home = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("user.home"))
        if ((user_home).nil?)
          user_home = (Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("user.dir"))).to_s
        end
        if (!(user_name).nil?)
          name = user_home + (JavaFile.attr_separator).to_s + std_cache_name_component + "_" + user_name
        else
          name = user_home + (JavaFile.attr_separator).to_s + std_cache_name_component
        end
        if (self.attr_debug)
          System.out.println(">>>KinitOptions cache name is " + name)
        end
        return name
      end
      
      typesig { [String] }
      def check_validation(name)
        fullname = nil
        if ((name).nil?)
          return nil
        end
        begin
          # get full path name
          fullname = ((JavaFile.new(name)).get_canonical_path).to_s
          f_check = JavaFile.new(fullname)
          if (!(f_check.exists))
            # get absolute directory
            temp = JavaFile.new(f_check.get_parent)
            # test if the directory exists
            if (!(temp.is_directory))
              fullname = (nil).to_s
            end
            temp = nil
          end
          f_check = nil
        rescue IOException => e
          fullname = (nil).to_s # invalid name
        end
        return fullname
      end
      
      typesig { [String] }
      def exec(c)
        st = StringTokenizer.new(c)
        v = Vector.new
        while (st.has_more_tokens)
          v.add_element(st.next_token)
        end
        command = Array.typed(String).new(v.size) { nil }
        v.copy_into(command)
        begin
          p = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members FileCredentialsCache
            include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              begin
                return (Runtime.get_runtime.exec(command))
              rescue Java::Io::IOException => e
                if (self.attr_debug)
                  e.print_stack_trace
                end
                return nil
              end
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          if ((p).nil?)
            # exception occured in execing the command
            return nil
          end
          command_result = BufferedReader.new(InputStreamReader.new(p.get_input_stream, "8859_1"))
          s1 = nil
          if (((command.attr_length).equal?(1)) && ((command[0] == "/usr/bin/env")))
            while (!((s1 = (command_result.read_line).to_s)).nil?)
              if (s1.length >= 11)
                if ((s1.substring(0, 11)).equals_ignore_case("KRB5CCNAME="))
                  s1 = (s1.substring(11)).to_s
                  break
                end
              end
            end
          else
            s1 = (command_result.read_line).to_s
          end
          command_result.close
          return s1
        rescue Exception => e
          if (self.attr_debug)
            e.print_stack_trace
          end
        end
        return nil
      end
    }
    
    private
    alias_method :initialize__file_credentials_cache, :initialize
  end
  
end
