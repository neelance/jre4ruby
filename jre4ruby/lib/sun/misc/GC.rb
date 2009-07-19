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
module Sun::Misc
  module GCImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Util, :SortedSet
      include_const ::Java::Util, :TreeSet
    }
  end
  
  # Support for garbage-collection latency requests.
  # 
  # @author   Mark Reinhold
  # @since    1.2
  class GC 
    include_class_members GCImports
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      # To prevent instantiation
      # Latency-target value indicating that there's no active target
      const_set_lazy(:NO_TARGET) { Long::MAX_VALUE }
      const_attr_reader  :NO_TARGET
      
      # The current latency target, or NO_TARGET if there is no target
      
      def latency_target
        defined?(@@latency_target) ? @@latency_target : @@latency_target= NO_TARGET
      end
      alias_method :attr_latency_target, :latency_target
      
      def latency_target=(value)
        @@latency_target = value
      end
      alias_method :attr_latency_target=, :latency_target=
      
      # The daemon thread that implements the latency-target mechanism,
      # or null if there is presently no daemon thread
      
      def daemon
        defined?(@@daemon) ? @@daemon : @@daemon= nil
      end
      alias_method :attr_daemon, :daemon
      
      def daemon=(value)
        @@daemon = value
      end
      alias_method :attr_daemon=, :daemon=
      
      # The lock object for the latencyTarget and daemon fields.  The daemon
      # thread, if it exists, waits on this lock for notification that the
      # latency target has changed.
      const_set_lazy(:LatencyLock) { Class.new(Object) do
        include_class_members GC
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__latency_lock, :initialize
      end }
      
      
      def lock
        defined?(@@lock) ? @@lock : @@lock= LatencyLock.new
      end
      alias_method :attr_lock, :lock
      
      def lock=(value)
        @@lock = value
      end
      alias_method :attr_lock=, :lock=
      
      JNI.native_method :Java_sun_misc_GC_maxObjectInspectionAge, [:pointer, :long], :int64
      typesig { [] }
      # Returns the maximum <em>object-inspection age</em>, which is the number
      # of real-time milliseconds that have elapsed since the
      # least-recently-inspected heap object was last inspected by the garbage
      # collector.
      # 
      # <p> For simple stop-the-world collectors this value is just the time
      # since the most recent collection.  For generational collectors it is the
      # time since the oldest generation was most recently collected.  Other
      # collectors are free to return a pessimistic estimate of the elapsed
      # time, or simply the time since the last full collection was performed.
      # 
      # <p> Note that in the presence of reference objects, a given object that
      # is no longer strongly reachable may have to be inspected multiple times
      # before it can be reclaimed.
      def max_object_inspection_age
        JNI.__send__(:Java_sun_misc_GC_maxObjectInspectionAge, JNI.env, self.jni_id)
      end
      
      const_set_lazy(:Daemon) { Class.new(JavaThread) do
        include_class_members GC
        
        typesig { [] }
        def run
          loop do
            l = 0
            synchronized((self.attr_lock)) do
              l = self.attr_latency_target
              if ((l).equal?(NO_TARGET))
                # No latency target, so exit
                GC.attr_daemon = nil
                return
              end
              d = max_object_inspection_age
              if (d >= l)
                # Do a full collection.  There is a remote possibility
                # that a full collection will occurr between the time
                # we sample the inspection age and the time the GC
                # actually starts, but this is sufficiently unlikely
                # that it doesn't seem worth the more expensive JVM
                # interface that would be required.
                System.gc
                d = 0
              end
              # Wait for the latency period to expire,
              # or for notification that the period has changed
              begin
                self.attr_lock.wait(l - d)
              rescue InterruptedException => x
                next
              end
            end
          end
        end
        
        typesig { [JavaThreadGroup] }
        def initialize(tg)
          super(tg, "GC Daemon")
        end
        
        class_module.module_eval {
          typesig { [] }
          # Create a new daemon thread in the root thread group
          def create
            pa = Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
              extend LocalClass
              include_class_members Daemon
              include PrivilegedAction if PrivilegedAction.class == Module
              
              typesig { [] }
              define_method :run do
                tg = JavaThread.current_thread.get_thread_group
                tgn = tg
                while !(tgn).nil?
                  tg = tgn
                  tgn = tg.get_parent
                end
                d = Daemon.new(tg)
                d.set_daemon(true)
                d.set_priority(JavaThread::MIN_PRIORITY + 1)
                d.start
                GC.attr_daemon = d
                return nil
              end
              
              typesig { [] }
              define_method :initialize do
                super()
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self)
            AccessController.do_privileged(pa)
          end
        }
        
        private
        alias_method :initialize__daemon, :initialize
      end }
      
      typesig { [::Java::Long] }
      # Sets the latency target to the given value.
      # Must be invoked while holding the lock.
      def set_latency_target(ms)
        self.attr_latency_target = ms
        if ((self.attr_daemon).nil?)
          # Create a new daemon thread
          Daemon.create
        else
          # Notify the existing daemon thread
          # that the lateency target has changed
          self.attr_lock.notify
        end
      end
      
      # Represents an active garbage-collection latency request.  Instances of
      # this class are created by the <code>{@link #requestLatency}</code>
      # method.  Given a request, the only interesting operation is that of
      # cancellation.
      const_set_lazy(:LatencyRequest) { Class.new do
        include_class_members GC
        include JavaComparable
        
        class_module.module_eval {
          # Instance counter, used to generate unique identifers
          
          def counter
            defined?(@@counter) ? @@counter : @@counter= 0
          end
          alias_method :attr_counter, :counter
          
          def counter=(value)
            @@counter = value
          end
          alias_method :attr_counter=, :counter=
          
          # Sorted set of active latency requests
          
          def requests
            defined?(@@requests) ? @@requests : @@requests= nil
          end
          alias_method :attr_requests, :requests
          
          def requests=(value)
            @@requests = value
          end
          alias_method :attr_requests=, :requests=
          
          typesig { [] }
          # Examine the request set and reset the latency target if necessary.
          # Must be invoked while holding the lock.
          def adjust_latency_if_needed
            if (((self.attr_requests).nil?) || self.attr_requests.is_empty)
              if (!(self.attr_latency_target).equal?(NO_TARGET))
                set_latency_target(NO_TARGET)
              end
            else
              r = self.attr_requests.first
              if (!(r.attr_latency).equal?(self.attr_latency_target))
                set_latency_target(r.attr_latency)
              end
            end
          end
        }
        
        # The requested latency, or NO_TARGET
        # if this request has been cancelled
        attr_accessor :latency
        alias_method :attr_latency, :latency
        undef_method :latency
        alias_method :attr_latency=, :latency=
        undef_method :latency=
        
        # Unique identifier for this request
        attr_accessor :id
        alias_method :attr_id, :id
        undef_method :id
        alias_method :attr_id=, :id=
        undef_method :id=
        
        typesig { [::Java::Long] }
        def initialize(ms)
          @latency = 0
          @id = 0
          if (ms <= 0)
            raise IllegalArgumentException.new("Non-positive latency: " + (ms).to_s)
          end
          @latency = ms
          synchronized((self.attr_lock)) do
            @id = (self.attr_counter += 1)
            if ((self.attr_requests).nil?)
              self.attr_requests = TreeSet.new
            end
            self.attr_requests.add(self)
            adjust_latency_if_needed
          end
        end
        
        typesig { [] }
        # Cancels this latency request.
        # 
        # @throws  IllegalStateException
        # If this request has already been cancelled
        def cancel
          synchronized((self.attr_lock)) do
            if ((@latency).equal?(NO_TARGET))
              raise IllegalStateException.new("Request already" + " cancelled")
            end
            if (!self.attr_requests.remove(self))
              raise InternalError.new("Latency request " + (self).to_s + " not found")
            end
            if (self.attr_requests.is_empty)
              self.attr_requests = nil
            end
            @latency = NO_TARGET
            adjust_latency_if_needed
          end
        end
        
        typesig { [Object] }
        def compare_to(o)
          r = o
          d = @latency - r.attr_latency
          if ((d).equal?(0))
            d = @id - r.attr_id
          end
          return (d < 0) ? -1 : ((d > 0) ? +1 : 0)
        end
        
        typesig { [] }
        def to_s
          return ((LatencyRequest.class.get_name).to_s + "[" + (@latency).to_s + "," + (@id).to_s + "]")
        end
        
        private
        alias_method :initialize__latency_request, :initialize
      end }
      
      typesig { [::Java::Long] }
      # Makes a new request for a garbage-collection latency of the given
      # number of real-time milliseconds.  A low-priority daemon thread makes a
      # best effort to ensure that the maximum object-inspection age never
      # exceeds the smallest of the currently active requests.
      # 
      # @param   latency
      # The requested latency
      # 
      # @throws  IllegalArgumentException
      # If the given <code>latency</code> is non-positive
      def request_latency(latency)
        return LatencyRequest.new(latency)
      end
      
      typesig { [] }
      # Returns the current smallest garbage-collection latency request, or zero
      # if there are no active requests.
      def current_latency_target
        t = self.attr_latency_target
        return ((t).equal?(NO_TARGET)) ? 0 : t
      end
    }
    
    private
    alias_method :initialize__gc, :initialize
  end
  
end
