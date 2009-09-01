require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Http
  module KeepAliveCacheImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Http
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :NotSerializableException
      include ::Java::Util
      include_const ::Java::Net, :URL
      include_const ::Java::Util::Concurrent, :ConcurrentHashMap
    }
  end
  
  # A class that implements a cache of idle Http connections for keep-alive
  # 
  # @author Stephen R. Pietrowicz (NCSA)
  # @author Dave Brown
  class KeepAliveCache < KeepAliveCacheImports.const_get :ConcurrentHashMap
    include_class_members KeepAliveCacheImports
    overload_protected {
      include Runnable
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -2937172892064557949 }
      const_attr_reader  :SerialVersionUID
      
      # maximum # keep-alive connections to maintain at once
      # This should be 2 by the HTTP spec, but because we don't support pipe-lining
      # a larger value is more appropriate. So we now set a default of 5, and the value
      # refers to the number of idle connections per destination (in the cache) only.
      # It can be reset by setting system property "http.maxConnections".
      const_set_lazy(:MAX_CONNECTIONS) { 5 }
      const_attr_reader  :MAX_CONNECTIONS
      
      
      def result
        defined?(@@result) ? @@result : @@result= -1
      end
      alias_method :attr_result, :result
      
      def result=(value)
        @@result = value
      end
      alias_method :attr_result=, :result=
      
      typesig { [] }
      def get_max_connections
        if ((self.attr_result).equal?(-1))
          self.attr_result = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetIntegerAction.new("http.maxConnections", MAX_CONNECTIONS)).int_value
          if (self.attr_result <= 0)
            self.attr_result = MAX_CONNECTIONS
          end
        end
        return self.attr_result
      end
      
      const_set_lazy(:LIFETIME) { 5000 }
      const_attr_reader  :LIFETIME
    }
    
    attr_accessor :keep_alive_timer
    alias_method :attr_keep_alive_timer, :keep_alive_timer
    undef_method :keep_alive_timer
    alias_method :attr_keep_alive_timer=, :keep_alive_timer=
    undef_method :keep_alive_timer=
    
    typesig { [] }
    # Constructor
    def initialize
      @keep_alive_timer = nil
      super()
      @keep_alive_timer = nil
    end
    
    typesig { [URL, Object, HttpClient] }
    # Register this URL and HttpClient (that supports keep-alive) with the cache
    # @param url  The URL contains info about the host and port
    # @param http The HttpClient to be cached
    def put(url, obj, http)
      synchronized(self) do
        start_thread = ((@keep_alive_timer).nil?)
        if (!start_thread)
          if (!@keep_alive_timer.is_alive)
            start_thread = true
          end
        end
        if (start_thread)
          clear
          # Unfortunately, we can't always believe the keep-alive timeout we got
          # back from the server.  If I'm connected through a Netscape proxy
          # to a server that sent me a keep-alive
          # time of 15 sec, the proxy unilaterally terminates my connection
          # The robustness to to get around this is in HttpClient.parseHTTP()
          cache = self
          Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members KeepAliveCache
            include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              # We want to create the Keep-Alive-Timer in the
              # system threadgroup
              grp = JavaThread.current_thread.get_thread_group
              parent = nil
              while (!((parent = grp.get_parent)).nil?)
                grp = parent
              end
              self.attr_keep_alive_timer = self.class::JavaThread.new(grp, cache, "Keep-Alive-Timer")
              self.attr_keep_alive_timer.set_daemon(true)
              self.attr_keep_alive_timer.set_priority(JavaThread::MAX_PRIORITY - 2)
              self.attr_keep_alive_timer.start
              return nil
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        key = KeepAliveKey.new(url, obj)
        v = ConcurrentHashMap.instance_method(:get).bind(self).call(key)
        if ((v).nil?)
          keep_alive_timeout = http.get_keep_alive_timeout
          v = ClientVector.new(keep_alive_timeout > 0 ? keep_alive_timeout * 1000 : LIFETIME)
          v.put(http)
          super(key, v)
        else
          v.put(http)
        end
      end
    end
    
    typesig { [HttpClient, Object] }
    # remove an obsolete HttpClient from it's VectorCache
    def remove(h, obj)
      synchronized(self) do
        key = KeepAliveKey.new(h.attr_url, obj)
        v = ConcurrentHashMap.instance_method(:get).bind(self).call(key)
        if (!(v).nil?)
          v.remove(h)
          if (v.empty)
            remove_vector(key)
          end
        end
      end
    end
    
    typesig { [KeepAliveKey] }
    # called by a clientVector thread when all it's connections have timed out
    # and that vector of connections should be removed.
    def remove_vector(k)
      synchronized(self) do
        ConcurrentHashMap.instance_method(:remove).bind(self).call(k)
      end
    end
    
    typesig { [URL, Object] }
    # Check to see if this URL has a cached HttpClient
    def get(url, obj)
      synchronized(self) do
        key = KeepAliveKey.new(url, obj)
        v = super(key)
        if ((v).nil?)
          # nothing in cache yet
          return nil
        end
        return v.get
      end
    end
    
    typesig { [] }
    # Sleeps for an alloted timeout, then checks for timed out connections.
    # Errs on the side of caution (leave connections idle for a relatively
    # short time).
    def run
      total_cache = 0
      begin
        begin
          JavaThread.sleep(LIFETIME)
        rescue InterruptedException => e
        end
        synchronized((self)) do
          # Remove all unused HttpClients.  Starting from the
          # bottom of the stack (the least-recently used first).
          # REMIND: It'd be nice to not remove *all* connections
          # that aren't presently in use.  One could have been added
          # a second ago that's still perfectly valid, and we're
          # needlessly axing it.  But it's not clear how to do this
          # cleanly, and doing it right may be more trouble than it's
          # worth.
          current_time = System.current_time_millis
          itr = key_set.iterator
          keys_to_remove = ArrayList.new
          while (itr.has_next)
            key = itr.next_
            v = get(key)
            synchronized((v)) do
              i = 0
              i = 0
              while i < v.size
                e = v.element_at(i)
                if ((current_time - e.attr_idle_start_time) > v.attr_nap)
                  h = e.attr_hc
                  h.close_server
                else
                  break
                end
                i += 1
              end
              v.sub_list(0, i).clear
              if ((v.size).equal?(0))
                keys_to_remove.add(key)
              end
            end
          end
          itr = keys_to_remove.iterator
          while (itr.has_next)
            remove_vector(itr.next_)
          end
        end
      end while (size > 0)
      return
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Do not serialize this class!
    def write_object(stream)
      raise NotSerializableException.new
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    def read_object(stream)
      raise NotSerializableException.new
    end
    
    private
    alias_method :initialize__keep_alive_cache, :initialize
  end
  
  # FILO order for recycling HttpClients, should run in a thread
  # to time them out.  If > maxConns are in use, block.
  class ClientVector < Java::Util::Stack
    include_class_members KeepAliveCacheImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -8680532108106489459 }
      const_attr_reader  :SerialVersionUID
    }
    
    # sleep time in milliseconds, before cache clear
    attr_accessor :nap
    alias_method :attr_nap, :nap
    undef_method :nap
    alias_method :attr_nap=, :nap=
    undef_method :nap=
    
    typesig { [::Java::Int] }
    def initialize(nap)
      @nap = 0
      super()
      @nap = nap
    end
    
    typesig { [] }
    def get
      synchronized(self) do
        if (empty)
          return nil
        else
          # Loop until we find a connection that has not timed out
          hc = nil
          current_time = System.current_time_millis
          begin
            e = pop
            if ((current_time - e.attr_idle_start_time) > @nap)
              e.attr_hc.close_server
            else
              hc = e.attr_hc
            end
          end while (((hc).nil?) && (!empty))
          return hc
        end
      end
    end
    
    typesig { [HttpClient] }
    # return a still valid, unused HttpClient
    def put(h)
      synchronized(self) do
        if (size > KeepAliveCache.get_max_connections)
          h.close_server # otherwise the connection remains in limbo
        else
          push(KeepAliveEntry.new(h, System.current_time_millis))
        end
      end
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Do not serialize this class!
    def write_object(stream)
      raise NotSerializableException.new
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    def read_object(stream)
      raise NotSerializableException.new
    end
    
    private
    alias_method :initialize__client_vector, :initialize
  end
  
  class KeepAliveKey 
    include_class_members KeepAliveCacheImports
    
    attr_accessor :protocol
    alias_method :attr_protocol, :protocol
    undef_method :protocol
    alias_method :attr_protocol=, :protocol=
    undef_method :protocol=
    
    attr_accessor :host
    alias_method :attr_host, :host
    undef_method :host
    alias_method :attr_host=, :host=
    undef_method :host=
    
    attr_accessor :port
    alias_method :attr_port, :port
    undef_method :port
    alias_method :attr_port=, :port=
    undef_method :port=
    
    attr_accessor :obj
    alias_method :attr_obj, :obj
    undef_method :obj
    alias_method :attr_obj=, :obj=
    undef_method :obj=
    
    typesig { [URL, Object] }
    # additional key, such as socketfactory
    # 
    # Constructor
    # 
    # @param url the URL containing the protocol, host and port information
    def initialize(url, obj)
      @protocol = nil
      @host = nil
      @port = 0
      @obj = nil
      @protocol = url.get_protocol
      @host = url.get_host
      @port = url.get_port
      @obj = obj
    end
    
    typesig { [Object] }
    # Determine whether or not two objects of this type are equal
    def ==(obj)
      if (((obj.is_a?(KeepAliveKey))).equal?(false))
        return false
      end
      kae = obj
      return (@host == kae.attr_host) && ((@port).equal?(kae.attr_port)) && (@protocol == kae.attr_protocol) && (@obj).equal?(kae.attr_obj)
    end
    
    typesig { [] }
    # The hashCode() for this object is the string hashCode() of
    # concatenation of the protocol, host name and port.
    def hash_code
      str = @protocol + @host + RJava.cast_to_string(@port)
      return (@obj).nil? ? str.hash_code : str.hash_code + @obj.hash_code
    end
    
    private
    alias_method :initialize__keep_alive_key, :initialize
  end
  
  class KeepAliveEntry 
    include_class_members KeepAliveCacheImports
    
    attr_accessor :hc
    alias_method :attr_hc, :hc
    undef_method :hc
    alias_method :attr_hc=, :hc=
    undef_method :hc=
    
    attr_accessor :idle_start_time
    alias_method :attr_idle_start_time, :idle_start_time
    undef_method :idle_start_time
    alias_method :attr_idle_start_time=, :idle_start_time=
    undef_method :idle_start_time=
    
    typesig { [HttpClient, ::Java::Long] }
    def initialize(hc, idle_start_time)
      @hc = nil
      @idle_start_time = 0
      @hc = hc
      @idle_start_time = idle_start_time
    end
    
    private
    alias_method :initialize__keep_alive_entry, :initialize
  end
  
end
