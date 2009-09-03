require "rjava"

# Copyright 1998-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net
  module InetAddressCachePolicyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :Security
    }
  end
  
  class InetAddressCachePolicy 
    include_class_members InetAddressCachePolicyImports
    
    class_module.module_eval {
      # Controls the cache policy for successful lookups only
      const_set_lazy(:CachePolicyProp) { "networkaddress.cache.ttl" }
      const_attr_reader  :CachePolicyProp
      
      const_set_lazy(:CachePolicyPropFallback) { "sun.net.inetaddr.ttl" }
      const_attr_reader  :CachePolicyPropFallback
      
      # Controls the cache policy for negative lookups only
      const_set_lazy(:NegativeCachePolicyProp) { "networkaddress.cache.negative.ttl" }
      const_attr_reader  :NegativeCachePolicyProp
      
      const_set_lazy(:NegativeCachePolicyPropFallback) { "sun.net.inetaddr.negative.ttl" }
      const_attr_reader  :NegativeCachePolicyPropFallback
      
      const_set_lazy(:FOREVER) { -1 }
      const_attr_reader  :FOREVER
      
      const_set_lazy(:NEVER) { 0 }
      const_attr_reader  :NEVER
      
      # default value for positive lookups
      const_set_lazy(:DEFAULT_POSITIVE) { 30 }
      const_attr_reader  :DEFAULT_POSITIVE
      
      # The Java-level namelookup cache policy for successful lookups:
      # 
      # -1: caching forever
      # any positive value: the number of seconds to cache an address for
      # 
      # default value is forever (FOREVER), as we let the platform do the
      # caching. For security reasons, this caching is made forever when
      # a security manager is set.
      
      def cache_policy
        defined?(@@cache_policy) ? @@cache_policy : @@cache_policy= 0
      end
      alias_method :attr_cache_policy, :cache_policy
      
      def cache_policy=(value)
        @@cache_policy = value
      end
      alias_method :attr_cache_policy=, :cache_policy=
      
      # The Java-level namelookup cache policy for negative lookups:
      # 
      # -1: caching forever
      # any positive value: the number of seconds to cache an address for
      # 
      # default value is 0. It can be set to some other value for
      # performance reasons.
      
      def negative_cache_policy
        defined?(@@negative_cache_policy) ? @@negative_cache_policy : @@negative_cache_policy= 0
      end
      alias_method :attr_negative_cache_policy, :negative_cache_policy
      
      def negative_cache_policy=(value)
        @@negative_cache_policy = value
      end
      alias_method :attr_negative_cache_policy=, :negative_cache_policy=
      
      # Whether or not the cache policy for successful lookups was set
      # using a property (cmd line).
      
      def set
        defined?(@@set) ? @@set : @@set= false
      end
      alias_method :attr_set, :set
      
      def set=(value)
        @@set = value
      end
      alias_method :attr_set=, :set=
      
      # Whether or not the cache policy for negative lookups was set
      # using a property (cmd line).
      
      def negative_set
        defined?(@@negative_set) ? @@negative_set : @@negative_set= false
      end
      alias_method :attr_negative_set, :negative_set
      
      def negative_set=(value)
        @@negative_set = value
      end
      alias_method :attr_negative_set=, :negative_set=
      
      # Initialize
      when_class_loaded do
        self.attr_set = false
        self.attr_negative_set = false
        self.attr_cache_policy = FOREVER
        self.attr_negative_cache_policy = 0
        tmp = nil
        begin
          tmp = Java::Security::AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members InetAddressCachePolicy
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              return Security.get_property(CachePolicyProp)
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        rescue NumberFormatException => e
          # ignore
        end
        if (!(tmp).nil?)
          self.attr_cache_policy = tmp.int_value
          if (self.attr_cache_policy < 0)
            self.attr_cache_policy = FOREVER
          end
          self.attr_set = true
        else
          tmp = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetIntegerAction.new(CachePolicyPropFallback))
          if (!(tmp).nil?)
            self.attr_cache_policy = tmp.int_value
            if (self.attr_cache_policy < 0)
              self.attr_cache_policy = FOREVER
            end
            self.attr_set = true
          end
        end
        begin
          tmp = Java::Security::AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members InetAddressCachePolicy
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              return Security.get_property(NegativeCachePolicyProp)
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        rescue NumberFormatException => e
          # ignore
        end
        if (!(tmp).nil?)
          self.attr_negative_cache_policy = tmp.int_value
          if (self.attr_negative_cache_policy < 0)
            self.attr_negative_cache_policy = FOREVER
          end
          self.attr_negative_set = true
        else
          tmp = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetIntegerAction.new(NegativeCachePolicyPropFallback))
          if (!(tmp).nil?)
            self.attr_negative_cache_policy = tmp.int_value
            if (self.attr_negative_cache_policy < 0)
              self.attr_negative_cache_policy = FOREVER
            end
            self.attr_negative_set = true
          end
        end
      end
      
      typesig { [] }
      def get
        synchronized(self) do
          if (!self.attr_set && (System.get_security_manager).nil?)
            return DEFAULT_POSITIVE
          else
            return self.attr_cache_policy
          end
        end
      end
      
      typesig { [] }
      def get_negative
        synchronized(self) do
          return self.attr_negative_cache_policy
        end
      end
      
      typesig { [::Java::Int] }
      # Sets the cache policy for successful lookups if the user has not
      # already specified a cache policy for it using a
      # command-property.
      # @param newPolicy the value in seconds for how long the lookup
      # should be cached
      def set_if_not_set(new_policy)
        synchronized(self) do
          # When setting the new value we may want to signal that the
          # cache should be flushed, though this doesn't seem strictly
          # necessary.
          if (!self.attr_set)
            check_value(new_policy, self.attr_cache_policy)
            self.attr_cache_policy = new_policy
          end
        end
      end
      
      typesig { [::Java::Int] }
      # Sets the cache policy for negative lookups if the user has not
      # already specified a cache policy for it using a
      # command-property.
      # @param newPolicy the value in seconds for how long the lookup
      # should be cached
      def set_negative_if_not_set(new_policy)
        synchronized(self) do
          # When setting the new value we may want to signal that the
          # cache should be flushed, though this doesn't seem strictly
          # necessary.
          if (!self.attr_negative_set)
            # Negative caching does not seem to have any security
            # implications.
            # checkValue(newPolicy, negativeCachePolicy);
            self.attr_negative_cache_policy = new_policy
          end
        end
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      def check_value(new_policy, old_policy)
        # If malicious code gets a hold of this method, prevent
        # setting the cache policy to something laxer or some
        # invalid negative value.
        if ((new_policy).equal?(FOREVER))
          return
        end
        if (((old_policy).equal?(FOREVER)) || (new_policy < old_policy) || (new_policy < FOREVER))
          raise SecurityException.new("can't make InetAddress cache more lax")
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__inet_address_cache_policy, :initialize
  end
  
end
