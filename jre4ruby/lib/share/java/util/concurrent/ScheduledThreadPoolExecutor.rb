require "rjava"

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
# 
# 
# This file is available under and governed by the GNU General Public
# License version 2 only, as published by the Free Software Foundation.
# However, the following notice accompanied the original version of this
# file:
# 
# Written by Doug Lea with assistance from members of JCP JSR-166
# Expert Group and released to the public domain, as explained at
# http://creativecommons.org/licenses/publicdomain
module Java::Util::Concurrent
  module ScheduledThreadPoolExecutorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util::Concurrent::Atomic
      include ::Java::Util
    }
  end
  
  # A {@link ThreadPoolExecutor} that can additionally schedule
  # commands to run after a given delay, or to execute
  # periodically. This class is preferable to {@link java.util.Timer}
  # when multiple worker threads are needed, or when the additional
  # flexibility or capabilities of {@link ThreadPoolExecutor} (which
  # this class extends) are required.
  # 
  # <p> Delayed tasks execute no sooner than they are enabled, but
  # without any real-time guarantees about when, after they are
  # enabled, they will commence. Tasks scheduled for exactly the same
  # execution time are enabled in first-in-first-out (FIFO) order of
  # submission.
  # 
  # <p>While this class inherits from {@link ThreadPoolExecutor}, a few
  # of the inherited tuning methods are not useful for it. In
  # particular, because it acts as a fixed-sized pool using
  # {@code corePoolSize} threads and an unbounded queue, adjustments
  # to {@code maximumPoolSize} have no useful effect. Additionally, it
  # is almost never a good idea to set {@code corePoolSize} to zero or
  # use {@code allowCoreThreadTimeOut} because this may leave the pool
  # without threads to handle tasks once they become eligible to run.
  # 
  # <p><b>Extension notes:</b> This class overrides the
  # {@link ThreadPoolExecutor#execute execute} and
  # {@link AbstractExecutorService#submit(Runnable) submit}
  # methods to generate internal {@link ScheduledFuture} objects to
  # control per-task delays and scheduling.  To preserve
  # functionality, any further overrides of these methods in
  # subclasses must invoke superclass versions, which effectively
  # disables additional task customization.  However, this class
  # provides alternative protected extension method
  # {@code decorateTask} (one version each for {@code Runnable} and
  # {@code Callable}) that can be used to customize the concrete task
  # types used to execute commands entered via {@code execute},
  # {@code submit}, {@code schedule}, {@code scheduleAtFixedRate},
  # and {@code scheduleWithFixedDelay}.  By default, a
  # {@code ScheduledThreadPoolExecutor} uses a task type extending
  # {@link FutureTask}. However, this may be modified or replaced using
  # subclasses of the form:
  # 
  # <pre> {@code
  # public class CustomScheduledExecutor extends ScheduledThreadPoolExecutor {
  # 
  # static class CustomTask<V> implements RunnableScheduledFuture<V> { ... }
  # 
  # protected <V> RunnableScheduledFuture<V> decorateTask(
  # Runnable r, RunnableScheduledFuture<V> task) {
  # return new CustomTask<V>(r, task);
  # }
  # 
  # protected <V> RunnableScheduledFuture<V> decorateTask(
  # Callable<V> c, RunnableScheduledFuture<V> task) {
  # return new CustomTask<V>(c, task);
  # }
  # // ... add constructors, etc.
  # }}</pre>
  # 
  # @since 1.5
  # @author Doug Lea
  class ScheduledThreadPoolExecutor < ScheduledThreadPoolExecutorImports.const_get :ThreadPoolExecutor
    include_class_members ScheduledThreadPoolExecutorImports
    overload_protected {
      include ScheduledExecutorService
    }
    
    # This class specializes ThreadPoolExecutor implementation by
    # 
    # 1. Using a custom task type, ScheduledFutureTask for
    # tasks, even those that don't require scheduling (i.e.,
    # those submitted using ExecutorService execute, not
    # ScheduledExecutorService methods) which are treated as
    # delayed tasks with a delay of zero.
    # 
    # 2. Using a custom queue (DelayedWorkQueue) based on an
    # unbounded DelayQueue. The lack of capacity constraint and
    # the fact that corePoolSize and maximumPoolSize are
    # effectively identical simplifies some execution mechanics
    # (see delayedExecute) compared to ThreadPoolExecutor
    # version.
    # 
    # The DelayedWorkQueue class is defined below for the sake of
    # ensuring that all elements are instances of
    # RunnableScheduledFuture.  Since DelayQueue otherwise
    # requires type be Delayed, but not necessarily Runnable, and
    # the workQueue requires the opposite, we need to explicitly
    # define a class that requires both to ensure that users don't
    # add objects that aren't RunnableScheduledFutures via
    # getQueue().add() etc.
    # 
    # 3. Supporting optional run-after-shutdown parameters, which
    # leads to overrides of shutdown methods to remove and cancel
    # tasks that should NOT be run after shutdown, as well as
    # different recheck logic when task (re)submission overlaps
    # with a shutdown.
    # 
    # 4. Task decoration methods to allow interception and
    # instrumentation, which are needed because subclasses cannot
    # otherwise override submit methods to get this effect. These
    # don't have any impact on pool control logic though.
    # 
    # 
    # False if should cancel/suppress periodic tasks on shutdown.
    attr_accessor :continue_existing_periodic_tasks_after_shutdown
    alias_method :attr_continue_existing_periodic_tasks_after_shutdown, :continue_existing_periodic_tasks_after_shutdown
    undef_method :continue_existing_periodic_tasks_after_shutdown
    alias_method :attr_continue_existing_periodic_tasks_after_shutdown=, :continue_existing_periodic_tasks_after_shutdown=
    undef_method :continue_existing_periodic_tasks_after_shutdown=
    
    # False if should cancel non-periodic tasks on shutdown.
    attr_accessor :execute_existing_delayed_tasks_after_shutdown
    alias_method :attr_execute_existing_delayed_tasks_after_shutdown, :execute_existing_delayed_tasks_after_shutdown
    undef_method :execute_existing_delayed_tasks_after_shutdown
    alias_method :attr_execute_existing_delayed_tasks_after_shutdown=, :execute_existing_delayed_tasks_after_shutdown=
    undef_method :execute_existing_delayed_tasks_after_shutdown=
    
    class_module.module_eval {
      # Sequence number to break scheduling ties, and in turn to
      # guarantee FIFO order among tied entries.
      const_set_lazy(:Sequencer) { AtomicLong.new(0) }
      const_attr_reader  :Sequencer
    }
    
    typesig { [] }
    # Returns current nanosecond time.
    def now
      return System.nano_time
    end
    
    class_module.module_eval {
      const_set_lazy(:ScheduledFutureTask) { Class.new(FutureTask) do
        extend LocalClass
        include_class_members ScheduledThreadPoolExecutor
        overload_protected {
          include RunnableScheduledFuture
        }
        
        # Sequence number to break ties FIFO
        attr_accessor :sequence_number
        alias_method :attr_sequence_number, :sequence_number
        undef_method :sequence_number
        alias_method :attr_sequence_number=, :sequence_number=
        undef_method :sequence_number=
        
        # The time the task is enabled to execute in nanoTime units
        attr_accessor :time
        alias_method :attr_time, :time
        undef_method :time
        alias_method :attr_time=, :time=
        undef_method :time=
        
        # Period in nanoseconds for repeating tasks.  A positive
        # value indicates fixed-rate execution.  A negative value
        # indicates fixed-delay execution.  A value of 0 indicates a
        # non-repeating task.
        attr_accessor :period
        alias_method :attr_period, :period
        undef_method :period
        alias_method :attr_period=, :period=
        undef_method :period=
        
        # The actual task to be re-enqueued by reExecutePeriodic
        attr_accessor :outer_task
        alias_method :attr_outer_task, :outer_task
        undef_method :outer_task
        alias_method :attr_outer_task=, :outer_task=
        undef_method :outer_task=
        
        typesig { [class_self::Runnable, Object, ::Java::Long] }
        # Creates a one-shot action with given nanoTime-based trigger time.
        def initialize(r, result, ns)
          @sequence_number = 0
          @time = 0
          @period = 0
          @outer_task = nil
          super(r, result)
          @outer_task = self
          @time = ns
          @period = 0
          @sequence_number = Sequencer.get_and_increment
        end
        
        typesig { [class_self::Runnable, Object, ::Java::Long, ::Java::Long] }
        # Creates a periodic action with given nano time and period.
        def initialize(r, result, ns, period)
          @sequence_number = 0
          @time = 0
          @period = 0
          @outer_task = nil
          super(r, result)
          @outer_task = self
          @time = ns
          @period = period
          @sequence_number = Sequencer.get_and_increment
        end
        
        typesig { [class_self::Callable, ::Java::Long] }
        # Creates a one-shot action with given nanoTime-based trigger.
        def initialize(callable, ns)
          @sequence_number = 0
          @time = 0
          @period = 0
          @outer_task = nil
          super(callable)
          @outer_task = self
          @time = ns
          @period = 0
          @sequence_number = Sequencer.get_and_increment
        end
        
        typesig { [class_self::TimeUnit] }
        def get_delay(unit)
          d = unit.convert(@time - now, TimeUnit::NANOSECONDS)
          return d
        end
        
        typesig { [class_self::Delayed] }
        def compare_to(other)
          if ((other).equal?(self))
            # compare zero ONLY if same object
            return 0
          end
          if (other.is_a?(self.class::ScheduledFutureTask))
            x = other
            diff = @time - x.attr_time
            if (diff < 0)
              return -1
            else
              if (diff > 0)
                return 1
              else
                if (@sequence_number < x.attr_sequence_number)
                  return -1
                else
                  return 1
                end
              end
            end
          end
          d = (get_delay(TimeUnit::NANOSECONDS) - other.get_delay(TimeUnit::NANOSECONDS))
          return ((d).equal?(0)) ? 0 : ((d < 0) ? -1 : 1)
        end
        
        typesig { [] }
        # Returns true if this is a periodic (not a one-shot) action.
        # 
        # @return true if periodic
        def is_periodic
          return !(@period).equal?(0)
        end
        
        typesig { [] }
        # Sets the next time to run for a periodic task.
        def set_next_run_time
          p = @period
          if (p > 0)
            @time += p
          else
            @time = now - p
          end
        end
        
        typesig { [] }
        # Overrides FutureTask version so as to reset/requeue if periodic.
        def run
          periodic = is_periodic
          if (!can_run_in_current_run_state(periodic))
            cancel(false)
          else
            if (!periodic)
              ScheduledFutureTask.superclass.instance_method(:run).bind(self).call
            else
              if (ScheduledFutureTask.superclass.instance_method(:run_and_reset).bind(self).call)
                set_next_run_time
                re_execute_periodic(@outer_task)
              end
            end
          end
        end
        
        private
        alias_method :initialize__scheduled_future_task, :initialize
      end }
    }
    
    typesig { [::Java::Boolean] }
    # Returns true if can run a task given current run state
    # and run-after-shutdown parameters.
    # 
    # @param periodic true if this task periodic, false if delayed
    def can_run_in_current_run_state(periodic)
      return is_running_or_shutdown(periodic ? @continue_existing_periodic_tasks_after_shutdown : @execute_existing_delayed_tasks_after_shutdown)
    end
    
    typesig { [RunnableScheduledFuture] }
    # Main execution method for delayed or periodic tasks.  If pool
    # is shut down, rejects the task. Otherwise adds task to queue
    # and starts a thread, if necessary, to run it.  (We cannot
    # prestart the thread to run the task because the task (probably)
    # shouldn't be run yet,) If the pool is shut down while the task
    # is being added, cancel and remove it if required by state and
    # run-after-shutdown parameters.
    # 
    # @param task the task
    def delayed_execute(task)
      if (is_shutdown)
        reject(task)
      else
        ThreadPoolExecutor.instance_method(:get_queue).bind(self).call.add(task)
        if (is_shutdown && !can_run_in_current_run_state(task.is_periodic) && remove(task))
          task.cancel(false)
        else
          prestart_core_thread
        end
      end
    end
    
    typesig { [RunnableScheduledFuture] }
    # Requeues a periodic task unless current run state precludes it.
    # Same idea as delayedExecute except drops task rather than rejecting.
    # 
    # @param task the task
    def re_execute_periodic(task)
      if (can_run_in_current_run_state(true))
        ThreadPoolExecutor.instance_method(:get_queue).bind(self).call.add(task)
        if (!can_run_in_current_run_state(true) && remove(task))
          task.cancel(false)
        else
          prestart_core_thread
        end
      end
    end
    
    typesig { [] }
    # Cancels and clears the queue of all tasks that should not be run
    # due to shutdown policy.  Invoked within super.shutdown.
    def on_shutdown
      q = ThreadPoolExecutor.instance_method(:get_queue).bind(self).call
      keep_delayed = get_execute_existing_delayed_tasks_after_shutdown_policy
      keep_periodic = get_continue_existing_periodic_tasks_after_shutdown_policy
      if (!keep_delayed && !keep_periodic)
        q.clear
      else
        # Traverse snapshot to avoid iterator exceptions
        q.to_array.each do |e|
          if (e.is_a?(RunnableScheduledFuture))
            t = e
            if ((t.is_periodic ? !keep_periodic : !keep_delayed) || t.is_cancelled)
              # also remove if already cancelled
              if (q.remove(t))
                t.cancel(false)
              end
            end
          end
        end
      end
      try_terminate
    end
    
    typesig { [Runnable, RunnableScheduledFuture] }
    # Modifies or replaces the task used to execute a runnable.
    # This method can be used to override the concrete
    # class used for managing internal tasks.
    # The default implementation simply returns the given task.
    # 
    # @param runnable the submitted Runnable
    # @param task the task created to execute the runnable
    # @return a task that can execute the runnable
    # @since 1.6
    def decorate_task(runnable, task)
      return task
    end
    
    typesig { [Callable, RunnableScheduledFuture] }
    # Modifies or replaces the task used to execute a callable.
    # This method can be used to override the concrete
    # class used for managing internal tasks.
    # The default implementation simply returns the given task.
    # 
    # @param callable the submitted Callable
    # @param task the task created to execute the callable
    # @return a task that can execute the callable
    # @since 1.6
    def decorate_task(callable, task)
      return task
    end
    
    typesig { [::Java::Int] }
    # Creates a new {@code ScheduledThreadPoolExecutor} with the
    # given core pool size.
    # 
    # @param corePoolSize the number of threads to keep in the pool, even
    # if they are idle, unless {@code allowCoreThreadTimeOut} is set
    # @throws IllegalArgumentException if {@code corePoolSize < 0}
    def initialize(core_pool_size)
      @continue_existing_periodic_tasks_after_shutdown = false
      @execute_existing_delayed_tasks_after_shutdown = false
      super(core_pool_size, JavaInteger::MAX_VALUE, 0, TimeUnit::NANOSECONDS, DelayedWorkQueue.new)
      @execute_existing_delayed_tasks_after_shutdown = true
    end
    
    typesig { [::Java::Int, ThreadFactory] }
    # Creates a new {@code ScheduledThreadPoolExecutor} with the
    # given initial parameters.
    # 
    # @param corePoolSize the number of threads to keep in the pool, even
    # if they are idle, unless {@code allowCoreThreadTimeOut} is set
    # @param threadFactory the factory to use when the executor
    # creates a new thread
    # @throws IllegalArgumentException if {@code corePoolSize < 0}
    # @throws NullPointerException if {@code threadFactory} is null
    def initialize(core_pool_size, thread_factory)
      @continue_existing_periodic_tasks_after_shutdown = false
      @execute_existing_delayed_tasks_after_shutdown = false
      super(core_pool_size, JavaInteger::MAX_VALUE, 0, TimeUnit::NANOSECONDS, DelayedWorkQueue.new, thread_factory)
      @execute_existing_delayed_tasks_after_shutdown = true
    end
    
    typesig { [::Java::Int, RejectedExecutionHandler] }
    # Creates a new ScheduledThreadPoolExecutor with the given
    # initial parameters.
    # 
    # @param corePoolSize the number of threads to keep in the pool, even
    # if they are idle, unless {@code allowCoreThreadTimeOut} is set
    # @param handler the handler to use when execution is blocked
    # because the thread bounds and queue capacities are reached
    # @throws IllegalArgumentException if {@code corePoolSize < 0}
    # @throws NullPointerException if {@code handler} is null
    def initialize(core_pool_size, handler)
      @continue_existing_periodic_tasks_after_shutdown = false
      @execute_existing_delayed_tasks_after_shutdown = false
      super(core_pool_size, JavaInteger::MAX_VALUE, 0, TimeUnit::NANOSECONDS, DelayedWorkQueue.new, handler)
      @execute_existing_delayed_tasks_after_shutdown = true
    end
    
    typesig { [::Java::Int, ThreadFactory, RejectedExecutionHandler] }
    # Creates a new ScheduledThreadPoolExecutor with the given
    # initial parameters.
    # 
    # @param corePoolSize the number of threads to keep in the pool, even
    # if they are idle, unless {@code allowCoreThreadTimeOut} is set
    # @param threadFactory the factory to use when the executor
    # creates a new thread
    # @param handler the handler to use when execution is blocked
    # because the thread bounds and queue capacities are reached
    # @throws IllegalArgumentException if {@code corePoolSize < 0}
    # @throws NullPointerException if {@code threadFactory} or
    # {@code handler} is null
    def initialize(core_pool_size, thread_factory, handler)
      @continue_existing_periodic_tasks_after_shutdown = false
      @execute_existing_delayed_tasks_after_shutdown = false
      super(core_pool_size, JavaInteger::MAX_VALUE, 0, TimeUnit::NANOSECONDS, DelayedWorkQueue.new, thread_factory, handler)
      @execute_existing_delayed_tasks_after_shutdown = true
    end
    
    typesig { [Runnable, ::Java::Long, TimeUnit] }
    def schedule(command, delay, unit)
      if ((command).nil? || (unit).nil?)
        raise NullPointerException.new
      end
      if (delay < 0)
        delay = 0
      end
      trigger_time = now + unit.to_nanos(delay)
      t = decorate_task(command, ScheduledFutureTask.new_local(self, command, nil, trigger_time))
      delayed_execute(t)
      return t
    end
    
    typesig { [Callable, ::Java::Long, TimeUnit] }
    def schedule(callable, delay, unit)
      if ((callable).nil? || (unit).nil?)
        raise NullPointerException.new
      end
      if (delay < 0)
        delay = 0
      end
      trigger_time = now + unit.to_nanos(delay)
      t = decorate_task(callable, ScheduledFutureTask.new_local(self, callable, trigger_time))
      delayed_execute(t)
      return t
    end
    
    typesig { [Runnable, ::Java::Long, ::Java::Long, TimeUnit] }
    def schedule_at_fixed_rate(command, initial_delay, period, unit)
      if ((command).nil? || (unit).nil?)
        raise NullPointerException.new
      end
      if (period <= 0)
        raise IllegalArgumentException.new
      end
      if (initial_delay < 0)
        initial_delay = 0
      end
      trigger_time = now + unit.to_nanos(initial_delay)
      sft = ScheduledFutureTask.new_local(self, command, nil, trigger_time, unit.to_nanos(period))
      t = decorate_task(command, sft)
      sft.attr_outer_task = t
      delayed_execute(t)
      return t
    end
    
    typesig { [Runnable, ::Java::Long, ::Java::Long, TimeUnit] }
    def schedule_with_fixed_delay(command, initial_delay, delay, unit)
      if ((command).nil? || (unit).nil?)
        raise NullPointerException.new
      end
      if (delay <= 0)
        raise IllegalArgumentException.new
      end
      if (initial_delay < 0)
        initial_delay = 0
      end
      trigger_time = now + unit.to_nanos(initial_delay)
      sft = ScheduledFutureTask.new_local(self, command, nil, trigger_time, unit.to_nanos(-delay))
      t = decorate_task(command, sft)
      sft.attr_outer_task = t
      delayed_execute(t)
      return t
    end
    
    typesig { [Runnable] }
    # Executes {@code command} with zero required delay.
    # This has effect equivalent to
    # {@link #schedule(Runnable,long,TimeUnit) schedule(command, 0, anyUnit)}.
    # Note that inspections of the queue and of the list returned by
    # {@code shutdownNow} will access the zero-delayed
    # {@link ScheduledFuture}, not the {@code command} itself.
    # 
    # <p>A consequence of the use of {@code ScheduledFuture} objects is
    # that {@link ThreadPoolExecutor#afterExecute afterExecute} is always
    # called with a null second {@code Throwable} argument, even if the
    # {@code command} terminated abruptly.  Instead, the {@code Throwable}
    # thrown by such a task can be obtained via {@link Future#get}.
    # 
    # @throws RejectedExecutionException at discretion of
    # {@code RejectedExecutionHandler}, if the task
    # cannot be accepted for execution because the
    # executor has been shut down
    # @throws NullPointerException {@inheritDoc}
    def execute(command)
      schedule(command, 0, TimeUnit::NANOSECONDS)
    end
    
    typesig { [Runnable] }
    # Override AbstractExecutorService methods
    def submit(task)
      return schedule(task, 0, TimeUnit::NANOSECONDS)
    end
    
    typesig { [Runnable, Object] }
    def submit(task, result)
      return schedule(Executors.callable(task, result), 0, TimeUnit::NANOSECONDS)
    end
    
    typesig { [Callable] }
    def submit(task)
      return schedule(task, 0, TimeUnit::NANOSECONDS)
    end
    
    typesig { [::Java::Boolean] }
    # Sets the policy on whether to continue executing existing
    # periodic tasks even when this executor has been {@code shutdown}.
    # In this case, these tasks will only terminate upon
    # {@code shutdownNow} or after setting the policy to
    # {@code false} when already shutdown.
    # This value is by default {@code false}.
    # 
    # @param value if {@code true}, continue after shutdown, else don't.
    # @see #getContinueExistingPeriodicTasksAfterShutdownPolicy
    def set_continue_existing_periodic_tasks_after_shutdown_policy(value)
      @continue_existing_periodic_tasks_after_shutdown = value
      if (!value && is_shutdown)
        on_shutdown
      end
    end
    
    typesig { [] }
    # Gets the policy on whether to continue executing existing
    # periodic tasks even when this executor has been {@code shutdown}.
    # In this case, these tasks will only terminate upon
    # {@code shutdownNow} or after setting the policy to
    # {@code false} when already shutdown.
    # This value is by default {@code false}.
    # 
    # @return {@code true} if will continue after shutdown
    # @see #setContinueExistingPeriodicTasksAfterShutdownPolicy
    def get_continue_existing_periodic_tasks_after_shutdown_policy
      return @continue_existing_periodic_tasks_after_shutdown
    end
    
    typesig { [::Java::Boolean] }
    # Sets the policy on whether to execute existing delayed
    # tasks even when this executor has been {@code shutdown}.
    # In this case, these tasks will only terminate upon
    # {@code shutdownNow}, or after setting the policy to
    # {@code false} when already shutdown.
    # This value is by default {@code true}.
    # 
    # @param value if {@code true}, execute after shutdown, else don't.
    # @see #getExecuteExistingDelayedTasksAfterShutdownPolicy
    def set_execute_existing_delayed_tasks_after_shutdown_policy(value)
      @execute_existing_delayed_tasks_after_shutdown = value
      if (!value && is_shutdown)
        on_shutdown
      end
    end
    
    typesig { [] }
    # Gets the policy on whether to execute existing delayed
    # tasks even when this executor has been {@code shutdown}.
    # In this case, these tasks will only terminate upon
    # {@code shutdownNow}, or after setting the policy to
    # {@code false} when already shutdown.
    # This value is by default {@code true}.
    # 
    # @return {@code true} if will execute after shutdown
    # @see #setExecuteExistingDelayedTasksAfterShutdownPolicy
    def get_execute_existing_delayed_tasks_after_shutdown_policy
      return @execute_existing_delayed_tasks_after_shutdown
    end
    
    typesig { [] }
    # Initiates an orderly shutdown in which previously submitted
    # tasks are executed, but no new tasks will be accepted.  If the
    # {@code ExecuteExistingDelayedTasksAfterShutdownPolicy} has
    # been set {@code false}, existing delayed tasks whose delays
    # have not yet elapsed are cancelled.  And unless the
    # {@code ContinueExistingPeriodicTasksAfterShutdownPolicy} has
    # been set {@code true}, future executions of existing periodic
    # tasks will be cancelled.
    def shutdown
      super
    end
    
    typesig { [] }
    # Attempts to stop all actively executing tasks, halts the
    # processing of waiting tasks, and returns a list of the tasks
    # that were awaiting execution.
    # 
    # <p>There are no guarantees beyond best-effort attempts to stop
    # processing actively executing tasks.  This implementation
    # cancels tasks via {@link Thread#interrupt}, so any task that
    # fails to respond to interrupts may never terminate.
    # 
    # @return list of tasks that never commenced execution.
    # Each element of this list is a {@link ScheduledFuture},
    # including those tasks submitted using {@code execute},
    # which are for scheduling purposes used as the basis of a
    # zero-delay {@code ScheduledFuture}.
    # @throws SecurityException {@inheritDoc}
    def shutdown_now
      return super
    end
    
    typesig { [] }
    # Returns the task queue used by this executor.  Each element of
    # this queue is a {@link ScheduledFuture}, including those
    # tasks submitted using {@code execute} which are for scheduling
    # purposes used as the basis of a zero-delay
    # {@code ScheduledFuture}.  Iteration over this queue is
    # <em>not</em> guaranteed to traverse tasks in the order in
    # which they will execute.
    # 
    # @return the task queue
    def get_queue
      return super
    end
    
    class_module.module_eval {
      # An annoying wrapper class to convince javac to use a
      # DelayQueue<RunnableScheduledFuture> as a BlockingQueue<Runnable>
      const_set_lazy(:DelayedWorkQueue) { Class.new(AbstractCollection) do
        include_class_members ScheduledThreadPoolExecutor
        overload_protected {
          include BlockingQueue
        }
        
        attr_accessor :dq
        alias_method :attr_dq, :dq
        undef_method :dq
        alias_method :attr_dq=, :dq=
        undef_method :dq=
        
        typesig { [] }
        def poll
          return @dq.poll
        end
        
        typesig { [] }
        def peek
          return @dq.peek
        end
        
        typesig { [] }
        def take
          return @dq.take
        end
        
        typesig { [::Java::Long, class_self::TimeUnit] }
        def poll(timeout, unit)
          return @dq.poll(timeout, unit)
        end
        
        typesig { [class_self::Runnable] }
        def add(x)
          return @dq.add(x)
        end
        
        typesig { [class_self::Runnable] }
        def offer(x)
          return @dq.offer(x)
        end
        
        typesig { [class_self::Runnable] }
        def put(x)
          @dq.put(x)
        end
        
        typesig { [class_self::Runnable, ::Java::Long, class_self::TimeUnit] }
        def offer(x, timeout, unit)
          return @dq.offer(x, timeout, unit)
        end
        
        typesig { [] }
        def remove
          return @dq.remove
        end
        
        typesig { [] }
        def element
          return @dq.element
        end
        
        typesig { [] }
        def clear
          @dq.clear
        end
        
        typesig { [class_self::Collection] }
        def drain_to(c)
          return @dq.drain_to(c)
        end
        
        typesig { [class_self::Collection, ::Java::Int] }
        def drain_to(c, max_elements)
          return @dq.drain_to(c, max_elements)
        end
        
        typesig { [] }
        def remaining_capacity
          return @dq.remaining_capacity
        end
        
        typesig { [Object] }
        def remove(x)
          return @dq.remove(x)
        end
        
        typesig { [Object] }
        def contains(x)
          return @dq.contains(x)
        end
        
        typesig { [] }
        def size
          return @dq.size
        end
        
        typesig { [] }
        def is_empty
          return @dq.is_empty
        end
        
        typesig { [] }
        def to_array
          return @dq.to_array
        end
        
        typesig { [Array.typed(Object)] }
        def to_array(array)
          return @dq.to_array(array)
        end
        
        typesig { [] }
        def iterator
          return Class.new(self.class::Iterator.class == Class ? self.class::Iterator : Object) do
            extend LocalClass
            include_class_members DelayedWorkQueue
            include class_self::Iterator if class_self::Iterator.class == Module
            
            attr_accessor :it
            alias_method :attr_it, :it
            undef_method :it
            alias_method :attr_it=, :it=
            undef_method :it=
            
            typesig { [] }
            define_method :has_next do
              return @it.has_next
            end
            
            typesig { [] }
            define_method :next_ do
              return @it.next_
            end
            
            typesig { [] }
            define_method :remove do
              @it.remove
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              @it = nil
              super(*args)
              @it = self.attr_dq.iterator
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        typesig { [] }
        def initialize
          @dq = nil
          super()
          @dq = self.class::DelayQueue.new
        end
        
        private
        alias_method :initialize__delayed_work_queue, :initialize
      end }
    }
    
    private
    alias_method :initialize__scheduled_thread_pool_executor, :initialize
  end
  
end
