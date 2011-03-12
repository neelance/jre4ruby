require "rjava"

# Copyright 2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Dns
  module ResolverConfigurationImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Dns
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Io, :BufferedReader
      include_const ::Java::Io, :FileReader
      include_const ::Java::Io, :IOException
    }
  end
  
  # An implementation of ResolverConfiguration for Solaris
  # and Linux.
  class ResolverConfigurationImpl < ResolverConfigurationImplImports.const_get :ResolverConfiguration
    include_class_members ResolverConfigurationImplImports
    
    class_module.module_eval {
      # Lock helds whilst loading configuration or checking
      
      def lock
        defined?(@@lock) ? @@lock : @@lock= Object.new
      end
      alias_method :attr_lock, :lock
      
      def lock=(value)
        @@lock = value
      end
      alias_method :attr_lock=, :lock=
      
      # Time of last refresh.
      
      def last_refresh
        defined?(@@last_refresh) ? @@last_refresh : @@last_refresh= -1
      end
      alias_method :attr_last_refresh, :last_refresh
      
      def last_refresh=(value)
        @@last_refresh = value
      end
      alias_method :attr_last_refresh=, :last_refresh=
      
      # Cache timeout (300 seconds) - should be converted into property
      # or configured as preference in the future.
      const_set_lazy(:TIMEOUT) { 300000 }
      const_attr_reader  :TIMEOUT
    }
    
    # Resolver options
    attr_accessor :opts
    alias_method :attr_opts, :opts
    undef_method :opts
    alias_method :attr_opts=, :opts=
    undef_method :opts=
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # Parse /etc/resolv.conf to get the values for a particular
    # keyword.
    # 
    def resolvconf(keyword, maxperkeyword, maxkeywords)
      ll = LinkedList.new
      begin
        in_ = BufferedReader.new(FileReader.new("/etc/resolv.conf"))
        line = nil
        while (!((line = RJava.cast_to_string(in_.read_line))).nil?)
          maxvalues = maxperkeyword
          if ((line.length).equal?(0))
            next
          end
          if ((line.char_at(0)).equal?(Character.new(?#.ord)) || (line.char_at(0)).equal?(Character.new(?;.ord)))
            next
          end
          if (!line.starts_with(keyword))
            next
          end
          value = line.substring(keyword.length)
          if ((value.length).equal?(0))
            next
          end
          if (!(value.char_at(0)).equal?(Character.new(?\s.ord)) && !(value.char_at(0)).equal?(Character.new(?\t.ord)))
            next
          end
          st = StringTokenizer.new(value, " \t")
          while (st.has_more_tokens)
            val = st.next_token
            if ((val.char_at(0)).equal?(Character.new(?#.ord)) || (val.char_at(0)).equal?(Character.new(?;.ord)))
              break
            end
            ll.add(val)
            if (((maxvalues -= 1)).equal?(0))
              break
            end
          end
          if (((maxkeywords -= 1)).equal?(0))
            break
          end
        end
        in_.close
      rescue IOException => ioe
        # problem reading value
      end
      return ll
    end
    
    attr_accessor :searchlist
    alias_method :attr_searchlist, :searchlist
    undef_method :searchlist
    alias_method :attr_searchlist=, :searchlist=
    undef_method :searchlist=
    
    attr_accessor :nameservers
    alias_method :attr_nameservers, :nameservers
    undef_method :nameservers
    alias_method :attr_nameservers=, :nameservers=
    undef_method :nameservers=
    
    typesig { [] }
    # Load DNS configuration from OS
    def load_config
      raise AssertError if not (JavaThread.holds_lock(self.attr_lock))
      # check if cached settings have expired.
      if (self.attr_last_refresh >= 0)
        curr_time = System.current_time_millis
        if ((curr_time - self.attr_last_refresh) < TIMEOUT)
          return
        end
      end # run
      @nameservers = Java::Security::AccessController.do_privileged(# get the name servers from /etc/resolv.conf
      Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        local_class_in ResolverConfigurationImpl
        include_class_members ResolverConfigurationImpl
        include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          # typically MAXNS is 3 but we've picked 5 here
          # to allow for additional servers if required.
          return resolvconf("nameserver", 1, 5)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      # get the search list (or domain)
      @searchlist = get_search_list
      # update the timestamp on the configuration
      self.attr_last_refresh = System.current_time_millis
    end
    
    typesig { [] }
    # obtain search list or local domain
    def get_search_list
      sl = nil # run
      sl = Java::Security::AccessController.do_privileged(# first try the search keyword in /etc/resolv.conf
      Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        local_class_in ResolverConfigurationImpl
        include_class_members ResolverConfigurationImpl
        include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          ll = nil
          # first try search keyword (max 6 domains)
          ll = resolvconf("search", 6, 1)
          if (ll.size > 0)
            return ll
          end
          return nil
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      if (!(sl).nil?)
        return sl
      end
      # No search keyword so use local domain
      # LOCALDOMAIN has absolute priority on Solaris
      local_domain = local_domain0
      if (!(local_domain).nil? && local_domain.length > 0)
        sl = LinkedList.new
        sl.add(local_domain)
        return sl
      end # run
      sl = Java::Security::AccessController.do_privileged(# try domain keyword in /etc/resolv.conf
      Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        local_class_in ResolverConfigurationImpl
        include_class_members ResolverConfigurationImpl
        include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          ll = nil
          ll = resolvconf("domain", 1, 1)
          if (ll.size > 0)
            return ll
          end
          return nil
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      if (!(sl).nil?)
        return sl
      end
      # no local domain so try fallback (RPC) domain or
      # hostname
      sl = LinkedList.new
      domain = fallback_domain0
      if (!(domain).nil? && domain.length > 0)
        sl.add(domain)
      end
      return sl
    end
    
    typesig { [] }
    # ----
    def initialize
      @opts = nil
      @searchlist = nil
      @nameservers = nil
      super()
      @opts = OptionsImpl.new
    end
    
    typesig { [] }
    def searchlist
      synchronized((self.attr_lock)) do
        load_config
        # List is mutable so return a shallow copy
        return @searchlist.clone
      end
    end
    
    typesig { [] }
    def nameservers
      synchronized((self.attr_lock)) do
        load_config
        # List is mutable so return a shallow copy
        return @nameservers.clone
      end
    end
    
    typesig { [] }
    def options
      return @opts
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_sun_net_dns_ResolverConfigurationImpl_localDomain0, [:pointer, :long], :long
      typesig { [] }
      # --- Native methods --
      def local_domain0
        JNI.call_native_method(:Java_sun_net_dns_ResolverConfigurationImpl_localDomain0, JNI.env, self.jni_id)
      end
      
      JNI.load_native_method :Java_sun_net_dns_ResolverConfigurationImpl_fallbackDomain0, [:pointer, :long], :long
      typesig { [] }
      def fallback_domain0
        JNI.call_native_method(:Java_sun_net_dns_ResolverConfigurationImpl_fallbackDomain0, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        Java::Security::AccessController.do_privileged(Sun::Security::Action::LoadLibraryAction.new("net"))
      end
    }
    
    private
    alias_method :initialize__resolver_configuration_impl, :initialize
  end
  
  # Implementation of {@link ResolverConfiguration.Options}
  class OptionsImpl < ResolverConfigurationImplImports.const_get :ResolverConfiguration::Options
    include_class_members ResolverConfigurationImplImports
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__options_impl, :initialize
  end
  
end
