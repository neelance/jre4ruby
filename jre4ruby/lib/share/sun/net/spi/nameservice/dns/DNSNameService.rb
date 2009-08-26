require "rjava"

# Copyright 2000-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Spi::Nameservice::Dns
  module DNSNameServiceImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Spi::Nameservice::Dns
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Net, :UnknownHostException
      include ::Javax::Naming
      include ::Javax::Naming::Directory
      include_const ::Javax::Naming::Spi, :NamingManager
      include ::Java::Util
      include_const ::Sun::Net::Util, :IPAddressUtil
      include_const ::Sun::Net::Dns, :ResolverConfiguration
      include ::Sun::Net::Spi::Nameservice
      include_const ::Java::Security, :AccessController
      include ::Sun::Security::Action
    }
  end
  
  # A name service provider based on JNDI-DNS.
  class DNSNameService 
    include_class_members DNSNameServiceImports
    include NameService
    
    # List of domains specified by property
    attr_accessor :domain_list
    alias_method :attr_domain_list, :domain_list
    undef_method :domain_list
    alias_method :attr_domain_list=, :domain_list=
    undef_method :domain_list=
    
    # JNDI-DNS URL for name servers specified via property
    attr_accessor :name_provider_url
    alias_method :attr_name_provider_url, :name_provider_url
    undef_method :name_provider_url
    alias_method :attr_name_provider_url=, :name_provider_url=
    undef_method :name_provider_url=
    
    class_module.module_eval {
      # Per-thread soft cache of the last temporary context
      
      def context_ref
        defined?(@@context_ref) ? @@context_ref : @@context_ref= ThreadLocal.new
      end
      alias_method :attr_context_ref, :context_ref
      
      def context_ref=(value)
        @@context_ref = value
      end
      alias_method :attr_context_ref=, :context_ref=
      
      # Simple class to encapsulate the temporary context
      const_set_lazy(:ThreadContext) { Class.new do
        include_class_members DNSNameService
        
        attr_accessor :dir_ctxt
        alias_method :attr_dir_ctxt, :dir_ctxt
        undef_method :dir_ctxt
        alias_method :attr_dir_ctxt=, :dir_ctxt=
        undef_method :dir_ctxt=
        
        attr_accessor :ns_list
        alias_method :attr_ns_list, :ns_list
        undef_method :ns_list
        alias_method :attr_ns_list=, :ns_list=
        undef_method :ns_list=
        
        typesig { [self::DirContext, SwtList] }
        def initialize(dir_ctxt, ns_list)
          @dir_ctxt = nil
          @ns_list = nil
          @dir_ctxt = dir_ctxt
          @ns_list = ns_list
        end
        
        typesig { [] }
        def dir_context
          return @dir_ctxt
        end
        
        typesig { [] }
        def nameservers
          return @ns_list
        end
        
        private
        alias_method :initialize__thread_context, :initialize
      end }
    }
    
    typesig { [] }
    # Returns a per-thread DirContext
    def get_temporary_context
      ref = self.attr_context_ref.get
      thr_ctxt = nil
      ns_list = nil
      # if no property specified we need to obtain the list of servers
      if ((@name_provider_url).nil?)
        ns_list = ResolverConfiguration.open.nameservers
      end
      # if soft reference hasn't been gc'ed no property has been
      # specified then we need to check if the DNS configuration
      # has changed.
      if ((!(ref).nil?) && (!((thr_ctxt = ref.get)).nil?))
        if ((@name_provider_url).nil?)
          if (!(thr_ctxt.nameservers == ns_list))
            # DNS configuration has changed
            thr_ctxt = nil
          end
        end
      end
      # new thread context needs to be created
      if ((thr_ctxt).nil?)
        env = Hashtable.new
        env.put("java.naming.factory.initial", "com.sun.jndi.dns.DnsContextFactory")
        # If no nameservers property specified we create provider URL
        # based on system configured name servers
        prov_url = @name_provider_url
        if ((prov_url).nil?)
          prov_url = RJava.cast_to_string(create_provider_url(ns_list))
          if ((prov_url.length).equal?(0))
            raise RuntimeException.new("bad nameserver configuration")
          end
        end
        env.put("java.naming.provider.url", prov_url)
        # Need to create directory context in privileged block
        # as JNDI-DNS needs to resolve the name servers.
        dir_ctxt = nil
        begin
          dir_ctxt = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedExceptionAction.class == Class ? Java::Security::PrivilegedExceptionAction : Object) do
            extend LocalClass
            include_class_members DNSNameService
            include Java::Security::PrivilegedExceptionAction if Java::Security::PrivilegedExceptionAction.class == Module
            
            typesig { [] }
            define_method :run do
              # Create the DNS context using NamingManager rather than using
              # the initial context constructor. This avoids having the initial
              # context constructor call itself.
              ctx = NamingManager.get_initial_context(env)
              if (!(ctx.is_a?(self.class::DirContext)))
                return nil # cannot create a DNS context
              end
              return ctx
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        rescue Java::Security::PrivilegedActionException => pae
          raise pae.get_exception
        end
        # create new soft reference to our thread context
        thr_ctxt = ThreadContext.new(dir_ctxt, ns_list)
        self.attr_context_ref.set(SoftReference.new(thr_ctxt))
      end
      return thr_ctxt.dir_context
    end
    
    typesig { [DirContext, String, Array.typed(String), ::Java::Int] }
    # Resolves the specified entry in DNS.
    # 
    # Canonical name records are recursively resolved (to a maximum
    # of 5 to avoid performance hit and potential CNAME loops).
    # 
    # @param   ctx     JNDI directory context
    # @param   name    name to resolve
    # @param   ids     record types to search
    # @param   depth   call depth - pass as 0.
    # 
    # @return  array list with results (will have at least on entry)
    # 
    # @throws  UnknownHostException if lookup fails or other error.
    def resolve(ctx, name, ids, depth)
      results = ArrayList.new
      attrs = nil
      # do the query
      begin
        attrs = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedExceptionAction.class == Class ? Java::Security::PrivilegedExceptionAction : Object) do
          extend LocalClass
          include_class_members DNSNameService
          include Java::Security::PrivilegedExceptionAction if Java::Security::PrivilegedExceptionAction.class == Module
          
          typesig { [] }
          define_method :run do
            return ctx.get_attributes(name, ids)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      rescue Java::Security::PrivilegedActionException => pae
        raise UnknownHostException.new(pae.get_exception.get_message)
      end
      # non-requested type returned so enumeration is empty
      ne = attrs.get_all
      if (!ne.has_more_elements)
        raise UnknownHostException.new("DNS record not found")
      end
      # iterate through the returned attributes
      uhe = nil
      begin
        while (ne.has_more_elements)
          attr = ne.next_
          attr_id = attr.get_id
          e = attr.get_all
          while e.has_more_elements
            addr = e.next_
            # for canoncical name records do recursive lookup
            # - also check for CNAME loops to avoid stack overflow
            if ((attr_id == "CNAME"))
              if (depth > 4)
                raise UnknownHostException.new(name + ": possible CNAME loop")
              end
              begin
                results.add_all(resolve(ctx, addr, ids, depth + 1))
              rescue UnknownHostException => x
                # canonical name can't be resolved.
                if ((uhe).nil?)
                  uhe = x
                end
              end
            else
              results.add(addr)
            end
          end
        end
      rescue NamingException => nx
        raise UnknownHostException.new(nx.get_message)
      end
      # pending exception as canonical name could not be resolved.
      if (results.is_empty && !(uhe).nil?)
        raise uhe
      end
      return results
    end
    
    typesig { [] }
    def initialize
      @domain_list = nil
      @name_provider_url = nil
      # default domain
      domain = AccessController.do_privileged(GetPropertyAction.new("sun.net.spi.nameservice.domain"))
      if (!(domain).nil? && domain.length > 0)
        @domain_list = LinkedList.new
        @domain_list.add(domain)
      end
      # name servers
      nameservers_ = AccessController.do_privileged(GetPropertyAction.new("sun.net.spi.nameservice.nameservers"))
      if (!(nameservers_).nil? && nameservers_.length > 0)
        @name_provider_url = RJava.cast_to_string(create_provider_url(nameservers_))
        if ((@name_provider_url.length).equal?(0))
          raise RuntimeException.new("malformed nameservers property")
        end
      else
        # no property specified so check host DNS resolver configured
        # with at least one nameserver in dotted notation.
        ns_list = ResolverConfiguration.open.nameservers
        if ((ns_list.size).equal?(0))
          raise RuntimeException.new("no nameservers provided")
        end
        found = false
        i = ns_list.iterator
        while (i.has_next)
          addr = i.next_
          if (IPAddressUtil.is_ipv4literal_address(addr) || IPAddressUtil.is_ipv6literal_address(addr))
            found = true
            break
          end
        end
        if (!found)
          raise RuntimeException.new("bad nameserver configuration")
        end
      end
    end
    
    typesig { [String] }
    def lookup_all_host_addr(host)
      # DNS records that we search for
      ids = Array.typed(String).new(["A", "AAAA", "CNAME"])
      # first get directory context
      ctx = nil
      begin
        ctx = get_temporary_context
      rescue NamingException => nx
        raise JavaError.new(nx)
      end
      results = nil
      uhe = nil
      # If host already contains a domain name then just look it up
      if (host.index_of(Character.new(?..ord)) >= 0)
        begin
          results = resolve(ctx, host, ids, 0)
        rescue UnknownHostException => x
          uhe = x
        end
      end
      # Here we try to resolve the host using the domain suffix or
      # the domain suffix search list. If the host cannot be resolved
      # using the domain suffix then we attempt devolution of
      # the suffix - eg: if we are searching for "foo" and our
      # domain suffix is "eng.sun.com" we will try to resolve
      # "foo.eng.sun.com" and "foo.sun.com".
      # It's not normal to attempt devolation with domains on the
      # domain suffix search list - however as ResolverConfiguration
      # doesn't distinguish domain or search list in the list it
      # returns we approximate by doing devolution on the domain
      # suffix if the list has one entry.
      if ((results).nil?)
        search_list = nil
        i = nil
        using_search_list = false
        if (!(@domain_list).nil?)
          i = @domain_list.iterator
        else
          search_list = ResolverConfiguration.open.searchlist
          if (search_list.size > 1)
            using_search_list = true
          end
          i = search_list.iterator
        end
        # iterator through each domain suffix
        while (i.has_next)
          parent_domain = i.next_
          start = 0
          while (!((start = parent_domain.index_of("."))).equal?(-1) && start < parent_domain.length - 1)
            begin
              results = resolve(ctx, host + "." + parent_domain, ids, 0)
              break
            rescue UnknownHostException => x
              uhe = x
              if (using_search_list)
                break
              end
              # devolve
              parent_domain = RJava.cast_to_string(parent_domain.substring(start + 1))
            end
          end
          if (!(results).nil?)
            break
          end
        end
      end
      # finally try the host if it doesn't have a domain name
      if ((results).nil? && (host.index_of(Character.new(?..ord)) < 0))
        results = resolve(ctx, host, ids, 0)
      end
      # if not found then throw the (last) exception thrown.
      if ((results).nil?)
        raise AssertError if not (!(uhe).nil?)
        raise uhe
      end
      # Convert the array list into a byte aray list - this
      # filters out any invalid IPv4/IPv6 addresses.
      raise AssertError if not (results.size > 0)
      addrs = Array.typed(InetAddress).new(results.size) { nil }
      count = 0
      i = 0
      while i < results.size
        addr_string = results.get(i)
        addr = IPAddressUtil.text_to_numeric_format_v4(addr_string)
        if ((addr).nil?)
          addr = IPAddressUtil.text_to_numeric_format_v6(addr_string)
        end
        if (!(addr).nil?)
          addrs[((count += 1) - 1)] = InetAddress.get_by_address(host, addr)
        end
        i += 1
      end
      # If addresses are filtered then we need to resize the
      # array. Additionally if all addresses are filtered then
      # we throw an exception.
      if ((count).equal?(0))
        raise UnknownHostException.new(host + ": no valid DNS records")
      end
      if (count < results.size)
        tmp = Array.typed(InetAddress).new(count) { nil }
        i_ = 0
        while i_ < count
          tmp[i_] = addrs[i_]
          i_ += 1
        end
        addrs = tmp
      end
      return addrs
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Reverse lookup code. I.E: find a host name from an IP address.
    # IPv4 addresses are mapped in the IN-ADDR.ARPA. top domain, while
    # IPv6 addresses can be in IP6.ARPA or IP6.INT.
    # In both cases the address has to be converted into a dotted form.
    def get_host_by_addr(addr)
      host = nil
      begin
        literalip = ""
        ids = Array.typed(String).new(["PTR"])
        ctx = nil
        results = nil
        begin
          ctx = get_temporary_context
        rescue NamingException => nx
          raise JavaError.new(nx)
        end
        if ((addr.attr_length).equal?(4))
          # IPv4 Address
          i = addr.attr_length - 1
          while i >= 0
            literalip += RJava.cast_to_string((addr[i] & 0xff)) + "."
            i -= 1
          end
          literalip += "IN-ADDR.ARPA."
          results = resolve(ctx, literalip, ids, 0)
          host = RJava.cast_to_string(results.get(0))
        else
          if ((addr.attr_length).equal?(16))
            # IPv6 Address
            # 
            # Because RFC 3152 changed the root domain name for reverse
            # lookups from IP6.INT. to IP6.ARPA., we need to check
            # both. I.E. first the new one, IP6.ARPA, then if it fails
            # the older one, IP6.INT
            i = addr.attr_length - 1
            while i >= 0
              literalip += RJava.cast_to_string(JavaInteger.to_hex_string((addr[i] & 0xf))) + "." + RJava.cast_to_string(JavaInteger.to_hex_string((addr[i] & 0xf0) >> 4)) + "."
              i -= 1
            end
            ip6lit = literalip + "IP6.ARPA."
            begin
              results = resolve(ctx, ip6lit, ids, 0)
              host = RJava.cast_to_string(results.get(0))
            rescue UnknownHostException => e
              host = RJava.cast_to_string(nil)
            end
            if ((host).nil?)
              # IP6.ARPA lookup failed, let's try the older IP6.INT
              ip6lit = literalip + "IP6.INT."
              results = resolve(ctx, ip6lit, ids, 0)
              host = RJava.cast_to_string(results.get(0))
            end
          end
        end
      rescue JavaException => e
        raise UnknownHostException.new(e.get_message)
      end
      # Either we couldn't find it or the address was neither IPv4 or IPv6
      if ((host).nil?)
        raise UnknownHostException.new
      end
      # remove trailing dot
      if (host.ends_with("."))
        host = RJava.cast_to_string(host.substring(0, host.length - 1))
      end
      return host
    end
    
    class_module.module_eval {
      typesig { [String, StringBuffer] }
      # ---------
      def append_if_literal_address(addr, sb)
        if (IPAddressUtil.is_ipv4literal_address(addr))
          sb.append("dns://" + addr + " ")
        else
          if (IPAddressUtil.is_ipv6literal_address(addr))
            sb.append("dns://[" + addr + "] ")
          end
        end
      end
      
      typesig { [SwtList] }
      # @return String containing the JNDI-DNS provider URL
      # corresponding to the supplied List of nameservers.
      def create_provider_url(ns_list)
        i = ns_list.iterator
        sb = StringBuffer.new
        while (i.has_next)
          append_if_literal_address(i.next_, sb)
        end
        return sb.to_s
      end
      
      typesig { [String] }
      # @return String containing the JNDI-DNS provider URL
      # corresponding to the list of nameservers
      # contained in the provided str.
      def create_provider_url(str)
        sb = StringBuffer.new
        st = StringTokenizer.new(str, ",")
        while (st.has_more_tokens)
          append_if_literal_address(st.next_token, sb)
        end
        return sb.to_s
      end
    }
    
    private
    alias_method :initialize__dnsname_service, :initialize
  end
  
end
