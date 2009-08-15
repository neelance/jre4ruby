require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Net
  module ResponseCacheImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaList
      include_const ::Sun::Security::Util, :SecurityConstants
    }
  end
  
  # Represents implementations of URLConnection caches. An instance of
  # such a class can be registered with the system by doing
  # ResponseCache.setDefault(ResponseCache), and the system will call
  # this object in order to:
  # 
  # <ul><li>store resource data which has been retrieved from an
  # external source into the cache</li>
  # <li>try to fetch a requested resource that may have been
  # stored in the cache</li>
  # </ul>
  # 
  # The ResponseCache implementation decides which resources
  # should be cached, and for how long they should be cached. If a
  # request resource cannot be retrieved from the cache, then the
  # protocol handlers will fetch the resource from its original
  # location.
  # 
  # The settings for URLConnection#useCaches controls whether the
  # protocol is allowed to use a cached response.
  # 
  # For more information on HTTP caching, see <a
  # href="http://www.ietf.org/rfc/rfc2616.txt""><i>RFC&nbsp;2616: Hypertext
  # Transfer Protocol -- HTTP/1.1</i></a>
  # 
  # @author Yingxian Wang
  # @since 1.5
  class ResponseCache 
    include_class_members ResponseCacheImports
    
    class_module.module_eval {
      # The system wide cache that provides access to a url
      # caching mechanism.
      # 
      # @see #setDefault(ResponseCache)
      # @see #getDefault()
      
      def the_response_cache
        defined?(@@the_response_cache) ? @@the_response_cache : @@the_response_cache= nil
      end
      alias_method :attr_the_response_cache, :the_response_cache
      
      def the_response_cache=(value)
        @@the_response_cache = value
      end
      alias_method :attr_the_response_cache=, :the_response_cache=
      
      typesig { [] }
      # Gets the system-wide response cache.
      # 
      # @throws  SecurityException
      # If a security manager has been installed and it denies
      # {@link NetPermission}<tt>("getResponseCache")</tt>
      # 
      # @see #setDefault(ResponseCache)
      # @return the system-wide <code>ResponseCache</code>
      # @since 1.5
      def get_default
        synchronized(self) do
          sm = System.get_security_manager
          if (!(sm).nil?)
            sm.check_permission(SecurityConstants::GET_RESPONSECACHE_PERMISSION)
          end
          return self.attr_the_response_cache
        end
      end
      
      typesig { [ResponseCache] }
      # Sets (or unsets) the system-wide cache.
      # 
      # Note: non-standard procotol handlers may ignore this setting.
      # 
      # @param responseCache The response cache, or
      # <code>null</code> to unset the cache.
      # 
      # @throws  SecurityException
      # If a security manager has been installed and it denies
      # {@link NetPermission}<tt>("setResponseCache")</tt>
      # 
      # @see #getDefault()
      # @since 1.5
      def set_default(response_cache)
        synchronized(self) do
          sm = System.get_security_manager
          if (!(sm).nil?)
            sm.check_permission(SecurityConstants::SET_RESPONSECACHE_PERMISSION)
          end
          self.attr_the_response_cache = response_cache
        end
      end
    }
    
    typesig { [URI, String, Map] }
    # Retrieve the cached response based on the requesting uri,
    # request method and request headers. Typically this method is
    # called by the protocol handler before it sends out the request
    # to get the network resource. If a cached response is returned,
    # that resource is used instead.
    # 
    # @param uri a <code>URI</code> used to reference the requested
    # network resource
    # @param rqstMethod a <code>String</code> representing the request
    # method
    # @param rqstHeaders - a Map from request header
    # field names to lists of field values representing
    # the current request headers
    # @return a <code>CacheResponse</code> instance if available
    # from cache, or null otherwise
    # @throws  IOException if an I/O error occurs
    # @throws  IllegalArgumentException if any one of the arguments is null
    # 
    # @see     java.net.URLConnection#setUseCaches(boolean)
    # @see     java.net.URLConnection#getUseCaches()
    # @see     java.net.URLConnection#setDefaultUseCaches(boolean)
    # @see     java.net.URLConnection#getDefaultUseCaches()
    def get(uri, rqst_method, rqst_headers)
      raise NotImplementedError
    end
    
    typesig { [URI, URLConnection] }
    # The protocol handler calls this method after a resource has
    # been retrieved, and the ResponseCache must decide whether or
    # not to store the resource in its cache. If the resource is to
    # be cached, then put() must return a CacheRequest object which
    # contains an OutputStream that the protocol handler will
    # use to write the resource into the cache. If the resource is
    # not to be cached, then put must return null.
    # 
    # @param uri a <code>URI</code> used to reference the requested
    # network resource
    # @param conn - a URLConnection instance that is used to fetch
    # the response to be cached
    # @return a <code>CacheRequest</code> for recording the
    # response to be cached. Null return indicates that
    # the caller does not intend to cache the response.
    # @throws IOException if an I/O error occurs
    # @throws IllegalArgumentException if any one of the arguments is
    # null
    def put(uri, conn)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__response_cache, :initialize
  end
  
end
