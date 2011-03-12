require "rjava"

# Copyright 1995 Sun Microsystems, Inc.  All Rights Reserved.
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
  module TimerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
    }
  end
  
  # A Timer object is used by algorithms that require timed events.
  # For example, in an animation loop, a timer would help in
  # determining when to change frames.
  # 
  # A timer has an interval which determines when it "ticks";
  # that is, a timer delays for the specified interval and then
  # it calls the owner's tick() method.
  # 
  # Here's an example of creating a timer with a 5 sec interval:
  # 
  # <pre>
  # class Main implements Timeable {
  #     public void tick(Timer timer) {
  #         System.out.println("tick");
  #     }
  #     public static void main(String args[]) {
  #         (new Timer(this, 5000)).cont();
  #     }
  # }
  # </pre>
  # 
  # A timer can be stopped, continued, or reset at any time.
  # A timer's state is not stopped while it's calling the
  # owner's tick() method.
  # 
  # A timer can be regular or irregular.  If in regular mode,
  # a timer ticks at the specified interval, regardless of
  # how long the owner's tick() method takes.  While the timer
  # is running, no ticks are ever discarded.  That means that if
  # the owner's tick() method takes longer than the interval,
  # the ticks that would have occurred are delivered immediately.
  # 
  # In irregular mode, a timer starts delaying for exactly
  # the specified interval only after the tick() method returns.
  # 
  # Synchronization issues: do not hold the timer's monitor
  # while calling any of the Timer operations below otherwise
  # the Timer class will deadlock.
  # 
  # @author     Patrick Chan
  # Synchronization issues:  there are two data structures that
  # require locking.  A Timer object and the Timer queue
  # (described in the TimerThread class).  To avoid deadlock,
  # the timer queue monitor is always acquired before the timer
  # object's monitor.  However, the timer queue monitor is acquired
  # only if the timer operation will make use of the timer
  # queue, e.g. stop().
  # 
  # The class monitor on the class TimerThread severs as the monitor
  # to the timer queue.
  # 
  # Possible feature: perhaps a timer should have an associated
  # thread priority.  The thread that makes the callback temporarily
  # takes on that priority before calling the owner's tick() method.
  class Timer 
    include_class_members TimerImports
    
    # This is the owner of the timer.  Its tick method is
    # called when the timer ticks.
    attr_accessor :owner
    alias_method :attr_owner, :owner
    undef_method :owner
    alias_method :attr_owner=, :owner=
    undef_method :owner=
    
    # This is the interval of time in ms.
    attr_accessor :interval
    alias_method :attr_interval, :interval
    undef_method :interval
    alias_method :attr_interval=, :interval=
    undef_method :interval=
    
    # This variable is used for two different purposes.
    # This is done in order to save space.
    # If 'stopped' is true, this variable holds the time
    # that the timer was stopped; otherwise, this variable
    # is used by the TimerThread to determine when the timer
    # should tick.
    attr_accessor :sleep_until
    alias_method :attr_sleep_until, :sleep_until
    undef_method :sleep_until
    alias_method :attr_sleep_until=, :sleep_until=
    undef_method :sleep_until=
    
    # This is the time remaining before the timer ticks.  It
    # is only valid if 'stopped' is true.  If the timer is
    # continued, the next tick will happen remaingTime
    # milliseconds later.
    attr_accessor :remaining_time
    alias_method :attr_remaining_time, :remaining_time
    undef_method :remaining_time
    alias_method :attr_remaining_time=, :remaining_time=
    undef_method :remaining_time=
    
    # True iff the timer is in regular mode.
    attr_accessor :regular
    alias_method :attr_regular, :regular
    undef_method :regular
    alias_method :attr_regular=, :regular=
    undef_method :regular=
    
    # True iff the timer has been stopped.
    attr_accessor :stopped
    alias_method :attr_stopped, :stopped
    undef_method :stopped
    alias_method :attr_stopped=, :stopped=
    undef_method :stopped=
    
    # Timer queue-related variables
    # A link to another timer object.  This is used while the
    # timer object is enqueued in the timer queue.
    attr_accessor :next
    alias_method :attr_next, :next
    undef_method :next
    alias_method :attr_next=, :next=
    undef_method :next=
    
    class_module.module_eval {
      # Timer methods
      # This variable holds a handle to the TimerThread class for
      # the purpose of getting at the class monitor.  The reason
      # why Class.forName("TimerThread") is not used is because it
      # doesn't appear to work when loaded via a net class loader.
      
      def timer_thread
        defined?(@@timer_thread) ? @@timer_thread : @@timer_thread= nil
      end
      alias_method :attr_timer_thread, :timer_thread
      
      def timer_thread=(value)
        @@timer_thread = value
      end
      alias_method :attr_timer_thread=, :timer_thread=
    }
    
    typesig { [Timeable, ::Java::Long] }
    # Creates a timer object that is owned by 'owner' and
    # with the interval 'interval' milliseconds.  The new timer
    # object is stopped and is regular.  getRemainingTime()
    # return 'interval' at this point.  getStopTime() returns
    # the time this object was created.
    # @param owner    owner of the timer object
    # @param interval interval of the timer in milliseconds
    def initialize(owner, interval)
      @owner = nil
      @interval = 0
      @sleep_until = 0
      @remaining_time = 0
      @regular = false
      @stopped = false
      @next = nil
      @owner = owner
      @interval = interval
      @remaining_time = interval
      @regular = true
      @sleep_until = System.current_time_millis
      @stopped = true
      synchronized((get_class)) do
        if ((self.attr_timer_thread).nil?)
          self.attr_timer_thread = TimerThread.new
        end
      end
    end
    
    typesig { [] }
    # Returns true if this timer is stopped.
    def is_stopped
      synchronized(self) do
        return @stopped
      end
    end
    
    typesig { [] }
    # Stops the timer.  The amount of time the timer has already
    # delayed is saved so if the timer is continued, it will only
    # delay for the amount of time remaining.
    # Note that even after stopping a timer, one more tick may
    # still occur.
    # This method is MT-safe; i.e. it is synchronized but for
    # implementation reasons, the synchronized modifier cannot
    # be included in the method declaration.
    def stop
      now = System.current_time_millis
      synchronized((self.attr_timer_thread)) do
        synchronized((self)) do
          if (!@stopped)
            TimerThread.dequeue(self)
            @remaining_time = Math.max(0, @sleep_until - now)
            @sleep_until = now # stop time
            @stopped = true
          end
        end
      end
    end
    
    typesig { [] }
    # Continue the timer.  The next tick will come at getRemainingTime()
    # milliseconds later.  If the timer is not stopped, this
    # call will be a no-op.
    # This method is MT-safe; i.e. it is synchronized but for
    # implementation reasons, the synchronized modifier cannot
    # be included in the method declaration.
    def cont
      synchronized((self.attr_timer_thread)) do
        synchronized((self)) do
          if (@stopped)
            # The TimerTickThread avoids requeuing the
            # timer only if the sleepUntil value has changed.
            # The following guarantees that the sleepUntil
            # value will be different; without this guarantee,
            # it's theoretically possible for the timer to be
            # inserted twice.
            @sleep_until = Math.max(@sleep_until + 1, System.current_time_millis + @remaining_time)
            TimerThread.enqueue(self)
            @stopped = false
          end
        end
      end
    end
    
    typesig { [] }
    # Resets the timer's remaining time to the timer's interval.
    # If the timer's running state is not altered.
    def reset
      synchronized((self.attr_timer_thread)) do
        synchronized((self)) do
          set_remaining_time(@interval)
        end
      end
    end
    
    typesig { [] }
    # Returns the time at which the timer was last stopped.  The
    # return value is valid only if the timer is stopped.
    def get_stop_time
      synchronized(self) do
        return @sleep_until
      end
    end
    
    typesig { [] }
    # Returns the timer's interval.
    def get_interval
      synchronized(self) do
        return @interval
      end
    end
    
    typesig { [::Java::Long] }
    # Changes the timer's interval.  The new interval setting
    # does not take effect until after the next tick.
    # This method does not alter the remaining time or the
    # running state of the timer.
    # @param interval new interval of the timer in milliseconds
    def set_interval(interval)
      synchronized(self) do
        @interval = interval
      end
    end
    
    typesig { [] }
    # Returns the remaining time before the timer's next tick.
    # The return value is valid only if timer is stopped.
    def get_remaining_time
      synchronized(self) do
        return @remaining_time
      end
    end
    
    typesig { [::Java::Long] }
    # Sets the remaining time before the timer's next tick.
    # This method does not alter the timer's running state.
    # This method is MT-safe; i.e. it is synchronized but for
    # implementation reasons, the synchronized modifier cannot
    # be included in the method declaration.
    # @param time new remaining time in milliseconds.
    def set_remaining_time(time)
      synchronized((self.attr_timer_thread)) do
        synchronized((self)) do
          if (@stopped)
            @remaining_time = time
          else
            stop
            @remaining_time = time
            cont
          end
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # In regular mode, a timer ticks at the specified interval,
    # regardless of how long the owner's tick() method takes.
    # While the timer is running, no ticks are ever discarded.
    # That means that if the owner's tick() method takes longer
    # than the interval, the ticks that would have occurred are
    # delivered immediately.
    # 
    # In irregular mode, a timer starts delaying for exactly
    # the specified interval only after the tick() method returns.
    def set_regular(regular)
      synchronized(self) do
        @regular = regular
      end
    end
    
    typesig { [] }
    # This method is used only for testing purposes.
    def get_timer_thread
      return TimerThread.attr_timer_thread
    end
    
    private
    alias_method :initialize__timer, :initialize
  end
  
  # This class implements the timer queue and is exclusively used by the
  # Timer class.  There are only two methods exported to the Timer class -
  # enqueue, for inserting a timer into queue and dequeue, for removing
  # a timer from the queue.
  # 
  # A timer in the timer queue is awaiting a tick.  When a timer is to be
  # ticked, it is removed from the timer queue before the owner's tick()
  # method is called.
  # 
  # A single timer thread manages the timer queue.  This timer thread
  # looks at the head of the timer queue and delays until it's time for
  # the timer to tick.  When the time comes, the timer thread creates a
  # callback thread to call the timer owner's tick() method.  The timer
  # thread then processes the next timer in the queue.
  # 
  # When a timer is inserted at the head of the queue, the timer thread is
  # notified.  This causes the timer thread to prematurely wake up and
  # process the new head of the queue.
  class TimerThread < TimerImports.const_get :JavaThread
    include_class_members TimerImports
    
    class_module.module_eval {
      # Set to true to get debugging output.
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= false
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      # This is a handle to the thread managing the thread queue.
      
      def timer_thread
        defined?(@@timer_thread) ? @@timer_thread : @@timer_thread= nil
      end
      alias_method :attr_timer_thread, :timer_thread
      
      def timer_thread=(value)
        @@timer_thread = value
      end
      alias_method :attr_timer_thread=, :timer_thread=
      
      # This flag is set if the timer thread has been notified
      # while it was in the timed wait.  This flag allows the
      # timer thread to tell whether or not the wait completed.
      
      def notified
        defined?(@@notified) ? @@notified : @@notified= false
      end
      alias_method :attr_notified, :notified
      
      def notified=(value)
        @@notified = value
      end
      alias_method :attr_notified=, :notified=
    }
    
    typesig { [] }
    def initialize
      super("TimerThread")
      self.attr_timer_thread = self
      start
    end
    
    typesig { [] }
    def run
      synchronized(self) do
        while (true)
          delay = 0
          while ((self.attr_timer_queue).nil?)
            begin
              wait
            rescue InterruptedException => ex
              # Just drop through and check timerQueue.
            end
          end
          self.attr_notified = false
          delay = self.attr_timer_queue.attr_sleep_until - System.current_time_millis
          if (delay > 0)
            begin
              wait(delay)
            rescue InterruptedException => ex
              # Just drop through.
            end
          end
          # remove from timer queue.
          if (!self.attr_notified)
            timer = self.attr_timer_queue
            self.attr_timer_queue = self.attr_timer_queue.attr_next
            thr = TimerTickThread.call(timer, timer.attr_sleep_until)
            if (self.attr_debug)
              delta = (System.current_time_millis - timer.attr_sleep_until)
              System.out.println("tick(" + RJava.cast_to_string(thr.get_name) + "," + RJava.cast_to_string(timer.attr_interval) + "," + RJava.cast_to_string(delta) + ")")
              if (delta > 250)
                System.out.println("*** BIG DELAY ***")
              end
            end
          end
        end
      end
    end
    
    class_module.module_eval {
      # Timer Queue
      # The timer queue is a queue of timers waiting to tick.
      
      def timer_queue
        defined?(@@timer_queue) ? @@timer_queue : @@timer_queue= nil
      end
      alias_method :attr_timer_queue, :timer_queue
      
      def timer_queue=(value)
        @@timer_queue = value
      end
      alias_method :attr_timer_queue=, :timer_queue=
      
      typesig { [Timer] }
      # Uses timer.sleepUntil to determine where in the queue
      # to insert the timer object.
      # A new ticker thread is created only if the timer
      # is inserted at the beginning of the queue.
      # The timer must not already be in the queue.
      # Assumes the caller has the TimerThread monitor.
      def enqueue(timer)
        prev = nil
        cur = self.attr_timer_queue
        if ((cur).nil? || timer.attr_sleep_until <= cur.attr_sleep_until)
          # insert at front of queue
          timer.attr_next = self.attr_timer_queue
          self.attr_timer_queue = timer
          self.attr_notified = true
          self.attr_timer_thread.notify
        else
          begin
            prev = cur
            cur = cur.attr_next
          end while (!(cur).nil? && timer.attr_sleep_until > cur.attr_sleep_until)
          # insert or append to the timer queue
          timer.attr_next = cur
          prev.attr_next = timer
        end
        if (self.attr_debug)
          now = System.current_time_millis
          System.out.print(RJava.cast_to_string(JavaThread.current_thread.get_name) + ": enqueue " + RJava.cast_to_string(timer.attr_interval) + ": ")
          cur = self.attr_timer_queue
          while (!(cur).nil?)
            delta = cur.attr_sleep_until - now
            System.out.print(RJava.cast_to_string(cur.attr_interval) + "(" + RJava.cast_to_string(delta) + ") ")
            cur = cur.attr_next
          end
          System.out.println
        end
      end
      
      typesig { [Timer] }
      # If the timer is not in the queue, returns false;
      # otherwise removes the timer from the timer queue and returns true.
      # Assumes the caller has the TimerThread monitor.
      def dequeue(timer)
        prev = nil
        cur = self.attr_timer_queue
        while (!(cur).nil? && !(cur).equal?(timer))
          prev = cur
          cur = cur.attr_next
        end
        if ((cur).nil?)
          if (self.attr_debug)
            System.out.println(RJava.cast_to_string(JavaThread.current_thread.get_name) + ": dequeue " + RJava.cast_to_string(timer.attr_interval) + ": no-op")
          end
          return false
        end
        if ((prev).nil?)
          self.attr_timer_queue = timer.attr_next
          self.attr_notified = true
          self.attr_timer_thread.notify
        else
          prev.attr_next = timer.attr_next
        end
        timer.attr_next = nil
        if (self.attr_debug)
          now = System.current_time_millis
          System.out.print(RJava.cast_to_string(JavaThread.current_thread.get_name) + ": dequeue " + RJava.cast_to_string(timer.attr_interval) + ": ")
          cur = self.attr_timer_queue
          while (!(cur).nil?)
            delta = cur.attr_sleep_until - now
            System.out.print(RJava.cast_to_string(cur.attr_interval) + "(" + RJava.cast_to_string(delta) + ") ")
            cur = cur.attr_next
          end
          System.out.println
        end
        return true
      end
      
      typesig { [Timer] }
      # Inserts the timer back into the queue.  This method
      # is used by a callback thread after it has called the
      # timer owner's tick() method.  This method recomputes
      # the sleepUntil field.
      # Assumes the caller has the TimerThread and Timer monitor.
      def requeue(timer)
        if (!timer.attr_stopped)
          now = System.current_time_millis
          if (timer.attr_regular)
            timer.attr_sleep_until += timer.attr_interval
          else
            timer.attr_sleep_until = now + timer.attr_interval
          end
          enqueue(timer)
        else
          if (self.attr_debug)
            System.out.println(RJava.cast_to_string(JavaThread.current_thread.get_name) + ": requeue " + RJava.cast_to_string(timer.attr_interval) + ": no-op")
          end
        end
      end
    }
    
    private
    alias_method :initialize__timer_thread, :initialize
  end
  
  # This class implements a simple thread whose only purpose is to call a
  # timer owner's tick() method.  A small fixed-sized pool of threads is
  # maintained and is protected by the class monitor.  If the pool is
  # exhausted, a new thread is temporarily created and destroyed when
  # done.
  # 
  # A thread that's in the pool waits on it's own monitor.  When the
  # thread is retrieved from the pool, the retriever notifies the thread's
  # monitor.
  class TimerTickThread < TimerImports.const_get :JavaThread
    include_class_members TimerImports
    
    class_module.module_eval {
      # Maximum size of the thread pool.
      const_set_lazy(:MAX_POOL_SIZE) { 3 }
      const_attr_reader  :MAX_POOL_SIZE
      
      # Number of threads in the pool.
      
      def cur_pool_size
        defined?(@@cur_pool_size) ? @@cur_pool_size : @@cur_pool_size= 0
      end
      alias_method :attr_cur_pool_size, :cur_pool_size
      
      def cur_pool_size=(value)
        @@cur_pool_size = value
      end
      alias_method :attr_cur_pool_size=, :cur_pool_size=
      
      # The pool of timer threads.
      
      def pool
        defined?(@@pool) ? @@pool : @@pool= nil
      end
      alias_method :attr_pool, :pool
      
      def pool=(value)
        @@pool = value
      end
      alias_method :attr_pool=, :pool=
    }
    
    # Is used when linked into the thread pool.
    attr_accessor :next
    alias_method :attr_next, :next
    undef_method :next
    alias_method :attr_next=, :next=
    undef_method :next=
    
    # This is the handle to the timer whose owner's
    # tick() method will be called.
    attr_accessor :timer
    alias_method :attr_timer, :timer
    undef_method :timer
    alias_method :attr_timer=, :timer=
    undef_method :timer=
    
    # The value of a timer's sleepUntil value is captured here.
    # This is used to determine whether or not the timer should
    # be reinserted into the queue.  If the timer's sleepUntil
    # value has changed, the timer is not reinserted.
    attr_accessor :last_sleep_until
    alias_method :attr_last_sleep_until, :last_sleep_until
    undef_method :last_sleep_until
    alias_method :attr_last_sleep_until=, :last_sleep_until=
    undef_method :last_sleep_until=
    
    class_module.module_eval {
      typesig { [Timer, ::Java::Long] }
      # Creates a new callback thread to call the timer owner's
      # tick() method.  A thread is taken from the pool if one
      # is available, otherwise, a new thread is created.
      # The thread handle is returned.
      def call(timer, sleep_until)
        synchronized(self) do
          thread = self.attr_pool
          if ((thread).nil?)
            # create one.
            thread = TimerTickThread.new
            thread.attr_timer = timer
            thread.attr_last_sleep_until = sleep_until
            thread.start
          else
            self.attr_pool = self.attr_pool.attr_next
            thread.attr_timer = timer
            thread.attr_last_sleep_until = sleep_until
            synchronized((thread)) do
              thread.notify
            end
          end
          return thread
        end
      end
    }
    
    typesig { [] }
    # Returns false if the thread should simply exit;
    # otherwise the thread is returned the pool, where
    # it waits to be notified.  (I did try to use the
    # class monitor but the time between the notify
    # and breaking out of the wait seemed to take
    # significantly longer; need to look into this later.)
    def return_to_pool
      synchronized((get_class)) do
        if (self.attr_cur_pool_size >= MAX_POOL_SIZE)
          return false
        end
        @next = self.attr_pool
        self.attr_pool = self
        self.attr_cur_pool_size += 1
        @timer = nil
      end
      while ((@timer).nil?)
        synchronized((self)) do
          begin
            wait
          rescue InterruptedException => ex
            # Just drop through and retest timer.
          end
        end
      end
      synchronized((get_class)) do
        self.attr_cur_pool_size -= 1
      end
      return true
    end
    
    typesig { [] }
    def run
      begin
        @timer.attr_owner.tick(@timer)
        synchronized((TimerThread.attr_timer_thread)) do
          synchronized((@timer)) do
            if ((@last_sleep_until).equal?(@timer.attr_sleep_until))
              TimerThread.requeue(@timer)
            end
          end
        end
      end while (return_to_pool)
    end
    
    typesig { [] }
    def initialize
      @next = nil
      @timer = nil
      @last_sleep_until = 0
      super()
      @next = nil
    end
    
    private
    alias_method :initialize__timer_tick_thread, :initialize
  end
  
end
