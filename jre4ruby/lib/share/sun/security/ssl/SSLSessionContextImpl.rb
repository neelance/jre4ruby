require "rjava"

# Copyright 1999-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module SSLSessionContextImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include ::Java::Net
      include_const ::Java::Util, :JavaDate
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :NoSuchElementException
      include_const ::Java::Util, :Vector
      include_const ::Javax::Net::Ssl, :SSLSession
      include_const ::Javax::Net::Ssl, :SSLSessionContext
      include_const ::Javax::Net::Ssl, :SSLSessionBindingListener
      include_const ::Javax::Net::Ssl, :SSLSessionBindingEvent
      include_const ::Javax::Net::Ssl, :SSLPeerUnverifiedException
      include_const ::Javax::Net::Ssl, :SSLSession
      include_const ::Sun::Misc, :Cache
    }
  end
  
  class SSLSessionContextImpl 
    include_class_members SSLSessionContextImplImports
    include SSLSessionContext
    
    attr_accessor :session_cache
    alias_method :attr_session_cache, :session_cache
    undef_method :session_cache
    alias_method :attr_session_cache=, :session_cache=
    undef_method :session_cache=
    
    attr_accessor :session_host_port_cache
    alias_method :attr_session_host_port_cache, :session_host_port_cache
    undef_method :session_host_port_cache
    alias_method :attr_session_host_port_cache=, :session_host_port_cache=
    undef_method :session_host_port_cache=
    
    attr_accessor :cache_limit
    alias_method :attr_cache_limit, :cache_limit
    undef_method :cache_limit
    alias_method :attr_cache_limit=, :cache_limit=
    undef_method :cache_limit=
    
    attr_accessor :timeout_millis
    alias_method :attr_timeout_millis, :timeout_millis
    undef_method :timeout_millis
    alias_method :attr_timeout_millis=, :timeout_millis=
    undef_method :timeout_millis=
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("ssl") }
      const_attr_reader  :Debug
    }
    
    typesig { [] }
    # file private
    def initialize
      @session_cache = Cache.new
      @session_host_port_cache = Cache.new
      @cache_limit = 0
      @timeout_millis = 0
      @cache_limit = get_cache_limit
      @timeout_millis = 86400000 # default, 24 hours
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Returns the SSL session object associated with the
    # specific session ID passed.
    def get_session(id)
      sess = @session_cache.get(SessionId.new(id))
      return check_time_validity(sess)
    end
    
    typesig { [] }
    # Returns an enumeration of the active SSL sessions.
    def get_ids
      v = Vector.new(@session_cache.size)
      sess_id = nil
      e = @session_cache.keys
      while e.has_more_elements
        sess_id = e.next_element
        if (!is_timedout(@session_cache.get(sess_id)))
          v.add_element(sess_id.get_id)
        end
      end
      return v.elements
    end
    
    typesig { [::Java::Int] }
    def set_session_timeout(seconds)
      if (seconds < 0)
        raise IllegalArgumentException.new
      end
      @timeout_millis = seconds * 1000
    end
    
    typesig { [] }
    def get_session_timeout
      return ((@timeout_millis / 1000)).to_int
    end
    
    typesig { [::Java::Int] }
    def set_session_cache_size(size_)
      if (size_ < 0)
        raise IllegalArgumentException.new
      end
      @cache_limit = size_
      # If cache size limit is reduced, when the cache is full to its
      # previous limit, trim the cache before its contents
      # are used.
      if ((!(@cache_limit).equal?(0)) && (@session_cache.size > @cache_limit))
        adjust_cache_size_to(@cache_limit)
      end
    end
    
    typesig { [] }
    def get_session_cache_size
      return @cache_limit
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def get(id)
      return get_session(id)
    end
    
    typesig { [String, ::Java::Int] }
    # Returns the SSL session object associated with the
    # specific host name and port number passed.
    def get(hostname, port)
      # If no session caching info is available, we won't
      # get one, so exit before doing a lookup.
      if ((hostname).nil? && (port).equal?(-1))
        return nil
      end
      sess = @session_host_port_cache.get(get_key(hostname, port))
      return check_time_validity(sess)
    end
    
    typesig { [String, ::Java::Int] }
    def get_key(hostname, port)
      return (hostname + ":" + RJava.cast_to_string(String.value_of(port))).to_lower_case
    end
    
    typesig { [SSLSessionImpl] }
    def put(s)
      # make space for the new session to be added
      if ((!(@cache_limit).equal?(0)) && (@session_cache.size >= @cache_limit))
        adjust_cache_size_to(@cache_limit - 1)
      end
      # Can always add the session id.
      @session_cache.put(s.get_session_id, s)
      # If no hostname/port info is available, don't add this one.
      if ((!(s.get_peer_host).nil?) && (!(s.get_peer_port).equal?(-1)))
        @session_host_port_cache.put(get_key(s.get_peer_host, s.get_peer_port), s)
      end
      s.set_context(self)
    end
    
    typesig { [::Java::Int] }
    def adjust_cache_size_to(target_size)
      cache_size = @session_cache.size
      if (target_size < 0)
        return
      end
      while (cache_size > target_size)
        lru = nil
        s = nil
        e = nil
        if (!(Debug).nil? && Debug.is_on("sessioncache"))
          System.out.println("exceeded cache limit of " + RJava.cast_to_string(@cache_limit))
        end
        # Count the number of elements in the cache. The size() method
        # does not reflect the cache entries that are no longer available,
        # i.e entries that are garbage collected (the cache entries are
        # held using soft references and are garbage collected when not
        # in use).
        count = 0
        count = 0
        e = @session_cache.elements
        while e.has_more_elements
          begin
            s = e.next_element
          rescue NoSuchElementException => nsee
            break
          end
          if (is_timedout(s))
            lru = s
            break
          else
            if (((lru).nil?) || (s.get_last_accessed_time < lru.get_last_accessed_time))
              lru = s
            end
          end
          count += 1
        end
        if ((!(lru).nil?) && (count > target_size))
          if (!(Debug).nil? && Debug.is_on("sessioncache"))
            System.out.println("uncaching " + RJava.cast_to_string(lru))
          end
          lru.invalidate
          count -= 1 # element removed from the cache
        end
        cache_size = count
      end
    end
    
    typesig { [SessionId] }
    # file private
    def remove(key)
      s = @session_cache.get(key)
      @session_cache.remove(key)
      @session_host_port_cache.remove(get_key(s.get_peer_host, s.get_peer_port))
    end
    
    typesig { [] }
    def get_cache_limit
      cache_limit = 0
      begin
        s = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
          local_class_in SSLSessionContextImpl
          include_class_members SSLSessionContextImpl
          include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return System.get_property("javax.net.ssl.sessionCacheSize")
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        cache_limit = (!(s).nil?) ? JavaInteger.value_of(s).int_value : 0
      rescue JavaException => e
      end
      return (cache_limit > 0) ? cache_limit : 0
    end
    
    typesig { [SSLSession] }
    def check_time_validity(sess)
      if (is_timedout(sess))
        sess.invalidate
        return nil
      else
        return sess
      end
    end
    
    typesig { [SSLSession] }
    def is_timedout(sess)
      if ((@timeout_millis).equal?(0))
        return false
      end
      if ((!(sess).nil?) && ((sess.get_creation_time + @timeout_millis) <= (System.current_time_millis)))
        return true
      end
      return false
    end
    
    private
    alias_method :initialize__sslsession_context_impl, :initialize
  end
  
end
