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
      include_const ::Java::Io, :IOException
    }
  end
  
  # An implementation of sun.net.ResolverConfiguration for Windows.
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
    }
    
    # Resolver options
    attr_accessor :opts
    alias_method :attr_opts, :opts
    undef_method :opts
    alias_method :attr_opts=, :opts=
    undef_method :opts=
    
    class_module.module_eval {
      # Addreses have changed
      
      def changed
        defined?(@@changed) ? @@changed : @@changed= false
      end
      alias_method :attr_changed, :changed
      
      def changed=(value)
        @@changed = value
      end
      alias_method :attr_changed=, :changed=
      
      # Time of last refresh.
      
      def last_refresh
        defined?(@@last_refresh) ? @@last_refresh : @@last_refresh= -1
      end
      alias_method :attr_last_refresh, :last_refresh
      
      def last_refresh=(value)
        @@last_refresh = value
      end
      alias_method :attr_last_refresh=, :last_refresh=
      
      # Cache timeout (120 seconds) - should be converted into property
      # or configured as preference in the future.
      const_set_lazy(:TIMEOUT) { 120000 }
      const_attr_reader  :TIMEOUT
      
      # DNS suffix list and name servers populated by native method
      
      def os_searchlist
        defined?(@@os_searchlist) ? @@os_searchlist : @@os_searchlist= nil
      end
      alias_method :attr_os_searchlist, :os_searchlist
      
      def os_searchlist=(value)
        @@os_searchlist = value
      end
      alias_method :attr_os_searchlist=, :os_searchlist=
      
      
      def os_nameservers
        defined?(@@os_nameservers) ? @@os_nameservers : @@os_nameservers= nil
      end
      alias_method :attr_os_nameservers, :os_nameservers
      
      def os_nameservers=(value)
        @@os_nameservers = value
      end
      alias_method :attr_os_nameservers=, :os_nameservers=
      
      # Cached lists
      
      def searchlist
        defined?(@@searchlist) ? @@searchlist : @@searchlist= nil
      end
      alias_method :attr_searchlist, :searchlist
      
      def searchlist=(value)
        @@searchlist = value
      end
      alias_method :attr_searchlist=, :searchlist=
      
      
      def nameservers
        defined?(@@nameservers) ? @@nameservers : @@nameservers= nil
      end
      alias_method :attr_nameservers, :nameservers
      
      def nameservers=(value)
        @@nameservers = value
      end
      alias_method :attr_nameservers=, :nameservers=
    }
    
    typesig { [String] }
    # Parse string that consists of token delimited by space or commas
    # and return LinkedHashMap
    def string_to_list(str)
      ll = LinkedList.new
      # comma and space are valid delimites
      st = StringTokenizer.new(str, ", ")
      while (st.has_more_tokens)
        s = st.next_token
        if (!ll.contains(s))
          ll.add(s)
        end
      end
      return ll
    end
    
    typesig { [] }
    # Load DNS configuration from OS
    def load_config
      raise AssertError if not (JavaThread.holds_lock(self.attr_lock))
      # if address have changed then DNS probably changed aswell;
      # otherwise check if cached settings have expired.
      if (self.attr_changed)
        self.attr_changed = false
      else
        if (self.attr_last_refresh >= 0)
          curr_time = System.current_time_millis
          if ((curr_time - self.attr_last_refresh) < TIMEOUT)
            return
          end
        end
      end
      # load DNS configuration, update timestamp, create
      # new HashMaps from the loaded configuration
      load_dnsconfig0
      self.attr_last_refresh = System.current_time_millis
      self.attr_searchlist = string_to_list(self.attr_os_searchlist)
      self.attr_nameservers = string_to_list(self.attr_os_nameservers)
      self.attr_os_searchlist = RJava.cast_to_string(nil) # can be GC'ed
      self.attr_os_nameservers = RJava.cast_to_string(nil)
    end
    
    typesig { [] }
    def initialize
      @opts = nil
      super()
      @opts = OptionsImpl.new
    end
    
    typesig { [] }
    def searchlist
      synchronized((self.attr_lock)) do
        load_config
        # List is mutable so return a shallow copy
        return self.attr_searchlist.clone
      end
    end
    
    typesig { [] }
    def nameservers
      synchronized((self.attr_lock)) do
        load_config
        # List is mutable so return a shallow copy
        return self.attr_nameservers.clone
      end
    end
    
    typesig { [] }
    def options
      return @opts
    end
    
    class_module.module_eval {
      # --- Address Change Listener
      const_set_lazy(:AddressChangeListener) { Class.new(JavaThread) do
        include_class_members ResolverConfigurationImpl
        
        typesig { [] }
        def run
          loop do
            # wait for configuration to change
            if (!(notify_addr_change0).equal?(0))
              return
            end
            synchronized((self.attr_lock)) do
              self.attr_changed = true
            end
          end
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__address_change_listener, :initialize
      end }
      
      JNI.load_native_method :Java_sun_net_dns_ResolverConfigurationImpl_init0, [:pointer, :long], :void
      typesig { [] }
      # --- Native methods --
      def init0
        JNI.call_native_method(:Java_sun_net_dns_ResolverConfigurationImpl_init0, JNI.env, self.jni_id)
      end
      
      JNI.load_native_method :Java_sun_net_dns_ResolverConfigurationImpl_loadDNSconfig0, [:pointer, :long], :void
      typesig { [] }
      def load_dnsconfig0
        JNI.call_native_method(:Java_sun_net_dns_ResolverConfigurationImpl_loadDNSconfig0, JNI.env, self.jni_id)
      end
      
      JNI.load_native_method :Java_sun_net_dns_ResolverConfigurationImpl_notifyAddrChange0, [:pointer, :long], :int32
      typesig { [] }
      def notify_addr_change0
        JNI.call_native_method(:Java_sun_net_dns_ResolverConfigurationImpl_notifyAddrChange0, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        Java::Security::AccessController.do_privileged(Sun::Security::Action::LoadLibraryAction.new("net"))
        init0
        # start the address listener thread
        thr = AddressChangeListener.new
        thr.set_daemon(true)
        thr.start
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
