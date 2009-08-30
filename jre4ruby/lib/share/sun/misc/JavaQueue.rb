require "rjava"

# Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module QueueImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :NoSuchElementException
    }
  end
  
  # Queue: implements a simple queue mechanism.  Allows for enumeration of the
  # elements.
  # 
  # @author Herb Jellinek
  class JavaQueue 
    include_class_members QueueImports
    
    attr_accessor :length
    alias_method :attr_length, :length
    undef_method :length
    alias_method :attr_length=, :length=
    undef_method :length=
    
    attr_accessor :head
    alias_method :attr_head, :head
    undef_method :head
    alias_method :attr_head=, :head=
    undef_method :head=
    
    attr_accessor :tail
    alias_method :attr_tail, :tail
    undef_method :tail
    alias_method :attr_tail=, :tail=
    undef_method :tail=
    
    typesig { [] }
    def initialize
      @length = 0
      @head = nil
      @tail = nil
    end
    
    typesig { [Object] }
    # Enqueue an object.
    def enqueue(obj)
      synchronized(self) do
        new_elt = QueueElement.new(obj)
        if ((@head).nil?)
          @head = new_elt
          @tail = new_elt
          @length = 1
        else
          new_elt.attr_next = @head
          @head.attr_prev = new_elt
          @head = new_elt
          @length += 1
        end
        notify
      end
    end
    
    typesig { [] }
    # Dequeue the oldest object on the queue.  Will wait indefinitely.
    # 
    # @return    the oldest object on the queue.
    # @exception java.lang.InterruptedException if any thread has
    # interrupted this thread.
    def dequeue
      return dequeue(0)
    end
    
    typesig { [::Java::Long] }
    # Dequeue the oldest object on the queue.
    # @param timeOut the number of milliseconds to wait for something
    # to arrive.
    # 
    # @return    the oldest object on the queue.
    # @exception java.lang.InterruptedException if any thread has
    # interrupted this thread.
    def dequeue(time_out)
      synchronized(self) do
        while ((@tail).nil?)
          wait(time_out)
        end
        elt = @tail
        @tail = elt.attr_prev
        if ((@tail).nil?)
          @head = nil
        else
          @tail.attr_next = nil
        end
        @length -= 1
        return elt.attr_obj
      end
    end
    
    typesig { [] }
    # Is the queue empty?
    # @return true if the queue is empty.
    def is_empty
      synchronized(self) do
        return ((@tail).nil?)
      end
    end
    
    typesig { [] }
    # Returns an enumeration of the elements in Last-In, First-Out
    # order. Use the Enumeration methods on the returned object to
    # fetch the elements sequentially.
    def elements
      synchronized(self) do
        return LIFOQueueEnumerator.new(self)
      end
    end
    
    typesig { [] }
    # Returns an enumeration of the elements in First-In, First-Out
    # order. Use the Enumeration methods on the returned object to
    # fetch the elements sequentially.
    def reverse_elements
      synchronized(self) do
        return FIFOQueueEnumerator.new(self)
      end
    end
    
    typesig { [String] }
    def dump(msg)
      synchronized(self) do
        System.err.println(">> " + msg)
        System.err.println("[" + RJava.cast_to_string(@length) + " elt(s); head = " + RJava.cast_to_string(((@head).nil? ? "null" : RJava.cast_to_string((@head.attr_obj)) + "")) + " tail = " + RJava.cast_to_string(((@tail).nil? ? "null" : RJava.cast_to_string((@tail.attr_obj)) + "")))
        cursor = @head
        last = nil
        while (!(cursor).nil?)
          System.err.println("  " + RJava.cast_to_string(cursor))
          last = cursor
          cursor = cursor.attr_next
        end
        if (!(last).equal?(@tail))
          System.err.println("  tail != last: " + RJava.cast_to_string(@tail) + ", " + RJava.cast_to_string(last))
        end
        System.err.println("]")
      end
    end
    
    private
    alias_method :initialize__queue, :initialize
  end
  
  class FIFOQueueEnumerator 
    include_class_members QueueImports
    include Enumeration
    
    attr_accessor :queue
    alias_method :attr_queue, :queue
    undef_method :queue
    alias_method :attr_queue=, :queue=
    undef_method :queue=
    
    attr_accessor :cursor
    alias_method :attr_cursor, :cursor
    undef_method :cursor
    alias_method :attr_cursor=, :cursor=
    undef_method :cursor=
    
    typesig { [JavaQueue] }
    def initialize(q)
      @queue = nil
      @cursor = nil
      @queue = q
      @cursor = q.attr_tail
    end
    
    typesig { [] }
    def has_more_elements
      return (!(@cursor).nil?)
    end
    
    typesig { [] }
    def next_element
      synchronized((@queue)) do
        if (!(@cursor).nil?)
          result = @cursor
          @cursor = @cursor.attr_prev
          return result.attr_obj
        end
      end
      raise NoSuchElementException.new("FIFOQueueEnumerator")
    end
    
    private
    alias_method :initialize__fifoqueue_enumerator, :initialize
  end
  
  class LIFOQueueEnumerator 
    include_class_members QueueImports
    include Enumeration
    
    attr_accessor :queue
    alias_method :attr_queue, :queue
    undef_method :queue
    alias_method :attr_queue=, :queue=
    undef_method :queue=
    
    attr_accessor :cursor
    alias_method :attr_cursor, :cursor
    undef_method :cursor
    alias_method :attr_cursor=, :cursor=
    undef_method :cursor=
    
    typesig { [JavaQueue] }
    def initialize(q)
      @queue = nil
      @cursor = nil
      @queue = q
      @cursor = q.attr_head
    end
    
    typesig { [] }
    def has_more_elements
      return (!(@cursor).nil?)
    end
    
    typesig { [] }
    def next_element
      synchronized((@queue)) do
        if (!(@cursor).nil?)
          result = @cursor
          @cursor = @cursor.attr_next
          return result.attr_obj
        end
      end
      raise NoSuchElementException.new("LIFOQueueEnumerator")
    end
    
    private
    alias_method :initialize__lifoqueue_enumerator, :initialize
  end
  
  class QueueElement 
    include_class_members QueueImports
    
    attr_accessor :next
    alias_method :attr_next, :next
    undef_method :next
    alias_method :attr_next=, :next=
    undef_method :next=
    
    attr_accessor :prev
    alias_method :attr_prev, :prev
    undef_method :prev
    alias_method :attr_prev=, :prev=
    undef_method :prev=
    
    attr_accessor :obj
    alias_method :attr_obj, :obj
    undef_method :obj
    alias_method :attr_obj=, :obj=
    undef_method :obj=
    
    typesig { [Object] }
    def initialize(obj)
      @next = nil
      @prev = nil
      @obj = nil
      @obj = obj
    end
    
    typesig { [] }
    def to_s
      return "QueueElement[obj=" + RJava.cast_to_string(@obj) + RJava.cast_to_string(((@prev).nil? ? " null" : " prev")) + RJava.cast_to_string(((@next).nil? ? " null" : " next")) + "]"
    end
    
    private
    alias_method :initialize__queue_element, :initialize
  end
  
end
