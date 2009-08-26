require "rjava"

# Copyright 1997-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ReferenceQueueImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Ref
    }
  end
  
  # Reference queues, to which registered reference objects are appended by the
  # garbage collector after the appropriate reachability changes are detected.
  # 
  # @author   Mark Reinhold
  # @since    1.2
  class ReferenceQueue 
    include_class_members ReferenceQueueImports
    
    typesig { [] }
    # Constructs a new reference-object queue.
    def initialize
      @lock = Lock.new
      @head = nil
      @queue_length = 0
    end
    
    class_module.module_eval {
      const_set_lazy(:Null) { Class.new(ReferenceQueue) do
        include_class_members ReferenceQueue
        
        typesig { [self::Reference] }
        def enqueue(r)
          return false
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__null, :initialize
      end }
      
      
      def null
        defined?(@@null) ? @@null : @@null= Null.new
      end
      alias_method :attr_null, :null
      
      def null=(value)
        @@null = value
      end
      alias_method :attr_null=, :null=
      
      
      def enqueued
        defined?(@@enqueued) ? @@enqueued : @@enqueued= Null.new
      end
      alias_method :attr_enqueued, :enqueued
      
      def enqueued=(value)
        @@enqueued = value
      end
      alias_method :attr_enqueued=, :enqueued=
      
      const_set_lazy(:Lock) { Class.new do
        include_class_members ReferenceQueue
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__lock, :initialize
      end }
    }
    
    attr_accessor :lock
    alias_method :attr_lock, :lock
    undef_method :lock
    alias_method :attr_lock=, :lock=
    undef_method :lock=
    
    attr_accessor :head
    alias_method :attr_head, :head
    undef_method :head
    alias_method :attr_head=, :head=
    undef_method :head=
    
    attr_accessor :queue_length
    alias_method :attr_queue_length, :queue_length
    undef_method :queue_length
    alias_method :attr_queue_length=, :queue_length=
    undef_method :queue_length=
    
    typesig { [Reference] }
    def enqueue(r)
      # Called only by Reference class
      synchronized((r)) do
        if ((r.attr_queue).equal?(self.attr_enqueued))
          return false
        end
        synchronized((@lock)) do
          r.attr_queue = self.attr_enqueued
          r.attr_next = ((@head).nil?) ? r : @head
          @head = r
          @queue_length += 1
          if (r.is_a?(FinalReference))
            Sun::Misc::VM.add_final_ref_count(1)
          end
          @lock.notify_all
          return true
        end
      end
    end
    
    typesig { [] }
    def really_poll
      # Must hold lock
      if (!(@head).nil?)
        r = @head
        @head = ((r.attr_next).equal?(r)) ? nil : r.attr_next
        r.attr_queue = self.attr_null
        r.attr_next = r
        @queue_length -= 1
        if (r.is_a?(FinalReference))
          Sun::Misc::VM.add_final_ref_count(-1)
        end
        return r
      end
      return nil
    end
    
    typesig { [] }
    # Polls this queue to see if a reference object is available.  If one is
    # available without further delay then it is removed from the queue and
    # returned.  Otherwise this method immediately returns <tt>null</tt>.
    # 
    # @return  A reference object, if one was immediately available,
    # otherwise <code>null</code>
    def poll
      synchronized((@lock)) do
        return really_poll
      end
    end
    
    typesig { [::Java::Long] }
    # Removes the next reference object in this queue, blocking until either
    # one becomes available or the given timeout period expires.
    # 
    # <p> This method does not offer real-time guarantees: It schedules the
    # timeout as if by invoking the {@link Object#wait(long)} method.
    # 
    # @param  timeout  If positive, block for up to <code>timeout</code>
    # milliseconds while waiting for a reference to be
    # added to this queue.  If zero, block indefinitely.
    # 
    # @return  A reference object, if one was available within the specified
    # timeout period, otherwise <code>null</code>
    # 
    # @throws  IllegalArgumentException
    # If the value of the timeout argument is negative
    # 
    # @throws  InterruptedException
    # If the timeout wait is interrupted
    def remove(timeout)
      if (timeout < 0)
        raise IllegalArgumentException.new("Negative timeout value")
      end
      synchronized((@lock)) do
        r = really_poll
        if (!(r).nil?)
          return r
        end
        loop do
          @lock.wait(timeout)
          r = really_poll
          if (!(r).nil?)
            return r
          end
          if (!(timeout).equal?(0))
            return nil
          end
        end
      end
    end
    
    typesig { [] }
    # Removes the next reference object in this queue, blocking until one
    # becomes available.
    # 
    # @return A reference object, blocking until one becomes available
    # @throws  InterruptedException  If the wait is interrupted
    def remove
      return remove(0)
    end
    
    private
    alias_method :initialize__reference_queue, :initialize
  end
  
end
