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
  module ResolverConfigurationImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Dns
      include_const ::Java::Util, :JavaList
      include_const ::Java::Io, :IOException
    }
  end
  
  # The configuration of the client resolver.
  # 
  # <p>A ResolverConfiguration is a singleton that represents the
  # configuration of the client resolver. The ResolverConfiguration
  # is opened by invoking the {@link #open() open} method.
  # 
  # @since 1.4
  class ResolverConfiguration 
    include_class_members ResolverConfigurationImports
    
    class_module.module_eval {
      const_set_lazy(:Lock) { Object.new }
      const_attr_reader  :Lock
      
      
      def provider
        defined?(@@provider) ? @@provider : @@provider= nil
      end
      alias_method :attr_provider, :provider
      
      def provider=(value)
        @@provider = value
      end
      alias_method :attr_provider=, :provider=
    }
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      typesig { [] }
      # Opens the resolver configuration.
      # 
      # @return the resolver configuration
      def open
        synchronized((Lock)) do
          if ((self.attr_provider).nil?)
            self.attr_provider = Sun::Net::Dns::ResolverConfigurationImpl.new
          end
          return self.attr_provider
        end
      end
    }
    
    typesig { [] }
    # Returns a list corresponding to the domain search path. The
    # list is ordered by the search order used for host name lookup.
    # Each element in the list returns a {@link java.lang.String}
    # containing a domain name or suffix.
    # 
    # @return list of domain names
    def searchlist
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a list of name servers used for host name lookup.
    # Each element in the list returns a {@link java.lang.String}
    # containing the textual representation of the IP address of
    # the name server.
    # 
    # @return list of the name servers
    def nameservers
      raise NotImplementedError
    end
    
    class_module.module_eval {
      # Options representing certain resolver variables of
      # a {@link ResolverConfiguration}.
      const_set_lazy(:Options) { Class.new do
        include_class_members ResolverConfiguration
        
        typesig { [] }
        # Returns the maximum number of attempts the resolver
        # will connect to each name server before giving up
        # and returning an error.
        # 
        # @return the resolver attempts value or -1 is unknown
        def attempts
          return -1
        end
        
        typesig { [] }
        # Returns the basic retransmit timeout, in milliseconds,
        # used by the resolver. The resolver will typically use
        # an exponential backoff algorithm where the timeout is
        # doubled for every retransmit attempt. The basic
        # retransmit timeout, returned here, is the initial
        # timeout for the exponential backoff algorithm.
        # 
        # @return the basic retransmit timeout value or -1
        # if unknown
        def retrans
          return -1
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__options, :initialize
      end }
    }
    
    typesig { [] }
    # Returns the {@link #Options} for the resolver.
    # 
    # @return options for the resolver
    def options
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__resolver_configuration, :initialize
  end
  
end
