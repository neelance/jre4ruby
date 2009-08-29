require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang::Ref
  module ReferenceImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Ref
      include_const ::Sun::Misc, :Cleaner
    }
  end
  
  # Abstract base class for reference objects.  This class defines the
  # operations common to all reference objects.  Because reference objects are
  # implemented in close cooperation with the garbage collector, this class may
  # not be subclassed directly.
  # 
  # @author   Mark Reinhold
  # @since    1.2
  class Reference 
    include_class_members ReferenceImports
    
    # A Reference instance is in one of four possible internal states:
    # 
    # Active: Subject to special treatment by the garbage collector.  Some
    # time after the collector detects that the reachability of the
    # referent has changed to the appropriate state, it changes the
    # instance's state to either Pending or Inactive, depending upon
    # whether or not the instance was registered with a queue when it was
    # created.  In the former case it also adds the instance to the
    # pending-Reference list.  Newly-created instances are Active.
    # 
    # Pending: An element of the pending-Reference list, waiting to be
    # enqueued by the Reference-handler thread.  Unregistered instances
    # are never in this state.
    # 
    # Enqueued: An element of the queue with which the instance was
    # registered when it was created.  When an instance is removed from
    # its ReferenceQueue, it is made Inactive.  Unregistered instances are
    # never in this state.
    # 
    # Inactive: Nothing more to do.  Once an instance becomes Inactive its
    # state will never change again.
    # 
    # The state is encoded in the queue and next fields as follows:
    # 
    # Active: queue = ReferenceQueue with which instance is registered, or
    # ReferenceQueue.NULL if it was not registered with a queue; next =
    # null.
    # 
    # Pending: queue = ReferenceQueue with which instance is registered;
    # next = Following instance in queue, or this if at end of list.
    # 
    # Enqueued: queue = ReferenceQueue.ENQUEUED; next = Following instance
    # in queue, or this if at end of list.
    # 
    # Inactive: queue = ReferenceQueue.NULL; next = this.
    # 
    # With this scheme the collector need only examine the next field in order
    # to determine whether a Reference instance requires special treatment: If
    # the next field is null then the instance is active; if it is non-null,
    # then the collector should treat the instance normally.
    # 
    # To ensure that concurrent collector can discover active Reference
    # objects without interfering with application threads that may apply
    # the enqueue() method to those objects, collectors should link
    # discovered objects through the discovered field.
    attr_accessor :referent
    alias_method :attr_referent, :referent
    undef_method :referent
    alias_method :attr_referent=, :referent=
    undef_method :referent=
    
    # Treated specially by GC
    attr_accessor :queue
    alias_method :attr_queue, :queue
    undef_method :queue
    alias_method :attr_queue=, :queue=
    undef_method :queue=
    
    attr_accessor :next
    alias_method :attr_next, :next
    undef_method :next
    alias_method :attr_next=, :next=
    undef_method :next=
    
    attr_accessor :discovered
    alias_method :attr_discovered, :discovered
    undef_method :discovered
    alias_method :attr_discovered=, :discovered=
    undef_method :discovered=
    
    class_module.module_eval {
      # used by VM
      # Object used to synchronize with the garbage collector.  The collector
      # must acquire this lock at the beginning of each collection cycle.  It is
      # therefore critical that any code holding this lock complete as quickly
      # as possible, allocate no new objects, and avoid calling user code.
      const_set_lazy(:Lock) { Class.new do
        include_class_members Reference
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__lock, :initialize
      end }
      
      
      def lock
        defined?(@@lock) ? @@lock : @@lock= Lock.new
      end
      alias_method :attr_lock, :lock
      
      def lock=(value)
        @@lock = value
      end
      alias_method :attr_lock=, :lock=
      
      # List of References waiting to be enqueued.  The collector adds
      # References to this list, while the Reference-handler thread removes
      # them.  This list is protected by the above lock object.
      
      def pending
        defined?(@@pending) ? @@pending : @@pending= nil
      end
      alias_method :attr_pending, :pending
      
      def pending=(value)
        @@pending = value
      end
      alias_method :attr_pending=, :pending=
      
      # High-priority thread to enqueue pending References
      const_set_lazy(:ReferenceHandler) { Class.new(JavaThread) do
        include_class_members Reference
        
        typesig { [class_self::JavaThreadGroup, String] }
        def initialize(g, name)
          super(g, name)
        end
        
        typesig { [] }
        def run
          loop do
            r = nil
            synchronized((self.attr_lock)) do
              if (!(self.attr_pending).nil?)
                r = self.attr_pending
                rn = r.attr_next
                self.attr_pending = ((rn).equal?(r)) ? nil : rn
                r.attr_next = r
              else
                begin
                  self.attr_lock.wait
                rescue self.class::InterruptedException => x
                end
                next
              end
            end
            # Fast path for cleaners
            if (r.is_a?(self.class::Cleaner))
              (r).clean
              next
            end
            q = r.attr_queue
            if (!(q).equal?(ReferenceQueue::NULL))
              q.enqueue(r)
            end
          end
        end
        
        private
        alias_method :initialize__reference_handler, :initialize
      end }
      
      when_class_loaded do
        tg = JavaThread.current_thread.get_thread_group
        tgn = tg
        while !(tgn).nil?
          tg = tgn
          tgn = tg.get_parent
        end
        handler = ReferenceHandler.new(tg, "Reference Handler")
        # If there were a special system-only priority greater than
        # MAX_PRIORITY, it would be used here
        handler.set_priority(JavaThread::MAX_PRIORITY)
        handler.set_daemon(true)
        handler.start
      end
    }
    
    typesig { [] }
    # -- Referent accessor and setters --
    # 
    # Returns this reference object's referent.  If this reference object has
    # been cleared, either by the program or by the garbage collector, then
    # this method returns <code>null</code>.
    # 
    # @return   The object to which this reference refers, or
    # <code>null</code> if this reference object has been cleared
    def get
      return @referent
    end
    
    typesig { [] }
    # Clears this reference object.  Invoking this method will not cause this
    # object to be enqueued.
    # 
    # <p> This method is invoked only by Java code; when the garbage collector
    # clears references it does so directly, without invoking this method.
    def clear
      @referent = nil
    end
    
    typesig { [] }
    # -- Queue operations --
    # 
    # Tells whether or not this reference object has been enqueued, either by
    # the program or by the garbage collector.  If this reference object was
    # not registered with a queue when it was created, then this method will
    # always return <code>false</code>.
    # 
    # @return   <code>true</code> if and only if this reference object has
    # been enqueued
    def is_enqueued
      # In terms of the internal states, this predicate actually tests
      # whether the instance is either Pending or Enqueued
      synchronized((self)) do
        return (!(@queue).equal?(ReferenceQueue::NULL)) && (!(@next).nil?)
      end
    end
    
    typesig { [] }
    # Adds this reference object to the queue with which it is registered,
    # if any.
    # 
    # <p> This method is invoked only by Java code; when the garbage collector
    # enqueues references it does so directly, without invoking this method.
    # 
    # @return   <code>true</code> if this reference object was successfully
    # enqueued; <code>false</code> if it was already enqueued or if
    # it was not registered with a queue when it was created
    def enqueue
      return @queue.enqueue(self)
    end
    
    typesig { [Object] }
    # -- Constructors --
    def initialize(referent)
      initialize__reference(referent, nil)
    end
    
    typesig { [Object, ReferenceQueue] }
    def initialize(referent, queue)
      @referent = nil
      @queue = nil
      @next = nil
      @discovered = nil
      @referent = referent
      @queue = ((queue).nil?) ? ReferenceQueue::NULL : queue
    end
    
    private
    alias_method :initialize__reference, :initialize
  end
  
end
