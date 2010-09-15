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
module Java::Util
  module TimerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Util, :JavaDate
    }
  end
  
  # A facility for threads to schedule tasks for future execution in a
  # background thread.  Tasks may be scheduled for one-time execution, or for
  # repeated execution at regular intervals.
  # 
  # <p>Corresponding to each <tt>Timer</tt> object is a single background
  # thread that is used to execute all of the timer's tasks, sequentially.
  # Timer tasks should complete quickly.  If a timer task takes excessive time
  # to complete, it "hogs" the timer's task execution thread.  This can, in
  # turn, delay the execution of subsequent tasks, which may "bunch up" and
  # execute in rapid succession when (and if) the offending task finally
  # completes.
  # 
  # <p>After the last live reference to a <tt>Timer</tt> object goes away
  # <i>and</i> all outstanding tasks have completed execution, the timer's task
  # execution thread terminates gracefully (and becomes subject to garbage
  # collection).  However, this can take arbitrarily long to occur.  By
  # default, the task execution thread does not run as a <i>daemon thread</i>,
  # so it is capable of keeping an application from terminating.  If a caller
  # wants to terminate a timer's task execution thread rapidly, the caller
  # should invoke the timer's <tt>cancel</tt> method.
  # 
  # <p>If the timer's task execution thread terminates unexpectedly, for
  # example, because its <tt>stop</tt> method is invoked, any further
  # attempt to schedule a task on the timer will result in an
  # <tt>IllegalStateException</tt>, as if the timer's <tt>cancel</tt>
  # method had been invoked.
  # 
  # <p>This class is thread-safe: multiple threads can share a single
  # <tt>Timer</tt> object without the need for external synchronization.
  # 
  # <p>This class does <i>not</i> offer real-time guarantees: it schedules
  # tasks using the <tt>Object.wait(long)</tt> method.
  # 
  # <p>Java 5.0 introduced the {@code java.util.concurrent} package and
  # one of the concurrency utilities therein is the {@link
  # java.util.concurrent.ScheduledThreadPoolExecutor
  # ScheduledThreadPoolExecutor} which is a thread pool for repeatedly
  # executing tasks at a given rate or delay.  It is effectively a more
  # versatile replacement for the {@code Timer}/{@code TimerTask}
  # combination, as it allows multiple service threads, accepts various
  # time units, and doesn't require subclassing {@code TimerTask} (just
  # implement {@code Runnable}).  Configuring {@code
  # ScheduledThreadPoolExecutor} with one thread makes it equivalent to
  # {@code Timer}.
  # 
  # <p>Implementation note: This class scales to large numbers of concurrently
  # scheduled tasks (thousands should present no problem).  Internally,
  # it uses a binary heap to represent its task queue, so the cost to schedule
  # a task is O(log n), where n is the number of concurrently scheduled tasks.
  # 
  # <p>Implementation note: All constructors start a timer thread.
  # 
  # @author  Josh Bloch
  # @see     TimerTask
  # @see     Object#wait(long)
  # @since   1.3
  class Timer 
    include_class_members TimerImports
    
    # The timer task queue.  This data structure is shared with the timer
    # thread.  The timer produces tasks, via its various schedule calls,
    # and the timer thread consumes, executing timer tasks as appropriate,
    # and removing them from the queue when they're obsolete.
    attr_accessor :queue
    alias_method :attr_queue, :queue
    undef_method :queue
    alias_method :attr_queue=, :queue=
    undef_method :queue=
    
    # The timer thread.
    attr_accessor :thread
    alias_method :attr_thread, :thread
    undef_method :thread
    alias_method :attr_thread=, :thread=
    undef_method :thread=
    
    # This object causes the timer's task execution thread to exit
    # gracefully when there are no live references to the Timer object and no
    # tasks in the timer queue.  It is used in preference to a finalizer on
    # Timer as such a finalizer would be susceptible to a subclass's
    # finalizer forgetting to call it.
    attr_accessor :thread_reaper
    alias_method :attr_thread_reaper, :thread_reaper
    undef_method :thread_reaper
    alias_method :attr_thread_reaper=, :thread_reaper=
    undef_method :thread_reaper=
    
    class_module.module_eval {
      # This ID is used to generate thread names.  (It could be replaced
      # by an AtomicInteger as soon as they become available.)
      
      def next_serial_number
        defined?(@@next_serial_number) ? @@next_serial_number : @@next_serial_number= 0
      end
      alias_method :attr_next_serial_number, :next_serial_number
      
      def next_serial_number=(value)
        @@next_serial_number = value
      end
      alias_method :attr_next_serial_number=, :next_serial_number=
      
      typesig { [] }
      def serial_number
        synchronized(self) do
          return ((self.attr_next_serial_number += 1) - 1)
        end
      end
    }
    
    typesig { [] }
    # Creates a new timer.  The associated thread does <i>not</i>
    # {@linkplain Thread#setDaemon run as a daemon}.
    def initialize
      initialize__timer("Timer-" + RJava.cast_to_string(serial_number))
    end
    
    typesig { [::Java::Boolean] }
    # Creates a new timer whose associated thread may be specified to
    # {@linkplain Thread#setDaemon run as a daemon}.
    # A daemon thread is called for if the timer will be used to
    # schedule repeating "maintenance activities", which must be
    # performed as long as the application is running, but should not
    # prolong the lifetime of the application.
    # 
    # @param isDaemon true if the associated thread should run as a daemon.
    def initialize(is_daemon)
      initialize__timer("Timer-" + RJava.cast_to_string(serial_number), is_daemon)
    end
    
    typesig { [String] }
    # Creates a new timer whose associated thread has the specified name.
    # The associated thread does <i>not</i>
    # {@linkplain Thread#setDaemon run as a daemon}.
    # 
    # @param name the name of the associated thread
    # @throws NullPointerException if name is null
    # @since 1.5
    def initialize(name)
      @queue = TaskQueue.new
      @thread = TimerThread.new(@queue)
      @thread_reaper = Class.new(Object.class == Class ? Object : Object) do
        local_class_in Timer
        include_class_members Timer
        include Object if Object.class == Module
        
        typesig { [] }
        define_method :finalize do
          synchronized((self.attr_queue)) do
            self.attr_thread.attr_new_tasks_may_be_scheduled = false
            self.attr_queue.notify # In case queue is empty.
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @thread.set_name(name)
      @thread.start
    end
    
    typesig { [String, ::Java::Boolean] }
    # Creates a new timer whose associated thread has the specified name,
    # and may be specified to
    # {@linkplain Thread#setDaemon run as a daemon}.
    # 
    # @param name the name of the associated thread
    # @param isDaemon true if the associated thread should run as a daemon
    # @throws NullPointerException if name is null
    # @since 1.5
    def initialize(name, is_daemon)
      @queue = TaskQueue.new
      @thread = TimerThread.new(@queue)
      @thread_reaper = Class.new(Object.class == Class ? Object : Object) do
        local_class_in Timer
        include_class_members Timer
        include Object if Object.class == Module
        
        typesig { [] }
        define_method :finalize do
          synchronized((self.attr_queue)) do
            self.attr_thread.attr_new_tasks_may_be_scheduled = false
            self.attr_queue.notify # In case queue is empty.
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @thread.set_name(name)
      @thread.set_daemon(is_daemon)
      @thread.start
    end
    
    typesig { [TimerTask, ::Java::Long] }
    # Schedules the specified task for execution after the specified delay.
    # 
    # @param task  task to be scheduled.
    # @param delay delay in milliseconds before task is to be executed.
    # @throws IllegalArgumentException if <tt>delay</tt> is negative, or
    # <tt>delay + System.currentTimeMillis()</tt> is negative.
    # @throws IllegalStateException if task was already scheduled or
    # cancelled, or timer was cancelled.
    def schedule(task, delay)
      if (delay < 0)
        raise IllegalArgumentException.new("Negative delay.")
      end
      sched(task, System.current_time_millis + delay, 0)
    end
    
    typesig { [TimerTask, JavaDate] }
    # Schedules the specified task for execution at the specified time.  If
    # the time is in the past, the task is scheduled for immediate execution.
    # 
    # @param task task to be scheduled.
    # @param time time at which task is to be executed.
    # @throws IllegalArgumentException if <tt>time.getTime()</tt> is negative.
    # @throws IllegalStateException if task was already scheduled or
    # cancelled, timer was cancelled, or timer thread terminated.
    def schedule(task, time)
      sched(task, time.get_time, 0)
    end
    
    typesig { [TimerTask, ::Java::Long, ::Java::Long] }
    # Schedules the specified task for repeated <i>fixed-delay execution</i>,
    # beginning after the specified delay.  Subsequent executions take place
    # at approximately regular intervals separated by the specified period.
    # 
    # <p>In fixed-delay execution, each execution is scheduled relative to
    # the actual execution time of the previous execution.  If an execution
    # is delayed for any reason (such as garbage collection or other
    # background activity), subsequent executions will be delayed as well.
    # In the long run, the frequency of execution will generally be slightly
    # lower than the reciprocal of the specified period (assuming the system
    # clock underlying <tt>Object.wait(long)</tt> is accurate).
    # 
    # <p>Fixed-delay execution is appropriate for recurring activities
    # that require "smoothness."  In other words, it is appropriate for
    # activities where it is more important to keep the frequency accurate
    # in the short run than in the long run.  This includes most animation
    # tasks, such as blinking a cursor at regular intervals.  It also includes
    # tasks wherein regular activity is performed in response to human
    # input, such as automatically repeating a character as long as a key
    # is held down.
    # 
    # @param task   task to be scheduled.
    # @param delay  delay in milliseconds before task is to be executed.
    # @param period time in milliseconds between successive task executions.
    # @throws IllegalArgumentException if <tt>delay</tt> is negative, or
    # <tt>delay + System.currentTimeMillis()</tt> is negative.
    # @throws IllegalStateException if task was already scheduled or
    # cancelled, timer was cancelled, or timer thread terminated.
    def schedule(task, delay, period)
      if (delay < 0)
        raise IllegalArgumentException.new("Negative delay.")
      end
      if (period <= 0)
        raise IllegalArgumentException.new("Non-positive period.")
      end
      sched(task, System.current_time_millis + delay, -period)
    end
    
    typesig { [TimerTask, JavaDate, ::Java::Long] }
    # Schedules the specified task for repeated <i>fixed-delay execution</i>,
    # beginning at the specified time. Subsequent executions take place at
    # approximately regular intervals, separated by the specified period.
    # 
    # <p>In fixed-delay execution, each execution is scheduled relative to
    # the actual execution time of the previous execution.  If an execution
    # is delayed for any reason (such as garbage collection or other
    # background activity), subsequent executions will be delayed as well.
    # In the long run, the frequency of execution will generally be slightly
    # lower than the reciprocal of the specified period (assuming the system
    # clock underlying <tt>Object.wait(long)</tt> is accurate).
    # 
    # <p>Fixed-delay execution is appropriate for recurring activities
    # that require "smoothness."  In other words, it is appropriate for
    # activities where it is more important to keep the frequency accurate
    # in the short run than in the long run.  This includes most animation
    # tasks, such as blinking a cursor at regular intervals.  It also includes
    # tasks wherein regular activity is performed in response to human
    # input, such as automatically repeating a character as long as a key
    # is held down.
    # 
    # @param task   task to be scheduled.
    # @param firstTime First time at which task is to be executed.
    # @param period time in milliseconds between successive task executions.
    # @throws IllegalArgumentException if <tt>time.getTime()</tt> is negative.
    # @throws IllegalStateException if task was already scheduled or
    # cancelled, timer was cancelled, or timer thread terminated.
    def schedule(task, first_time, period)
      if (period <= 0)
        raise IllegalArgumentException.new("Non-positive period.")
      end
      sched(task, first_time.get_time, -period)
    end
    
    typesig { [TimerTask, ::Java::Long, ::Java::Long] }
    # Schedules the specified task for repeated <i>fixed-rate execution</i>,
    # beginning after the specified delay.  Subsequent executions take place
    # at approximately regular intervals, separated by the specified period.
    # 
    # <p>In fixed-rate execution, each execution is scheduled relative to the
    # scheduled execution time of the initial execution.  If an execution is
    # delayed for any reason (such as garbage collection or other background
    # activity), two or more executions will occur in rapid succession to
    # "catch up."  In the long run, the frequency of execution will be
    # exactly the reciprocal of the specified period (assuming the system
    # clock underlying <tt>Object.wait(long)</tt> is accurate).
    # 
    # <p>Fixed-rate execution is appropriate for recurring activities that
    # are sensitive to <i>absolute</i> time, such as ringing a chime every
    # hour on the hour, or running scheduled maintenance every day at a
    # particular time.  It is also appropriate for recurring activities
    # where the total time to perform a fixed number of executions is
    # important, such as a countdown timer that ticks once every second for
    # ten seconds.  Finally, fixed-rate execution is appropriate for
    # scheduling multiple repeating timer tasks that must remain synchronized
    # with respect to one another.
    # 
    # @param task   task to be scheduled.
    # @param delay  delay in milliseconds before task is to be executed.
    # @param period time in milliseconds between successive task executions.
    # @throws IllegalArgumentException if <tt>delay</tt> is negative, or
    # <tt>delay + System.currentTimeMillis()</tt> is negative.
    # @throws IllegalStateException if task was already scheduled or
    # cancelled, timer was cancelled, or timer thread terminated.
    def schedule_at_fixed_rate(task, delay, period)
      if (delay < 0)
        raise IllegalArgumentException.new("Negative delay.")
      end
      if (period <= 0)
        raise IllegalArgumentException.new("Non-positive period.")
      end
      sched(task, System.current_time_millis + delay, period)
    end
    
    typesig { [TimerTask, JavaDate, ::Java::Long] }
    # Schedules the specified task for repeated <i>fixed-rate execution</i>,
    # beginning at the specified time. Subsequent executions take place at
    # approximately regular intervals, separated by the specified period.
    # 
    # <p>In fixed-rate execution, each execution is scheduled relative to the
    # scheduled execution time of the initial execution.  If an execution is
    # delayed for any reason (such as garbage collection or other background
    # activity), two or more executions will occur in rapid succession to
    # "catch up."  In the long run, the frequency of execution will be
    # exactly the reciprocal of the specified period (assuming the system
    # clock underlying <tt>Object.wait(long)</tt> is accurate).
    # 
    # <p>Fixed-rate execution is appropriate for recurring activities that
    # are sensitive to <i>absolute</i> time, such as ringing a chime every
    # hour on the hour, or running scheduled maintenance every day at a
    # particular time.  It is also appropriate for recurring activities
    # where the total time to perform a fixed number of executions is
    # important, such as a countdown timer that ticks once every second for
    # ten seconds.  Finally, fixed-rate execution is appropriate for
    # scheduling multiple repeating timer tasks that must remain synchronized
    # with respect to one another.
    # 
    # @param task   task to be scheduled.
    # @param firstTime First time at which task is to be executed.
    # @param period time in milliseconds between successive task executions.
    # @throws IllegalArgumentException if <tt>time.getTime()</tt> is negative.
    # @throws IllegalStateException if task was already scheduled or
    # cancelled, timer was cancelled, or timer thread terminated.
    def schedule_at_fixed_rate(task, first_time, period)
      if (period <= 0)
        raise IllegalArgumentException.new("Non-positive period.")
      end
      sched(task, first_time.get_time, period)
    end
    
    typesig { [TimerTask, ::Java::Long, ::Java::Long] }
    # Schedule the specified timer task for execution at the specified
    # time with the specified period, in milliseconds.  If period is
    # positive, the task is scheduled for repeated execution; if period is
    # zero, the task is scheduled for one-time execution. Time is specified
    # in Date.getTime() format.  This method checks timer state, task state,
    # and initial execution time, but not period.
    # 
    # @throws IllegalArgumentException if <tt>time()</tt> is negative.
    # @throws IllegalStateException if task was already scheduled or
    # cancelled, timer was cancelled, or timer thread terminated.
    def sched(task, time, period)
      if (time < 0)
        raise IllegalArgumentException.new("Illegal execution time.")
      end
      synchronized((@queue)) do
        if (!@thread.attr_new_tasks_may_be_scheduled)
          raise IllegalStateException.new("Timer already cancelled.")
        end
        synchronized((task.attr_lock)) do
          if (!(task.attr_state).equal?(TimerTask::VIRGIN))
            raise IllegalStateException.new("Task already scheduled or cancelled")
          end
          task.attr_next_execution_time = time
          task.attr_period = period
          task.attr_state = TimerTask::SCHEDULED
        end
        @queue.add(task)
        if ((@queue.get_min).equal?(task))
          @queue.notify
        end
      end
    end
    
    typesig { [] }
    # Terminates this timer, discarding any currently scheduled tasks.
    # Does not interfere with a currently executing task (if it exists).
    # Once a timer has been terminated, its execution thread terminates
    # gracefully, and no more tasks may be scheduled on it.
    # 
    # <p>Note that calling this method from within the run method of a
    # timer task that was invoked by this timer absolutely guarantees that
    # the ongoing task execution is the last task execution that will ever
    # be performed by this timer.
    # 
    # <p>This method may be called repeatedly; the second and subsequent
    # calls have no effect.
    def cancel
      synchronized((@queue)) do
        @thread.attr_new_tasks_may_be_scheduled = false
        @queue.clear
        @queue.notify # In case queue was already empty.
      end
    end
    
    typesig { [] }
    # Removes all cancelled tasks from this timer's task queue.  <i>Calling
    # this method has no effect on the behavior of the timer</i>, but
    # eliminates the references to the cancelled tasks from the queue.
    # If there are no external references to these tasks, they become
    # eligible for garbage collection.
    # 
    # <p>Most programs will have no need to call this method.
    # It is designed for use by the rare application that cancels a large
    # number of tasks.  Calling this method trades time for space: the
    # runtime of the method may be proportional to n + c log n, where n
    # is the number of tasks in the queue and c is the number of cancelled
    # tasks.
    # 
    # <p>Note that it is permissible to call this method from within a
    # a task scheduled on this timer.
    # 
    # @return the number of tasks removed from the queue.
    # @since 1.5
    def purge
      result = 0
      synchronized((@queue)) do
        i = @queue.size
        while i > 0
          if ((@queue.get(i).attr_state).equal?(TimerTask::CANCELLED))
            @queue.quick_remove(i)
            result += 1
          end
          i -= 1
        end
        if (!(result).equal?(0))
          @queue.heapify
        end
      end
      return result
    end
    
    private
    alias_method :initialize__timer, :initialize
  end
  
  # This "helper class" implements the timer's task execution thread, which
  # waits for tasks on the timer queue, executions them when they fire,
  # reschedules repeating tasks, and removes cancelled tasks and spent
  # non-repeating tasks from the queue.
  class TimerThread < TimerImports.const_get :JavaThread
    include_class_members TimerImports
    
    # This flag is set to false by the reaper to inform us that there
    # are no more live references to our Timer object.  Once this flag
    # is true and there are no more tasks in our queue, there is no
    # work left for us to do, so we terminate gracefully.  Note that
    # this field is protected by queue's monitor!
    attr_accessor :new_tasks_may_be_scheduled
    alias_method :attr_new_tasks_may_be_scheduled, :new_tasks_may_be_scheduled
    undef_method :new_tasks_may_be_scheduled
    alias_method :attr_new_tasks_may_be_scheduled=, :new_tasks_may_be_scheduled=
    undef_method :new_tasks_may_be_scheduled=
    
    # Our Timer's queue.  We store this reference in preference to
    # a reference to the Timer so the reference graph remains acyclic.
    # Otherwise, the Timer would never be garbage-collected and this
    # thread would never go away.
    attr_accessor :queue
    alias_method :attr_queue, :queue
    undef_method :queue
    alias_method :attr_queue=, :queue=
    undef_method :queue=
    
    typesig { [TaskQueue] }
    def initialize(queue)
      @new_tasks_may_be_scheduled = false
      @queue = nil
      super()
      @new_tasks_may_be_scheduled = true
      @queue = queue
    end
    
    typesig { [] }
    def run
      begin
        main_loop
      ensure
        # Someone killed this Thread, behave as if Timer cancelled
        synchronized((@queue)) do
          @new_tasks_may_be_scheduled = false
          @queue.clear # Eliminate obsolete references
        end
      end
    end
    
    typesig { [] }
    # The main timer loop.  (See class comment.)
    def main_loop
      while (true)
        begin
          task = nil
          task_fired = false
          synchronized((@queue)) do
            # Wait for queue to become non-empty
            while (@queue.is_empty && @new_tasks_may_be_scheduled)
              @queue.wait
            end
            if (@queue.is_empty)
              break
            end # Queue is empty and will forever remain; die
            # Queue nonempty; look at first evt and do the right thing
            current_time = 0
            execution_time = 0
            task = @queue.get_min
            synchronized((task.attr_lock)) do
              if ((task.attr_state).equal?(TimerTask::CANCELLED))
                @queue.remove_min
                next # No action required, poll queue again
              end
              current_time = System.current_time_millis
              execution_time = task.attr_next_execution_time
              if (task_fired = (execution_time <= current_time))
                if ((task.attr_period).equal?(0))
                  # Non-repeating, remove
                  @queue.remove_min
                  task.attr_state = TimerTask::EXECUTED
                else
                  # Repeating task, reschedule
                  @queue.reschedule_min(task.attr_period < 0 ? current_time - task.attr_period : execution_time + task.attr_period)
                end
              end
            end
            if (!task_fired)
              # Task hasn't yet fired; wait
              @queue.wait(execution_time - current_time)
            end
          end
          if (task_fired)
            # Task fired; run it, holding no locks
            task.run
          end
        rescue InterruptedException => e
        end
      end
    end
    
    private
    alias_method :initialize__timer_thread, :initialize
  end
  
  # This class represents a timer task queue: a priority queue of TimerTasks,
  # ordered on nextExecutionTime.  Each Timer object has one of these, which it
  # shares with its TimerThread.  Internally this class uses a heap, which
  # offers log(n) performance for the add, removeMin and rescheduleMin
  # operations, and constant time performance for the getMin operation.
  class TaskQueue 
    include_class_members TimerImports
    
    # Priority queue represented as a balanced binary heap: the two children
    # of queue[n] are queue[2*n] and queue[2*n+1].  The priority queue is
    # ordered on the nextExecutionTime field: The TimerTask with the lowest
    # nextExecutionTime is in queue[1] (assuming the queue is nonempty).  For
    # each node n in the heap, and each descendant of n, d,
    # n.nextExecutionTime <= d.nextExecutionTime.
    attr_accessor :queue
    alias_method :attr_queue, :queue
    undef_method :queue
    alias_method :attr_queue=, :queue=
    undef_method :queue=
    
    # The number of tasks in the priority queue.  (The tasks are stored in
    # queue[1] up to queue[size]).
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    typesig { [] }
    # Returns the number of tasks currently on the queue.
    def size
      return @size
    end
    
    typesig { [TimerTask] }
    # Adds a new task to the priority queue.
    def add(task)
      # Grow backing store if necessary
      if ((@size + 1).equal?(@queue.attr_length))
        @queue = Arrays.copy_of(@queue, 2 * @queue.attr_length)
      end
      @queue[(@size += 1)] = task
      fix_up(@size)
    end
    
    typesig { [] }
    # Return the "head task" of the priority queue.  (The head task is an
    # task with the lowest nextExecutionTime.)
    def get_min
      return @queue[1]
    end
    
    typesig { [::Java::Int] }
    # Return the ith task in the priority queue, where i ranges from 1 (the
    # head task, which is returned by getMin) to the number of tasks on the
    # queue, inclusive.
    def get(i)
      return @queue[i]
    end
    
    typesig { [] }
    # Remove the head task from the priority queue.
    def remove_min
      @queue[1] = @queue[@size]
      @queue[((@size -= 1) + 1)] = nil # Drop extra reference to prevent memory leak
      fix_down(1)
    end
    
    typesig { [::Java::Int] }
    # Removes the ith element from queue without regard for maintaining
    # the heap invariant.  Recall that queue is one-based, so
    # 1 <= i <= size.
    def quick_remove(i)
      raise AssertError if not (i <= @size)
      @queue[i] = @queue[@size]
      @queue[((@size -= 1) + 1)] = nil # Drop extra ref to prevent memory leak
    end
    
    typesig { [::Java::Long] }
    # Sets the nextExecutionTime associated with the head task to the
    # specified value, and adjusts priority queue accordingly.
    def reschedule_min(new_time)
      @queue[1].attr_next_execution_time = new_time
      fix_down(1)
    end
    
    typesig { [] }
    # Returns true if the priority queue contains no elements.
    def is_empty
      return (@size).equal?(0)
    end
    
    typesig { [] }
    # Removes all elements from the priority queue.
    def clear
      # Null out task references to prevent memory leak
      i = 1
      while i <= @size
        @queue[i] = nil
        i += 1
      end
      @size = 0
    end
    
    typesig { [::Java::Int] }
    # Establishes the heap invariant (described above) assuming the heap
    # satisfies the invariant except possibly for the leaf-node indexed by k
    # (which may have a nextExecutionTime less than its parent's).
    # 
    # This method functions by "promoting" queue[k] up the hierarchy
    # (by swapping it with its parent) repeatedly until queue[k]'s
    # nextExecutionTime is greater than or equal to that of its parent.
    def fix_up(k)
      while (k > 1)
        j = k >> 1
        if (@queue[j].attr_next_execution_time <= @queue[k].attr_next_execution_time)
          break
        end
        tmp = @queue[j]
        @queue[j] = @queue[k]
        @queue[k] = tmp
        k = j
      end
    end
    
    typesig { [::Java::Int] }
    # Establishes the heap invariant (described above) in the subtree
    # rooted at k, which is assumed to satisfy the heap invariant except
    # possibly for node k itself (which may have a nextExecutionTime greater
    # than its children's).
    # 
    # This method functions by "demoting" queue[k] down the hierarchy
    # (by swapping it with its smaller child) repeatedly until queue[k]'s
    # nextExecutionTime is less than or equal to those of its children.
    def fix_down(k)
      j = 0
      while ((j = k << 1) <= @size && j > 0)
        if (j < @size && @queue[j].attr_next_execution_time > @queue[j + 1].attr_next_execution_time)
          j += 1
        end # j indexes smallest kid
        if (@queue[k].attr_next_execution_time <= @queue[j].attr_next_execution_time)
          break
        end
        tmp = @queue[j]
        @queue[j] = @queue[k]
        @queue[k] = tmp
        k = j
      end
    end
    
    typesig { [] }
    # Establishes the heap invariant (described above) in the entire tree,
    # assuming nothing about the order of the elements prior to the call.
    def heapify
      i = @size / 2
      while i >= 1
        fix_down(i)
        i -= 1
      end
    end
    
    typesig { [] }
    def initialize
      @queue = Array.typed(TimerTask).new(128) { nil }
      @size = 0
    end
    
    private
    alias_method :initialize__task_queue, :initialize
  end
  
end
