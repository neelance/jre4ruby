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
# This file is available under and governed by the GNU General Public
# License version 2 only, as published by the Free Software Foundation.
# However, the following notice accompanied the original version of this
# file:
# 
# Written by Doug Lea with assistance from members of JCP JSR-166
# Expert Group and released to the public domain, as explained at
# http://creativecommons.org/licenses/publicdomain
module Java::Util::Concurrent
  module ThreadPoolExecutorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util::Concurrent::Locks
      include ::Java::Util::Concurrent::Atomic
      include ::Java::Util
    }
  end
  
  # An {@link ExecutorService} that executes each submitted task using
  # one of possibly several pooled threads, normally configured
  # using {@link Executors} factory methods.
  # 
  # <p>Thread pools address two different problems: they usually
  # provide improved performance when executing large numbers of
  # asynchronous tasks, due to reduced per-task invocation overhead,
  # and they provide a means of bounding and managing the resources,
  # including threads, consumed when executing a collection of tasks.
  # Each {@code ThreadPoolExecutor} also maintains some basic
  # statistics, such as the number of completed tasks.
  # 
  # <p>To be useful across a wide range of contexts, this class
  # provides many adjustable parameters and extensibility
  # hooks. However, programmers are urged to use the more convenient
  # {@link Executors} factory methods {@link
  # Executors#newCachedThreadPool} (unbounded thread pool, with
  # automatic thread reclamation), {@link Executors#newFixedThreadPool}
  # (fixed size thread pool) and {@link
  # Executors#newSingleThreadExecutor} (single background thread), that
  # preconfigure settings for the most common usage
  # scenarios. Otherwise, use the following guide when manually
  # configuring and tuning this class:
  # 
  # <dl>
  # 
  # <dt>Core and maximum pool sizes</dt>
  # 
  # <dd>A {@code ThreadPoolExecutor} will automatically adjust the
  # pool size (see {@link #getPoolSize})
  # according to the bounds set by
  # corePoolSize (see {@link #getCorePoolSize}) and
  # maximumPoolSize (see {@link #getMaximumPoolSize}).
  # 
  # When a new task is submitted in method {@link #execute}, and fewer
  # than corePoolSize threads are running, a new thread is created to
  # handle the request, even if other worker threads are idle.  If
  # there are more than corePoolSize but less than maximumPoolSize
  # threads running, a new thread will be created only if the queue is
  # full.  By setting corePoolSize and maximumPoolSize the same, you
  # create a fixed-size thread pool. By setting maximumPoolSize to an
  # essentially unbounded value such as {@code Integer.MAX_VALUE}, you
  # allow the pool to accommodate an arbitrary number of concurrent
  # tasks. Most typically, core and maximum pool sizes are set only
  # upon construction, but they may also be changed dynamically using
  # {@link #setCorePoolSize} and {@link #setMaximumPoolSize}. </dd>
  # 
  # <dt>On-demand construction</dt>
  # 
  # <dd> By default, even core threads are initially created and
  # started only when new tasks arrive, but this can be overridden
  # dynamically using method {@link #prestartCoreThread} or {@link
  # #prestartAllCoreThreads}.  You probably want to prestart threads if
  # you construct the pool with a non-empty queue. </dd>
  # 
  # <dt>Creating new threads</dt>
  # 
  # <dd>New threads are created using a {@link ThreadFactory}.  If not
  # otherwise specified, a {@link Executors#defaultThreadFactory} is
  # used, that creates threads to all be in the same {@link
  # ThreadGroup} and with the same {@code NORM_PRIORITY} priority and
  # non-daemon status. By supplying a different ThreadFactory, you can
  # alter the thread's name, thread group, priority, daemon status,
  # etc. If a {@code ThreadFactory} fails to create a thread when asked
  # by returning null from {@code newThread}, the executor will
  # continue, but might not be able to execute any tasks. Threads
  # should possess the "modifyThread" {@code RuntimePermission}. If
  # worker threads or other threads using the pool do not possess this
  # permission, service may be degraded: configuration changes may not
  # take effect in a timely manner, and a shutdown pool may remain in a
  # state in which termination is possible but not completed.</dd>
  # 
  # <dt>Keep-alive times</dt>
  # 
  # <dd>If the pool currently has more than corePoolSize threads,
  # excess threads will be terminated if they have been idle for more
  # than the keepAliveTime (see {@link #getKeepAliveTime}). This
  # provides a means of reducing resource consumption when the pool is
  # not being actively used. If the pool becomes more active later, new
  # threads will be constructed. This parameter can also be changed
  # dynamically using method {@link #setKeepAliveTime}. Using a value
  # of {@code Long.MAX_VALUE} {@link TimeUnit#NANOSECONDS} effectively
  # disables idle threads from ever terminating prior to shut down. By
  # default, the keep-alive policy applies only when there are more
  # than corePoolSizeThreads. But method {@link
  # #allowCoreThreadTimeOut(boolean)} can be used to apply this
  # time-out policy to core threads as well, so long as the
  # keepAliveTime value is non-zero. </dd>
  # 
  # <dt>Queuing</dt>
  # 
  # <dd>Any {@link BlockingQueue} may be used to transfer and hold
  # submitted tasks.  The use of this queue interacts with pool sizing:
  # 
  # <ul>
  # 
  # <li> If fewer than corePoolSize threads are running, the Executor
  # always prefers adding a new thread
  # rather than queuing.</li>
  # 
  # <li> If corePoolSize or more threads are running, the Executor
  # always prefers queuing a request rather than adding a new
  # thread.</li>
  # 
  # <li> If a request cannot be queued, a new thread is created unless
  # this would exceed maximumPoolSize, in which case, the task will be
  # rejected.</li>
  # 
  # </ul>
  # 
  # There are three general strategies for queuing:
  # <ol>
  # 
  # <li> <em> Direct handoffs.</em> A good default choice for a work
  # queue is a {@link SynchronousQueue} that hands off tasks to threads
  # without otherwise holding them. Here, an attempt to queue a task
  # will fail if no threads are immediately available to run it, so a
  # new thread will be constructed. This policy avoids lockups when
  # handling sets of requests that might have internal dependencies.
  # Direct handoffs generally require unbounded maximumPoolSizes to
  # avoid rejection of new submitted tasks. This in turn admits the
  # possibility of unbounded thread growth when commands continue to
  # arrive on average faster than they can be processed.  </li>
  # 
  # <li><em> Unbounded queues.</em> Using an unbounded queue (for
  # example a {@link LinkedBlockingQueue} without a predefined
  # capacity) will cause new tasks to wait in the queue when all
  # corePoolSize threads are busy. Thus, no more than corePoolSize
  # threads will ever be created. (And the value of the maximumPoolSize
  # therefore doesn't have any effect.)  This may be appropriate when
  # each task is completely independent of others, so tasks cannot
  # affect each others execution; for example, in a web page server.
  # While this style of queuing can be useful in smoothing out
  # transient bursts of requests, it admits the possibility of
  # unbounded work queue growth when commands continue to arrive on
  # average faster than they can be processed.  </li>
  # 
  # <li><em>Bounded queues.</em> A bounded queue (for example, an
  # {@link ArrayBlockingQueue}) helps prevent resource exhaustion when
  # used with finite maximumPoolSizes, but can be more difficult to
  # tune and control.  Queue sizes and maximum pool sizes may be traded
  # off for each other: Using large queues and small pools minimizes
  # CPU usage, OS resources, and context-switching overhead, but can
  # lead to artificially low throughput.  If tasks frequently block (for
  # example if they are I/O bound), a system may be able to schedule
  # time for more threads than you otherwise allow. Use of small queues
  # generally requires larger pool sizes, which keeps CPUs busier but
  # may encounter unacceptable scheduling overhead, which also
  # decreases throughput.  </li>
  # 
  # </ol>
  # 
  # </dd>
  # 
  # <dt>Rejected tasks</dt>
  # 
  # <dd> New tasks submitted in method {@link #execute} will be
  # <em>rejected</em> when the Executor has been shut down, and also
  # when the Executor uses finite bounds for both maximum threads and
  # work queue capacity, and is saturated.  In either case, the {@code
  # execute} method invokes the {@link
  # RejectedExecutionHandler#rejectedExecution} method of its {@link
  # RejectedExecutionHandler}.  Four predefined handler policies are
  # provided:
  # 
  # <ol>
  # 
  # <li> In the default {@link ThreadPoolExecutor.AbortPolicy}, the
  # handler throws a runtime {@link RejectedExecutionException} upon
  # rejection. </li>
  # 
  # <li> In {@link ThreadPoolExecutor.CallerRunsPolicy}, the thread
  # that invokes {@code execute} itself runs the task. This provides a
  # simple feedback control mechanism that will slow down the rate that
  # new tasks are submitted. </li>
  # 
  # <li> In {@link ThreadPoolExecutor.DiscardPolicy}, a task that
  # cannot be executed is simply dropped.  </li>
  # 
  # <li>In {@link ThreadPoolExecutor.DiscardOldestPolicy}, if the
  # executor is not shut down, the task at the head of the work queue
  # is dropped, and then execution is retried (which can fail again,
  # causing this to be repeated.) </li>
  # 
  # </ol>
  # 
  # It is possible to define and use other kinds of {@link
  # RejectedExecutionHandler} classes. Doing so requires some care
  # especially when policies are designed to work only under particular
  # capacity or queuing policies. </dd>
  # 
  # <dt>Hook methods</dt>
  # 
  # <dd>This class provides {@code protected} overridable {@link
  # #beforeExecute} and {@link #afterExecute} methods that are called
  # before and after execution of each task.  These can be used to
  # manipulate the execution environment; for example, reinitializing
  # ThreadLocals, gathering statistics, or adding log
  # entries. Additionally, method {@link #terminated} can be overridden
  # to perform any special processing that needs to be done once the
  # Executor has fully terminated.
  # 
  # <p>If hook or callback methods throw exceptions, internal worker
  # threads may in turn fail and abruptly terminate.</dd>
  # 
  # <dt>Queue maintenance</dt>
  # 
  # <dd> Method {@link #getQueue} allows access to the work queue for
  # purposes of monitoring and debugging.  Use of this method for any
  # other purpose is strongly discouraged.  Two supplied methods,
  # {@link #remove} and {@link #purge} are available to assist in
  # storage reclamation when large numbers of queued tasks become
  # cancelled.</dd>
  # 
  # <dt>Finalization</dt>
  # 
  # <dd> A pool that is no longer referenced in a program <em>AND</em>
  # has no remaining threads will be {@code shutdown} automatically. If
  # you would like to ensure that unreferenced pools are reclaimed even
  # if users forget to call {@link #shutdown}, then you must arrange
  # that unused threads eventually die, by setting appropriate
  # keep-alive times, using a lower bound of zero core threads and/or
  # setting {@link #allowCoreThreadTimeOut(boolean)}.  </dd>
  # 
  # </dl>
  # 
  # <p> <b>Extension example</b>. Most extensions of this class
  # override one or more of the protected hook methods. For example,
  # here is a subclass that adds a simple pause/resume feature:
  # 
  #  <pre> {@code
  # class PausableThreadPoolExecutor extends ThreadPoolExecutor {
  #   private boolean isPaused;
  #   private ReentrantLock pauseLock = new ReentrantLock();
  #   private Condition unpaused = pauseLock.newCondition();
  # 
  #   public PausableThreadPoolExecutor(...) { super(...); }
  # 
  #   protected void beforeExecute(Thread t, Runnable r) {
  #     super.beforeExecute(t, r);
  #     pauseLock.lock();
  #     try {
  #       while (isPaused) unpaused.await();
  #     } catch (InterruptedException ie) {
  #       t.interrupt();
  #     } finally {
  #       pauseLock.unlock();
  #     }
  #   }
  # 
  #   public void pause() {
  #     pauseLock.lock();
  #     try {
  #       isPaused = true;
  #     } finally {
  #       pauseLock.unlock();
  #     }
  #   }
  # 
  #   public void resume() {
  #     pauseLock.lock();
  #     try {
  #       isPaused = false;
  #       unpaused.signalAll();
  #     } finally {
  #       pauseLock.unlock();
  #     }
  #   }
  # }}</pre>
  # 
  # @since 1.5
  # @author Doug Lea
  class ThreadPoolExecutor < ThreadPoolExecutorImports.const_get :AbstractExecutorService
    include_class_members ThreadPoolExecutorImports
    
    # The main pool control state, ctl, is an atomic integer packing
    # two conceptual fields
    #   workerCount, indicating the effective number of threads
    #   runState,    indicating whether running, shutting down etc
    # 
    # In order to pack them into one int, we limit workerCount to
    # (2^29)-1 (about 500 million) threads rather than (2^31)-1 (2
    # billion) otherwise representable. If this is ever an issue in
    # the future, the variable can be changed to be an AtomicLong,
    # and the shift/mask constants below adjusted. But until the need
    # arises, this code is a bit faster and simpler using an int.
    # 
    # The workerCount is the number of workers that have been
    # permitted to start and not permitted to stop.  The value may be
    # transiently different from the actual number of live threads,
    # for example when a ThreadFactory fails to create a thread when
    # asked, and when exiting threads are still performing
    # bookkeeping before terminating. The user-visible pool size is
    # reported as the current size of the workers set.
    # 
    # The runState provides the main lifecyle control, taking on values:
    # 
    #   RUNNING:  Accept new tasks and process queued tasks
    #   SHUTDOWN: Don't accept new tasks, but process queued tasks
    #   STOP:     Don't accept new tasks, don't process queued tasks,
    #             and interrupt in-progress tasks
    #   TIDYING:  All tasks have terminated, workerCount is zero,
    #             the thread transitioning to state TIDYING
    #             will run the terminated() hook method
    #   TERMINATED: terminated() has completed
    # 
    # The numerical order among these values matters, to allow
    # ordered comparisons. The runState monotonically increases over
    # time, but need not hit each state. The transitions are:
    # 
    # RUNNING -> SHUTDOWN
    #    On invocation of shutdown(), perhaps implicitly in finalize()
    # (RUNNING or SHUTDOWN) -> STOP
    #    On invocation of shutdownNow()
    # SHUTDOWN -> TIDYING
    #    When both queue and pool are empty
    # STOP -> TIDYING
    #    When pool is empty
    # TIDYING -> TERMINATED
    #    When the terminated() hook method has completed
    # 
    # Threads waiting in awaitTermination() will return when the
    # state reaches TERMINATED.
    # 
    # Detecting the transition from SHUTDOWN to TIDYING is less
    # straightforward than you'd like because the queue may become
    # empty after non-empty and vice versa during SHUTDOWN state, but
    # we can only terminate if, after seeing that it is empty, we see
    # that workerCount is 0 (which sometimes entails a recheck -- see
    # below).
    attr_accessor :ctl
    alias_method :attr_ctl, :ctl
    undef_method :ctl
    alias_method :attr_ctl=, :ctl=
    undef_method :ctl=
    
    class_module.module_eval {
      const_set_lazy(:COUNT_BITS) { JavaInteger::SIZE - 3 }
      const_attr_reader  :COUNT_BITS
      
      const_set_lazy(:CAPACITY) { (1 << COUNT_BITS) - 1 }
      const_attr_reader  :CAPACITY
      
      # runState is stored in the high-order bits
      const_set_lazy(:RUNNING) { -1 << COUNT_BITS }
      const_attr_reader  :RUNNING
      
      const_set_lazy(:SHUTDOWN) { 0 << COUNT_BITS }
      const_attr_reader  :SHUTDOWN
      
      const_set_lazy(:STOP) { 1 << COUNT_BITS }
      const_attr_reader  :STOP
      
      const_set_lazy(:TIDYING) { 2 << COUNT_BITS }
      const_attr_reader  :TIDYING
      
      const_set_lazy(:TERMINATED) { 3 << COUNT_BITS }
      const_attr_reader  :TERMINATED
      
      typesig { [::Java::Int] }
      # Packing and unpacking ctl
      def run_state_of(c)
        return c & ~CAPACITY
      end
      
      typesig { [::Java::Int] }
      def worker_count_of(c)
        return c & CAPACITY
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      def ctl_of(rs, wc)
        return rs | wc
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Bit field accessors that don't require unpacking ctl.
      # These depend on the bit layout and on workerCount being never negative.
      def run_state_less_than(c, s)
        return c < s
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      def run_state_at_least(c, s)
        return c >= s
      end
      
      typesig { [::Java::Int] }
      def is_running(c)
        return c < SHUTDOWN
      end
    }
    
    typesig { [::Java::Int] }
    # Attempt to CAS-increment the workerCount field of ctl.
    def compare_and_increment_worker_count(expect)
      return @ctl.compare_and_set(expect, expect + 1)
    end
    
    typesig { [::Java::Int] }
    # Attempt to CAS-decrement the workerCount field of ctl.
    def compare_and_decrement_worker_count(expect)
      return @ctl.compare_and_set(expect, expect - 1)
    end
    
    typesig { [] }
    # Decrements the workerCount field of ctl. This is called only on
    # abrupt termination of a thread (see processWorkerExit). Other
    # decrements are performed within getTask.
    def decrement_worker_count
      begin
      end while (!compare_and_decrement_worker_count(@ctl.get))
    end
    
    # The queue used for holding tasks and handing off to worker
    # threads.  We do not require that workQueue.poll() returning
    # null necessarily means that workQueue.isEmpty(), so rely
    # solely on isEmpty to see if the queue is empty (which we must
    # do for example when deciding whether to transition from
    # SHUTDOWN to TIDYING).  This accommodates special-purpose
    # queues such as DelayQueues for which poll() is allowed to
    # return null even if it may later return non-null when delays
    # expire.
    attr_accessor :work_queue
    alias_method :attr_work_queue, :work_queue
    undef_method :work_queue
    alias_method :attr_work_queue=, :work_queue=
    undef_method :work_queue=
    
    # Lock held on access to workers set and related bookkeeping.
    # While we could use a concurrent set of some sort, it turns out
    # to be generally preferable to use a lock. Among the reasons is
    # that this serializes interruptIdleWorkers, which avoids
    # unnecessary interrupt storms, especially during shutdown.
    # Otherwise exiting threads would concurrently interrupt those
    # that have not yet interrupted. It also simplifies some of the
    # associated statistics bookkeeping of largestPoolSize etc. We
    # also hold mainLock on shutdown and shutdownNow, for the sake of
    # ensuring workers set is stable while separately checking
    # permission to interrupt and actually interrupting.
    attr_accessor :main_lock
    alias_method :attr_main_lock, :main_lock
    undef_method :main_lock
    alias_method :attr_main_lock=, :main_lock=
    undef_method :main_lock=
    
    # Set containing all worker threads in pool. Accessed only when
    # holding mainLock.
    attr_accessor :workers
    alias_method :attr_workers, :workers
    undef_method :workers
    alias_method :attr_workers=, :workers=
    undef_method :workers=
    
    # Wait condition to support awaitTermination
    attr_accessor :termination
    alias_method :attr_termination, :termination
    undef_method :termination
    alias_method :attr_termination=, :termination=
    undef_method :termination=
    
    # Tracks largest attained pool size. Accessed only under
    # mainLock.
    attr_accessor :largest_pool_size
    alias_method :attr_largest_pool_size, :largest_pool_size
    undef_method :largest_pool_size
    alias_method :attr_largest_pool_size=, :largest_pool_size=
    undef_method :largest_pool_size=
    
    # Counter for completed tasks. Updated only on termination of
    # worker threads. Accessed only under mainLock.
    attr_accessor :completed_task_count
    alias_method :attr_completed_task_count, :completed_task_count
    undef_method :completed_task_count
    alias_method :attr_completed_task_count=, :completed_task_count=
    undef_method :completed_task_count=
    
    # All user control parameters are declared as volatiles so that
    # ongoing actions are based on freshest values, but without need
    # for locking, since no internal invariants depend on them
    # changing synchronously with respect to other actions.
    # Factory for new threads. All threads are created using this
    # factory (via method addWorker).  All callers must be prepared
    # for addWorker to fail, which may reflect a system or user's
    # policy limiting the number of threads.  Even though it is not
    # treated as an error, failure to create threads may result in
    # new tasks being rejected or existing ones remaining stuck in
    # the queue. On the other hand, no special precautions exist to
    # handle OutOfMemoryErrors that might be thrown while trying to
    # create threads, since there is generally no recourse from
    # within this class.
    attr_accessor :thread_factory
    alias_method :attr_thread_factory, :thread_factory
    undef_method :thread_factory
    alias_method :attr_thread_factory=, :thread_factory=
    undef_method :thread_factory=
    
    # Handler called when saturated or shutdown in execute.
    attr_accessor :handler
    alias_method :attr_handler, :handler
    undef_method :handler
    alias_method :attr_handler=, :handler=
    undef_method :handler=
    
    # Timeout in nanoseconds for idle threads waiting for work.
    # Threads use this timeout when there are more than corePoolSize
    # present or if allowCoreThreadTimeOut. Otherwise they wait
    # forever for new work.
    attr_accessor :keep_alive_time
    alias_method :attr_keep_alive_time, :keep_alive_time
    undef_method :keep_alive_time
    alias_method :attr_keep_alive_time=, :keep_alive_time=
    undef_method :keep_alive_time=
    
    # If false (default), core threads stay alive even when idle.
    # If true, core threads use keepAliveTime to time out waiting
    # for work.
    attr_accessor :allow_core_thread_time_out
    alias_method :attr_allow_core_thread_time_out, :allow_core_thread_time_out
    undef_method :allow_core_thread_time_out
    alias_method :attr_allow_core_thread_time_out=, :allow_core_thread_time_out=
    undef_method :allow_core_thread_time_out=
    
    # Core pool size is the minimum number of workers to keep alive
    # (and not allow to time out etc) unless allowCoreThreadTimeOut
    # is set, in which case the minimum is zero.
    attr_accessor :core_pool_size
    alias_method :attr_core_pool_size, :core_pool_size
    undef_method :core_pool_size
    alias_method :attr_core_pool_size=, :core_pool_size=
    undef_method :core_pool_size=
    
    # Maximum pool size. Note that the actual maximum is internally
    # bounded by CAPACITY.
    attr_accessor :maximum_pool_size
    alias_method :attr_maximum_pool_size, :maximum_pool_size
    undef_method :maximum_pool_size
    alias_method :attr_maximum_pool_size=, :maximum_pool_size=
    undef_method :maximum_pool_size=
    
    class_module.module_eval {
      # The default rejected execution handler
      const_set_lazy(:DefaultHandler) { AbortPolicy.new }
      const_attr_reader  :DefaultHandler
      
      # Permission required for callers of shutdown and shutdownNow.
      # We additionally require (see checkShutdownAccess) that callers
      # have permission to actually interrupt threads in the worker set
      # (as governed by Thread.interrupt, which relies on
      # ThreadGroup.checkAccess, which in turn relies on
      # SecurityManager.checkAccess). Shutdowns are attempted only if
      # these checks pass.
      # 
      # All actual invocations of Thread.interrupt (see
      # interruptIdleWorkers and interruptWorkers) ignore
      # SecurityExceptions, meaning that the attempted interrupts
      # silently fail. In the case of shutdown, they should not fail
      # unless the SecurityManager has inconsistent policies, sometimes
      # allowing access to a thread and sometimes not. In such cases,
      # failure to actually interrupt threads may disable or delay full
      # termination. Other uses of interruptIdleWorkers are advisory,
      # and failure to actually interrupt will merely delay response to
      # configuration changes so is not handled exceptionally.
      const_set_lazy(:ShutdownPerm) { RuntimePermission.new("modifyThread") }
      const_attr_reader  :ShutdownPerm
      
      # Class Worker mainly maintains interrupt control state for
      # threads running tasks, along with other minor bookkeeping.
      # This class opportunistically extends AbstractQueuedSynchronizer
      # to simplify acquiring and releasing a lock surrounding each
      # task execution.  This protects against interrupts that are
      # intended to wake up a worker thread waiting for a task from
      # instead interrupting a task being run.  We implement a simple
      # non-reentrant mutual exclusion lock rather than use ReentrantLock
      # because we do not want worker tasks to be able to reacquire the
      # lock when they invoke pool control methods like setCorePoolSize.
      const_set_lazy(:Worker) { Class.new(AbstractQueuedSynchronizer) do
        local_class_in ThreadPoolExecutor
        include_class_members ThreadPoolExecutor
        overload_protected {
          include Runnable
        }
        
        class_module.module_eval {
          # This class will never be serialized, but we provide a
          # serialVersionUID to suppress a javac warning.
          const_set_lazy(:SerialVersionUID) { 6138294804551838833 }
          const_attr_reader  :SerialVersionUID
        }
        
        # Thread this worker is running in.  Null if factory fails.
        attr_accessor :thread
        alias_method :attr_thread, :thread
        undef_method :thread
        alias_method :attr_thread=, :thread=
        undef_method :thread=
        
        # Initial task to run.  Possibly null.
        attr_accessor :first_task
        alias_method :attr_first_task, :first_task
        undef_method :first_task
        alias_method :attr_first_task=, :first_task=
        undef_method :first_task=
        
        # Per-thread task counter
        attr_accessor :completed_tasks
        alias_method :attr_completed_tasks, :completed_tasks
        undef_method :completed_tasks
        alias_method :attr_completed_tasks=, :completed_tasks=
        undef_method :completed_tasks=
        
        typesig { [class_self::Runnable] }
        # Creates with given first task and thread from ThreadFactory.
        # @param firstTask the first task (null if none)
        def initialize(first_task)
          @thread = nil
          @first_task = nil
          @completed_tasks = 0
          super()
          @first_task = first_task
          @thread = get_thread_factory.new_thread(self)
        end
        
        typesig { [] }
        # Delegates main run loop to outer runWorker
        def run
          run_worker(self)
        end
        
        typesig { [] }
        # Lock methods
        # 
        # The value 0 represents the unlocked state.
        # The value 1 represents the locked state.
        def is_held_exclusively
          return (get_state).equal?(1)
        end
        
        typesig { [::Java::Int] }
        def try_acquire(unused)
          if (compare_and_set_state(0, 1))
            set_exclusive_owner_thread(JavaThread.current_thread)
            return true
          end
          return false
        end
        
        typesig { [::Java::Int] }
        def try_release(unused)
          set_exclusive_owner_thread(nil)
          set_state(0)
          return true
        end
        
        typesig { [] }
        def lock
          acquire(1)
        end
        
        typesig { [] }
        def try_lock
          return try_acquire(1)
        end
        
        typesig { [] }
        def unlock
          release(1)
        end
        
        typesig { [] }
        def is_locked
          return is_held_exclusively
        end
        
        private
        alias_method :initialize__worker, :initialize
      end }
    }
    
    typesig { [::Java::Int] }
    # Methods for setting control state
    # Transitions runState to given target, or leaves it alone if
    # already at least the given target.
    # 
    # @param targetState the desired state, either SHUTDOWN or STOP
    #        (but not TIDYING or TERMINATED -- use tryTerminate for that)
    def advance_run_state(target_state)
      loop do
        c = @ctl.get
        if (run_state_at_least(c, target_state) || @ctl.compare_and_set(c, ctl_of(target_state, worker_count_of(c))))
          break
        end
      end
    end
    
    typesig { [] }
    # Transitions to TERMINATED state if either (SHUTDOWN and pool
    # and queue empty) or (STOP and pool empty).  If otherwise
    # eligible to terminate but workerCount is nonzero, interrupts an
    # idle worker to ensure that shutdown signals propagate. This
    # method must be called following any action that might make
    # termination possible -- reducing worker count or removing tasks
    # from the queue during shutdown. The method is non-private to
    # allow access from ScheduledThreadPoolExecutor.
    def try_terminate
      loop do
        c = @ctl.get
        if (is_running(c) || run_state_at_least(c, TIDYING) || ((run_state_of(c)).equal?(SHUTDOWN) && !@work_queue.is_empty))
          return
        end
        if (!(worker_count_of(c)).equal?(0))
          # Eligible to terminate
          interrupt_idle_workers(ONLY_ONE)
          return
        end
        main_lock = @main_lock
        main_lock.lock
        begin
          if (@ctl.compare_and_set(c, ctl_of(TIDYING, 0)))
            begin
              terminated
            ensure
              @ctl.set(ctl_of(TERMINATED, 0))
              @termination.signal_all
            end
            return
          end
        ensure
          main_lock.unlock
        end
      end
    end
    
    typesig { [] }
    # Methods for controlling interrupts to worker threads.
    # If there is a security manager, makes sure caller has
    # permission to shut down threads in general (see shutdownPerm).
    # If this passes, additionally makes sure the caller is allowed
    # to interrupt each worker thread. This might not be true even if
    # first check passed, if the SecurityManager treats some threads
    # specially.
    def check_shutdown_access
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_permission(ShutdownPerm)
        main_lock = @main_lock
        main_lock.lock
        begin
          @workers.each do |w|
            security.check_access(w.attr_thread)
          end
        ensure
          main_lock.unlock
        end
      end
    end
    
    typesig { [] }
    # Interrupts all threads, even if active. Ignores SecurityExceptions
    # (in which case some threads may remain uninterrupted).
    def interrupt_workers
      main_lock = @main_lock
      main_lock.lock
      begin
        @workers.each do |w|
          begin
            w.attr_thread.interrupt
          rescue SecurityException => ignore
          end
        end
      ensure
        main_lock.unlock
      end
    end
    
    typesig { [::Java::Boolean] }
    # Interrupts threads that might be waiting for tasks (as
    # indicated by not being locked) so they can check for
    # termination or configuration changes. Ignores
    # SecurityExceptions (in which case some threads may remain
    # uninterrupted).
    # 
    # @param onlyOne If true, interrupt at most one worker. This is
    # called only from tryTerminate when termination is otherwise
    # enabled but there are still other workers.  In this case, at
    # most one waiting worker is interrupted to propagate shutdown
    # signals in case all threads are currently waiting.
    # Interrupting any arbitrary thread ensures that newly arriving
    # workers since shutdown began will also eventually exit.
    # To guarantee eventual termination, it suffices to always
    # interrupt only one idle worker, but shutdown() interrupts all
    # idle workers so that redundant workers exit promptly, not
    # waiting for a straggler task to finish.
    def interrupt_idle_workers(only_one)
      main_lock = @main_lock
      main_lock.lock
      begin
        @workers.each do |w|
          t = w.attr_thread
          if (!t.is_interrupted && w.try_lock)
            begin
              t.interrupt
            rescue SecurityException => ignore
            ensure
              w.unlock
            end
          end
          if (only_one)
            break
          end
        end
      ensure
        main_lock.unlock
      end
    end
    
    typesig { [] }
    # Common form of interruptIdleWorkers, to avoid having to
    # remember what the boolean argument means.
    def interrupt_idle_workers
      interrupt_idle_workers(false)
    end
    
    class_module.module_eval {
      const_set_lazy(:ONLY_ONE) { true }
      const_attr_reader  :ONLY_ONE
    }
    
    typesig { [] }
    # Ensures that unless the pool is stopping, the current thread
    # does not have its interrupt set. This requires a double-check
    # of state in case the interrupt was cleared concurrently with a
    # shutdownNow -- if so, the interrupt is re-enabled.
    def clear_interrupts_for_task_run
      if (run_state_less_than(@ctl.get, STOP) && JavaThread.interrupted && run_state_at_least(@ctl.get, STOP))
        JavaThread.current_thread.interrupt
      end
    end
    
    typesig { [Runnable] }
    # Misc utilities, most of which are also exported to
    # ScheduledThreadPoolExecutor
    # Invokes the rejected execution handler for the given command.
    # Package-protected for use by ScheduledThreadPoolExecutor.
    def reject(command)
      @handler.rejected_execution(command, self)
    end
    
    typesig { [] }
    # Performs any further cleanup following run state transition on
    # invocation of shutdown.  A no-op here, but used by
    # ScheduledThreadPoolExecutor to cancel delayed tasks.
    def on_shutdown
    end
    
    typesig { [::Java::Boolean] }
    # State check needed by ScheduledThreadPoolExecutor to
    # enable running tasks during shutdown.
    # 
    # @param shutdownOK true if should return true if SHUTDOWN
    def is_running_or_shutdown(shutdown_ok)
      rs = run_state_of(@ctl.get)
      return (rs).equal?(RUNNING) || ((rs).equal?(SHUTDOWN) && shutdown_ok)
    end
    
    typesig { [] }
    # Drains the task queue into a new list, normally using
    # drainTo. But if the queue is a DelayQueue or any other kind of
    # queue for which poll or drainTo may fail to remove some
    # elements, it deletes them one by one.
    def drain_queue
      q = @work_queue
      task_list = ArrayList.new
      q.drain_to(task_list)
      if (!q.is_empty)
        q.to_array(Array.typed(Runnable).new(0) { nil }).each do |r|
          if (q.remove(r))
            task_list.add(r)
          end
        end
      end
      return task_list
    end
    
    typesig { [Runnable, ::Java::Boolean] }
    # Methods for creating, running and cleaning up after workers
    # Checks if a new worker can be added with respect to current
    # pool state and the given bound (either core or maximum). If so,
    # the worker count is adjusted accordingly, and, if possible, a
    # new worker is created and started running firstTask as its
    # first task. This method returns false if the pool is stopped or
    # eligible to shut down. It also returns false if the thread
    # factory fails to create a thread when asked, which requires a
    # backout of workerCount, and a recheck for termination, in case
    # the existence of this worker was holding up termination.
    # 
    # @param firstTask the task the new thread should run first (or
    # null if none). Workers are created with an initial first task
    # (in method execute()) to bypass queuing when there are fewer
    # than corePoolSize threads (in which case we always start one),
    # or when the queue is full (in which case we must bypass queue).
    # Initially idle threads are usually created via
    # prestartCoreThread or to replace other dying workers.
    # 
    # @param core if true use corePoolSize as bound, else
    # maximumPoolSize. (A boolean indicator is used here rather than a
    # value to ensure reads of fresh values after checking other pool
    # state).
    # @return true if successful
    def add_worker(first_task, core)
      catch(:break_retry) do
        loop do
          catch(:next_retry) do
            c = @ctl.get
            rs = run_state_of(c)
            # Check if queue empty only if necessary.
            if (rs >= SHUTDOWN && !((rs).equal?(SHUTDOWN) && (first_task).nil? && !@work_queue.is_empty))
              return false
            end
            loop do
              wc = worker_count_of(c)
              if (wc >= CAPACITY || wc >= (core ? @core_pool_size : @maximum_pool_size))
                return false
              end
              if (compare_and_increment_worker_count(c))
                throw :break_retry, :thrown
              end
              c = @ctl.get # Re-read ctl
              if (!(run_state_of(c)).equal?(rs))
                throw :next_retry, :thrown
              end
            end
          end
        end
      end
      w = Worker.new_local(self, first_task)
      t = w.attr_thread
      main_lock = @main_lock
      main_lock.lock
      begin
        # Recheck while holding lock.
        # Back out on ThreadFactory failure or if
        # shut down before lock acquired.
        c = @ctl.get
        rs = run_state_of(c)
        if ((t).nil? || (rs >= SHUTDOWN && !((rs).equal?(SHUTDOWN) && (first_task).nil?)))
          decrement_worker_count
          try_terminate
          return false
        end
        @workers.add(w)
        s = @workers.size
        if (s > @largest_pool_size)
          @largest_pool_size = s
        end
      ensure
        main_lock.unlock
      end
      t.start
      # It is possible (but unlikely) for a thread to have been
      # added to workers, but not yet started, during transition to
      # STOP, which could result in a rare missed interrupt,
      # because Thread.interrupt is not guaranteed to have any effect
      # on a non-yet-started Thread (see Thread#interrupt).
      if ((run_state_of(@ctl.get)).equal?(STOP) && !t.is_interrupted)
        t.interrupt
      end
      return true
    end
    
    typesig { [Worker, ::Java::Boolean] }
    # Performs cleanup and bookkeeping for a dying worker. Called
    # only from worker threads. Unless completedAbruptly is set,
    # assumes that workerCount has already been adjusted to account
    # for exit.  This method removes thread from worker set, and
    # possibly terminates the pool or replaces the worker if either
    # it exited due to user task exception or if fewer than
    # corePoolSize workers are running or queue is non-empty but
    # there are no workers.
    # 
    # @param w the worker
    # @param completedAbruptly if the worker died due to user exception
    def process_worker_exit(w, completed_abruptly)
      if (completed_abruptly)
        # If abrupt, then workerCount wasn't adjusted
        decrement_worker_count
      end
      main_lock = @main_lock
      main_lock.lock
      begin
        @completed_task_count += w.attr_completed_tasks
        @workers.remove(w)
      ensure
        main_lock.unlock
      end
      try_terminate
      c = @ctl.get
      if (run_state_less_than(c, STOP))
        if (!completed_abruptly)
          min = @allow_core_thread_time_out ? 0 : @core_pool_size
          if ((min).equal?(0) && !@work_queue.is_empty)
            min = 1
          end
          if (worker_count_of(c) >= min)
            return
          end # replacement not needed
        end
        add_worker(nil, false)
      end
    end
    
    typesig { [] }
    # Performs blocking or timed wait for a task, depending on
    # current configuration settings, or returns null if this worker
    # must exit because of any of:
    # 1. There are more than maximumPoolSize workers (due to
    #    a call to setMaximumPoolSize).
    # 2. The pool is stopped.
    # 3. The pool is shutdown and the queue is empty.
    # 4. This worker timed out waiting for a task, and timed-out
    #    workers are subject to termination (that is,
    #    {@code allowCoreThreadTimeOut || workerCount > corePoolSize})
    #    both before and after the timed wait.
    # 
    # @return task, or null if the worker must exit, in which case
    #         workerCount is decremented
    def get_task
      timed_out = false # Did the last poll() time out?
      loop do
        catch(:next_retry) do
          c = @ctl.get
          rs = run_state_of(c)
          # Check if queue empty only if necessary.
          if (rs >= SHUTDOWN && (rs >= STOP || @work_queue.is_empty))
            decrement_worker_count
            return nil
          end
          timed = false # Are workers subject to culling?
          loop do
            wc = worker_count_of(c)
            timed = @allow_core_thread_time_out || wc > @core_pool_size
            if (wc <= @maximum_pool_size && !(timed_out && timed))
              break
            end
            if (compare_and_decrement_worker_count(c))
              return nil
            end
            c = @ctl.get # Re-read ctl
            if (!(run_state_of(c)).equal?(rs))
              throw :next_retry, :thrown
            end
          end
          begin
            r = timed ? @work_queue.poll(@keep_alive_time, TimeUnit::NANOSECONDS) : @work_queue.take
            if (!(r).nil?)
              return r
            end
            timed_out = true
          rescue InterruptedException => retry_
            timed_out = false
          end
        end
      end
    end
    
    typesig { [Worker] }
    # Main worker run loop.  Repeatedly gets tasks from queue and
    # executes them, while coping with a number of issues:
    # 
    # 1. We may start out with an initial task, in which case we
    # don't need to get the first one. Otherwise, as long as pool is
    # running, we get tasks from getTask. If it returns null then the
    # worker exits due to changed pool state or configuration
    # parameters.  Other exits result from exception throws in
    # external code, in which case completedAbruptly holds, which
    # usually leads processWorkerExit to replace this thread.
    # 
    # 2. Before running any task, the lock is acquired to prevent
    # other pool interrupts while the task is executing, and
    # clearInterruptsForTaskRun called to ensure that unless pool is
    # stopping, this thread does not have its interrupt set.
    # 
    # 3. Each task run is preceded by a call to beforeExecute, which
    # might throw an exception, in which case we cause thread to die
    # (breaking loop with completedAbruptly true) without processing
    # the task.
    # 
    # 4. Assuming beforeExecute completes normally, we run the task,
    # gathering any of its thrown exceptions to send to
    # afterExecute. We separately handle RuntimeException, Error
    # (both of which the specs guarantee that we trap) and arbitrary
    # Throwables.  Because we cannot rethrow Throwables within
    # Runnable.run, we wrap them within Errors on the way out (to the
    # thread's UncaughtExceptionHandler).  Any thrown exception also
    # conservatively causes thread to die.
    # 
    # 5. After task.run completes, we call afterExecute, which may
    # also throw an exception, which will also cause thread to
    # die. According to JLS Sec 14.20, this exception is the one that
    # will be in effect even if task.run throws.
    # 
    # The net effect of the exception mechanics is that afterExecute
    # and the thread's UncaughtExceptionHandler have as accurate
    # information as we can provide about any problems encountered by
    # user code.
    # 
    # @param w the worker
    def run_worker(w)
      task = w.attr_first_task
      w.attr_first_task = nil
      completed_abruptly = true
      begin
        while (!(task).nil? || !((task = get_task)).nil?)
          w.lock
          clear_interrupts_for_task_run
          begin
            before_execute(w.attr_thread, task)
            thrown = nil
            begin
              task.run
            rescue RuntimeException => x
              thrown = x
              raise x
            rescue JavaError => x
              thrown = x
              raise x
            rescue JavaThrowable => x
              thrown = x
              raise JavaError.new(x)
            ensure
              after_execute(task, thrown)
            end
          ensure
            task = nil
            w.attr_completed_tasks += 1
            w.unlock
          end
        end
        completed_abruptly = false
      ensure
        process_worker_exit(w, completed_abruptly)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Long, TimeUnit, BlockingQueue] }
    # Public constructors and methods
    # Creates a new {@code ThreadPoolExecutor} with the given initial
    # parameters and default thread factory and rejected execution handler.
    # It may be more convenient to use one of the {@link Executors} factory
    # methods instead of this general purpose constructor.
    # 
    # @param corePoolSize the number of threads to keep in the pool, even
    #        if they are idle, unless {@code allowCoreThreadTimeOut} is set
    # @param maximumPoolSize the maximum number of threads to allow in the
    #        pool
    # @param keepAliveTime when the number of threads is greater than
    #        the core, this is the maximum time that excess idle threads
    #        will wait for new tasks before terminating.
    # @param unit the time unit for the {@code keepAliveTime} argument
    # @param workQueue the queue to use for holding tasks before they are
    #        executed.  This queue will hold only the {@code Runnable}
    #        tasks submitted by the {@code execute} method.
    # @throws IllegalArgumentException if one of the following holds:<br>
    #         {@code corePoolSize < 0}<br>
    #         {@code keepAliveTime < 0}<br>
    #         {@code maximumPoolSize <= 0}<br>
    #         {@code maximumPoolSize < corePoolSize}
    # @throws NullPointerException if {@code workQueue} is null
    def initialize(core_pool_size, maximum_pool_size, keep_alive_time, unit, work_queue)
      initialize__thread_pool_executor(core_pool_size, maximum_pool_size, keep_alive_time, unit, work_queue, Executors.default_thread_factory, DefaultHandler)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Long, TimeUnit, BlockingQueue, ThreadFactory] }
    # Creates a new {@code ThreadPoolExecutor} with the given initial
    # parameters and default rejected execution handler.
    # 
    # @param corePoolSize the number of threads to keep in the pool, even
    #        if they are idle, unless {@code allowCoreThreadTimeOut} is set
    # @param maximumPoolSize the maximum number of threads to allow in the
    #        pool
    # @param keepAliveTime when the number of threads is greater than
    #        the core, this is the maximum time that excess idle threads
    #        will wait for new tasks before terminating.
    # @param unit the time unit for the {@code keepAliveTime} argument
    # @param workQueue the queue to use for holding tasks before they are
    #        executed.  This queue will hold only the {@code Runnable}
    #        tasks submitted by the {@code execute} method.
    # @param threadFactory the factory to use when the executor
    #        creates a new thread
    # @throws IllegalArgumentException if one of the following holds:<br>
    #         {@code corePoolSize < 0}<br>
    #         {@code keepAliveTime < 0}<br>
    #         {@code maximumPoolSize <= 0}<br>
    #         {@code maximumPoolSize < corePoolSize}
    # @throws NullPointerException if {@code workQueue}
    #         or {@code threadFactory} is null
    def initialize(core_pool_size, maximum_pool_size, keep_alive_time, unit, work_queue, thread_factory)
      initialize__thread_pool_executor(core_pool_size, maximum_pool_size, keep_alive_time, unit, work_queue, thread_factory, DefaultHandler)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Long, TimeUnit, BlockingQueue, RejectedExecutionHandler] }
    # Creates a new {@code ThreadPoolExecutor} with the given initial
    # parameters and default thread factory.
    # 
    # @param corePoolSize the number of threads to keep in the pool, even
    #        if they are idle, unless {@code allowCoreThreadTimeOut} is set
    # @param maximumPoolSize the maximum number of threads to allow in the
    #        pool
    # @param keepAliveTime when the number of threads is greater than
    #        the core, this is the maximum time that excess idle threads
    #        will wait for new tasks before terminating.
    # @param unit the time unit for the {@code keepAliveTime} argument
    # @param workQueue the queue to use for holding tasks before they are
    #        executed.  This queue will hold only the {@code Runnable}
    #        tasks submitted by the {@code execute} method.
    # @param handler the handler to use when execution is blocked
    #        because the thread bounds and queue capacities are reached
    # @throws IllegalArgumentException if one of the following holds:<br>
    #         {@code corePoolSize < 0}<br>
    #         {@code keepAliveTime < 0}<br>
    #         {@code maximumPoolSize <= 0}<br>
    #         {@code maximumPoolSize < corePoolSize}
    # @throws NullPointerException if {@code workQueue}
    #         or {@code handler} is null
    def initialize(core_pool_size, maximum_pool_size, keep_alive_time, unit, work_queue, handler)
      initialize__thread_pool_executor(core_pool_size, maximum_pool_size, keep_alive_time, unit, work_queue, Executors.default_thread_factory, handler)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Long, TimeUnit, BlockingQueue, ThreadFactory, RejectedExecutionHandler] }
    # Creates a new {@code ThreadPoolExecutor} with the given initial
    # parameters.
    # 
    # @param corePoolSize the number of threads to keep in the pool, even
    #        if they are idle, unless {@code allowCoreThreadTimeOut} is set
    # @param maximumPoolSize the maximum number of threads to allow in the
    #        pool
    # @param keepAliveTime when the number of threads is greater than
    #        the core, this is the maximum time that excess idle threads
    #        will wait for new tasks before terminating.
    # @param unit the time unit for the {@code keepAliveTime} argument
    # @param workQueue the queue to use for holding tasks before they are
    #        executed.  This queue will hold only the {@code Runnable}
    #        tasks submitted by the {@code execute} method.
    # @param threadFactory the factory to use when the executor
    #        creates a new thread
    # @param handler the handler to use when execution is blocked
    #        because the thread bounds and queue capacities are reached
    # @throws IllegalArgumentException if one of the following holds:<br>
    #         {@code corePoolSize < 0}<br>
    #         {@code keepAliveTime < 0}<br>
    #         {@code maximumPoolSize <= 0}<br>
    #         {@code maximumPoolSize < corePoolSize}
    # @throws NullPointerException if {@code workQueue}
    #         or {@code threadFactory} or {@code handler} is null
    def initialize(core_pool_size, maximum_pool_size, keep_alive_time, unit, work_queue, thread_factory, handler)
      @ctl = nil
      @work_queue = nil
      @main_lock = nil
      @workers = nil
      @termination = nil
      @largest_pool_size = 0
      @completed_task_count = 0
      @thread_factory = nil
      @handler = nil
      @keep_alive_time = 0
      @allow_core_thread_time_out = false
      @core_pool_size = 0
      @maximum_pool_size = 0
      super()
      @ctl = AtomicInteger.new(ctl_of(RUNNING, 0))
      @main_lock = ReentrantLock.new
      @workers = HashSet.new
      @termination = @main_lock.new_condition
      if (core_pool_size < 0 || maximum_pool_size <= 0 || maximum_pool_size < core_pool_size || keep_alive_time < 0)
        raise IllegalArgumentException.new
      end
      if ((work_queue).nil? || (thread_factory).nil? || (handler).nil?)
        raise NullPointerException.new
      end
      @core_pool_size = core_pool_size
      @maximum_pool_size = maximum_pool_size
      @work_queue = work_queue
      @keep_alive_time = unit.to_nanos(keep_alive_time)
      @thread_factory = thread_factory
      @handler = handler
    end
    
    typesig { [Runnable] }
    # Executes the given task sometime in the future.  The task
    # may execute in a new thread or in an existing pooled thread.
    # 
    # If the task cannot be submitted for execution, either because this
    # executor has been shutdown or because its capacity has been reached,
    # the task is handled by the current {@code RejectedExecutionHandler}.
    # 
    # @param command the task to execute
    # @throws RejectedExecutionException at discretion of
    #         {@code RejectedExecutionHandler}, if the task
    #         cannot be accepted for execution
    # @throws NullPointerException if {@code command} is null
    def execute(command)
      if ((command).nil?)
        raise NullPointerException.new
      end
      # Proceed in 3 steps:
      # 
      # 1. If fewer than corePoolSize threads are running, try to
      # start a new thread with the given command as its first
      # task.  The call to addWorker atomically checks runState and
      # workerCount, and so prevents false alarms that would add
      # threads when it shouldn't, by returning false.
      # 
      # 2. If a task can be successfully queued, then we still need
      # to double-check whether we should have added a thread
      # (because existing ones died since last checking) or that
      # the pool shut down since entry into this method. So we
      # recheck state and if necessary roll back the enqueuing if
      # stopped, or start a new thread if there are none.
      # 
      # 3. If we cannot queue task, then we try to add a new
      # thread.  If it fails, we know we are shut down or saturated
      # and so reject the task.
      c = @ctl.get
      if (worker_count_of(c) < @core_pool_size)
        if (add_worker(command, true))
          return
        end
        c = @ctl.get
      end
      if (is_running(c) && @work_queue.offer(command))
        recheck = @ctl.get
        if (!is_running(recheck) && remove(command))
          reject(command)
        else
          if ((worker_count_of(recheck)).equal?(0))
            add_worker(nil, false)
          end
        end
      else
        if (!add_worker(command, false))
          reject(command)
        end
      end
    end
    
    typesig { [] }
    # Initiates an orderly shutdown in which previously submitted
    # tasks are executed, but no new tasks will be accepted.
    # Invocation has no additional effect if already shut down.
    # 
    # @throws SecurityException {@inheritDoc}
    def shutdown
      main_lock = @main_lock
      main_lock.lock
      begin
        check_shutdown_access
        advance_run_state(SHUTDOWN)
        interrupt_idle_workers
        on_shutdown # hook for ScheduledThreadPoolExecutor
      ensure
        main_lock.unlock
      end
      try_terminate
    end
    
    typesig { [] }
    # Attempts to stop all actively executing tasks, halts the
    # processing of waiting tasks, and returns a list of the tasks
    # that were awaiting execution. These tasks are drained (removed)
    # from the task queue upon return from this method.
    # 
    # <p>There are no guarantees beyond best-effort attempts to stop
    # processing actively executing tasks.  This implementation
    # cancels tasks via {@link Thread#interrupt}, so any task that
    # fails to respond to interrupts may never terminate.
    # 
    # @throws SecurityException {@inheritDoc}
    def shutdown_now
      tasks = nil
      main_lock = @main_lock
      main_lock.lock
      begin
        check_shutdown_access
        advance_run_state(STOP)
        interrupt_workers
        tasks = drain_queue
      ensure
        main_lock.unlock
      end
      try_terminate
      return tasks
    end
    
    typesig { [] }
    def is_shutdown
      return !is_running(@ctl.get)
    end
    
    typesig { [] }
    # Returns true if this executor is in the process of terminating
    # after {@link #shutdown} or {@link #shutdownNow} but has not
    # completely terminated.  This method may be useful for
    # debugging. A return of {@code true} reported a sufficient
    # period after shutdown may indicate that submitted tasks have
    # ignored or suppressed interruption, causing this executor not
    # to properly terminate.
    # 
    # @return true if terminating but not yet terminated
    def is_terminating
      c = @ctl.get
      return !is_running(c) && run_state_less_than(c, TERMINATED)
    end
    
    typesig { [] }
    def is_terminated
      return run_state_at_least(@ctl.get, TERMINATED)
    end
    
    typesig { [::Java::Long, TimeUnit] }
    def await_termination(timeout, unit)
      nanos = unit.to_nanos(timeout)
      main_lock = @main_lock
      main_lock.lock
      begin
        loop do
          if (run_state_at_least(@ctl.get, TERMINATED))
            return true
          end
          if (nanos <= 0)
            return false
          end
          nanos = @termination.await_nanos(nanos)
        end
      ensure
        main_lock.unlock
      end
    end
    
    typesig { [] }
    # Invokes {@code shutdown} when this executor is no longer
    # referenced and it has no threads.
    def finalize
      shutdown
    end
    
    typesig { [ThreadFactory] }
    # Sets the thread factory used to create new threads.
    # 
    # @param threadFactory the new thread factory
    # @throws NullPointerException if threadFactory is null
    # @see #getThreadFactory
    def set_thread_factory(thread_factory)
      if ((thread_factory).nil?)
        raise NullPointerException.new
      end
      @thread_factory = thread_factory
    end
    
    typesig { [] }
    # Returns the thread factory used to create new threads.
    # 
    # @return the current thread factory
    # @see #setThreadFactory
    def get_thread_factory
      return @thread_factory
    end
    
    typesig { [RejectedExecutionHandler] }
    # Sets a new handler for unexecutable tasks.
    # 
    # @param handler the new handler
    # @throws NullPointerException if handler is null
    # @see #getRejectedExecutionHandler
    def set_rejected_execution_handler(handler)
      if ((handler).nil?)
        raise NullPointerException.new
      end
      @handler = handler
    end
    
    typesig { [] }
    # Returns the current handler for unexecutable tasks.
    # 
    # @return the current handler
    # @see #setRejectedExecutionHandler
    def get_rejected_execution_handler
      return @handler
    end
    
    typesig { [::Java::Int] }
    # Sets the core number of threads.  This overrides any value set
    # in the constructor.  If the new value is smaller than the
    # current value, excess existing threads will be terminated when
    # they next become idle.  If larger, new threads will, if needed,
    # be started to execute any queued tasks.
    # 
    # @param corePoolSize the new core size
    # @throws IllegalArgumentException if {@code corePoolSize < 0}
    # @see #getCorePoolSize
    def set_core_pool_size(core_pool_size)
      if (core_pool_size < 0)
        raise IllegalArgumentException.new
      end
      delta = core_pool_size - @core_pool_size
      @core_pool_size = core_pool_size
      if (worker_count_of(@ctl.get) > core_pool_size)
        interrupt_idle_workers
      else
        if (delta > 0)
          # We don't really know how many new threads are "needed".
          # As a heuristic, prestart enough new workers (up to new
          # core size) to handle the current number of tasks in
          # queue, but stop if queue becomes empty while doing so.
          k = Math.min(delta, @work_queue.size)
          while (((k -= 1) + 1) > 0 && add_worker(nil, true))
            if (@work_queue.is_empty)
              break
            end
          end
        end
      end
    end
    
    typesig { [] }
    # Returns the core number of threads.
    # 
    # @return the core number of threads
    # @see #setCorePoolSize
    def get_core_pool_size
      return @core_pool_size
    end
    
    typesig { [] }
    # Starts a core thread, causing it to idly wait for work. This
    # overrides the default policy of starting core threads only when
    # new tasks are executed. This method will return {@code false}
    # if all core threads have already been started.
    # 
    # @return {@code true} if a thread was started
    def prestart_core_thread
      return worker_count_of(@ctl.get) < @core_pool_size && add_worker(nil, true)
    end
    
    typesig { [] }
    # Starts all core threads, causing them to idly wait for work. This
    # overrides the default policy of starting core threads only when
    # new tasks are executed.
    # 
    # @return the number of threads started
    def prestart_all_core_threads
      n = 0
      while (add_worker(nil, true))
        (n += 1)
      end
      return n
    end
    
    typesig { [] }
    # Returns true if this pool allows core threads to time out and
    # terminate if no tasks arrive within the keepAlive time, being
    # replaced if needed when new tasks arrive. When true, the same
    # keep-alive policy applying to non-core threads applies also to
    # core threads. When false (the default), core threads are never
    # terminated due to lack of incoming tasks.
    # 
    # @return {@code true} if core threads are allowed to time out,
    #         else {@code false}
    # 
    # @since 1.6
    def allows_core_thread_time_out
      return @allow_core_thread_time_out
    end
    
    typesig { [::Java::Boolean] }
    # Sets the policy governing whether core threads may time out and
    # terminate if no tasks arrive within the keep-alive time, being
    # replaced if needed when new tasks arrive. When false, core
    # threads are never terminated due to lack of incoming
    # tasks. When true, the same keep-alive policy applying to
    # non-core threads applies also to core threads. To avoid
    # continual thread replacement, the keep-alive time must be
    # greater than zero when setting {@code true}. This method
    # should in general be called before the pool is actively used.
    # 
    # @param value {@code true} if should time out, else {@code false}
    # @throws IllegalArgumentException if value is {@code true}
    #         and the current keep-alive time is not greater than zero
    # 
    # @since 1.6
    def allow_core_thread_time_out(value)
      if (value && @keep_alive_time <= 0)
        raise IllegalArgumentException.new("Core threads must have nonzero keep alive times")
      end
      if (!(value).equal?(@allow_core_thread_time_out))
        @allow_core_thread_time_out = value
        if (value)
          interrupt_idle_workers
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the maximum allowed number of threads. This overrides any
    # value set in the constructor. If the new value is smaller than
    # the current value, excess existing threads will be
    # terminated when they next become idle.
    # 
    # @param maximumPoolSize the new maximum
    # @throws IllegalArgumentException if the new maximum is
    #         less than or equal to zero, or
    #         less than the {@linkplain #getCorePoolSize core pool size}
    # @see #getMaximumPoolSize
    def set_maximum_pool_size(maximum_pool_size)
      if (maximum_pool_size <= 0 || maximum_pool_size < @core_pool_size)
        raise IllegalArgumentException.new
      end
      @maximum_pool_size = maximum_pool_size
      if (worker_count_of(@ctl.get) > maximum_pool_size)
        interrupt_idle_workers
      end
    end
    
    typesig { [] }
    # Returns the maximum allowed number of threads.
    # 
    # @return the maximum allowed number of threads
    # @see #setMaximumPoolSize
    def get_maximum_pool_size
      return @maximum_pool_size
    end
    
    typesig { [::Java::Long, TimeUnit] }
    # Sets the time limit for which threads may remain idle before
    # being terminated.  If there are more than the core number of
    # threads currently in the pool, after waiting this amount of
    # time without processing a task, excess threads will be
    # terminated.  This overrides any value set in the constructor.
    # 
    # @param time the time to wait.  A time value of zero will cause
    #        excess threads to terminate immediately after executing tasks.
    # @param unit the time unit of the {@code time} argument
    # @throws IllegalArgumentException if {@code time} less than zero or
    #         if {@code time} is zero and {@code allowsCoreThreadTimeOut}
    # @see #getKeepAliveTime
    def set_keep_alive_time(time, unit)
      if (time < 0)
        raise IllegalArgumentException.new
      end
      if ((time).equal?(0) && allows_core_thread_time_out)
        raise IllegalArgumentException.new("Core threads must have nonzero keep alive times")
      end
      keep_alive_time = unit.to_nanos(time)
      delta = keep_alive_time - @keep_alive_time
      @keep_alive_time = keep_alive_time
      if (delta < 0)
        interrupt_idle_workers
      end
    end
    
    typesig { [TimeUnit] }
    # Returns the thread keep-alive time, which is the amount of time
    # that threads in excess of the core pool size may remain
    # idle before being terminated.
    # 
    # @param unit the desired time unit of the result
    # @return the time limit
    # @see #setKeepAliveTime
    def get_keep_alive_time(unit)
      return unit.convert(@keep_alive_time, TimeUnit::NANOSECONDS)
    end
    
    typesig { [] }
    # User-level queue utilities
    # Returns the task queue used by this executor. Access to the
    # task queue is intended primarily for debugging and monitoring.
    # This queue may be in active use.  Retrieving the task queue
    # does not prevent queued tasks from executing.
    # 
    # @return the task queue
    def get_queue
      return @work_queue
    end
    
    typesig { [Runnable] }
    # Removes this task from the executor's internal queue if it is
    # present, thus causing it not to be run if it has not already
    # started.
    # 
    # <p> This method may be useful as one part of a cancellation
    # scheme.  It may fail to remove tasks that have been converted
    # into other forms before being placed on the internal queue. For
    # example, a task entered using {@code submit} might be
    # converted into a form that maintains {@code Future} status.
    # However, in such cases, method {@link #purge} may be used to
    # remove those Futures that have been cancelled.
    # 
    # @param task the task to remove
    # @return true if the task was removed
    def remove(task)
      removed = @work_queue.remove(task)
      try_terminate # In case SHUTDOWN and now empty
      return removed
    end
    
    typesig { [] }
    # Tries to remove from the work queue all {@link Future}
    # tasks that have been cancelled. This method can be useful as a
    # storage reclamation operation, that has no other impact on
    # functionality. Cancelled tasks are never executed, but may
    # accumulate in work queues until worker threads can actively
    # remove them. Invoking this method instead tries to remove them now.
    # However, this method may fail to remove tasks in
    # the presence of interference by other threads.
    def purge
      q = @work_queue
      begin
        it = q.iterator
        while (it.has_next)
          r = it.next_
          if (r.is_a?(Future) && (r).is_cancelled)
            it.remove
          end
        end
      rescue ConcurrentModificationException => fall_through
        # Take slow path if we encounter interference during traversal.
        # Make copy for traversal and call remove for cancelled entries.
        # The slow path is more likely to be O(N*N).
        q.to_array.each do |r|
          if (r.is_a?(Future) && (r).is_cancelled)
            q.remove(r)
          end
        end
      end
      try_terminate # In case SHUTDOWN and now empty
    end
    
    typesig { [] }
    # Statistics
    # Returns the current number of threads in the pool.
    # 
    # @return the number of threads
    def get_pool_size
      main_lock = @main_lock
      main_lock.lock
      begin
        # Remove rare and surprising possibility of
        # isTerminated() && getPoolSize() > 0
        return run_state_at_least(@ctl.get, TIDYING) ? 0 : @workers.size
      ensure
        main_lock.unlock
      end
    end
    
    typesig { [] }
    # Returns the approximate number of threads that are actively
    # executing tasks.
    # 
    # @return the number of threads
    def get_active_count
      main_lock = @main_lock
      main_lock.lock
      begin
        n = 0
        @workers.each do |w|
          if (w.is_locked)
            (n += 1)
          end
        end
        return n
      ensure
        main_lock.unlock
      end
    end
    
    typesig { [] }
    # Returns the largest number of threads that have ever
    # simultaneously been in the pool.
    # 
    # @return the number of threads
    def get_largest_pool_size
      main_lock = @main_lock
      main_lock.lock
      begin
        return @largest_pool_size
      ensure
        main_lock.unlock
      end
    end
    
    typesig { [] }
    # Returns the approximate total number of tasks that have ever been
    # scheduled for execution. Because the states of tasks and
    # threads may change dynamically during computation, the returned
    # value is only an approximation.
    # 
    # @return the number of tasks
    def get_task_count
      main_lock = @main_lock
      main_lock.lock
      begin
        n = @completed_task_count
        @workers.each do |w|
          n += w.attr_completed_tasks
          if (w.is_locked)
            (n += 1)
          end
        end
        return n + @work_queue.size
      ensure
        main_lock.unlock
      end
    end
    
    typesig { [] }
    # Returns the approximate total number of tasks that have
    # completed execution. Because the states of tasks and threads
    # may change dynamically during computation, the returned value
    # is only an approximation, but one that does not ever decrease
    # across successive calls.
    # 
    # @return the number of tasks
    def get_completed_task_count
      main_lock = @main_lock
      main_lock.lock
      begin
        n = @completed_task_count
        @workers.each do |w|
          n += w.attr_completed_tasks
        end
        return n
      ensure
        main_lock.unlock
      end
    end
    
    typesig { [JavaThread, Runnable] }
    # Extension hooks
    # Method invoked prior to executing the given Runnable in the
    # given thread.  This method is invoked by thread {@code t} that
    # will execute task {@code r}, and may be used to re-initialize
    # ThreadLocals, or to perform logging.
    # 
    # <p>This implementation does nothing, but may be customized in
    # subclasses. Note: To properly nest multiple overridings, subclasses
    # should generally invoke {@code super.beforeExecute} at the end of
    # this method.
    # 
    # @param t the thread that will run task {@code r}
    # @param r the task that will be executed
    def before_execute(t, r)
    end
    
    typesig { [Runnable, JavaThrowable] }
    # Method invoked upon completion of execution of the given Runnable.
    # This method is invoked by the thread that executed the task. If
    # non-null, the Throwable is the uncaught {@code RuntimeException}
    # or {@code Error} that caused execution to terminate abruptly.
    # 
    # <p>This implementation does nothing, but may be customized in
    # subclasses. Note: To properly nest multiple overridings, subclasses
    # should generally invoke {@code super.afterExecute} at the
    # beginning of this method.
    # 
    # <p><b>Note:</b> When actions are enclosed in tasks (such as
    # {@link FutureTask}) either explicitly or via methods such as
    # {@code submit}, these task objects catch and maintain
    # computational exceptions, and so they do not cause abrupt
    # termination, and the internal exceptions are <em>not</em>
    # passed to this method. If you would like to trap both kinds of
    # failures in this method, you can further probe for such cases,
    # as in this sample subclass that prints either the direct cause
    # or the underlying exception if a task has been aborted:
    # 
    #  <pre> {@code
    # class ExtendedExecutor extends ThreadPoolExecutor {
    #   // ...
    #   protected void afterExecute(Runnable r, Throwable t) {
    #     super.afterExecute(r, t);
    #     if (t == null && r instanceof Future<?>) {
    #       try {
    #         Object result = ((Future<?>) r).get();
    #       } catch (CancellationException ce) {
    #           t = ce;
    #       } catch (ExecutionException ee) {
    #           t = ee.getCause();
    #       } catch (InterruptedException ie) {
    #           Thread.currentThread().interrupt(); // ignore/reset
    #       }
    #     }
    #     if (t != null)
    #       System.out.println(t);
    #   }
    # }}</pre>
    # 
    # @param r the runnable that has completed
    # @param t the exception that caused termination, or null if
    # execution completed normally
    def after_execute(r, t)
    end
    
    typesig { [] }
    # Method invoked when the Executor has terminated.  Default
    # implementation does nothing. Note: To properly nest multiple
    # overridings, subclasses should generally invoke
    # {@code super.terminated} within this method.
    def terminated
    end
    
    class_module.module_eval {
      # Predefined RejectedExecutionHandlers
      # A handler for rejected tasks that runs the rejected task
      # directly in the calling thread of the {@code execute} method,
      # unless the executor has been shut down, in which case the task
      # is discarded.
      const_set_lazy(:CallerRunsPolicy) { Class.new do
        include_class_members ThreadPoolExecutor
        include RejectedExecutionHandler
        
        typesig { [] }
        # Creates a {@code CallerRunsPolicy}.
        def initialize
        end
        
        typesig { [class_self::Runnable, class_self::ThreadPoolExecutor] }
        # Executes task r in the caller's thread, unless the executor
        # has been shut down, in which case the task is discarded.
        # 
        # @param r the runnable task requested to be executed
        # @param e the executor attempting to execute this task
        def rejected_execution(r, e)
          if (!e.is_shutdown)
            r.run
          end
        end
        
        private
        alias_method :initialize__caller_runs_policy, :initialize
      end }
      
      # A handler for rejected tasks that throws a
      # {@code RejectedExecutionException}.
      const_set_lazy(:AbortPolicy) { Class.new do
        include_class_members ThreadPoolExecutor
        include RejectedExecutionHandler
        
        typesig { [] }
        # Creates an {@code AbortPolicy}.
        def initialize
        end
        
        typesig { [class_self::Runnable, class_self::ThreadPoolExecutor] }
        # Always throws RejectedExecutionException.
        # 
        # @param r the runnable task requested to be executed
        # @param e the executor attempting to execute this task
        # @throws RejectedExecutionException always.
        def rejected_execution(r, e)
          raise self.class::RejectedExecutionException.new
        end
        
        private
        alias_method :initialize__abort_policy, :initialize
      end }
      
      # A handler for rejected tasks that silently discards the
      # rejected task.
      const_set_lazy(:DiscardPolicy) { Class.new do
        include_class_members ThreadPoolExecutor
        include RejectedExecutionHandler
        
        typesig { [] }
        # Creates a {@code DiscardPolicy}.
        def initialize
        end
        
        typesig { [class_self::Runnable, class_self::ThreadPoolExecutor] }
        # Does nothing, which has the effect of discarding task r.
        # 
        # @param r the runnable task requested to be executed
        # @param e the executor attempting to execute this task
        def rejected_execution(r, e)
        end
        
        private
        alias_method :initialize__discard_policy, :initialize
      end }
      
      # A handler for rejected tasks that discards the oldest unhandled
      # request and then retries {@code execute}, unless the executor
      # is shut down, in which case the task is discarded.
      const_set_lazy(:DiscardOldestPolicy) { Class.new do
        include_class_members ThreadPoolExecutor
        include RejectedExecutionHandler
        
        typesig { [] }
        # Creates a {@code DiscardOldestPolicy} for the given executor.
        def initialize
        end
        
        typesig { [class_self::Runnable, class_self::ThreadPoolExecutor] }
        # Obtains and ignores the next task that the executor
        # would otherwise execute, if one is immediately available,
        # and then retries execution of task r, unless the executor
        # is shut down, in which case task r is instead discarded.
        # 
        # @param r the runnable task requested to be executed
        # @param e the executor attempting to execute this task
        def rejected_execution(r, e)
          if (!e.is_shutdown)
            e.get_queue.poll
            e.execute(r)
          end
        end
        
        private
        alias_method :initialize__discard_oldest_policy, :initialize
      end }
    }
    
    private
    alias_method :initialize__thread_pool_executor, :initialize
  end
  
end
